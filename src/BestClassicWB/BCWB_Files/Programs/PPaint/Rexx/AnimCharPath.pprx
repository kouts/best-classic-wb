/* Personal Paint Amiga Rexx script - Copyright © 1997 Cloanto Italia srl */

/* $VER: AnimCharPath.pprx 1.1 */

/** ENG
 This script can be used to easily create animations with
 moving and transforming characters (vector fonts).

 The main requester gives access to the following commands:

 - New: the path is cleared and the character settings are restored
   to their default values.

 - Load: an existing path file can be selected using the file requester;
   this causes the path coordinates, the brush transformation settings
   and the animation settings to be loaded (note: this data
   is stored in ASCII format and can easily be algorithmically
   generated and manipulated by other programs).

 - Save: this command writes a path file using the current path data.

 - Define Freehand: the mouse can be used to "draw" the path;
   both the direction of the path and the mouse movement speed
   affect the resulting animation: the original direction
   is used to render the frames (the starting point is used
   to place the object in the first frame and the last point
   is used for the last frame) and the drawing speed
   affects the number and the "density" of stored points
   (the slower the speed, the more points, and
   vice versa) and defines the perceived speed of the animation
   (e.g. a path defined with a high initial speed and a slow
   ending speed leads to a corresponding animation).
   Before the mouse button is pressed, the character is displayed
   to ease positioning in the first frame. All drawing must occur
   holding down the left mouse button, releasing it only at the
   end of the definition.

 - Define Linear: the mouse can be used to define a linear path
   (simply consisting of a starting point and an ending point);
   unlike the freehand path, this kind of path produces a
   constant-speed animation (equally-spaced intermediate points
   are generated automatically). To define the path, press the left
   mouse button on the starting point, and release it at the end.

 - Edit: this command can be used to visually edit the path;
   the "path points" can be dragged with the mouse to change the
   path shape and/or density (speed); the <m> key toggles
   the magnify mode on or off, and the right mouse button or the <Esc> key
   can be pressed to leave the editing mode.

 - Move and Resize: the mouse can be used to resize the animation
   path (clicking on the lower right part of the path) or to drag it
   to a new position (clicking on the upper part). This is useful
   to create paths with point outside the screen, which cannot be
   drawn by hand. The <m> key toggles the magnify mode on or off, and
   the right mouse button or the <Esc> key can be pressed
   to exit from the move and resize mode.

 - Character: the character requester can be used to select the
   font to be used (the "Vector Font Path Selection" macro must be
   run to select a font path other than "FONTS:"), the character,
   its (initial) size, the handle position ("Base Left", "Base Center",
   "Center") and the antialias level ("None", "Low", "Medium", "High").

 - Character Angle: the Character Angle requester is used to set
   the number of character rotations ("Rotation Cycles"), the starting
   ("From Angle") and ending angle ("To Angle"), and the
   rotation direction ("Direction": "Clockwise/Counterclockwise");
   a number of rotations greater than 1 can be used to add
   additional 360° spins in the specified direction.

 - Character Shear: the Character Shear requester is used to set
   the number of shear cycles ("Shear Cycles"), and the starting and
   ending shear level ("From Angle", "To Angle"); if a number of
   shear cycles greather than 1 is specified,
   the shear factors will move back and forth within the specified
   limits (an odd number of cycles must be used to reach the ending
   shear in the last frame).

 - Character Boldness: the Character Boldness requester is used to set
   the number of boldness cycles, the starting and
   ending horizontal boldness level ("From Horizontal" and "To Horizontal"),
   and the starting and ending vertical boldness ("From Vertical" and
   "To Vertical"); if a number of cycles greather than 1
   is specified, the boldness levels will move back and forth within
   the specified limits (an odd number of cycles must be used to reach
   the ending boldness in the last frame).

 - Character Size: the Character Size requester is used to set
   the number of resize cycles ("Resize Cycles"), and the starting and
   ending size ("From" and "To", in percentage of the initial size);
   if a number of resize cycles greather than 1 is specified,
   the resize factor will move back and forth within the specified
   limits (an odd number of cycles must be used to reach the ending
   size in the last frame).

 - Data: the Data requester is used to view all path information
   at a glance (animation, character, rotation, shear, boldness
   and resize settings, followed by the path coordinates).

 - Preview: this command is used to preview the animation (no antialiasing
   is applied in preview mode).

 The main requester also contains gadgets to set the animation
 frames ("Count"), the recording direction ("Direction":
 "Forward/Backward/Still" - the frame step) and the frame insertion option
 ("Add Frames" - if active, "Count" frames are inserted).

 When using freehand paths with no character effect, the "Count"
 setting should not be set to a number greater than the path points
 (as reported by the Data requester), as this would generate one or more
 duplicate frames.

 The bottom gadgets in the main requester can be used to render
 the animation ("Draw", which also terminates the script) or to
 quit the script ("Quit"). A copy of the current path is
 always temporarily stored, so that it can be used when the script is
 run again.
*/

/** DEU
 Dieses Skript ermöglicht die einfache Erzeugung von Animationen, in deren
 Verlauf Schriftzeichen aus Vektorfonts bewegt und verwandelt werden.

 Im Haupt-Dialogfenster erfolgt der Zugriff auf folgende Befehle:

 - Neu: Löscht den alten Pfad und setzt die Zeicheneinstellungen auf ihre
   Standardwerte zurück.

 - Laden: Mit dem Dateiauswahlfenster läßt sich eine zurvor gespeicherte
   Pfaddatei auswählen. Dabei werden Pfadkoordinaten, Einstellungen für die
   Pinseltransformation und verschiedene Animationseinstellungen geladen.
   Hinweis: Diese Daten liegen im ASCII-Format vor und lassen sich daher auf
   einfache Weise mit Hilfe anderer Programme algorithmisch erzeugen und/oder
   verändern.

 - Speichern: Schreibt eine Pfaddatei unter Verwendung der aktuellen
   Pfaddaten.

 - Frei festlegen: Ermöglicht die Bestimmung des Pfades mit Hilfe der Maus.
   Sowohl dessen Verlauf als auch die Geschwindigkeit der Mausbewegung
   beeinflussen den späteren Animationsablauf: Die ursprüngliche Richtung wird
   zur Berechnung der Einzelbilder verwendet (Das erste Einzelbild wird am
   Startpunkt berechnet, das letzte dementsprechend am Zielpunkt), während die
   Geschwindigkeit des Zeichenvorgangs sowohl Anzahl als auch Abstand
   ("Dichte") der gespeicherten Punkte beeinflußt. Dabei gilt: Je geringer die
   Geschwindigkeit, desto mehr Punkte, und umgekehrt. Auch die
   Ablaufgeschwindigkeit hängt von diesem Faktor ab, d. h. ein mit hoher
   Anfangs- und geringer Endgeschwindigkeit definierter Pfad erzeugt eine
   dementsprechend mit zunehmend geringerer Geschwindigkeit ablaufende
   Animation. Um die Festlegung der Position für das erste Einzelbild zu
   erleichtern, wird vor der Betätigung der linken Maustaste das aktuelle
   Zeichen angezeigt.

 - Linear festlegen: Ermöglicht die Bestimmung eines linearen Pfades,
   welcher lediglich durch Anfangs- und Endpunkt festgelegt wird. Im Gegensatz
   zum frei festgelegten Pfad wird hierdurch eine Animation erzeugt, die über
   ihren gesamten Verlauf hinweg eine konstante Geschwindigkeit beibehält, da
   die Zwischenpunkte automatisch alle im gleichen Abstand voneinander
   angeordnet werden.

 - Bearbeiten: Dient zur visuellen Bearbeitung des Pfades. Durch Verschieben
   der einzelnen Knotenpunkte des Pfades mit der Maus lassen sich Form und
   Dichte (Geschwindigkeit) ändern. Mit Hilfe der Taste <m> läßt sich die
   Lupenfunktion an- oder ausschalten. Um den Bearbeitungsmodus zu verlassen,
   ist die <Esc>-Taste zu drücken.

 - Position und Größe: Hiermit lassen sich unter Verwendung der Maus
   Position (durch Anklicken des rechten unteren Pfadteils) und Größe (durch
   Anklicken des oberen Teils) des Animationspfades ändern. Dies eignet sich
   besonders zur Erzeugung von Animationspfaden, die aus dem sichtbaren Bereich
   hinauslaufen, da sich diese nicht von Hand zeichnen lassen. Mit <m> läßt
   sich jederzeit die Lupe an- oder ausschalten, und mit <Esc> wird der Modus
   "Position und Größe" verlassen.

 - Zeichen: In diesem Zeichenauswahl-Dialogfenster werden der gewünschte
   Font, das Zeichen, dessen Anfangsgröße, die Griffpunktposition "Basis
   Links", "Basis Mitte", "Mitte" und der Grad der Kantenglättung "Keine",
   "Gering", "Mittel", "Hoch") eingestellt. Hinweis: Um einen anderen Fontpfad
   als "FONTS:" zu wählen, muß zuvor das Makro "Vektorfont-Pfadauswahl"
   ausgeführt werden.

 - Zeichen drehen: In diesem Dialogfenster werden die Anzahl der Umdrehungen
   ("Umdrehungen"), der Startwinkel ("Startwinkel"), der Zielwinkel
   ("Zielwinkel") und der Drehsinn ("Drehsinn "Rechts herum/Links herum"
   festgelegt; durch die Angabe eines Wertes > 1 lassen sich zusätzliche volle
   Umdrehungen erzeugen.

 - Zeichen kippen: In diesem Dialogfenster werden die Anzahl der
   Kippdurchläufe ("Durchläufe") und der Anfangs- und Endwinkel des
   Kippvorgangs ("Von Winkel", "Bis Winkel") festgelegt; durch die Angabe eines
   Kipp-Wertes > 1 pendeln die Kippwerte zwischen den angegebenen Grenzwerten
   hin und her. Hinweis: Um den Kipp-Endwert beim letzten Einzelbild zu
   erreichen, muß eine gerade Anzahl von Durchläufen angegeben werden.

 - Zeichendicke: In diesem Dialogfenster werden die Anzahl der Durchläufe,
   der Start- und Endwert für die horizontale Zeichendicke ("Von Horizontal"
   und "Bis Horizontal") und der Start- und Endwert für die vertikale
   Zeichendicke ("Von Vertikal") und ("Bis Vertikal") festgelegt. Wenn mehr als
   ein Durchlauf festgelegt wird, pendeln die Dickewerte zwischen den beiden
   Grenzwerten hin und her. Hinweis: Um den Dicke-Endwert beim letzten
   Einzelbild zu erreichen, muß eine gerade Anzahl von Durchläufen angegeben
   werden.

 - Zeichengröße: Dieses Dialogfenster dient zum Einstellen der
   Änderungsdurchläufe für die Zeichengröße ("Durchläufe"), der Start- und
   Zielgröße ("Von" und "Bis" in Prozent der ursprünglichen Größe); wenn mehr
   als ein Durchlauf festgelegt wird, pendelt der Wert für für die
   Größenänderung zwischen den angegebenen Grenzwerten hin und her. Hinweis: Um
   den Endwert beim letzten Einzelbild zu erreichen, muß eine gerade Anzahl von
   Durchläufen angegeben werden.

 - Im Daten-Dialogfenster werden alle Pfadinformationen auf einen Blick
   dargestellt: Animation, Zeichen, Umdrehung, Kippwerte, Dicke,
   Größeneinstellungen und Pfadkoordinaten.

 - Vorschau: Mit diesem Befehl läßt sich eine Vorschau der Animation
   betrachten. Im Vorschaumodus wird keine Kantenglättung angewendet.

 - Das Haupt-Dialogfenster enthält daneben auch Funktionen zum Festlegen der
   Einzelbilder einer Animation ("Zähler"), der Aufzeichnungsrichtung
   ("Richtung": "Vorwärts/Rückwärts/Stillstand" - die Schrittweite) und zum
   Einfügen von Einzelbildern ("Bilder add." - wenn aktiviert, werden unter
   "Zähler" Bilder hinzugefügt).

 Bei der Verwendung eines frei festgelegten Pfades ohne einen Pinseleffekt
 sollte der "Zähler"-Wert die Anzahl der Knotenpunkte des Pfades (wie im
 Daten-Dialogfenster angezeigt) nicht überschreiten, da dies zur Duplizierung
 eines oder mehrerer Einzelbilder führen würde.

 Die unteren Funktionselemente im Haupt-Dialogfenster dienen zum Erzeugen der
 Animation ("Zeichnen", dient auch zum Abbrechen des Skripts) und zum Beenden
 des Skripts ("Verlassen"). Es wird immer eine temporäre Kopie des aktuellen
 Pfades gespeichert, die bei einem erneuten Start des aktuellen Skripts
 geladen wird.

*/

