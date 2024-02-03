/*
 * Utils.h: Prototypes of some useful functions
 * Free software under GNU license, started on 11/11/2000
 * Written by T.Pierron, C.Guillaume for JanoPrefs
 */

#ifndef	PREFS_UTILITY_H
#define	PREFS_UTILITY_H

/*** snprintf like routine ***/
UWORD my_snprintf( STRPTR buffer, UWORD max, STRPTR fmt, APTR args );

/*** Show or build main preference window ***/
BOOL setup_guipref( void );

/*** Close preference window, sending command to Jano ***/
void close_prefwnd( UWORD cmd );

/*** Measure the maximal lenght of a NULL-terminated array of string ***/
WORD meas_table( STRPTR * );

/*** Extract some information of a TextFont struct ***/
void font_info( STRPTR buf, struct TextFont * );

/*** Same job with a (struct Screen *) ***/
void scr_info( STRPTR buf, WORD * WidthHeightDepth );

/*** Try to load an already loaded font ***/
struct TextFont *get_old_font( STRPTR /* name/size */ );

/*** Ask user for a file using ASL requester ***/
BOOL choose_file( STRPTR path, UWORD max );

/*** Free things allocated for ASL stuff ***/
void free_asl( void );

/*** Set default preference ***/
void default_prefs();

/*** Save current configuration to restore it later if desired ***/
void save_config( char ConfigFile );

/*** Display an error message in the window's title ***/
void ThrowError( struct Window *, STRPTR );

/*** Show messages associated with IoErr() number ***/
void ThrowDOSError(struct Window *, STRPTR Prefix);

/*** Reset the old title of the window after a ThrowError() ***/
void StopError( struct Window * );

/*** To temporarize error message ***/
extern ULONG err_time;

/*** Localization stuff ***/
void free_locale( void );
void prefs_local( void );

/*** Free custom RGB pens, that are allocated ***/
void release_pens( ULONG * spec, ULONG * pens, UWORD nb );

/* Get correct pen number according to pen specification */
void get_correct_pens( ULONG * spec, ULONG * pens, UWORD nb );

#ifdef	INTUITION_INTUITION_H
/*** flush message port of window before to close it ***/
void safe_close_window( struct Window * );

int count_gadget( struct Gadget * );
#endif

#ifdef	PREFS_H
/*** Restore config ***/
void restore_config( Prefs );
#endif

#ifdef	ErrMsg
#undef	ErrMsg
#endif

#define ErrMsg(num)		JanoMessages[ num-ERR_BADOS ]
extern  STRPTR JanoMessages[];

#endif
