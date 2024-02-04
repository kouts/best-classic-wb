#ifndef IMAGES_WBDOCKICON_H

#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif


/* Applicability:         */
/* I = OM_NEW             */
/* S = OM_SET, OM_UPDATE  */
/* G = OM_GET             */

#define WBDOCKICON_File        (TAG_USER + 0x1401)	/* (ISG) (STRPTR)              */
#define WBDOCKICON_DefType     (TAG_USER + 0x1402)	/* (ISG) (UBYTE)               */
#define WBDOCKICON_DiskObject  (TAG_USER + 0x1403)	/* (..G) (struct DiskObject *) */
#define WBDOCKICON_EraseBack   (TAG_USER + 0x1404)	/* (ISG) (BOOL)                */
#define WBDOCKICON_KeepAspect  (TAG_USER + 0x1405)	/* (ISG) (BOOL)                */
#define WBDOCKICON_DefaultTool (TAG_USER + 0x1406)	/* (..G) (STRPTR)              */


#define WBDOCKICON_OPENOBJECT 0x144F

struct wbdockOpenObject {
	ULONG MethodID;
	APTR imp_Context;
	struct AppMessage *imp_AppMessage;
	};

#define WBDOCKICONCLASS "wbdockicon.image"

#endif /* IMAGES_WBDOCKICON_H */
