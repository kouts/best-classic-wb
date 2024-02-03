/*
 * GeneralTab.c : Tabulator handling general pref management
 * Free software under terms of GNU public license.
 * Written by T.Pierron, C.Guillaume, november 11, 2000.
 */

#define	ASL_V38_NAMES_ONLY
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <graphics/gfxbase.h>

#include "Prefs.h"
#include "Jed.h"
#include "Tabulators.h"
#include "Sample.h"
#include "Palette.h"
#include "ProtoTypes.h"
#include "Catalogs.h"


STRPTR FSCycTxt[5];       /* Strings for Font style gadget */
UBYTE  CB_state[CBS];     /* States of check box gadgets */

/*
 * Tag list for various gadget
 */
ULONG IntTags[]      = {GTST_String,0, GTST_MaxChars,10,         TAG_MORE, (ULONG) UseUnderscore};
ULONG SepTags[]      = {GTST_String,0, GTST_MaxChars,MAX_STRBUF, TAG_MORE, (ULONG) UseUnderscore};
ULONG RecentTags[]   = {GTST_String,0, GTST_MaxChars,MAX_STRBUF, TAG_MORE, (ULONG) UseUnderscore};
ULONG TextFontTags[] = {GTCY_Labels, (ULONG)FTCycTxt,  GTCY_Active,0, TAG_DONE};
ULONG ScrFontTags[]  = {GTCY_Labels, (ULONG)FSCycTxt,  GTCY_Active,0, TAG_DONE};
ULONG ScrMdTags[]    = {GTCY_Labels, (ULONG)ScrCycTxt, GTCY_Active,0, TAG_DONE};
ULONG ColorTags[]    = {GTCY_Labels, (ULONG)ColCycTxt, GTCY_Active,0, TAG_DONE};

/*
 * Some tables to easily initialize our gadgets
 */
static struct GadgetKind GadInfo[] = {
	{IntTags,     STRING_KIND},   {SepTags,      STRING_KIND},
	{RecentTags,  STRING_KIND},   {TextFontTags, CYCLE_KIND },
	{ScrFontTags, CYCLE_KIND },   {ScrMdTags,    CYCLE_KIND },
};

/*
 * Gadtools gadget buffer
 */
static struct NewGadget NG;
static struct Gadget *  gads[CBS+CGS];
static struct IBox      col_box;
static UBYTE            IntBuf[4];

/*
 * Various gadget state buffer.
 */
ULONG  extended   = 0;    /* Which cycle gadget are extended */
UBYTE  ColorIndex = 0;    /* Current color index selected */
UBYTE  StrInfo[60];       /* Fonts and display information */
WORD   MiscLength,        /* Various gadget length */
       CBLength,
       FontCycLength,
       ColorLength,
       ScreenLength,
       ScrInfo[3];

extern struct TextFont *   font;       /* from JanoPrefs.c */
extern struct IntuiMessage msgbuf;     /* from JanoPrefs.c */
extern struct GfxBase *    GfxBase;    /* from JanoPrefs.c */
extern UBYTE               Modif[];    /* from Prefs.c */

/*
 * Init static tables that have same entries
 */
