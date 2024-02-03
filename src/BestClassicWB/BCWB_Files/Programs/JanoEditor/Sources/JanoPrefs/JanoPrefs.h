/*
 * JanoPrefs.h : Definition of some useful macros
 * Free software under GNU license
 * Written by T.Pierron, C.Guillaume, november 11, 2000.
 */

#ifndef	JANOPREFS_H
#define	JANOPREFS_H

#ifndef	PREFS_UTILITY_H
#include "Utils.h"
#endif

#define	PREFNAME       "JanoPrefs"
#define	PREFVERSION    "1.1"
#define	PREFDATE       "june 8, 2002"

#define	EOT(table)     (table+sizeof(table)/sizeof(table[0]))
#define	EOS(strukt)    ((APTR) (strukt+1))
#define	GetSI(gad)     ((struct StringInfo *)gad->SpecialInfo)

/*
 * These tags are common to all gadgets
 */
extern ULONG UseUnderscore[];
extern ULONG OBPTags[];

/*
 * Shared message strings
 */
extern struct NewMenu newmenu[];
extern STRPTR PrefMsg[], FSCycTxt[];

/*
 * Start of list of strings relative to PrefMsg table
 */
#define CGS         6                    /* Number of cycle/string gadget */
#define CBS         4                    /* Number of checkbox gadget */
#define	NB_SYSPENS  11

#define OkCanSav    (PrefMsg     + 1)
#define StrTabItems (OkCanSav    + 4)
#define MiscTxt     (StrTabItems + 4)    /* Some shortcut definition */
#define ChkTxt      (MiscTxt     + CGS+1)
#define CCTxt       (ChkTxt      + CBS+2)
#define FTCycTxt    (CCTxt       + 1)
#define ScrCycTxt   (FTCycTxt    + 4)
#define ColCycTxt   (ScrCycTxt   + 5)
#define AddRemTxt   (ColCycTxt   + 14)
#define TokensTxt   (AddRemTxt   + 3)
#define CCStrs      (TokensTxt   + 10)
#define SystemStrs  (CCStrs      + 5)
#define RGBStrs     (SystemStrs  + NB_SYSPENS + 1)

#endif
