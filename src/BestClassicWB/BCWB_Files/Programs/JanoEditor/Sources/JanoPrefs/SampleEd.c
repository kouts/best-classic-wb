/*
** SampleEd.c: Show an sample editor in JanoPrefs.
** Free software under GNU license, started on 18/11/2000
** Written by T.Pierron, C.Guillaume.
*/

/* Share the rendering routines of this module */
#include <libraries/gadtools.h>
#include <proto/layers.h>
#include "Project.c"
#include <graphics/clip.h>
#include <graphics/layers.h>
#include "JanoPrefs.h"
#include "Sample.h"
#include "Jed.h"

struct gv      gui;
struct GuiPens pen = {0,1, 3,2, 3,1, 2,1, 0,1, 3,0};

ULONG BoxTags[] =       /* Draws a recessed box */
{
	GT_VisualInfo,0,
	GTBB_Recessed,TRUE,
	TAG_DONE
};

static struct SampleEd sample_editor[] =
{
	{0, "/*******************************"},
	{1, "*************************** \n"
	    "** jed.c : An simple, fast and efficient text editor     ** \n"
	    "**         Written by T.Pierron an"},
	{0, "d C.Guillaume.         **\n"
       "Started on august 1998.                       **\n"
       "**-------------------------------------------------------**\n"
	    "** Special requirements: WorkBench 2.0, v36 or above     **\n"
	    "**********************************************************/\n"
	    END_SAMPLE },
};

static struct SampleEd sample_syntax[] =
{
	{ 3, "/*\n"
	     " * Sample tokens highlighting possibilities\n"
	     " * Use shift key to change background color\n"
	     " */\n"},
	{ 4, "#ifdef DEBUG\n"},
	{ 7, " */\n"},
	{ 1, "UWORD"},
	{ 0, " snprintf( "},
	{ 1, "STRPTR"},
	{ 0, " buffer, "},
	{ 1, "UWORD"},
	{ 0, " max, "},
	{ 1, "STRPTR"},
	{ 0, " fmt, "},
	{ 1, "APTR"},
	{ 0, " args )\n"
	     "{\n"
	     "   savea3 = buffer; max_buf = max;\n"
	     "   RawDoFmt(fmt, args, ("
	},
	{ 1, "APTR"},
	{ 0, ")my_PutChProc, "},
	{ 5, "0"},
	{ 0, ");\n\n   "},
	{ 2, "return"},
	{ 0, " savea3 - buffer;\n}\n"
	     "snprintf( buf, "},
	{ 2, "sizeof"},
	{ 0, "(buf), "},
	{ 5, "\"[REC] "},
	{ 6, "%4ld"},
	{ 5, ", "},
	{ 6, "%5ld"},
	{ 5, " \""},
	{ 0, ", &my_args );\n" },
	{ 4, "#endif" END_SAMPLE },
};

extern struct RastPort RPT;

/*
** Used to remove a clipping region installed by clipWindow() or
** clipWindowToBorders(), disposing of the installed region and
** reinstalling the region removed. RKM source.
*/
static void unclipWindow(struct Window *win)
{
	struct Region *old_region;

	/* Remove any old region by installing a NULL region,
	** then dispose of the old region if one was installed.
	*/
	if (NULL != (old_region = (void *) InstallClipRegion(win->WLayer, NULL)))
		DisposeRegion(old_region);
}

/*
** Clip a window to a specified rectangle (given by upper left and
** lower right corner.)  the removed region is returned so that it
** may be re-installed later. RKM source.
*/
static struct Region * clipWindow(struct Window *win, LONG minX, LONG minY, LONG maxX, LONG maxY)
{
	struct Region *  new_region;
	struct Rectangle my_rectangle;

	/* set up the limits for the clip */
	my_rectangle.MinX = minX;
	my_rectangle.MinY = minY;
	my_rectangle.MaxX = maxX;
	my_rectangle.MaxY = maxY;

	/* get a new region and OR in the limits. */
	if (NULL != (new_region = (APTR) NewRegion()))
	{
		if (FALSE == OrRectRegion(new_region, &my_rectangle))
		{
			DisposeRegion(new_region);
			new_region = NULL;
		}
	}

	/* Install the new region, and return any existing region.
	** If the above allocation and region processing failed, then
	** new_region will be NULL and no clip region will be installed.
	*/
	return (struct Region *) InstallClipRegion(win->WLayer, new_region);
}

/* Simple project creation */
Project new_project( Project ins, Prefs prefs )
{
	Project new = (Project) AllocVec(sizeof(*new), MEMF_PUBLIC | MEMF_CLEAR);

	if( new  )
	{
		if(ins) ins->next = new, new->prev = ins;

		/* NbProject & first herited from project.c */
		NbProject++;
		if(NbProject == 1) first = new;
	}
	return new;
}

