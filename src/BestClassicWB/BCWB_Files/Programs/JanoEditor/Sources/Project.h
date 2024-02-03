/**********************************************************
**                                                       **
**      $VER: Project.h v1.3 (16.2.2000)                 **
**      Data-types for handling multi-project window     **
**                                                       **
**      © T.Pierron, C.Guilaume. Free software under     **
**      terms of GNU public license.                     **
**                                                       **
**********************************************************/

#ifndef	PROJECT_H
#define	PROJECT_H

typedef	struct Project_t *          Project;

#ifndef	MEMORY_H
#include "Memory.h"
#endif
#ifndef	PREFS_H
#include "Prefs.h"
#endif
#ifndef	CLIPLOC_H
#include "ClipLoc.h"
#endif
#ifndef	UNDOREDO_H
#include "UndoRedo.h"
#endif

typedef struct Project_t            /* MAIN PROJECT STRUCTURE */
{
	Project next, prev;              /* Linked list of opened project */
	CCP     ccp;                     /* The lines selected */
	STRPTR  buffer;                  /* Main file buffer */
	ULONG   date[3];                 /* Last modification time */
	UBYTE   tabsize;                 /* Local tabulation size */
	UBYTE   cursmode;                /* Cursor movement mode */
	UBYTE   syntax;                  /* Local syntax mode */
	UBYTE   eol;                     /* End of line type, see below */

	UWORD   xcurs, ycurs;            /* Screen position of cursor */
	ULONG   nbc,nbrc, nbl;           /* Nb. char where cursor is and real column */
	ULONG   nbrwc;                   /* Nb. of real wanted column */

	WORD    pleft, pwidth;           /* Panel tab information */
	WORD    labwid, labsize;         /* Label width in pixels and size in bytes */
	WORD    open_count;              /* Counter usage for other utility */

	STRPTR  path, name, pname;       /* Project name */
	UBYTE   state;                   /* See below */
	Line    show, the_line;          /* First shown & first line */
	Line    edited;                  /* Line being edited */
	ULONG   top_line;                /* Number of first line displayed */
	ULONG   left_pos;                /* Number of first real column displayed */
	ULONG   max_lines;               /* Number of total lines */

	JBUF    undo, redo;              /* Journalized buffers */
	STRPTR  savepoint;               /* Last modification saved */

	APTR    recent;                  /* RecentFile entry */

}	PROJECT;

/** State of a project **/
#define	MODIFIED          1        /* Don't close it without asking user */
#define	PAGINATED         2        /* Remain on disk (reduce disk usage) */
#define	DONT_FLUSH        4        /* Do not flush redo log */
#define	DUPLICATE         8        /* Do not free edit buffer */

/** String added to project when modified **/
#define	STR_MODIF         "+"

/** End of line type **/
#define	AMIGA_EOL         0
#define	MACOS_EOL         1
#define	MSDOS_EOL         2

/*
 * Try to close all projects. Returns the first non-closed one.
 * Ask user for any modified project before to close. No refresh
 * is performed.
 */
Project close_projects( void );

/*
 * Alloc a new empty project, with a starting empty line.
 */
Project new_project( Project, Prefs );

/*
 * Save all modified projects, and if close == 1, close projects too.
 * Like close_projects, returns first non-closed project.
 */
Project save_projects( Project active, char close );

/*
 * Search for panel under window position 'arg', if type == XWIN_PROJECT.
 * If type == NEXT_PROJECT, next project (if any) will be shown. If type
 * equals PREV_PROJECT, it will be the previous. If type == NTH_PROJECT,
 * 'arg' th project will be activated (if any). At last, arg is assumed
 * to be a valid pointer to a project. Return new activated project,
 * and will performed any required refresh.
 */
Project select_panel( Project current, ULONG arg, UWORD type );

/* Possible values for 'type' argument */
#define	NEXT_PROJECT      0
#define	PREV_PROJECT      1
#define	NTH_PROJECT       2
#define	XWIN_PROJECT      3
#define	THIS_PROJECT      4

/*
 * Create a list of projects, inserted them after specified project.
 * args is actually (struct WBArg []) table, and nb its length. Return
 * last successfully loaded project. No refresh performed.
 */
Project create_projects( Project, APTR args, ULONG nb );

/*
 * Load and create one or more projects after the desired one.
 * Tab and display will be refreshed. Projects will be inserted
 * as specified by "ins_type":
 * USE_CURRENT_PROJECT - name is a fully qualified and rightly spelled
 *                       filename, which will be loaded in the "ins"
 *                       project, discarding previous one.
 * USE_NEW_PROJECT     - name is also a filename, but will be loaded
 *                       in a new tab.
 * WBARGS_USE_CURRENT  - name is actually a pointer to a (StartUpArgs *)
 *                       that may contain regular expression. The "ins"
 *                       project will be discarded.
 * WBARGS_USE_NEW      - Like previous, but create all projects in a new tab.
 *
 * This function may ask to the user that project may be duplicated,
 * but doesn't check that a modified file will be trashed, just beacause
 * for numerous cases this should be done sooner (especially before
 * choosing the filename).
 *
 * Return the last project inserted, which should be the active one.
 * Refresh of display will be performed.
 *
 * Side effect: in case of type == USE_*_PROJECT, name will be deallocated
 * if it is not required, or something failed. Be sure provided buffer is
 * a freshed AllocVec()'ed one.
 */
Project load_and_activate( Project ins, STRPTR name, UBYTE ins_type );

#define	USE_NEW_PROJECT          0x00
#define	USE_CURRENT_PROJECT      0x01
#define	WBARGS_USE_CURRENT       0x02
#define	WBARGS_USE_NEW           0x03

/*
 * Save one projet, asking for filename if no one has been choosen
 * yet or "ask" is set to TRUE. If "refresh" is TRUE, the tab of the
 * file will be refreshed. This can be useless when closing project
 * or quitting Jano.
 */
char save_project( Project, char refresh, char ask );

/*
 * Split the path of a filename into directory and file name, storing
 * results in two pointers. Note that "dir" will point to a statically
 * allocated buffer.
 */
void split_path( STRPTR path[], STRPTR * dir, STRPTR * file );

/*
 * remove modifition mark (if any) of the project. if showmodif is TRUE,
 * panel name and window's title will be changed too.
 */
void unset_modif_mark( Project, char showmodif );

/*
 * Utility functions
 */
char active_project (Project);   /* Makes specified project, the active one */
char close_project  (Project);   /* Try to close a project */
void reload_project (Project);   /* Load project and flush changes */
void reshape_panel  (Project);   /* Resize item's project bar and readraw */
void set_modif_mark (Project);   /* Set and show modification flag */
void prop_adj       (Project);   /* Adjust prop gadget imagery */
void insert_file    (Project);   /* Ask user for a file to insert */

extern UBYTE NbProject;          /* Read only! */

void draw_panel( Project, BYTE, BYTE, BYTE );

#define	REDRAW_CURLINE(prj)		\
	{ Move(RP,gui.left,prj->ycurs); write_text(prj, prj->edited); }

#define	RECENT_PROJECT(prj)     \
	((RecentFile)prj->recent)->rf_Project

#endif
