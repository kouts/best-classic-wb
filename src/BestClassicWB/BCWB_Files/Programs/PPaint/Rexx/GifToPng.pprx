/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: GifToPng.pprx 1.1 */

/** ENG
  This script asks the user to specify a directory, scans the directory
  and its subdirectories and converts all GIF files it finds into PNG.

  Non-GIF files are not affected. Icon images are preserved. Icon format
  information is updated (Tool Types: FILETYPE=PNG). GIF Author, Copyright
  and Comment fields are translated to PNG equivalents. File name suffixes
  are changed (i.e. the files are renamed) as follows:

    .gif   -> .png
    .GIF   -> .PNG
    .Gif   -> .Png, etc.

    others -> unchanged

  Personal Paint identifies the file type by its contents (not by the file
  name suffix). If the script runs during Workbench use, the Workbench Update
  menu item must be selected to visually update the contents of any windows
  containing files being renamed by this script.

  This script requires Personal Paint version 7.0 (PPaint Rexx version 7)
  or higher, personal_png_io.library (enclosed with PPaint), and
  personal_gif_io.library (or another GIF-compatible library).


  Possible changes that could be applied to this file:

    Convert all images to PNG (not just GIFs). To do this, change the line
    selecting GIFs to IF UPPER(RESULT) ~= 'PNG' THEN DO. However, be careful
    if you have IFF animations, as they can be loaded as ILBM images unless
    they are filtered out (IFF animations begin with an ILBM image).

    Activate PNG Adam 7 progressive display in files being written. This
    degrades compression but the resulting images appear more nicely when
    displayed by progressive viewers. Set PROGDSP=1.

    Convert any file to uncompressed IFF-ILBM. This may be good for files to
    be stored on an Amiga CD-ROM, where loading speed could be more important
    than compression. Remove the instructions selecting only GIFs and replace
    the PNG FORMAT option with FORMAT ILBM OPTIONS "COMPR=0" "SCRFMT=0".


  PNG was designed as a replacement and extension to GIF and LZW-based TIFF,
  after Unisys Corporation began demanding royalties on GIF/LZW code. As
  the PNG specification was released in May 1995, it gained general
  recognition as the best lossless standard for storing digital images.

  Cloanto, the first software house to publish a paint program supporting the
  PNG file format, is also making available a PNG developer's kit for the
  Amiga (on the Personal Suite CD-ROM). A PNG DataType is available at no
  cost for free electronic distribution.
*/

/** DEU
  Die GIF-Bilder im angegebenen Verzeichnis (und in dessen
  Unterverzeichnissen) lassen sich mit Hilfe dieses Skripts automatisch in
  PNG-Bilder umwandeln.

  Nicht im GIF-Format vorliegende Bilder werden nicht berücksichtigt;
  Icon-Dateien bleiben grundsätzlich unverändert, allerdings werden die
  Formatinformationen der Formatänderung angepaßt (Merkmale: FILETYPE=PNG).
  Außerdem die durch das GIF-Format unterstützten Felder für Autor,
  Copyright und Kommentar ihren PNG-Äquivalenten angepaßt. Evtl. vorhandene
  Dateinamenerweiterungen werden durch Umbenennung wie folgt geändert:

    .gif   -> .png
    .GIF   -> .PNG
    .Gif   -> .Png, usw.

    andere -> unverändert

  Personal Paint identifiziert das Dateiformat anhand des Dateiinhalts,
  und nicht etwa anhand der Dateinamenerweiterung. Wenn dieses Skript
  während der Benutzung der Workbench ausgeführt wird, muß zunächst
  der Menübefehl "alles aktualisieren" im Menü "Workbench" ausgeführt werden,
  um den Inhalt von Fenstern zu aktualisieren, die von diesem Skript
  modifizierte Dateien enthalten.

  Dieses Skript erfordert Personal Paint 7.0 (PPaint Rexx Version 7)
  oder höher, die personal_png_io.library (im Lieferumfang von PPaint
  enthalten) und die personal_gif_io.library (oder eine andere
  GIF-kompatible Library).

  Denkbare Änderungen an dieser Skriptdatei:

    Konvertierung sämtlicher Bilder (nicht nur GIF) in das PNG-Format.
    Dazu ist die Zeile zur Auswahl der GIF-Bilder in
    IF UPPER(RESULT) ~='PNG' THEN DO zu ändern. Hierbei ist im Hinblick
    auf das Vorhandensein von Animationen im IFF-Format Vorsicht
    walten zu lassen, da auch diese sich als ILBM-Bilder laden lassen
    (IFF-Animationen beginnen mit einem ILBM-Bild).

    Aktivierung der "PNG Adam 7 progressive Display"-Option beim Speichern
    der Dateien. Dies führt zwar zu einer verringerten Komprimierungsrate,
    bewirkt aber bei der Anzeige mit einem geeigneten Programme eine
    eine optimierte Darstellung. Set PROGDSP=1.

    Konvertierung einer beliebigen Grafikdatei in das umkomprimierte
    IFF-ILBM-Format. Dies kann besonders für Dateien sinnvoll sein, die auf
    einer speziell für den Amiga entwickelten CD-ROM gespeichert werden
    sollen, und wenn die Ladegeschwindigkeit eine höhere Priorität genießt
    als die Komprimierungsrate. Entfernen Sie einfach die Befehle, die
    die Auswahl lediglich auf GIF-Bilder beschränken, und ersetzen Sie die
    Option PNG FORMAT durch FORMAT ILBM OPTIONS "COMPR=0" "SCRFMT=0".

  Das PNG-Format wurde als Ersatz und Erweiterung zu GIF und dem
  LZW-basierten TIFF-Format entwickelt, nachdem deren Eigentümer, die
  Firma Unisys, für die Verwendung des GIF-/LZW-Codes Gebühren forderte.
  Kurz nach der Veröffentlichung der PNG-Spezifikation im Mai 1995
  genoß das Format bereits allgemeine Anerkennung als bester verlustfreier
  Standard zur digitalen Bildspeicherung.

  Cloanto, die Entwickler des ersten Malprogramms mit PNG-Unterstützung,
  sind auch die Herausgeber des PNG-Entwicklerpakets für den Amiga
  (erhältlich auf der Personal Suite CD-ROM). Zusätzlich ist gratis ein
  PNG-DataType erhältlich, der auf elektronischem Wege frei verteilt werden
  darf.
*/

