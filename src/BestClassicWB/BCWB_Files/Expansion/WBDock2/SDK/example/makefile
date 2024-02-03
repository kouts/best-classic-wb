CC      = vc +aos68k
CFLAGS  = -I/include -c99 -warn=-1 -dontwarn=79,81,163,164,166,167,168,306,307,362
LDLIBS  = -lamiga -ldebug

example.dockapp: gadgetbase.o example.o debug.o
	$(CC) -nostdlib $^ -o $@ $(LDLIBS)
	avail >nil: flush

example.o: debug.h example.dockapp_rev.h

debug.o: debug.h

example.dockapp_rev.h: example.c gadgetbase.c
	bumprev 1 example.dockapp

clean:
	-delete example.dockapp gadgetbase.o example.o debug.o

