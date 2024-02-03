/**********************************************************
**                                                       **
**      $VER: Memory.h v1.0 (15.2.2000)                  **
**      Main data-types for storing file in memory       **
**                                                       **
**      © T.Pierron, C.Guilaume. Free software under     **
**      terms of GNU public license.                     **
**                                                       **
**********************************************************/

#ifndef	MEMORY_H
#define	MEMORY_H

#include <exec/types.h>
#include <exec/memory.h>

/* Internal representation of a line of text */
typedef	struct Line_t
{
	struct Line_t *next,*prev;  /* linked list */
	ULONG          size, max;   /* actual size and max before overflow */
	STRPTR         stream;      /* Start of buffer */
	UBYTE          flags;       /* See below */

}	LINE, * Line;

#include "UndoRedo.h"

/* Possible values for 'flags' field */
#define	FIRSTSEL       1     /* Line begins a selection */
#define	LASTSEL        2     /* Line ends a selection */
#define	WHOLESEL       4     /* Entire line is selected */

/* Granularity of mem allocation (power of 2) */
#define	GRANULARITY    16

/* Special code */
#define	KERNEL_PANIC   (ULONG)-1

/*
 * Create a new line of 'size' bytes. 'text' can be NULL, thus buffer
 * will be left uninitialized (not even cleared!). 'size' will be rounded
 * to a multiple of GRANULARITY. Return NULL if alloc failed.
 */
Line create_line( STRPTR text, ULONG size );

/*
 * Simplified line creation. This will create a empty line, with 'stream'
 * field left uninitialized. Return new line created.
 */
Line new_line( Line );

/*
 * Free memory for node and buffer. Node will not be unlinked from list.
 */
void free_line( Line );

/*
 * Free memory of all lines, starting a the specified line.
 */
void trash_file( Line );

/*
 * Add a character 'chr' to a line at the position 'pos'. 'pos' must
 * be < than 'max' field of Line, otherwise 'chr' will be inserted at
 * the end. Stream is reallocted if not enough large. This function
 * will perform an reg_add_chars on the journalized buffer, unless
 * this parameter is set to NULL. Return sucess of operation.
 * Notice that if something failed, you can be sure that nothing
 * has been modified.
 */
BOOL add_char( JBuf, Line, ULONG pos, UBYTE chr );

/*
 * Similar to previous function, this one can insert a whole string.
 * Actually, it uses just the same scheme, with no special side-effect.
 */
BOOL insert_str( JBuf, Line, ULONG pos, STRPTR text, ULONG length );

/*
 * Remove chars between and including s and e. s must <= to e, and e must
 * be < than 'Line->max', otherwise strange things may happen, including
 * crash of the machine.
 */
BOOL rem_chars( JBuf, Line, ULONG s, ULONG e );

/*
 * Remove a line, unlinking from list and readjusting first pointer if
 * required. Note that if no journalized buffer is given, the node will
 * be definitively freed, otherwise just copied to the rollback segment.
 * If the deleted line is the last one, it will be just reduced to a
 * 0-length buffer.
 */
BOOL del_line( JBuf, Line * first, Line del );

/*
 * Copy entire buffer of line2 at the end of line1.
 */
BOOL join_lines( JBuf, Line line1, Line line2 );

/*
 * Split 'Line' into two parts at the specified 'pos'. The new will start
 * with the same space characters than 'Line', if autoindent is set to TRUE.
 * curspos must be a valid pointer that will contain the character number
 * (not the column) at which cursor should be placed.
 */
BOOL split_line( JBuf, Line, ULONG pos, ULONG *curspos, BOOL autoindent );

/*
 * Simply change one character at the specified position.
 * TODO journalized operation!
 */
BOOL replace_char( Line, ULONG, UBYTE );

/*
 * Replace charater from and including s to e, exclude ( [s - e[ ).
 * TODO journalized operation!
 */
typedef UBYTE (*replace_func_t) ( UBYTE );
BOOL replace_chars( Line, ULONG s, ULONG e, replace_func_t change );

/*
 * Count the bytes of a file, using 'szEOL' bytes for each 'Line'.
 */
ULONG size_count  ( Line, BYTE szEOL );

/*
 * These 2 function will insert a string, taking care of newline.
 * They will return 3 values in 'buf', with the following meaning:
 * buf[0]: Horizontal position for the cursor
 * buf[1]: Number of lines modified in the display
 * buf[2]: Number of lines added to the buffer (rq: for add_string buf[1] == buf[2])
 */
BOOL add_string( JBuf, Line, ULONG pos, STRPTR, ULONG len, LONG *buf );
BOOL add_block ( JBuf, Line, ULONG pos, STRPTR, ULONG len, LONG *buf );

#endif

