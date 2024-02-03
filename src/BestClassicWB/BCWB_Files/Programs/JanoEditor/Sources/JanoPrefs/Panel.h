/**********************************************************
**                                                       **
**      $VER: Panel.h v1.0 (26.1.2002)                   **
**      Data-types for handling tabulation gadget        **
**                                                       **
**********************************************************/

#ifndef	PANEL_H
#define	PANEL_H

#ifndef	LIBRARIES_GADTOOLS_H
#include	<libraries/gadtools.h>
#endif

/** Tags for CreateTabGadget() **/

#define	Tab_Base        TAG_USER+0x81000

/*
 * ti_Data is a UWORD [7] table specifying colors of each
 * element of the panel. See PEN_* for offset meaning of
 * this table.
 */
#define	GTAB_Pens       Tab_Base

/*
 * Another quick for specifying color of panel's items. Just
 * Provide a (struct DrawInfo *) as ti_Data, and colors will
 * be choosen the best possible
 */
#define	GTAB_DriPens    Tab_Base+1

/*
 * ti_Data is a NULL terminated table of string specifying
 * initial tabulator name. Table's data must remain valid as
 * long as gadget stays in the interface.
 */
#define	GTAB_Items      Tab_Base+2

/*
 * Ordinal number of selected tabulator, starting at 0. Default
 * or invalid range activate the first one.
 */
#define	GTAB_Active     Tab_Base+3

/*
 * ti_Data is a (activate_hoot_t) (defined below) that will be
 * called whenever the active tabulator changes
 */
#define	GTAB_CallBack   Tab_Base+4

/*
 * Public datatypes and prototypes
 */
typedef struct TabItem_t *    TabItem;
typedef struct TabGadget_t *  TabGadget;

typedef void (* activate_hook_t) ( UWORD );

/*
 * Create a tabulator gadget using gadget's position described
 * by `ng', and tabulator's parameters of `tags', which is
 * actually a tagitem list.
 */
TabGadget CreateTabGadget( struct NewGadget * ng, ULONG * tags );

/*
 * Free all memory allocated for tabulator gadget
 */
void FreeTabGadget( TabGadget );

/*
 * Link the gadget to the window and refresh its imagery
 */
void AddRefreshTabGadget( struct Window *, TabGadget );

/*
 * After getting an event, just call this function to see whether
 * it was destinated to the provided tabulator gadget. Return
 * TRUE if event has been processed.
 */
BOOL HandleTabEvents( TabGadget );

/*
 * Entirely redraw the tabulator gadget
 */
void ReshapePanel( TabGadget );

/*
 * Select a particular tabulator, located using `arg' and `type'
 * argument. `type' can have the following values:
 * PREV_TAB - Select the previous tab if any. `arg' ignored.
 * NEXT_TAB - Select the next tab if any. `arg' ignored.
 * NTH_TAB  - Select the `arg'th tabulator if any.
 * XWIN_TAB - Select tabulator under `arg' window position.
 * If active tabulator changes, internal callback will be called.
 */
#define	NEXT_TAB       0
#define	PREV_TAB       1
#define	NTH_TAB        2
#define	XWIN_TAB       3

void SelectPanel( TabGadget, UWORD arg, UWORD type );


/** List of tabulators **/
struct TabItem_t
{
	struct Node node;               /* Panel's name & state */
	UWORD  Size, Show;              /* Size in bytes of name, and how many shown */
	UWORD  Length;                  /* Pixel length of name */
	UWORD  Xleft, Xright;           /* Starting and ending position into rastport */
};

/** Internal panel representation **/
struct TabGadget_t
{
	struct IBox       box;           /* Panel position */
	struct List       list;          /* List of tabs */
	TabItem           active;        /* Active panel */
	UWORD             nbItems;       /* Number of items in the panel */
	UWORD             pens[7];       /* Pens for rendering gadget */
	UWORD             basel;         /* Line where to render panel text */
	activate_hook_t   callback;      /* Called whenever active tab changed */
	struct RastPort * RP;            /* Rastport where to render */
};

/** Wrappers for TabGadget **/
#define	TLEFT(T)          (T)->box.Left
#define	TRIGHT(T)         (T)->box.Width
#define	TBOTTOM(T)        (T)->box.Height
#define	TTOP(T)           (T)->box.Top
#define	THEAD(T)          ((TabItem)(T)->list.lh_Head)

/** Wrappers for TabItem **/
#define	TNAME(TI)         (TI)->node.ln_Name
#define	TSTATE(TI)        (TI)->node.ln_Type
#define	TSUCC(TI)         ((TabItem)(TI)->node.ln_Succ)
#define	TPRED(TI)         ((TabItem)(TI)->node.ln_Pred)

/** Index meaning for field `pens' **/
#define	PEN_ACTIVE_FORE   0        /* Active panel text/background */
#define	PEN_ACTIVE_BACK   1
#define	PEN_SHINE_EDGE    2        /* Bright/dark edges */
#define	PEN_SHADE_EDGE    3
#define	PEN_UNUSED_FORE   4        /* Inactive panel text/background */
#define	PEN_UNUSED_BACK   5
#define	PEN_GLYPH         6        /* Inter tab color */

#endif
