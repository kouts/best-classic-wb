/*********************************************************
** Search.c: Implementation of `Search' menu commands.  **
** (Search/replace/goto/bracket match)                  **
** Written by T.Pierron, aug 5, 2000                    **
*********************************************************/

#include <intuition/intuition.h>
#include <intuition/sghooks.h>
#include <libraries/gadtools.h>
#include <utility/hooks.h>
#include "Project.h"
#include "Gui.h"
#include "Jed.h"
#include "Search.h"
#include "Edit.h"
#include "Utility.h"
#include "Events.h"
#include "ProtoTypes.h"

#define  CATCOMP_NUMBERS
#include "Jed_Strings.h"

static struct Window *swin = NULL;        /* Main search/replace window */
static struct Gadget *sgads,*sg;          /* Gadtool's gadgets */
static struct Gadget *rep=NULL,*search;   /* Specific gadtools gadgets */
extern struct IntuiMessage *msg,msgbuf;   /* For collecting events */

ULONG  swinsig = 0;
struct NewWindow NewSWin =
{
	0,0,0,0, 1,1,					/* LE,TE,Wid,Hei, Pens */
	IDCMP_MENUPICK   | IDCMP_CLOSEWINDOW | IDCMP_GADGETUP   | IDCMP_NEWSIZE | IDCMP_VANILLAKEY,
	WFLG_CLOSEGADGET | WFLG_NEWLOOKMENUS | WFLG_DEPTHGADGET | WFLG_ACTIVATE | WFLG_SMART_REFRESH |
	WFLG_DRAGBAR,
	NULL,								/* FirstGadget */
	NULL,								/* CheckMark */
	NULL,								/* Title */
	NULL,								/* Screen */
	NULL,								/* BitMap */
	100, 50, 0xffff, 0xffff,	/* Min & Max size */
	CUSTOMSCREEN
};

WORD  SWinZoom[4];
ULONG SWinTags[] = {
	WA_Zoom,(ULONG)SWinZoom,
	WA_NewLookMenus,TRUE,
	TAG_DONE
};

ReviewBuf search_rb  = NULL;
ReviewBuf replace_rb = NULL;
UBYTE     CharClass[256];

#define	STRING_BUFFER		(MAX_REVIEW_BUF/2)

static struct Hook hook;

char HilitePattern( Project, STRPTR, BYTE, BYTE quiet );

/** Values for `quiet' parameter **/
#define	VERBOSE                 0      /* Move cursor and show warnings */
#define	VERB_BUT_NO_HIDE_CURS   1      /* Cursor has been already moved */
#define	FULLY_QUIET             2      /* Just internally move cursor */
#define	QUIET_BUT_WARN          3      /* Warn if pattern not found */

/*** Init search table for faster text scan ***/
BOOL init_searchtable( void )
{
	static UBYTE UpClassEqv[] =
		"a¿¡¬√ƒ≈‡·‚„‰Â" "e»… ÀËÈÍÎ" "iÃÕŒœÏÌÓÔ" "nÒ—"
		"o“”‘’÷ÚÛÙıˆ¯ÿ" "uŸ⁄€‹˘˙˚¸" "y˝ˇ"       "cÁ«";
	STRPTR p;
	UWORD  i;

	/* Init character class equivalence table */
	for (p=CharClass, i=0; i<256; *p++ = i++);
	for (p=CharClass + (i='A'); i<='Z'; *p++ = i+('a'-'A'), i++);
	for (p=UpClassEqv; *p; p++)
		if(*p < 128) i = *p; else CharClass[ *p ] = i;

	/* Review buffer */
	search_rb  = AllocVec( sizeof(*search_rb)*2, MEMF_PUBLIC | MEMF_CLEAR );
	replace_rb = search_rb+1;

	return search_rb != NULL;
}

