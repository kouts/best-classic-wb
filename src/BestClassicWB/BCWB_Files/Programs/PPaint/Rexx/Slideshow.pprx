/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: Slideshow.pprx 1.0 */

/** ENG
  This is a simple slideshow script. It normally displays all images
  and animations which it finds in the specified directory (and
  subdirectories).

  When the script is launched, it first searches for a file named
  "T:pprx_slideshow.list". If this file exists, the script displays the
  artwork files listed in the file. The file must contain two lines for
  each image or animation: the first line containing the path, and the
  second line indicating how often the item should be repeated (useful for
  animations).

  To have a slideshow loop automatically and unattended, both the Repeat and
  the Automatic options in the initial requester should be selected.
*/

/** DEU
  Ein einfaches Skript zur Erzeugung einer Diaschau, welches
  im Normalfall alle Bilder und Animationen im angegebenen Verzeichnis
  (und in dessen Unterverzeichnissen) anzeigt.

  Sobald das Skript ausgeführt wird, sucht es zunächst eine Datei
  namens "T:pprx_slideshow.list" und zeigt die darin enthaltenen
  Bilder und Animationen an. Die Datei muß für jedes Bild (oder
  jede Animation) jeweils zwei Zeilen enthalten: Die erste Zeile
  enthält den Pfad, die zweite die gewünschte Anzahl von Wiederholungen
  (besonders geeignet bei Animationen).

  Um eine automatisch endlos ablaufende Diaschau zu erzeugen,
  müssen im ersten Dialogfenster die Optionen "Wiederholen" und
  "Automatisch" aktiviert sein.
*/

/** ITA
  Questo è uno script per creare una semplice proiezione di immagini e
  animazioni. In genere mostra tutte le immagini e le animazioni che trova
  nel cassetto specificato (e negli eventuali cassetti in esso contunuti).

  Quando si avvia lo script, esso ricerca per prima cosa un file chiamato
  "T:pprx_slideshow.list". Se tale file esiste, lo script mostra i file grafici
  là elencati. Il file deve contenere due righe per ciascuna immagine o
  animazione: la prima contiene il percorso completo di nome di file, la
  seconda indica quante volte ripetere la voce (utile per le animazioni).

  Per ottenere una proiezione che riparta automaticamente
  si dovrebbero selezionare entrambe le opzioni Ripetuto e
  Automatico nella finestra di dialogo iniziale.
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
	txt_title_filreq  = 'Grafikverzeichnis auswählen'
	txt_title_options = 'Diaschau-Optionen'
	txt_gad_repeat    = 'Wiede_rholen:'
	txt_gad_auto      = 'Auto_matisch:'
	txt_msg_stopped   = 'Diaschau wurde unterbrochen'
	txt_msg_complete  = 'Diaschau beendet'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	txt_err_nolist    = 'Listendatei konnte nicht_geöffnet werden'
END
ELSE IF RESULT = 3 THEN DO	/* Français */
	txt_title_filreq  = 'Choisir le répertoire des graphismes'
	txt_title_options = 'Options de diaporama'
	txt_gad_repeat    = '_Répéter :'
	txt_gad_auto      = 'Auto_matique :'
	txt_msg_stopped   = 'Le diaporama a été interrompu'
	txt_msg_complete  = 'Diaporama terminé'
	txt_err_oldclient = 'Ce script nécessite une nouvelle_version de Personal Paint'
	txt_err_nolist    = "Impossible d'ouvrir le fichier de liste."
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_filreq  = 'Selezionare cassetto immagini'
	txt_title_options = 'Opzioni slideshow'
	txt_gad_repeat    = '_Ripetuto:'
	txt_gad_auto      = 'Auto_matico:'
	txt_msg_stopped   = 'Lo slideshow è stato interrotto'
	txt_msg_complete  = 'Slideshow terminato'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	txt_err_nolist    = 'Il file indice non può essere aperto'
