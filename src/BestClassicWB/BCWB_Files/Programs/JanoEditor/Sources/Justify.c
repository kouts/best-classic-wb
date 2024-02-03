/**********************************************************
**                                                       **
**      $VER: Justify.c 1.0 (sep 10, 2002)               **
**      little utility module to make block of text      **
**      looks better by making them perfectly square.    **
**                                                       **
**      © T.Pierron, C.Guilaume. Free software under     **
**      terms of GNU public license.                     **
**                                                       **
**********************************************************/

#include <intuition/intuition.h>
#include "Jed.h"
#include "Rawkey.h"
#include "Utility.h"
#include "ProtoTypes.h"

#define  CATCOMP_NUMBERS
#include "Jed_Strings.h"

#define	MAX_BUFFER       1024

static WORD   width          = 78;
static STRPTR justified_line = NULL;
static UWORD  usage          = 0;
static Line   edited_line    = NULL;
static UWORD  removed_line   = 0;
static ULONG  added_line     = 0;
static ULONG  start_line     = 0;
static BOOL   do_split_line  = TRUE;

extern UBYTE BufTxt[256];     /* From Jed.c :-\ */

static void justify_lines( Project );

/* Returns screen column position */
static LONG widest_selected_line( Project p )
{
	if( p->ccp.select )
	{
		LONG column = 0;
		Line line = (p->ccp.yc < p->ccp.yp ?
			p->ccp.cline : p->ccp.line);

		for( ; line && line->flags; line = line->next )
		{
			LONG endcol = (line->flags & LASTSEL ?
				find_nbc(line, p->ccp.endsel) : line->size);

			endcol = x2pos(line, endcol);
			if( column < endcol ) column = endcol;
		}
		return column;
	}
	return -1;
}

/* Let user choose up to where text will be justified */
void select_column( Project p, int init_process )
{
	extern struct IntuiMessage msgbuf;
	extern UBYTE               state;
	static STRPTR              old_title;
	static WORD                old_x, old_width;
	WORD                       x;

	#define	UNDEFINED_COL      0x7fff

	if( init_process )
	{
		state       = SELECT_COL;
		Wnd->Flags |= WFLG_RMBTRAP;
		old_title   = NULL;
		old_width   = UNDEFINED_COL;
		old_x       = -1;
		width       = widest_selected_line( p );
		/* If outside current visible area, take current mouse pos */
		if( width < p->left_pos || width >= gui.nbcol+p->left_pos )
			goto show_vert_line;
	}
	else switch( msgbuf.Class )
	{
		case RAWKEY:
			x = (msgbuf.Qualifier & SHIFTKEYS ? 10 : 1);
			switch( msgbuf.Code )
			{
				case LEFT_KEY:  width -= x; break;
				case RIGHT_KEY: width += x; break;
				case ESC_KEY:   goto cancel_select;
				case RETURN_KEY:
				case NENTER_KEY: goto confirm_select;
			}
			break;
		case MOUSEMOVE:
			show_vert_line:
			width = (msgbuf.MouseX - gui.left) / XSIZE + p->left_pos;
			break;
		case MOUSEBUTTONS:
			switch( msgbuf.Code )
			{
				case MENUDOWN: cancel_select:
					/* Cancel selection */
					width = UNDEFINED_COL;
				case SELECTDOWN: confirm_select:
					Wnd->UserData = old_title;
					Wnd->Flags   &= ~WFLG_RMBTRAP;
					state         = STAND_BY;
					StopError( Wnd );
			}
	}
	SetDrMd(RP, COMPLEMENT);
	if( width != UNDEFINED_COL )
	{
		if( width < 5 ) width = 5;
		x = (width - p->left_pos) * XSIZE + gui.left - 2;
		if( x > gui.rcurs || state == STAND_BY ) x = -1;
	}
	else x = -1;
	if( old_x > 0 )
	{
		if( old_x != x )
			RectFill( RP, old_x, gui.top, old_x+1, gui.bottom );
		else
			goto skip_some_things;
	}
	if( x > 0 ) RectFill(RP, x, gui.top, x+1, gui.bottom);
	if( width != UNDEFINED_COL && width != old_width )
	{
		if( old_title == NULL )
			old_title = Wnd->UserData;
		SetTitle(Wnd, my_SPrintf(ErrMsg(INFO_COLUMN), &width));
		old_width = width;
	}
	skip_some_things:
	SetDrMd(RP, JAM2); old_x = x;

	/* Shall we do justification ? */
	if( state == STAND_BY && width != UNDEFINED_COL )
		justify_lines( p );
}

