/* Example dock app for WBDock2                                               */

/*----------------------------------------------------------------------------*/
/* System Includes                                                            */
/*----------------------------------------------------------------------------*/

	#include <proto/exec.h>

	#define __NOLIBBASE__
	#include <proto/intuition.h>
	#include <proto/utility.h>
	#include <proto/icon.h>
	#include <proto/dos.h>

	#include <clib/alib_protos.h>

	#include <workbench/startup.h>
	#include <workbench/icon.h>

	#include <gadgets/wbdockapp.h>
	#include <images/wbdockicon.h>

	#include "debug.h"

	#include "example.dockapp_rev.h"

/*----------------------------------------------------------------------------*/
/* Constants & Macros                                                         */
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Type Definitions                                                           */
/*----------------------------------------------------------------------------*/

	struct example_data {
		struct Screen *screen;
		struct Image *icon;
		APTR context;
		Class *iconimage_class;
		Class *backfill_class;
		BOOL click;
		BOOL needs_layout;
		};

/*----------------------------------------------------------------------------*/
/* Global Variables                                                           */
/*----------------------------------------------------------------------------*/

	struct Library *IntuitionBase;
	struct Library *UtilityBase;
	struct Library *IconBase;
	struct Library *DOSBase;

	const char GadgetName[] = "example.dockapp";
	const char GadgetIdString[] = VSTRING;
	UWORD GadgetVersion = VERSION;
	UWORD GadgetRevision = REVISION;

/*----------------------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/

	static void free_icon (struct example_data *data)

	{
	if (data->icon)
		{
		DisposeObject ((APTR)data->icon);
		data->icon = NULL;
		}
	}

/*----------------------------------------------------------------------------*/
/*                                                                            */
/*----------------------------------------------------------------------------*/

	static void load_icon (struct example_data *data,struct WBArg *wbarg)

	{
	free_icon (data);

	if (wbarg)
		{
		BPTR oldcd = CurrentDir (wbarg->wa_Lock);
		data->icon = NewObject (data->iconimage_class, NULL,
			IA_Screen, data->screen,
			WBDOCKICON_File, wbarg->wa_Name,
			TAG_END);
		CurrentDir (oldcd);
		}
	else
		{
		kprintf ("load_icon: loading default icon\n");
		data->icon = NewObject (data->iconimage_class, NULL,
			IA_Screen, data->screen,
			WBDOCKICON_DefType, WBGARBAGE,
			TAG_END);
		}

	kprintf ("load_icon: icon = %lx\n",data->icon);

	data->needs_layout = TRUE;
	}

/*----------------------------------------------------------------------------*/
/* GM_RENDER method                                                           */
/*----------------------------------------------------------------------------*/

	static ULONG example_layout (Class *cl,struct Gadget *o,struct gpLayout *msg)

	{
	struct example_data *data = INST_DATA(cl,o);

	if (o->GadgetRender && data->icon)
		{
		struct impFrameBox boxmsg;
		struct IBox gadbox;
		struct IBox iconbox;

/*
	We need to call IM_FRAMEBOX here because the icon is not always
	in the center of the gadget and only the background frame knows
	where it should be.
*/
		gadbox.Left    = 0;
		gadbox.Top     = 0;
		gadbox.Width   = o->Width;
		gadbox.Height  = o->Height;

		iconbox.Left   = 0;
		iconbox.Top    = 0;
		iconbox.Width  = data->icon->Width;
		iconbox.Height = data->icon->Height;

		boxmsg.MethodID = IM_FRAMEBOX;
		boxmsg.imp_ContentsBox = &iconbox;
		boxmsg.imp_FrameBox    = &gadbox;
		boxmsg.imp_FrameFlags  = FRAMEF_SPECIFY;

		DoMethodA ((Object *)o->GadgetRender,(Msg)&boxmsg);
/*
	IM_FRAMEBOX places the gadget around the icon. Because I want it
	the other way round, (position the icon inside the gadget), I use
	temporary boxes and then change the icon position.
*/
		data->icon->LeftEdge = -gadbox.Left;
		data->icon->TopEdge  = -gadbox.Top;
		}

	data->needs_layout = FALSE;
	return (TRUE);
	}

/*----------------------------------------------------------------------------*/
/* GM_RENDER method                                                           */
/*----------------------------------------------------------------------------*/

	static ULONG example_render (Class *cl,struct Gadget *o,struct gpRender *msg)

	{
	struct example_data *data = INST_DATA(cl,o);

	if (data->needs_layout)
		DoMethod ((Object *)o,GM_LAYOUT,msg->gpr_GInfo,TRUE);

	DoSuperMethodA (cl,(Object *)o,(Msg)msg);	// erase background and draw frame

	if (data->icon)
		{
		SetAttrs (data->icon,WBDOCKICON_EraseBack,FALSE,TAG_END);
		DrawImageState (msg->gpr_RPort,data->icon,
			o->LeftEdge,o->TopEdge,
			o->Flags & GFLG_SELECTED ? IDS_SELECTED : IDS_NORMAL,
			NULL);
		}

	return (0);
	}