END
ELSE DO				/* English */
	txt_title_filreq  = 'Select artwork directory'
	txt_title_options = 'Slideshow Options'
	txt_gad_repeat    = '_Repeat:'
	txt_gad_auto      = 'Auto_matic:'
	txt_msg_stopped   = 'The slideshow has been stopped'
	txt_msg_complete  = 'Slideshow complete'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	txt_err_nolist    = 'List file could not be opened'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

DeleteFrames 'ALL'
IF RC = 5 THEN
	EXIT 0

FreeEnvironment 'QUERY'
IF RC = 5 THEN
	EXIT 0

tmpfname = 'T:pprx_slideshow.list'

LockGUI

IF ~EXISTS(tmpfname) THEN DO
	RequestPath '"'txt_title_filreq'"'
	IF RC = 0 THEN DO
		tmpfname = 'T:pprx_temp.'PRAGMA('ID')
		ADDRESS COMMAND 'List >'tmpfname' 'RESULT' NOHEAD PAT=~(#?.info) LFORMAT="*"%s%s*"*N1" ALL FILES'
	END
END

originalbars = ''
listopen = 0
SIGNAL ON Break_C

IF EXISTS(tmpfname) THEN DO
	Request '"'txt_title_options'" "CHECK = ""'txt_gad_repeat'"", 0  CHECK = ""'txt_gad_auto'"", 1 "'
	IF RC = 0 THEN DO
		repeat = RESULT.1
		automatic = RESULT.2
		IF automatic THEN
			noprog = ''
		ELSE
			noprog = 'NOPROGRESS'

		Get 'BARS'
		originalbars = RESULT
		IF OPEN('listfile', tmpfname, 'R') THEN DO
			listopen = 1
			errcode = 0
			Set '"BARS=0"'
			DO FOREVER
				prevpos = SEEK('listfile', 0, CURRENT)
				curfname = READLN('listfile')
				IF EOF('listfile') THEN DO
					IF repeat THEN DO
						SEEK('listfile', 0, BEGIN)
						ITERATE
					END
					ELSE LEAVE
				END
				curtimes = READLN('listfile')
				IF EOF('listfile') THEN DO
					IF repeat THEN DO
						SEEK('listfile', 0, BEGIN)
						ITERATE
					END
					ELSE LEAVE
				END

				IF DATATYPE(curtimes) ~= 'NUM' THEN curtimes = 1
				curtimes = ABS(curtimes)
				curtimes = TRUNC(curtimes)
				IF curtimes < 1 THEN curtimes = 1

				GetFileFormat curfname
				IF RC = 0 THEN DO
					IF UPPER(RESULT) = 'ANIM' THEN
						PlayFile curfname 'TIMES' curtimes 'FORCE QUIET' noprog
					ELSE DO
						LoadImage curfname 'FORCE QUIET' noprog
						IF RC = 0 & automatic THEN
							ADDRESS COMMAND 'Wait >NIL: 3 SEC'
					END
					IF RC = 5 THEN
						errcode = 5
					IF RC = 0 & ~automatic THEN DO
						WaitForClick
						IF RC ~= 0 THEN
							errcode = 5
					END
				END
				IF errcode > 0 THEN BREAK
			END
			CALL CLOSE('listfile')
			listopen = 0
			IF errcode > 0 THEN
				RequestNotify 'PROMPT "'txt_msg_stopped'"'
			ELSE
				RequestNotify 'PROMPT "'txt_msg_complete'"'
		END
		ELSE
			RequestNotify 'PROMPT "'txt_err_nolist'"'

		Set '"BARS='originalbars'"'
	END
	ADDRESS COMMAND 'Delete >NIL: 'tmpfname
END
UnlockGUI
EXIT 0



Break_C:

	if originalbars ~= '' THEN
		Set '"BARS='originalbars'"'
	IF listopen THEN
		CALL CLOSE('listfile')
	ADDRESS COMMAND 'Delete >NIL: 'tmpfname

	RETURN
