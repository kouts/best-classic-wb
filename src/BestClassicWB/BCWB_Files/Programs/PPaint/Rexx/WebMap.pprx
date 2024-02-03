/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: WebMap.pprx 1.1 */

/** ENG
 This script loads, saves and edits Internet server-side web maps in the
 "NCSA httpd" format. These maps are used to associate different types
 of actions to the selection of different areas of an image.

 The following commands are available:

 - Load: a web map file can be selected using the file requester;
   the file objects are appended to the current map objects (if any).

 - Add Rectangle: the mouse can be used to define a rectangular object
   in the image. An object data requester is opened when the mouse button
   is released.

 - Add Circle: the mouse can be used to define a circular object
   in the image. An object data requester is opened when the mouse button
   is released.

 - Add Polygon: the mouse can be used to define a polygon object
   in the image; the polygon can be closed by connecting the line
   to the starting point, or with a click of the right mouse button. An
   object data requester is opened when the mouse button is released
   (polygon points can be freely added or removed in the Parameters field).

 - Add Freehand Area: the mouse can be used to define a freehand-polygon
   object in the image, the polygon is automatically closed when the mouse
   button is released. An object data requester is opened when the mouse
   button is released.

 - Add Point: the mouse can be used to place a point object in the image.
   An object data requester is opened when the mouse button is released.

 - Edit: the edit requester contains a list of the map objects; the
   "View by" gadget can be used to list the items by object data, URL
   or comment. A click on the Show gadget causes the selected object
   to be highlighted in the image. The Edit gadget opens a new requester
   with the selected object data: the Parameters, URL and (optional) Comment
   fields can be edited (this requester is very similar to the one
   which appears after an object definition), and the Delete gadget
   can be used to remove the object from the map.

 - Save: this command writes a map file using the current object data.

 - Export: this command writes an HTML file (client-side map) using the
   current object data. The file contains a sample inline image definition
   which uses the map. The map definition can however be used by other
   images with the USEMAP attribute. Point objects are not yet supported
   by the HTML specification and therefore cannot be exported.

 - Clear: all map objects can be deleted with this command (for example,
   before loading a new map).
*/

/** DEU
 Dieses Skript dient zum Laden, Speichern und Bearbeiten von Internet
 Web-Maps auf der Serverseite im "NCSA httpd"-Format. Solche Maps ermöglichen
 es, bei der Auswahl bestimmter Bildbereiche unterschiedliche Aktionen
 auszulösen.

 Die folgenden Befehle stehen zur Verfügung:

 - Laden: Mit Hilfe des Dateiauswahlfensters läßt sich die gewünschte Web
   Map-Datei laden. Dabei werden die Dateiobjekte an die aktuellen Map-Objekte
   (falls vorhanden) angehängt.

 - Neues Rechteck: Dient zum Auswählen eines rechteckigen Bereichs mit der
   Maus. Sobald die Maustaste losgelassen wird, öffnet sich ein Dialogfenster
   zur Festlegung der Objektdaten.

 - Neuer Kreis: Dient zum Auswählen eines kreisförmigen Bereichs mit der
   Maus. Sobald die Maustaste losgelassen wird, öffnet sich ein Dialogfenster
   zur Festlegung der Objektdaten.

 - Neues Polygon: Dient zum Erstellen eines Polygonobjekts, welches sich
   entweder durch Verbinden des Linienendes mit dem Anfangspunkt oder durch
   einen Druck auf die rechte Maustaste wieder schließen läßt. Sobald die
   Maustaste losgelassen wird, öffnet sich ein Dialogfenster zur Eingabe der
   Objektdaten.

 - Neues freies Polygon: Dient zum Zeichnen eines freihändig gezeichneten
   Polygonobjekts, welches beim Loslassen der linken Maustaste automatisch
   geschlossen wird. Sobald die Maustaste losgelassen wird, öffnet sich ein
   Dialogfenster zur Eingabe der Objektdaten.

 - Neuer Punkt: Dient zum Plazieren eines Punktobjekts auf der Bildfläche.
   Sobald die Maustaste losgelassen wird, öffnet sich ein Dialogfenster zur
   Eingabe der Objektdaten.

 - Bearbeiten: Das Edit-Dialogfenster enthält eine Liste der vorhandenen
   Map-Objekte. Unter Verwendung des "Anzeigen als"-Symbols lassen sich die
   einzelnen Elemente wahlweise nach Objektdaten, URL oder Kommentar auflisten.
   Durch Anklicken von "Anzeigen" wird das ausgewählte Objekt auf der
   Bildfläche hervorgehoben dargestellt. Das "Bearbeiten"-Symbol dient zum
   Öffnen eines neuen Dialogfensters mit den ausgewählten Objektdaten: Hier
   läßt sich der Feldinhalt für Parameter, URL und einen optionalen Kommentar
   bearbeiten. Mit Hilfe von "Löschen" kann das Objekt aus der aktuellen Map
   entfernt werden. Dieses Dialogfensters ähnelt bezüglich seiner
   Funktionalität sehr stark demjenigen, welches nach einer Objektdefinition
   geöffnet wird.

 - Speichern: Dient zum Speichern einer Map-Datei unter Verwendung der
   aktuellen Objektdaten.

 - Export: Dieser Befehl schreibt eine HTML-"Client-side Map" unter
   Verwendung der Daten des aktuellen Objekts. Die in eine solche Datei
   eingebettete Bildbeschreibung verwendet diese Map. Selbstverständlich läßt
   sich die Map-Beschreibung aber mit Hilfe des Attributs USEMAP auch mit
   anderen Bildern verwenden. Hinweis: Der Export von Punktobjekten ist nicht
   möglich, da diese noch nicht Bestandteil der HTML-Spezfikation sind.

 - Löschen: Bewirkt das Löschen aller Map-Objekte (z. B. vor dem Laden einer
   neuen Map).
*/

