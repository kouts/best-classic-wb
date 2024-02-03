/**********************************************************
**                                                       **
**      $VER: UndoRedo.h 1.2 (3.2.2001)                  **
**      Datatypes for journalized buffer                 **
**                                                       **
**      © T.Pierron, C.Guilaume. Free software under     **
**      terms of GNU public license.                     **
**                                                       **
**********************************************************/

#ifndef UNDOREDO_H
#define UNDOREDO_H

#ifndef	MEMORY_H
#include "Memory.h"
#endif

/* Size of one chunk of undo/redo buf (must be a power of 2) */
#define	UNDO_CHUNK        1024

typedef struct RBOps_t *   RBOps;
typedef struct RBSeg_t *   RBSeg;
typedef struct JBuf_t *    JBuf;

/** Structure holding modifications data (operations) **/
struct RBOps_t
{
	RBOps   prev;
	UWORD   size;                 /* Nb. of bytes in the array data */
	UBYTE   data[ UNDO_CHUNK ];   /* Buffer for operation data */
};

/** Rollback segment (text) **/
struct RBSeg_t
{
	RBSeg   prev, next;
	ULONG   max;                  /* Max data in data array */
	UBYTE   data[1];              /* Removed characters */
};


/** Internal values per Project **/
typedef struct JBuf_t            /* Journalized buffer */
{
	Line    line;                 /* Last line modified */
	ULONG   nbc;                  /* Last character modified */
	RBOps   ops;                  /* Stack of operations */
	RBSeg   rbseg;                /* Rollback segment */
	ULONG   size;                 /* Nb. of bytes in modif buffer */
	ULONG   rbsz;                 /* Nb. of bytes in rollback segment */
	UBYTE   op;                   /* Type of last operation */
	UBYTE   rbtype;               /* 0:undo 1:redo */
	APTR    prj;                  /* Link to project struct */
}	JBUF;


/** Get Project struct **/
#define	PRJ(jbuf)      ((Project)jbuf->prj)

/** Operations journalized **/
#define	ADD_CHAR       1        /* Add chars on a new line */
#define	REM_CHAR       2        /* Remove chars */
#define	REM_LINE       3        /* Remove whole content of a line */
#define	JOIN_LINE      4        /* Line joined */
#define	GROUP_BY       5        /* Group of operation */

#define	LAST_TYPE(x)   ((STRPTR)(x))[-1]
#define	IS_COMMIT(x)   ((STRPTR)(x))[-2]
#define	OUT_OF_DATE    ((STRPTR)-1)
#define	NO_MEANING_VAL ((STRPTR)-2)

#ifdef	_AROS
#define	AROS_PADDING      UWORD pad;
#else
#define	AROS_PADDING
#endif

/** Datatypes specific to an operation (must be WORD aligned) **/
typedef struct AddChar_t
{
	Line  line;                   /* Line where operation occured */
	UWORD pos;                    /* Position in this line */
	UWORD nbc;                    /* Nb. of char inserted */
	AROS_PADDING                  /* to get multiple-of-4 structure sizeof */
	UBYTE commit;                 /* Savepoint */
	UBYTE type;                   /* ADD_CHAR */
}	*AddChar;

/** Yes, no meaning changes, except type == REM_CHAR **/
typedef struct AddChar_t *       RemChar;

typedef struct RemLine_t
{
	Line   line;                  /* Line removed */
	Line   after;                 /* Insert the line after this one */
	AROS_PADDING                  /* to get multiple-of-4 structure sizeof */
	UBYTE  commit;                /* Savepoint */
	UBYTE  type;                  /* REM_LINE */
}	*RemLine;

typedef struct JoinLine_t
{
	Line   line;                  /* First line concerned */
	Line   old;                   /* Old line removed */
	ULONG  pos;                   /* Joined position */
	AROS_PADDING                  /* to get multiple-of-4 structure sizeof */
	UBYTE  commit;                /* Savepoint */
	UBYTE  type;                  /* JOIN_LINE */
}	*JoinLine;

typedef struct GroupBy_t         /* Gather multiple operations */
{
	AROS_PADDING                  /* to get multiple-of-4 structure sizeof */
	UBYTE  commit;                /* Savepoint */
	UBYTE  type;                  /* GROUP_BY */
}  *GroupBy;

void flush_undo_buf ( JBuf );
void rollback       ( JBuf );
void last_modif     ( JBuf, char );
#ifdef	PROJECT_H
void commit_work    ( Project );
#endif

STRPTR pop_last_op  ( JBuf, char, char ); /* Update JBuf values */

void reg_add_chars  ( JBuf, LINE *, ULONG pos, UWORD nb );
void reg_rem_chars  ( JBuf, LINE *, ULONG s,   ULONG e  );
void reg_join_lines ( JBuf, LINE *, LINE * );
void reg_rem_line   ( JBuf, LINE * );
void reg_group_by   ( JBuf );

#endif
