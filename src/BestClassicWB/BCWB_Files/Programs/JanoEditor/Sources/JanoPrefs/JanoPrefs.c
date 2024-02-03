/*
 * JanoPrefs.c: Configuration window for JanoEditor
 * Free software under GNU license
 * Written by T.Pierron, C.Guillaume, november 11, 2000.
 */

#include <libraries/gadtools.h>
#include <intuition/intuitionbase.h>
#include <libraries/dos.h>
#include "Jed.h"
#include "Tabulators.h"
#include "IPC_Prefs.h"
#include "Panel.h"
#include "Catalogs.h"
#include "Palette.h"
#include "Prefs.h"
#include "ProtoTypes.h"
#include "Debug.h"

/*
 * Shared ressources we'll need to open
 */
struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *      GfxBase       = NULL;
struct LocaleBase *   LocaleBase    = NULL;
struct Library *      UtilityBase   = NULL;
struct Library *      GadToolsBase  = NULL;
struct Library *      IFFParseBase  = NULL;
struct Library *      AslBase       = NULL;
struct Library *      DiskfontBase  = NULL;
struct Library *      LayersBase    = NULL;
struct Screen *       Scr           = NULL;    /* Screen where window opens */
struct Window *       Wnd           = NULL;    /* Pointer to the opened window */
void *                Vi            = NULL;    /* Visual Info for gadget */
struct Menu *         Menu          = NULL;    /* Menu of interface */
struct Gadget *       Gads          = NULL;    /* Gadget of main interface */
TabGadget             TGad          = NULL;    /* Tabulator gadget */
struct IntuiMessage * msg, msgbuf;
struct TextFont *     font;
struct RastPort *     RP, RPT;

UWORD PrefZoom[4];
ULONG MenuTags[]      = { GTMN_FrontPen, 1L,  TAG_DONE };
ULONG UseUnderscore[] = { GT_Underscore, '_', TAG_DONE };

ULONG prefsigbit, msgport;         /* Signal bits for asynchronous messages collect */
UBYTE ConfigFile = TRUE;           /* TRUE is a config file is edited */
UWORD dri_Pens[ NUMDRIPENS ];      /* Keep dri pens uptodate */

ULONG OBPTags[] =
{
	OBP_Precision, PRECISION_EXACT,
	TAG_DONE,
};

struct IBox tab_box, win_box =
{
	50, 50, 400, 200
};

struct TabHooks * hook, tab_hooks[] =
{
	/* General tab callbacks */
	{create_general_gui, handle_general_tab_gadget, handle_general_kbd,
	 do_general_action, update_general_gui, 0, NULL},
	/* Syntax tab callbacks */
	{create_syntax_gui, handle_syntax_tab_gadget, handle_syntax_kbd,
	 NULL, NULL, 0, NULL},
	/* Colors tab callbacks */
	{create_colors_gui, handle_colors_tab_gadget, NULL,
	 do_colors_action, NULL, 0, NULL},
};

/*
 * Remove previous gadgets attached to a tabulator, and add the
 * one of the new selected panel.
 */
static void activate_nth_tab( UWORD nb )
{
	if( hook )
	{
		/* Remove old panel */
		RemoveGList( Wnd, hook->context, hook->nb_gadget );

		SetAPen(RP, 0);
		RectFill( RP, tab_box.Left, tab_box.Top+1, tab_box.Left + tab_box.Width,
				tab_box.Top + tab_box.Height );
	}
	hook = &tab_hooks[ nb ];
	AddGList( Wnd, hook->context, -1, -1, NULL );
	RefreshGadgets( hook->context, Wnd, NULL );
	GT_RefreshWindow( Wnd, NULL );
	if( hook->do_action ) hook->do_action( CODE_REFRESH_GUI );
	else set_palette_callback( NULL );
}

/*
 * Try to open configuration window, return 1 if all's ok
 */