/** ITA
 Questo script permette di leggere, scrivere e modificare mappe di
 collegamento Web sul lato server nel formato "NCSA httpd". Tali mappe
 sono usate per associare vari tipi di azione alla selezione di aree
 differenti dell'immagine.

 Sono disponibili i seguenti comandi:

 - Leggere: si può selezionare una mappa web tramite la finestra di scelta file;
   gli oggetti del file sono accodati agli oggetti correnti della mappa (se
   presenti).

 - Aggiungere rettangolo: si può usare il mouse per definire un oggetto
   rettangolare nell'immagine. Quando si rilascia il tasto del mouse si apre
   la finestra di dialogo relativa ai dati dell'oggetto.

 - Aggiungere cerchio: si può usare il mouse per definire un oggetto
   circolare nell'immagine. Quando si rilascia il tasto del mouse si apre
   la finestra di dialogo relativa ai dati dell'oggetto.

 - Aggiungere poligono: si può usare il mouse per definire un oggetto
   poligonale nell'immagine; il poligono può essere chiuso congiungendo la
   linea col punto iniziale o facendo click col tasto destro del mouse. Quando
   si rilascia il tasto del mouse si apre la finestra di dialogo relativa ai
   dati dell'oggetto (si possono liberamente aggiungere o togliere punti dal
   poligono tramite il campo Parametri).

 - Aggiungere area: si può usare il mouse per definire un oggetto poligonale
   a mano libera nell'immagine, che si chiude automaticamente quando si
   rilascia il tasto del mouse. A questo si apre la finestra di dialogo
   relativa ai dati dell'oggetto.

 - Aggiungere punto: si può usare il mouse per piazzare un oggetto punto nella
   immagine. Quando si rilascia il tatso del mouse si apre la finestra di
   dialogo relativa ai dati dell'oggetto.

 - Definire: la finestra di dialogo corrispondente contiene un elenco degli
   oggetti della mappa; si può usare il pulsante "Elencare per" per vedere
   le voci elencate in base a dati oggetto, URL o commento. Un click sul
   pulsante Mostrare fa sì che l'oggetto selezionato sia evidenziato nella
   immagine. Il pulsante Definire apre una nuova finestra di dialogo relativa
   ai dati dell'oggetto selezionato: si possono modificare i campi Parametri,
   URL e Commento (opzionale), mentre col pulsante Cancellare si può
   rimuovere l'oggetto dalla mappa.

 - Scrivere: questo comando salva il file della mappa usando i dati correnti
   degli oggetti.

 - Esportare: questo comando salva un file HTML (mappa lato client) usando i
   dati correnti degli oggetti. Il file contiene una definizione di esempio
   dell'immagine in linea che usa la mappa. La definizione della mappa può però
   essere usata da altre immagini con l'attributo USEMAP. Gli oggetti punto
   non sono ancora definiti come esportabili dalle specifiche HTML.

 - Cancellare: con questo comando si pssono eliminare tutti gli oggetti della
   mappa (per esempio, prima di caricare una nuova mappa).
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
	global.txt_title_menu  = 'Web Map'
	global.txt_title_load  = 'Web Map laden'
	global.txt_title_save  = 'Web Map speichern'
	global.txt_title_exprt = 'Web Map exportieren (HTML)'
	global.txt_title_edit  = 'Web Map bearbeiten'
	global.txt_title_clear = 'Map löschen'
	global.txt_title_rect  = 'Rechteckdaten'
	global.txt_title_circ  = 'Kreisdaten'
	global.txt_title_poly  = 'Polygondaten'
	global.txt_title_point = 'Punktdaten'
	global.txt_title_def   = 'Standarddaten'

	global.txt_menu_load   = 'Laden...'
	global.txt_menu_save   = 'Speichern...'
	global.txt_menu_export = 'Exportieren (HTML)...'
	global.txt_menu_rect   = 'Neues Rechteck'
	global.txt_menu_circ   = 'Neuer Kreis'
	global.txt_menu_poly   = 'Neues Polygon'
	global.txt_menu_fhand  = 'Neue freies Polygon'
	global.txt_menu_point  = 'Neuer Punkt'
	global.txt_menu_edit   = 'Bearbeiten...'
	global.txt_menu_clear  = 'Löschen'

	global.txt_gad_quit    = '_Verlassen'
	global.txt_gad_del     = '_Löschen'
	global.txt_gad_view    = 'Ansi_cht als:'
	global.txt_gad_view0   = 'Objekt'
	global.txt_gad_view1   = 'URL'
	global.txt_gad_view2   = 'Kommentar'
	global.txt_gad_edit    = '_Bearbeiten'
	global.txt_gad_show    = 'An_zeigen'
	global.txt_gad_exit    = '_Schließen'
	global.txt_gad_param   = 'Pa_rameter:'
	global.txt_gad_url     = '_URL:'
	global.txt_gad_comm    = 'Ko_mmentar:'

	global.txt_err_oldcl   = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	global.txt_err_load    = 'Map kann nicht geöffnet werden'
	global.txt_err_nomap   = 'Map ist leer'
	global.txt_err_noclear = 'Map ist bereits leer'
	global.txt_err_save    = 'Map kann nicht gespeichert werden'
	global.txt_err_export  = 'Map kann nicht exportiert werden'
	global.txt_err_expoint = 'Punk-Objekte wurden nicht exportiert'
	global.txt_err_badpar  = 'Parameter sind ungültig'
	global.txt_err_nourl   = 'Fehlende URL-Festlegung '
	global.txt_msg_clear   = 'Map wird gelöscht'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	global.txt_title_menu  = 'Web Map'
	global.txt_title_load  = 'Leggere Web Map'
	global.txt_title_save  = 'Scrivere Web Map'
	global.txt_title_exprt = 'Esportare Web Map (HTML)'
	global.txt_title_edit  = 'Definizione Web Map'
	global.txt_title_clear = 'Cancellare Web Map'
	global.txt_title_rect  = 'Dati rettangolo'
	global.txt_title_circ  = 'Dati cerchio'
	global.txt_title_poly  = 'Dati poligono'
	global.txt_title_point = 'Dati punto'
	global.txt_title_def   = 'Dati URL predefinita'

	global.txt_menu_load   = 'Leggere...'
	global.txt_menu_save   = 'Scrivere...'
	global.txt_menu_export = 'Esportare (HTML)...'
	global.txt_menu_rect   = 'Aggiungere rettangolo'
	global.txt_menu_circ   = 'Aggiungere cerchio'
	global.txt_menu_poly   = 'Aggiungere poligono'
	global.txt_menu_fhand  = 'Aggiungere area'
	global.txt_menu_point  = 'Aggiungere punto'
	global.txt_menu_edit   = 'Definire...'
	global.txt_menu_clear  = 'Cancellare'

	global.txt_gad_quit    = '_Uscire'
	global.txt_gad_del     = '_Cancellare'
	global.txt_gad_view    = '_Elencare per:'
	global.txt_gad_view0   = 'Oggetto'
	global.txt_gad_view1   = 'URL'
	global.txt_gad_view2   = 'Commento'
	global.txt_gad_edit    = '_Definire'
	global.txt_gad_show    = '_Mostrare'
	global.txt_gad_exit    = '_Uscire'
	global.txt_gad_param   = 'Pa_rametri:'
	global.txt_gad_url     = '_URL:'
	global.txt_gad_comm    = 'Co_mmento:'

	global.txt_err_oldcl   = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	global.txt_err_load    = 'Il file non può essere aperto'
	global.txt_err_nomap   = 'La mappa è vuota'
	global.txt_err_noclear = 'La mappa è già vuota'
	global.txt_err_save    = 'Errore nella scrittura del file'
	global.txt_err_export  = 'Errore nella scrittura del file'
	global.txt_err_expoint = 'Uno o più punti non sono stati esportati'
	global.txt_err_badpar  = 'Parametri errati'
	global.txt_err_nourl   = 'URL non specificata'
	global.txt_msg_clear   = 'La mappa verrà cancellata'
END
ELSE DO				/* English */
	global.txt_title_menu  = 'Web Map'
	global.txt_title_load  = 'Load Web Map'
	global.txt_title_save  = 'Save Web Map'
	global.txt_title_exprt = 'Export Web Map (HTML)'
	global.txt_title_edit  = 'Edit Web Map'
	global.txt_title_clear = 'Clear Map'
	global.txt_title_rect  = 'Rectangle Data'
	global.txt_title_circ  = 'Circle Data'
	global.txt_title_poly  = 'Polygon Data'
	global.txt_title_point = 'Point Data'
	global.txt_title_def   = 'Default Data'

	global.txt_menu_load   = 'Load...'
	global.txt_menu_save   = 'Save...'
	global.txt_menu_export = 'Export (HTML)...'
	global.txt_menu_rect   = 'Add Rectangle'
	global.txt_menu_circ   = 'Add Circle'
	global.txt_menu_poly   = 'Add Polygon'
	global.txt_menu_fhand  = 'Add Freehand Area'
	global.txt_menu_point  = 'Add Point'
	global.txt_menu_edit   = 'Edit...'
	global.txt_menu_clear  = 'Clear'

	global.txt_gad_quit    = '_Quit'
	global.txt_gad_del     = '_Delete'
	global.txt_gad_view    = '_View by:'
	global.txt_gad_view0   = 'Object'
	global.txt_gad_view1   = 'URL'
	global.txt_gad_view2   = 'Comment'
	global.txt_gad_edit    = '_Edit'
	global.txt_gad_show    = '_Show'
	global.txt_gad_exit    = 'E_xit'
	global.txt_gad_param   = 'Pa_rameters:'
	global.txt_gad_url     = '_URL:'
	global.txt_gad_comm    = 'Co_mment:'

	global.txt_err_oldcl   = 'This script requires a newer_version of Personal Paint'
	global.txt_err_load    = 'The map file cannot be opened'
	global.txt_err_nomap   = 'The map is empty'
	global.txt_err_noclear = 'The map is already empty'
	global.txt_err_save    = 'The map cannot be saved'
	global.txt_err_export  = 'The map cannot be exported'
	global.txt_err_expoint = 'One or more point object were not exported'
	global.txt_err_badpar  = 'Invalid parameters'
	global.txt_err_nourl   = 'URL not specified'
	global.txt_msg_clear   = 'The map will be cleared'
