/*
 * Utils.c - Some useful functions that doesn't change too much
 * Free software under GNU license, started on 11/11/2000
 * Written by T.Pierron, C.Guillaume.
 */

#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <dos/dos.h>
#include "Jed.h"
#include "JanoPrefs.h"
#include "ProtoTypes.h"
#include "Tabulators.h"

#define CATCOMP_NUMBERS
#include "Jed_Strings.h"

ULONG err_time = 0;

extern UBYTE Path[100];  /* In Prefs.c */

static struct FileRequester * fr = NULL;
static STRPTR Title = NULL;
static PREFS  oldprefs;
static UBYTE  TempPath[100];
static char   edit_file;
static char   buffer[ MAX(sizeof(Path),sizeof(prefs)) ];

static UBYTE  DefaultPath[] = "ENVARC:";

/* ASL load or save requester tags */
static ULONG tags[] =
{
	ASLFR_InitialLeftEdge, 50,
	ASLFR_InitialTopEdge,  50,
	ASLFR_InitialWidth,    320,
	ASLFR_InitialHeight,   256,
	ASLFR_Window,          NULL,
	ASLFR_Flags1,          0,
	ASLFR_SleepWindow,     TRUE,
	ASLFR_InitialDrawer,   NULL,
	ASLFR_InitialFile,     NULL,
	ASLFR_InitialPattern,  (ULONG)"#?",
	TAG_DONE
};

/*
 * Gory function that can emulate sprintf
 */
static STRPTR savea3;
static UWORD  max_buf;

#ifdef _AROS
#include <aros/asmcall.h>