static void init_static_tables( void )
{
	/* Setup inital tags */
	ScrMdTags[3] = ScrFontTags[3] = TextFontTags[3] = 0;
	extended     = 0;

	/* Fucking INTERGER_KIND causes memory leaks */
	{
		UWORD tabsize = prefs.tabsize;
		my_snprintf( IntBuf, sizeof(IntBuf), "%d", &tabsize);
	}
	IntTags[1] = (ULONG) IntBuf;
	SepTags[1] = (ULONG) prefs.wordssep;
	RecentTags[1] = (ULONG) prefs.recentfile;

	if( prefs.use_txtfont )
	{
		/* Show text area font name */
		font_info(StrInfo, prefs.txtfont);
		TextFontTags[1] = (ULONG) FTCycTxt;
		extended       |= EXTENDED_TXTFONT;
	}
	else TextFontTags[1] = (ULONG) (FTCycTxt+1);

	if( prefs.use_scrfont )
	{
		font_info(StrInfo+20, prefs.scrfont);
		ScrFontTags[1] = (ULONG) FSCycTxt;
		extended      |= EXTENDED_SCRFONT;
	}
	else ScrFontTags[1] = (ULONG) (FSCycTxt+1);

	if( prefs.use_pub == 1 )
	{
		ScrInfo[0] = Scr->Width;
		ScrInfo[1] = Scr->Height;
		ScrInfo[2] = Scr->RastPort.BitMap->Depth;
		scr_info(StrInfo+40, ScrInfo);
		ScrMdTags[1] = (ULONG) ScrCycTxt;
		extended    |= EXTENDED_SCREEN;
	}
	else /* Clone or Use parent */
	{
		ScrMdTags[1] = (ULONG) (ScrCycTxt+1);
		if( prefs.use_pub != 2 ) ScrMdTags[3] = 1; /* Clone */
	}
	/* Checkbox states */
	CopyMem(&prefs.backdrop, CB_state, CBS);
}

/*
 * User requested a certain window dimension, this function
 * will be called for this tab to see if it's not too small.
 */
void adjust_general_box( struct IBox * box )
{
	UWORD min_width, min_height;

	CopyMem( FTCycTxt,   FSCycTxt,    sizeof(FSCycTxt) );
	CopyMem( FTCycTxt+1, ScrCycTxt+2, sizeof(STRPTR) * 2 );

	FTCycTxt[0]  = StrInfo;
	FSCycTxt[0]  = StrInfo+20;
	ScrCycTxt[0] = StrInfo+40;

	/* Compute window width and height */
	MiscLength    = meas_table(MiscTxt);
	CBLength      = meas_table(ChkTxt);
	FontCycLength = meas_table(FSCycTxt);
	ColorLength   = meas_table(ColCycTxt);
	ScreenLength  = meas_table(ScrCycTxt);

	if(FontCycLength < ScreenLength)
		FontCycLength = ScreenLength;

	min_width  = MiscLength + FontCycLength + CBLength + 110;
	min_height = font->tf_YSize * 9 + (24 + SAMPLE_HEIGHT);

	if( min_width  > box->Width  ) box->Width  = min_width;
	if( min_height > box->Height ) box->Height = min_height;
}

/*
 * Allocate all gadgets for the general tab of the gui.
 * Attachement and refresh will be carried in JanoPrefs.c
 */
struct Gadget * create_general_gui( struct IBox * box )
{
	struct Gadget ** gadgets        = gads;
	struct Gadget *  gadget_context = NULL;
	struct Gadget *  pgadget;
	WORD             i, top, median;

	init_static_tables();

	pgadget = (struct Gadget *) CreateContext(&gadget_context);

	median = box->Left + box->Width - CBLength - (CHECKBOX_WIDTH+20);

	NG.ng_TopEdge    = box->Top+5;
	NG.ng_LeftEdge   = MiscLength + 10 + box->Left;
	NG.ng_Width      = median - NG.ng_LeftEdge;
	NG.ng_Height     = font->tf_YSize+6;
	NG.ng_Flags      = PLACETEXT_LEFT | NG_HIGHLABEL;
	NG.ng_TextAttr   = Scr->Font;
	NG.ng_VisualInfo = Vi;

	/* Create left column of gadgets (integer, string & cycle) */
	for( i = 0; i < CGS; i++, NG.ng_TopEdge += NG.ng_Height )
	{
		NG.ng_GadgetText = MiscTxt[i];
		NG.ng_GadgetID   = i;
		pgadget = (struct Gadget *) CreateGadgetA( GadInfo[i].gi_Type, pgadget,
				&NG, (APTR) GadInfo[i].gi_Tags );

		*gadgets++ = pgadget;
	}
	top = NG.ng_TopEdge + 3;

	/* Create right column of gads (checkboxes) */
	NG.ng_TopEdge  = box->Top  +  5;
	NG.ng_LeftEdge = median + 10;
	NG.ng_Width    = NG.ng_Height -= 2;
	NG.ng_Flags    = PLACETEXT_RIGHT;

