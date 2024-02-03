/**********************************************************
**                                                       **
**      $VER: RecentFiles.c 1.0 (may 31, 2002)           **
**      Keep track of recent files accessed.             **
**                                                       **
**      © T.Pierron, C.Guilaume. Free software under     **
**      terms of GNU public license.                     **
**                                                       **
**********************************************************/

#include <libraries/gadtools.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include "Project.h"
#include "RecentFiles.h"
#include "Rawkey.h"
#include "Utility.h"
#include "Gui.h"

#include "ProtoTypes.h"

#define  CATCOMP_NUMBERS		/* We will need the string id */
#include "Jed_Strings.h"

static struct MinList recent_list;
static UWORD          nb_files = 0;

extern struct IntuiMessage * msg, msgbuf;
extern ReviewBuf             search_rb;

/* Simply add a file to the recent list */
static RecentFile register_recent( STRPTR filename, LONG linecoltab[] )
{
	UWORD      len = strlen( filename ) + 1;
	RecentFile new = (APTR) AllocVec( sizeof(*new)+len, MEMF_PUBLIC | MEMF_CLEAR );

	if( new )
	{
		AddHead( (APTR) &recent_list, &new->rf_Node ); nb_files++;
		new->rf_FileName = (STRPTR) (new + 1);
		new->rf_FileSize = len;
		CopyMem( linecoltab, &new->rf_ModifLine, 3*sizeof(ULONG) );
		CopyMem( filename,    new->rf_FileName,  len );
	}
	return new;
}

/* Add a recent file from a project */
Project check_or_create_recent( ULONG * ref, STRPTR filename )
{
	RecentFile list = RECENT_HEAD;

	while( ! END_OF_RECENT(list) )
	{
		if( !Stricmp( filename, list->rf_FileName ) )
		{
			/* Move this project to the beginning of the list */
			Remove( &list->rf_Node );
			AddHead( (APTR) &recent_list, &list->rf_Node );

			/* Udpate project structure */
			*ref = (ULONG) list;
			return list->rf_Project;
		}
		list = RECENT_NEXT(list);
	}
	/* Not yet registered */
	{	LONG args[3];
	
		args[0] = args[1] = 0; args[2] = prefs.tabsize;

		/* Recent project does not exists yet, add it to the list */
		*ref = (ULONG) register_recent( filename, args );
	}
	return NULL;
}

/* Copy recent */
void update_project( Project p )
{
	RecentFile recent;
	if( (recent = p->recent) )
	{
		p->nbl     = recent->rf_ModifLine;
		p->nbrwc   = recent->rf_ModifCol;
		p->tabsize = recent->rf_TabSize;
		recent->rf_Project = p;
	}
}

/* Update the content of a recent file, before closing project */
void update_recent( Project p, BOOL close )
{
	RecentFile list = RECENT_HEAD;

	while( ! END_OF_RECENT(list) && list->rf_Project != p )
		list = RECENT_NEXT(list);

	/* New project maybe unreferenced yet */
	if( ! END_OF_RECENT(list) )
	{
		list->rf_TabSize   = p->tabsize;
		list->rf_ModifLine = p->nbl;
		list->rf_ModifCol  = p->nbrc;
		if( close )
			list->rf_Project = NULL; /* Project will be closed after */
	}
}

/* Free all memory allocated for recent files */
void free_recent( void )
{
	register RecentFile list = RECENT_HEAD, next;

	for( ; (next = RECENT_NEXT(list)); list = next )
		FreeVec( list );
}

/* Save the list of recent files before editor quits */
BOOL save_recent_files( STRPTR filename )
{
	BPTR fh = Open( filename, MODE_NEWFILE );

	if( fh )
	{
		RecentFile list = RECENT_HEAD;
		UWORD      nb   = MAX_RECENT_FILES;

		while( ! END_OF_RECENT(list) && nb-- )
		{
			my_FPrintf( fh, "L=%ld C=%ld TAB=%ld FILE=%s\n", &list->rf_ModifLine );
			list = RECENT_NEXT( list );
		}
		/* Not very clean :-\ */
		for( nb = 0; nb < search_rb->Usage; nb += strlen( search_rb->Buffer + nb ) + 1 )
		{
			STRPTR keyword = search_rb->Buffer + nb;
			my_FPrintf( fh, "SEARCH=%s\n", &keyword );
		}
		Close( fh );

		return TRUE;
	}
	return FALSE;
}