/** Special hook executed while editing a line **/
ULONG CheckConfirm( struct Hook *hook, struct SGWork *sgw, ULONG *msg )
{
	if(*msg == SGH_KEY)
	{
		if( sgw->Code == 27 )
			sgw->Code = 0, sgw->Actions |= SGA_END;
		else if( sgw->EditOp == EO_ENTER )
			sgw->Code = (sgw->Actions & (SGA_NEXTACTIVE | SGA_PREVACTIVE) ? 0 : 1);
		else if( sgw->IEvent->ie_Class == IECLASS_RAWKEY )
		{
			BYTE dir;
			switch( sgw->IEvent->ie_Code )
			{
				case CURSORUP:   dir = -1; goto after;
				case CURSORDOWN: dir =  1; after:
					sgw->BufferPos = sgw->NumChars = 
						GetPrevNextBuffer( sgw->Gadget->UserData, sgw->WorkBuffer, STRING_BUFFER, dir),
					sgw->Actions |= SGA_USE | SGA_REDISPLAY;
			}
		}
	}
	else return 0;
	return ~0;
}

/*** Open an asynchronous GUI for searching/replacing string ***/
BYTE setup_winsearch( Project p, UBYTE replace )
{
	extern ULONG  HookEntry();
	static struct NewGadget NG;
	static ULONG  SGadTags[] = {
		GTCB_Checked,  0,
		GTST_MaxChars, STRING_BUFFER,
		GT_Underscore, '_',
		TAG_DONE
	};
	WORD Wid[6];

	/* If window is already opened, but isn't to the required type */
	if( (rep ? 0:1) == replace )
		close_searchwnd(TRUE);
	else if( swin )
	{
		ActivateWindow(swin);
		WindowToFront(swin);
		/* Uniconified it, if needed */
		if(swin->Height<=swin->BorderTop) ZipWindow(swin);
		/* Copy selected part of text in string gadget */
		if(p->ccp.select)
			GetSI(search)->BufferPos = copy_mark_to_buf(p,GetSI(search)->Buffer,GetSI(search)->MaxChars),
			unmark_all(p,FALSE), inv_curs(p,TRUE);
		ActivateGadget(search, swin, NULL);
		return TRUE;
	}

	/** Compute optimal window width **/
	{
		register WORD     len, sum, *wid;
		register STRPTR * str;
		for(str=SWinTxt+(replace ? 6:8), sum=0, wid=Wid; *str; str++)
		{
			len=TextLength(&RPT,*str,strlen(*str))+20;
			if( replace ) *wid++ = len, sum += len;
			else if( sum < len ) sum = len;
		}
		/* Minimal width of 320 pixels */
		if(replace == 0) {
			if(sum < (320-50)/4) sum = (320-50)/4;
			len = sum*4+50;
			Wid[0] = sum;
		} else len = sum + 70;
		NewSWin.Width = len;
	}
	/* Window too large ? */
	if(NewSWin.Width > Scr->Width) NewSWin.Width = Scr->Width;
	NewSWin.Height   = Scr->BarHeight + (replace ?
		prefs.scrfont->tf_YSize * 4 + 40 :
		prefs.scrfont->tf_YSize * 3 + 32);
	NewSWin.LeftEdge = (Scr->Width - NewSWin.Width) / 2;
	NewSWin.Screen   = Scr;
	NewSWin.Title    = SWinTxt[replace ? 1 : 0];

	/** Compute iconified window dimensions **/
	SWinZoom[2] = TextLength(&RPT,NewSWin.Title,strlen(NewSWin.Title))+100;
	SWinZoom[0] = Scr->Width-SWinZoom[2]-gui.depthwid;
	SWinZoom[3] = Scr->BarHeight+1;
	SWinZoom[1] = 0;

	/* Let the cursor visible */
	if( (NewSWin.TopEdge = Wnd->TopEdge + p->ycurs + 10)+NewSWin.Height > Scr->Height )
		NewSWin.TopEdge = 50;

	/* Setting up GUI */
	if( (swin = (APTR) OpenWindowTagList(&NewSWin, (APTR) SWinTags)) )
	{
		UWORD I;
		rep = search = sgads = NULL;
		sg = (APTR) CreateContext(&sgads);
		swin->UserData = NewSWin.Title;

		/* Init strgad hook (v37+ only) */
		hook.h_Entry    = HookEntry;
		hook.h_SubEntry = CheckConfirm;

		/* `Search' string gadget */
		if( (NG.ng_LeftEdge = TextLength(&RPT,SWinTxt[2],strlen(SWinTxt[2]))) <
		    (I              = TextLength(&RPT,SWinTxt[3],strlen(SWinTxt[3]))) )
			NG.ng_LeftEdge = I;
		NG.ng_TopEdge    = swin->BorderTop+5;
		NG.ng_Width      = swin->Width - 10 - (NG.ng_LeftEdge += 20);
		NG.ng_Height     = prefs.scrfont->tf_YSize+6;
		NG.ng_Flags      = PLACETEXT_LEFT;
		NG.ng_TextAttr   = &prefs.attrscr;
		NG.ng_VisualInfo = Vi;
		NG.ng_GadgetText = SWinTxt[2];
		NG.ng_GadgetID   = 0;

		search = sg = (APTR) CreateGadget( STRING_KIND, sg, &NG,
			GTST_EditHook, &hook,
			TAG_MORE,      SGadTags+2
		);
		search->UserData = search_rb;
		/* Copy part of selected text in the `Search' strgad */
		if(p->ccp.select)
		{
			GetSI(sg)->BufferPos = copy_mark_to_buf( p, GetSI(sg)->Buffer, GetSI(sg)->MaxChars );
			unmark_all( p, FALSE );
			inv_curs( p, TRUE );
		}
		else /* Copy the last registered search string */
		{
			GetSI(sg)->BufferPos = my_StrnCpy( GetLastBuffer( search_rb, TRUE ), 
				GetSI(sg)->Buffer, STRING_BUFFER );
		}
		/* `Replace' string gadget */
		if( replace )
		{
			NG.ng_TopEdge += NG.ng_Height+2;
			NG.ng_GadgetText = SWinTxt[3];
			NG.ng_GadgetID = 1;
			rep = sg = (APTR) CreateGadget( STRING_KIND, sg, &NG,
					GTST_EditHook, &hook,
					GTST_String,   GetLastBuffer( replace_rb, TRUE ),
					TAG_MORE,      SGadTags+2
			);
			rep->UserData = replace_rb;
		}

		/** Check box gadgets **/
		NG.ng_TopEdge += NG.ng_Height+4;
		for(NG.ng_LeftEdge = 10, I=4; I<6; I++)
		{
			NG.ng_Flags      = (I&1 ? PLACETEXT_LEFT : PLACETEXT_RIGHT);
			NG.ng_GadgetText = SWinTxt[I];
			NG.ng_GadgetID   = I;
			SGadTags[1]      = (&prefs.matchcase)[I-4];
			sg = (void *) CreateGadgetA(CHECKBOX_KIND, sg, &NG, (struct TagItem *)SGadTags);
			sg->LeftEdge     = (I&1 ? swin->Width-10-sg->Width : 10);
			if(I&1) NG.ng_TopEdge += NG.ng_Height;
		}

		/** Bottom row of gadget ([Replace/Replace All/]Search/Previous/Use/Cancel) **/
		NG.ng_TopEdge += 3;
		NG.ng_Flags    = PLACETEXT_IN;
		NG.ng_Height  -= 2;
		if(replace == 0) I+=2;
		for(NG.ng_LeftEdge = 10; I<12; I++)
		{
			NG.ng_Width = (replace ? Wid[I-6] : Wid[0]);
			NG.ng_GadgetText = SWinTxt[I];
			NG.ng_GadgetID   = I;
			sg = (void *) CreateGadgetA(BUTTON_KIND, sg, &NG, (struct TagItem *)(SGadTags+4));
			NG.ng_LeftEdge  += NG.ng_Width+10;
		}

		/** Finally, add gadgets into the window **/
		AddGList(swin, sgads, -1, -1, NULL);
		RefreshGList(sgads, swin, NULL, -1);
		SetMenuStrip(swin, Menu);
		ActivateGadget(search, swin, NULL);

		/** Register window's signal bit **/
		swinsig = 1 << swin->UserPort->mp_SigBit;
		recalc_sigbits();
		return TRUE;
	}
	else ThrowError(Wnd, ErrMsg(ERR_NOMEM));
	return FALSE;
}

