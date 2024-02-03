#ifndef GADGETS_WBDOCKAPP_H
#define GADGETS_WBDOCKAPP_H 1

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

#define WBDOCK_MinWidth        (TAG_USER + 0x1506)
#define WBDOCK_MinHeight       (TAG_USER + 0x1507)

#define WBDOCK_Screen          (TAG_USER + 0x1F98)
#define WBDOCK_HitBox          (TAG_USER + 0x1F99)
#define WBDOCK_HelpText        (TAG_USER + 0x1F9A)

#define WBDOCK_Context         (TAG_USER + 0x1F9B)
#define WBDOCK_IconImageClass  (TAG_USER + 0x1F9C)
#define WBDOCK_BackFillClass   (TAG_USER + 0x1F9D)



#define WBDOCK_TICK       0x802

struct wbdockTick {
	ULONG MethodID;
	struct Window *wbt_Window;
	ULONG wbt_Visible;
	};



#define WBDOCK_DROPICON   0x803

struct wbdockDropIcon {
	ULONG MethodID;
	struct Window *wbdi_Window;
	struct AppMessage *wbdi_AppMessage;
	};


#endif /* GADGETS_WBDOCKAPP_H */
