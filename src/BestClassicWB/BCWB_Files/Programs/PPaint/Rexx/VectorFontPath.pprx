/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: VectorFontPath.pprx 1.0 */

/** ENG
 This script selects the directory path used by macros working with
 vector fonts, such as "Vector Text" and "Text Whirlpool".

 The selected path must contain vector font description files with names
 ending with ".otag".

 By default, the Amiga uses vector fonts in the Compugraphic file format.
 Non-Amiga Compugraphic fonts can be installed using the Intellifont
 tool which is part of the operating system. Other types of fonts, such
 as Adobe Type 1 fonts, can also be used, if the appropriate libraries
 have been installed. Digita's Wordworth package, for example, includes
 such fonts and libraries. The path for Wordworth fonts, which can be
 selected with this script, is "Wordworth:WwFonts/UFST".
*/

/** DEU
 Dieses Skript dient zur Auswahl des Verzeichnispfads für Makros,
 zu deren Ausführung Vektorschriften erforderlich sind, z.B.
 "VektorText" und "Text Whirlpool".

 Unter dem ausgewählten Pfad müssen Dateien gespeichert sein, deren
 Namen die Endung ".otag" aufweist.

 Der Amiga verwendet standardmäßig Vektorschriften im sog. "Compugraphic"-Format.
 Nicht im Amiga-Format vorliegende Compugraphic-Fonts lassen sich mit Hilfe
 des Hilfsprogramms Intellifont installieren, welches Bestandteil der
 Amiga-Systemsoftware ist. Vorausgesetzt, daß die entsprechenden Libraries
 vorhanden sind, lassen sich auch andere Fontformate (z.B. Adobe Typ 1)
 einsetzen. Diese Libraries (und dazugehörige Fonts) befinden sich z.B. im
 Lieferumfang der Textverarbeitung Wordworth von Digita. Der mit diesem
 Skript einzustellende Pfad zu den Wordworth-Fonts würde z.B. folgendermaßen
 aussehen: "Wordworth:WwFonts/UFST".
*/

/** ITA
 Questo script consente di selezionare il percorso per i font usato dalle
 macro che operano su font vettoriali, come "Vector Text" e "Text Whirlpool".

 Il percorso selezionato deve contenere file di descrizione font vettoriali,
 riconoscibili dal suffisso ".otag".

 Per impostazione predefinita, Amiga usa font vettoriali in formato
 Compugraphic. Si possono installare font Compugraphic non Amiga utilizzando
 lo strumento Intellifont che è parte del sistema operativo. Altri tipi di
 font, come quelli Adobe Type 1, possono essere utilizzati, se sono state
 installate le opportune librerie. Il pacchetto Wordworth della Digita, per
 esempio, include tali font e librerie. Il percorso per i font di Wordworth,
 che si può selezionare con questo script, è "Wordworth:WwFonts/UFST".
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT
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
	req_title         = 'Pfad für Vektorfonts auswählen'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	req_title         = 'Percorso font vettoriali'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	req_title         = 'Select the vector font path'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

set_fname  = 'ENV:PP_VectorPath'
list_fname = 'ENV:PP_VectorFonts'


LockGUI
IF OPEN('settingfile', set_fname, 'R') THEN DO
	spath = READCH('settingfile', 65535)
	CALL CLOSE('settingfile')
END
ELSE spath = 'FONTS:'

RequestPath '"'req_title'" "'spath'"'
IF RC = 0 THEN DO
	PARSE VALUE RESULT WITH '"' path '"'
	IF OPEN('settingfile', set_fname, 'W') THEN DO
		WRITECH('settingfile', path)
		CALL CLOSE('settingfile')

		IF spath ~= path THEN
			ADDRESS COMMAND 'Delete >NIL: "'list_fname'"'
	END
END
UnlockGUI
