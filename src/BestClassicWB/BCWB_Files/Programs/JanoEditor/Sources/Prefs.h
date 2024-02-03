/*
** Prefs.h - internal representation of preference file.
** Written by T.Pierron & C.Guillaume, february 16, 2000.
** Free software under terms of GNU license.
*/

#ifndef PREFS_H
#define PREFS_H

#ifndef	GUI_H
#include "Gui.h"
#endif

#include <graphics/text.h>
#include "Version.h"

/*
 * Internal preferences of JanoEditor
 */
typedef struct Prefs_t
{
	char   use_pub;            /* TRUE if a pubscreen is created */
	char   use_txtfont;        /* TRUE if a custom text font is used */
	char   use_scrfont;        /* TRUE if a custom screen font is used */
	char   backdrop;           /* TRUE if use a backdrop'ed window */
	char   invert_qual;        /* Invert Ctrl and Alt+Shift qualifier */
	char   auto_indent;        /* TRUE if auto indent mode */
	char   xtend;              /* TRUE if use PC-like numeric keypad */
	char   reserved;           /* Unused for now */
	char   matchcase;          /* TRUE if search is case insensitive */
	char   wholewords;         /* TRUE if only whole words match in a search */
	char   tabsize;            /* Tabulation size */
	char   depth;              /* Depth of custom screen */
	STRPTR wordssep;           /* List of characters used to separate words */
	STRPTR recentfile;         /* File where to store/load recent files list */
	struct TextAttr attrtxt;   /* Font used to edit text */
	struct TextAttr attrscr;   /* Font used for graphical interface */
	WORD   left,top;           /* Left corner of the window */
	WORD   width,height;       /* Dimensions */

	/* Information about duplicated screen */
	WORD   scrw,scrh,scrd;     /* Properties of cloned screen */
	ULONG  modeid;             /* Mode id of new screen */
	ULONG  vmd;                /* Display ID of pubscreen */

	struct GuiPens pen;        /* Pens offset used */

	/* Information allocated at run-time */
	struct TextFont *txtfont;  /* Font usable with rastport */
	struct TextFont *scrfont;  /* Font used to render gui */
	struct Screen   *parent;   /* Parent screen */
	struct Screen   *current;  /* Screen where window remains */

}	PREFS, * Prefs;

/*
 * Internal pens representation : 3 kinds of pens can be defined
 * 1. Color index using default colormap. This can be dangerous
 *    since colormap is subject to change, but is enough for low
 *    color mode.
 * 2. System color to use predefined color with a special
 *    semantic, such as dark edge, shine edge, etc... Can't have
 *    access to full colormap so.
 * 3. Using RGB specification of desired color.
 */
#define	PALETTE_TYPE          (0 << 24)
#define	SYSTEM_TYPE           (1 << 24)
#define	RGB_TYPE              (2 << 24)
#define	PALETTE_COLOR(code)   (PALETTE_TYPE | code)
#define	SYSTEM_COLOR(code)    (SYSTEM_TYPE  | code)
#define	RGB_COLOR(r,g,b)      (RGB_TYPE | (((r << 8) | g) << 8) | b)
#define	RED(color)            ((color >> 16) & 0xff)
#define	GREEN(color)          ((color >>  8) & 0xff)
#define	BLUE(color)           (color & 0xff)
#define	COLOR_VALUE(color)    (color & 0x00ffffff)
#define	COLOR_TYPE(color)     (color & 0xff000000)

/** Maximal fields saved in preference file **/
#define	MAX_NUMFIELD   sizeof(sizefields)

/** Command search to edit preference of editor **/
#define	SYS_DIR        "SYS:"
#define	PREF_DIR       "Prefs/"
#define	PREF_NAME      "JanoPrefs"
#define	SYS_DIR_LEN    4
#define	PREF_DIR_LEN   (6+SYS_DIR_LEN)
#define	PREF_NAME_LEN  (9+PREF_DIR_LEN)

/** Character types to split words **/
#define	ALPHA          0
#define	SEPARATOR      1
#define	SPACE          2
#define	MAX_STRBUF     40    /* Maximal string separator length */

/** Table where character type can be found **/
extern UBYTE TypeChar[256];

#define	ID_JANO        MAKE_ID('J','A','N','O')
#define	ID_PREF        MAKE_ID('P','R','E','F')

/** Open preference file according to mode **/
APTR open_prefs(STRPTR name, UBYTE mode);

/** Values for `mode' **/
#define	MODE_USE       1     /* Open file for reading (name can be NULL) */
#define	MODE_SAVE      2     /* Open file for writing with IFF header */


/** Load/save preference file **/
UBYTE load_prefs( Prefs, STRPTR file );
UBYTE save_prefs( Prefs );

/** Search for janoprefs and launch it **/
void  setup_winpref(void);

/** Ask user for a new screen mode/font **/
struct TextFont *change_fonts(struct TextAttr *buf, APTR Wnd, BOOL fixed);

extern struct Prefs_t prefs;

/** Inhibit unwanted functions **/
#ifdef	JANOPREF
#define	init_tabstop(X)

/** Ask user for a new screen mode **/
ULONG change_screen_mode(WORD *,ULONG);
#else

/** Check changes between two prefs and make them effective **/
void update_prefs( Project );

/** Ask user for a new preference file with ASL **/
void ask_prefs( Project, char save, STRPTR);

/** Ask user for a new screen mode **/
ULONG change_screen_mode( STRPTR, ULONG );

/** Change screenmode (shortcut of gui) **/
void ask_new_screen( void );

/** Ask user for a new font (shortcut of gui) **/
void ask_new_font( void );

#endif /* JANOPREF */

/** Convert a TextFont struct into a TextAttr **/
void text_to_attr(struct TextFont *, struct TextAttr *);

/** Try to load a preference file **/
UBYTE load_prefs( Prefs, STRPTR );

/** Set preference to default settings **/
void set_default_prefs( Prefs, struct Screen * );

#endif /* PREFS_H */