/* Free all allocated ressources */
void close_searchwnd( BOOL really )
{
	if( swin )
	{
		if( really )
		{
			AddToBuffer( search_rb, GetSI(search)->Buffer, GetSI(search)->NumChars );
			if(rep) AddToBuffer( replace_rb, GetSI(rep)->Buffer, GetSI(rep)->NumChars );
		}

		ClearMenuStrip(swin);
		CloseWindow(swin);
		swinsig=0; swin=NULL; rep=NULL;
		recalc_sigbits();
		if(sgads) FreeGadgets(sgads);
	}
}

/* Handle messages coming from gadgets */
BYTE handle_swingadget( struct Gadget * G )
{
	extern Project edit;
	switch( G->GadgetID )
	{
		case 0:
			if( msgbuf.Code != 1 ) break;
		case 8:
			if( GetSI(search)->Buffer[0] )
				HilitePattern(edit, GetSI(search)->Buffer, 1, VERBOSE);
			/* Activate replace gadget if it exists */
			if( G->GadgetID == 0 && rep != NULL )
				ActivateGadget(rep, swin, NULL);
			break;
		case 4: case 5:
			(&prefs.matchcase)[G->GadgetID-4] = ((G->Flags & GFLG_SELECTED) == GFLG_SELECTED);
			break;
		case 6:
			if( GetSI(search)->Buffer[0] ) ReplacePattern( edit );
			break;
		case 7:
			if( GetSI(search)->Buffer[0] ) ReplaceAllPat( edit );
			break;
		case 9:
			if( GetSI(search)->Buffer[0] )
				HilitePattern(edit, GetSI(search)->Buffer, -1, VERBOSE);
			break;
		case 10: close_searchwnd(TRUE);  return TRUE;
		case 11: close_searchwnd(FALSE); return TRUE;
	}
	return FALSE;
}

