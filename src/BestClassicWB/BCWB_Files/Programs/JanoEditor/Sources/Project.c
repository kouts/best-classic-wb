/**************************************************************
**                                                           **
**      $VER: Project.c 1.2 (16.2.2000)                      **
**      Handle projects management, and top bar drawing      **
**                                                           **
**      Written by T.Pierron, C.Guillaume. Free software     **
**      under terms of GNU public license.                   **
**                                                           **
**************************************************************/

#include <dos/dos.h>
#include <dos/exall.h>
#include <graphics/rastport.h>
#include <exec/memory.h>
#include <workbench/startup.h>
#include "Jed.h"
#include "RecentFiles.h"
#include "DiskIO.h"
#include "Utility.h"
#include "ProtoTypes.h"

#define  CATCOMP_NUMBERS            /* We will need the string id */
#include "Jed_Strings.h"

Project first = NULL;               /* Keep track of first created project */
UBYTE   NbProject = 0;              /* Number of opened projects */

#ifndef	JANOPREF
/*** Change and set internal project name variables ***/
static void set_project_name( Project p, STRPTR path )
{
	if( path )
	{
		UWORD namelen;

		if( p->pname && p->path ) FreeVec( p->pname );

		namelen = 1 + strlen(
		p->name = (STRPTR) FilePart( p->path = path ) );

		if( (p->pname = AllocVec(namelen, MEMF_PUBLIC)) )
			CopyMem( p->name, p->pname, namelen );
		else
			/* TODO Ooooops what can we do? */ ;
	}
	else p->name = p->pname = ErrMsg(ERR_NONAME);

	p->labsize = strlen(p->name);
}

/*** Alloc a new project ***/
Project new_project( Project ins, Prefs prefs )
{
	Project new = AllocVec(sizeof(*new), MEMF_PUBLIC | MEMF_CLEAR);
	if( new )
	{
		/* Always need at least one line */
		if( ( new->show = create_line(NULL,0) ) )
		{
			InsertAfter(ins, new);
			/* Local preferences herited */
			new->tabsize = prefs->tabsize;
			NbProject++;

			/* The line shown/edited */
			if(NbProject == 1) first = new;
			new->show->prev = new->show->next = NULL;
			new->the_line   = new->edited     = new->show;
			new->ccp.xp     = (ULONG)-1;
			new->max_lines  = 1;
			new->undo.prj   = new->redo.prj = (APTR) new;
			new->redo.rbtype = 1;
			set_project_name(new, NULL);
		}
		else FreeVec(new),new = NULL;
	}
	return new;
}

/*** Try to load the file contained in the project ***/
static WORD load_in_project( Project p, STRPTR path )
{
	LoadFileArgs args;
	WORD         err;

	args.filename = path;

	if(RETURN_OK == (err = load_file( &args )))
	{
		ULONG cursor, new_top;

		/* Project is about to be changed, save some settings */
		if( p->path ) update_recent( p, TRUE );

		/* File successfully loaded - free previous file */
		flush_undo_buf( &p->undo );
		flush_undo_buf( &p->redo );
		trash_file(p->the_line);
		if(p->buffer) FreeVec(p->buffer);

		p->edited    = p->the_line = args.lines;
		p->state     = 0;
		p->savepoint = 0;
		p->buffer    = args.buffer;
		p->max_lines = args.nblines;
		p->eol       = args.eol;

		update_project( p );

		if( p->nbl >= p->max_lines )
			p->nbl = p->max_lines - 1;
		new_top = center_vert( p );
		cursor  = p->nbl; p->nbl = 0;

		set_cursor_line(p, cursor, new_top);
		p->show = p->edited; p->top_line = cursor;
		set_top_line(p, new_top, center_horiz(p));

		/* Ctrl+Z will jump to this line */
		if( cursor != 0 ) p->undo.line = p->edited;
	}
	else ThrowError(Wnd, ErrMsg(err));

	return err;
}

/*** Title of panel has changed, update it ***/
static void update_panel_name( Project activ )
{
	/* Assuming that activ is the currently selected */
	activ->labwid  = TextLength(&RPT, activ->name,
	activ->labsize = strlen(activ->name));
	if( NbProject > 1 )
	{
		RPT.AlgoStyle = FSF_BOLD;
		draw_panel(activ, FALSE, FALSE, TRUE);
	}
}