END

global.basename = 'T:PP_WebMap_'PRAGMA('ID')'.'
global.last_url = 'http://www.'

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'global.txt_err_oldcl'"'
	EXIT 10
END

GetCurrentBrush
savebsh = RESULT
SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'

GetPen 'FOREGROUND'
savepen = RESULT
Get 'COLORS'
SetPen 'FOREGROUND' RESULT-1

Get 'BARS'
savebars = RESULT
Set '"BARS=2"'

Get 'GCLIP'
saveclip = RESULT
Set '"GCLIP=0"'

DisableTools

SIGNAL ON Break_C

command = 0
DO FOREVER
	Request '"'global.txt_title_menu'" ',
	        '"LIST ACTION = , 10, 'command', 20, 10, ',
	        ' ""'global.txt_menu_load'"", ',
	        ' ""'global.txt_menu_save'"", ',
	        ' ""'global.txt_menu_export'"", ',
	        ' ""'global.txt_menu_rect'"", ',
	        ' ""'global.txt_menu_circ'"", ',
	        ' ""'global.txt_menu_poly'"", ',
	        ' ""'global.txt_menu_fhand'"", ',
	        ' ""'global.txt_menu_point'"", ',
	        ' ""'global.txt_menu_edit'"", ',
	        ' ""'global.txt_menu_clear'""  ',
	        ' ACTION = PROCEED ',
	        ' ACTION = ""'global.txt_gad_quit'"" "'

	IF RESULT = 2 THEN	/* Quit */
		LEAVE
	ELSE DO 	/* Proceed / Command List */
		command = RESULT.1
		IF      command = 0 THEN CALL LoadMap
		ELSE IF command = 1 THEN CALL SaveMap
		ELSE IF command = 2 THEN CALL ExportMap
		ELSE IF command = 3 THEN CALL AddRectangle
		ELSE IF command = 4 THEN CALL AddCircle
		ELSE IF command = 5 THEN CALL AddPolygon
		ELSE IF command = 6 THEN CALL AddFreehand
		ELSE IF command = 7 THEN CALL AddPoint
		ELSE IF command = 8 THEN CALL EditMap
		ELSE IF command = 9 THEN CALL ClearMap
	END