	for( ; i < CGS+CBS; i++, NG.ng_TopEdge += NG.ng_Height )
	{
		NG.ng_GadgetText = ChkTxt[i-CGS];
		NG.ng_GadgetID   = i;
		pgadget = (struct Gadget *) CreateGadget( CHECKBOX_KIND, pgadget,
				&NG, GTCB_Checked, CB_state[i-CGS], TAG_MORE, UseUnderscore );

		/* If user has choosen a pubscreen, disable backdroped window */
		if(i == CGS && prefs.use_pub == 0)
			pgadget->Flags |= GFLG_DISABLED;

		*gadgets++ = pgadget;
	}

	/* Cycle color chooser */
	NG.ng_TopEdge    = top;
	NG.ng_Width      = ColorLength + 40;
	NG.ng_GadgetText = NULL;
	NG.ng_GadgetID   = 100;
	NG.ng_LeftEdge   = box->Left;
	pgadget = (APTR) CreateGadgetA(CYCLE_KIND, pgadget, &NG, (APTR) ColorTags);

	/* Color preview box */
	col_box.Left   = NG.ng_LeftEdge + NG.ng_Width + 10;
	col_box.Width  = NG.ng_Height + 15;
	col_box.Height = NG.ng_Height;
	col_box.Top    = NG.ng_TopEdge;

	/* Button for choosing color */
	NG.ng_Width      = box->Width + 10 - (
	NG.ng_LeftEdge   = col_box.Left + col_box.Width + 10);
	NG.ng_GadgetID   = 101;
	NG.ng_GadgetText = CCTxt[0];
	NG.ng_Flags      = PLACETEXT_IN;
	CreateGadgetA(BUTTON_KIND, pgadget, &NG, (APTR) UseUnderscore);

	/* Initiate sample editor to see colors adjustement */
	top += NG.ng_Height + 5;
	{
		struct IBox sample_box;
		sample_box.Left   = box->Left;
		sample_box.Top    = top;
		sample_box.Width  = box->Width;
		sample_box.Height = box->Height - (top - box->Top);

		init_sample( &sample_box, &prefs );
	}
	return gadget_context;
}

/* Show current color that is using an item */
static void render_color_preview( BOOL sync_pal )
{
	extern ULONG BoxTags[];

	SetAPen( RP, (&pen.bg)[ ColorIndex ] );

	RectFill( RP, col_box.Left + 1, col_box.Top + 1, col_box.Left + col_box.Width -
	          2, col_box.Top + col_box.Height - 2 );

	DrawBevelBoxA(
		RP, col_box.Left,  col_box.Top,
		    col_box.Width, col_box.Height, (APTR) BoxTags
	);
	if( sync_pal )
		sync_palette( (&prefs.pen.bg)[ ColorIndex ] );
}

/*
 * Reflect color choosen by user in sample editor
 */
static void set_general_color( ULONG code, ULONG color )
{
	ULONG * curcode = &prefs.pen.bg + ColorIndex,
	      * curcol  = &pen.bg       + ColorIndex;

	if( *curcol != color )
	{
		if( COLOR_TYPE( *curcode ) == RGB_TYPE )
			ReleasePen( Scr->ViewPort.ColorMap, *curcol );
		*curcol  = color;
		*curcode = code;
		render_color_preview(0);
		render_sample( Wnd, Modif[ ColorIndex ] );
	}
}

/*
 * Refresh the General tab gui components
 */
void do_general_action( UWORD code )
{
	switch( code )
	{
		case CODE_REFRESH_GUI:
			set_palette_callback( set_general_color );
			render_color_preview( 1 );
			render_sample( Wnd, EDIT_ALL );
			break;
		case CODE_FREE_GUI:
			/* Free allocated pens */
			release_pens( &prefs.pen.bg, &pen.bg, sizeof(pen)/sizeof(pen.bg) );
			/* Flush content of some gadget that may not be confirmed */
			prefs.tabsize = atoi(GetSI(gads[0])->Buffer);
			strcpy(prefs.wordssep,   GetSI(gads[1])->Buffer);
			strcpy(prefs.recentfile, GetSI(gads[2])->Buffer);
			/* Then free memory allocated here */
			free_sample();
	}
}

