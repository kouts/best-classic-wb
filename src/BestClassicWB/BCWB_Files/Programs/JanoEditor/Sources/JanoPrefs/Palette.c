/*
 * Palette.c: Color chooser for various item of JanoEditor
 * Free software under GNU license
 * Written by T.Pierron, C.Guillaume, june 29, 2002
 */

#include <libraries/gadtools.h>
#include <intuition/gadgetclass.h>
#include <libraries/dos.h>
#include <exec/memory.h>
#include "JanoPrefs.h"
#include "Panel.h"
#include "Palette.h"
#include "Prefs.h"
#include "ProtoTypes.h"

/* Shared ressources (in JanoPrefs.c) */
extern struct IntuiMessage * msg, msgbuf;
extern struct TextFont *     font;
extern UWORD                 dri_Pens[];


/* Private ones */
static TabGadget         TGad  = NULL;    /* Tabulator gadget */
static struct Window *   CCWnd = NULL;
static struct RastPort * RPC;
static struct NewGadget  ng;
static struct List       syspens;
static struct Node *     nodebuf;
static struct Gadget *   gads[5];
static UWORD             CCZoom[4];

static UWORD RGBLength, RGBSpace;
static UBYTE Red, Green, Blue;

static struct CCTabHooks * hook, tab_hooks[] =
{
	/* General tab callbacks */
	{create_palette_gui, handle_palette_tab_gadget, NULL, 0, NULL},
	/* Syntax tab callbacks */
	{create_system_gui, handle_system_tab_gadget, NULL, 0, NULL},
	/* Colors tab callbacks */
	{create_rgb_gui, handle_rgb_tab_gadget, NULL, 0, NULL},
};

static struct IBox tab_box;

static PalCallback gpcb = NULL;

/* Exported symbols */
ULONG palettesigbit;

/* "Palette" tabulator gui */
struct Gadget * create_palette_gui( struct IBox * box )
{
	struct Gadget * context = NULL;

	CopyMem( box, &ng.ng_LeftEdge, sizeof(*box) );

	ng.ng_TopEdge   += 5;
	ng.ng_TextAttr   = Scr->Font;
	ng.ng_VisualInfo = Vi;
	ng.ng_GadgetText = NULL;

	/* Create a single palette chooser gadget */
	gads[3] = (APTR) CreateGadget(PALETTE_KIND, CreateContext(&context), &ng,
			GTPA_Depth, Scr->RastPort.BitMap->Depth,
			GTPA_Color, 0, GTPA_IndicatorWidth, 20, TAG_DONE);

	return context;
}

/* Process gadget events of "Palette" tab */
BOOL handle_palette_tab_gadget( struct Gadget * G )
{
	if( gpcb )
		gpcb( PALETTE_COLOR(msgbuf.Code), msgbuf.Code );

	return TRUE;
}

/* "System" tabulator gui */
struct Gadget * create_system_gui( struct IBox * box )
{
	struct Gadget * context = NULL;
	STRPTR *        strs;

	if( (nodebuf = AllocVec( sizeof(*nodebuf) * NB_SYSPENS, MEMF_PUBLIC )) )
	{
		struct Node * list = nodebuf;
		NewList( &syspens );
		for( strs = SystemStrs; *strs; strs ++, list++ )
		{
			list->ln_Name = *strs;
			AddTail(&syspens, list);
		}

		gads[4] = (APTR) CreateGadget(LISTVIEW_KIND, CreateContext(&context), &ng,
			GTLV_ShowSelected, NULL, GTLV_Labels, &syspens,
			GTLV_Selected,     0,    TAG_DONE);
	}
	return context;
}

BOOL handle_system_tab_gadget( struct Gadget * G )
{
	if( gpcb )
		gpcb( SYSTEM_COLOR(msgbuf.Code), dri_Pens[ msgbuf.Code ] );

	return TRUE;
}

/* Be sure palette GUI can fit in the box */
void adjust_gui_box( struct IBox * box )
{
	UWORD min_width, min_height;
	ULONG min_pal_height;

	RGBSpace  = TextLength(RP, "999", 3);
	RGBLength = meas_table(RGBStrs);

	min_width  = RGBLength + 200;
	min_height = (font->tf_YSize + 5) * 3;

	/* Be sure palette square are not less than 8x8 pixel square */
	min_pal_height = (1 << Scr->RastPort.BitMap->Depth) / (box->Width / 8) * 8;

	if( min_pal_height > 100 ) min_pal_height = 100;
	if( min_pal_height > min_height ) min_height = min_pal_height;

	if( min_width  > box->Width  ) box->Width  = min_width;
	if( min_height > box->Height ) box->Height = min_height;
}

/* Create RGB gui */
struct Gadget * create_rgb_gui( struct IBox * box )
{
	struct Gadget * context = NULL, * last;
	UWORD           i, height;

	ng.ng_Flags  = PLACETEXT_LEFT | NG_HIGHLABEL;
	ng.ng_Height = font->tf_YSize + 2;
	ng.ng_Width -= (ng.ng_LeftEdge += RGBLength + 10) + RGBSpace + 10;