/* Get recent file list */
BOOL read_recent_files( STRPTR filename )
{
	BPTR fh = Open( filename, MODE_OLDFILE ), old_stdin;
	WORD ch, is_ok = TRUE;

	NewList( (APTR) &recent_list );

	if( fh )
	{
		old_stdin = SelectInput( fh );
		do
		{
			struct RDArgs ra, *ret;
			LONG   opt[5];

			memset(&ra,  0, sizeof(ra));
			memset(&opt, 0, sizeof(opt));

			/* Use stdin instead of anything else */
			ra.RDA_Flags = RDAF_NOPROMPT | RDAF_STDIN;

			if( (ret = (APTR) ReadArgs("L/N,C/N,TAB/N,FILE/F,SEARCH/F", opt, &ra)) )
			{
				if( opt[4] )
					AddToBuffer( search_rb, (STRPTR) opt[4], strlen((STRPTR)opt[4]) );

				if( opt[0] ) opt[0] = * (ULONG *) opt[0];
				if( opt[1] ) opt[1] = * (ULONG *) opt[1];
				if( opt[2] ) opt[2] = * (ULONG *) opt[2];
				if( opt[3] ) is_ok = (register_recent( (STRPTR) opt[3], opt ) != NULL);

				FreeArgs( ret );
			}

			ch = FGetC( fh );
		} while( is_ok && ch != -1 && UnGetC(fh, ch) );

		Close( SelectInput( old_stdin ) );
	}
	if( !is_ok ) free_recent();
	return is_ok;
}

/* Popup a window to let user choose ont item among a list */
static struct Node * select_node( struct MinList * list, STRPTR title, int selected )
{
	struct Window * win;
	struct Node *   node;
	int             width, height, nb_item;

	width = TextLength( &RPT, title, strlen(title) ) + 40;
	for( node = (APTR) list->mlh_Head, nb_item = 0;
	     node->ln_Succ; node = node->ln_Succ, nb_item++ )
	{
		int tmp = TextLength(&RPT, node->ln_Name, strlen(node->ln_Name));

		if( tmp > width ) width = tmp;
	}
	height = nb_item * prefs.scrfont->tf_YSize;
	width += 30;

	win = (APTR) OpenWindowTags( NULL,
			WA_InnerWidth,  width  + 10,
			WA_InnerHeight, height + 12,
			WA_Left,        Wnd->LeftEdge + (Wnd->Width  - width)  / 2,
			WA_Top,         Wnd->TopEdge  + (Wnd->Height - height) / 2,
			WA_Title,       (ULONG) title,
			WA_IDCMP,       IDCMP_CLOSEWINDOW | LISTVIEWIDCMP | IDCMP_RAWKEY,
			WA_Flags,       WFLG_CLOSEGADGET  | WFLG_ACTIVATE | WFLG_RMBTRAP |
			                WFLG_DEPTHGADGET  | WFLG_DRAGBAR,
			WA_PubScreen,   (ULONG) Scr,
			TAG_DONE);

