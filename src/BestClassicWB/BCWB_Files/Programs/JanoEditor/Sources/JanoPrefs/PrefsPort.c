/*
 * PrefsPort.c: Communication port with JanoEditor
 * Free software under GNU license
 * Written by T.Pierron & C.Guilaume. november 11, 2000
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <libraries/dos.h>
#include "Gui.h"
#include "Prefs.h"
#include "IPC_Prefs.h"
#include "Utils.h"
#include "ProtoTypes.h"

/* Port of Pref and Jano */
static struct MsgPort *port, *reply;
static struct JPacket *cmd;

STRPTR PortName = JANOPREFS_PORT;

/* Look if prefs isn't alredy running */
char find_prefs( void )
{
	ULONG sigwait;
	if( (reply = (struct MsgPort *) FindPort(PortName)) )
	{
		PortName = NULL; /* Private port */
		if( (sigwait = create_port()) )
		{
			/* Send to the running preference tool that someone tries to launch it again */
			cmd->class = CMD_SHOW;
			PutMsg( reply, &cmd->Msg );
			/* cmd packet is associated with "port", thus reply will be done here */
			Wait( sigwait );
			/* Unqueue message (don't reply!) */
			GetMsg( port );
		}
		/* Cleanup will be done later */
		return 1;
	}
	else return 0;
}

/* Setup public port of the preference editor */
ULONG create_port( void )
{
	/* Create a port and  */
	if( (port = (struct MsgPort *) CreateMsgPort()) )
	{
		/* Create a message that can be sent to the editor */
		if( (cmd = (APTR) CreateIORequest(port, sizeof(*cmd))) )
		{
			port->mp_Node.ln_Pri = 0;
			if( (port->mp_Node.ln_Name = PortName) )
				AddPort( port );

			return 1UL << port->mp_SigBit;
		}
		DeleteMsgPort(port);
	}
	return 0;
}

/* Search for a running session of editor */
char find_jano( Prefs prefs )
{
	extern struct Screen *Scr;
	if( (reply = (struct MsgPort *) FindPort(JANO_PORT)) )
	{
		/* Get a copy of the preferences that uses the editor */
		cmd->class = CMD_PREF;
		PutMsg( reply, &cmd->Msg );
		Wait( (1 << port->mp_SigBit) | SIGBREAKF_CTRL_C );
		GetMsg( port );
		/* Copy to our local buffer */
		CopyMem(&cmd->prefs, prefs, sizeof(*prefs));
		Scr = prefs->current;
		return 1;
	}
	return 0;
}

/* Send a preference struct to Jano's public port */
char send_jano( Prefs prefs, ULONG class )
{
	/* The port can be shutted down!! */
	if( (reply = (struct MsgPort *) FindPort(JANO_PORT)) )
	{
		cmd->class = class;
		CopyMem(prefs, &cmd->prefs, sizeof(*prefs));

		PutMsg( reply, &cmd->Msg );
		Wait( (1 << port->mp_SigBit) | SIGBREAKF_CTRL_C );
		GetMsg( port );
		return 1;
	}
	return 0;
}

/* Shutdown port */
void close_port( void )
{
	if( cmd ) DeleteIORequest( cmd );
	if( port )
	{
		/* Be sure there are no message left */
		APTR msg;
		while( (msg = (APTR) GetMsg(port)) ) ReplyMsg(msg);
		if( PortName ) RemPort( port );
		DeleteMsgPort( port );
	}
}

/* Handle messages posted to the public port */
void handle_port( void )
{
	struct JPacket *msg;
	extern UBYTE    ConfigFile;
	while( (msg = (struct JPacket *) GetMsg(port)) )
	{
		switch( msg->class )
		{
			case CMD_SHOW: setup_guipref(); break;
			case CMD_KILL:
				/* Close preference tool only if it's associated to jano */
				if( !ConfigFile ) close_prefwnd(0); break;
		}
		ReplyMsg( &msg->Msg );
	}
}

