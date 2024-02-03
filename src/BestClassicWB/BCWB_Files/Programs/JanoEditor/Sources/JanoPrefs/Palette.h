/*
 * Palette.h: Public prototypes for manipulating system colors
 * Free software under GNU license
 * Written by T.Pierron, C.Guillaume, july 25, 2002
 */

#ifndef	PREFS_PALETTE_H
#define	PREFS_PALETTE_H

/* Public symbols */
extern ULONG  palettesigbit;

/* Public prototypes */
typedef void (*PalCallback)( ULONG jano_code, ULONG pen );

BOOL open_palette_window  ( PalCallback, ULONG );
void set_palette_callback ( PalCallback );
void close_palette_window ( void );
void handle_palette       ( void );
void sync_palette         ( ULONG );

/*
 * Following is private, don't bother with this
 */
struct CCTabHooks    /* Hooks used according to active tab */
{
	struct Gadget * (* create_gui )    ( struct IBox * );
	BOOL            (* handle_gadget ) ( struct Gadget * );
	BOOL            (* handle_kbd )    ( UWORD code );
	UWORD           nb_gadget;
	struct Gadget * context;
};

#define	foreach_tab( table, ptr )    \
	for( ptr = table; ptr < EOT(table); ptr ++ )

/*
 * "Palette" tabulator constants & prototypes
 */
struct Gadget * create_palette_gui        ( struct IBox * );
BOOL            handle_palette_tab_gadget ( struct Gadget * );

/*
 * "System" tabulator prototypes
 */
struct Gadget * create_system_gui        ( struct IBox * );
BOOL            handle_system_tab_gadget ( struct Gadget * );

/*
 * "Colors" tabulator prototypes
 */
void            adjust_rgb_box        ( struct IBox * );
struct Gadget * create_rgb_gui        ( struct IBox * );
BOOL            handle_rgb_tab_gadget ( struct Gadget * );

void free_palette_tabs( void );

#endif