/*** Keyboard handler ***/
BYTE handle_swinkey( UBYTE Key )
{
	extern Project edit;
	switch( Key )
	{
		case 'q': case 'Q': case 'c': case 'C':
			close_searchwnd(FALSE); return TRUE;
		case 27: case 'u': case 'U':
			close_searchwnd(TRUE);  return TRUE;
		case 'n': case 'N': Key = 3; goto case_all;
		case 'p': case 'P': Key = 1; goto case_all;
		case 'r': case 'R': Key = 2; if(rep == NULL) break;
		case 'A': case_all:
			if( GetSI(search)->Buffer[0] == 0 ) break;
			switch( Key )
			{
				case 3:
				case 1: HilitePattern(edit, GetSI(search)->Buffer, Key-2, VERBOSE); break;
				case 2: ReplacePattern(edit); break;
				default:ReplaceAllPat(edit);
			}
			break;
		case '/': case 'f': case 'F':
			ActivateGadget(search, swin, NULL); break;
		case 's': case 'S':
			if(rep) ActivateGadget(rep, swin, NULL);
	}
	return FALSE;
}

/*** Handle events coming from search window ***/
void handle_search()
{
	extern ULONG err_time;
	/* Collect messages posted to the window port */
	while( (msg = GT_GetIMsg(swin->UserPort)) )
	{
		/* Copy the entire message into the buffer */
		CopyMemQuick(msg, &msgbuf, sizeof(msgbuf));
		GT_ReplyIMsg( msg );

		switch( msgbuf.Class )
		{
			case IDCMP_CLOSEWINDOW:	close_searchwnd(FALSE); return;
			case IDCMP_MENUPICK:    handle_menu((ULONG)GTMENUITEM_USERDATA(ItemAddress(Menu,msgbuf.Code))); break;
			case IDCMP_VANILLAKEY:  if( handle_swinkey( msgbuf.Code ) ) return; break;
			case IDCMP_NEWSIZE:     if( swin->Height <= swin->BorderTop ) ActivateWindow( Wnd ); return;
			case IDCMP_GADGETUP:
				if( handle_swingadget((struct Gadget *)msgbuf.IAddress) ) return;
				else break;
			case IDCMP_INTUITICKS:
				/* An error message which needs to be removed? */
				if(err_time == 0) err_time = msgbuf.Seconds;
				if(err_time && msgbuf.Seconds-err_time>4) StopError(swin);
				break;
		}
	}
}

