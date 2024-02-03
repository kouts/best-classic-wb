#ifndef PREFS_STRINGS_H
#define PREFS_STRINGS_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef CATCOMP_ARRAY
#undef CATCOMP_NUMBERS
#undef CATCOMP_STRINGS
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#endif

#ifdef CATCOMP_BLOCK
#undef CATCOMP_STRINGS
#define CATCOMP_STRINGS
#endif


/****************************************************************************/


#ifdef CATCOMP_NUMBERS

#define MSG_RESETDEFAULT 0
#define MSG_LASTSAVED 1
#define MSG_TITLEWIN 2
#define MSG_PREFSSAVE 3
#define MSG_USEPREFS 4
#define MSG_DISCARDPREFS 5
#define MSG_GENERALTAB 6
#define MSG_SYNTAXTAB 7
#define MSG_COLORTAB 8
#define MSG_TAB 9
#define MSG_SEPARATORS 10
#define MSG_RECENTPATH 11
#define MSG_TXTFONT 12
#define MSG_SCRFONT 13
#define MSG_PUBSCREEN 14
#define MSG_BACKDROP 15
#define MSG_INVERTQUAL 16
#define MSG_AUTOINDENT 17
#define MSG_EXTEND 18
#define MSG_LEFTMARGIN 19
#define MSG_COLORCHOOSER 20
#define MSG_USEDEF 21
#define MSG_CHOOSEIT 22
#define MSG_CLONEPARENT 23
#define MSG_COLOR_BACK 24
#define MSG_COLOR_TEXT 25
#define MSG_COLOR_FILLTXT 26
#define MSG_COLOR_FILLSEL 27
#define MSG_COLOR_MARGINBACK 28
#define MSG_COLOR_MARGINTXT 29
#define MSG_COLOR_SHINE 30
#define MSG_COLOR_SHADE 31
#define MSG_COLOR_PANELBACK 32
#define MSG_COLOR_PANELTEXT 33
#define MSG_COLOR_GLYPH 34
#define MSG_COLOR_MARKEDLINES 35
#define MSG_SYNDATABASE 36
#define MSG_ADDSYNTAX 37
#define MSG_REMSYNTAX 38
#define MSG_SYNNORMAL 39
#define MSG_SYNTYPE 40
#define MSG_SYNKEYWORD 41
#define MSG_SYNCOMMENT 42
#define MSG_SYNMACRO 43
#define MSG_SYNCONSTANT 44
#define MSG_SYNSPECIAL 45
#define MSG_SYNERROR 46
#define MSG_SYNALL 47
#define MSG_CC_TITLE 48
#define MSG_CCTAB_PALETTE 49
#define MSG_CCTAB_SYSTEM 50
#define MSG_CCTAB_RGB 51
#define MSG_SYS_DETAL 52
#define MSG_SYS_BLOCK 53
#define MSG_SYS_STDTEXT 54
#define MSG_SYS_SHINEEDGE 55
#define MSG_SYS_DARKEDGE 56
#define MSG_SYS_FILLPEN 57
#define MSG_SYS_FILLTEXTPEN 58
#define MSG_SYS_BACKGROUND 59
#define MSG_SYS_HITEXT 60
#define MSG_SYS_MENUTEXT 61
#define MSG_SYS_MENUBACK 62
#define MSG_SLIDER_RED 63
#define MSG_SLIDER_GREEN 64
#define MSG_SLIDER_BLUE 65

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_RESETDEFAULT_STR "Default values"
#define MSG_LASTSAVED_STR "Last saved values"
#define MSG_TITLEWIN_STR "Main setup"
#define MSG_PREFSSAVE_STR "_Save"
#define MSG_USEPREFS_STR "_Use"
#define MSG_DISCARDPREFS_STR "_Cancel"
#define MSG_GENERALTAB_STR "General"
#define MSG_SYNTAXTAB_STR "Syntax"
#define MSG_COLORTAB_STR "Colors"
#define MSG_TAB_STR "_Tabulation:"
#define MSG_SEPARATORS_STR "_Separators:"
#define MSG_RECENTPATH_STR "_Recent files:"
#define MSG_TXTFONT_STR "Text font:"
#define MSG_SCRFONT_STR "Screen font:"
#define MSG_PUBSCREEN_STR "Screen mode:"
#define MSG_BACKDROP_STR "_Backdrop"
#define MSG_INVERTQUAL_STR "In_vert Ctrl and Alt"
#define MSG_AUTOINDENT_STR "Auto _indent"
#define MSG_EXTEND_STR "_Extended numeric pad"
#define MSG_LEFTMARGIN_STR "Left _margin"
#define MSG_COLORCHOOSER_STR "Choose color..."
#define MSG_USEDEF_STR "Use Default"
#define MSG_CHOOSEIT_STR "Choose one..."
#define MSG_CLONEPARENT_STR "Clone parent"
#define MSG_COLOR_BACK_STR "Background"
#define MSG_COLOR_TEXT_STR "Standard text"
#define MSG_COLOR_FILLTXT_STR "Selected fill text"
#define MSG_COLOR_FILLSEL_STR "Selected text"
#define MSG_COLOR_MARGINBACK_STR "Margin background"
#define MSG_COLOR_MARGINTXT_STR "Margin text"
#define MSG_COLOR_SHINE_STR "Panel shine"
#define MSG_COLOR_SHADE_STR "Panel shade"
#define MSG_COLOR_PANELBACK_STR "Panel back"
#define MSG_COLOR_PANELTEXT_STR "Panel text"
#define MSG_COLOR_GLYPH_STR "Panel glyph"
#define MSG_COLOR_MARKEDLINES_STR "Active panel"
#define MSG_SYNDATABASE_STR "Syntax _database:"
#define MSG_ADDSYNTAX_STR "_Add syntax"
#define MSG_REMSYNTAX_STR "_Remove syntax"
#define MSG_SYNNORMAL_STR "Normal"
#define MSG_SYNTYPE_STR "Datatypes"
#define MSG_SYNKEYWORD_STR "Keywords"
#define MSG_SYNCOMMENT_STR "Comments"
#define MSG_SYNMACRO_STR "Pre-processor"
#define MSG_SYNCONSTANT_STR "Constants"
#define MSG_SYNSPECIAL_STR "Special"
#define MSG_SYNERROR_STR "Errors"
#define MSG_SYNALL_STR "All tokens"
#define MSG_CC_TITLE_STR "Color chooser"
#define MSG_CCTAB_PALETTE_STR "Palette"
#define MSG_CCTAB_SYSTEM_STR "System"
#define MSG_CCTAB_RGB_STR "RGB"
#define MSG_SYS_DETAL_STR "Detail pen"
#define MSG_SYS_BLOCK_STR "Block pen"
#define MSG_SYS_STDTEXT_STR "Standard text"
#define MSG_SYS_SHINEEDGE_STR "Shine edge"
#define MSG_SYS_DARKEDGE_STR "Dark edge"
#define MSG_SYS_FILLPEN_STR "Fill pen"
#define MSG_SYS_FILLTEXTPEN_STR "Text over fill"
#define MSG_SYS_BACKGROUND_STR "Background"
#define MSG_SYS_HITEXT_STR "Highlighted text"
#define MSG_SYS_MENUTEXT_STR "Menu text"
#define MSG_SYS_MENUBACK_STR "Menu background"
#define MSG_SLIDER_RED_STR "Red:"
#define MSG_SLIDER_GREEN_STR "Green:"
#define MSG_SLIDER_BLUE_STR "Blue:"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};



#endif /* PREFS_STRINGS_H */