/** ITA
 Si può usare questo script per creare facilmente animazioni con caratteri
 che si muovono e trasformano (font vettoriali).

 La finestra di dialogo principale mette a disposizione i seguenti comandi:

 - Nuovo: il percorso è cancellato e le impostazioni del carattere
   sono riportate ai loro valori predefiniti.

 - Leggere: si può scegliere un file di percorso già esistente tramite la
   finestra di scelta file; ciò comporta il caricamento delle coordinate del
   percorso, delle impostazioni di trasformazione del pennello e di quelle
   relative all'animazione (nota: tali dati sono immagazzinati in formato
   ASCII e possono essere facilmente generati tramite algoritmi nonché
   manipolati da altri programmi).

 - Scrivere: Questo comando salva un file di percorso usando i dato del percorso
   corrente.

 - Definire a mano libera: si può usare il mouse per "tracciare" il percorso;
   l'animazione risultante è influenzata sia dalla direzione del percorso sia
   dalla velocità di spostamento del mouse: la direzione originale è usata
   per disegnare i fotogrammi (il punto di partenza è utilizzato per piazzare
   l'oggetto nel primo fotogramma e l'ultimo punto è usato per il fotogramma
   finale) mentre la velocità del tracciamento influenza il numero e la
   "densità" dei punti memorizzati (tanto è più lenta la velocità, tanto
   maggiore il numero dei punti, e viceversa) e definisce la velocità
   percepita dell'animazione (es. un percorso definito con una alta velocità
   iniziale ed una bassa velocità finale porta ad una animazione con
   caratteristiche corrispondenti). Per facilitare il posizionamento del
   primo fotogramma, prima che sia premuto il pulsante del mouse viene
   visualizzato il carattere. Il pulsante del mouse va rilasciato solo a
   percorso completato.

 - Definire lineare: si può usare il mouse per definire un percorso lineare
   (che consiste semplicemente di un punto di partenza e uno d'arrivo);
   a differenza del percorso a mano libera, questo tipo di percorso produce
   una animazione a velocità costante (i punti intermedi sono generati in modo
   automatico a distanze tra loro eguali). Per definire il percorso,
   premere il pulsante sinistro del mouse all'inizio del percorso, e
   rilasciarlo alla fine.

 - Modificare: si può usare questo comando per modificare in modo
   visivo il percorso; i "punti del percorso" possono essere spostati col
   mouse per cambiare la forma del percorso e/o la densità (velocità); il
   tasto <m> attiva/disattiva l'ingrandimento, ed il tasto destro del mouse
   o il tasto <Esc> possono essere premuti per uscire dalla modalità di
   modifica percorso.

 - Spostare e ridimensionare: si può usare il mouse per ridimensionare il
   percorso dell'animazione (facendo click sulla parte inferiore destra dello
   stesso) o spostarlo in una nuova posizione (facendo click sulla parte
   superiore). Ciò è utile per creare percorsi con punti all'esterno dello
   schermo, che non si possono piazzare manualmente. Il tasto <m>
   attiva/disattiva l'ingrandimento, ed il tasto destro del mouse o il tasto
   <Esc> possono essere premuti per uscire dalla modalità di spostamento e
   ridimensionamento.

 - Carattere: si può usare la finestra di selezione caratteri per scegliere
   il font da usare (si deve lanciare la macro "VectorFontPath.pprx"
   per scegliere un percorso font diverso da "FONTS:"), il carattere,
   il suo (iniziale) corpo, la posizione della maniglia di ridimensionamento
   ("Base sinistra", "Base centro", "Centro") e il livello di smorzamento
   seghettature - o antialias ("Nessuno", "Basso", "Medio", "Alto").

 - Angolo carattere: si usa la finestra di dialogo Angolo carattere
   per impostare il numero di rotazioni del carattere ("Cicli rotazione"),
   l'angolo iniziale ("Da angolo") e finale ("Ad angolo"), e la direzione
   della rotazione ("Senso": "Orario/Antiorario"); si può usare un numero di
   rotazioni maggiore di 1 per aggiungere ulteriori avvitamenti a 360° nella
   direzione specificata.

 - Inclinazione carattere: si usa la finestra di dialogo Inclinazione carattere
   per impostare il numero di cicli di inclinazione ("Cicli inclinazione"), e
   il livello di inclinazione iniziale e finale ("Da angolo", "Ad angolo");
   se si specifica un numero di cicli di inclinazione maggiore di 1, i fattori
   di inclinazione si muoveranno avanti ed indietro entro i limiti specificati
   (si deve usare un numero dispari di cicli per raggiungere l'inclinazione
   finale nell'ultimo fotogramma).

 - Spessore carattere: si usa la finestra di dialogo Spessore carattere per
   impostare il numero di cicli di spessore, il livello iniziale e finale di
   spessore orizzontale ("Da orizzontale" e "A orizzontale"), lo spessore
   verticale iniziale e finale ("Da verticale" e "A verticale"); se si
   specifica un numero di cicli maggiore di 1, i livelli di spessore si
   muoveranno avanti ed indietro entro i limiti specificati (si deve usare un
   numero dispari di cicli per raggiungerelo spessore finale nell'ultimo
   fotogramma).

 - Dimensioni carattere: si usa la finestra di dialogo Dimensioni carattere per
   impostare il numero di cicli di ridimensionamento ("Cicli
   ridimensionamento"), e la dimensione iniziale e finale ("Da" e "A", in
   percentuale della dimensione iniziale); se si specifica un numero di cicli
   di ridimensionamento maggiore di 1, il fattore di ridimensionamento si
   muoverà avanti ed indietro entro i limiti specificati (si deve usare un
   numero dispari di cicli per raggiungere la dimensione finale nell'ultimo
   fotogramma).

 - Dati: si usa la finestra di dialogo Dati percorso per vedere tutte
   le informazioni relative al percorso con un solo colpo d'occhio
   (impostazioni per animazione, carattere, rotazione, inclinazione, spessore,
   ridimensionamento, seguite dalle coordinate del percorso).

 - Anteprima: si usa questo comando per vedere una anteprima dell'animazione
   (nella modalità di anteprima non è attivato lo smorzamento seghettature).

 La finestra principale contiene anche pulsanti per impostare il numero di
 fotogrammi dell'animazione ("Passi"), la direzione di registrazione
 ("Direzione": "Avanti/Indietro/Fermo" - il passo fotogramma) e l'opzione per
 l'inserimento di fotogrammi ("Aggiunta fotogrammi" - se è attiva, saranno
 inseriti tanti fotogrammi quanti indicato da "Passi").

 Quando si usano percorsi a mano libera senza effetti sul carattere, il numero
 specificato in "Passi" non dovrebbe essere maggiore del numero di punti del
 percorso (come riferito dalla finestra di dialogo Dati percorso), perché in
 questo modo si otterrebbero uno o più fotogrammi doppi.

 Si possono usare i pulsanti sulla parte inferiore della finestra di dialogo
 principale per realizzare l'animazione ("Animare", che inoltre fa terminare
 lo script) o per uscire dallo script ("Uscire"). Una copia del percorso
 corrente è sempre immagazzinata temporaneamente, perché sia possibile usarla
 quando si avvia nuovamente lo script.
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
        global.txt_title_menu  = 'AnimZeichen-Pfad'
        global.txt_title_new   = 'Neuer Animationspfad'
        global.txt_title_load  = 'Animationspfad laden'
        global.txt_title_save  = 'Animationspfad speichern'
        global.txt_title_fhand = 'Pfad frei festlegen'
        global.txt_title_line  = 'Pfad linear festlegen'
        global.txt_title_edit  = 'Animationspfad bearbeiten'
        global.txt_title_movrs = 'Pfadposition/Größe ändern'
        global.txt_title_char  = 'Zeichen'
        global.txt_title_crot  = 'Zeichen drehenl'
        global.txt_title_cshr  = 'Zeichen kippen'
        global.txt_title_cbold = 'Zeichendicke'
        global.txt_title_cresz = 'Zeichengröße'
        global.txt_title_pview = 'Pfadvorschau'
        global.txt_title_draw  = 'Animation zeichnen'
        global.txt_title_data  = 'Pfadinformationen'

        global.txt_menu_new    = 'Neu'
        global.txt_menu_load   = 'Laden...'
        global.txt_menu_save   = 'Speichern...'
        global.txt_menu_fhand  = 'Frei festlegen'
        global.txt_menu_line   = 'Linear festlegen'
        global.txt_menu_edit   = 'Bearbeiten'
        global.txt_menu_movrs  = 'Position/Größe'
        global.txt_menu_char   = 'Zeichen...'
        global.txt_menu_crot   = 'Zeichen drehen...'
        global.txt_menu_cshr   = 'Zeichen kippen...'
        global.txt_menu_cbold  = 'Zeichendicke...'
        global.txt_menu_cresz  = 'Zeichengröße...'
        global.txt_menu_data   = 'Informationen...'
        global.txt_menu_prview = 'Vorschau'

        global.txt_gad_count   = 'Z_ähler:'
        global.txt_gad_add     = '_Frames add.:'
        global.txt_gad_noyes.0 = 'Nein'
        global.txt_gad_noyes.1 = 'Ja'
        global.txt_gad_direct  = '_Richtung:'
        global.txt_gad_dirct.0 = 'Vorwärts'
        global.txt_gad_dirct.1 = 'Rückwärts'
        global.txt_gad_dirct.2 = 'Stillstand'
        global.txt_gad_draw    = '_Zeichnen'
        global.txt_gad_quit    = '_Verlassen'
        global.txt_gad_font    = '_Font:'
        global.txt_gad_char    = 'Zeiche_n:'
        global.txt_gad_size    = '_Größe:'
        global.txt_gad_handle  = 'G_riffpunkt:'
        global.txt_gad_aalias  = '_Kantenglättung:'
        global.txt_gad_aals.0  = 'Keine'
        global.txt_gad_aals.1  = 'Gering'
        global.txt_gad_aals.2  = 'Mittel'
        global.txt_gad_aals.3  = 'Hoch'
        global.txt_gad_handl.0 = 'Basis links'
        global.txt_gad_handl.1 = 'Basis Mitte'
        global.txt_gad_handl.2 = 'Mitte'
        global.txt_gad_rotats  = '_Umdrehungen:'
        global.txt_gad_fromang = '_Startwinkel:'
        global.txt_gad_toang   = '_Zielwinkel:'
        global.txt_gad_rotdir  = '_Richtung:'
        global.txt_gad_rotdr.0 = 'Rechts herum'
        global.txt_gad_rotdr.1 = 'Links herum'
        global.txt_gad_shears  = '_Durchläufe:'
        global.txt_gad_fromsh  = '_Von Winkel:'
        global.txt_gad_tosh    = '_Bis Winkel:'
        global.txt_gad_resizes = '_Durchläufe:'
        global.txt_gad_fromrs  = '_Von (%):'
        global.txt_gad_tors    = '_Bis (%):'
        global.txt_gad_bolds   = '_Durchläufe:'
        global.txt_gad_frombdx = '_Von Horizontal:'
        global.txt_gad_tobdx   = '_Bis Horizontal:'
        global.txt_gad_frombdy = 'V_on Vertikal:'
        global.txt_gad_tobdy   = 'B_is Vertikal:'
        global.txt_msg_points  = 'Punkte:'
        global.txt_msg_ptype.0 = '(Freier Pfad)'
        global.txt_msg_ptype.1 = '(Linearer Pfad)'

        global.txt_err_oldcl   = 'Dieses Skript erfordert eine neuere_Version von Personal Paint'
        global.txt_err_lost    = 'Pfaddaten gehen verloren'
        global.txt_err_load    = 'Pfaddatei kann nicht geöffnet werden'
        global.txt_err_nopath  = 'Keine Pfaddefinition vorhanden'
        global.txt_err_save    = 'Pfad kann nicht gespeichert werden'
        global.txt_err_notbsh  = 'Zu wenig Platz für tempörären Pinsel'
        global.txt_err_nofonts = 'Vektorschriften nicht auffindbar'
        global.txt_err_rend    = 'Fehler bei der Zeichenerzeugung'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	global.txt_title_menu  = 'Percorso AnimCharacter'
	global.txt_title_new   = 'Nuovo percorso AnimCharacter'
	global.txt_title_load  = 'Leggere percorso AnimCharacter'
	global.txt_title_save  = 'Scrivere percorso AnimCharacter'
	global.txt_title_fhand = 'Definire a mano libera'
	global.txt_title_line  = 'Definire lineare'
	global.txt_title_edit  = 'Modificare percorso AnimCharacter'
	global.txt_title_movrs = 'Spostare percorso AnimCharacter'
	global.txt_title_char  = 'Carattere'
	global.txt_title_crot  = 'Angolo carattere'
	global.txt_title_cshr  = 'Inclinazione carattere'
	global.txt_title_cbold = 'Spessore carattere'
	global.txt_title_cresz = 'Dimensione carattere'
	global.txt_title_pview = 'Anteprima animazione'
	global.txt_title_draw  = 'Creare animazione'
	global.txt_title_data  = 'Dati percorso animazione'

	global.txt_menu_new    = 'Nuovo'
	global.txt_menu_load   = 'Leggere...'
	global.txt_menu_save   = 'Scrivere...'
	global.txt_menu_fhand  = 'Definire a mano libera'
	global.txt_menu_line   = 'Definire lineare'
	global.txt_menu_edit   = 'Modificare'
	global.txt_menu_movrs  = 'Spostare e ridimensionare'
	global.txt_menu_char   = 'Carattere...'
	global.txt_menu_crot   = 'Angolo carattere...'
	global.txt_menu_cshr   = 'Inclinazione carattere...'
	global.txt_menu_cbold  = 'Spessore carattere...'
	global.txt_menu_cresz  = 'Dimensione carattere...'
	global.txt_menu_data   = 'Dati...'
	global.txt_menu_prview = 'Anteprima'

	global.txt_gad_count   = 'Pa_ssi:'
	global.txt_gad_add     = 'Aggiunta _fotogrammi:'
	global.txt_gad_noyes.0 = 'No'
	global.txt_gad_noyes.1 = 'Sì'
	global.txt_gad_direct  = 'Direzi_one:'
	global.txt_gad_dirct.0 = 'Avanti'
	global.txt_gad_dirct.1 = 'Indietro'
	global.txt_gad_dirct.2 = 'Fermo'
	global.txt_gad_draw    = '_Animare'
	global.txt_gad_quit    = '_Uscire'
	global.txt_gad_font    = '_Font:'
	global.txt_gad_char    = '_Carattere:'
	global.txt_gad_size    = '_Dimensione:'
	global.txt_gad_handle  = '_Impugnatura:'
	global.txt_gad_aalias  = 'An_tialias:'
	global.txt_gad_aals.0  = 'Nessuno'
	global.txt_gad_aals.1  = 'Basso'
	global.txt_gad_aals.2  = 'Medio'
	global.txt_gad_aals.3  = 'Alto'
	global.txt_gad_handl.0 = 'Base sinistra'
	global.txt_gad_handl.1 = 'Base centro'
	global.txt_gad_handl.2 = 'Centro'
	global.txt_gad_rotats  = 'Cicli _rotazione:'
	global.txt_gad_fromang = '_Da angolo:'
	global.txt_gad_toang   = 'Ad a_ngolo:'
	global.txt_gad_rotdir  = '_Senso:'
	global.txt_gad_rotdr.0 = 'Orario'
	global.txt_gad_rotdr.1 = 'Antiorario'
	global.txt_gad_shears  = 'Cicli _inclinazione:'
	global.txt_gad_fromsh  = '_Da angolo:'
	global.txt_gad_tosh    = 'Ad a_ngolo:'
	global.txt_gad_resizes = 'Cicli _ridimensionamento:'
	global.txt_gad_fromrs  = '_Da (%):'
	global.txt_gad_tors    = 'A (_%):'
	global.txt_gad_bolds   = 'Cicli _spessore:'
	global.txt_gad_frombdx = '_Da orizzontale:'
	global.txt_gad_tobdx   = 'A ori_zzontale:'
	global.txt_gad_frombdy = 'Da _verticale:'
	global.txt_gad_tobdy   = 'A ver_ticale:'
	global.txt_msg_points  = 'Punti:'
	global.txt_msg_ptype.0 = '(percorso a mano libera)'
	global.txt_msg_ptype.1 = '(percorso lineare)'

	global.txt_err_oldcl   = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	global.txt_err_lost    = 'Il percorso sarà cancellato'
	global.txt_err_load    = 'Il file non può essere aperto'
	global.txt_err_nopath  = 'Non è stato definito alcun percorso'
	global.txt_err_save    = 'Il percorso non può essere scritto'
	global.txt_err_notbsh  = 'Non vi è spazio per il pennello temporaneo'
	global.txt_err_nofonts = 'Non vi sono font vettoriali'
	global.txt_err_rend    = 'Errore nella creazione del carattere'
END
ELSE DO				/* English */
	global.txt_title_menu  = 'AnimCharacter Path'
	global.txt_title_new   = 'New AnimCharacter Path'
	global.txt_title_load  = 'Load AnimCharacter Path'
	global.txt_title_save  = 'Save AnimCharacter Path'
	global.txt_title_fhand = 'Define Freehand Path'
	global.txt_title_line  = 'Define Linear Path'
	global.txt_title_edit  = 'Edit AnimCharacter Path'
	global.txt_title_movrs = 'Move/Resize AnimCharacter Path'
	global.txt_title_char  = 'Character'
	global.txt_title_crot  = 'Character Angle'
	global.txt_title_cshr  = 'Character Shear'
	global.txt_title_cbold = 'Character Boldness'
	global.txt_title_cresz = 'Character Size'
	global.txt_title_pview = 'Preview Path'
	global.txt_title_draw  = 'Draw Animation'
	global.txt_title_data  = 'AnimCharacter Path Data'

	global.txt_menu_new    = 'New'
	global.txt_menu_load   = 'Load...'
	global.txt_menu_save   = 'Save...'
	global.txt_menu_fhand  = 'Define Freehand'
	global.txt_menu_line   = 'Define Linear'
	global.txt_menu_edit   = 'Edit'
	global.txt_menu_movrs  = 'Move and Resize'
	global.txt_menu_char   = 'Character...'
	global.txt_menu_crot   = 'Character Angle...'
	global.txt_menu_cshr   = 'Character Shear...'
	global.txt_menu_cbold  = 'Character Boldness...'
	global.txt_menu_cresz  = 'Character Size...'
	global.txt_menu_data   = 'Data...'
	global.txt_menu_prview = 'Preview'

	global.txt_gad_count   = 'C_ount:'
	global.txt_gad_add     = 'Add _Frames:'
	global.txt_gad_noyes.0 = 'No'
	global.txt_gad_noyes.1 = 'Yes'
	global.txt_gad_direct  = 'Directi_on:'
	global.txt_gad_dirct.0 = 'Forward'
	global.txt_gad_dirct.1 = 'Backward'
	global.txt_gad_dirct.2 = 'Still'
	global.txt_gad_draw    = '_Draw'
	global.txt_gad_quit    = '_Quit'
	global.txt_gad_font    = '_Font:'
	global.txt_gad_char    = 'Ch_aracter:'
	global.txt_gad_size    = '_Size:'
	global.txt_gad_handle  = '_Handle:'
	global.txt_gad_aalias  = 'An_tialias:'
	global.txt_gad_aals.0  = 'None'
	global.txt_gad_aals.1  = 'Low'
	global.txt_gad_aals.2  = 'Medium'
	global.txt_gad_aals.3  = 'High'
	global.txt_gad_handl.0 = 'Base Left'
	global.txt_gad_handl.1 = 'Base Center'
	global.txt_gad_handl.2 = 'Center'
	global.txt_gad_rotats  = '_Rotation Cycles:'
	global.txt_gad_fromang = '_From Angle:'
	global.txt_gad_toang   = '_To Angle:'
	global.txt_gad_rotdir  = '_Direction:'
	global.txt_gad_rotdr.0 = 'Clockwise'
	global.txt_gad_rotdr.1 = 'Counterclockwise'
	global.txt_gad_shears  = '_Shear Cycles:'
	global.txt_gad_fromsh  = '_From Angle:'
	global.txt_gad_tosh    = '_To Angle:'
	global.txt_gad_resizes = 'Re_size Cycles:'
	global.txt_gad_fromrs  = '_From (%):'
	global.txt_gad_tors    = '_To (%):'
	global.txt_gad_bolds   = '_Boldness Cycles:'
	global.txt_gad_frombdx = '_From Horizontal:'
	global.txt_gad_tobdx   = '_To Horizontal:'
	global.txt_gad_frombdy = 'F_rom Vertical:'
	global.txt_gad_tobdy   = 'T_o Vertical:'
	global.txt_msg_points  = 'Points:'
	global.txt_msg_ptype.0 = '(freehand path)'
	global.txt_msg_ptype.1 = '(linear path)'

	global.txt_err_oldcl   = 'This script requires a newer_version of Personal Paint'
	global.txt_err_lost    = 'The path will be lost'
	global.txt_err_load    = 'The path file cannot be opened'
	global.txt_err_nopath  = 'No path has been defined'
	global.txt_err_save    = 'The path cannot be saved'
	global.txt_err_notbsh  = 'No space for temporary brush'
	global.txt_err_nofonts = 'Vector fonts not found'
	global.txt_err_rend    = 'Character rendering error'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'global.txt_err_oldcl'"'
	EXIT 10