BOOL setup_guipref( void )
{
	extern UBYTE Path[];
	STRPTR Title;
	WORD   adj_width, adj_height;

	/*
	 * Look if window isn't already open, thus just activate it,
	 * unzip to get full size and bring it to front.
	 */
	if( Wnd )
	{
		ActivateWindow( Wnd );
		WindowToFront( Wnd );
		/*
		 * Uniconified it, if it is
		 */
		if( Wnd->Height <= Wnd->BorderTop ) ZipWindow( Wnd );
		ScreenToFront( Scr );
		return TRUE;
	}

	/*
	 * Init temporary rastport, for font measurement and
	 * VisualInfo for gadtools gadgets creation.
	 */
	InitRastPort(&RPT);
	SetFont(&RPT, font = Scr->RastPort.Font);
	Vi = (APTR) GetVisualInfoA(Scr, NULL);

	/*
	 * Compute the iconified window dimensions
	 */
	Title       = ConfigFile ? Path : PrefMsg[0];
	PrefZoom[3] = Scr->BarHeight+1;
	PrefZoom[2] = TextLength(&RPT, Title, strlen(Title)) + 100;

	if ( prefs.use_pub )
	{
		/* Put window in upper right corner */
		PrefZoom[0] = Scr->Width - PrefZoom[2] - 15;
		PrefZoom[1] = 0;
	}
	else PrefZoom[0] = PrefZoom[1] = 50;

	/* Get correct drawinfo structure */
	{
		struct DrawInfo * di = GetScreenDrawInfo(Scr);
		if( di )
		{
			CopyMem( di->dri_Pens, dri_Pens, sizeof(dri_Pens) );
			FreeScreenDrawInfo(Scr, di);
		}
		else return FALSE;
	}
	/*
	 * Adjust the window box if it is too small for one or
	 * more tabulator content.
	 */
	adj_width       = 20;
	adj_height      = Scr->BarHeight + font->tf_YSize * 2 + 20;
	win_box.Width  -= adj_width;
	win_box.Height -= adj_height;

	CopyMem(&win_box, &tab_box, sizeof(tab_box));

	tab_box.Left = 10;
	tab_box.Top  = Scr->BarHeight + font->tf_YSize + 5;

	adjust_general_box( &tab_box );

	foreach_tab( tab_hooks, hook )
		hook->nb_gadget = count_gadget(
		hook->context   = hook->create_gui( &tab_box ) );

	if( Scr != IntuitionBase->ActiveScreen )
		ScreenToFront(Scr);

	if( !(Menu = (APTR) CreateMenusA(newmenu, (APTR) MenuTags)) )
		return FALSE;

	if( !LayoutMenus(Menu, Vi, GTMN_TextAttr, Scr->Font, TAG_DONE) )
   	return FALSE;

	if( (Wnd = (struct Window *) OpenWindowTags(NULL,
			WA_Width,       tab_box.Width  + adj_width,
			WA_Height,      tab_box.Height + adj_height,
			WA_Left,        win_box.Left,
			WA_Top,         win_box.Top,
			WA_IDCMP,       IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | IDCMP_MENUPICK |
			                IDCMP_VANILLAKEY  | IDCMP_NEWSIZE,
			WA_Flags,       WFLG_CLOSEGADGET | WFLG_NEWLOOKMENUS  | WFLG_DEPTHGADGET |
			                WFLG_ACTIVATE    | WFLG_SMART_REFRESH | WFLG_DRAGBAR,
			WA_NewLookMenus,TRUE,
			WA_Title,       (ULONG) Title,
			WA_PubScreen,   (ULONG) Scr,
			WA_Zoom,        (ULONG) PrefZoom,
			TAG_DONE)) )
	{
		static ULONG TTags[] = {
			GTAB_DriPens,  NULL,
			GTAB_Items,    (ULONG) StrTabItems,
			GTAB_CallBack, (ULONG) activate_nth_tab,
			TAG_DONE
		};
		struct NewGadget NG;
		struct Gadget *  gadget = (APTR) CreateContext( &Gads );
		WORD             width, i;

		NG.ng_TextAttr   = Scr->Font;
		NG.ng_VisualInfo = Vi;
		NG.ng_Flags      = PLACETEXT_IN;
		NG.ng_Height     = font->tf_YSize + 5;

		/* Create top row of tabs */
		NG.ng_LeftEdge = Wnd->BorderLeft;
		NG.ng_Width    = Wnd->Width - Wnd->BorderLeft - Wnd->BorderRight;
		NG.ng_TopEdge  = Wnd->BorderTop;

		RP       = Wnd->RPort; SetFont(RP, font);
		TTags[1] = (ULONG) dri_Pens;
		TGad     = CreateTabGadget(&NG, TTags);

		/* Create bottom row of gadgets */
		NG.ng_TopEdge  = Wnd->Height-NG.ng_Height-5;
		NG.ng_LeftEdge = 10;
		NG.ng_Width    = meas_table( OkCanSav ) + 40;
		width          = (Wnd->Width - 20 - NG.ng_Width) / 2;

		for( i = 0; i < 3; i++, NG.ng_LeftEdge += width )
		{
			NG.ng_GadgetText = OkCanSav[i];
			NG.ng_GadgetID   = 1000 + i;
			gadget = (APTR) CreateGadgetA(BUTTON_KIND, gadget, &NG, (APTR) UseUnderscore);
		}

		/* Point temporary RastPort to the window's one */
		CopyMem(RP, &RPT, sizeof(RPT));

		/* Add gadgets to window */
		AddGList( Wnd, Gads, -1, -1, NULL );
		AddRefreshTabGadget( Wnd, TGad );
		RefreshGList(Gads, Wnd, NULL, -1);

		hook = NULL; activate_nth_tab( 0 );

		SetMenuStrip( Wnd, Menu );
		GT_RefreshWindow(Wnd, NULL);

		/* Add window's signal bit */
		prefsigbit = 1 << Wnd->UserPort->mp_SigBit;
		return TRUE;
	}
	return FALSE;
}

