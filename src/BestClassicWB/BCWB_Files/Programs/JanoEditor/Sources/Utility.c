/**************************************************************
**** Utility.c: some useful functions, by T.Pierron        ****
**** Free software under GNU license, started on 17/2/2000 ****
**************************************************************/

#define  UTILITY_C
#include <intuition/intuition.h>
#include <workbench/startup.h>
#include <utility/tagitem.h>
#include <dos/dos.h>
#include <exec/memory.h>
#include <exec/io.h>
#include "ClipLoc.h"
#include "Project.h"
#include "Gui.h"
#include "Utility.h"
#include "DiskIO.h"
#include "ProtoTypes.h"

#define  CATCOMP_NUMBERS
#include "Jed_Strings.h"

extern ULONG  err_time;
static UBYTE  SPrintfBuf[80], *savea3;

/** SPrintf like routine **/


#ifdef _AROS
#include <aros/asmcall.h>

AROS_UFH2(void, PutChProc,
    AROS_UFHA(UBYTE,    data, D0),
    AROS_UFHA(STRPTR *, p,   A3))
{
    AROS_USERFUNC_INIT

#elif defined( __GNUC__ )

void PutChProc( void )        /* Register based-argument passing with gcc */
{
	register UBYTE data __asm("d0");

#else                         /* Same proc with SAS/C */

void __saveds __asm PutChProc(register __d0 UBYTE data, register __a3 STRPTR out)
{
#endif
	/* Can't use a3 ; compiler will restore register content on exit */
	if( savea3 < SPrintfBuf + sizeof(SPrintfBuf) - 1 )
		*savea3++ = data;
	else *savea3 = 0;

#ifdef _AROS
    AROS_USERFUNC_EXIT
#endif
}

#ifdef _AROS
AROS_UFH2(void, FPutChProc,    /* AROS specific */
    AROS_UFHA(UBYTE, data, D0),
    AROS_UFHA(BPTR,  fh,   A3))
{
    AROS_USERFUNC_INIT

#elif defined( __GNUC__ )

void FPutChProc( void )        /* GCC specific */
{
	register UBYTE data __asm("d0");
	register BPTR  fh   __asm("a3");

#else                         /* SAS/C specific */

void __saveds __asm FPutChProc( register __d0 UBYTE data, register __a3 BPTR fh )
{
#endif
	if( data ) FPutC( fh, data );

#ifdef _AROS
    AROS_USERFUNC_EXIT
#endif
}

/** This is a very simplified routine, but takes only a few hundreed of bytes **/
STRPTR my_SPrintf(STRPTR fmt, APTR data)
{
	savea3 = SPrintfBuf;
	RawDoFmt(fmt, data, (void *)PutChProc, 0);
	return SPrintfBuf;
}

UWORD my_StrnCpy( STRPTR src, STRPTR dest, UWORD max )
{
	register STRPTR s = src;
	register STRPTR d = dest;
	register UWORD  n = 1;
	for( ; n < max && *s; *d++ = *s++, n++ );
	*d = 0;
	return n-1;
}

STRPTR InfoTmpl = "%4ld, %5ld ";

/** Write column/line in top of window **/
void draw_info(Project p)
{
	extern UBYTE boopsigad;
	extern WORD  fginfo, bginfo;
	struct { ULONG x; ULONG y; } coord;
	struct RastPort *RP;

	coord.x = p->nbrc+1; coord.y = p->nbl+1; savea3 = SPrintfBuf;
	RawDoFmt(InfoTmpl, &coord, PutChProc, 0);

	if( boopsigad )
		RP = &Scr->RastPort;
	else
		SetFont(RP = &RPT, Scr->RastPort.Font);

	RP->AlgoStyle = FS_NORMAL;
	SetABPenDrMd(RP,fginfo,bginfo,JAM2);
	Move(RP, gui.xinfo,  gui.yinfo);
	Text(RP, SPrintfBuf, savea3-SPrintfBuf-1);
	if( !boopsigad )
		SetFont(&RPT, prefs.scrfont);
}

/** Convert argv table into a WBArg one **/
void ParseArgs(StartUpArgs *res, int nb, char **argv)
{
	res->sa_Free   = 0;
	res->sa_NbArgs = 0;
	if( nb == 0 ) {
		/* Program has been started from Workbench */
		res->sa_NbArgs =        ((struct WBStartup *)argv)->sm_NumArgs-1;
		res->sa_ArgLst = (APTR)(((struct WBStartup *)argv)->sm_ArgList+1);
	} else if( nb > 1 ) {
		/* From CLI */
		struct WBArg *new;
		if((new = (void *) AllocVec(sizeof(*new)*(--nb), MEMF_PUBLIC | MEMF_CLEAR)))
		{
			BPTR cwd = (BPTR) CurrentDir( NULL ); /* No need to UnLock so */
			res->sa_ArgLst = (APTR) new;
			res->sa_NbArgs = nb;
			res->sa_Free   = 1;
			for(argv++; nb; new->wa_Name = *argv++, new->wa_Lock = cwd, new++, nb--);
			CurrentDir( cwd );
		}
	}
}

/** Get the filename inside #include directive **/
STRPTR GetIncludeFile(Project prj, LINE * ln)
{
	STRPTR p = ln->stream;
	LONG   i = ln->size;

	while(i && TypeChar[ *p ] == SPACE) p++, i--;
	if( i > 0 && *p == '#' )
	{
		for(p++, i--; i && TypeChar[*p] == SPACE; p++, i--);
		if( i > 7 && 0 == strncmp(p, "include", 7) )
		{
			for(p+=7, i-=7; i && TypeChar[*p] == SPACE; p++, i--);
			if(i > 2)
			{
				extern UBYTE BufTxt[];
				STRPTR dest = BufTxt;
				UBYTE  end  = *p;
				if(*p == '<') strcpy(BufTxt, "INCLUDE:"), dest+=8, end = '>';
				else if(prj->path == NULL) BufTxt[0] = 0;
				else {
					CopyMem(prj->path, BufTxt, prj->name-prj->path);
					dest += prj->name-prj->path;
				}
				for(p++, i--; i && *p != end; *dest++ = *p++, i--);
				*dest=0;
				if(RETURN_OK == get_full_path(BufTxt, &dest))
					return dest;
			}
		}
	}
	return NULL;
}

/* Generic list used ONLY as pointer */
typedef	struct _list
{
	struct _list *next, *prev;
}	*list;

/*** Insert node Src after the node It ***/
void InsertAfter( list It,list Src )
{
	register list L, Lp;
	if(It)
	{
		Lp=It; L=Lp->next;
		Src->next = L; Src->prev = Lp;
		if( L  ) L->prev = Src;
		if( Lp ) Lp->next= Src;
	}
	else Src->next = Src->prev = NULL;
}

/*** Remove a node from a list ***/
void Destroy( list *First, list p )
{
	if(p->next) p->next->prev = p->prev;
	if(p->prev) p->prev->next = p->next;
	else *First = p->next;
}

/*** Catenate two path part ***/
STRPTR CatPath(STRPTR dir, STRPTR file)
{
	STRPTR dst;
	UWORD  len;
	if( ( dst = (STRPTR) AllocVec(len = strlen(dir) + strlen(file) + 2, MEMF_PUBLIC) ) )
		strcpy(dst, dir), AddPart(dst, file, len);
	return dst;
}

/*** MemMove: copy overlapping chunk of mem ***/
void MemMove(UBYTE *Src, UWORD Offset, LONG sz)
{
	register UBYTE *src, *dst;
	for(src=Src+sz-1, dst=src+Offset; sz>0; sz--, *dst-- = *src--);
}

static UBYTE TabStop[256], tab = 255;

/*** Pre-computes tabstop ***/
void init_tabstop(UBYTE ts)
{
	if(ts != tab) {
		int i;
		for(i=0, tab=ts; i<sizeof(TabStop); i++)
		{
			TabStop[i] = tab;
			if(tab==1) tab=ts; else tab--;
		}
		tab=ts;
	}
}

/*** Returns increment up to the next tabstop ***/
UBYTE tabstop(ULONG nb)
{
	/* Almost all tabulations are situated before the 256th character */
	return (UBYTE) (nb < sizeof(TabStop) ? TabStop[nb] : tab - (nb % tab));
}

/*** Display an error message in the window's title ***/
void ThrowError(struct Window *W, STRPTR Msg)
{
	if( W )
	{
		if(Msg[0] != 127) DisplayBeep(W->WScreen); else Msg++;

		/* If window is backdrop'ed, change screen's title instead of window */
		if(W->Flags & WFLG_BACKDROP) SetWindowTitles(W,(UBYTE *)-1,Msg);
		else SetWindowTitles(W,Msg,(UBYTE *)-1);

		err_time = 0;
		/* To be sure that mesage will be disappear one day */
		ModifyIDCMP(W,W->IDCMPFlags | IDCMP_INTUITICKS);
	}
	else puts(Msg);
}

/*** Show messages associated with IoErr() number ***/
void ThrowDOSError(struct Window *W, STRPTR Prefix)
{
	static UBYTE Message[100];

	/* Get standard DOS error message */
	Fault(IoErr(), Prefix, Message, sizeof(Message));

	ThrowError(W, Message);
}

/*** Set title of window/screen properly ***/
void SetTitle( struct Window * W, STRPTR Msg )
{
	/* If there is a pending msg, stop it */
	if( W->IDCMPFlags & IDCMP_INTUITICKS )
		ModifyIDCMP(W,W->IDCMPFlags & ~IDCMP_INTUITICKS);

	/* Modify visible title */
	if(W->Flags & WFLG_BACKDROP) SetWindowTitles( W, (STRPTR)-1, Msg );
	else SetWindowTitles( W, Msg, (STRPTR)-1 );
	W->UserData = Msg;
}

/*** Reset the old title ***/
void StopError( struct Window * W )
{
	if(W->Flags & WFLG_BACKDROP) SetWindowTitles( W, (STRPTR)-1, W->UserData );
	else SetWindowTitles( W, W->UserData, (STRPTR)-1 );

	/* INTUITICKS aren't required anymore */
	ModifyIDCMP(W,W->IDCMPFlags & ~IDCMP_INTUITICKS);
}

/** Getting standard busy pointer **/
static ULONG IDCMPFlags;
static ULONG busy_pointer_tags[] =
{
	WA_BusyPointer,TRUE,
	TAG_END
};

/*** Shutdown window IDCMP port ***/
void BusyWindow(struct Window *W)
{
	if( W )
	{
		/* Store IDCMP flags and shutdown port */
		IDCMPFlags = W->IDCMPFlags;
		ModifyIDCMP(W,0);
		/* Change window's pointer (OS 3.0+ only) */
		SetWindowPointerA(W,(struct TagItem *)busy_pointer_tags);
	}
}

/*** Reset IDCMP port ***/
void WakeUp(struct Window *W)
{
	if( W )
		ModifyIDCMP(W,IDCMPFlags),
		ClearPointer(W);
}

/* Information window about current project */
struct EasyStruct request = {
	sizeof(struct EasyStruct)
};

/*** Don't know where to put this one... ***/
void show_info(Project p)
{
	extern UBYTE WinTitle[], szEOL[];
	ULONG  bytes;

	BusyWindow(Wnd);
	CopyMem(MsgAbout, &request.es_Title, 3*sizeof(STRPTR));
	bytes = size_count(p->the_line, szEOL[ p->eol ]);

	EasyRequest(Wnd, &request, 0, 
		(ULONG) WinTitle,
		(ULONG) TARGET,
		(ULONG) p->pname,
		p->max_lines, (ULONG) MsgAbout[ p->max_lines>1 ? 6:5 ],
		bytes,        (ULONG) MsgAbout[ bytes>1 ? 4:3 ]
	);
	WakeUp(Wnd);
}

/*** Avert user that its file has been modified ***/
char warn_modif(Project p)
{
	if( p->state & MODIFIED )
	{
		request.es_Title        = MsgAbout[0];
		request.es_TextFormat   = ErrMsg(ERR_FILEMODIFIED);
		request.es_GadgetFormat = ErrMsg(ERR_SLC);

		switch( EasyRequest( Wnd, &request, 0, (ULONG) p->pname ) )
		{
			case 0:  return 0;
			case 1:  return save_project(p, FALSE, FALSE);
		}
	}
	/* User want to close this file */
	return 1;
}

/*** Avert user that he is going to overwrite a file ***/
char warn_overwrite( STRPTR path )
{
	APTR lock;
	if(NULL != (lock = (APTR) Lock( path, SHARED_LOCK )))
	{
		UnLock( (BPTR) lock );
		/* Fuck'n shit, the file exists */
		request.es_Title        = MsgAbout[0];
		request.es_TextFormat   = ErrMsg(ERR_FILEEXISTS);
		request.es_GadgetFormat = ErrMsg(ERR_OC);

		return (char) EasyRequest(Wnd, &request, 0, NULL);
	}
	return 1;
}

/*** Avert user that he is openning twice the same file ***/
char warn_already_open( STRPTR file )
{
	request.es_Title        = MsgAbout[0];
	request.es_TextFormat   = ErrMsg(ERR_ALREADYOPEN);
	request.es_GadgetFormat = ErrMsg(ERR_SO);

	return (char) EasyRequest(Wnd, &request, 0, FilePart(file));
}

/*** Simple requester to ask user for a number ***/
int get_number( Project p, STRPTR title, LONG * result )
{
	struct Window *win;
	static UBYTE  LineNum[10];
	static struct StringInfo SI = {LineNum,NULL,0,sizeof(LineNum),0,0,0,0,0,0,NULL,NULL,NULL};
	static struct Gadget StrGad = {
		NULL,0,0,0,0,GFLG_GADGHCOMP,GACT_IMMEDIATE | GACT_RELVERIFY | GACT_LONGINT | GACT_STRINGCENTER,
		GTYP_STRGADGET,NULL,NULL,NULL,NULL,(APTR) &SI,0,NULL
	};

	/* Open our window */
	if((win = (APTR) OpenWindowTags( NULL,
			WA_Width,       160,
			WA_InnerHeight, prefs.scrfont->tf_YSize+2,
			WA_Left,        Wnd->LeftEdge + (Wnd->Width  - 160) / 2,
			WA_Top,         Wnd->TopEdge  + (Wnd->Height - 30)  / 2,
			WA_Title,       (ULONG) title,
			WA_IDCMP,       IDCMP_CLOSEWINDOW | IDCMP_GADGETUP,
			WA_Flags,       WFLG_CLOSEGADGET  | WFLG_ACTIVATE | WFLG_RMBTRAP | WFLG_DRAGBAR,
			WA_PubScreen,   (ULONG) Scr,
			TAG_DONE)))
	{
		extern struct IntuiMessage msgbuf,*msg;

		BusyWindow(Wnd);
		/* Attach the simple OS1.3 compliant string gadget */
		*LineNum = 0;
		StrGad.Width    = 160 - win->BorderRight - (
		StrGad.LeftEdge = win->BorderLeft);
		StrGad.TopEdge  = win->BorderTop+1;
		StrGad.Height   = prefs.scrfont->tf_YSize;
		AddGList(win, &StrGad, 0, 1, NULL);
		ActivateGadget(&StrGad, win, NULL);

		/* Quickly collects events */
		for(;;) {

			WaitPort( win->UserPort );

			while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)))
			{
				CopyMemQuick(msg, &msgbuf, sizeof(msgbuf));
				ReplyMsg((struct Message *)msg);

				switch( msgbuf.Class )
				{
					case IDCMP_GADGETUP:
					case IDCMP_CLOSEWINDOW: goto the_end;
				}
			}
		}
		/* Cleanup everything */
		the_end: WakeUp(Wnd);
		CloseWindow(win);
		*result = SI.LongInt;

		if( LineNum[0] != 0 ) return 1;

	}	else ThrowError(Wnd, ErrMsg(ERR_NOMEM));
	return 0;
}


/*** Add a string to a review buffer ***/
STRPTR AddToBuffer( ReviewBuf rb, STRPTR new, UWORD len )
{
	UWORD i = 0;

	if( ++len == 1 ) return NULL;

	/* Check if new string doesn't exists yet */
	while( i < rb->Usage )
	{
		UWORD length = strlen(rb->Buffer + i)+1;

		if( length == len && strncmp(rb->Buffer+i, new, length-1) == 0 )
		{
			/* Yes, the string already exists, move it to the end */
			WORD j = i + length;
			rb->Review = rb->Usage-length;
			if( j < rb->Usage ) {
				CopyMem(rb->Buffer+j, rb->Buffer+i, rb->Usage-j);
				CopyMem(new, rb->Buffer+rb->Review, length);
			}
			return rb->Buffer+rb->Review;
		}
		i += length;
	}
	/* String does not exists yet: check first for free space */
	if(rb->Usage + len >= sizeof(rb->Buffer))
	{
		/* Need to discard some strings */
		STRPTR p = rb->Buffer; i=0;
		do {
			while(i < rb->Usage && *p) i++, p++;
			if(*p == 0) i++, p++;
		} while( sizeof(rb->Buffer) - rb->Usage + i < len );
		/* Shift buffer */
		CopyMem(p, rb->Buffer, rb->Usage -= (p - rb->Buffer));
	}
	
	/* Now we can add the new string */
	{	STRPTR ret = rb->Buffer + rb->Usage;
		CopyMem(new, ret, len); ret[len-1] = 0;
		rb->Review = rb->Usage;
		rb->Usage += len;
		return ret;
	}
}

/* Get previous/next string in review buffer */
UWORD GetPrevNextBuffer( ReviewBuf rb, STRPTR dest, UWORD max, BYTE dir )
{
	STRPTR p   = rb->Buffer + rb->Review;
	UWORD  len = 0;
	if(dir < 0) {
		if(rb->Review > 1) {
			for(p -= 2; p > rb->Buffer && *p; p--);
			if(*p == 0) p++;
			len = rb->Buffer + rb->Review - p;
		}
		else return strlen( p );
	} else {
		if(rb->Review >= 0) while(*p++); else p++;
		if(p - rb->Buffer < rb->Usage)
			len = strlen(p)+1;
		else rb->Review = rb->Usage;
	}
	/* No dest str. given: just give starting index of buffer */
	if(dest == NULL) return (len > 0 ? rb->Review = p - rb->Buffer : 0);

	if(len > 0) {
		CopyMem(p, dest, len > max ? max : len);
		rb->Review = p - rb->Buffer; dest[max-1] = 0;
		return len - 1;
	}
	*dest = 0; return 0;
}

STRPTR GetLastBuffer( ReviewBuf rb, BOOL force )
{
	if( rb->Review < rb->Usage || !force )
		return rb->Buffer + rb->Review;
	else
		return rb->Buffer + GetPrevNextBuffer( rb, NULL, 0, -1 );
}