	last   = CreateContext(&context);
	height = box->Height - ng.ng_Height;

	for( i = 0; i < 3; i++ )
	{
		ng.ng_GadgetText = RGBStrs[i];
		ng.ng_GadgetID   = i;
		ng.ng_TopEdge    = box->Top + height * i / 2 + 5;

		gads[i] = last = (APTR) CreateGadget( SLIDER_KIND, last, &ng,
				GA_RelVerify,       TRUE,
				GA_Immediate,       TRUE,
				GTSL_LevelFormat,   "%ld",
				GTSL_Max,           255,
				GTSL_MaxLevelLen,   5,
				GTSL_MaxPixelLen,   RGBSpace + 10,
				GTSL_LevelPlace,    PLACETEXT_RIGHT,
				GTSL_Justification, GTJ_RIGHT, TAG_DONE );

	}
	return context;
}

/* Process gadget events of "RGB" tab */
BOOL handle_rgb_tab_gadget( struct Gadget * G )
{
	switch( G->GadgetID )
	{
		case 0: Red   = msgbuf.Code; break;
		case 1: Green = msgbuf.Code; break;
		case 2: Blue  = msgbuf.Code; break;
		default: return FALSE;
	}
	if( gpcb )
		gpcb( RGB_COLOR(Red, Green, Blue), 
			ObtainBestPenA(Scr->ViewPort.ColorMap, Red<<24, Green<<24, Blue<<24,
				(APTR) OBPTags ) );

	return TRUE;
}

/* Free all memory allocated here */
void free_palette_tabs( void )
{
	if( nodebuf ) FreeVec( nodebuf );
}

/*
 * Remove previous gadgets attached to a tabulator, and add the
 * one of the new selected panel.
 */
static void activate_nth_tab( UWORD nb )
{
	if( hook )
	{
		/* Remove old panel */
		RemoveGList( CCWnd, hook->context, hook->nb_gadget );

		SetAPen( RPC, 0 );
		RectFill( RPC, tab_box.Left, tab_box.Top+1, tab_box.Left + tab_box.Width,
				tab_box.Top + tab_box.Height + 5 );
	}
	hook = &tab_hooks[ nb ];
	AddGList( CCWnd, hook->context, -1, -1, NULL );
	RefreshGadgets( hook->context, CCWnd, NULL );
	GT_RefreshWindow( CCWnd, NULL );
}

/*
 * Synchronise palette window with what user select
 */
void sync_palette( ULONG code )
{
	if( CCWnd )
	{
		UBYTE tab = code >> 24;
		ULONG val = COLOR_VALUE(code);
		APTR  win = (tab == hook - tab_hooks ? CCWnd : NULL);

		switch( tab )
		{
			case 0:
				GT_SetGadgetAttrs(gads[3], win, NULL, GTPA_Color, val, TAG_DONE);
				break;
			case 1:
				GT_SetGadgetAttrs(gads[4], win, NULL, GTLV_Selected, val,
						GTLV_MakeVisible, val, TAG_DONE);
				break;
			case 2:
				GT_SetGadgetAttrs(gads[0], win, NULL, GTSL_Level, RED(val),   TAG_DONE);
				GT_SetGadgetAttrs(gads[1], win, NULL, GTSL_Level, GREEN(val), TAG_DONE);
				GT_SetGadgetAttrs(gads[2], win, NULL, GTSL_Level, BLUE(val),  TAG_DONE);
		}
		if( win == NULL )
			SelectPanel(TGad, tab, NTH_TAB);
	}
}

/*
 * Try to open configuration window, return 1 if all's ok
 */