/* Bourrin mais efficace ;-) */
static void add_or_create_line( Project p, STRPTR data, UWORD len )
{
	if( do_split_line )
	{
		split_line( &p->undo, edited_line, edited_line->size, NULL, 0 );
		do_split_line = FALSE;
		added_line++;
		edited_line = edited_line->next;
	}
	insert_str( &p->undo, edited_line, edited_line->size, data, len );
}

static void flush_string( Project p )
{
	if( usage > 0 )
		add_or_create_line( p, justified_line, usage );
	do_split_line = TRUE;
	usage         = 0;
}

static void bufferize_string( Project p, STRPTR string, WORD length )
{
	if( usage + length >= MAX_BUFFER )
	{
		/* Flush content of buffer inside Edit buffer */
		if( usage > 0 )
			add_or_create_line( p, justified_line, usage );
		usage = 0;
	}
	if( length < MAX_BUFFER )
	{
		CopyMem( string, justified_line + usage, length );
		usage += length;
	}
	else add_or_create_line( p, string, length );
}

/* Count words that can fit in "width" characters */
WORD count_words( Project p, Line ln, ULONG stcol, ULONG first_col,
                  BOOL * is_end, WORD * nb_chars )
{
	WORD nb_word, i, length;
	Line line;

	for( line = ln, nb_word = 0, i = length = x2pos(ln, first_col);
		 line && line->flags /* && i < width */; line = line->next )
	{
		STRPTR sp, word, prev;
		ULONG  endcol;

		if( line != ln )
		stcol  = (line->flags & FIRSTSEL ? find_nbc(line, p->ccp.startsel) : 0);
		endcol = (line->flags & LASTSEL  ? find_nbc(line, p->ccp.endsel)   : line->size);

		/* Count words that can fit in one line */
		for( sp = word = prev = line->stream + stcol; ; i++, stcol++ )
		{
			/* Wrap words */
			if( TypeChar[*sp] == SPACE || stcol == endcol )
			{
				if( sp > word ) nb_word++, length += sp - prev;
				for( sp++; TypeChar[*sp] == SPACE; sp++, stcol++ )
					if( stcol >= endcol ) break;
				prev = sp;
			}
			else sp++;
			if( stcol == endcol ) break;
			if( nb_word && i >= width ) goto break_all;
		}
	}
	break_all:
	*is_end   = (line == NULL || line->flags == 0);
	*nb_chars = length;
	return nb_word;
}

#define	get_nth_line( result, start, nth ) \
{ \
	register Line  line  = start; \
	register ULONG count = nth;   \
	for( ; count--; line = line->next ); \
	result = line; \
}

/* Perform visual changes on current edit area */
static void cleanup_display( Project p )
{
	/* Get cursor line */
	p->nbl = start_line;

	if( p->ccp.yc > p->ccp.yp )
		p->nbl += added_line - 1;

	/* Get new top visible line */
	p->max_lines += added_line - removed_line;
	p->top_line   = center_vert( p );

	get_nth_line(p->show,   p->the_line, p->top_line);
	get_nth_line(p->edited, p->show,     p->nbl - p->top_line);
	set_cursor_line( p, p->nbl, p->top_line );
	p->ccp.select = FALSE;

	redraw_content( p, p->show, gui.topcurs, gui.nbline );
	inv_curs(p, TRUE);
	prop_adj( p );
	p->ccp.xp = (ULONG)-1;
	RP->Mask  = gui.txtmask;
}

#undef	get_nth_line

static void bufferize_spaces( Project p, int nb_spaces )
{
	for( ; nb_spaces > 0; nb_spaces -= 256 )
		bufferize_string( p, BufTxt, nb_spaces > 256 ? 256 : nb_spaces );
}