END

tmpname = 'T:PP_AnimCharPath'

global.fontnum = 0
global.pathdisp = 1

CALL DefData

LockGUI

GetPaintMode
global.savepmode = RESULT

GetBrushAttributes 'WIDTH'
global.bshw = RESULT
GetBrushAttributes 'HEIGHT'
global.bshh = RESULT
GetBrushAttributes 'HANDLEX'
global.bshhx = RESULT
GetBrushAttributes 'HANDLEY'
global.bshhy = RESULT

GetBrushAttributes 'FRAMES'
global.savebshfr = RESULT
GetBrushAttributes 'FRAMEPOSITION'
global.savebshfp = RESULT
GetBrushNumber
global.savebshnum = RESULT
GetCurrentBrush
global.savebsh = RESULT

SetCurrentBrush 'UNUSED'
IF RC ~= 0 THEN DO
	RequestNotify 'TITLE "'global.txt_title_menu'" PROMPT "'global.txt_err_notbsh'"'
	UnlockGUI
	EXIT 0
END
GetBrushNumber
global.tbshnum = RESULT

SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'

GetPen 'FOREGROUND'
global.savepen = RESULT
Get 'COLORS'
global.xorpen = RESULT-1
SetPen 'FOREGROUND' global.xorpen

Get 'BARS'
savebars = RESULT
Set '"BARS=0"'

