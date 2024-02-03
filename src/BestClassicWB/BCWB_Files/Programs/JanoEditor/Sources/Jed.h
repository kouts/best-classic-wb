/**************************************************************
**** jed.h : prototypes of main functions.                 ****
**** Free software under GNU license, started on 15/2/2000 ****
**** © T.Pierron, C.Guillaume.                             ****
**************************************************************/

#ifndef JANOEDITOR_H
#define JANOEDITOR_H

#ifndef	PROJECT_H
#include "Project.h"
#endif
#ifndef	GUI_H
#include "Gui.h"
#endif
#ifndef	CURSOR_H
#include "Cursor.h"
#endif

/*** Classical macros ***/
#define	MIN(a,b)       ((a)<(b) ? (a):(b))
#define	MAX(a,b)       ((a)<(b) ? (b):(a))
#define	SWAP(a,b)      (a^=b, b^=a, a^=b)

/*** Prototypes ***/
void cleanup(STRPTR, int ret);               /* To cleanup properly */
void dispatch_events(void);                  /* Collect events */

void write_text   (Project, LINE *);         /* Render a line usign gui opts */
LONG curs_visible (Project, LONG);           /* Be sure cursor always visible */
LONG center_horiz (Project);                 /* Adjust horizontal display position */
LONG center_vert  (Project);                 /* Adjust vertical display position */
void scroll_disp  (Project, BOOL);           /* Scroll according to prop gadget */
void new_size     (UBYTE Flags);             /* Refresh main display, see flags below */

BOOL auto_scrolling (Project, WORD ystep);               /* Delta scroll, returning TRUE if changes */
void scroll_xdelta  (Project, LONG xstep);
void scroll_ydelta  (Project, LONG ystep);               /* Ditto for vertical scroll */
void scroll_xy      (Project, LONG,LONG,BYTE adj);       /* Jump display to absolute pos */
void scroll_up      (Project, LINE *,WORD yc,LONG lp);
void redraw_content (Project, LINE *,WORD y,WORD nb);
void unmark_all     (Project, BYTE);                     /* Deselect all marked region */

/** Possible values for flags in new_size() **/
#define	EDIT_AREA            1              /* Refresh only text area */
#define	EDIT_GUI             2              /* Refresh gui components */
#define	EDIT_ALL             3              /* Refresh all */

/** Internal state **/
enum {
	STAND_BY    = 0,
	SELECT_COL  = 1,
	MARK_TEXT   = 2,
};

#endif