/*** Load and create a new project from a path ***/
Project load_and_activate( Project ins, STRPTR name, UBYTE ins_type )
{
	Project new;

	if( ins_type >= WBARGS_USE_CURRENT )
	{
		/* Multi-selection: name is actually a (StartUpArgs *) */
		if( ((StartUpArgs *)name)->sa_NbArgs > 0 )
		{
			ins->recent = NULL;
			new = create_projects(ins, ((StartUpArgs *)name)->sa_ArgLst,
			                           ((StartUpArgs *)name)->sa_NbArgs);
			if( new != ins ) {
				inv_curs(ins, FALSE);
				if(ins_type == WBARGS_USE_CURRENT) close_project(ins), FreeVec(ins);
				goto refresh;
			}
			else if( new->recent )
			{
				return select_panel( ins, (ULONG) ((RecentFile)new->recent)->rf_Project,
				                     THIS_PROJECT );
			}
		}
		return NULL;
	}
	else /* Load a single file into `new' */
	{
		APTR    ref;
		Project dup = check_or_create_recent( (APTR) &ref, name );

		if( dup && (ins_type == USE_NEW_PROJECT || warn_already_open( name )) )
		{
			FreeVec(name);
			return select_panel( ins, (ULONG) dup, THIS_PROJECT );
		}
		else /* Open/load project */
		{
			if( dup ) ins_type = USE_NEW_PROJECT;
			new = (ins_type == USE_NEW_PROJECT ? new_project(ins, &prefs) : ins);

			if( new )
			{
				new->recent = ref;
				inv_curs(ins, FALSE);
				if( RETURN_OK == load_in_project(new, name) )
				{
					set_project_name(new, name);
					/* Add a panel tab and show content of file */
					if( ins_type == USE_CURRENT_PROJECT )
						update_panel_name(new);
					else
						refresh:reshape_panel(new);
					active_project(new);
					return new;
				}
				else inv_curs(ins, TRUE);
				if( ins_type == USE_NEW_PROJECT ) close_project(new),FreeVec(new);
			}
		}
		/* Something failed, close project */
		ThrowDOSError(Wnd, name);
		FreeVec(name);
	}
	return NULL;
}

/*** Reload project, flush redolog, reduce fragmentation ***/
void reload_project( Project p )
{
	/* Flush all buffers and reload file */
	unset_modif_mark(p, TRUE);
	inv_curs(p, FALSE);
	if( load_in_project(p, p->path) != RETURN_OK )
		ThrowDOSError( Wnd, p->path );
	prop_adj(p);
	inv_curs(p, TRUE);
}

/*** Insert a file at current cursor position ***/
void insert_file( Project p )
{
	LoadFileArgs args;
	ULONG        length;
	WORD         err;

	if( ( args.filename = ask_load(Wnd, &p->path, TRUE, GetMenuText(208)) ) )
	{
		if( RETURN_OK == (err = read_file( &args, &length )) )
		{
			LONG pos[3];
			reg_group_by(&p->undo);
			if( add_string( &p->undo, p->edited, p->nbc, args.buffer, length, pos) )
			{
				/* Just one line concerned? */
				p->max_lines += pos[2];
				if( pos[1] == 0 ) REDRAW_CURLINE(p)

				move_cursor(p, pos[0], pos[1]);
				if( pos[1] > 0 )    redraw_content(p, p->show, gui.topcurs, gui.nbline);
				if( p->ccp.select ) move_selection(p, p->nbrc, p->nbl);
				inv_curs(p,TRUE); prop_adj(p);
			}
			else ThrowDOSError(Wnd, args.filename);

			if( args.buffer ) FreeVec( args.buffer );

			reg_group_by(&p->undo);
		}
		else ThrowDOSError(Wnd, p->path);

		FreeVec( args.filename );
	}
}

/*** Save one projet ***/
char save_project(Project p, char refresh, char ask)
{
	/* Ask for a name if file doesn't have one */
	if(p->path == NULL || ask)
	{
		STRPTR newname = ask_save(Wnd, &p->path, GetMenuText(105));
		if( newname == NULL || warn_overwrite( newname ) == 0 )
			/* User cancels or there was errors */
			return 0;

		update_recent(p, FALSE);
		set_project_name(p, newname);
		p->state = 0;
	}
	unset_modif_mark(p, FALSE);

	if( refresh )
		SetTitle(Wnd, p->path),
		update_panel_name( p );

	return (char) save_file(p->path, p->the_line, p->eol);
}

