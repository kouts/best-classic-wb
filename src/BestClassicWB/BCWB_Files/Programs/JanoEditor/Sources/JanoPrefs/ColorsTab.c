/*
 * ColorsTab.c : Tabulator handling general token's colors
 * Written by T.Pierron, C.Guillaume, june 23, 2002
 *
 * Free software under GNU public license
 */

#include <libraries/gadtools.h>

#include "Prefs.h"
#include "Catalogs.h"
#include "Jed.h"
#include "Sample.h"
#include "Rawkey.h"
#include "Tabulators.h"
#include "Palette.h"
#include "ProtoTypes.h"

static struct NewGadget NG;
static struct Gadget *  gads[2];
static struct IBox      col_box, ed_box;

static UBYTE ColorIndex = 0; /* Current color index */

struct FontStyle SyntaxPens[] = {
	{0, 1, FS_NORMAL},     {0, 3, FSF_BOLD },
	{3, 4, FSF_BOLD },     {0, 5, FS_NORMAL},
	{0, 7, FSF_BOLD },     {0, 7, FSF_BOLD },
	{0, 5, FS_NORMAL},     {7, 2, FS_NORMAL},
};

static ULONG TokenPens[] = {
	SYSTEM_COLOR(BACKGROUNDPEN), SYSTEM_COLOR(TEXTPEN),     /* Normal text */
	SYSTEM_COLOR(BACKGROUNDPEN), RGB_COLOR(0x44,0x77,0xbb), /* Keywords */
	RGB_COLOR(0x44,0x77,0xbb),   RGB_COLOR(0xee,0x99,0x00), /* Instructions */
	SYSTEM_COLOR(BACKGROUNDPEN), RGB_COLOR(0x22,0x22,0xaa), /* Comments */
	SYSTEM_COLOR(BACKGROUNDPEN), RGB_COLOR(0xcc,0x00,0xff), /* Macros */
	SYSTEM_COLOR(BACKGROUNDPEN), RGB_COLOR(0xff,0x33,0x33), /* Constants */
	SYSTEM_COLOR(BACKGROUNDPEN), RGB_COLOR(0x77,0x00,0xff), /* Special */
	RGB_COLOR(0xff,0x33,0x33),   SYSTEM_COLOR(HIGHLIGHTTEXTPEN), /* Errors */
	PALETTE_COLOR(0),            PALETTE_COLOR(0),          /* All tokens */
};

static ULONG TablePens[ 2*(MAX_TOKENS+1) ];

extern struct TextFont *   font;       /* from JanoPrefs.c */
extern struct IntuiMessage msgbuf;     /* from JanoPrefs.c */

/*
 * Allocate all gadgets for the Colors tab.
 * Attachement and refresh will be carried in JanoPrefs.c
 */
struct Gadget * create_colors_gui( struct IBox * box )
{
	struct Gadget * context = NULL;

	get_correct_pens( TokenPens, TablePens, 2*MAX_TOKENS );

	/* Sync TablePens with SyntaxPens */
	{
		register struct FontStyle * fs  = SyntaxPens;
		register ULONG *            pen = TablePens;

		for( ; pen < EOT(TablePens); pen++, fs++ )
			fs->fs_Bg = *pen++,
			fs->fs_Fg = *pen;
	}

	NG.ng_TopEdge    = box->Top+5;
	NG.ng_LeftEdge   = box->Left;
	NG.ng_Width      = meas_table( TokensTxt ) + 40;
	NG.ng_Height     = font->tf_YSize+6;
	NG.ng_GadgetText = NULL;
	NG.ng_GadgetID   = 1;
	NG.ng_TextAttr   = Scr->Font;
	NG.ng_VisualInfo = Vi;

	/* Create a cycle gadget */
	gads[0] = (APTR) CreateGadget( CYCLE_KIND, CreateContext(&context), &NG,
					GTCY_Labels, TokensTxt, TAG_DONE );