Get 'GCLIP'
saveclip = RESULT
Set '"GCLIP=0"'

Get 'COORD'
savecoord = RESULT
Set '"COORD=0"'

DisableTools
UnlockGUI

SIGNAL ON Break_C

/* load last used path and display it */
CALL LoadPathFile(tmpname)
CALL XorPath

Get 'SCREENH'
IF RESULT < 225 THEN
	mrows = 11
ELSE
	mrows = 14

command = 0
DO FOREVER
	Request '"'global.txt_title_menu'" COMPACT ',
	        '"LIST ACTION = , 14, 'command', 20, 'mrows', ',
	        ' ""'global.txt_menu_new'"", ',
	        ' ""'global.txt_menu_load'"", ',
	        ' ""'global.txt_menu_save'"", ',
	        ' ""'global.txt_menu_fhand'"", ',
	        ' ""'global.txt_menu_line'"", ',
	        ' ""'global.txt_menu_edit'"", ',
	        ' ""'global.txt_menu_movrs'"", ',
	        ' ""'global.txt_menu_char'"", ',
	        ' ""'global.txt_menu_crot'"", ',
	        ' ""'global.txt_menu_cshr'"", ',
	        ' ""'global.txt_menu_cbold'"", ',
	        ' ""'global.txt_menu_cresz'"", ',
	        ' ""'global.txt_menu_data'"", ',
	        ' ""'global.txt_menu_prview'"" ',
	        ' VSPACE = 4 ',
	        ' INTSTR = ""'global.txt_gad_count'"", 1, 32000, 'global.count' ',
	        ' VSPACE = 2 ',
	        ' CYCLE = ""'global.txt_gad_direct'"", 3, 'global.direct', ""'global.txt_gad_dirct.0'"", ""'global.txt_gad_dirct.1'"", ""'global.txt_gad_dirct.2'"" ' ||,
	        ' VSPACE = 2 ',
	        ' CHECK = ""'global.txt_gad_add'"", 'global.add' ' ||,
	        ' VSPACE = 2 ',
	        ' ACTION = ""'global.txt_gad_draw'"" ',
	        ' ACTION = ""'global.txt_gad_quit'"" "'
	IF RC = 0 THEN DO
		command = RESULT.1
		global.count = RESULT.2
		global.direct = RESULT.3
		global.add = RESULT.4

		IF RESULT = 1 THEN DO	/* Draw */
			IF DrawIt() THEN
				LEAVE
		END
		ELSE IF RESULT = 2 THEN	/* Quit */
			LEAVE
		ELSE DO 	/* Command List */
			IF      command = 0 THEN CALL NewPath
			ELSE IF command = 1 THEN CALL LoadPath
			ELSE IF command = 2 THEN CALL SavePath
			ELSE IF command = 3 THEN CALL DefFreehand
			ELSE IF command = 4 THEN CALL DefLinear
			ELSE IF command = 5 THEN CALL EditPath
			ELSE IF command = 6 THEN CALL MoveResizePath
			ELSE IF command = 7 THEN CALL CharSettings
			ELSE IF command = 8 THEN CALL RotSettings
			ELSE IF command = 9 THEN CALL ShearSettings
			ELSE IF command = 10 THEN CALL BoldSettings
			ELSE IF command = 11 THEN CALL ResizeSettings
			ELSE IF command = 12 THEN CALL DisplayData
			ELSE IF command = 13 THEN CALL PreviewPath
		END
	END