/*
 * Performs some checks on what user has enterred
 */
void check_tab( struct Gadget * G )
{
	LONG buf;

	if( StrToLong( GetSI(G)->Buffer, &buf ) == -1 )
	{
		DisplayBeep(NULL);
		ActivateGadget(G, Wnd, NULL);
	}
}

/*
 * Handle messages coming from gadgets, return TRUE if
 * event has been processed.
 */
BOOL handle_general_tab_gadget( struct Gadget * G )
{
	struct TextFont *newfont;
	static UBYTE useit[]={1,2,0,1};
	LONG  Code;

	switch( G->GadgetID )
	{
		case 0:  /* Check tabulation */
			check_tab( G );
			break;
		case 3:  /* Changing default text font */
			Code = msgbuf.Code; if(extended & 1) Code--;
			if(Code <= 0)
			{
				if( !(prefs.use_txtfont = (Code==-1)) )
					/* User want to use the default text font */
					text_to_attr(prefs.txtfont=GfxBase->DefaultFont, &prefs.attrtxt);
				else
					if( (newfont = get_old_font(FTCycTxt[0])) )
						text_to_attr(prefs.txtfont=newfont, &prefs.attrtxt);
					else { ThrowError(Wnd, ErrMsg(ERR_LOADFONT)); break; }
				render_sample(Wnd, EDIT_AREA);
				break;
			}
			else if( (newfont = change_fonts(&prefs.attrtxt, Wnd, TRUE)) )
			{
				/* User want to change the text font */
				if( prefs.txtfont ) CloseFont(prefs.txtfont);
				font_info(StrInfo, prefs.txtfont = newfont );
				TextFontTags[1] = (ULONG) FTCycTxt; extended |= 1;
				prefs.use_txtfont = TRUE;
				TextFontTags[3] = 0;
			}
			/* else we must reset the original cycle gadget entry */
			GT_SetGadgetAttrsA(G, Wnd, NULL, (APTR) TextFontTags);
			render_sample(Wnd, EDIT_AREA);
			break;
		case 4:  /* Changing default screen font */
			Code = msgbuf.Code; if(extended & 2) Code--;
			if(Code <= 0)
			{
				if( !(prefs.use_scrfont = (Code==-1)) )
					/* User want to use default screen font */
					text_to_attr(prefs.scrfont=prefs.parent->RastPort.Font, &prefs.attrscr);
				else
					if( (newfont = get_old_font(FSCycTxt[0])) )
						text_to_attr(prefs.scrfont=newfont, &prefs.attrscr);
					else { ThrowError(Wnd, ErrMsg(ERR_LOADFONT)); break; }

				render_sample(Wnd, EDIT_ALL);
				break;
			}
			else if( (newfont = change_fonts(&prefs.attrscr, Wnd, FALSE)) )
			{
				/* User want to change the screen font */
				if( prefs.scrfont ) CloseFont(prefs.scrfont);
				font_info(StrInfo+20, prefs.scrfont = newfont );
				ScrFontTags[1] = (ULONG) FSCycTxt; extended |= 2;
				prefs.use_scrfont = TRUE;
				ScrFontTags[3] = 0;
			}
			GT_SetGadgetAttrsA(G, Wnd, NULL, (APTR) ScrFontTags);
			render_sample(Wnd, EDIT_ALL);
			break;
		case 5:  /* Change screen mode/type */
			Code = msgbuf.Code; if(extended & 4) Code--;
			if(Code > 1)
			{
				/* User want to use a pubscreen instead of workbench screen */
				if((Code = change_screen_mode(ScrInfo, prefs.modeid)) != INVALID_ID)
				{
					prefs.depth  = ScrInfo[2];
					prefs.modeid = Code;
					ScrMdTags[1] = (ULONG) ScrCycTxt;
					ScrMdTags[3] = 0;
					scr_info(StrInfo+40, ScrInfo);
					prefs.use_pub = TRUE; extended |= 4;
				} else ScrMdTags[3] = useit[ prefs.use_pub+1 ];
				GT_SetGadgetAttrsA(G, Wnd, NULL, (APTR) ScrMdTags);
			}
			else prefs.use_pub = useit[Code+1];
			/*
			 * If user want to use a pubscreen, then disable backdrop checkbox
			 * It is not recommended to use a backdrop'ed window on a such scr
			 */
			if( prefs.use_pub )
				OnGadget  (gads[CGS], Wnd, NULL);
			else
				OffGadget (gads[CGS], Wnd, NULL);
			break;
		case CGS:   case CGS+1:	/* Checkbuttons */
		case CGS+2: case CGS+3:
			(&prefs.backdrop)[G->GadgetID-CGS] = ((G->Flags & GFLG_SELECTED) == GFLG_SELECTED);
			break;
		case 100: /* Cycle color */
			ColorIndex = msgbuf.Code;
			render_color_preview( 1 );
			break;
		case 101: /* Palette chooser */
			open_palette_window( set_general_color, (&prefs.pen.bg)[ ColorIndex ] );
			break;
		default:
			return FALSE;
	}
	return TRUE;
}

