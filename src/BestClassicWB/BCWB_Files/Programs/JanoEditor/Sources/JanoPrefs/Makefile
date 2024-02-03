#
# GNU Makefile for JanoPref. By T.Pierron
# For use with gcc
#

# System environment
EXE    = /amiga/c/JanoPrefs
CC     = gcc -s
CFLAGS = -I/amiga/include -I.. -Wall -DJANOPREF -O2 #-m68020
LIBS   = -noixemul
RM     = rm -f #Delete quiet
VPATH  = ..

OBJ = ColorsTab.o GeneralTab.o JanoPrefs.o Palette.o Panel.o \
      PrefsIO.o PrefsPort.o Prefs_Strings.o SampleEd.o SyntaxTab.o \
      Utils.o

all: $(EXE)

PrefsIO.c: Prefs.c
	cp -f ../Prefs.c $@

# Implicit rule to produce object file
%.o:%.c
	$(CC) -c $< $(CFLAGS)

$(EXE): $(OBJ)
	$(CC) $(OBJ) -o $(EXE) $(LIBS)

clean:
	$(RM) $(OBJ)

# Special  dependencies
JanoPrefs.o: Prefs.h JanoPrefs.h Utils.h IPC_Prefs.h Prefs_Strings.h Jed_Strings.h Sample.h
PrefsPort.o: Prefs.h Version.h IPC_Prefs.h
Prefs_Strings.o: Prefs_Strings.h Jed_Strings.h
SampleEd.o: Prefs.h Project.c Project.h Gui.h Memory.h UndoRedo.h Sample.h
Utils.o: Prefs.h JanoPrefs.h Utils.h Jed_Strings.h
Palette.o: Palette.h