END

CALL SavePathFile(tmpname)
CALL Break_C

EXIT 0





DefData: PROCEDURE EXPOSE global.

	global.count  = 10
	global.direct = 0
	global.add    = 1

	global.fontpath = 'FONTS:'
	global.font     = 'CGTimes'
	global.char     = 'A'
	global.size     = '45'
	global.handle   = 1
	global.aalias   = 0

	global.rotats  = 1
	global.fromang = 0 * 10000
	global.toang   = 0 * 10000
	global.rotdir  = 0

	global.shears  = 1
	global.fromsh  = 0 * 10000
	global.tosh    = 0 * 10000

	global.resizes = 1
	global.fromrs  = 100 * 10000
	global.tors    = 100 * 10000

	global.bolds   = 1
	global.frombdx = 0 * 10000
	global.tobdx   = 0 * 10000
	global.frombdy = 0 * 10000
	global.tobdy   = 0 * 10000

	global.points = 0
	DROP global.xcoord. global.ycoord.

	RETURN




NewPath: PROCEDURE EXPOSE global.

	RequestResponse 'TITLE "'global.txt_title_new'" PROMPT "'global.txt_err_lost'"'
	IF RC = 0 THEN DO
		IF global.points > 0 THEN
			CALL XorPath

		CALL DefData
	END

	RETURN




LoadPathFile: PROCEDURE EXPOSE global.

	ok = 0
	IF OPEN('pfile', ARG(1), 'R') THEN DO
		LockGUI
		IF READLN('pfile') = 'PPAINT CPATH' THEN DO
			IF READLN('pfile') = '1' THEN DO
				global.count  = READLN('pfile')
				global.direct = READLN('pfile')
				global.add    = READLN('pfile')

				global.fontpath = READLN('pfile')
				global.font     = READLN('pfile')
				global.char     = READLN('pfile')
				global.size     = READLN('pfile')
				global.handle   = READLN('pfile')
				global.aalias   = READLN('pfile')

				global.rotats  = READLN('pfile')
				global.fromang = READLN('pfile')
				global.toang   = READLN('pfile')
				global.rotdir  = READLN('pfile')

				global.shears  = READLN('pfile')
				global.fromsh  = READLN('pfile')
				global.tosh    = READLN('pfile')

				global.resizes = READLN('pfile')
				global.fromrs  = READLN('pfile')
				global.tors    = READLN('pfile')

				global.bolds   = READLN('pfile')
				global.frombdx = READLN('pfile')
				global.tobdx   = READLN('pfile')
				global.frombdy = READLN('pfile')
				global.tobdy   = READLN('pfile')

				global.points = READLN('pfile')

				DO point = 0 FOR global.points
					xy = READLN('pfile')
					PARSE VAR xy global.xcoord.point global.ycoord.point .
				END
				ok = 1
			END
		END
		CALL CLOSE('pfile')
		UnlockGUI
	END

	RETURN ok




LoadPath: PROCEDURE EXPOSE global.

	RequestFile 'TITLE "'global.txt_title_load'"'
	IF RC = 0 THEN DO
		PARSE VALUE RESULT WITH '"' pfilename '"'

		IF global.points > 0 THEN DO
			CALL XorPath
			CALL DefData
		END

		IF LoadPathFile(pfilename) THEN
			CALL XorPath
		ELSE DO
			CALL DefData
			RequestNotify 'TITLE "'global.txt_title_load'" PROMPT "'global.txt_err_load'"'
		END
	END

	RETURN




SavePathFile: PROCEDURE EXPOSE global.

	ok = 0
	IF OPEN('pfile', ARG(1), 'W') THEN DO
		LockGUI
		CALL WRITELN('pfile', 'PPAINT CPATH')
		CALL WRITELN('pfile', '1')		/* version */

		CALL WRITELN('pfile', global.count)
		CALL WRITELN('pfile', global.direct)
		CALL WRITELN('pfile', global.add)

		CALL WRITELN('pfile', global.fontpath)
		CALL WRITELN('pfile', global.font)
      CALL WRITELN('pfile', global.char)
		CALL WRITELN('pfile', global.size)
		CALL WRITELN('pfile', global.handle)
		CALL WRITELN('pfile', global.aalias)

		CALL WRITELN('pfile', global.rotats)
		CALL WRITELN('pfile', global.fromang)
		CALL WRITELN('pfile', global.toang)
		CALL WRITELN('pfile', global.rotdir)

		CALL WRITELN('pfile', global.shears)
		CALL WRITELN('pfile', global.fromsh)
		CALL WRITELN('pfile', global.tosh)

		CALL WRITELN('pfile', global.resizes)
		CALL WRITELN('pfile', global.fromrs)
		CALL WRITELN('pfile', global.tors)

		CALL WRITELN('pfile', global.bolds)
		CALL WRITELN('pfile', global.frombdx)
		CALL WRITELN('pfile', global.tobdx)
		CALL WRITELN('pfile', global.frombdy)
		CALL WRITELN('pfile', global.tobdy)

		CALL WRITELN('pfile', global.points)

		DO point = 0 FOR global.points
			CALL WRITELN('pfile', global.xcoord.point' 'global.ycoord.point)
		END
		ok = 1
		CALL CLOSE('pfile')
		UnlockGUI
	END

	RETURN ok




SavePath: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_save'" PROMPT "'global.txt_err_nopath'"'
		RETURN
	END

	RequestFile 'TITLE "'global.txt_title_save'" SAVEMODE'
	IF RC = 0 THEN DO
		PARSE VALUE RESULT WITH '"' pfilename '"'
		IF ~SavePathFile(pfilename) THEN
			RequestNotify 'TITLE "'global.txt_title_save'" PROMPT "'global.txt_err_save'"'
	END

	RETURN




XorVertex: PROCEDURE EXPOSE global.

	point = ARG(1)

	IF point > 0 THEN DO
		IF point = 1 THEN
			nfp = ''
		ELSE
			nfp = 'NOFIRSTPIXEL'
		ppt = point - 1
		DrawLine global.xcoord.ppt global.ycoord.ppt global.xcoord.point global.ycoord.point 'COMPLEMENT' nfp
	END
	npt = point + 1
	IF npt < global.points THEN DO
		IF point = 0 THEN
			nfp = ''
		ELSE
			nfp = 'NOFIRSTPIXEL'
		DrawLine global.xcoord.point global.ycoord.point global.xcoord.npt global.ycoord.npt 'COMPLEMENT' nfp
	END

	RETURN




EditPath: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_edit'" PROMPT "'global.txt_err_nopath'"'
		RETURN
	END

	SetPointer 'DATA ',
		'"0xC000,0x7000,0x3C00,0x3F00,0x1F00,0x1E00,0x0B00,0x0980,',
		' 0x0080,0x0000,0x0018,0x003C,0x0018,',
		' 0x4000,0xB000,0x4C00,0x4300,0x2000,0x2200,0x1500,0x1280,',
		' 0x0100,0x0000,0x0028,0x0044,0x0028" ',
		'HEIGHT 13 OFFSETX -1 OFFSETY 0'

	DO FOREVER
		WaitForClick 'DOWN POINT SHOWBRUSH'
		IF RC = 0 THEN DO
			PARSE VAR RESULT button xp yp .

			IF button > 1 THEN
				LEAVE
			mindist = 30000
			DO point = 0 FOR global.points
				GetDistance xp yp global.xcoord.point global.ycoord.point 'IMAGERATIO'
				IF RESULT < mindist THEN DO
					mindist = RESULT
					mindpt = point
				END
			END
			point = mindpt
			prev_xp = xp
			prev_yp = yp
			drawn = 0

			DO FOREVER
				GetMousePosition
				PARSE VAR RESULT xp yp .

				IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
					CALL XorVertex(point)
					global.xcoord.point = xp
					global.ycoord.point = yp
					CALL XorVertex(point)

					prev_xp = xp
					prev_yp = yp
					drawn = 1
				END
				ELSE WaitForEvent

				GetMouseButton
				IF RESULT = 0 THEN
					LEAVE
			END
		END
		ELSE LEAVE
	END
	SetPointer
	RETURN