	/* Colorbox */
	col_box.Left   = NG.ng_LeftEdge + NG.ng_Width + 5;
	col_box.Top    = NG.ng_TopEdge;
	col_box.Width  = NG.ng_Height + 15;
	col_box.Height = NG.ng_Height;

	NG.ng_Width      = box->Left + box->Width - (
	NG.ng_LeftEdge   = col_box.Left + col_box.Width + 5);
	NG.ng_GadgetID   = 2;
	NG.ng_GadgetText = CCTxt[0];
	NG.ng_Flags      = PLACETEXT_IN;

	/* Create a button for choosing color */
	gads[1] = (APTR) CreateGadgetA( BUTTON_KIND, gads[0], &NG, (APTR) UseUnderscore );

	/* Box of the token colors sample */
	ed_box.Left   = box->Left;
	ed_box.Height = box->Top + box->Height - (
	ed_box.Top    = NG.ng_TopEdge + NG.ng_Height + 3);
	ed_box.Width  = box->Width;

	return context;
}

/*
 * Render a sample color box
 */
static void render_color_box( BOOL sync_pal )
{
	extern ULONG BoxTags[];

	UWORD right  = col_box.Left + col_box.Width  - 2,
	      bottom = col_box.Top  + col_box.Height - 2;

	struct FontStyle * fs = &SyntaxPens[ ColorIndex ];

	SetAPen(RP, fs->fs_Bg);
	RectFill(RP, col_box.Left + 1, col_box.Top+1, right, bottom);
	SetAPen(RP, fs->fs_Fg);
	RectFill(RP, col_box.Left + 8, col_box.Top+4, right - 7, bottom-3);

	DrawBevelBoxA(
		RP, col_box.Left,  col_box.Top,
		    col_box.Width, col_box.Height, (APTR) BoxTags
	);
	if( sync_pal )
		sync_palette( TokenPens[ ColorIndex*2+1 ] );
}

/*
 * Reflect choices made by user on the sample editor
 */
static void set_tokens_color( ULONG code, ULONG pen )
{
	struct FontStyle * color = SyntaxPens;
	UWORD              index = 1;
	BOOL               draw  = 1;

	if( msgbuf.Qualifier & SHIFTKEYS ) index = 0;

	if( ColorIndex == MAX_TOKENS )
	{
		/* Set all tokens to the same color */
		for( ; color < EOT(SyntaxPens); color ++ )
			(&color->fs_Bg)[ index ] = pen;
	}
	else /* Change only one color */
	{
		color += ColorIndex;
		if( (&color->fs_Bg)[ index ] == pen ) draw = 0;

		(&color->fs_Bg)[ index ] = pen;
	}
	index += ColorIndex * 2;
	{
		ULONG * curcode = TokenPens + index,
		      * curcol  = TablePens + index;

		if( COLOR_TYPE( *curcode ) == RGB_TYPE )
			ReleasePen( Scr->ViewPort.ColorMap, *curcol );

		*curcol = pen; *curcode = code;
	}	
	render_color_box( 0 );
	if( draw ) render_sample_syntax( Wnd, &ed_box, EDIT_AREA );
}

/*
 * Handle messages coming from gadgets, return TRUE if
 * event has been processed.
 */
BOOL handle_colors_tab_gadget( struct Gadget * G )
{
	switch( G->GadgetID )
	{
		case 1:
			ColorIndex = msgbuf.Code;
			render_color_box( 1 );
			break;
		case 2:
			open_palette_window( set_tokens_color, TokenPens[1] );
			break;
		default: return FALSE;
	}
	return TRUE;
}

/*
 * Refresh the Colors tab gui components
 */
void do_colors_action( UWORD code )
{
	switch( code )
	{
		case CODE_REFRESH_GUI:
			set_palette_callback( set_tokens_color );
			render_color_box( 1 );
			render_sample_syntax( Wnd, &ed_box, EDIT_ALL );
			break;
		case CODE_FREE_GUI:
			/* Free allocated pens */
			release_pens( TokenPens, TablePens, 2*(MAX_TOKENS+1) );
	}
}

