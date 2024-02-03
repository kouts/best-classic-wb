
#define __NOLIBBASE__
#include <proto/exec.h>

#include <exec/resident.h>

#ifdef __VBCC__
#define __D0 __reg("d0")
#define __A0 __reg("a0")
#define __A6 __reg("a6")
#endif



LONG _start (void)

{
return (-1);
}



extern const char GadgetName[];
extern const char GadgetIdString[];
extern UWORD GadgetVersion;
extern UWORD GadgetRevision;

APTR GadgetInitClass (void);
void GadgetFreeClass (APTR cl);


struct GadgetBase {
	struct Library gadget_Lib;
	UWORD gadget_Pad;
	APTR gadget_Class;
	APTR gadget_SegList;
	};

struct Library *SysBase;

__saveds
static struct GadgetBase *GadgetInit (__D0 struct GadgetBase *gadgetbase,__A0 APTR seglist,__A6 struct Library *execbase)

{
SysBase = execbase;

gadgetbase->gadget_SegList = seglist;

if (!(gadgetbase->gadget_Class = GadgetInitClass()))
	return (NULL);

gadgetbase->gadget_Lib.lib_Node.ln_Type = NT_LIBRARY;
gadgetbase->gadget_Lib.lib_Node.ln_Name = (char *)GadgetName;
gadgetbase->gadget_Lib.lib_Flags = LIBF_SUMUSED|LIBF_CHANGED;
gadgetbase->gadget_Lib.lib_Version = GadgetVersion;
gadgetbase->gadget_Lib.lib_Revision = GadgetRevision;
gadgetbase->gadget_Lib.lib_IdString = GadgetIdString;

return (gadgetbase);
}


__saveds
static struct GadgetBase *GadgetOpen (__A6 struct GadgetBase *gadgetbase,__D0 ULONG version)

{
gadgetbase->gadget_Lib.lib_OpenCnt ++;
gadgetbase->gadget_Lib.lib_Flags &= ~LIBF_DELEXP;
return (gadgetbase);
}



#define DeleteLibrary(lib) FreeMem(((UBYTE *)(lib)) - (lib)->lib_NegSize,(lib)->lib_NegSize + (lib)->lib_PosSize);



__saveds
static APTR GadgetExpunge (__A6 struct GadgetBase *gadgetbase)

{
APTR retval;

if (gadgetbase->gadget_Lib.lib_OpenCnt)
	{
	gadgetbase->gadget_Lib.lib_Flags |= LIBF_DELEXP;
	retval = NULL;
	}
else
	{
	retval = gadgetbase->gadget_SegList;
	Remove (&gadgetbase->gadget_Lib.lib_Node);
	GadgetFreeClass (gadgetbase->gadget_Class);
	DeleteLibrary (&gadgetbase->gadget_Lib);
	}

return (retval);
}



__saveds
static APTR GadgetClose (__A6 struct GadgetBase *gadgetbase)

{
gadgetbase->gadget_Lib.lib_OpenCnt --;

if (gadgetbase->gadget_Lib.lib_OpenCnt == 0)
	{
	if (gadgetbase->gadget_Lib.lib_Flags & LIBF_DELEXP)
		return (GadgetExpunge (gadgetbase));
	}

return (NULL);
}



static ULONG GadgetReserved (void)

{
return (0);
}




__saveds
static APTR GadgetGetClass (__A6 struct GadgetBase *gadgetbase)

{
return (gadgetbase->gadget_Class);
}



static APTR GadgetFuncTable[] = {
	(APTR)GadgetOpen,
	(APTR)GadgetClose,
	(APTR)GadgetExpunge,
	(APTR)GadgetReserved,
	(APTR)GadgetGetClass,
	(APTR)-1
	};

static ULONG GadgetDataTable[] = {
	0
	};


static APTR InitTable[] = {
	(APTR)sizeof(struct GadgetBase),
	(APTR)GadgetFuncTable,
	(APTR)GadgetDataTable,
	(APTR)GadgetInit
	};

static struct Resident RomTag = {
	RTC_MATCHWORD,
	&RomTag,
	&RomTag + 1,
	RTF_AUTOINIT,
	42,
	NT_LIBRARY,
	0,
	(char *)GadgetName,
	(char *)GadgetIdString,
	InitTable
	};

