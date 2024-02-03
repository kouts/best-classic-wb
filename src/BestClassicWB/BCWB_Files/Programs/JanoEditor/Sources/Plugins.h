/*
** Plugins.h - Private datatypes for managing internal buffers.
** Free software under terms of GNU public license.
** Written by T.Pierron & C.Guillaume on nov 24, 2002.
*/

#ifndef	PLUGINS_H
#define	PLUGINS_H

#ifndef	MEMORY_H
#include "Memory.h"
#endif

/* This type must remain opaque */
struct FileDescriptor
{
	APTR fd_Project;
	Line fd_CurLinePtr;
	LONG fd_CurLine;
	LONg fd_CurColumn;
};



#endif