/*** Save all modified projects ***/
Project save_projects(Project active, char close)
{
	Project cur, p; int nb = 0;
	for(p=first; p; )
	{
		/* Auto-save modified project */
		if(p->state & MODIFIED) {
			if(save_project(p, FALSE, FALSE) == 0) break; else nb ++;
			if(p == active && close == 0) SetTitle(Wnd, p->path);
		}

		if(close == TRUE)
		{
			cur = p; close_project(p);
			p = p->next; FreeVec(cur);
			if(active == cur) active = p; nb = 0;
		}
		else p=p->next;
	}
	if(NbProject > 0 && nb > 0) reshape_panel(active);
	return active;
}

/*** Makes project the active one (i.e. visible) ***/
char active_project( Project p )
{
	/* If file isn't loaded yet, makes it now */
	if(p->state & PAGINATED)
	{
		/* This call is subject to failed! */
		if( load_in_project(p, p->path) != RETURN_OK )
		{
			/* This is too nasty to attempt something: close faulty project */
			ThrowDOSError(Wnd, p->path);
			close_project(p); FreeVec(p);
			return FALSE;
		}
		else p->state &= ~PAGINATED;
	}
	prop_adj(p);
	init_tabstop(p->tabsize);
	SetTitle(Wnd, p->path ? p->path : p->name);
	SetABPenDrMd(RP,pen.fg,pen.bg,JAM2);

	p->left_pos = curs_visible(p, p->top_line),
	p->xcurs    = (p->nbrc-p->left_pos)*XSIZE + gui.left;

	/* This can speedup a lot, text rendering */
	if(p->ccp.select != 0) RP->Mask = gui.selmask;
	redraw_content(p,p->show,gui.topcurs,gui.nbline);
	if(p->ccp.select == 0) RP->Mask = gui.txtmask;
	inv_curs(p,TRUE);
	draw_info(p);
	return 1;
}

/*** Test if a string represent an AmigaDOS pattern ***/
STRPTR IsPat( STRPTR name )
{
	int    len = strlen( name ) * 2 + 2;
	STRPTR tok;
	/* 512 bytes is used for ExAll buffer scan */
	if( (tok = AllocVec(len + 512, MEMF_CLEAR)) )
	{
		if( ParsePatternNoCase(name, tok+512, len) > 0 )
			return tok;
		FreeVec( tok );
	}
	return NULL;
}

/*** Create a new project with an incomplete path ***/
static BOOL new_file( Project *ins, STRPTR path )
{
	Project new = new_project(*ins, &prefs);
	if( new )
	{
		STRPTR newname;
		UBYTE  err = get_full_path(path, &newname);

		if( err == RETURN_OK )
		{
			/* If project already exists, discards it */
			if( !check_or_create_recent( (APTR) &new->recent, newname ) )
			{
				set_project_name(new, newname); *ins = new;
				new->state = PAGINATED;
				return TRUE;
			}
			else (*ins)->recent = new->recent;
			/* TODO else prevent user ? */
			FreeVec( newname );
		}
		else ThrowError(Wnd, ErrMsg(err));
		close_project(new);
		FreeVec(new);
	}
	else ThrowError(Wnd, ErrMsg(ERR_NOMEM));
	return FALSE;
}

/*** Create a set of projects (command line or WBStartup) ***/
Project create_projects(Project ins_after, APTR args, ULONG nb)
{
	Project new;
	STRPTR  pattern;
	BPTR    cwd = CurrentDir( NULL );

	if(nb > 0)
	{
		register struct WBArg * arg = args;
		for(new = ins_after; nb--; arg++ )
		{
			CurrentDir(arg->wa_Lock);
			/* Directory scan is required with pattern */
			if( ( pattern = IsPat( (STRPTR) FilePart(arg->wa_Name) ) ) )
			{
				struct ExAllControl *eac;
				struct ExAllData    *ead;
				BPTR   lock;
				char   more;
				((STRPTR)PathPart(arg->wa_Name))[0] = 0;
				if((lock = Lock(arg->wa_Name, SHARED_LOCK)))
				{
					CurrentDir( lock );
					if ( (eac = (APTR) AllocDosObject(DOS_EXALLCONTROL, NULL)) )
					{
						eac->eac_LastKey = 0;
						eac->eac_MatchString = pattern+512;
						do {
							more = ExAll(lock, pattern, 512, ED_TYPE, eac);
							if( eac->eac_Entries == 0 ) continue;
							for(ead = (APTR) pattern; ead; ead = ead->ed_Next)
								if(ead->ed_Type < 0 && !new_file(&new, ead->ed_Name))
									goto stop_now;
						} while( more );
						stop_now: FreeDosObject(DOS_EXALLCONTROL, eac);
					}
					UnLock( lock );
				}	/* else bad pattern: discard entry */
				FreeVec( pattern );
			}
			/* Given file contains no pattern */
			else if( !new_file(&new, arg->wa_Name) )
				break;
		}
		CurrentDir( cwd );
		/* Still have no file to edit (pattern with no match) */
		if(new == NULL) goto newempty;

		/* We have a bunch of projects, try to load at least one */
		while( new != ins_after && RETURN_OK != load_in_project(new, new->path) )
		{
			Project prev = new->prev;
			ThrowDOSError(Wnd, new->path);
			close_project(new);
			FreeVec(new); new = prev;
		}
	}
	else newempty: new = new_project(NULL, &prefs);
	CurrentDir( cwd );
	return new;
}

