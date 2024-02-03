/*
 * Unix.h : Map AmigaOS constants to unix one.
 *
 * Written by T.Pierron, May 1, 2002.
 */

#ifndef	UNIX_H
#define	UNIX_H

#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define	Open(f,m)            (BPTR)fopen(f,m)
#define	FGets(f,b,s)         fgets(b,s,(FILE *)f)
#define	Close(f)             fclose((FILE *)f)
#define	AllocVec(s,t)        malloc(s)
#define	ReallocVec(p,s)      realloc(p,s)
#define	FreeVec(p)           free(p)
#define	PrintFault(c,m)      perror(m)
#define	AllocClear(s)        calloc(s,1)
#define	NewList(lst)         ((struct MinList *)lst)->mlh_Head=\
       	                     ((struct MinList *)lst)->mlh_Tail=NULL

#ifdef	END_OF_LIST
#undef	END_OF_LIST
#define	END_OF_LIST(lst)     (lst == NULL)
#endif

#ifdef	MODE_OLDFILE
#undef	MODE_OLDFILE
#define	MODE_OLDFILE         "r"
#endif

void AddTail( struct MinList *, struct MinNode * );

#endif

