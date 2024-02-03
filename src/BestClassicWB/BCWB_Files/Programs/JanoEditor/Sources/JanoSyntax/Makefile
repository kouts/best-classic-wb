# Makefile for JanoSyntax
# Written by T.Pierron May 1, 2002

EXE = syntax
INC = -I/amiga/include
OPT = -DUNIX -g # -O2 -s -mc68020
LD  = -g # -s -noixemul
OBJ = JanoSyntax.o DFA.o Unix.o

all: $(EXE)

%.o: %.c
	gcc -c $< $(OPT) $(INC)

$(EXE): $(OBJ)
	gcc -o $(EXE) $(OBJ) $(LD)

count:
	@wc *.c

clean:
	rm -f *.o $(EXE)

DFA.c: DFA.h
