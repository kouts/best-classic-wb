#include "debug.h"

#if DEBUG

#include <proto/exec.h>

#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>

#include <gadgets/wbdockapp.h>


static const ULONG putchproc[] = {0x16c04e75};



const char *attr_name (ULONG id)

{
static char buffer[20];

switch (id)
	{
case GA_Left:					return ("GA_Left");
case GA_Top:					return ("GA_Top");
case GA_Width:					return ("GA_Width");
case GA_RelWidth:				return ("GA_RelWidth");
case GA_Height:					return ("GA_Height");
case GA_Image:                  return ("GA_Image");
case GA_Previous:				return ("GA_Previous");
case GA_RelVerify:				return ("GA_RelVerify");
case GA_ID:						return ("GA_ID");
case GA_UserData:               return ("GA_UserData");
case GA_DrawInfo:				return ("GA_DrawInfo");
case GA_TextAttr:               return ("GA_TextAttr");
case GA_BackFill:				return ("GA_BackFill");
case GA_GadgetHelpText:			return ("GA_GadgetHelpText");

case ICA_TARGET:				return ("ICA_TARGET");
case ICA_MAP:					return ("ICA_TARGET");

case WBDOCK_MinWidth:           return ("WBDOCK_MinWidth");
case WBDOCK_MinHeight:          return ("WBDOCK_MinHeight");

case WBDOCK_Screen:             return ("WBDOCK_Screen");
case WBDOCK_HitBox:             return ("WBDOCK_HitBox");
case WBDOCK_HelpText:           return ("WBDOCK_HelpText");
case WBDOCK_Context:            return ("WBDOCK_Context");
case WBDOCK_IconImageClass:     return ("WBDOCK_IconImageClass");
case WBDOCK_BackFillClass:      return ("WBDOCK_BackFillClass");

default:
	RawDoFmt ("%08lx",&id,(APTR)putchproc,buffer);
	}

return (buffer);
}




const char *method_name (ULONG id)

{
static char buffer[20];

switch (id)
	{
case OM_NEW:             return ("OM_NEW");
case OM_DISPOSE:         return ("OM_DISPOSE");
case OM_SET:             return ("OM_SET");
case OM_GET:             return ("OM_GET");
case OM_ADDTAIL:         return ("OM_ADDTAIL");
case OM_REMOVE:          return ("OM_REMOVE");
case OM_NOTIFY:          return ("OM_NOTIFY");
case OM_UPDATE:          return ("OM_UPDATE");

case GM_RENDER:          return ("GM_RENDER");
case GM_HITTEST:         return ("GM_HITTEST");
case GM_GOACTIVE:        return ("GM_GOACTIVE");
case GM_HANDLEINPUT:     return ("GM_HANDLEINPUT");
case GM_GOINACTIVE:      return ("GM_GOINACTIVE");
case GM_HELPTEST:        return ("GM_HELPTEST");
case GM_LAYOUT:          return ("GM_LAYOUT");
case GM_DOMAIN:          return ("GM_DOMAIN");

case WBDOCK_TICK:        return ("WBDOCK_TICK");
case WBDOCK_DROPICON:    return ("WBDOCK_DROPICON");
case WBDOCK_MOUSEOVER:   return ("WBDOCK_MOUSEOVER");
case WBDOCK_MOUSEOUT:    return ("WBDOCK_MOUSEOUT");

default:
	RawDoFmt ("%08lx",&id,(APTR)putchproc,buffer);
	}

return (buffer);
}


#endif /* DEBUG */
