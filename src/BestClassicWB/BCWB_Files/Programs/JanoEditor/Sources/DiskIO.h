/**************************************************************
**                                                           **
**      $VER: DiskIO.h v1.2 (feb 25, 2002)                   **
**      Public functions for reading / writing files         **
**                                                           **
**      © T.Pierron, C.Guilaume. Free software under terms   **
**      of GNU public license.                               **
**                                                           **
**************************************************************/

#ifndef DISKIO_H
#define DISKIO_H

#ifndef	MEMORY_H
#include "Memory.h"
#endif

#ifndef	INTUITION_INTUITION_H
struct Window;
#endif

/*
 * This is the fields modified by load_file in Project datatype
 * But because of this function may failed, we must use another
 * datatype and re-fill original structure in case of success
 */
typedef	struct
{
	STRPTR filename;			/* Just fill this field */
	STRPTR buffer;          /* Buffer which need to be FreeVec()'ed */
	LINE * lines;           /* Lines of file */
	ULONG  nblines;
	char   eol;

}	LoadFileArgs;

/*
 * Try to load the specified file into memory. The only field of the
 * LoadFileArgs that must be filled is 'filename'. All others will
 * be set by the function. Return AmigaDOS error, or 0 on success.
 */
WORD load_file( LoadFileArgs * );

/*
 * Like previous function, but will just fill 'buffer' field of
 * LoadFileArgs struct and returns in 'length', the size in bytes
 * of the file read. Returns AmigaDOS error, or 0 on success.
 */
WORD read_file( LoadFileArgs *, ULONG * length );

/*
 * Save 'Line's into the 'filename' using specified end of line
 * type, for the missing one (see *_EOL in Project.h). Returns
 * TRUE on success.
 */
BOOL save_file( STRPTR filename, Line, UBYTE eol );

/*
 * Get the full path from an incomplete one. The new is
 * AllocVec()'ed and must be FreeVec()'ed after use.
 * Returns Catalog index of error string, or 0 on success.
 */
UBYTE get_full_path( STRPTR, STRPTR * );

/*
 * Prompt user for a filename, setting path and file of requester
 */
STRPTR ask_save(struct Window *, STRPTR path[], STRPTR title);

/*
 * Like previous but with ASL_LOAD. if setfile is 1 File gadget will
 * be initially fill. Otherwise it will be empty and multi-select will
 * be enabled. Thus a (StartUpArgs *) will be returned instead (utility.h).
 */
STRPTR ask_load(struct Window *, STRPTR path[], BYTE setfile, STRPTR asltitle);

/*
 * Free all static allocation done in this module
 */
void free_diskio_alloc( void );

#endif