END

CALL Break_C
EXIT 0





LoadMap: PROCEDURE EXPOSE global.

	RequestFile 'TITLE "'global.txt_title_load'"'
	IF RC = 0 THEN DO
		PARSE VALUE RESULT WITH '"' mfilename '"'
		IF OPEN('mfile', mfilename, 'R') THEN DO
			LockGUI
			comment = ''
			DO FOREVER
				mline = READLN('mfile')
				IF EOF('mfile') THEN
					LEAVE
				mline = STRIP(mline)
				IF LEFT(mline, 1) = '#' THEN
					comment = comment STRIP(SUBSTR(mline, 2))
				ELSE DO
					PARSE VAR mline obtype url param
					obtype = TRANSLATE(obtype, XRANGE('a','z'), XRANGE('A', 'Z'))	/* convert to lower case */
					param = STRIP(TRANSLATE(param, ' ', ','))
					comment = STRIP(comment)

					IF obtype = 'rect' | ,
						obtype = 'circle' | ,
						obtype = 'poly' |,
						obtype = 'point' THEN DO

						CALL XorObject(obtype, param)
						CALL AddObject(obtype, 0 '"'param'" "'url'" "'comment'"')
					END
					ELSE IF obtype = 'default' THEN DO
						IF OPEN('obfile', global.basename || 'def', 'W') THEN DO
							CALL WRITELN('obfile', url)
							CALL WRITELN('obfile', comment)
							CALL CLOSE('obfile')
						END
					END
					comment = ''
				END
			END
			CALL CLOSE('mfile')
			UnlockGUI
		END
		ELSE RequestNotify 'TITLE "'global.txt_title_load'" PROMPT "'global.txt_err_load'"'
	END

	RETURN




AddRectangle: PROCEDURE EXPOSE global.

	SetPointer 'DATA ',
		'"0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,0xA82A,',
		' 0x0000,0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,',
		' 0x0000,0x0000,0x0000,0x1FE0,0x1020,0x1020,0x1020,0x1FE0,',
		' 0x0000,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x5454,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,',
		' 0x0000,0x0000,0x0000,0x0000,0x0FD0,0x0810,0x0810,0x0010,',
		' 0x0FF0" ',
		'HEIGHT 25 OFFSETX -8 OFFSETY -7'

	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN DO
		PARSE VAR RESULT button x0 y0 .
		prev_xp = x0
		prev_yp = y0
		drawn = 0

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
				IF drawn THEN
					Undo
				DrawRectangle x0 y0 xp yp 'COMPLEMENT'

				prev_xp = xp
				prev_yp = yp
				drawn = 1
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END

		IF x0 > xp THEN DO
			t = x0
			x0 = xp
			xp = t
		END
		IF y0 > yp THEN DO
			t = y0
			y0 = yp
			yp = t
		END

		objdata = RequestObject(global.txt_title_rect, 'rect', x0','y0 xp','yp, '', '', 0)
		IF objdata = 'cancel' THEN
			erase_it = 1
		ELSE
			PARSE VAR objdata erase_it .
		IF erase_it THEN
			DrawRectangle x0 y0 xp yp 'COMPLEMENT'

		IF objdata ~= 'cancel' THEN DO
			IF erase_it THEN DO
				PARSE VALUE objdata WITH . '"' param '"' .
				DrawRectangle param 'COMPLEMENT'
			END
			CALL AddObject('rect', objdata)
		END
	END
	SetPointer
	RETURN




AddCircle: PROCEDURE EXPOSE global.

	SetPointer 'DATA ',
		'"0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,0xA82A,',
		' 0x0000,0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,',
		' 0x0000,0x0000,0x0000,0x0780,0x0840,0x1020,0x1020,0x1020,',
		' 0x0840,0x0780,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x5454,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,',
		' 0x0000,0x0000,0x0000,0x0040,0x0420,0x0810,0x0810,0x0810,',
		' 0x0420,0x0040" ',
		'HEIGHT 26 OFFSETX -8 OFFSETY -7'

	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN DO
		PARSE VAR RESULT button x0 y0 .
		prev_xp = x0
		prev_yp = y0
		drawn = 0

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
				IF drawn THEN
					Undo
				GetDistance x0 y0 xp yp 'IMAGERATIO'
				radius = RESULT
				DrawCircle x0 y0 'RADIUSX' radius 'COMPLEMENT'

				prev_xp = xp
				prev_yp = yp
				drawn = 1
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END

		objdata = RequestObject(global.txt_title_circ, 'circle', x0','y0 xp','yp, '', '', 0)
		IF objdata = 'cancel' THEN
			erase_it = 1
		ELSE
			PARSE VAR objdata erase_it .
		IF erase_it THEN DO
			DrawCircle x0 y0 'RADIUSX' radius 'COMPLEMENT'
		END

		IF objdata ~= 'cancel' THEN DO
			IF erase_it THEN DO
				PARSE VALUE objdata WITH . '"' x0 y0 xp yp '"' .
				GetDistance x0 y0 xp yp 'IMAGERATIO'
				radius = RESULT
				DrawCircle x0 y0 'RADIUSX' radius 'COMPLEMENT'
			END
			CALL AddObject('circle', objdata)
		END
	END
	SetPointer
	RETURN




