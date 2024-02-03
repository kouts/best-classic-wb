/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: Help.pprx 1.1 */

/** ENG
 This script displays a list of all Rexx commands and options.

 The script can be executed with an argument, which is passed on to the
 "Help" command, and which causes instructions to be displayed either for
 the internal commands and options, or for the I/O modules, or for both.

 Additional information and support is available via E-mail from Cloanto.
 E-mail: <support@cloanto.com>.
*/

/** DEU
 Dieses Skript zeigt eine Liste aller Rexx-Befehle und -Optionen.

 Es läßt sich mit einem optionalen Argument ausführen, welches an
 den Befehl "Help" übergeben wird und dazu führt, daß entweder
 Hinweise zu den internen Befehlen und Optionen, zu den E/A-Modulen,
 oder zu beiden Themenbereichen ausgegeben werden.

 Zusätzliche Informationen und Hilfestellungen erhalten Sie via
 E-Mail direkt von Cloanto unter <support@cloanto.com>.
*/

/** ITA
 Questo script mostra un elenco di tutti i comandi Rexx e delle loro opzioni.

 Si può eseguire lo script specificando un argomento, che è passato al comando
 "Help", e che porta alla visualizzazione delle istruzioni o per i comandi
 interni e loro opzioni, o per i moduli di I/O, o per entrambi.

 Informazioni aggiuntive e assistenza tecnica sono disponibili via posta
 elettronica dalla Cloanto. E-mail: <support@cloanto.com>.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT topic output '"' title '"'
ELSE
	PPPORT = 'PPAINT'


IF ~SHOW('P', PPPORT) THEN DO
	IF EXISTS('PPaint:PPaint') THEN DO
		ADDRESS COMMAND 'Run >NIL: PPaint:PPaint'
		DO 30 WHILE ~SHOW('P',PPPORT)
			 ADDRESS COMMAND 'Wait >NIL: 1 SEC'
		END
	END
	ELSE DO
		SAY "Personal Paint could not be loaded."
		EXIT 10
	END
END

IF ~SHOW('P', PPPORT) THEN DO
	SAY 'Personal Paint Rexx port could not be opened'
	EXIT 10
END

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_port_name     = 'Rexx-Port: '
	txt_rexx_ver      = 'Rexx-Version: '
	txt_rexx_version  = '-- PPaint Rexx Version '
	txt_io_modules    = '-- Verfügbare I/O Module --'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_port_name     = 'Nome porta Rexx: '
	txt_rexx_ver      = 'Versione Rexx: '
	txt_rexx_version  = '-- Versione Rexx PPaint '
	txt_io_modules    = '-- Moduli I/O disponibili --'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_port_name     = 'Port Name: '
	txt_rexx_ver      = 'Rexx Version: '
	txt_rexx_version  = '-- PPaint Rexx Version '
	txt_io_modules    = '-- Available I/O Modules --'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 3 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

IF output = 'GUI' THEN DO
	Help topic
	helptext = RESULT
	IF topic = 'Command' THEN DO
		Version 'REXX'
		helptext = txt_port_name || PPPORT '0a'X || txt_rexx_ver || RESULT '0a0a'X || helptext
	END

	pos = 1
	DO FOREVER
		pos = INDEX(helptext, '"', pos)
		IF pos = 0 THEN
			BREAK
		helptext = INSERT('"', helptext, pos)
		pos = pos + 2
	END

	RequestNotify '"'title'" "'helptext'" SCROLL'
END
ELSE DO
	SAY txt_rexx_version || RESULT '--' '0a'X

	Help
	SAY RESULT

	SAY '0a0a'X || txt_io_modules '0a'X

	Help 'IOFORMAT'
	SAY RESULT
END