/*** Find next matching keyword ***/
void FindPattern( Project p, BYTE dir )
{
	STRPTR search_str = swin ?
		/* Window overrides review buffer */
		GetSI(search)->Buffer :
		GetLastBuffer( search_rb, FALSE );

	if( search_str[0] )
		HilitePattern(p, search_str, dir, VERBOSE);
	else
		/* No pattern entered! Avoid short-circuit evaluation */
		if( !p->ccp.select & setup_winsearch(p, 0) )
			ThrowError(swin, ErrMsg(ERR_NOSEARCHTEXT));
}

/*** Search directly word under cursor ***/
void FindWord( Project p, BYTE dir )
{
	Line ln = p->edited;

	if( p->nbc < ln->size && TypeChar[ ln->stream[ p->nbc ] ] != SPACE )
	{
		/* Get the word under the cursor */
		ULONG  start, nbc;
		STRPTR search_str;

		nbc = forward_word( ln, p->nbc );
		while( TypeChar[ ln->stream[ --nbc ] ] == SPACE );
		nbc -= (start = (p->nbc > 0 ? backward_word(ln, p->nbc) : 0))-1;

		search_str = AddToBuffer( search_rb, ln->stream + start, nbc );

		/* Move cursor to start of word, thus this occurency won't be found */
		nbc = p->nbc; inv_curs(p, FALSE); if(dir < 0) p->nbc = start;
		if( HilitePattern(p, search_str, dir, VERB_BUT_NO_HIDE_CURS) == 0 )
			/* Nothing found */
			p->nbc = nbc, inv_curs(p, TRUE);
	}
}

/*** Replace next pattern ***/
void ReplacePattern( Project p )
{
	STRPTR replace_str, search_str = NULL;

	if( swin )
	{
		/* Window overrides review buffer */
		if( rep != NULL && (search_str = GetSI(search)->Buffer)[0] )
		{
			replace_str = GetSI(rep)->Buffer;
			goto replace_process;
		}
	}
	else if( (search_str = GetLastBuffer( search_rb, FALSE ))[0] )
	{
		replace_str = GetLastBuffer( replace_rb, TRUE );
		replace_process:
		if( HilitePattern(p, search_str, 0, VERBOSE) == 1 )
		{
			inv_curs(p, FALSE);
			if( replace_str ) reg_group_by( &p->undo );
			rem_chars( &p->undo, p->edited, p->nbc, p->nbc+strlen(search_str)-1 );
			/* Something to replace with? */
			if( replace_str )
			{
				WORD len = strlen( replace_str );
				LONG Buf[3];
				add_string( &p->undo, p->edited, p->nbc, replace_str, len, Buf );
				reg_group_by( &p->undo );
				/* Avoid recusive replacement */
				p->nbc += len; p->xcurs += len*XSIZE;
			}
			REDRAW_CURLINE( p );
			/* Hilight next pattern */
			if( !HilitePattern(p, search_str, 0, VERBOSE) )
				inv_curs(p, TRUE);
		}
	}
	else /* No pattern given yet! */
		if( !p->ccp.select & setup_winsearch(p, 1) )
			ThrowError(swin, ErrMsg(ERR_NOSEARCHTEXT));
}

