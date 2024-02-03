/*
 * Prefs_Strings.c: locale library support of pref tool
 * Free software under terms of GNU public license.
 * Written by T.Pierron & C.Guillaume, february 24, 2001
 */

#include <libraries/gadtools.h>
#include <libraries/locale.h>
#include <proto/locale.h>

#define  CATCOMP_STRINGS		/* and the english string corresponding to the id */
#include "Catalogs.h"

#include "JanoPrefs.h"

/* Messages from all interface of JanoPrefs */
STRPTR PrefMsg[] = {
	MSG_TITLEWIN_STR,
	MSG_PREFSSAVE_STR,        MSG_USEPREFS_STR,        MSG_DISCARDPREFS_STR,  NULL,
	MSG_GENERALTAB_STR,       MSG_SYNTAXTAB_STR,       MSG_COLORTAB_STR,      NULL,
	MSG_TAB_STR,              MSG_SEPARATORS_STR,      MSG_RECENTPATH_STR,    MSG_TXTFONT_STR,
	MSG_SCRFONT_STR,          MSG_PUBSCREEN_STR,       NULL,
	MSG_BACKDROP_STR,         MSG_INVERTQUAL_STR,      MSG_AUTOINDENT_STR,    MSG_EXTEND_STR,
	MSG_LEFTMARGIN_STR,       NULL,
	MSG_COLORCHOOSER_STR,
	NULL,                     MSG_USEDEF_STR,          MSG_CHOOSEIT_STR,      NULL,
	NULL,                     MSG_CLONEPARENT_STR,     NULL,                  NULL, NULL,
	MSG_COLOR_BACK_STR,       MSG_COLOR_TEXT_STR,      MSG_COLOR_FILLTXT_STR, MSG_COLOR_FILLSEL_STR,
	MSG_COLOR_MARGINBACK_STR, MSG_COLOR_MARGINTXT_STR, MSG_COLOR_SHINE_STR,   MSG_COLOR_SHADE_STR,
	MSG_COLOR_PANELBACK_STR,  MSG_COLOR_PANELTEXT_STR, MSG_COLOR_GLYPH_STR,   MSG_COLOR_MARKEDLINES_STR, NULL,
	MSG_SYNDATABASE_STR,      MSG_ADDSYNTAX_STR,       MSG_REMSYNTAX_STR,     NULL,
	MSG_SYNNORMAL_STR,        MSG_SYNTYPE_STR,         MSG_SYNKEYWORD_STR,    MSG_SYNCOMMENT_STR,
	MSG_SYNMACRO_STR,         MSG_SYNCONSTANT_STR,     MSG_SYNSPECIAL_STR,    MSG_SYNERROR_STR,
	MSG_SYNALL_STR,           NULL,

	MSG_CC_TITLE_STR,
	MSG_CCTAB_PALETTE_STR,    MSG_CCTAB_SYSTEM_STR,    MSG_CCTAB_RGB_STR,     NULL,
	MSG_SYS_DETAL_STR,        MSG_SYS_BLOCK_STR,       MSG_SYS_STDTEXT_STR,
	MSG_SYS_SHINEEDGE_STR,    MSG_SYS_DARKEDGE_STR,    MSG_SYS_FILLPEN_STR,
	MSG_SYS_FILLTEXTPEN_STR,  MSG_SYS_BACKGROUND_STR,  MSG_SYS_HITEXT_STR,
	MSG_SYS_MENUTEXT_STR,     MSG_SYS_MENUBACK_STR,    NULL,
	MSG_SLIDER_RED_STR,       MSG_SLIDER_GREEN_STR,    MSG_SLIDER_BLUE_STR,   NULL,
};

/* Global error messages (taken from Jano) */
STRPTR JanoMessages[] = {
	ERR_BADOS_STR,         ERR_NOASLREQ_STR,
	ERR_NOMEM_STR,         ERR_NOGUI_STR,
	ERR_NONAME_STR,        ERR_WRITECLIP_STR,
	ERR_OPENCLIP_STR,      ERR_NOTXTINCLIP_STR,
	ERR_WRONG_TYPE_STR,    ERR_READCLIP_STR,
	ERR_NOBRACKET_STR,     ERR_NOT_FOUND_STR,
	ERR_LOADFONT_STR,      ERR_NOPREFEDITOR_STR,
	ERR_BADPREFSFILE_STR,  ERR_FILEMODIFIED_STR,
};


struct NewMenu newmenu[] =
{
	/* Part of strings are shared with Jano */
	{NM_TITLE, MSG_PROJECTTITLE_STR},
	{	NM_ITEM, MSG_OPENNEWFILE_STR,  "O", 0, 0L, (APTR)101},
	{	NM_ITEM, MSG_SAVEFILEAS_STR,   "A", 0, 0L, (APTR)102},
	{	NM_ITEM, NM_BARLABEL},
	{	NM_ITEM, MSG_QUIT_STR,         "Q", 0, 0L, (APTR)103},

	{NM_TITLE, MSG_EDITTITLE_STR},
	{	NM_ITEM, MSG_RESETDEFAULT_STR, "D", 0, 0L, (APTR)201},
	{	NM_ITEM, MSG_LASTSAVED_STR,    "L", 0, 0L, (APTR)202},

	{NM_END}
};

/* String ID to quote from catalogs for newmenus (IDs aren't contiguous) */
static WORD StrID[] = {
	MSG_PROJECTTITLE, MSG_OPENNEWFILE, MSG_SAVEFILEAS,
	MSG_QUIT,         MSG_EDITTITLE,   MSG_RESETDEFAULT,
	MSG_LASTSAVED
};

static APTR prefs_cat = NULL;
static APTR jano_cat  = NULL;

/*** Localise all strings of the program ***/
void prefs_local(void)
{
	WORD MsgID;
	/* Custom prefs messages */
	if( (prefs_cat = (APTR) OpenCatalogA(NULL,"JanoPrefs.catalog", NULL)) &&
	    (jano_cat  = (APTR) OpenCatalogA(NULL,"JanoEditor.catalog",NULL)) )
	{
		{	/* Various message of pref */
			STRPTR *str;
			for(str = PrefMsg, MsgID=MSG_TITLEWIN; str < EOT(PrefMsg); str++)
				if(*str != NULL)
					*str = (STRPTR) GetCatalogStr(prefs_cat,MsgID++,*str);
		}
		{	/* NewMenus */
			struct NewMenu * nm;
			STRPTR           str;

			for(nm = newmenu, MsgID = 0; nm->nm_Type != NM_END; nm++)
			{
				if (nm->nm_Label == NM_BARLABEL) continue;

				str = (STRPTR) GetCatalogStr(MsgID<5 ? jano_cat : prefs_cat,
						StrID[MsgID],nm->nm_Label);
				MsgID++;
				/* Change shortcut to user prefered one */
				if (*str == 127) {
					nm->nm_CommKey  = str+1; str += 2;
					nm->nm_Flags   &= ~NM_COMMANDSTRING;
				}
				nm->nm_Label = str;
			}
		}
		/* Common messages with Jano */
		{
			STRPTR *str;
			for(str = JanoMessages, MsgID=ERR_BADOS; str < EOT(JanoMessages); str++)
				*str = (STRPTR) GetCatalogStr(jano_cat,MsgID++,*str);
		}
	}
}

/*** Free allocated ressource ***/
void free_locale(void)
{
	if(prefs_cat) CloseCatalog(prefs_cat);
	if(jano_cat)  CloseCatalog(jano_cat);
}
