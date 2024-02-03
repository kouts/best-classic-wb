/*
** Gui.h - datatypes of main interface.
** Free software under GNU license, written in 3/1/2000
** Written by T.Pierron & C.Guillaume.
*/

#ifndef	GUI_H
#define	GUI_H

#ifdef	INTUITION_INTUITION_H      /* Reduce includes required */
struct Scroll
{
	struct Gadget   scroller;        /* proportionnal gadget */
	struct Gadget   down;            /* down gadget */
	struct Gadget   up;              /* up gadget */
	struct PropInfo pinfo;           /* PropInfo for scroller */
	struct Image    simage;          /* image for scroller */
	struct Image *  upimage;         /* Boopsi image for up arrow */
	struct Image *  downimage;       /* ditto for down arrow */
};

/* This very looooong names are quite boring to write... */
#define	GetSI( gad )         ((struct StringInfo *)gad->SpecialInfo)

#endif

/*
 * Various shortcut position for project
 */
struct gv
{
	UWORD left,    top;              /* Upper left corner of edit area */
	UWORD right,   bottom;           /* Bottom right corner */
	UWORD nbline,  nbcol;            /* Nb. of visible lines/columns */
	UWORD topcurs, botcurs;          /* Max positions before to scroll */
	UBYTE xsize,   ysize, basel;     /* Font size */
	UWORD rcurs,   xstep;            /* Right-most window pos of cursor */
	UBYTE txtmask, selmask;          /* Mask to optimize scrolling */
	UBYTE depthwid;                  /* Depth-arrange image width */
	UWORD oldtop;                    /* Top change if project bar is added */
	UWORD xinfo,   yinfo;            /* Position of line/col [INS|OVR] marker */
};

/*
 * Pens number to render editor
 */
struct GuiPens
{
	ULONG bg,     fg;                /* Foreground & background normal text pens */
	ULONG bgfill, fgfill;            /* Dito with selected text pens */
	ULONG bgbar,  fgbar;             /* Left margin background & foreground */
	ULONG shine,  shade;             /* Shine & shadow pens for project bar */
	ULONG bgpan,  fgpan;             /* Foreground & background panel pens */
	ULONG panel,  abpan;             /* Project bar glyph & activ bg panel */
};

extern struct Screen *  Scr;
extern APTR             Vi;
extern struct Window *  Wnd;
extern struct Menu *    Menu;
extern struct Scroll *  Prop;
extern struct RastPort *RP,RPT;
extern struct GuiPens   pen;
extern struct gv        gui;
extern UWORD            OpenCount;

long   setup          ( void );
void   load_pens      ( void );
void   adjust_win     ( struct Window *, BYTE PrjBar );
STRPTR GetMenuText    ( ULONG );
void   clear_brcorner ( void );
void   CloseMainWnd   ( BOOL );
void   recalc_sigbits ( void );

/* Easy access to commonly used variables */
#define	YSIZE         (gui.ysize)
#define	XSIZE         (gui.xsize)
#define	BASEL         (gui.basel)

/*
 * Some ofently accessed menu entries by [On|Off]Menus()
 */
#define	MENUITEM(M,I,S)    (SHIFTMENU(M)+SHIFTITEM(I)+SHIFTSUB(S))
#define	MENU_RECENT        MENUITEM(0,2,NOSUB)

#endif