MoveResizePath: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_movrs'" PROMPT "'global.txt_err_nopath'"'
		RETURN
	END

	SetPointer 'DATA ',
		'"0xC000,0x7000,0x3C00,0x3F00,0x1FC0,0x1FC0,0x0F00,0x0D80,',
		' 0x04C0,0x0460,0x0020,',
		' 0x4000,0xB000,0x4C00,0x4300,0x20C0,0x2000,0x1100,0x1280,',
		' 0x0940,0x08A0,0x0040" ',
		'HEIGHT 11 OFFSETX -1 OFFSETY 0'
	minx = 32000
	miny = 32000
	maxx = -32000
	maxy = -32000
	DO point = 0 FOR global.points
		IF global.xcoord.point < minx THEN minx = global.xcoord.point
		IF global.xcoord.point > maxx THEN maxx = global.xcoord.point
		IF global.ycoord.point < miny THEN miny = global.ycoord.point
		IF global.ycoord.point > maxy THEN maxy = global.ycoord.point

		origxc.point = global.xcoord.point
		origyc.point = global.ycoord.point
	END
	w1 = maxx - minx
	h1 = maxy - miny
	minx00 = minx
	miny00 = miny
	w100 = w1
	h100 = h1

	DO FOREVER
		WaitForClick 'DOWN POINT'
		IF RC = 0 THEN DO
			PARSE VAR RESULT button xp yp .

			IF button > 1 THEN
				LEAVE
			resize = (xp > minx+w1/2 & yp > miny+h1/2)
			IF resize THEN DO
				SetPointer 'DATA ',
					'"0xC000,0x7000,0x3C00,0x3F00,0x1F00,0x1E00,0x0B00,0x0980,',
					' 0x00E0,0x00A0,0x00FE,0x0022,0x0022,0x0022,0x003E,',
					' 0x4000,0xB000,0x4C00,0x4300,0x2000,0x2200,0x1500,0x1280,',
					' 0x0100,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000" ',
					'HEIGHT 15 OFFSETX -1 OFFSETY 0'
				w10 = w1
				h10 = h1
			END
			ELSE DO
				minx0 = minx
				miny0 = miny
			END
			CALL XorPath
			DrawRectangle minx miny maxx maxy 'COMPLEMENT'
			prev_xp = xp
			prev_yp = yp

			DO FOREVER
				GetMousePosition
				PARSE VAR RESULT xp yp .

				IF xp ~= prev_xp | yp ~= prev_yp THEN DO
					DrawRectangle minx miny maxx maxy 'COMPLEMENT'
					IF resize THEN DO
						w1 = w1 + (xp - prev_xp)
						h1 = h1 + (yp - prev_yp)
						IF w1 < 1 THEN w1 = 1
						IF h1 < 1 THEN h1 = 1
						maxx = minx + w1
						maxy = miny + h1
					END
					ELSE DO
						minx = minx + (xp - prev_xp)
						miny = miny + (yp - prev_yp)
						maxx = minx + w1
						maxy = miny + h1
					END
					DrawRectangle minx miny maxx maxy 'COMPLEMENT'
					prev_xp = xp
					prev_yp = yp
				END
				ELSE WaitForEvent

				GetMouseButton
				IF RESULT = 0 THEN
					LEAVE
			END

			DrawRectangle minx miny maxx maxy 'COMPLEMENT'
			IF resize THEN DO
				IF w10 ~= w1 | h10 ~= h1 THEN DO
					mx = w1 / w100
					my = h1 / h100
					DO point = 0 FOR global.points
						global.xcoord.point = minx + TRUNC((origxc.point - minx00) * mx)
						global.ycoord.point = miny + TRUNC((origyc.point - miny00) * my)
					END
				END
				SetPointer 'DATA ',
					'"0xC000,0x7000,0x3C00,0x3F00,0x1FC0,0x1FC0,0x0F00,0x0D80,',
					' 0x04C0,0x0460,0x0020,',
					' 0x4000,0xB000,0x4C00,0x4300,0x20C0,0x2000,0x1100,0x1280,',
					' 0x0940,0x08A0,0x0040" ',
					'HEIGHT 11 OFFSETX -1 OFFSETY 0'
			END
			ELSE DO
				IF minx ~= minx0 | miny ~= miny0 THEN DO
					dx = minx - minx0
					dy = miny - miny0
					DO point = 0 FOR global.points
						global.xcoord.point = global.xcoord.point + dx
						global.ycoord.point = global.ycoord.point + dy
					END
				END
			END
			CALL XorPath
		END
		ELSE LEAVE
	END
	SetPointer

	RETURN




SetFirstChar: PROCEDURE EXPOSE global.

	SetCurrentBrush 'BRUSH' global.tbshnum
	IF RC ~= 0 THEN
		RETURN

	global.rot_ang = global.fromang
	global.shear = global.fromsh
	global.bold_x = global.frombdx
	global.bold_y = global.frombdy
	global.resize = global.fromrs
	IF CreateCharacter(0) THEN DO
		SetPaintMode 'COLOR'
		SetPen 'FOREGROUND' global.savepen
		RETURN 1
	END

	RETURN 0




DefFreehand: PROCEDURE EXPOSE global.

	LockGUI
	IF global.points > 0 THEN DO
		CALL XorPath
		DROP global.xcoord. global.ycoord.
		global.points = 0
	END

	IF ~SetFirstChar() THEN DO
		RequestNotify 'TITLE "'global.txt_title_fhand'" PROMPT "'global.txt_err_rend'"'
		UnlockGUI
		RETURN
	END
	UnlockGUI

	button = 0
	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN
		PARSE VAR RESULT button x0 y0 .

	FreeBrush 'FORCE QUIET'
	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen

	IF button > 0 THEN DO
		prev_xp = x0
		prev_yp = y0
		global.xcoord.0 = x0
		global.ycoord.0 = y0
		point = 1

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp THEN DO
				IF point = 1 THEN
					nfp = ''
				ELSE
					nfp = 'NOFIRSTPIXEL'
				DrawLine prev_xp prev_yp xp yp 'COMPLEMENT' nfp

				global.xcoord.point = xp
				global.ycoord.point = yp
				point = point + 1

				prev_xp = xp
				prev_yp = yp
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END
		IF point = 1 THEN DO
			point = 2
			global.xcoord.1 = global.xcoord.0
			global.ycoord.1 = global.ycoord.0
		END
		global.points = point
	END

	RETURN




DefLinear: PROCEDURE EXPOSE global.

	LockGUI
	IF global.points > 0 THEN DO
		CALL XorPath
		DROP global.xcoord. global.ycoord.
		global.points = 0
	END

	IF ~SetFirstChar() THEN DO
		RequestNotify 'TITLE "'global.txt_title_fhand'" PROMPT "'global.txt_err_rend'"'
		UnlockGUI
		RETURN
	END
	UnlockGUI

	button = 0
	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN
		PARSE VAR RESULT button x0 y0 .

	FreeBrush 'FORCE QUIET'
	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen

	IF button > 0 THEN DO
		prev_xp = x0
		prev_yp = y0
		global.xcoord.0 = x0
		global.ycoord.0 = y0
		drawn = 0

		DO FOREVER
			GetMousePosition
			PARSE VAR RESULT xp yp .

			IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
				IF drawn THEN
					Undo
				DrawLine x0 y0 xp yp 'COMPLEMENT'

				global.xcoord.1 = xp
				global.ycoord.1 = yp
				prev_xp = xp
				prev_yp = yp
				drawn = 1
			END
			ELSE WaitForEvent

			GetMouseButton
			IF RESULT ~= button THEN
				LEAVE
		END
		global.points = 2
	END

	RETURN




InitStep: PROCEDURE EXPOSE global.

	IF global.points = 2 THEN DO
		IF global.count > 1 THEN DO
			global.line_xs = (global.xcoord.1 - global.xcoord.0) / (global.count - 1)
			global.line_ys = (global.ycoord.1 - global.ycoord.0) / (global.count - 1)
		END
		ELSE DO
			global.line_xs = 0
			global.line_ys = 0
		END
		global.line_xp = global.xcoord.0
		global.line_yp = global.ycoord.0
	END
	ELSE DO
		global.point_s = global.points / global.count
		global.point_p = 0
	END

	IF global.fromang ~= global.toang | global.rotats > 1 THEN DO
		global.do_rot = 1
		IF global.fromang > global.toang & global.rotdir = 0 THEN
			rotdeg = (3600000 - global.fromang) + global.toang
		ELSE IF global.fromang < global.toang & global.rotdir = 1 THEN
			rotdeg = global.fromang + (3600000 - global.toang)
		ELSE
			rotdeg = ABS(global.toang - global.fromang)

		rotdeg = rotdeg + ((global.rotats - 1) * 3600000)
		IF global.count > 1 THEN
			global.rot_step =	rotdeg / (global.count - 1)
		ELSE
			global.rot_step =	0
		IF global.rotdir > 0 THEN
			global.rot_step = -global.rot_step
	END
	ELSE
		global.do_rot = 0
	global.rot_ang = global.fromang

	IF global.fromsh ~= global.tosh | global.shears > 1 THEN DO
		global.do_shear = 1
		shr_deg = ABS(global.tosh - global.fromsh)
		IF global.count > 1 THEN
			global.shear_s = (shr_deg * global.shears) / (global.count - 1)
		ELSE
			global.shear_s =	0
		IF global.tosh < global.fromsh THEN
			global.shear_s = -global.shear_s
		global.min_sh = MIN(global.fromsh, global.tosh)
		global.max_sh = MAX(global.fromsh, global.tosh)
	END
	ELSE
		global.do_shear = 0
	global.shear = global.fromsh

	IF global.frombdx ~= global.tobdx | global.frombdy ~= global.tobdy | global.bolds > 1 THEN DO
		global.do_bold = 1
		boldx = ABS(global.tobdx - global.frombdx)
		IF global.count > 1 THEN
			global.bold_sx =	(boldx * global.bolds) / (global.count - 1)
		ELSE
			global.bold_sx =	0
		IF global.tobdx < global.frombdx THEN
			global.bold_sx = -global.bold_sx
		global.min_bdx = MIN(global.frombdx, global.tobdx)
		global.max_bdx = MAX(global.frombdx, global.tobdx)

		boldy = ABS(global.tobdy - global.frombdy)
		IF global.count > 1 THEN
			global.bold_sy =	(boldy * global.bolds) / (global.count - 1)
		ELSE
			global.bold_sy =	0
		IF global.tobdy < global.frombdy THEN
			global.bold_sy = -global.bold_sy
		global.min_bdy = MIN(global.frombdy, global.tobdy)
		global.max_bdy = MAX(global.frombdy, global.tobdy)
	END
	ELSE
		global.do_bold = 0
	global.bold_x = global.frombdx
	global.bold_y = global.frombdy

	IF global.fromrs ~= global.tors | global.resizes > 1 THEN DO
		global.do_resize = 1
		resz = ABS(global.tors - global.fromrs)
		IF global.count > 1 THEN
			global.resize_s = (resz * global.resizes) / (global.count - 1)
		ELSE
			global.resize_s =	0
		IF global.tors < global.fromrs THEN
			global.resize_s = -global.resize_s
		global.min_rs = MIN(global.fromrs, global.tors)
		global.max_rs = MAX(global.fromrs, global.tors)
	END
	ELSE
		global.do_resize = 0
	global.resize = global.fromrs

	RETURN




