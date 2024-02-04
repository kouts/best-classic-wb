#ifndef GADGETS_WBDOCKAPP_H
#define GADGETS_WBDOCKAPP_H 1

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif


/* Applicability:         */
/* I = OM_NEW             */
/* S = OM_SET, OM_UPDATE  */
/* G = OM_GET             */

#define WBDOCK_MinWidth        (TAG_USER + 0x1506)	/* (..G) (UWORD)           */
#define WBDOCK_MinHeight       (TAG_USER + 0x1507)	/* (..G) (UWORD)           */

#define WBDOCK_Hover           (TAG_USER + 0x1607)	/* (.S.) (BOOL)            */

#define WBDOCK_Screen          (TAG_USER + 0x1F98)	/* (IS.) (struct Screen *) */
#define WBDOCK_HitBox          (TAG_USER + 0x1F99)	/* (..G) (struct IBox)     */
#define WBDOCK_HelpText        (TAG_USER + 0x1F9A)	/* (..G) (STRPTR)          */

#define WBDOCK_Context         (TAG_USER + 0x1F9B)	/* (IS.) (Object *)        */
#define WBDOCK_IconImageClass  (TAG_USER + 0x1F9C)	/* (IS.) (Class *)         */
#define WBDOCK_BackFillClass   (TAG_USER + 0x1F9D)	/* (IS.) (Class *)         */
#define WBDOCK_Orientation     (TAG_USER + 0x1F9E)	/* (IS.) (UBYTE)           */

#define WBDOCK_ORIENT_VERT  0x56	/* 'V' */
#define WBDOCK_ORIENT_HORIZ 0x48	/* 'H' */



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


#define WBDOCK_MOUSEOVER  0x804
#define WBDOCK_MOUSEOUT   0x805

/* the two above use struct gpRender

   Note: the GadgetInfo pointed to by gpr_GInfo is not fully populated.
         Only gi_DrInfo is properly filled.
*/


#endif /* GADGETS_WBDOCKAPP_H */
