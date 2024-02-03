/*
 * Some debugging macros for tracking memory loss
 * Written by every paranoid programmers
 */

#ifdef	DEBUG
#ifndef	EXEC_MEMORY_H
#include	<exec/memory.h>
#endif

#define	DEBUG_STATIC_VARS      static ULONG amem, bmem
#define	DEBUG_START            bmem = AvailMem( MEMF_PUBLIC )
#define	DEBUG_END              amem = AvailMem( MEMF_PUBLIC ); \
	if(amem < bmem)	printf("Possible memory lost of %ld bytes\n", bmem-amem)

#else

#define	DEBUG_STATIC_VARS
#define	DEBUG_START
#define	DEBUG_END

#endif
