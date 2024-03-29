/*
 * ProtoTypes.h : Load standard Amiga prototypes declaration
 * Written by T.Pierron 27/5/2000
 */

#ifndef	SKIP_PROTO
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/asl.h>
#include <proto/gadtools.h>
#include <proto/keymap.h>
#include <proto/diskfont.h>
#include <proto/iffparse.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#else

extern APTR AllocVec( ULONG, ULONG );
extern APTR AllocMem( ULONG, ULONG );

#endif