AddPolygon: PROCEDURE EXPOSE global.

	SetPointer 'DATA ',
		'"0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,0xA82A,,',
		' 0x0000,0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,,',
		' 0x0000,0x0000,0x0000,0x0400,0x0A80,0x1140,0x0820,0x0440,,',
		' 0x0280,0x0100,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x5454,,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,,',
		' 0x0000,0x0000,0x0000,0x0200,0x0540,0x08A0,0x0410,0x0220,,',
		' 0x0140,0x0080" ',
		'HEIGHT 26 OFFSETX -8 OFFSETY -7'

	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN DO
		PARSE VAR RESULT button x0 y0 .
		prev_xp = x0
		prev_yp = y0
		xs = x0
		ys = y0
		xcoord.0 = x0
		ycoord.0 = y0
		points = 1
		bpressed = 1
		drawn = 0

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
				IF drawn THEN
					Undo
				DrawLine xs ys xp yp 'COMPLEMENT NOFIRSTPIXEL'

				prev_xp = xp
				prev_yp = yp
				drawn = 1
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT = 0 THEN DO
				IF bpressed THEN DO
					bpressed = 0
					dx0 = ABS(prev_xp - x0)
					dy0 = ABS(prev_yp - y0)
					IF dx0 < 3 & dy0 < 3 & points > 1 THEN
						LEAVE
					IF xs ~= prev_xp | ys ~= prev_yp THEN DO
						xs = prev_xp
						ys = prev_yp
						xcoord.points = xs
						ycoord.points = ys
						points = points + 1
						drawn = 0
					END
				END
			END
			ELSE DO
				IF RESULT ~= button THEN
					LEAVE
				bpressed = 1
			END
		END

		IF drawn THEN
			Undo
		DrawLine xs ys x0 y0 'COMPLEMENT NOFIRSTPIXEL'

		objdata = RequestObject(global.txt_title_poly, 'poly', PointString('xcoord', 'ycoord', ',', points), '', '', 0)
		IF objdata = 'cancel' THEN
			erase_it = 1
		ELSE
			PARSE VAR objdata erase_it .
		IF erase_it THEN
			DrawPolygon '"' PointString('xcoord', 'ycoord', ' ', points) '" COMPLEMENT'

		IF objdata ~= 'cancel' THEN DO
			IF erase_it THEN DO
				PARSE VALUE objdata WITH . '"' param '"' .
				DrawPolygon '"'param'" COMPLEMENT'
			END
			CALL AddObject('poly', objdata)
		END
	END
	SetPointer
	RETURN




AddFreehand: PROCEDURE EXPOSE global.

	SetPointer 'DATA ',
		'"0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,0xA82A,',
		' 0x0000,0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,',
		' 0x0000,0x0000,0x0000,0x0600,0x0900,0x10C0,0x1020,0x0820,',
		' 0x0640,0x0180,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x5454,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,',
		' 0x0000,0x0000,0x0000,0x0100,0x0480,0x0820,0x0810,0x0410,',
		' 0x0120,0x0040" ',
		'HEIGHT 26 OFFSETX -8 OFFSETY -7'

	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN DO
		PARSE VAR RESULT button x0 y0 .
		prev_xp = x0
		prev_yp = y0
		xcoord.0 = x0
		ycoord.0 = y0
		points = 1

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp THEN DO
				DrawLine prev_xp prev_yp xp yp 'COMPLEMENT NOFIRSTPIXEL'

				xcoord.points = xp
				ycoord.points = yp
				points = points + 1

				prev_xp = xp
				prev_yp = yp
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END
		DrawLine prev_xp prev_yp x0 y0 'COMPLEMENT NOFIRSTPIXEL'

		objdata = RequestObject(global.txt_title_poly, 'poly', PointString('xcoord', 'ycoord', ',', points), '', '', 0)
		IF objdata = 'cancel' THEN
			erase_it = 1
		ELSE
			PARSE VAR objdata erase_it .
		IF erase_it THEN
			DrawPolygon '"' PointString('xcoord', 'ycoord', ' ', points) '" COMPLEMENT'

		IF objdata ~= 'cancel' THEN DO
			IF erase_it THEN DO
				PARSE VALUE objdata WITH . '"' param '"' .
				DrawPolygon '"'param'" COMPLEMENT'
			END
			CALL AddObject('poly', objdata)
		END
	END
	SetPointer
	RETURN




AddPoint: PROCEDURE EXPOSE global.

	SetPointer 'DATA ',
		'"0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,0xA82A,',
		' 0x0000,0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,',
		' 0x0000,0x0000,0x0000,0x0000,0x0780,0x0780,0x0780,0x0000,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x5454,',
		' 0x0000,0x0100,0x0000,0x0100,0x0000,0x0100,0x0000,0x0000,',
		' 0x0000,0x0000,0x0000,0x0000,0x0000,0x0040,0x0040,0x03C0" ',
		'HEIGHT 24 OFFSETX -8 OFFSETY -7'

	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN DO
		PARSE VAR RESULT button x0 y0 .
		prev_xp = x0
		prev_yp = y0

		SetCurrentBrush 'RECTANGULAR WIDTH 5 HEIGHT 5'
		DisableTools
		PutBrush x0 y0 'COMPLEMENT'

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp THEN DO
				Undo
				PutBrush xp yp 'COMPLEMENT'

				prev_xp = xp
				prev_yp = yp
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END

		objdata = RequestObject(global.txt_title_point, 'point', xp','yp, '', '', 0)
		IF objdata = 'cancel' THEN
			erase_it = 1
		ELSE
			PARSE VAR objdata erase_it .
		IF erase_it THEN
			PutBrush xp yp 'COMPLEMENT'

		IF objdata ~= 'cancel' THEN DO
			IF erase_it THEN DO
				PARSE VALUE objdata WITH . '"' param '"' .
				PutBrush param 'COMPLEMENT'
			END
			CALL AddObject('point', objdata)
		END
		SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
		DisableTools
	END
	SetPointer
	RETURN