/*
 * Close the preference window and notify Jano of the changes
 */
void close_prefwnd( UWORD cmd )
{
	close_palette_window();

	/* Remove gadgets first */
	if( hook )
		RemoveGList( Wnd, hook->context, hook->nb_gadget );

	if(Wnd)
	{
		safe_close_window( Wnd );
		prefsigbit=0; Wnd=NULL;
	}
	/* Free all memory associated to a tab */
	foreach_tab( tab_hooks, hook )
	{
		if( hook->context )   FreeGadgets( hook->context );
		if( hook->do_action ) hook->do_action( CODE_FREE_GUI );
	}
	if(Gads)
	{
		FreeGadgets(Gads); Gads=NULL;
	}
	if(Menu)
	{
		FreeMenus(Menu); Menu=NULL;
	}
	/* Do we need to send modifications to JANO? */
	if( cmd && !ConfigFile ) send_jano(&prefs, cmd);
}

/*
 * Process events coming from generic gadgets
 */
static BOOL handle_gadget( struct Gadget * G )
{
	switch( G->GadgetID )
	{
		case 1000:  /* Save */
			close_prefwnd(CMD_SAVPREF);
			if(ConfigFile) save_prefs(&prefs);
			break;
		case 1001:  /* Use */
			close_prefwnd(CMD_NEWPREF);
			break;
		case 1002:  /* Cancel */
			close_prefwnd(0);
			break;
		default:
			return FALSE;
	}
	/* Returns TRUE if window is closed */
	return TRUE;
}

/*
 * Process keyboard shorcut, returning TRUE if window
 * has been closed.
 */
static BOOL handle_pref_kbd( UBYTE Key )
{
	switch( Key )
	{
		case 'c': case 'C': case 27:
			close_prefwnd(0); return TRUE;
		case 13:  case 'u': case 'U':
			close_prefwnd(CMD_NEWPREF); return TRUE;
		case 's': case 'S':
			close_prefwnd(CMD_SAVPREF);
			if(ConfigFile) save_prefs(&prefs);
			return TRUE;
		case 127:
			if(Wnd->Height > Wnd->BorderTop)
				ZipWindow(Wnd);
			break;
	}
	return FALSE;
}

/*
 * Handle newmenu events
 */
BOOL handle_pref_menu( ULONG MenuID )
{
	switch( MenuID )
	{
		case 101: load_pref(&prefs);      break; /* Load */
		case 102: save_pref_as(&prefs);   break; /* Save as */
		case 103: close_prefwnd(0);       return TRUE;
		case 201: default_prefs(&prefs);  break; /* Default prefs */
		case 202: restore_config(&prefs); break; /* Last saved */
	}
	return FALSE;
}

/*
 * Dispatch events coming from main pref window
 */