/*** Replace all pattern ***/
void ReplaceAllPat( Project p )
{
	struct {				/* This vars must appear in this order for RawDoFmt */
		ULONG  nbrep;
		STRPTR occur;
		STRPTR find_str, replace_str;
	}	args;
	WORD    replen, slen;
	Line    edited = p->edited;
	LONG    nbl    = p->nbl;
#	define	find    args.find_str
#	define	replace args.replace_str

	if( swin )
	{
		/* Window overrides review buffer */
		if( rep != NULL && (find = GetSI(search)->Buffer)[0] ) {
			replace = GetSI(rep)->Buffer;
			goto replace_all;
		}
	}
	else if( (find = GetLastBuffer( search_rb, FALSE ))[0] )
	{
		replace = GetLastBuffer( replace_rb, FALSE );
		replace_all: inv_curs(p, FALSE);
		/* Replace all pattern */
		replen    = strlen( replace );
		slen      = strlen( find ) - 1;
		p->edited = p->the_line;
		p->nbc    = p->nbl = 0;
		if( HilitePattern(p, find, 0, QUIET_BUT_WARN) != 0 )
		{
			Line lastline = p->edited;
			LONG nblast   = p->nbl;
			char retcode;
			reg_group_by( &p->undo ); args.nbrep = 0;
			do {
				args.nbrep ++;
				rem_chars( &p->undo, p->edited, p->nbc, p->nbc + slen );
				/* Something to replace with? */
				if( *replace )
				{
					LONG Buf[3];
					add_string(&p->undo, p->edited, p->nbc, replace, replen, Buf);
					/* Avoid recursive replacement */
					p->nbc += replen;
				}
				retcode = HilitePattern(p, find, 0, FULLY_QUIET);
				/* Show modifications to the line */
				if((lastline != p->edited || retcode == 0) &&
				   p->top_line <= nblast && nblast < p->top_line+gui.nbline)
				{
					Move(RP,gui.left,(nblast-p->top_line)*YSIZE+gui.topcurs);
					write_text(p, lastline);
					lastline = p->edited;
					nblast   = p->nbl;
				}
			} while( retcode > 0 );
			reg_group_by( &p->undo );

			/* Show the number of pattern replaced */
			args.occur = (args.nbrep > 1 ? SWinTxt[15] : SWinTxt[14]);
			ThrowError(swin ? swin : Wnd, my_SPrintf(SWinTxt[13], &args));
		}
		/* Reset original cursor position */
		p->edited = edited;
		p->xcurs  = gui.left + XSIZE * ((
		p->nbrc   = adjust_rc(edited, p->nbrc, &p->nbc, 0)) - p->left_pos);
		p->nbl    = nbl;
		{
			ULONG newleft;
			if(p->left_pos != (newleft = center_horiz(p)))
				scroll_xy(p, newleft, p->top_line, 0);
		}
		draw_info(p);
		inv_curs(p, TRUE);
		return;
	}

	/* No pattern entered! */
	if( !p->ccp.select & setup_winsearch(p, 1) )
		ThrowError(swin, ErrMsg(ERR_NOSEARCHTEXT));
}

/*** Hightlight next pattern ***/
char HilitePattern(Project p, STRPTR pattern, BYTE direction, BYTE quiet)
{
	LINE *ln;  register STRPTR search, pat;
	WORD  len; register LONG   nb, nbl;

	ln     = p->edited;
	search = ln->stream + p->nbc + direction;
	pat    = pattern;
	len    = strlen( pat );
	nb     = (direction>=0 ? ln->size - p->nbc - len + 1 : p->nbc);
	nbl    = p->nbl;
	{
		register BYTE dir = direction;
		if(dir == 0) dir=1;
		for(;;) {
			finish_it:if(prefs.matchcase)
				/* Matching case algorithm is a little bit **
				** simpler and therefore can be optimized  */
				for( ; nb>0; nb--, search+=dir)
				{
					/* This single instruction is executed thousand of times !! */
					if( *search == *pat ) {
						do {
							pat++; search++;
						} while( *pat && *pat==*search );
						search -= pat-pattern;
						if(*pat == 0) break;
						pat = pattern;
					}
				}
			else /* Non matching case algorithm */
				for( ; nb>0; nb--, search+=dir)
				{
					if( CharClass[*search] == CharClass[*pat] ) {
						do {
							pat++; search++;
						} while( *pat && CharClass[*pat] == CharClass[*search] );
						search -= pat-pattern;
						if(*pat == 0) break;
						pat = pattern;
					}
				}
			/* Something found ? */
			if(nb > 0) {
				if( prefs.wholewords == 0 || (
				   (nb     == 1          || TypeChar[ search[len] ] != ALPHA)  &&
				   (search == ln->stream || TypeChar[ search[-1]  ] != ALPHA)) )
					goto jump_cursor;
				pat=pattern; nb--; search+=dir; goto finish_it;
			}

			/* Next line */
			ln = (dir<0 ? ln->prev : ln->next); nbl+=dir;
			if (ln) search = ln->stream, nb = ln->size-len+1;
			else break;
			if(dir < 0) search += ln->size-len;
		}
	}
	if(quiet != FULLY_QUIET)
		ThrowError(swin ? swin:Wnd, my_SPrintf(ErrMsg(ERR_NOT_FOUND), &pattern));
	return 0;

	jump_cursor:
	/* Has cursor moved? */
	len = (search == p->edited->stream + p->nbc ? 1:2);

	if(quiet < FULLY_QUIET)
	{
		/* A pattern has been found, move cursor at beginning */
		p->nbrwc = x2pos(ln,search-ln->stream);

		/* Does the keyword remain on visible area? */
		search = (UBYTE *)p->nbl; p->nbl = nbl;
		nb = center_vert( p ); p->nbl = (LONG)search;

		if(quiet != VERB_BUT_NO_HIDE_CURS) inv_curs(p,FALSE);
		set_cursor_line(p, nbl, nb);

		scroll_xy(p, center_horiz(p), nb, TRUE);

		if(p->ccp.select) move_selection(p,p->nbrc,nbl);
		inv_curs(p,TRUE);

		/* Does the window recover the word? */
		if( swin && swin->TopEdge-Wnd->TopEdge < p->ycurs-gui.basel+YSIZE &&
		    p->ycurs-gui.basel < swin->TopEdge+swin->Height-Wnd->TopEdge )
		{
			WORD newy;
			/* Move it under the word found, if there is enough place */
			if( Scr->Height - (newy = Wnd->TopEdge + p->ycurs + 10) >= swin->Height )
				MoveWindow(swin, 0, newy-swin->TopEdge);
			else
				/* Otherwise, place it above the word found */
				MoveWindow(swin, 0, newy-swin->Height-10-gui.ysize-swin->TopEdge);
		}
	} else {
		p->edited = ln;
		p->nbc    = search-ln->stream;
		p->nbl    = nbl;
	}
	return (char)len;
}