/*----------------------------------------------------------------------------*/
/* GM_INPUT method                                                            */
/*----------------------------------------------------------------------------*/

	static ULONG example_input (Class *cl,struct Gadget *o,struct gpInput *msg)

	{
	ULONG retval = DoSuperMethodA (cl,(Object *)o,(Msg)msg);

	if (retval != GMR_MEACTIVE && retval != GMR_REUSE && retval != GMR_NOREUSE)
		{
		// gadget clicked
		struct example_data *data = INST_DATA(cl,o);
		if (data->icon)
			{
			data->click = TRUE;
			// we may not call workbench from input.device,
			// so we need to remember that we were clicked
			// and open the object later from the main task.
			}
		else
			DisplayBeep (msg->gpi_GInfo->gi_Screen);
		}

	return (retval);
	}


/*----------------------------------------------------------------------------*/
/* WBDOCK_TICK method                                                         */
/*----------------------------------------------------------------------------*/

	static ULONG example_tick (Class *cl,struct Gadget *o,struct wbdockTick *msg)

	{
	struct example_data *data = INST_DATA(cl,o);
	if (data->click)
		{
		data->click = FALSE;
		if (data->icon)
			DoMethod ((APTR)data->icon,WBDOCKICON_OPENOBJECT,data->context,NULL);
		}
	return (0);
	}

/*----------------------------------------------------------------------------*/
/* OM_GET method                                                              */
/*----------------------------------------------------------------------------*/

	static ULONG example_get (Class *cl,struct Gadget *o,struct opGet *msg)

	{
	struct example_data *data = INST_DATA(cl,o);
	ULONG retval = 1;

	switch (msg->opg_AttrID)
		{
	case WBDOCK_MinWidth:
		if (data->icon)
			*msg->opg_Storage = data->icon->Width + 4;
		break;

	case WBDOCK_MinHeight:
		if (data->icon)
			*msg->opg_Storage = data->icon->Height + 4;
		break;

	case WBDOCK_HelpText:
		*msg->opg_Storage = (ULONG)"Example Dock App";
		break;

	default:
		retval = DoSuperMethodA (cl,(Object *)o,(Msg)msg);
		}

	kprintf ("  %s = %lx\n",attr_name(msg->opg_AttrID),*msg->opg_Storage);

	return (retval);
	}

/*----------------------------------------------------------------------------*/
/* OM_SET method                                                              */
/*----------------------------------------------------------------------------*/

	static ULONG example_set (Class *cl,struct Gadget *o,struct opSet *msg)

	{
	struct example_data *data = INST_DATA(cl,o);
	ULONG retval = 0;
	struct TagItem *tag,*tags;

	if (msg->MethodID != OM_NEW)
		retval = DoSuperMethodA (cl,(Object *)o,(Msg)msg);

	tags = msg->ops_AttrList;
	while ((tag = NextTagItem (&tags)))
		{
		kprintf ("  %s = %lx\n",attr_name(tag->ti_Tag),tag->ti_Data);
		switch (tag->ti_Tag)
			{
		case WBDOCK_Screen:
			data->screen = (struct Screen *) tag->ti_Data;
			break;

		case WBDOCK_Context:
			data->context = (APTR) tag->ti_Data;
			break;

		case WBDOCK_IconImageClass:
			data->iconimage_class = (Class *) tag->ti_Data;
			break;

		case WBDOCK_BackFillClass:
			data->backfill_class = (Class *) tag->ti_Data;
			break;
			}
		}

/*	if (msg->ops_GInfo)
		{
		do_render (o,msg->ops_GInfo,GREDRAW_REDRAW);
		retval = 0;
		}
*/
	return (retval);
	}

/*----------------------------------------------------------------------------*/
/* OM_NEW method                                                              */
/*----------------------------------------------------------------------------*/

	static ULONG example_new (Class *cl,struct Gadget *o,struct opSet *msg)

	{
	if ((o = (struct Gadget *)DoSuperMethodA (cl,(Object *)o,(Msg)msg)))
		{
		struct example_data *data = INST_DATA(cl,o);

		example_set (cl,o,msg);

		if (!data->icon)
			load_icon (data,NULL);
		}

	return ((ULONG)o);
	}

/*----------------------------------------------------------------------------*/
/* OM_DISPOSE method                                                          */
/*----------------------------------------------------------------------------*/

	static ULONG example_dispose (Class *cl,struct Gadget *o,Msg msg)

	{
	struct example_data *data = INST_DATA(cl,o);

	free_icon (data);

	return (DoSuperMethodA (cl,(Object *)o,msg));
	}