BOOL open_palette_window( PalCallback pcb, ULONG init_code )
{
	gpcb = pcb;
	/*
	 * Look if window isn't already open, thus just activate it,
	 * unzip to get full size and bring it to front.
	 */
	if( CCWnd )
	{
		ActivateWindow( CCWnd );
		WindowToFront( CCWnd );
		if( CCWnd->Height <= CCWnd->BorderTop ) ZipWindow( CCWnd );
		ScreenToFront( Scr );
		return TRUE;
	}

	/*
	 * Compute the iconified window dimensions
	 */
	CCZoom[3] = Scr->BarHeight+1;
	CCZoom[2] = Wnd->Width;
	CCZoom[0] = Wnd->LeftEdge;
	CCZoom[1] = Wnd->TopEdge + Wnd->Height;

	/*
	 * Adjust the window box if it is too small for one or
	 * more tabulator content.
	 */
	tab_box.Left   = 10;
	tab_box.Top    = Scr->BarHeight + font->tf_YSize + 5;
	tab_box.Width  = Wnd->Width - 20;
	tab_box.Height = 60;

	adjust_gui_box( &tab_box );

	foreach_tab( tab_hooks, hook )
		hook->nb_gadget = count_gadget(
		hook->context   = hook->create_gui( &tab_box ) );

	if( (CCWnd = (struct Window *) OpenWindowTags(NULL,
			WA_Width,       tab_box.Width  + 20,
			WA_Height,      tab_box.Height + tab_box.Top + 10,
			WA_Left,        CCZoom[0],
			WA_Top,         CCZoom[1],
			WA_IDCMP,       IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | IDCMP_MENUPICK |
			                IDCMP_VANILLAKEY  | IDCMP_NEWSIZE,
			WA_Flags,       WFLG_CLOSEGADGET | WFLG_NEWLOOKMENUS  | WFLG_DEPTHGADGET |
			                WFLG_ACTIVATE    | WFLG_SMART_REFRESH | WFLG_DRAGBAR,
			WA_NewLookMenus,TRUE,
			WA_Title,       (ULONG) CCStrs[0],
			WA_PubScreen,   (ULONG) Scr,
			WA_Zoom,        (ULONG) CCZoom,
			TAG_DONE)) )
	{
		static ULONG TTags[] = {
			GTAB_DriPens,  NULL,
			GTAB_Items,    (ULONG) (CCStrs+1),
			GTAB_CallBack, (ULONG) activate_nth_tab,
			GTAB_Active,   0L,
			TAG_DONE
		};
		struct NewGadget NG;

		SetFont(RPC = CCWnd->RPort, font);

		/* Create top row of tabs */
		NG.ng_LeftEdge = CCWnd->BorderLeft;
		NG.ng_Width    = CCWnd->Width - CCWnd->BorderLeft - CCWnd->BorderRight;
		NG.ng_TopEdge  = CCWnd->BorderTop;
		NG.ng_TextAttr = Scr->Font;
		NG.ng_Height   = font->tf_YSize + 5;

		TTags[1] = (ULONG) dri_Pens;
		TTags[7] = init_code >> 24;
		if( TTags[7] > 2 ) TTags[7] = init_code = 0;
		TGad = CreateTabGadget(&NG, TTags);

		/* Add gadgets to window */
		AddRefreshTabGadget( CCWnd, TGad );
		SetMenuStrip( CCWnd, Menu );

		hook = NULL;
		sync_palette( init_code );
		activate_nth_tab( TTags[7] );

		/* Add window's signal bit */
		palettesigbit = 1 << CCWnd->UserPort->mp_SigBit;
		return TRUE;
	}
	return FALSE;
}

void set_palette_callback( PalCallback pcb )
{
	gpcb = pcb;
}

/*
 * Close the palette chooser window
 */
void close_palette_window( void )
{
	if( CCWnd == NULL ) return;

	/* Remove gadgets first */
	if( hook )
		RemoveGList( CCWnd, hook->context, hook->nb_gadget );

	if( TGad )
		FreeTabGadget( TGad );

	if( CCWnd )
	{
		safe_close_window( CCWnd );
		palettesigbit=0; CCWnd=NULL;
	}
	/* Free all memory associated to a tab */
	foreach_tab( tab_hooks, hook )
		if( hook->context )  FreeGadgets( hook->context );

	free_palette_tabs();
}

/*
 * Process keyboard shorcut, returning TRUE if window
 * has been closed.
 */
static BOOL handle_palette_kbd( UBYTE Key )
{
	switch( Key )
	{
		case 27: close_palette_window(); return TRUE;
		case 127:
			if( CCWnd->Height > CCWnd->BorderTop )
				ZipWindow( CCWnd );
	}
	return FALSE;
}

/*
 * Dispatch events coming from main pref window
 */
void handle_palette( void )
{
	while( (msg = (APTR) GT_GetIMsg(CCWnd->UserPort)) )
	{
		CopyMemQuick( msg, &msgbuf, sizeof(msgbuf) );

		GT_ReplyIMsg( msg );

		if( HandleTabEvents( TGad ) )
			continue;

		switch( msgbuf.Class )
		{
			case IDCMP_CLOSEWINDOW:	close_palette_window(); return;
			case IDCMP_VANILLAKEY:
				if( hook->handle_kbd && hook->handle_kbd( msgbuf.Code ) )
					break;

				if( handle_palette_kbd( msgbuf.Code ) ) return;
				break;
			case IDCMP_MENUPICK:
			{	extern BOOL handle_pref_menu( ULONG );
				struct MenuItem * Item;

				/* Multi-selection of menu entries */
				while( msgbuf.Code != MENUNULL )
					if( (Item = (APTR) ItemAddress( Menu, msgbuf.Code )) )
					{
						if( handle_pref_menu( (ULONG)GTMENUITEM_USERDATA(Item) ) ) return;

						msgbuf.Code = Item->NextSelect;
					}
			}	break;
			case IDCMP_GADGETUP:
				if( hook->handle_gadget )
					hook->handle_gadget( msgbuf.IAddress );
				break;
			case IDCMP_NEWSIZE:
				if( CCWnd->Height > CCWnd->BorderTop )
				{
					ReshapePanel( TGad );
				}
		}
	}
}
