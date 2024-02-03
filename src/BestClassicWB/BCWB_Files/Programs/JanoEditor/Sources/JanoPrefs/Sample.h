/** Simple constants definition **/

#ifndef	SAMPLE_H
#define	SAMPLE_H

struct FontStyle
{
	UWORD fs_Bg, fs_Fg;
	UWORD fs_Style;
};

struct SampleEd
{
	UWORD  sed_StyleIndex;
	STRPTR sed_Text;
};

#define	EXTEND_RIGHT  30
#define	END_SAMPLE    "\xff"

/** Setup mini-gui for sample **/
void init_sample( struct IBox *, Prefs);

/** Render piece of JanoEditor **/
void render_sample( struct Window *, UBYTE what );

/** Render tokens highlighting sample **/
void render_sample_syntax( struct Window *, struct IBox *, UBYTE what );

/** Free memory **/
void free_sample( void );

#endif
