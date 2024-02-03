#ifndef IMAGES_WBDOCKICON_H

#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif


#define WBDOCKICON_File       (TAG_USER + 0x1401)
#define WBDOCKICON_DefType    (TAG_USER + 0x1402)
#define WBDOCKICON_DiskObject (TAG_USER + 0x1403)
#define WBDOCKICON_EraseBack  (TAG_USER + 0x1404)
#define WBDOCKICON_KeepAspect (TAG_USER + 0x1405)


#define WBDOCKICON_OPENOBJECT 0x144F

struct wbdockOpenObject {
	ULONG MethodID;
	APTR imp_Context;
	struct AppMessage *imp_AppMessage;
	};

#endif /* IMAGES_WBDOCKICON_H */