/*** Extract path and file into 2 separate pointers (for ASL) ***/
void split_path( STRPTR path[], STRPTR *dir, STRPTR *file )
{
	extern UBYTE BufTxt[256];

	if( path[0] )
	{
		UWORD Len = path[1] - path[0];

		if(Len >= sizeof(BufTxt)) Len = sizeof(BufTxt)-1;
		if(path[0][Len-1] == '/') Len--;
		CopyMem(path[0], BufTxt, Len); BufTxt[Len] = '\0';
		*dir = BufTxt;
	}
	else *dir = NULL;

	*file = path[2];
}

/*** Set or unset modification flag on this project ***/
void set_modif_mark(Project p)
{
	p->state |= MODIFIED;
	if( p->path )
	{
		strcat(p->name, STR_MODIF);
		update_panel_name( p );
		SetTitle(Wnd, p->path);
	}
}
void unset_modif_mark(Project p, char update)
{
	commit_work( p );
	if( p->path && (p->state & MODIFIED) )
	{
		p->labsize = strlen(p->name) - sizeof(STR_MODIF) + 1;
		p->name[ p->labsize ] = 0;
		if( update ) SetTitle(Wnd, p->path);
	}
	p->state = 0;
	if( update ) update_panel_name(p);
}

/*** Close one project and ressources allocated ***/
char close_project(Project p)
{
	/* Close it, only if user knows what he does */
	if( warn_modif(p) )
	{
		/* Save before some values in recent list */
		update_recent(p, TRUE);
		NbProject--;
		trash_file(p->the_line);
		flush_undo_buf( &p->undo );
		flush_undo_buf( &p->redo );
		if(p->buffer) FreeVec(p->buffer);
		if(p->path) { FreeVec(p->path);
		if(p->pname)  FreeVec(p->pname); }
		Destroy(&first, p);
		return TRUE;
	}
	return FALSE;
}

/*** Close all projects, returning the first non-closed or NULL if none ***/
Project close_projects( void )
{
	register Project prj;
	while( first )
	{
		prj = first;
		/* If user doesn't want to close this one */
		if( close_project(first) ) FreeVec(prj);
		else break;
	}
	/* If NULL, then we should quit */
	return first;
}
#endif

/*** PROJECT BAR, GRAPHICAL ROUTINES ***/