GetStep: PROCEDURE EXPOSE global.

	IF global.points = 2 THEN DO
		xp = TRUNC(global.line_xp + 0.5)
		yp = TRUNC(global.line_yp + 0.5)
	END
	ELSE DO
		point = TRUNC(global.point_p + 0.5)
		xp = global.xcoord.point
		yp = global.ycoord.point
	END

	RETURN xp yp




CreateCharacter: PROCEDURE EXPOSE global.

	antialias = ARG(1)
	ang  = TRUNC(global.rot_ang / 10 + 0.5)
	shr  = TRUNC(global.shear / 10 + 0.5 * SIGN(global.shear))
	bldx = TRUNC(global.bold_x / 10 + 0.5 * SIGN(global.bold_x))
	bldy = TRUNC(global.bold_y / 10 + 0.5 * SIGN(global.bold_y))

	IF global.resize ~= 1000000 THEN DO
		siz = TRUNC(global.size * (global.resize / 1000000) + 0.5)
		IF siz < 1 THEN
			siz = 1
	END
	ELSE siz = global.size

	IF global.char = '"' THEN
		chr = '""'
	ELSE
		chr = global.char

	VectorCharacter 'CHARACTER "'chr'" FONTPATH "'global.fontpath'" FONTNAME "'global.font'" HEIGHT 'siz' ANGLE 'ang' SHEAR 'shr' BOLDX 'bldx' BOLDY 'bldy' ANTIALIAS 'antialias
	IF RC = 0 THEN DO
		PARSE VAR RESULT . . hx hy .

		IF global.handle = 1 THEN
			SetBrushAttributes 'HANDLEX 'hx' HANDLEY 'hy
		ELSE IF global.handle = 2 THEN DO
			GetBrushAttributes 'BOUNDARIES'
			PARSE VAR RESULT x0 y0 x1 y1 .
			SetBrushAttributes 'HANDLEX 'x0+((x1-x0+1)%2)' HANDLEY 'y0+((y1-y0+1)%2)
		END
		RETURN 1
	END

	RETURN 0




PreviewStep: PROCEDURE EXPOSE global.

	IF CreateCharacter(0) THEN DO
		SetPaintMode 'COLOR'
		Undo global.prvwundo

		IF ~global.add & global.prvwundo ~= 0 THEN DO
			IF global.direct = 0 THEN
				SetFramePosition 'NEXT'
			ELSE IF global.direct = 1 THEN
				SetFramePosition 'PREVIOUS'
		END
		PutBrush ARG(1)
		global.prvwundo = 1
		RETURN 1
	END

	RETURN 0




NextStep: PROCEDURE EXPOSE global.

	IF global.points = 2 THEN DO
		global.line_xp = global.line_xp + global.line_xs
		global.line_yp = global.line_yp + global.line_ys
	END
	ELSE
		global.point_p = global.point_p + global.point_s

	IF global.do_rot THEN
		global.rot_ang = global.rot_ang + global.rot_step

	IF global.do_shear THEN DO
		global.shear = global.shear + global.shear_s
		IF global.shear_s > 0 THEN DO
			IF global.shear > global.max_sh THEN DO
				excd = global.shear - global.max_sh
				global.shear = global.max_sh - excd
				global.shear_s = -global.shear_s
			END
		END
		ELSE DO
			IF global.shear < global.min_sh THEN DO
				excd = global.min_sh - global.shear
				global.shear = global.min_sh + excd
				global.shear_s = -global.shear_s
			END
		END
	END

	IF global.do_bold THEN DO
		global.bold_x = global.bold_x + global.bold_sx
		IF global.bold_sx > 0 THEN DO
			IF global.bold_x > global.max_bdx THEN DO
				excd = global.bold_x - global.max_bdx
				global.bold_x = global.max_bdx - excd
				global.bold_sx = -global.bold_sx
			END
		END
		ELSE DO
			IF global.bold_x < global.min_bdx THEN DO
				excd = global.min_bdx - global.bold_x
				global.bold_x = global.min_bdx + excd
				global.bold_sx = -global.bold_sx
			END
		END

		global.bold_y = global.bold_y + global.bold_sy
		IF global.bold_sy > 0 THEN DO
			IF global.bold_y > global.max_bdy THEN DO
				excd = global.bold_y - global.max_bdy
				global.bold_y = global.max_bdy - excd
				global.bold_sy = -global.bold_sy
			END
		END
		ELSE DO
			IF global.bold_y < global.min_bdy THEN DO
				excd = global.min_bdy - global.bold_y
				global.bold_y = global.min_bdy + excd
				global.bold_sy = -global.bold_sy
			END
		END
	END

	IF global.do_resize THEN DO
		global.resize = global.resize + global.resize_s
		IF global.resize_s > 0 THEN DO
			IF global.resize > global.max_rs THEN DO
				excd = global.resize - global.max_rs
				global.resize = global.max_rs - excd
				global.resize_s = -global.resize_s
			END
		END
		ELSE DO
			IF global.resize < global.min_rs THEN DO
				excd = global.min_rs - global.resize
				global.resize = global.min_rs + excd
				global.resize_s = -global.resize_s
			END
		END
	END

	RETURN




PreviewBegin: PROCEDURE EXPOSE global.

	SetCurrentBrush 'BRUSH' global.tbshnum
	SetPen 'FOREGROUND' global.savepen
	GetFramePosition
	IF RC = 0 THEN
		global.savefrpos = RESULT
	ELSE
		global.savefrpos = 0
	global.prvwundo = 0

	RETURN




PreviewEnd: PROCEDURE EXPOSE global.

	Undo global.prvwundo
	FreeBrush 'FORCE QUIET'
	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen
	IF global.savefrpos > 0 THEN
		SetFramePosition global.savefrpos

	RETURN




PreviewPath: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_pview'" PROMPT "'global.txt_err_nopath'"'
		RETURN
	END
	LockGUI
	CALL XorPath
	CALL InitStep
	CALL PreviewBegin

	DO cnt = 1 to global.count
		IF ~PreviewStep( GetStep() ) THEN DO
			RequestNotify 'TITLE "'global.txt_title_pview'" PROMPT "'global.txt_err_rend'"'
			LEAVE
		END
		Wait 'TIME 200'
		CALL NextStep()
	END
	Wait 'TIME 200'

	CALL PreviewEnd
	CALL XorPath
	UnlockGUI

	RETURN




DrawStep: PROCEDURE EXPOSE global.

	IF CreateCharacter(global.aalias) THEN DO
		pos = ARG(1)
		PARSE VAR pos px py .
		SetPaintMode 'COLOR'

		IF global.aalias > 0 THEN DO
			Process 'IMAGE BRUSHMODE X0 'px' Y0 'py' FILTER "Brush Alpha Channel (Single)" NOFS'
			IF RC ~= 0 THEN DO
				IF RC ~= 5 THEN
					RequestNotify 'PROMPT "'global.txt_err_rend'('RC')"'
				RETURN 0
			END
		END
		ELSE PutBrush px py

		global.prvwundo = 1
		RETURN 1
	END

	RETURN 0




DrawIt: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_nopath'"'
		RETURN 0
	END
	LockGUI
	CALL XorPath
	CALL InitStep
	global.pathdisp = 0
	SetCurrentBrush 'BRUSH' global.tbshnum
	SetPen 'FOREGROUND' global.savepen

	IF global.add THEN DO
		GetFramePosition
		IF RC = 0 THEN
			frpos = RESULT
		ELSE
			frpos = 0
		AddFrames global.count
		IF global.direct = 1 THEN
			SetFramePosition frpos + global.count
	END

	DO cnt = 1 to global.count
		IF ~DrawStep( GetStep() ) THEN DO
			RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_rend'"'
			LEAVE
		END
		IF global.direct = 0 THEN
			SetFramePosition 'NEXT'
		ELSE IF global.direct = 1 THEN
			SetFramePosition 'PREVIOUS'
		CALL NextStep()
	END

	FreeBrush 'FORCE QUIET'
	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen
	UnlockGUI

	RETURN 1