EditMap: PROCEDURE EXPOSE global.

	obnum = GetObjectNum()

	IF obnum = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_edit'" PROMPT "'global.txt_err_nomap'"'
		RETURN
	END

	tnum = obnum + 1
	def = obnum

	DO ob = 0 FOR obnum
		IF OPEN('obfile', global.basename || ob, 'R') THEN DO
			obtype.ob  = READLN('obfile')
			param.ob   = InsertCommas(READLN('obfile'))
			url.ob     = READLN('obfile')
			comment.ob = READLN('obfile')
			CALL CLOSE('obfile')
		END
	END
	IF OPEN('obfile', global.basename || 'def', 'R') THEN DO
		url.def     = READLN('obfile')
		comment.def = READLN('obfile')
		CALL CLOSE('obfile')
	END
	ELSE DO
		url.def     = ''
		comment.def = ''
	END
	obtype.def = 'default'
	param.def  = ''

	action = 0
	selected = 0
	view_by = 0
	IF OPEN('edfile', global.basename || 'edit', 'R') THEN DO
		selected = READLN('edfile')
		view_by = READLN('edfile')
		CALL CLOSE('edfile')
	END

	LockGUI
	DO WHILE action ~= 3 & obnum > 0
		req = '"LIST = , 'tnum', 'selected', 26, 8'
		IF view_by = 0 THEN DO
			DO ob = 0 FOR tnum
				req = req || ', ""' || obtype.ob param.ob '""'
			END
		END
		ELSE IF view_by = 1 THEN DO
			DO ob = 0 FOR tnum
				IF url.ob ~= '' THEN
					req = req || ', ""' || url.ob '""'
				ELSE
					req = req || ', . '
			END
		END
		ELSE IF view_by = 2 THEN DO
			DO ob = 0 FOR tnum
				IF comment.ob ~= '' THEN
					req = req || ', ""' || comment.ob '""'
				ELSE
					req = req || ', . '
			END
		END

		req = req ||,
			'CYCLE ACTION = ""'global.txt_gad_view'"", 3, 'view_by', ""'global.txt_gad_view0'"", ""'global.txt_gad_view1'"", ""'global.txt_gad_view2'"" ' ||,
			'ACTION = ""'global.txt_gad_edit'"" ' ||,
			'ACTION = ""'global.txt_gad_show'"" ' ||,
			'ACTION = ""'global.txt_gad_exit'"" "'

		Request '"'global.txt_title_edit'" RESIZE 'req
		action   = RESULT
		selected = RESULT.1
		view_by  = RESULT.2

		IF action = 1 THEN DO	/* Edit */
			IF obtype.selected = 'rect' THEN
				title = global.txt_title_rect
			ELSE IF obtype.selected = 'circle' THEN
				title = global.txt_title_circ
			ELSE IF obtype.selected = 'poly' THEN
				title = global.txt_title_poly
			ELSE IF obtype.selected = 'point' THEN
				title = global.txt_title_point
			ELSE
				title = global.txt_title_def

			objdata = RequestObject(title, obtype.selected, param.selected, url.selected, comment.selected, 1)

			IF objdata = 'delete' THEN DO		/* Delete */
				IF selected ~= def THEN DO
					CALL XorObject(obtype.selected, TRANSLATE(param.selected, ' ', ','))

					ADDRESS COMMAND 'Delete >NIL: 'global.basename || selected

					IF selected < obnum THEN DO
						obmax = tnum - 2
						DO ob = selected TO obmax
							nob = ob + 1
							obtype.ob  = obtype.nob
							param.ob   = param.nob
							url.ob     = url.nob
							comment.ob = comment.nob
							IF ob < obmax THEN
								ADDRESS COMMAND 'Rename >NIL: 'global.basename || nob  global.basename || ob
						END
					END
					obnum = obnum - 1
					tnum = obnum + 1
					def = obnum
					CALL SetObjectNum(obnum)

					IF selected >= obnum & obnum > 0 THEN
						selected = obnum - 1
				END
				ELSE DO	/* default */
					ADDRESS COMMAND 'Delete >NIL: 'global.basename || 'def'
					url.def     = ''
					comment.def = ''
				END
			END
			ELSE IF objdata ~= 'cancel' THEN DO		/* Proceed */
				IF selected ~= def THEN DO
					PARSE VAR objdata new_par .
					IF new_par THEN
						CALL XorObject(obtype.selected, TRANSLATE(param.selected, ' ', ','))

					PARSE VALUE objdata WITH . '"' param.selected '" "' url.selected '" "' comment.selected '"' .
					IF new_par THEN
						CALL XorObject(obtype.selected, TRANSLATE(param.selected, ' ', ','))

					IF OPEN('obfile', global.basename || selected, 'W') THEN DO
						CALL WRITELN('obfile', obtype.selected)
						CALL WRITELN('obfile', TRANSLATE(param.selected, ' ', ','))
						CALL WRITELN('obfile', url.selected)
						CALL WRITELN('obfile', comment.selected)
						CALL CLOSE('obfile')
					END
				END
				ELSE DO	/* default */
					PARSE VALUE objdata WITH '"' url.selected '" "' comment.selected '"' .

					IF OPEN('sfile', global.basename || 'def', 'W') THEN DO
						CALL WRITELN('sfile', url.selected)
						CALL WRITELN('sfile', comment.selected)
						CALL CLOSE('sfile')
					END
				END
			END
		END
		ELSE IF action = 2 & selected ~= def THEN DO		/* Show */
			CALL XorObject(obtype.selected, TRANSLATE(param.selected, ' ', ','))
			times = 5
			DO tm = 1 TO times
				Wait 'TIME 120'
				Undo
				IF tm < times THEN DO
					Wait 'TIME 120'
					Redo
				END
			END
		END
	END
	UnlockGUI

	IF OPEN('sfile', global.basename || 'edit', 'W') THEN DO
		CALL WRITELN('sfile', selected)
		CALL WRITELN('sfile', view_by)
		CALL CLOSE('sfile')
	END

	RETURN