/*----------------------------------------------------------------------------*/
/* WBDOCK_DROPICON method                                                     */
/*----------------------------------------------------------------------------*/

	static ULONG example_dropicon (Class *cl,struct Gadget *o,struct wbdockDropIcon *msg)

	{
	struct example_data *data = INST_DATA(cl,o);

	load_icon (data,msg->wbdi_AppMessage->am_ArgList);

	RefreshGList (o,msg->wbdi_Window,NULL,1);

#if DEBUG
	if (data->icon)
		{
		char *name;
		GetAttr (WBDOCKICON_File,data->icon,(ULONG *)&name);
		kprintf ("example_dropicon: file = <%s>\n",name);
		}
#endif

	return (0);
	}

/*----------------------------------------------------------------------------*/
/* BOOPSI dispatcher                                                          */
/*----------------------------------------------------------------------------*/

#ifndef __PPC__
	__saveds
#endif
	static ULONG example_dispatcher (Class *cl,struct Gadget *o,Msg msg)

	{
	ULONG retval;

#if DEBUG
	if (msg->MethodID != WBDOCK_TICK)	// this floods the debug output
		kprintf ("\nexample_dispatcher: MethodID = %s\n",method_name(msg->MethodID));
#endif

	switch (msg->MethodID)
		{
	case OM_NEW:
		retval = example_new (cl,o,(struct opSet *)msg);
		break;

	case OM_DISPOSE:
		retval = example_dispose (cl,o,msg);
		break;

	case OM_SET:
	case OM_UPDATE:
		retval = example_set (cl,o,(struct opSet *)msg);
		break;

	case OM_GET:
		retval = example_get (cl,o,(struct opGet *)msg);
		break;

	case GM_LAYOUT:
		retval = example_layout (cl,o,(struct gpLayout *)msg);
		break;

	case GM_RENDER:
		retval = example_render (cl,o,(struct gpRender *)msg);
		break;

	case GM_HANDLEINPUT:
		retval = example_input (cl,o,(struct gpInput *)msg);
		break;

	case WBDOCK_TICK:
		retval = example_tick (cl,o,(struct wbdockTick *)msg);
		break;

	case WBDOCK_DROPICON:
		retval = example_dropicon (cl,o,(struct wbdockDropIcon *)msg);
		break;

	default:
		retval = DoSuperMethodA (cl,(Object *)o,msg);
		}

#if DEBUG
	if (msg->MethodID != WBDOCK_TICK)	// this floods the debug output
		kprintf ("example_dispatcher: retval = %lx\n",retval);
#endif

	return (retval);
	}


/*----------------------------------------------------------------------------*/
/* Free the class and close previously opened libraries                       */
/*----------------------------------------------------------------------------*/

	void GadgetFreeClass (Class *cl)

	{
	kprintf ("\n%sGadgetFreeClass: cl = %lx\n"
			"------------------------------------\n",GadgetIdString,cl);

	if (cl) FreeClass (cl);

	if (DOSBase)       CloseLibrary (DOSBase);
	if (IconBase)      CloseLibrary (IconBase);
	if (UtilityBase)   CloseLibrary (UtilityBase);
	if (IntuitionBase) CloseLibrary (IntuitionBase);
	}

/*----------------------------------------------------------------------------*/
/* Open required libraries and initialise the class                           */
/*----------------------------------------------------------------------------*/

	Class *GadgetInitClass (void)

	{
	Class *cl = NULL;

	IntuitionBase = OpenLibrary ("intuition.library",36);
	UtilityBase   = OpenLibrary ("utility.library",36);
	IconBase      = OpenLibrary ("icon.library",0);
	DOSBase       = OpenLibrary ("dos.library",0);

	if (IntuitionBase && UtilityBase && IconBase && DOSBase)
		{
		if (cl = MakeClass (NULL,"frbuttonclass",NULL,sizeof(struct example_data),0))
			{
		#ifdef __PPC__
			cl->cl_Dispatcher.h_Entry = (HOOKFUNC)example_dispatcher;
		#else
			cl->cl_Dispatcher.h_Entry    = (HOOKFUNC)HookEntry;
			cl->cl_Dispatcher.h_SubEntry = (HOOKFUNC)example_dispatcher;
		#endif
			}
		}

	kprintf ("\n------------------------------------\n"
			"%sGadgetInitClass: cl = %lx\n",GadgetIdString,cl);


	if (!cl)
		GadgetFreeClass (NULL);	// close libs

	return (cl);
	}

/*----------------------------------------------------------------------------*/
/* End of source code                                                         */
/*----------------------------------------------------------------------------*/