CharSettings: PROCEDURE EXPOSE global.

	IF global.fontnum = 0 THEN DO
		LockGUI
		global.fontpath = LoadSet('PP_VectorPath', global.fontpath, 1, 0)

		ftot = 0
		vftfname = 'ENV:PP_VectorFonts'
		IF ~OPEN(fexists, vftfname) THEN DO
			ADDRESS COMMAND 'List >'vftfname' 'global.fontpath' PAT=#?.otag NOHEAD LFORMAT="%s"'
			ADDRESS COMMAND 'Sort 'vftfname vftfname'.s'
			IF RC = 0 THEN DO
				ADDRESS COMMAND 'Delete >NIL: 'vftfname
				ADDRESS COMMAND 'Copy >NIL: 'vftfname'.s' vftfname
				ADDRESS COMMAND 'Delete >NIL: 'vftfname'.s'
			END
		END
		ELSE CALL CLOSE(fexists)

		IF OPEN('listfile', vftfname) THEN DO
			DO FOREVER
				fline = READLN('listfile')
				IF EOF('listfile') THEN BREAK
				ftot = ftot + 1
				global.fontname.ftot = LEFT(fline, LENGTH(fline) - 5)
			END
			CALL CLOSE('listfile')
		END
		UnlockGUI

		IF ftot = 0 THEN DO
			RequestNotify 'PROMPT "'global.txt_err_nofonts'"'
			RETURN
		END
		global.fontnum = ftot
	END

	selfont = 0
	DO f = 1 TO global.fontnum
		IF UPPER(global.fontname.f) = UPPER(global.font) THEN DO
			selfont = f - 1
			LEAVE
		END
	END

	req = '"LIST = ""'global.txt_gad_font'"", 'global.fontnum', 'selfont', 20, 5'
	DO f = 1 TO global.fontnum
		req = req || ', ""' || global.fontname.f || '""'
	END
	req = req ||,
	     ' VSPACE = 2 ' ||,
	      'STRING = ""'global.txt_gad_char'"", 2, ""'global.char'"" ' ||,
	      'VSPACE = 2 ' ||,
         'INTSTR = ""'global.txt_gad_size'"", 1, 32000, 'global.size' ' ||,
	      'VSPACE = 2 ' ||,
			'CYCLE = ""'global.txt_gad_handle'"", 3, 'global.handle', ""'global.txt_gad_handl.0'"", ""'global.txt_gad_handl.1'"", ""'global.txt_gad_handl.2'"" ' ||,
	      'VSPACE = 2 ' ||,
			'CYCLE = ""'global.txt_gad_aalias'"", 4, 'global.aalias', ""'global.txt_gad_aals.0'"", ""'global.txt_gad_aals.1'"", ""'global.txt_gad_aals.2'"", ""'global.txt_gad_aals.3'"" ' ||,
	      'VSPACE = 2 "'

	Request 'RESIZE COMPACT "'global.txt_title_char'" 'req
	IF RC = 0 THEN DO
		fn = RESULT.1 + 1
		global.font = global.fontname.fn
		global.char = RESULT.2
		global.size = RESULT.3
		global.handle = RESULT.4
		global.aalias = RESULT.5
	END

	RETURN




RotSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_crot'" ',
	        '"INTSTR = ""'global.txt_gad_rotats'"", 1, 32000, 'global.rotats' ',
	        ' INT10000STR = ""'global.txt_gad_fromang'"", 0, 3590000, 'global.fromang' ',
	        ' INT10000STR = ""'global.txt_gad_toang'"", 0, 3590000, 'global.toang' ',
	        ' CYCLE = ""'global.txt_gad_rotdir'"", 2, 'global.rotdir', ""'global.txt_gad_rotdr.0'"", ""'global.txt_gad_rotdr.1'"" "'
	IF RC = 0 THEN DO
		global.rotats = RESULT.1
		global.fromang = RESULT.2
		global.toang = RESULT.3
		global.rotdir = RESULT.4
	END

	RETURN




ShearSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_cshr'" ',
	        '"INTSTR = ""'global.txt_gad_shears'"", 1, 32000, 'global.shears' ',
	        ' INT10000STR = ""'global.txt_gad_fromsh'"", -450000, 450000, 'global.fromsh' ',
	        ' INT10000STR = ""'global.txt_gad_tosh'"", -450000, 450000, 'global.tosh' "'
	IF RC = 0 THEN DO
		global.shears = RESULT.1
		global.fromsh = RESULT.2
		global.tosh   = RESULT.3
	END

	RETURN




ResizeSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_cresz'" ',
	        '"INTSTR = ""'global.txt_gad_resizes'"", 1, 32000, 'global.resizes' ',
	        ' INT10000STR = ""'global.txt_gad_fromrs'"", 00100, 320000000, 'global.fromrs' ',
	        ' INT10000STR = ""'global.txt_gad_tors'"", 00100, 320000000, 'global.tors' "'
	IF RC = 0 THEN DO
		global.resizes = RESULT.1
		global.fromrs  = RESULT.2
		global.tors    = RESULT.3
	END

	RETURN




BoldSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_cbold'" ',
	        '"INTSTR = ""'global.txt_gad_bolds'"", 1, 32000, 'global.bolds' ',
	        ' INT10000STR = ""'global.txt_gad_frombdx'"", -80000, 80000, 'global.frombdx' ',
	        ' INT10000STR = ""'global.txt_gad_tobdx'"", -80000, 80000, 'global.tobdx' ',
	        ' INT10000STR = ""'global.txt_gad_frombdy'"", -80000, 80000, 'global.frombdy' ',
	        ' INT10000STR = ""'global.txt_gad_tobdy'"", -80000, 80000, 'global.tobdy' "'
	IF RC = 0 THEN DO
		global.bolds   = RESULT.1
		global.frombdx = RESULT.2
		global.tobdx   = RESULT.3
		global.frombdy = RESULT.4
		global.tobdy   = RESULT.5
	END

	RETURN




DisplayData: PROCEDURE EXPOSE global.

	direct = global.direct
	add = global.add
	rotdir = global.rotdir
	handle = global.handle
	antialias = global.aalias

	str = COMPRESS(global.txt_gad_count, '_') global.count || '0A'x ||,
	      COMPRESS(global.txt_gad_direct, '_') global.txt_gad_dirct.direct || '0A'x ||,
	      COMPRESS(global.txt_gad_add, '_') global.txt_gad_noyes.add || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_font, '_') global.font || '0A'x ||,
	      COMPRESS(global.txt_gad_char, '_') global.char || '0A'x ||,
	      COMPRESS(global.txt_gad_size, '_') global.size || '0A'x ||,
	      COMPRESS(global.txt_gad_handle, '_') global.txt_gad_handl.handle || '0A'x ||,
	      COMPRESS(global.txt_gad_aalias, '_') global.txt_gad_aals.antialias || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_rotats, '_') global.rotats || '0A'x ||,
	      COMPRESS(global.txt_gad_fromang, '_') (global.fromang / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_toang, '_') (global.toang / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_rotdir, '_') global.txt_gad_rotdr.rotdir || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_shears, '_') global.shears || '0A'x ||,
	      COMPRESS(global.txt_gad_fromsh, '_') (global.fromsh / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_tosh, '_') (global.tosh / 10000) || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_resizes, '_') global.resizes || '0A'x ||,
	      COMPRESS(global.txt_gad_fromrs, '_') (global.fromrs / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_tors, '_') (global.tors / 10000) || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_bolds, '_') global.bolds || '0A'x ||,
	      COMPRESS(global.txt_gad_frombdx, '_') global.frombdx || '0A'x ||,
	      COMPRESS(global.txt_gad_tobdx, '_') global.tobdx || '0A'x ||,
	      COMPRESS(global.txt_gad_frombdy, '_') global.frombdy || '0A'x ||,
	      COMPRESS(global.txt_gad_tobdy, '_') global.tobdy || '0A'x

	pos = 1
	DO FOREVER
		pos = INDEX(str, '"', pos)
		IF pos = 0 THEN
			BREAK
		str = INSERT('"', str, pos)
		pos = pos + 2
	END

	IF global.points > 0 THEN DO
		IF global.points = 2 THEN
			ptype = 1
		ELSE
			ptype = 0

		str = str ||,
		      '0A'x ||,
		      global.txt_msg_points global.points global.txt_msg_ptype.ptype || '0A'x ||,
		      '0A'x

		DO point = 0 FOR global.points
			str = str || global.xcoord.point','global.ycoord.point || '0A'x
		END
	END
	RequestNotify '"'global.txt_title_data'" "'str'" SCROLL'

	RETURN




XorPath: PROCEDURE EXPOSE global.

	IF global.points > 0 THEN DO
		xp = global.xcoord.0
		yp = global.ycoord.0
		last = global.points - 1

		DO point = 1 TO last
			IF point = 1 THEN
				nfp = ''
			ELSE
				nfp = 'NOFIRSTPIXEL'
			DrawLine xp yp global.xcoord.point global.ycoord.point 'COMPLEMENT' nfp

			xp = global.xcoord.point
			yp = global.ycoord.point
		END
	END

	RETURN




LoadSet: PROCEDURE

	sname = ARG(1)
	def_val = ARG(2)
	IF ARG() > 2 THEN
		global_set = ARG(3)
	ELSE
		global_set = 0
	IF ARG() > 3 THEN
		request_quote = ARG(4)
	ELSE
		request_quote = 1

	val = def_val
	IF global_set THEN
		set_fname = 'ENV:'sname
	ELSE
		set_fname = 'ENV:PP_AnimChar_'sname

	IF OPEN('settingfile', set_fname, 'R') THEN DO
		val = READCH('settingfile', 65535)
		CALL CLOSE('settingfile')
	END

	IF request_quote THEN DO
		/* encode quotes for the Request command ('"' -> '\""') */
		qpos_start = 1
		DO FOREVER
			qpos = INDEX(val, '"', qpos_start)
			IF qpos = 0 THEN BREAK
			val = INSERT('\"', val, qpos-1)
			qpos_start = qpos + 3
		END
	END

	RETURN val




Cleanup: PROCEDURE EXPOSE global.

	IF global.pathdisp THEN DO
		LockGUI
		CALL XorPath
		UnlockGUI
	END

	RETURN




Break_C:

	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen
	CALL Cleanup

	LockGUI
	SetPen 'FOREGROUND' global.savepen
	SetCurrentBrush global.savebsh
	SetPaintMode global.savepmode
	IF global.savebshfr > 1 THEN
		SetBrushAttributes 'FRAMEPOSITION' global.savebshfp
	Set '"BARS='savebars'"'
	Set '"GCLIP='saveclip'"'
	Set '"COORD='savecoord'"'
	EnableTools
	UnlockGUI

	RETURN