	if( win )
	{
		struct NewGadget ng;
		struct Gadget *  glist = NULL, * gad;
		BOOL             quit  = FALSE;

		memset( &ng, 0, sizeof(ng) );
		ng.ng_LeftEdge   = 5 + win->BorderLeft;
		ng.ng_TopEdge    = 4 + win->BorderTop;
		ng.ng_Width      = width;
		ng.ng_Height     = height+4;
		ng.ng_TextAttr   = &prefs.attrscr;
		ng.ng_VisualInfo = Vi;

		BusyWindow( Wnd );

		/* Listview gadget containing recent files list */
		gad = CreateGadget(LISTVIEW_KIND, CreateContext(&glist), &ng, 
				GTLV_Labels,       list,
				GTLV_ShowSelected, NULL,
				GTLV_Selected,     selected, TAG_DONE );

		/* Refresh everything */
		AddGList     (win,  glist, (UWORD)-1, (UWORD)-1, NULL);
		RefreshGList (glist,  win, NULL,      (UWORD)-1);

		GT_RefreshWindow(win, NULL);

		/* Quickly process events */
		while( ! quit )
		{
			WaitPort( win->UserPort );

			while( (msg = (APTR) GT_GetIMsg( win->UserPort )) )
			{
				CopyMemQuick(msg, &msgbuf, sizeof(*msg));
				GT_ReplyIMsg(msg);

				switch( msgbuf.Class )
				{
					case IDCMP_CLOSEWINDOW: quit = TRUE; selected = -1; break;
					case IDCMP_GADGETUP:    quit = TRUE; selected = msgbuf.Code; break;
					case IDCMP_RAWKEY:
						switch( msgbuf.Code )
						{
							case DOWN_KEY:
								if( selected >= nb_item-1 ) continue;
								selected++;
								break;
							case UP_KEY:
								if( selected <= 0 ) continue;
								selected--;
								break;
							case ESC_KEY: selected = -1;
							case RETURN_KEY:
							case NENTER_KEY: quit = TRUE;
							default: continue;
						}
						GT_SetGadgetAttrs(gad, win, NULL, GTLV_Selected, selected,
								GTLV_MakeVisible, selected, TAG_DONE);
				}
			}
		}
		CloseWindow( win );
		FreeGadgets( glist );
		WakeUp( Wnd );

		if( selected >= 0 )
		{
			for( node = (APTR) list->mlh_Head; selected--; node = node->ln_Succ );

			return node;
		}
	}
	else ThrowError(Wnd, ErrMsg(ERR_NOGUI));

	return NULL;
}

/* Show the list of registered files and let user load one */
void show_recent_files( Project current, STRPTR title )
{
	RecentFile recent;
	int        selected = 0;

	/* No care to see list if there is only one project */
	if( nb_files > 1 )
	{
		register RecentFile list = RECENT_HEAD;
		register int        i;
		for( i = 0; ! END_OF_RECENT(list); list = RECENT_NEXT(list), i++ )
		{
			/* Takes project name, thus we can see modified project */
			list->rf_Node.ln_Name = (list->rf_Project ?
				((Project)list->rf_Project)->path : list->rf_FileName);

			if( list->rf_Project == current ) selected = i;
		}
	}
	else return;

	if( (recent = (APTR) select_node( &recent_list, title, selected )) )
	{
		register STRPTR  name;
		extern   Project edit;

		if( !(name = (STRPTR) AllocVec( recent->rf_FileSize, MEMF_PUBLIC )) )
			return;

		CopyMem( recent->rf_FileName, name, recent->rf_FileSize );

		if( !(recent->rf_Project = load_and_activate( edit, name,
				 msgbuf.Qualifier & SHIFTKEYS ? USE_CURRENT_PROJECT : USE_NEW_PROJECT )) )
			return;

		edit = recent->rf_Project;
	}
}

/* Show last search in a window */
void show_recent_search( Project current, STRPTR title, ReviewBuf rb )
{
	typedef struct
	{
		struct Node rs_Chain;
		UWORD       rs_Offset;
		UBYTE       rs_Buffer[1];

	} * RecentSearch;

	struct MinList list;
	RecentSearch   node, select = NULL;
	int            i = 0, nb = 0, selected = 0;

	NewList( (APTR) &list );

	while( i < rb->Usage )
	{
		int size = strlen( rb->Buffer+i )+1;

		if( (node = AllocVec(sizeof(*node) + size, MEMF_PUBLIC)) )
		{
			node->rs_Chain.ln_Name = node->rs_Buffer;

			CopyMem( rb->Buffer+i, node->rs_Chain.ln_Name, size );
			AddTail( (APTR) &list, &node->rs_Chain );
			if( i == rb->Review ) selected = nb;
			node->rs_Offset = i;
			nb++;
		}
		else break;
		i += size;
	}

	if( nb > 1 && (select = (APTR) select_node( &list, title, selected )) )
		HilitePattern( current, select->rs_Buffer, msgbuf.Qualifier & SHIFTKEYS ? -1 : 1, 0 );

	/* deallocate everything */
	{	RecentSearch succ;
		for( node = (APTR) list.mlh_Head; (succ = (APTR) node->rs_Chain.ln_Succ);
		     FreeVec(node), node = succ );
			if( node == select ) rb->Review = node->rs_Offset;
	}
}
