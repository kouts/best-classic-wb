#
# GNU Makefile for JanoEditor. By T.Pierron
# For use with GNU gcc v2.7.0+
#

# System environment
EXE    = jed
CC     = gcc -s
CFLAGS = -I/amiga/include -Wall -O2 -mc68020
LIBS   = -noixemul
RM     = rm -f #Delete Quiet

OBJ = ClipLoc.o Cursor.o DiskIO.o Edit.o Events.o Gui.o Jed.o \
      Justify.o Macros.o Memory.o Prefs.o Project.o RecentFiles.o \
	  Search.o UndoRedo.o Utility.o

# Implicit rule to produce object file
%.o: %.c
	$(CC) -c $< $(CFLAGS)

all: $(EXE)

$(EXE): $(OBJ)
	$(CC) $(OBJ) -o $(EXE) $(LIBS)

cat: ../Catalogs/JanoEditor.cd
	catcomp $< Jed_Strings.h

clean:
	$(RM) $(OBJ)


# Special dependencies
Memory.o:   Memory.h
Diskio.o:   DiskIO.h Jed_Strings.h
Project.o:  Project.h Gui.h   Jed_Strings.h
Cursor.o:   Project.h Prefs.h Jed_Strings.h
Utility.o:  Project.h Prefs.h Jed_Strings.h Utility.h Memory.h
Prefs.o:    Project.h Prefs.h Jed_Strings.h Version.h 
Gui.o:      Project.h Prefs.h Jed_Strings.h Gui.h 
Edit.o:     Project.h Prefs.h Jed_Strings.h Gui.h 
Events.o:   Project.h Prefs.h Jed_Strings.h IPC_Prefs.h
Search.o:   Project.h Prefs.h Jed_Strings.h
ClipLoc.o:  ClipLoc.h Jed_Strings.h 
Jed.o:      Project.h Prefs.h Jed_Strings.h Gui.h Version.h
UndoRedo.o: Project.h UndoRedo.h Debug.h
Macros.o:   Macros.h
RecentFiles.o: Project.h RecentFiles.h