/*
 * Process keyboard shortcut for general tabulator
 * Return TRUE if shortcut has been processed
 */
BOOL handle_general_kbd( UWORD code )
{
	switch( code )
	{
		case '\t': case 't': case 'T':
			GetSI(gads[0])->BufferPos = GetSI(gads[0])->MaxChars;
			ActivateGadget(gads[0], Wnd, NULL); break;
		case 'r': case 'R':
			ActivateGadget(gads[2], Wnd, NULL); break;
		case 'b': code = 0; goto case_toggle;
		case 'v': code = 1; goto case_toggle;
		case 'i': code = 2; goto case_toggle;
		case 'e': code = 3;
		case_toggle:
			GT_SetGadgetAttrs(gads[CGS+code], Wnd, NULL,
						GTCB_Checked, (&prefs.backdrop)[code] ^= 1, TAG_DONE);
			break;
		default:
			return FALSE;
	}
	return TRUE;
}

/*
 * Update gui components, if preference file has changed (setting
 * default prefs, loading new file or resetting last saved one).
 */
void update_general_gui( struct Window * Wnd, Prefs old, Prefs new )
{
	register int i, col;

	init_static_tables();

	/* Tabulations, Words separator, recent file */
	GT_SetGadgetAttrs(gads[0], Wnd, NULL, GTST_String, IntBuf,          TAG_DONE);
	GT_SetGadgetAttrs(gads[1], Wnd, NULL, GTST_String, new->wordssep,   TAG_DONE);
	GT_SetGadgetAttrs(gads[2], Wnd, NULL, GTST_String, new->recentfile, TAG_DONE);

	/* Text font, Screen font, Screen type */
	GT_SetGadgetAttrsA(gads[3], Wnd, NULL, (APTR) TextFontTags);
	GT_SetGadgetAttrsA(gads[4], Wnd, NULL, (APTR) ScrFontTags);
	GT_SetGadgetAttrsA(gads[5], Wnd, NULL, (APTR) ScrMdTags);

	for( i = 0; i < CBS; i++ )
		GT_SetGadgetAttrs(gads[CGS+i], Wnd, NULL, GTCB_Checked, (&new->backdrop)[i], TAG_DONE);

	if( Wnd )
	{
		for( col = i = 0; i < sizeof(new->pen); i++ )
			if( (&new->pen.bg)[i] != (&old->pen.bg)[i] ) col |= Modif[i];

		if(old->scrfont != new->scrfont) col |= EDIT_GUI;
		if(old->txtfont != new->txtfont) col |= EDIT_AREA;
		render_sample(Wnd, col);
	}
}

