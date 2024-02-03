/*
 * Tabulators.h : Datatypes and prototypes for easily managing tabs
 * Free software under GNU public license
 * Written by T.Pierron, C.Guillaume, november 11, 2000.
 */

#ifndef	PREFS_TABULATORS_H
#define	PREFS_TABULATORS_H

#ifndef	JANOPREFS_H
#include	"JanoPrefs.h"
#endif

struct TabHooks    /* Hooks used according to active tab */
{
	struct Gadget * (* create_gui )    ( struct IBox * );
	BOOL            (* handle_gadget ) ( struct Gadget * );
	BOOL            (* handle_kbd )    ( UWORD code );
	void            (* do_action )     ( UWORD action );
	void            (* update_gui )    ( struct Window *, Prefs, Prefs );
	UWORD           nb_gadget;
	struct Gadget * context;
};

/* Possible value for 'action' code */
#define	CODE_REFRESH_GUI     0     /* Redraw GUI's components */
#define	CODE_FREE_GUI        1     /* About to close window */

#define	foreach_tab( table, ptr )    \
	for( ptr = table; ptr < EOT(table); ptr ++ )

struct GadgetKind
{
	ULONG * gi_Tags;    /* Tags to be passed to CreateGadget() */
	ULONG   gi_Type;    /* Kind of gadget to create */
};

/*
 * "General" tabulator constants & prototypes
 */
void            adjust_general_box        ( struct IBox * );
struct Gadget * create_general_gui        ( struct IBox * );
BOOL            handle_general_tab_gadget ( struct Gadget * );
BOOL            handle_general_kbd        ( UWORD );
void            do_general_action         ( UWORD );
void            update_general_gui        ( struct Window *, Prefs, Prefs );

#define	EXTENDED_TXTFONT        0x1
#define	EXTENDED_SCRFONT        0x2
#define	EXTENDED_SCREEN         0x4
#define	SAMPLE_HEIGHT           50


/*
 * "Syntax" tabulator prototypes
 */
struct Gadget * create_syntax_gui        ( struct IBox * );
BOOL            handle_syntax_tab_gadget ( struct Gadget * );
BOOL            handle_syntax_kbd        ( UWORD );

#define	ALL_TOKENS        0xffff
#define	EOT(table)        (table+sizeof(table)/sizeof(table[0]))
#define	MAX_TOKENS        (sizeof(SyntaxPens)/sizeof(SyntaxPens[0]))

struct SynParser
{
	UBYTE syn_name[24];
	UBYTE syn_pattern[32];
	UBYTE syn_file[64];
	ULONG syn_offset;
	ULONG syn_length;
};

/*
 * "Colors" tabulator prototypes
 */
struct Gadget * create_colors_gui        ( struct IBox * );
BOOL            handle_colors_tab_gadget ( struct Gadget * );
void            do_colors_action         ( UWORD );

#endif
