/*
 * SyntaxTab.c : Tabulator handling general syntax file association
 * Written by T.Pierron, C.Guillaume, june 23, 2002
 *
 * Free software under GNU public license
 */

#include <libraries/gadtools.h>

#include "Prefs.h"
#include "Jed.h"
#include "Tabulators.h"
#include "ProtoTypes.h"
#include "Utils.h"

static struct NewGadget NG;
static struct Gadget *  gads[5];

extern struct TextFont *   font;       /* from JanoPrefs.c */
extern struct IntuiMessage msgbuf;     /* from JanoPrefs.c */

/*
 * Allocate all gadgets for the syntax tab.
 * Attachement and refresh will be carried in JanoPrefs.c
 */
struct Gadget * create_syntax_gui( struct IBox * box )
{
	struct Gadget * gadget_context = NULL;

	NG.ng_TopEdge    = box->Top+5;
	NG.ng_LeftEdge   = box->Left;
	NG.ng_Width      = box->Width - 5 - (
	NG.ng_Height     = font->tf_YSize+6);
	NG.ng_Flags      = PLACETEXT_LEFT | NG_HIGHLABEL;
	NG.ng_GadgetText = AddRemTxt[-1];
	NG.ng_GadgetID   = 1;
	NG.ng_TextAttr   = Scr->Font;
	NG.ng_VisualInfo = Vi;

	/* Create a string gadget */
	gads[0] = (APTR) CreateGadget( STRING_KIND, CreateContext(&gadget_context), &NG,
					GTST_MaxChars, 256, GTST_String, "S:JanoSyntaxDB",
					TAG_MORE, UseUnderscore );

	NG.ng_LeftEdge  += NG.ng_Width + 5;
	NG.ng_Width      = NG.ng_Height;
	NG.ng_GadgetText = "?";
	NG.ng_GadgetID   = 2;
	NG.ng_Flags      = 0;

	/* A question-marked gadget */
	gads[1] = (APTR) CreateGadgetA( BUTTON_KIND, gads[0], &NG, NULL );

	NG.ng_TopEdge   += NG.ng_Height + 3;
	NG.ng_LeftEdge   = box->Left;
	NG.ng_Width      = box->Width;
	NG.ng_Height     = box->Height - 2 * NG.ng_Height - 6;
	NG.ng_GadgetText = NULL;
	NG.ng_GadgetID   = 3;

	/* Create a listview gadget */
	gads[2] = (APTR) CreateGadget( LISTVIEW_KIND, gads[1], &NG,
					GTLV_ShowSelected, NULL,
					GTLV_Selected,     0,    TAG_DONE);

	NG.ng_TopEdge += gads[2]->Height + 2;
	NG.ng_Width    = meas_table(AddRemTxt) + 40;
	NG.ng_Height   = font->tf_YSize + 4;

	/* Add / Remove gadgets */
	NG.ng_GadgetText = AddRemTxt[0];
	NG.ng_GadgetID   = 4;

	gads[3] = (APTR) CreateGadgetA(BUTTON_KIND, gads[2], &NG, (APTR) UseUnderscore);

	NG.ng_LeftEdge  += box->Width - NG.ng_Width;
	NG.ng_GadgetText = AddRemTxt[1];
	NG.ng_GadgetID   = 5;

	gads[4] = (APTR) CreateGadgetA(BUTTON_KIND, gads[3], &NG, (APTR) UseUnderscore);

	return gadget_context;
}

/*
 * Handle messages coming from gadgets, return TRUE if
 * event has been processed.
 */
BOOL handle_syntax_tab_gadget( struct Gadget * G )
{
	switch( G->GadgetID )
	{
		case 2:
			G = gads[0];
			if( choose_file( GetSI(G)->Buffer, GetSI(G)->MaxChars ) )
				RefreshGList( G, Wnd, NULL, 1);
			break;
		case 1:
		case 3:
		case 4:
		case 5: break;
		default: return FALSE;
	}
	return TRUE;
}

/*
 * Process keyboard shortcut for syntax tabulator
 * Return TRUE if shortcut has been processed
 */
BOOL handle_syntax_kbd( UWORD code )
{
	switch( code )
	{
		case 'd':
			ActivateGadget(gads[0], Wnd, NULL); break;
		case '?':
			handle_syntax_tab_gadget( gads[1] ); break;
		case 'a':
		case '\b':
		case 127: break;
		default: return FALSE;
	}
	return TRUE;
}

#if	0
/*
 * Window where user can modify/add a new syntax parser
 */
static struct Gadget * pgads[6], * first = NULL;

static BOOL modify_syntax_parser( struct SynParser * parser )
{
	WORD height = 5 * font->tf_YSize + 60,
	     top    = Wnd->BorderTop + 5,
	     left   = 20 + meas_table(SynModify),
	     width  = Wnd->Width - 10 - left;

	NG.ng_TopEdge    = top;
	NG.ng_LeftEdge   = left;
	NG.ng_Width      = width;
	NG.ng_Height     = font->tf_YSize+6;
	NG.ng_Flags      = PLACETEXT_LEFT;
	NG.ng_GadgetText = SynModify[0];
	NG.ng_GadgetID   = 1;

	/* String gadget for language name */
	gads[0] = (APTR) CreateGadget( STRING_KIND, CreateContext(&first), &NG,
					GTST_MaxChars, sizeof(parser->syn_name), GTST_String, parser->syn_name,
					TAG_MORE, UseUnderscore );

	/* Pattern recognition of file */
	NG.ng_TopEdge   += NG.ng_Height + 2;
	NG.ng_GadgetText = SynModify[1];
	NG.ng_GadgetID   = 2;
	NG.ng_Flags      = PLACETEXT_LEFT | NG_HIGHLABEL;;

	gads[1] = (APTR) CreateGadget( STRING_KIND, gads[0], &NG,
					GTST_MaxChars, sizeof(parser->syn_pattern), GTST_String, parser->syn_pattern,
					TAG_MORE, UseUnderscore );

	NG.ng_TopEdge   += NG.ng_Height + 2;
	NG.ng_Width     -= NG.ng_Height - 5;
	NG.ng_GadgetText = SynModify[2];
	NG.ng_GadgetID   = 3;

	/* String gadget for syntax file */
	gads[2] = (APTR) CreateGadget( STRING_KIND, gads[1], &NG,
					GTST_MaxChars, sizeof(parser->syn_file), GTST_String, parser->syn_file,
					TAG_MORE, UseUnderscore );

	/* Question mark for chosing a path */
	NG.ng_LeftEdge  += NG.ng_Width + 5;
	NG.ng_Width      = NG.ng_Height;
	NG.ng_GadgetText = "?";
	NG.ng_GadgetID   = 4;
	NG.ng_Flags      = 0;

	gads[3] = (APTR) CreateGadgetA( BUTTON_KIND, gads[2], &NG, NULL );

	/* Use / Cancel gadgets */
	NG.ng_TopEdge   += NG.ng_Height + 2;
	NG.ng_LeftEdge   = 10;
	NG.ng_Width      = meas_table( OkCanSav+1 ) + 40;
	NG.ng_GadgetText = OkCanSav[1];
	NG.ng_GadgetID   = 5;

	gads[4] = (APTR) CreateGadgetA( BUTTON_KIND, gads[3], &NG, UseUnderscore );

	NG.ng_Width      = Wnd->Width - NG.ng_Width - 10;
	NG.ng_GadgetText = OkCanSav[2];
	NG.ng_GadgetID   = 6;

	gads[5] = (APTR) CreateGadgetA( BUTTON_KIND, gads[4], &NG, UseUnderscore );
}
#endif