/*** Draw one NextStep-like panel item ***/
void draw_panel(Project p, BYTE rclear, BYTE lclear, BYTE activ)
{
	BYTE max = (gui.top-gui.oldtop-1) >> 1, i;
	WORD right = p->pleft + p->pwidth - max - 1;

	WORD bgpan = (activ ? pen.abpan : pen.bgpan);

	/* Bottom line */
	if(rclear == 0) {
		SetAPen(&RPT,pen.shine);
		Move(&RPT, gui.left, gui.top-2);
		Draw(&RPT, p->pleft, RPT.cp_y);
	}
	/* Right shape */
	for(i=0; i<max; i++) {
		Move(&RPT, p->pleft+i, gui.top-2);        SetAPen(&RPT,    bgpan);
		Draw(&RPT, RPT.cp_x,   gui.top-2-(i<<1)); SetAPen(&RPT,pen.shine);
		Draw(&RPT, RPT.cp_x,   RPT.cp_y-1);
		if(rclear) {
			SetAPen(&RPT, pen.panel);
			Move(&RPT, RPT.cp_x, RPT.cp_y-1);
			Draw(&RPT, RPT.cp_x, gui.oldtop);
		}
	}
	/* Upper line */
	Move(&RPT, RPT.cp_x+1, gui.oldtop); SetAPen(&RPT,pen.shine);
	Draw(&RPT, right,      gui.oldtop); SetAPen(&RPT,    bgpan);

	RectFill(&RPT, p->pleft+max, gui.oldtop+1, RPT.cp_x, gui.top-2);
	SetABPenDrMd(&RPT, pen.fgpan, bgpan, JAM2);

	/* Text in the box */
	Move(&RPT,p->pleft+((p->pwidth-p->labwid)>>1), gui.oldtop+prefs.scrfont->tf_Baseline+3 );
	if(!activ && (p->state & PAGINATED)) RPT.AlgoStyle |= FSF_ITALIC;
	Text(&RPT,p->name,p->labsize);

	/* Right shape */
	for(i=0,right++; i<max; i++) {
		Move(&RPT, right+i,  gui.top-2);          SetAPen(&RPT,    bgpan);
		Draw(&RPT, RPT.cp_x, gui.top-((max-i)<<1)); SetAPen(&RPT,pen.shade);
		Draw(&RPT, RPT.cp_x, RPT.cp_y-1);
		if(lclear && i) {
			SetAPen(&RPT,pen.panel);
			Move(&RPT, RPT.cp_x, RPT.cp_y-1);
			Draw(&RPT, RPT.cp_x, gui.oldtop);
		}
	}
	/* Bottom line */
	if( !lclear ) {
		SetAPen(&RPT,pen.shine);
		Move(&RPT, RPT.cp_x,  gui.top-2);
		Draw(&RPT, gui.right, RPT.cp_y);
	}
	SetBPen(&RPT, pen.bg);
}

#ifndef	JANOPREF
/*** Search if a tab is select using mouse ***/
Project select_panel( Project current, ULONG arg, UWORD type )
{
	Project new;
	switch( type )
	{
		case NEXT_PROJECT: new = current->next; break;
		case PREV_PROJECT: new = current->prev; break;
		case NTH_PROJECT:  
			for(new = first; new && --arg; new = new->next);
			break;
		case XWIN_PROJECT:
			for(new=first; new; new=new->next)
				if(new->pleft <= arg && arg < new->pleft+new->pwidth) break;
			break;
		default:
			new = (Project) arg;
	}

	/* Don't change project if it is the same */
	if(new && new != current)
	{
		/* Refresh panel tab first */
		inv_curs(current, FALSE);
		RPT.AlgoStyle = FS_NORMAL; draw_panel(current, FALSE, FALSE, FALSE);
		RPT.AlgoStyle = FSF_BOLD;  draw_panel(new,     FALSE, FALSE, TRUE);

		/* Then content */
		if( active_project(new) == 0 )
			reshape_panel(current);
		else return new;
	}
	return current;
}
#endif

/*** Recompute size of each item and show the active project ***/
void reshape_panel(Project activ)
{
	Project lst; UBYTE i;
	/* Do not show the project bar if there is only one project */
	if( NbProject > 1 )
	{
		WORD height;
		/** Change top position, if not already **/
#ifndef	JANOPREF
		if(gui.top == gui.oldtop)
			adjust_win(Wnd, 1), clear_brcorner();
#endif

		/** Compute items size **/
		for(lst=first,i=1,height=(gui.top-gui.oldtop-2)>>1; lst; lst=lst->next,i++)
		{
			lst->pleft  = (lst==first ? gui.left : lst->prev->pleft+lst->prev->pwidth-height);
			lst->pwidth = (gui.right+1) * i / NbProject - lst->pleft;
			lst->labwid = TextLength(&RPT, lst->name, lst->labsize);
		}
		/** Redraw the project bar **/
		for(lst=first; lst; lst=lst->next) {
			RPT.AlgoStyle = FS_NORMAL;
			/* Active project should be the last drawn */
			if(lst != activ)
				draw_panel(lst, lst->prev==activ || !lst->prev, TRUE, FALSE);
		}
		RPT.AlgoStyle = FSF_BOLD;
		draw_panel(activ, !activ->prev, !activ->next, TRUE);
	}
#ifndef	JANOPREF
	else if(gui.oldtop != gui.top) {
		SetAPen(&RPT, pen.bg);
		RectFill(&RPT, gui.left, gui.oldtop, gui.right, gui.top);
		/** Remove project bar, if it lefts only one project **/
		adjust_win(Wnd, 0); clear_brcorner();
	}
#endif
}