/** ITA
  Questo script chiede all'utente di indicare un cassetto, che viene
  poi esaminato insieme agli altri cassetti in esso contenuti per convertire
  tutti i file GIF trovati in file PNG.

  File non-GIF non sono modificati. Le immagini delle icone sono conservate.
  Le informazioni dell'icona relative al formato sono aggiornate (Parametri:
  FILETYPE=PNG). I campi Autore, Copyright e Commenti di GIF sono tradotti
  negli equivalenti di PNG. Sono modificati i suffissi del nome file (i file
  sono rinominati) come segue:

    .gif   -> .png
    .GIF   -> .PNG
    .Gif   -> .Png, ecc.

    altri -> invariati

  Personal Paint identifica il tipo del file dal suo contenuto (non dal
  suffisso del nome file). Se si avvia lo script durante l'uso del Workbench,
  si deve selezionare la voce di menu Workbench/Aggiornare tutto per poter
  aggiornare la visualizzazione del contenuto di ogni finestra contenente file
  rinominati da questo script.

  Questo script richiede Personal Paint versione 7.0 (PPaint Rexx versione 7)
  o successivo, personal_png_io.library (acclusa a PPaint), e
  personal_gif_io.library (o altra libreria GIF-compatibile).

  Possibili modifiche apportabili a questo file:

    Convertire tutte le immagini in PNG (not solo quelle GIF). Per fare ciò,
    basta cambiare le linea per la selezione delle immagini GIF in
    IF UPPER(RESULT) ~= 'PNG' THEN DO. Bisogna però fare attenzione se si
    hanno animazioni IFF, poiché possono essere caricate come immagini ILBM
    a meno che non si usi un filtro di esclusione (le animazioni IFF iniziano
    con una immagine ILBM).

    Attivare la visualizzazione progressiva PNG Adam 7 nei file che sono
    via via salvati. Ciò peggiora i risultati della compressione ma le
    immagini così ottenute appaiono molto più elegantemente quando sono
    mostrate da visualizzatori progressivi. Impostare PROGDSP=1.

    Convertire ogni file in IFF-ILBM non compresso. Ciò può essere utile per
    file da immagazzinare su un CD-ROM per Amiga, dove la velocità di
    caricamento potrebbe essere più importante della compressione. Rimuovere
    le sitruzioni che selezionano solo immagini GIF e sostituire l'opzione
    PNG FORMAT con FORMAT ILBM OPTIONS "COMPR=0" "SCRFMT=0".

  PNG è stato progettato come sostituto ed estensione per GIF e TIFF LZW-based,
  dopo che Unisys Corporation iniziò a chiedere royalties sul codice GIF/LZW.
  Da quando le specifiche PNG furono rilasciate nel Maggio 1995, il formato
  ottenne riconoscimenti diffusi come il miglior standard di immagazzinamento
  per immagini digitali senza perdita di informazioni.

  Cloanto, la prima software house a pubblicare un programma di disegno che
  consente l'uso del formato PNG, rende disponibile un kit PNG per
  sviluppatori (sul CD-ROM Personal Suite). Un DataType PNG è
  disponibile senza alcun costo via Internet.
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
	txt_req_sel       = 'GifToPng-Zielverzeichnis'
	txt_err_svabort   = 'Speichervorgang wurde abgebrochen'
	txt_err_ldabort   = 'Ladevorgang wurde abgebrochen'
	txt_err_save      = 'Fehler beim Speichern: '
	txt_err_load      = 'Fehler beim Laden: '
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_req_sel       = 'Selezionare cassetto'
	txt_err_svabort   = 'Scrittura annullata'
	txt_err_ldabort   = 'Lettura annullata'
	txt_err_save      = 'Errore nella scrittura: '
	txt_err_load      = 'Errore nella lettura: '
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_req_sel       = 'GifToPng target directory'
	txt_err_svabort   = 'User abort during save'
	txt_err_ldabort   = 'User abort during load'
	txt_err_save      = 'Error during save: '
	txt_err_load      = 'Error during load: '
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
FreeBrush
IF RC = 0 THEN
	RequestPath '"'txt_req_sel'"'
IF RC = 0 THEN DO
	tmpfname = 'T:pprx_temp.'PRAGMA('ID')
	ADDRESS COMMAND 'List >'tmpfname' 'RESULT' NOHEAD PAT=~(#?.info) LFORMAT="*"%s%s*"" ALL FILES'
	IF OPEN('listfile', tmpfname, 'R') THEN DO
		Get 'ICONS'
		iconmode = RESULT
		errcode = 0
		Set '"ICONS=3"'
		DO FOREVER
			curfname = READLN('listfile')
			IF EOF('listfile') THEN BREAK
			GetFileFormat curfname
			IF RC = 0 THEN DO
				IF UPPER(RESULT) = 'GIF' THEN DO
					LoadBrush curfname 'FORCE'
					IF RC = 0 THEN DO
						IF UPPER(RIGHT(curfname, 5)) = '.GIF"' THEN DO
							len = LENGTH(curfname)
							newfname = OVERLAY(D2C(C2D(SUBSTR(curfname, len-3, 1)) + 9), curfname, len-3)
							newfname = OVERLAY(D2C(C2D(SUBSTR(curfname, len-2, 1)) + 5), newfname, len-2)
							newfname = OVERLAY(D2C(C2D(SUBSTR(curfname, len-1, 1)) + 1), newfname, len-1)
							IF EXISTS(SUBSTR(newfname,2,len-2)) = 0 THEN DO
								ADDRESS COMMAND 'Rename >NIL: 'curfname' 'newfname
								curiconfname = INSERT('.info', curfname, len-1)
								newiconfname = INSERT('.info', newfname, len-1)
								curfname = newfname
								IF EXISTS(SUBSTR(curiconfname,2,len+3)) THEN DO
									IF EXISTS(SUBSTR(newiconfname,2,len+3)) THEN
										ADDRESS COMMAND 'Delete >NIL: 'curiconfname
									ELSE
										ADDRESS COMMAND 'Rename >NIL: 'curiconfname' 'newiconfname
								END
							END
						END
						SaveBrush 'FORCE FILE 'curfname' FORMAT PNG OPTIONS "PROGDSP=0" "COMPR=6" "AUTO=1"'
						IF RC > 0 THEN DO
							errcode = RC
							IF RC = 5 THEN
								errmess = txt_err_svabort
							ELSE
								errmess = txt_err_save || RC
						END
						FreeBrush 'FORCE'
					END
					ELSE DO
						errcode = RC
						IF RC = 5 THEN
							errmess = txt_err_ldabort
						ELSE
							errmess = txt_err_load || RC
					END
				END
			END
			IF errcode > 0 THEN
				BREAK
		END
		IF errcode > 0 THEN
			RequestNotify 'PROMPT "'errmess'"'

		Set '"ICONS='iconmode'"'
		CALL CLOSE('listfile')
	END
	ADDRESS COMMAND 'Delete >NIL: 'tmpfname
END
UnlockGUI
