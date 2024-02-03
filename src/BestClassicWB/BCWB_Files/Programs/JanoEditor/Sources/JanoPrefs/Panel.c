/**********************************************************
**                                                       **
**      $VER: Panel.c v1.0 (26 jan 2002)                 **
**                                                       **
**      Tabulation widget using NeXtStep look. Code      **
**      grafecully taken from JanoEditor.                **
**                                                       **
**      Free software, under GNU public license          **
**                                                       **
**********************************************************/

#include "Panel.h"
#include <graphics/rastport.h>
#include <exec/memory.h>
#include "Rawkey.h"
#include "ProtoTypes.h"

extern struct RastPort *RP; /* :-( */
extern struct IntuiMessage msgbuf;

/** Standard pens number **/
static UWORD DefaultPens[] = {1, 0, 2, 1, 1, 0, 0};

static UBYTE driPens[] = {
	TEXTPEN, BACKGROUNDPEN, SHINEPEN, SHADOWPEN,
	TEXTPEN, BACKGROUNDPEN, BACKGROUNDPEN
};

void DrawPanel(TabGadget, TabItem, BYTE, BYTE, BYTE);

/*** Allocate a new list of tabs ***/
static BOOL AllocTabNode( TabGadget T, STRPTR * tabs )
{
	TabItem new, prev = NULL;
	WORD nb;

	/* Count number of items */
	for( nb = 0; *tabs; nb++, tabs++ )
	{
		/* Use an exec list */
		if( (new = (APTR) AllocVec( sizeof(*new), MEMF_CLEAR | MEMF_PUBLIC )) )
		{
			new->Length = TextLength( RP, TNAME(new), 
			new->Size   = new->Show = strlen( TNAME(new) = *tabs ));
			Insert(&T->list, &new->node, &prev->node);
			prev = new;
		}
		else return FALSE;
	}
	T->nbItems = nb;
	return TRUE;
}

/*** Search for nth item ***/
TabItem ActivateNth( TabGadget T, UWORD nth )
{
	register TabItem ti = THEAD(T);
	register UWORD   nb = nth;
	while( nb-- && ti ) ti = TSUCC(ti);
	return ti;
}

/*** Recompute size of each item and show the active project ***/
void ReshapePanel( TabGadget T )
{
	TabItem lst = THEAD(T);
	WORD    width, height, i = 1, lastpos = 0;

	/** Compute items size **/
	width  = ( TRIGHT(T)  - TLEFT(T) );
	height = ( TBOTTOM(T) - TTOP(T)) >> 1;
	for( ; TSUCC(lst); lst = TSUCC(lst), i++ )
	{
		lst->Xleft  = (i == 1 ? TLEFT(T) : lastpos - height);
		lst->Xright = lastpos = TLEFT(T) + width * i / T->nbItems;
	}

	/** Redraw the project bar **/
	for( lst = THEAD(T), i = 0; TSUCC(lst); lst = TSUCC(lst), i++ )
		/* Active project should be the last drawn */
		if( lst != T->active )
			DrawPanel(T, lst, TPRED(lst) == T->active || i == 0, TRUE, FALSE);
		else
			height = i + 1;

	DrawPanel(T, T->active, height == 1, height == T->nbItems, TRUE);
}

/*** Main allocator of tab gadget ***/
TabGadget CreateTabGadget( struct NewGadget *ng, ULONG *tags )
{
	TabGadget new;

	if( (new = (APTR) AllocVec( sizeof(*new), MEMF_PUBLIC | MEMF_CLEAR )) )
	{
		struct TextFont * font;
		struct TagItem  * tstate, *tag;
		ULONG  active = 0;

		TBOTTOM(new) = ng->ng_Height - 1 + (
		TTOP(new)    = ng->ng_TopEdge);
		TRIGHT(new)  = ng->ng_Width - 1 + (
		TLEFT(new)   = ng->ng_LeftEdge);

		if( (font = (APTR) OpenFont( ng->ng_TextAttr )) )
		{
			new->basel = font->tf_Baseline + 3;
			CloseFont( font );
		}
		NewList( &new->list );
		CopyMem( DefaultPens, new->pens, sizeof(DefaultPens) );

		/* Analyse tag item list */
		tstate = (APTR) tags;
		while ( (tag = (APTR) NextTagItem(&tstate)) )
			switch( tag->ti_Tag )
			{
				case GTAB_Pens:
					CopyMem( (APTR) tag->ti_Data, new->pens, sizeof(new->pens) );
					break;
				case GTAB_DriPens:
				{	STRPTR drip; WORD * tpens, i;
					for(drip = driPens, tpens = new->pens, i = 0; i < 7; i++, drip++, tpens++)
						*tpens = ((UWORD *)tag->ti_Data)[ *drip ];
				}	break;
				case GTAB_Items:
					AllocTabNode( new, (STRPTR *) tag->ti_Data );
					break;
				case GTAB_Active:
					active = tag->ti_Data;
					break;
				case GTAB_CallBack:
					new->callback = (activate_hook_t) tag->ti_Data;
			}
		new->active = ActivateNth(new, active);
	}
	return new;
}

/*** Attach and refresh Panel gadget ***/
void AddRefreshTabGadget( struct Window *win, TabGadget T )
{
	T->RP = win->RPort;

	/* Computes panel width and position */
	ReshapePanel( T );
}

/*** Free tab gadget ***/
void FreeTabGadget( TabGadget T )
{
	if( T != NULL )
	{
		TabItem ti, next;
		
		for( ti = THEAD(T); (next = TSUCC(ti)); ti = next )
			FreeVec( ti );

		FreeVec( T );
	}
}

