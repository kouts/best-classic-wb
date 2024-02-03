/**************************************************************
**** Utility.h: Prototypes of nice and helpful functions   ****
**** Free software under GNU license, written in 9/6/2000  ****
**************************************************************/

#ifndef	UTILITY_H
#define	UTILITY_H

#ifndef	INTUITION_INTUITION_H
struct Window;
#endif

/* Very simple SPrintf-like function (limited to 79 chars) */
STRPTR my_SPrintf(STRPTR fmt, APTR data);

/* Fully fprintf replacement */
#ifndef	UTILITY_C
void FPutChProc( void );

#define	my_FPrintf( fh, fmt, args )    \
	RawDoFmt(fmt, args, (void *)FPutChProc, (APTR) fh )

#endif

typedef struct StartupArgs_t    StartUpArgs;
typedef struct ReviewBuf_t *    ReviewBuf;

struct StartupArgs_t
{
	ULONG sa_NbArgs;            /* Nb. of WBArg */
	APTR  sa_ArgLst;            /* WBArg * */
	UBYTE sa_Free;              /* Must FreeVec()'ed sa_ArgLst */
};

#define	MAX_REVIEW_BUF          1024

struct ReviewBuf_t
{
	WORD  Usage, Review;
	UBYTE Buffer[ MAX_REVIEW_BUF ];
};

/** Add a string into a review buffer **/
STRPTR AddToBuffer( ReviewBuf, STRPTR, UWORD );

/** Browse through review buffer **/
UWORD GetPrevNextBuffer( ReviewBuf, STRPTR, UWORD, BYTE dir );

STRPTR GetLastBuffer( ReviewBuf rb, BOOL force );

/** Converts command line arguments into WBArg **/
void ParseArgs( StartUpArgs *, int nb, char ** );

#ifndef	UTILITY_C /* List manipulation */

void InsertAfter( APTR item, APTR node );

void Destroy( APTR first, APTR item );

#endif

/** Get include file name **/
STRPTR GetIncludeFile( Project, LINE * );

/** Like CopyMem but copy buf from end instead of beg. **/
void MemMove( STRPTR Src, UWORD Offset, LONG sz );

#ifndef	JANOPREF
/** Pre-computes the 256 first tabstop **/
void init_tabstop(UBYTE ts);
#endif

/** Returns increment to next tabstop **/
UBYTE tabstop(ULONG);

/** Shutdown events coming to the window and change pointer **/
void BusyWindow(struct Window *);

/** Enable receiving events and reset pointer **/
void WakeUp(struct Window *);

/** Simple strings manipulation **/
STRPTR CatPath( STRPTR dir, STRPTR file );

UWORD my_StrnCpy( STRPTR src, STRPTR dest, UWORD max );

/** Display an error in title bar & start a countdown **/
void ThrowError    (struct Window *, STRPTR);
void ThrowDOSError (struct Window *, STRPTR);

/** Set a permanent title **/
void SetTitle(struct Window *, STRPTR);

/** Stop countdown msg. and restore original title */
void StopError(struct Window *);

/** Write column/line in top of window **/
void draw_info(Project p);

/** Avert user that its file has been modified **/
char warn_modif(Project p);
char warn_overwrite( STRPTR path );
char warn_already_open( STRPTR path );
void show_info(Project p);

/** Simple requester to ask user for a number **/
int get_number( Project, STRPTR title, LONG * result );

void select_column( Project, int );

/** About requester messages **/
extern STRPTR JanoMessages[];
#define	MsgAbout     (JanoMessages + (MSG_ABOUT - ERR_BADOS))

#endif