static void handle_pref( void )
{
	while( (msg = (APTR) GT_GetIMsg(Wnd->UserPort)) )
	{
		CopyMemQuick( msg, &msgbuf, sizeof(msgbuf) );

		GT_ReplyIMsg( msg );

		if( HandleTabEvents( TGad ) )
			continue;

		switch( msgbuf.Class )
		{
			case IDCMP_CLOSEWINDOW:	close_prefwnd(CMD_NEWPREF); return;
			case IDCMP_INTUITICKS:
				/* An error message which needs to be removed? */
				if(err_time && msgbuf.Seconds - err_time > 4)
					StopError(Wnd);
				break;
			case IDCMP_VANILLAKEY:
				if( hook->handle_kbd && hook->handle_kbd( msgbuf.Code ) )
					break;

				if( handle_pref_kbd( msgbuf.Code ) ) return;
				break;
			case IDCMP_MENUPICK:
			{	struct MenuItem * Item;

				/* Multi-selection of menu entries */
				while( msgbuf.Code != MENUNULL )
					if( (Item = (APTR) ItemAddress( Menu, msgbuf.Code )) )
					{
						if( handle_pref_menu( (ULONG)GTMENUITEM_USERDATA(Item) ) ) return;

						msgbuf.Code = Item->NextSelect;
					}
			}	break;
			case IDCMP_GADGETUP:
				if( hook->handle_gadget && hook->handle_gadget( msgbuf.IAddress ) )
					break;

				if( handle_gadget( msgbuf.IAddress ) ) return;
				break;
			case IDCMP_NEWSIZE:
				if( Wnd->Height > Wnd->BorderTop )
				{
					ReshapePanel( TGad );
					if( hook->do_action ) hook->do_action( CODE_REFRESH_GUI );
				}
		}
	}
}

DEBUG_STATIC_VARS;

void cleanup( STRPTR msg, int errcode )
{
	free_locale();
	close_port();
	free_asl();
	FreeTabGadget( TGad );

	if(Vi)            FreeVisualInfo(Vi);
	if(DiskfontBase)  CloseLibrary(DiskfontBase);
	if(GadToolsBase)  CloseLibrary(GadToolsBase);
	if(AslBase)       CloseLibrary(AslBase);
	if(IFFParseBase)  CloseLibrary(IFFParseBase);
	if(LocaleBase)    CloseLibrary( (APTR) LocaleBase );
	if(UtilityBase)   CloseLibrary( (APTR) UtilityBase );
	if(GfxBase)       CloseLibrary( (APTR) GfxBase );
	if(IntuitionBase) CloseLibrary( (APTR) IntuitionBase );
	if(msg)           puts(msg);

	DEBUG_END;
	exit(errcode);
}

/*** MAIN LOOP ***/
int main( int argc, char *argv[] )
{
	ULONG sigwait, sigrcvd;

	DEBUG_START;

	memset(&prefs, 0, sizeof(prefs));

	/* If preference tool is already running, just quits */
	if( find_prefs() ) cleanup(0,0);

	/* Optionnal libraries */
	LocaleBase   = (APTR) OpenLibrary("locale.library",  38);
	AslBase      =        OpenLibrary("asl.library",     36);
	DiskfontBase =        OpenLibrary("diskfont.library", 0);
	IFFParseBase =        OpenLibrary("iffparse.library", 0);

	if(LocaleBase) prefs_local();		/* Localize the prog */

	/* Open the required ROM libraries */
	if( (IntuitionBase = (APTR) OpenLibrary("intuition.library", 36)) &&
	    (GfxBase       = (APTR) OpenLibrary("graphics.library",  36)) &&
	    (GadToolsBase  = (APTR) OpenLibrary("gadtools.library",  36)) &&
	    (UtilityBase   =        OpenLibrary("utility.library",   36)) &&
	    (LayersBase    =        OpenLibrary("layers.library",    36)) )
	{
		if( !(msgport = create_port()) ) cleanup(0, RETURN_FAIL);

		/* User may want to "edit" a particular file */
		if(argc > 1)
		{
			if( load_prefs(&prefs, argv[1]) )
				ThrowDOSError(NULL, argv[1]), cleanup(NULL, RETURN_FAIL);
		}
		else /* No argument given, use default */
		{
			if( find_jano(&prefs) ) ConfigFile = FALSE;
			else load_prefs(&prefs, NULL);
		}

		save_config( ConfigFile );
		if(ConfigFile) Scr = prefs.parent;

		/* Init interface */
		if( setup_guipref() )
		{
			sigwait = msgport | prefsigbit | SIGBREAKF_CTRL_C;
			for( ;; )
			{
				sigrcvd = Wait( sigwait | palettesigbit );

				/* From where does the signal comes from? */
				if(sigrcvd & SIGBREAKF_CTRL_C) break;

				else if(sigrcvd & msgport) handle_port();

				else if(sigrcvd & palettesigbit) handle_palette();
				
				else handle_pref();

				if(Wnd == NULL) break;
			}
		}
		else cleanup( ErrMsg(ERR_NOGUI), RETURN_FAIL );
	}
	else cleanup( ErrMsg(ERR_BADOS), RETURN_FAIL );

	cleanup( NULL, RETURN_OK );
}