/*** Draw one NextStep-like panel item ***/
void DrawPanel(TabGadget T, TabItem p, BYTE rclear, BYTE lclear, BYTE activ)
{
	struct RastPort * RP = T->RP;
	BYTE max = (TBOTTOM(T) - TTOP(T) - 1) >> 1, i;
	WORD right = p->Xright - max - 1;

	WORD bgpan = (activ ? T->pens[PEN_ACTIVE_BACK] : T->pens[PEN_UNUSED_BACK]);

	/* Bottom line */
	if(rclear == 0) {
		SetAPen(RP, T->pens[PEN_SHINE_EDGE]);
		Move(RP, TLEFT(T), TBOTTOM(T));
		Draw(RP, p->Xleft, RP->cp_y);
	}
	/* Left shape */
	for(i=0; i<=max; i++) {
		Move(RP, p->Xleft+i,TBOTTOM(T));        SetAPen(RP, bgpan);
		Draw(RP, RP->cp_x,  TBOTTOM(T)-(i<<1)); SetAPen(RP, T->pens[PEN_SHINE_EDGE]);
		Draw(RP, RP->cp_x,  RP->cp_y-1);
		if(rclear && i < max) {
			SetAPen(RP, T->pens[PEN_GLYPH]);
			Move(RP, RP->cp_x, RP->cp_y-1);
			Draw(RP, RP->cp_x, TTOP(T));
		}
	}
	/* Upper line */
	Move(RP, RP->cp_x+1, TTOP(T)); SetAPen(RP, T->pens[PEN_SHINE_EDGE]);
	Draw(RP, right,      TTOP(T)); SetAPen(RP, bgpan);

	RectFill(RP, p->Xleft+max+1, TTOP(T)+1, RP->cp_x, TBOTTOM(T));
	SetAPen(RP, activ? T->pens[PEN_ACTIVE_FORE]:
	                   T->pens[PEN_UNUSED_FORE]);

	/* Text in the box */
	if(activ) RP->AlgoStyle = FSF_BOLD;
	SetDrMd(RP, JAM1);
	Move(RP, (p->Xleft+p->Xright-p->Length) >> 1, TTOP(T)+T->basel );
	Text(RP, TNAME(p), p->Show);
	RP->AlgoStyle = FS_NORMAL;

	/* Right shape */
	for(i=0,right++; i<=max; i++) {
		Move(RP, right+i,  TBOTTOM(T));              SetAPen(RP,bgpan);
		Draw(RP, RP->cp_x, TBOTTOM(T)-((max-i)<<1)); SetAPen(RP,T->pens[PEN_SHADE_EDGE]);
		Draw(RP, RP->cp_x, RP->cp_y-1);
		if(lclear && i) {
			SetAPen(RP, T->pens[PEN_GLYPH]);
			Move(RP, RP->cp_x, RP->cp_y-1);
			Draw(RP, RP->cp_x, TTOP(T));
		}
	}
	/* Bottom line */
	if( !lclear ) {
		SetAPen(RP, T->pens[PEN_SHINE_EDGE]);
		Move(RP, RP->cp_x,  TBOTTOM(T));
		Draw(RP, TRIGHT(T), RP->cp_y);
	}
}

/*** Search if a tab is select using mouse ***/
void SelectPanel( TabGadget T, UWORD arg, UWORD type )
{
	TabItem ti;

	/* Search for the highlighted panel */
	switch( type )
	{
		case NEXT_TAB: ti = TSUCC(T->active); break;
		case PREV_TAB: ti = TPRED(T->active); break;
		case NTH_TAB:
			for(ti=THEAD(T); arg && TSUCC(ti); arg--, ti=TSUCC(ti));
			break;
		default:
			for(ti=THEAD(T); TSUCC(ti); ti=TSUCC(ti))
				if(ti->Xleft <= arg && arg < ti->Xright) break;
	}

	/* Don't change project if it is the same */
	if( TPRED(ti) && TSUCC(ti) && ti != T->active )
	{
		DrawPanel(T, T->active, FALSE, FALSE, FALSE);
		DrawPanel(T, ti,        FALSE, FALSE, TRUE);
		T->active = ti;

		if( T->callback )
		{
			UWORD num = 0;
			while( (ti = TPRED(ti)) ) num++;
			T->callback( num-1 );
		}
	}
}

/*** Process events associated to a TabGadget ***/
BOOL HandleTabEvents( TabGadget T )
{
	switch( msgbuf.Class )
	{
		case IDCMP_MOUSEBUTTONS:
			if(msgbuf.Code != SELECTDOWN ||
			   msgbuf.MouseX < TLEFT(T) || msgbuf.MouseX > TRIGHT(T)  ||
			   msgbuf.MouseY < TTOP(T)  || msgbuf.MouseY > TBOTTOM(T) ) break;

			SelectPanel( T, msgbuf.MouseX, XWIN_TAB );
			return TRUE;
			break;
		case IDCMP_RAWKEY:
			if((msgbuf.Qualifier & SHIFTKEYS) && (msgbuf.Qualifier & CTRLKEYS))
			switch( msgbuf.Code )
			{
				case LEFT_KEY:  SelectPanel( T, 0, NEXT_TAB ); return TRUE;
				case RIGHT_KEY: SelectPanel( T, 0, PREV_TAB ); return TRUE;
			}
			break;
	}
	return FALSE;
}

/*** Title of panel has changed, update it ***/
void ChangeTabName( TabGadget T )
{
	TabItem ti = T->active;
	/* Assuming that activ tab is the modified one */
	ti->Length = TextLength(T->RP, TNAME(ti),
	ti->Size   = ti->Show = strlen(TNAME(ti)));
	DrawPanel(T, ti, FALSE, FALSE, TRUE);
}