AROS_UFH2(void, PutChProc,
    AROS_UFHA(UBYTE,    data, D0),
    AROS_UFHA(STRPTR *, p,   A3))
{
    AROS_USERFUNC_INIT

#elif defined( __GNUC__ )

void PutChProc( void )
{
	register UBYTE data __asm("d0");

#else

void __saveds __asm PutChProc(register __d0 UBYTE data, register __a3 STRPTR out)
{
#endif
	/* Can't use a3 ; compiler will restore register content on exit */
	if( max_buf > 0 )
		*savea3++ = data, max_buf--;
	else
		*savea3 = 0;

#ifdef _AROS
    AROS_USERFUNC_EXIT
#endif
}

/*** snprintf like routine ***/
UWORD my_snprintf( STRPTR buffer, UWORD max, STRPTR fmt, APTR args )
{
	savea3  = buffer;
	max_buf = max;
	RawDoFmt(fmt, args, (APTR) PutChProc, 0);

	return (UWORD) (savea3 - buffer);
}

/*** Measure the maximal length of a NULL-terminated array of string ***/
WORD meas_table( STRPTR * strings )
{
	extern struct RastPort RPT;
	register STRPTR * p;
	register WORD     maxlen,len;

	for(p=strings, maxlen=0; *p; p++)
		if(maxlen < (len=TextLength(&RPT,*p,strlen(*p)))) maxlen = len;

	return maxlen;
}

/*** Extract some information of a TextFont struct ***/
void font_info( STRPTR buf, struct TextFont * font )
{
	STRPTR name = font->tf_Message.mn_Node.ln_Name;
	UWORD  size = strlen(name) - 5;

	/* Fontname / Height */
	CopyMem(name, buf, size);
	my_snprintf( buf + size, 20 - size, "/%d", &font->tf_YSize );
}

/*** Same job with a (struct Screen *) ***/
void scr_info( STRPTR buf, WORD * whd )
{
	/* Width x Height x Depth */
	my_snprintf( buf, 20, "%dx%dx%d", whd );
}

/*** Try to load an already loaded font ***/
struct TextFont *get_old_font( STRPTR fmt )
{
	static UBYTE FontName[50];
	STRPTR p;
	for(p=fmt; *p && *p!='/'; p++);
	if(*p == '/')
	{
		struct TextAttr font;
		CopyMem(fmt,FontName,p-fmt); strcpy(FontName+(p-fmt),".font");
		font.ta_Name  = FontName;
		font.ta_YSize = atoi(p+1);
		font.ta_Style = FS_NORMAL;
		font.ta_Flags = FPF_DISKFONT;
		return (struct TextFont *)OpenDiskFont(&font);
	}
	return NULL;
}

/*** flush message port of window before to close it ***/
void safe_close_window( struct Window * wnd )
{
	extern struct IntuiMessage * msg;

	while( (msg = (APTR) GT_GetIMsg(wnd->UserPort)) )
		GT_ReplyIMsg( msg );

	if( Menu ) ClearMenuStrip(wnd);
	CloseWindow(wnd);
}

int count_gadget( struct Gadget * first )
{
	int nb;
	for( nb = 0; first; nb++, first = first->NextGadget );
	return nb;
}

/*** Save width and height of an ASL requester ***/
static void save_asl_dim( struct FileRequester * fr )
{
	tags[1] = fr->fr_LeftEdge;
	tags[3] = fr->fr_TopEdge;
	tags[5] = fr->fr_Width;
	tags[7] = fr->fr_Height;
}

static int alloc_and_show_asl( STRPTR path, ULONG type )
{
	STRPTR file = FilePart( path );
	UWORD  len  = file-path;

	if( len >= sizeof(TempPath) ) len = sizeof(TempPath)-1;
	if( file > path ) CopyMem( path, TempPath, len );
	TempPath[ len ] = 0;

	tags[9]  = (ULONG) Wnd;
	tags[11] = type;
	tags[17] = (ULONG) file;
	tags[15] = (ULONG) TempPath;
	if( fr == NULL )
	{
		fr = (APTR) AllocAslRequest( ASL_FileRequest, NULL );

		if( fr == NULL )
		{
			ThrowError( Wnd, ErrMsg(ERR_NOASLREQ) );
			return FALSE;
		}
	}
	return AslRequest(fr, (APTR) tags);
}

static void cat_path( STRPTR path, UWORD max, STRPTR drawer, STRPTR file )
{
	/* Useless strncpy() of this fucking C library */
	{
		register STRPTR src, dest;
		register UWORD  i;

		for( i = max-1, src = drawer, dest = path; i--; *dest++ = *src++ );
	}
	AddPart(path, file, max);
}

/*** Update all guis ***/
static void update_all_guis( Prefs new )
{
	extern struct TabHooks * hook, tab_hooks[3]; /* In JanoPrefs.c */

	struct TabHooks * list;

	foreach_tab( tab_hooks, list )
		if( list->update_gui )
			list->update_gui( list == hook ? Wnd : NULL, &oldprefs, new );
}


/*** Ask user for a new preference file to load ***/
void load_pref( Prefs prefs )
{
	/* Save old preferences */
	CopyMem(prefs, &oldprefs, sizeof(oldprefs));

	if( alloc_and_show_asl( DefaultPath, FILF_PATGAD ) )
	{
		save_asl_dim(fr);
		strcpy(TempPath, Path);
		cat_path(Path, sizeof(Path), fr->fr_Drawer, fr->fr_File);
		switch( (UBYTE) load_prefs(prefs, Path) )
		{
			case RETURN_OK:
				update_all_guis( prefs );
				SetWindowTitles(Wnd, Path, (STRPTR)-1);
				return;
			case ERROR_OBJECT_WRONG_TYPE:
				ThrowError(Wnd, ErrMsg(ERR_BADPREFSFILE)); break;
			default:
				ThrowDOSError(Wnd, Path);
		}
		/* Restore previous path */
		strcpy(Path, TempPath);
	}
}

/*** Ask user for a place to save the preference file ***/
void save_pref_as( Prefs prefs )
{
	if( alloc_and_show_asl( DefaultPath, FILF_SAVE | FILF_PATGAD ) )
	{
		save_asl_dim(fr);
		cat_path(Path, sizeof(Path), fr->fr_Drawer, fr->fr_File);
		save_prefs( prefs );
		SetWindowTitles(Wnd, Path, (STRPTR)-1);
	}
}

/*** Ask user for a file using ASL requester ***/
BOOL choose_file( STRPTR path, UWORD max )
{
	if( alloc_and_show_asl( path, FILF_PATGAD ) )
	{
		save_asl_dim(fr);
		cat_path(path, max, fr->fr_Drawer, fr->fr_File);
		return TRUE;
	}
	return FALSE;
}

/*** Set default preference ***/
void default_prefs( Prefs prefs )
{
	PREFS oldprefs;

	CopyMem(prefs, &oldprefs, sizeof(oldprefs));
	set_default_prefs(prefs, prefs->parent);
	update_all_guis(prefs);
}

/*** Save current configuration to restore it later if desired ***/
void save_config( char ConfigFile )
{
	if( (edit_file = ConfigFile) )
		CopyMem(Path, buffer, sizeof(Path));
	else
		CopyMem(&prefs, buffer, sizeof(prefs));
}

/*** Restore config ***/
void restore_config( Prefs prefs )
{
	PREFS oldprefs;
	CopyMem(prefs, &oldprefs, sizeof(oldprefs));
	if( edit_file == 0 )
	{
		/* The preferences come from Jano */
		CopyMem(buffer, prefs, sizeof(*prefs));
	}
	else
	{
		/* We have edited a static file */
		if( load_prefs(prefs, buffer) == RETURN_OK )
			SetWindowTitles(Wnd, Path, (STRPTR)-1);
		else
			set_default_prefs(prefs, prefs->parent);
	}
	update_all_guis(prefs);
}

void free_asl( void )
{
	FreeAslRequest( fr );
}

/** Display an error message in the window's title **/
void ThrowError( struct Window * W, STRPTR Msg )
{
	if( W )
	{
		extern struct IntuiMessage msgbuf;

		/* Save old title */
		if(Title == NULL) Title = W->Title;

		SetWindowTitles(W, Msg, (STRPTR) -1);
		DisplayBeep(W->WScreen);
		err_time = msgbuf.Seconds;

		/* To be sure that mesage will be disappear one day */
		ModifyIDCMP(W,W->IDCMPFlags | IDCMP_INTUITICKS);
	}	else puts(Msg);
}

/** Show messages associated with IoErr() number **/
void ThrowDOSError(struct Window *W, STRPTR Prefix)
{
	static UBYTE Message[100];

	/* Get standard DOS error message */
	Fault(IoErr(), Prefix, Message, sizeof(Message));

	ThrowError(W, Message);
}

/** Reset the old title of the window after a ThrowError() **/
void StopError( struct Window * W )
{
	SetWindowTitles(W, Title, (STRPTR) -1);
	Title = NULL;
	ModifyIDCMP(W,W->IDCMPFlags & ~IDCMP_INTUITICKS);
}

/* Get correct pen number according to pen specification */
void get_correct_pens( ULONG * spec, ULONG * pens, UWORD nb )
{
	register ULONG * src = spec, * dest = pens;

	/* Get a copy of the correct pens for the screen */
	for( ; nb--; src++, dest++ )
	{
		extern UWORD dri_Pens[];

		ULONG val = COLOR_VALUE( *src );

		switch( COLOR_TYPE( *src ) )
		{
			case PALETTE_TYPE: *dest = val; break;
			case SYSTEM_TYPE:  *dest = dri_Pens[ val ]; break;
			case RGB_TYPE:
				*dest = ObtainBestPenA( Scr->ViewPort.ColorMap, val<<8, val<<16, val<<24,
				           (APTR) OBPTags );
				break;
		}
	}
}

/* Free allocated colors */
void release_pens( ULONG * spec, ULONG * pens, UWORD nb )
{
	register ULONG * src = spec, * dest = pens;

	/* Get a copy of the correct pens for the screen */
	for( ; nb--; src++, dest++ )
		if( COLOR_TYPE( *src ) == RGB_TYPE )
			ReleasePen( Scr->ViewPort.ColorMap, *dest );
}

