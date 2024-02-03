/*
 * RecentFils.h : datatypes and prototypes for managing
 * list of recent files and their properties.
 *
 * Written by T.Pierron and C.Guillaume for JanoEditor
 * Free software under GNU public license.
 */

#ifndef	RECENTFILES_H
#define	RECENTFILES_H

#ifndef	EXEC_NODES_H
#include <exec/nodes.h>
#endif

#define	MAX_RECENT_FILES         10

typedef struct
{
	struct Node rf_Node;        /* List of nodes */
	ULONG       rf_ModifLine;   /* Last line where cursor was */
	ULONG       rf_ModifCol;    /* Column */
	ULONG       rf_TabSize;     /* Current tab stop value */
	STRPTR      rf_FileName;    /* Fully qualified file name */
	UWORD       rf_FileSize;    /* Size in bytes of file name */
	APTR        rf_Project;     /* Project pointer, if loaded */

} * RecentFile;

/* Free all memory allocated for recent files list */
void free_recent( void );

/* Save the internal recent files list into the specified file */
BOOL save_recent_files( STRPTR );

/* Retrieve recent files list from the requested file */
BOOL read_recent_files( STRPTR );


#ifdef	PROJECT_H
/*
 * Show recent files list into a window and enable user to choose for a file
 * to load or activate if it is already loaded. If project is found in the
 * list (why not?!), it will be already selected in the list.
 */
void show_recent_files( Project, STRPTR title );

#ifdef	UTILITY_H
/*
 * Show recent search in a window
 */
void show_recent_search( Project, STRPTR title, ReviewBuf );
#endif

/*
 * This function will update various cursor position and tabsize or project
 * if it is found in the recent files list, or just adds it otherwise.
 * Returns TRUE if project has been added, FALSE if it has been updated.
 */
Project check_or_create_recent( ULONG *, STRPTR );


/*
 * Save settings of project to retrieve them when reloaded
 * if 'close' is TRUE, project reference will be cleared.
 */
void update_recent( Project, BOOL close );
void update_project( Project );

#endif

/* List management facilities */
#define	RECENT_HEAD         ((RecentFile)recent_list.mlh_Head)
#define	RECENT_NEXT(node)   ((RecentFile)node->rf_Node.ln_Succ)
#define	END_OF_RECENT(lst)  !RECENT_NEXT(lst)

#endif