/* Perform justification of selected block of text */
static void justify_lines( Project p )
{
	BOOL  the_end = FALSE, first_line = TRUE;
	ULONG stcol;
	Line  line;

	if( p->ccp.select == 0 ) return;

	memset( BufTxt, ' ', sizeof(BufTxt) );

	if( !(justified_line = AllocVec( MAX_BUFFER, MEMF_PUBLIC )) )
		return;

	/* First line selected */
	if( p->ccp.yc < p->ccp.yp )
		line = p->ccp.cline, start_line = p->ccp.yc;
	else
		line = p->ccp.line,  start_line = p->ccp.yp;

	edited_line = line->prev;
	added_line  = removed_line = 0;
	stcol       = (line->flags & FIRSTSEL ? find_nbc(line, p->ccp.startsel) : 0);
	do_split_line = TRUE;

	reg_group_by( &p->undo );

	/* Scan through selected lines, and format paragraph */
	while( ! the_end )
	{
		WORD  nb_word, length, nb_space, residue;
		ULONG endcol, first_col;

		/* Keep starting character not selected */
		if( !first_line )
		{
			first_col = (line->flags & FIRSTSEL ? find_nbc(line, p->ccp.startsel) : 0);

			if( first_col > 0 )
				bufferize_string( p, line->stream, first_col );
		} else {
			first_line = FALSE;
			first_col  = stcol;
			if( stcol > 0 ) bufferize_string( p, line->stream, stcol );
		}
		/*
		 * Need to go ahead first, to know number of words that can fit
		 * into one line, in order to insert right amount space between
		 * each word.
		 */
		nb_word  = count_words(p, line, stcol, first_col, &the_end, &length);
		length   = width - length;
		nb_space = nb_word-1;
		residue  = 0;
		endcol   = 0;

		/* Rewrite one line */
		while( TRUE )
		{
			STRPTR start, sp;

			endcol = (line->flags & LASTSEL ? find_nbc(line, p->ccp.endsel) : line->size);

			for( sp = start = line->stream + stcol; nb_word > 0; stcol++ )
			{
				if( TypeChar[*sp] == SPACE || stcol == endcol )
				{
					if( sp > start && --nb_word && nb_space )
					{
						LONG spaces;
						if( the_end == FALSE )
						{
							spaces = length / nb_space;
							residue += length % nb_space;
							if( residue >= nb_space ) spaces++, residue -= nb_space;
						}
						else spaces = 1;
						bufferize_spaces( p, spaces );
					}
					for( sp++; TypeChar[*sp] == SPACE; sp++, stcol++ )
						if( stcol >= endcol ) break;
				}
				else bufferize_string( p, sp, 1 ), sp++;

				if( stcol == endcol ) break;
			}
			/* Not enough words found on this line, continue with the next one */
			if( nb_word > 0 )
			{
				Line next = line->next;
				stcol = (line->flags & FIRSTSEL ? find_nbc(line, p->ccp.startsel) : 0);
				if( del_line( &p->undo, &p->the_line, line ) )
					removed_line++;
				line = next;
			}
			else break;
		}
		if( endcol < line->size )
		{
			/*
			 * On last block-selected line and if there are some characters
			 * after the selection, add white spaces to keep alignment.
			 */
			if( the_end && p->ccp.select == COLUMN_TYPE )
			{
				LINE dummy;
				dummy.stream = justified_line;
				bufferize_spaces( p, width - x2pos(&dummy, usage) );
			}
			bufferize_string( p, line->stream + endcol, line->size - endcol );
		}
		flush_string(p);
	}
	/* Remove meaningless lines */
	while( line && line->flags )
	{
		/* This is not totally like del_block() */
		Line next = line->next;
		if( line->flags == LASTSEL )
		{
			stcol = find_nbc(line, p->ccp.endsel);
			line->flags = 0;
			if( stcol > 0 )
				rem_chars( &p->undo, line, 0, stcol-1 );
		}
		else if( del_line( &p->undo, &p->the_line, line) )
			removed_line++;
		line = next;
	}

	reg_group_by( &p->undo );
	FreeVec( justified_line );
	cleanup_display( p );
}