/* Init size & pos of sample, depending fonts sizes */
void init_sample( struct IBox * box, Prefs p )
{
	Project new;

	gui.left   = box->Left+1;
	gui.rcurs  = box->Width;
	gui.right  = box->Left+box->Width+EXTEND_RIGHT;
	gui.bottom = box->Top+box->Height-2;
	gui.oldtop = box->Top+1;
	gui.xsize  = p->txtfont->tf_XSize;
	BoxTags[1] = (ULONG) Vi;

	get_correct_pens( &p->pen.bg, &pen.bg, sizeof(pen)/sizeof(pen.bg) );

	if(first == NULL)
	   if( (new = new_project(NULL, &prefs)) ) {
	   	new->name = "Prefs.c";
	   	new->labsize = 7;
		   if( (new = new_project(new,  &prefs)) ) {
		   	new->name = "JEd.c";
		   	new->labsize = 5;
		   	if( (new = new_project(new,  &prefs)) )
					new->name = "No title",
					new->labsize = 8;
			}
		}
}

/*
 * Draw a sample editor according to color and style specified in
 * the main table.
 */
static void draw_sample( struct RastPort * RP, struct SampleEd * s,
                         struct FontStyle * fs, UWORD bottom )
{
	struct SampleEd * se;
	UWORD             left = RP->cp_x;

	for( se = s; ; se ++ )
	{
		STRPTR p = se->sed_Text, prev = p;

		{	register struct FontStyle * s = &fs[ se->sed_StyleIndex ];
			SetABPenDrMd( RP, s->fs_Fg, s->fs_Bg, JAM2 );
			RP->AlgoStyle = s->fs_Style;
		}
		do
		{
			for( ; *p && *p != '\n' && *p != 255; p++ );

			Text(RP, prev, p - prev); prev = p+1;
			if( *p == '\n' )
			{
				p++; Move(RP, left, RP->cp_y + RP->Font->tf_YSize);
				if( RP->cp_y >= bottom + RP->Font->tf_Baseline ) goto break_all;
			}
			else if( *p == 255 ) goto break_all;
		}
		while( *p );
	}
	break_all: RP->AlgoStyle = FS_NORMAL;
}


/* (Re)draw the sample editor */
void render_sample( struct Window *wnd, UBYTE what )
{
	struct RastPort * RP  = wnd->RPort;
	struct TextFont * old = RP->Font;

	/* Draw a recessed bevel box arround this sample */
	DrawBevelBoxA(
		RP, gui.left-1, gui.oldtop-1,
		    gui.rcurs,  gui.bottom-gui.oldtop+3, (APTR) BoxTags
	);
	clipWindow(wnd, gui.left, gui.oldtop, gui.right-EXTEND_RIGHT-2, gui.bottom);

	/* If font size has changed */
	gui.ysize   = prefs.txtfont->tf_YSize;
	gui.topcurs = prefs.txtfont->tf_Baseline + (
	gui.top     = gui.oldtop+prefs.scrfont->tf_YSize+6);

	if( what & EDIT_GUI )
	{
		/* Redraw factice project bar */
		SetFont(&RPT,prefs.scrfont); reshape_panel(first->next);
	}

	if( what & EDIT_AREA )
	{
		static struct FontStyle EditorPens[] =
		{
			{0, 0, FS_NORMAL},    {0, 0, FS_NORMAL},
		};
		/* Show a sample selected text in the fake editor */
		SetFont(RP,prefs.txtfont);
		SetAPen(RP,pen.bg); Move(RP,gui.left,gui.top-1);
		Draw(RP,gui.right,gui.top-1);

		/* Synchronize colors */
		EditorPens[0].fs_Bg = pen.bg;   EditorPens[1].fs_Bg = pen.bgfill;
		EditorPens[0].fs_Fg = pen.fg;   EditorPens[1].fs_Fg = pen.fgfill;

		Move(RP, gui.left, gui.topcurs);
		draw_sample( RP, sample_editor, EditorPens, gui.bottom );
	}
	unclipWindow(wnd);
	SetFont(RP, old);
}

/*** Free allocated things here ***/
void free_sample( void )
{
	Project next;
	for(; first; next=first->next,FreeVec(first),first=next);
}

/*
 * Show a preview of a dummy syntax file
 */
void render_sample_syntax( struct Window * wnd, struct IBox * box, UBYTE what )
{
	struct RastPort * RP  = wnd->RPort;
	struct TextFont * old = RP->Font;

	UWORD bottom =  box->Top+box->Height-3;

	/* Draw a recessed bevel box arround this sample */
	DrawBevelBoxA(
		RP, box->Left,  box->Top,
		    box->Width, box->Height, (APTR) BoxTags
	);

	clipWindow(wnd, box->Left+2, box->Top+1, box->Left+box->Width-3, bottom);

	if( what & EDIT_GUI )
		SetRast( RP, pen.bg );

	if( what & EDIT_AREA )
	{
		extern struct FontStyle SyntaxPens[];

		SetFont(RP,prefs.txtfont);
		Move(RP, box->Left+2, box->Top + prefs.txtfont->tf_Baseline + 1);
		draw_sample( RP, sample_syntax, SyntaxPens, bottom );
	}
	unclipWindow(wnd);
	SetFont(RP, old);
}