/*** Ask the user for a line number to jump to ***/
void goto_line( Project p )
{
	static LONG line_num;
	
	if( get_number( p, GetMenuText(306), &line_num ) )
	{
		if(line_num < 0)             line_num += p->max_lines;
		else                         line_num --;
		if(line_num <  0)            line_num = 0;
		if(line_num >= p->max_lines) line_num = p->max_lines-1;

		move_to_line(p, line_num, LINE_AS_IS);
	}
}

static UBYTE Brackets[] = "[{(<´ª>)}] ";

#define	NbBrak		(sizeof(Brackets)-2)

/*** Search for the corresponding bracket under cursor ***/
void match_bracket( Project p )
{
	BYTE i; UBYTE ch;
	/* Look if character under cursor is registered */
	for(i=NbBrak,ch=p->edited->stream[p->nbc]; i && Brackets[i-1] != ch; i--);

	if(i==0) ThrowError(Wnd, ErrMsg(ERR_NOBRACKET));
	else {
		LINE *ln;   register UBYTE *search, cch;
		WORD  nest; register LONG   nb, nbl;

		/* Can't use HilitePattern because of nested char */
		ln     = p->edited;
		cch    = Brackets[ NbBrak-i ];
		i      = (i <= (NbBrak>>1) ? 1 : -1);
		search = ln->stream + p->nbc + i;
		nb     = (i>0 ? ln->size - p->nbc - 1 : p->nbc);
		nbl    = p->nbl;
		nest   = 0;

		for(;;) {
			for( ; nb>0; nb--, search+=i)
			{
				if( *search == cch && !(nest--) ) goto jump_cursor;
				if( *search ==  ch ) nest++;
			}

			/* Go next line */
			ln = (i<0 ? ln->prev : ln->next); nbl+=i;
			if (ln) search = ln->stream, nb = ln->size;
			else break;
			if(i < 0) search += ln->size-1;
		}
		{	STRPTR Char = Brackets + NbBrak; *Char = cch;
			ThrowError(Wnd, my_SPrintf(ErrMsg(ERR_NOT_FOUND), &Char));
		}	return;

		jump_cursor:
		/* A matching bracket has been found, move cursor to */
		p->nbrwc = x2pos(ln,search-ln->stream);

		/* Does the bracket remain on visible area? */
		search = (UBYTE *)p->nbl; p->nbl = nbl;
		nb = center_vert( p ); p->nbl = (LONG)search;

		inv_curs(p,FALSE);
		set_cursor_line(p, nbl, nb);
		nbl = center_horiz(p);
		if( nb != p->top_line || nbl != p->left_pos )
			scroll_xy(p, nbl, nb, TRUE);
		if(p->ccp.select) move_selection(p,p->nbrc,p->nbl);
		inv_curs(p,TRUE);
	}
}