SaveMap: PROCEDURE EXPOSE global.

	obnum = GetObjectNum()

	IF obnum > 0 THEN DO
		RequestFile 'TITLE "'global.txt_title_save'" SAVEMODE'
		IF RC = 0 THEN DO
			PARSE VALUE RESULT WITH '"' mfilename '"'
			IF OPEN('mfile', mfilename, 'W') THEN DO
				LockGUI
				GetImageAttributes 'NAME'
				CALL WRITELN('mfile', '# Map file for "'RESULT'" ('obnum' objects)')

				DO ob = 0 FOR obnum
					IF OPEN('obfile', global.basename || ob, 'R') THEN DO
						obtype  = READLN('obfile')
						param   = READLN('obfile')
						url     = READLN('obfile')
						comment = READLN('obfile')

						CALL WRITELN('mfile', '')
						IF comment ~= '' THEN
							CALL WRITELN('mfile', '# 'comment)
						CALL WRITELN('mfile', obtype url InsertCommas(param))

						CALL CLOSE('obfile')
					END
				END
				IF OPEN('obfile', global.basename || 'def', 'R') THEN DO
					url = READLN('obfile')
					comment = READLN('obfile')
					CALL WRITELN('mfile', '')
					IF comment ~= '' THEN
						CALL WRITELN('mfile', '# 'comment)
					CALL WRITELN('mfile', 'default 'url)
					CALL CLOSE('obfile')
				END
				CALL CLOSE('mfile')
				UnlockGUI
			END
			ELSE RequestNotify 'TITLE "'global.txt_title_save'" PROMPT "'global.txt_err_save'"'
		END
	END
	ELSE RequestNotify 'TITLE "'global.txt_title_save'" PROMPT "'global.txt_err_nomap'"'

	RETURN



ExportMap: PROCEDURE EXPOSE global.

	obnum = GetObjectNum()

	IF obnum > 0 THEN DO
		RequestFile 'TITLE "'global.txt_title_exprt'" SAVEMODE'
		IF RC = 0 THEN DO
			PARSE VALUE RESULT WITH '"' mfilename '"'
			IF OPEN('mfile', mfilename, 'W') THEN DO
				LockGUI
				GetImageAttributes 'NAME'
				imgname = RESULT
				ppos = INDEX(imgname, '.')
				IF ppos > 1 THEN
					mapname = LEFT(imgname, ppos - 1)
				ELSE
					mapname = imgname
				point_found = 0

				CALL WRITELN('mfile', '<!-- Map file for "'imgname'" ('obnum' objects) -->')

				CALL WRITELN('mfile', '0a'X'<H1>Imagemap</H1>')
				CALL WRITELN('mfile', '<IMG SRC="'imgname'" USEMAP="#'mapname'">')
				CALL WRITELN('mfile', '<MAP NAME="'mapname'">')

				DO ob = 0 FOR obnum
					IF OPEN('obfile', global.basename || ob, 'R') THEN DO
						obtype  = READLN('obfile')
						param   = READLN('obfile')
						url     = READLN('obfile')
						comment = READLN('obfile')

						IF obtype = 'point' THEN
							point_found = 1
						ELSE DO
							IF obtype = 'poly' THEN
								obtype = 'polygon'

							CALL WRITECH('mfile', '<AREA SHAPE="'obtype'" ')

							IF comment ~= '' THEN
								CALL WRITECH('mfile', 'ALT="'comment'" ')

							IF obtype = 'circle' THEN DO
								PARSE VAR param x0 y0 x1 y1 .
								GetDistance x0 y0 x1 y1 'IMAGERATIO'
								param = x0 y0 RESULT
							END

							CALL WRITELN('mfile', 'COORDS="' || TRANSLATE(param, ',', ' ') || '" HREF="'url'">')
						END
						CALL CLOSE('obfile')
					END
				END
				IF OPEN('obfile', global.basename || 'def', 'R') THEN DO
					url = READLN('obfile')
					comment = READLN('obfile')
					CALL WRITECH('mfile', '<AREA SHAPE="rect" ')

					IF comment ~= '' THEN
						CALL WRITECH('mfile', 'ALT="'comment'" ')

					Get 'IMAGEW'
					xmax = RESULT - 1
					Get 'IMAGEH'
					ymax = RESULT - 1

					CALL WRITELN('mfile', 'COORDS="0,0,'xmax','ymax'" HREF="'url'">')

					CALL CLOSE('obfile')
				END
				CALL WRITELN('mfile', '</MAP>')
				CALL CLOSE('mfile')

				IF point_found THEN
					RequestNotify 'TITLE "'global.txt_title_exprt'" PROMPT "'global.txt_err_expoint'"'

				UnlockGUI
			END
			ELSE RequestNotify 'TITLE "'global.txt_title_exprt'" PROMPT "'global.txt_err_export'"'
		END
	END
	ELSE RequestNotify 'TITLE "'global.txt_title_exprt'" PROMPT "'global.txt_err_nomap'"'

	RETURN



ClearMap: PROCEDURE EXPOSE global.

	IF GetObjectNum() > 0 THEN DO
		RequestResponse 'TITLE "'global.txt_title_clear'" PROMPT "'global.txt_msg_clear'"'
		IF RC = 0 THEN
			CALL Cleanup
	END
	ELSE RequestNotify 'TITLE "'global.txt_title_clear'" PROMPT "'global.txt_err_noclear'"'

	RETURN




PointString:

	INTERPRET('PROCEDURE EXPOSE' ARG(1)'.' ARG(2)'.')

	xname = ARG(1)
	yname = ARG(2)
	separ = ARG(3)
	ptnum = ARG(4)

	DO pt = 0 FOR ptnum
		ppoint = VALUE(xname'.'pt) || separ || VALUE(yname'.'pt)
		IF pt = 0 THEN
			ppoints = ppoint
		ELSE
			ppoints = ppoints ppoint
	END

	RETURN ppoints




InsertCommas: PROCEDURE EXPOSE global.

	param = ARG(1)
	wnum = WORDS(param)

	DO w = 1 TO wnum BY 2
		point = WORD(param, w) || ',' || WORD(param, w+1)
		IF w = 1 THEN
			cparam = point
		ELSE
			cparam = cparam point
	END

	RETURN cparam




