/*
 * Edit.h : Standard datatypes and prototypes
 * Written by T.Pierron and C.Guillaume
 * Free software under terms of GNU public license.
 */


#ifndef	EDIT_H
#define	EDIT_H

void del_block(Project);
void indent_by(Project, UBYTE ch, BYTE method);
void change_case(Project, UBYTE method);
void mark_all(Project);
LONG copy_mark_to_buf(Project, STRPTR Buf, LONG Max);
void line_selection(Project);

#endif