RequestObject: PROCEDURE EXPOSE global.

	do_request = 1

	DO WHILE do_request
		title   = ARG(1)
		type    = ARG(2)
		param   = ARG(3)
		url     = ARG(4)
		comment = ARG(5)
		delgadg = ARG(6)

		do_request = 0
		is_def = (type = 'default')

		IF url = '' & ~is_def THEN
			url = global.last_url

		start_url = url
		start_param = param

		IF delgadg THEN
			reqact = 'ACTION = PROCEED ' ||,
						'ACTION = ""'global.txt_gad_del'"" ' ||,
						'ACTION = CANCEL '
		ELSE
			reqact = ''	 /* PROCEED CANCEL */

		IF is_def THEN DO
			Request '"'CENTER(title, 44)'" RESIZE ',  /* spaces are used to properly size the requester */
			         '"STRING = ""'global.txt_gad_url'"", 200, ""'url'"" ',
			         ' STRING = ""'global.txt_gad_comm'"", 200, ""'comment'"" ',
						reqact '"'
			IF RC = 0 & RESULT = 1 THEN DO	/* Proceed */
				url     = RESULT.1
				comment = RESULT.2

				IF url = '' THEN
					obj_data = 'delete'
				ELSE
					obj_data = '"'url'" "'comment'"'
			END
			ELSE IF RC = 0 & RESULT = 2 THEN		/* Delete */
				obj_data = 'delete'
			ELSE
				obj_data = 'cancel'
		END
		ELSE DO
			Request '"'CENTER(title, 44)'" RESIZE ',  /* spaces are used to properly size the requester */
			         '"STRING = ""'global.txt_gad_param'"", 1000, ""'param'"" ',
			         ' STRING = ""'global.txt_gad_url'"", 200, ""'url'"" ',
			         ' STRING = ""'global.txt_gad_comm'"", 200, ""'comment'"" ',
						reqact '"'
			IF RC = 0 & RESULT = 1 THEN DO	/* Proceed */
				param   = RESULT.1
				url     = RESULT.2
				comment = RESULT.3
				newparam = (param ~= start_param)

				IF      type = 'rect'   THEN	crdnum = 4
				ELSE IF type = 'circle' THEN	crdnum = 4
				ELSE IF type = 'point'  THEN	crdnum = 2
				ELSE crdnum = 0	/* poly */

				param = TRANSLATE(param, ' ', ',')
				pnum = WORDS(param)

				IF ~DATATYPE(pnum / 2, 'W') THEN
					do_request = 1
				IF crdnum > 0 & crdnum ~= pnum THEN
					do_request = 1
				IF ~do_request THEN DO
					DO pn = 1 TO pnum
						IF ~DATATYPE(WORD(param, pn), 'W') THEN DO
							do_request = 1
							LEAVE
						END
					END
				END
				IF do_request THEN
					RequestNotify 'PROMPT "'global.txt_err_badpar'"'
				ELSE IF url = '' THEN DO
					do_request = 1
					RequestNotify 'PROMPT "'global.txt_err_nourl'"'
				END
				IF ~do_request THEN
					obj_data = newparam '"'param'" "'url'" "'comment'"'
			END
			ELSE IF RC = 0 & RESULT = 2 THEN		/* Delete */
				obj_data = 'delete'
			ELSE
				obj_data = 'cancel'
		END
		IF url ~= start_url & url ~= '' THEN
			global.last_url = url
	END

	RETURN obj_data




GetObjectNum: PROCEDURE EXPOSE global.

	obnum = 0
	IF OPEN('obnfile', global.basename || 'num', 'R') THEN DO
		obnum = READLN('obnfile')
		CALL CLOSE('obnfile')
	END
	RETURN obnum





SetObjectNum: PROCEDURE EXPOSE global.

	IF OPEN('obnfile', global.basename || 'num', 'W') THEN DO
		CALL WRITELN('obnfile', ARG(1))
		CALL CLOSE('obnfile')
	END
	RETURN




AddObject: PROCEDURE EXPOSE global.

	PARSE VALUE ARG(2) WITH . '"' param '" "' url '" "' comment '"'
	obnum = GetObjectNum()
	IF OPEN('obfile', global.basename || obnum, 'W') THEN DO
		CALL WRITELN('obfile', ARG(1))
		CALL WRITELN('obfile', param)
		CALL WRITELN('obfile', url)
		CALL WRITELN('obfile', comment)
		CALL CLOSE('obfile')

		CALL SetObjectNum(obnum + 1)
	END
	RETURN




XorObject: PROCEDURE EXPOSE global.

	obtype = ARG(1)
	param = ARG(2)

	IF obtype = 'point' THEN DO
		SetCurrentBrush 'RECTANGULAR WIDTH 5 HEIGHT 5'
		PutBrush param 'COMPLEMENT'
		SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
		DisableTools
	END
	ELSE IF obtype = 'circle' THEN DO
		PARSE VAR param x0 y0 x1 y1 .
		GetDistance x0 y0 x1 y1 'IMAGERATIO'
		DrawCircle x0 y0 'RADIUSX' RESULT 'COMPLEMENT'
	END
	ELSE IF obtype = 'rect' THEN
		DrawRectangle param 'COMPLEMENT'

	ELSE IF obtype = 'poly' THEN
		DrawPolygon '"'param'" COMPLEMENT'

	RETURN




Cleanup: PROCEDURE EXPOSE global.

	LockGUI
	obnum = GetObjectNum()

	DO ob = 0 FOR obnum
		IF OPEN('obfile', global.basename || ob, 'R') THEN DO
			CALL XorObject(READLN('obfile'), READLN('obfile'))
			CALL CLOSE('obfile')
		END
	END
	ADDRESS COMMAND 'Delete >NIL: 'global.basename'#?'
	UnlockGUI

	RETURN




Break_C:

	CALL Cleanup

	SetPen 'FOREGROUND' savepen
	SetCurrentBrush savebsh
	Set '"BARS='savebars'"'
	Set '"GCLIP='saveclip'"'
	EnableTools

	RETURN
