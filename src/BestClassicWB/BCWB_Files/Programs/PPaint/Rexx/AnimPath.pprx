/* Personal Paint Amiga Rexx script - Copyright © 1997 Cloanto Italia srl */

/* $VER: AnimPath.pprx 1.3 */

/** ENG
 This script can be used to easily create animations with
 moving and transforming objects.

 The main requester gives access to the following commands:

 - New: the path is cleared and the brush transformations are set
   to their defaults.

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
   Before the mouse button is pressed, the brush is displayed to ease
   positioning in the first frame. All drawing must occur holding
   down the left mouse button, releasing it only at the end
   of the definition.

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

 - Brush Angle: the Brush Angle requester is used to set
   the number of brush rotations ("Rotation Cycles"), the starting
   ("From Angle") and ending angle ("To Angle"), and the
   rotation direction ("Direction": "Clockwise/Counterclockwise");
   a number of rotations greater than 1 can be used to add
   additional 360° spins in the specified direction.

 - Brush Shear: the Brush Shear requester is used to set
   the number of shear cycles ("Shear Cycles"), the starting and
   ending horizontal shear ("From Horizontal", "To Horizontal"),
   and the starting and ending vertical shear ("From Vertical",
   "To Vertical"); if a number of shear cycles greather than 1 is specified,
   the shear factors will move back and forth within the specified
   limits (an odd number of cycles must be used to reach the ending
   shear in the last frame).

 - Brush Size: the Brush Size requester is used to set
   the number of resize cycles ("Resize Cycles"), the starting and
   ending horizontal size ("From Horizontal", "To Horizontal",
   in percentage of the original size), and the starting and ending
   vertical size ("From Vertical", "To Vertical");
   if a number of resize cycles greather than 1 is specified,
   the resize factors will move back and forth within the specified
   limits (an odd number of cycles must be used to reach the ending
   size in the last frame).

 - Data: the data requester can be used to view the path data
   at a glance (animation, rotation, shear and resize settings,
   followed by the path coordinates).

 - Preview: this command can be used to preview the animation;
   when one or more brush effects are involved, the brush image
   is replaced by an outline (the inner arrow points to the top
   of the brush).

 The main requester also contains gadgets to set the animation
 frames ("Count"), the recording direction ("Direction":
 "Forward/Backward/Still" - the frame step) and the frame insertion option
 ("Add Frames" - if active, "Count" frames are inserted).

 When using freehand paths with no brush effect, the "Count"
 setting should not be set to a number greater than the path points
 (as reported by the Data requester), as this would generate one or more
 duplicate frames.

 The bottom gadgets in the main requester can be used to render
 the animation ("Draw", which also terminates the script) or to
 quit the script ("Quit"). A copy of the current path is
 always temporarily stored, so that it can be used when the script is
 run again.

 The following program settings affect the animation appearance and
 quality: the current brush (anim-brushes can be used to
 create complex animation effects), the brush handle position,
 the brush paint mode (and the foreground color, if the "Color" mode
 is active) and the "Color average resize" option.
*/

/** DEU
 Dieses Skript ermöglicht die einfache Erzeugung von Animationen, in deren
 Verlauf Objekte bewegt und verwandelt werden.

 Im Haupt-Dialogfenster erfolgt der Zugriff auf folgende Befehle:

 - Neu: Löscht den alten Pfad und setzt die Pinseltransformationen auf die
   Standardwerte zurück.

 - Laden: Mit dem Dateiauswahlfenster läßt sich eine zuvor gespeicherte
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

 - Linear festlegen: Ermöglicht die Bestimmung eines linearen Pfades, welcher
   lediglich durch Anfangs- und Endpunkt festgelegt wird. Im Gegensatz zum frei
   festgelegten Pfad wird hierdurch eine Animation erzeugt, die über ihren
   gesamten Verlauf hinweg eine konstante Geschwindigkeit beibehält, da die
   Zwischenpunkte automatisch alle im gleichen Abstand voneinander angeordnet
   werden.

 - Bearbeiten: Dient zur visuellen Bearbeitung des Pfades. Durch Verschieben
   der einzelnen Knotenpunkte des Pfades mit der Maus lassen sich Form und
   Dichte (Geschwindigkeit) ändern. Mit Hilfe der Taste <m> kann die
   Lupfenfunktion an- oder ausgeschaltet werden. Um den Bearbeitungsmodus zu
   verlassen, ist die <Esc>-Taste zu drücken.

 - Position und Größe: Hiermit lassen sich unter Verwendung der Maus Position
   (durch Anklicken des rechten unteren Pfadteils) und Größe (durch Anklicken
   des oberen Teils) des Animationspfades ändern. Dies eignet sich besonders
   zur Erzeugung von Animationspfaden, die aus dem sichtbaren Bereich
   hinauslaufen, da sich diese nicht von Hand zeichnen lassen. Mit <m> läßt
   sich jederzeit die Lupe an- oder ausschalten, und mit <Esc> wird der Modus
   "Position und Bewegung" verlassen.

 - Pinsel drehen: In diesem Dialogfenster werden die Anzahl der Umdrehungen
   ("Umdrehungen"), der Startwinkel ("Startwinkel"), der Zielwinkel
   ("Zielwinkel") und der Drehsinn ("Rechts herum/Links herum" festgelegt;
   durch die Angabe eines Wertes >1 lassen sich zusätzliche volle Umdrehungen
   erzeugen.

 - Pinsel kippen: In diesem Dialogfenster werden die Anzahl der
   Kippdurchläufe ("Durchläufe") und der Start- und Zielwinkel des Kippvorgangs
   ("Von Winkel", "Bis Winkel") festgelegt; durch die Angabe eines Kipp-Wertes
   >1 pendeln die Kippwerte zwischen den angegebenen Grenzwerten hin und her.
   Hinweis: Um den Kipp-Endwert beim letzten Einzelbild zu erreichen, muß eine
   gerade Anzahl von Durchläufen angegeben werden.

 - Pinselgröße: Dieses Dialogfenster dient zum Einstellen der
   Änderungsdurchläufe für die Pinselgröße ("Durchläufe"), der Start- und
   Zielgröße ("Von" und "Bis" in Prozent der ursprünglichen Größe); wenn mehr
   als ein Änderungsdurchlauf festgelegt wird, pendelt der
   Größenänderungsfaktor zwischen den angegebenen Grenzwerten hin und her.
   Hinweis: Um den Endwert beim letzten Einzelbild zu erreichen, muß eine
   gerade Anzahl von Durchläufen angegeben werden.

 - Im Daten-Dialogfenster werden alle Pfadinformationen auf einen Blick
   dargestellt: Animation, Zeichen, Umdrehung, Kippwerte, Größeneinstellungen
   und Pfadkoordinaten.

 - Vorschau: Mit diesem Befehl läßt sich eine Vorschau der Animation
   betrachten. Wenn ein oder mehrere Pinseleffekte eingesetzt wurden, erscheint
   der Pinsel nur als Umriß. Der darin angezeigte Pfeil zeigt zur
   Pinseloberkante.

 Das Haupt-Dialogfenster enthält daneben auch Funktionen zum Festlegen der
 Einzelbilder einer Animation ("Zähler"), der Aufzeichnungsrichtung
 ("Richtung":"Vorwärts/Rückwärts/Stillstand" - die Schrittweite) und zum
 Einfügen von Einzelbildern ("Bilder add." - wenn aktiviert, werden unter
 "Zähler" Bilder hinzugefügt).

 Bei der Verwendung eines frei festgelegten Pfades ohne einen Pinseleffekt
 sollte der "Zähler"-Wert die Anzahl der Knotenpunkte des Pfades (wie im
 Daten-Dialogfenster angezeigt) nicht überschreiten, da dies zur Duplizierung
 eines oder mehrerer Einzelbilder führen würde. Die unteren Funktionselemente
 im Haupt-Dialogfenster dienen zum Erzeugen der Animation ("Zeichnen", dient
 auch zum Abbrechen des Skripts) und zum Beenden des Skripts ("Verlassen").
 Es wird immer eine temporäre Kopie des aktuellen Pfades gespeichert, die bei
 einem erneuten Aurufen des aktuellen Skripts geladen wird.

 Folgende Programmeinstellungen beeinflussen Erscheinungsbild und Qualität
 der Animation: Der aktuelle Pinsel (zum Erzielen komplexer Animationseffekte
 lassen sich Animationspinsel verwenden),die Griffpunktposition, der
 Pinsel-Malmodus (und die Vordergrundfarbe bei aktivem "Farbe"-Modus), sowie
 die Option "Farbe mit Größe ändern".
*/

/** ITA
 Questo script permette di creare facilmente animazioni con oggetti
 che si muovono e si trasformano.

 La finestra di dialogo principale mette a disposizione i seguenti comandi:

 - Nuovo: il percorso è cancellato e le trasformazioni del pennello
   sono riportate a valori predefiniti.

 - Leggere: si può scegliere un file di percorso già esistente tramite la
   finestra di scelta file; ciò comporta il caricamento delle coordinate del
   percorso, delle impostazioni di trasformazione del pennello e di quelle
   relative all'animazione (nota: tali dati sono immagazzinati in formato
   ASCII e possono essere facilmente generati tramite algoritmi nonché
   manipolati da altri programmi).

 - Scrivere: Questo comando salva un file di percorso usando i dato del percorso
   attuale.

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
   un'animazione a velocità costante (i punti intermedi sono generati in modo
   automatico a distanze tra loro eguali). Per definire il percorso,
   premere il pulsante sinistro del mouse all'inizio del percorso, e
   rilasciarlo alla fine.

 - Modificare: si può usare questo comando per modificare in modo
   visivo il percorso; i "punti del percorso" possono essere spostati col
   mouse per cambiare la forma del percorso e/o la densità (velocità); il
   tasto <m> attiva/disattiva l'ingrandimento, e il tasto destro del mouse
   o il tasto <Esc> possono essere premuti per uscire dalla modalità di
   modifica percorso.

 - Spostare e ridimensionare: si può usare il mouse per ridimensionare il
   percorso dell'animazione (facendo click sulla parte inferiore destra dello
   stesso) o spostarlo in una nuova posizione (facendo click sulla parte
   superiore). Ciò è utile per creare percorsi con punti all'esterno dello
   schermo, che non si possono piazzare manualmente. Il tasto <m>
   attiva/disattiva l'ingrandimento, e il tasto destro del mouse o il tasto
   <Esc> possono essere premuti per uscire dalla modalità di spostamento e
   ridimensionamento.

 - Angolo pennello: si usa la finestra di dialogo Angolo pennello
   per impostare il numero di rotazioni del pennello ("Cicli rotazione"),
   l'angolo iniziale ("Da angolo") e finale ("Ad angolo"), e la direzione
   della rotazione ("Senso": "Orario/Antiorario"); si può usare un numero di
   rotazioni maggiore di 1 per aggiungere ulteriori avvitamenti a 360° nella
   direzione specificata.

 - Inclinazione pennello: si usa la finestra di dialogo Inclinazione pennello
   per impostare il numero di cicli di inclinazione ("Cicli inclinazione"), e
   il livello di inclinazione iniziale e finale ("Da angolo", "Ad angolo");
   se si specifica un numero di cicli di inclinazione maggiore di 1, i fattori
   di inclinazione si sposteranno avanti ed indietro entro i limiti specificati
   (si deve usare un numero dispari di cicli per raggiungere l'inclinazione
   finale nell'ultimo fotogramma).

 - Dimensione pennello: si usa la finestra di dialogo Dimensione pennello per
   impostare il numero di cicli di ridimensionamento ("Cicli
   ridimensionamento"), la dimensione iniziale e finale in senso orizzontale
   ("Da orizzontale" e "A orizzontale", in percentuale della dimensione
   iniziale); la dimensione iniziale e finale in senso verticale ("Da
   verticale", "A verticale"); se si specifica un numero di cicli
   di ridimensionamento maggiore di 1, il fattore di ridimensionamento si
   sposterà avanti ed indietro entro i limiti specificati (si deve usare un
   numero dispari di cicli per raggiungere la dimensione finale nell'ultimo
   fotogramma).

 - Dati: si usa la finestra di dialogo Dati percorso per vedere tutte
   le informazioni relative al percorso con un solo colpo d'occhio
   (impostazioni per animazione, rotazione, inclinazione, ridimensionamento,
   seguite dalle coordinate del percorso).

 - Anteprima: si usa questo comando per vedere una anteprima dell'animazione;
   quando sono implicati uno o più effetti relativi al pennello, l'immagine
   dello stesso è sostituita da un contorno (la freccia interna indica la
   sommità del pennello).

 La finestra principale contiene anche pulsanti per impostare il numero di
 fotogrammi dell'animazione ("Passi"), la direzione di registrazione
 ("Direzione": "Avanti/Indietro/Fermo" - il passo fotogramma) e l'opzione per
 l'inserimento di fotogrammi ("Aggiunta fotogrammi" - se è attiva, saranno
 inseriti tanti fotogrammi quanti indicato da "Passi").

 Quando si usano percorsi a mano libera senza effetti sul pennello, il numero
 specificato in "Passi" non dovrebbe essere maggiore del numero di punti del
 percorso (come riferito dalla finestra di dialogo Dati percorso), perché in
 questo modo si otterrebbero uno o più fotogrammi doppi.

 Si possono usare i pulsanti sulla parte inferiore della finestra di dialogo
 principale per realizzare l'animazione ("Animare", che inoltre fa terminare
 lo script) o per uscire dallo script ("Uscire"). Il percorso attuale viene
 temporaneamente "ricordato", perché sia possibile usarlo quando si avvia
 nuovamente lo script.

 Le seguenti impostazioni del programma influenzano l'aspetto e la qualità
 dell'animazione: pennello corrente (si possono usare anim-brush per creare
 complessi effetti di animazione), posizione della maniglia di manipolazione
 pennello, modo di disegno pennello (e colore di primo piano, se è attivo il
 modo "Colore"), opzione di "Color average resize".
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
	global.txt_title_menu  = 'AnimPinsel-Pfad'
	global.txt_title_new   = 'Neuer Animationspfad'
	global.txt_title_load  = 'Animationspfad laden'
	global.txt_title_save  = 'Animationspfad speichern'
	global.txt_title_fhand = 'Pfad frei festlegen'
	global.txt_title_line  = 'Pfad linear festlegen'
	global.txt_title_edit  = 'Animationspfad bearbeiten'
	global.txt_title_movrs = 'Pfadposition/-größe ändern'
	global.txt_title_brot  = 'Pinsel drehen'
	global.txt_title_bshr  = 'Pinsel kippen'
	global.txt_title_bresz = 'Pinselgröße'
	global.txt_title_pview = 'Animationsvorschau'
	global.txt_title_draw  = 'Animation zeichnen'
	global.txt_title_data  = 'Pfadinformationen'

	global.txt_menu_new    = 'Neu'
	global.txt_menu_load   = 'Laden...'
	global.txt_menu_save   = 'Speichern...'
	global.txt_menu_fhand  = 'Frei festlegen'
	global.txt_menu_line   = 'Linear festlegen'
	global.txt_menu_edit   = 'Bearbeiten'
	global.txt_menu_movrs  = 'Position/Größe'
	global.txt_menu_brot   = 'Pinsel drehen...'
	global.txt_menu_bshr   = 'Pinsel kippen...'
	global.txt_menu_bresz  = 'Pinselgröße...'
	global.txt_menu_data   = 'Informationen...'
	global.txt_menu_prview = 'Preview'

	global.txt_gad_count   = 'Z_ähler:'
	global.txt_gad_add     = '_Frames add.:'
	global.txt_gad_addf.0  = 'Nein'
	global.txt_gad_addf.1  = 'Ja'
	global.txt_gad_direct  = '_Richtung:'
	global.txt_gad_dirct.0 = 'Vorwärts'
	global.txt_gad_dirct.1 = 'Rückwärts'
	global.txt_gad_dirct.2 = 'Stillstand'
	global.txt_gad_draw    = '_Zeichnen'
	global.txt_gad_quit    = '_Verlassen'
	global.txt_gad_rotats  = '_Umdrehungen:'
	global.txt_gad_fromang = '_Startwinkel:'
	global.txt_gad_toang   = '_Zielwinkel:'
	global.txt_gad_rotdir  = '_Richtung:'
	global.txt_gad_rotdr.0 = 'Rechts herum'
	global.txt_gad_rotdr.1 = 'Links herum'
	global.txt_gad_shears  = '_Durchläufe:'
	global.txt_gad_fromshx = '_Von Horizontal:'
	global.txt_gad_toshx   = '_Bis Horizontal:'
	global.txt_gad_fromshy = 'V_on Vertikal:'
	global.txt_gad_toshy   = 'B_is Vertikal:'
	global.txt_gad_resizes = '_Durchläufe:'
	global.txt_gad_fromrsx = '_Von Horizontal (%):'
	global.txt_gad_torsx   = '_Bis Horizontal (%):'
	global.txt_gad_fromrsy = 'V_on Vertikal (%):'
	global.txt_gad_torsy   = 'B_is Vertikal (%):'
	global.txt_msg_points  = 'Punkte:'
	global.txt_msg_ptype.0 = '(Freier Pfad)'
	global.txt_msg_ptype.1 = '(Linearer Pfad)'

	global.txt_err_oldcl   = 'Dieses Skript erfordert eine neuere_Version von Personal Paint'
	global.txt_err_lost    = 'Pfaddaten gehen verloren'
	global.txt_err_load    = 'Pfaddatei kann nicht geöffnet werden'
	global.txt_err_nopath  = 'Keine Pfaddefinition vorhanden'
	global.txt_err_save    = 'Pfad kann nicht gespeichert werden'
	global.txt_err_nocbsh  = 'Transformation läßt sich nur auf benutzer-_definierten Pinsel anwenden'
	global.txt_err_notbsh  = 'Transformation nicht durchfürbar: Zu wenig Platz für temporären Pinsel'
	global.txt_err_notmem  = 'Speichermangel'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	global.txt_title_menu  = 'Percorso animazione'
	global.txt_title_new   = 'Nuovo percorso animazione'
	global.txt_title_load  = 'Leggere percorso animazione'
	global.txt_title_save  = 'Scrivere percorso animazione'
	global.txt_title_fhand = 'Definire a mano libera'
	global.txt_title_line  = 'Definire lineare'
	global.txt_title_edit  = 'Modificare percorso animazione'
	global.txt_title_movrs = 'Spostare percorso animazione'
	global.txt_title_brot  = 'Angolo pennello'
	global.txt_title_bshr  = 'Inclinazione pennello'
	global.txt_title_bresz = 'Dimensione pennello'
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
	global.txt_menu_brot   = 'Angolo pennello...'
	global.txt_menu_bshr   = 'Inclinazione pennello...'
	global.txt_menu_bresz  = 'Dimensione pennello...'
	global.txt_menu_data   = 'Dati...'
	global.txt_menu_prview = 'Anteprima'

	global.txt_gad_count   = 'Pa_ssi:'
	global.txt_gad_add     = 'Aggiunta _fotogrammi:'
	global.txt_gad_addf.0  = 'No'
	global.txt_gad_addf.1  = 'Sì'
	global.txt_gad_direct  = 'Direzi_one:'
	global.txt_gad_dirct.0 = 'Avanti'
	global.txt_gad_dirct.1 = 'Indietro'
	global.txt_gad_dirct.2 = 'Fermo'
	global.txt_gad_draw    = '_Animare'
	global.txt_gad_quit    = '_Uscire'
	global.txt_gad_rotats  = 'Cicli _rotazione:'
	global.txt_gad_fromang = '_Da angolo:'
	global.txt_gad_toang   = 'Ad a_ngolo:'
	global.txt_gad_rotdir  = '_Senso:'
	global.txt_gad_rotdr.0 = 'Orario'
	global.txt_gad_rotdr.1 = 'Antiorario'
	global.txt_gad_shears  = 'Cicli _inclinazione:'
	global.txt_gad_fromshx = '_Da orizzontale:'
	global.txt_gad_toshx   = 'A ori_zzontale:'
	global.txt_gad_fromshy = 'Da _verticale:'
	global.txt_gad_toshy   = 'A ver_ticale:'
	global.txt_gad_resizes = 'Cicli _ridimensionamento:'
	global.txt_gad_fromrsx = '_Da orizzontale (%):'
	global.txt_gad_torsx   = 'A ori_zzontale (%):'
	global.txt_gad_fromrsy = 'Da _verticale (%):'
	global.txt_gad_torsy   = 'A ver_ticale (%):'
	global.txt_msg_points  = 'Punti:'
	global.txt_msg_ptype.0 = '(percorso a mano libera)'
	global.txt_msg_ptype.1 = '(percorso lineare)'

	global.txt_err_oldcl   = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	global.txt_err_lost    = 'Il percorso sarà cancellato'
	global.txt_err_load    = 'Il file non può essere aperto'
	global.txt_err_nopath  = 'Non è stato definito alcun percorso'
	global.txt_err_save    = 'Il percorso non può essere scritto'
	global.txt_err_nocbsh  = 'Le trasformazioni non possono essere applicate ai pennelli predefiniti'
	global.txt_err_notbsh  = 'Le trasformationi non possono essere applicate: non vi è spazio per il pennello temporaneo'
	global.txt_err_notmem  = 'Memoria insufficiente'
END
ELSE DO				/* English */
	global.txt_title_menu  = 'Animation Path'
	global.txt_title_new   = 'New Animation Path'
	global.txt_title_load  = 'Load Animation Path'
	global.txt_title_save  = 'Save Animation Path'
	global.txt_title_fhand = 'Define Freehand Path'
	global.txt_title_line  = 'Define Linear Path'
	global.txt_title_edit  = 'Edit Animation Path'
	global.txt_title_movrs = 'Move/Resize Animation Path'
	global.txt_title_brot  = 'Brush Angle'
	global.txt_title_bshr  = 'Brush Shear'
	global.txt_title_bresz = 'Brush Size'
	global.txt_title_pview = 'Preview Animation'
	global.txt_title_draw  = 'Draw Animation'
	global.txt_title_data  = 'Animation Path Data'

	global.txt_menu_new    = 'New'
	global.txt_menu_load   = 'Load...'
	global.txt_menu_save   = 'Save...'
	global.txt_menu_fhand  = 'Define Freehand'
	global.txt_menu_line   = 'Define Linear'
	global.txt_menu_edit   = 'Edit'
	global.txt_menu_movrs  = 'Move and Resize'
	global.txt_menu_brot   = 'Brush Angle...'
	global.txt_menu_bshr   = 'Brush Shear...'
	global.txt_menu_bresz  = 'Brush Size...'
	global.txt_menu_data   = 'Data...'
	global.txt_menu_prview = 'Preview'

	global.txt_gad_count   = 'C_ount:'
	global.txt_gad_add     = 'Add _Frames:'
	global.txt_gad_addf.0  = 'No'
	global.txt_gad_addf.1  = 'Yes'
	global.txt_gad_direct  = 'Directi_on:'
	global.txt_gad_dirct.0 = 'Forward'
	global.txt_gad_dirct.1 = 'Backward'
	global.txt_gad_dirct.2 = 'Still'
	global.txt_gad_draw    = '_Draw'
	global.txt_gad_quit    = '_Quit'
	global.txt_gad_rotats  = '_Rotation Cycles:'
	global.txt_gad_fromang = '_From Angle:'
	global.txt_gad_toang   = '_To Angle:'
	global.txt_gad_rotdir  = '_Direction:'
	global.txt_gad_rotdr.0 = 'Clockwise'
	global.txt_gad_rotdr.1 = 'Counterclockwise'
	global.txt_gad_shears  = '_Shear Cycles:'
	global.txt_gad_fromshx = '_From Horizontal:'
	global.txt_gad_toshx   = '_To Horizontal:'
	global.txt_gad_fromshy = 'F_rom Vertical:'
	global.txt_gad_toshy   = 'T_o Vertical:'
	global.txt_gad_resizes = 'Re_size Cycles:'
	global.txt_gad_fromrsx = '_From Horizontal (%):'
	global.txt_gad_torsx   = '_To Horizontal (%):'
	global.txt_gad_fromrsy = 'F_rom Vertical (%):'
	global.txt_gad_torsy   = 'T_o Vertical (%):'
	global.txt_msg_points  = 'Points:'
	global.txt_msg_ptype.0 = '(freehand path)'
	global.txt_msg_ptype.1 = '(linear path)'

	global.txt_err_oldcl   = 'This script requires a newer_version of Personal Paint'
	global.txt_err_lost    = 'The path will be lost'
	global.txt_err_load    = 'The path file cannot be opened'
	global.txt_err_nopath  = 'No path has been defined'
	global.txt_err_save    = 'The path cannot be saved'
	global.txt_err_nocbsh  = 'Transformation can only be applied to user brushes'
	global.txt_err_notbsh  = 'Transformation cannot be applied: no space for temporary brush'
	global.txt_err_notmem  = 'Not enough memory'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'global.txt_err_oldcl'"'
	EXIT 10
END

tmpname = 'T:PP_AnimPath'
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
IF RC ~= 0 THEN
	global.tbshnum = 0
ELSE DO
	GetBrushNumber
	global.tbshnum = RESULT
END

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
IF RESULT < 206 THEN
	mrows = 11
ELSE
	mrows = 12

command = 0
DO FOREVER
	Request '"'global.txt_title_menu'" COMPACT ',
	        '"LIST ACTION = , 12, 'command', 20, 'mrows', ',
	        ' ""'global.txt_menu_new'"", ',
	        ' ""'global.txt_menu_load'"", ',
	        ' ""'global.txt_menu_save'"", ',
	        ' ""'global.txt_menu_fhand'"", ',
	        ' ""'global.txt_menu_line'"", ',
	        ' ""'global.txt_menu_edit'"", ',
	        ' ""'global.txt_menu_movrs'"", ',
	        ' ""'global.txt_menu_brot'"", ',
	        ' ""'global.txt_menu_bshr'"", ',
	        ' ""'global.txt_menu_bresz'"", ',
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
			ELSE IF command = 7 THEN CALL RotSettings
			ELSE IF command = 8 THEN CALL ShearSettings
			ELSE IF command = 9 THEN CALL ResizeSettings
			ELSE IF command = 10 THEN CALL DisplayData
			ELSE IF command = 11 THEN CALL PreviewPath
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

	global.rotats  = 1
	global.fromang = 0 * 10000
	global.toang   = 0 * 10000
	global.rotdir  = 0

	global.shears  = 1
	global.fromshx = 0
	global.toshx   = 0
	global.fromshy = 0
	global.toshy   = 0

	global.resizes = 1
	global.fromrsx = 100 * 10000
	global.torsx   = 100 * 10000
	global.fromrsy = 100 * 10000
	global.torsy   = 100 * 10000

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
		IF READLN('pfile') = 'PPAINT PATH' THEN DO
			IF READLN('pfile') = '1' THEN DO
				global.count  = READLN('pfile')
				global.direct = READLN('pfile')
				global.add    = READLN('pfile')

				global.rotats  = READLN('pfile')
				global.fromang = READLN('pfile')
				global.toang   = READLN('pfile')
				global.rotdir  = READLN('pfile')

				global.shears  = READLN('pfile')
				global.fromshx = READLN('pfile')
				global.toshx   = READLN('pfile')
				global.fromshy = READLN('pfile')
				global.toshy   = READLN('pfile')

				global.resizes = READLN('pfile')
				global.fromrsx = READLN('pfile')
				global.torsx   = READLN('pfile')
				global.fromrsy = READLN('pfile')
				global.torsy   = READLN('pfile')

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
		CALL WRITELN('pfile', 'PPAINT PATH')
		CALL WRITELN('pfile', '1')		/* version */

		CALL WRITELN('pfile', global.count)
		CALL WRITELN('pfile', global.direct)
		CALL WRITELN('pfile', global.add)

		CALL WRITELN('pfile', global.rotats)
		CALL WRITELN('pfile', global.fromang)
		CALL WRITELN('pfile', global.toang)
		CALL WRITELN('pfile', global.rotdir)

		CALL WRITELN('pfile', global.shears)
		CALL WRITELN('pfile', global.fromshx)
		CALL WRITELN('pfile', global.toshx)
		CALL WRITELN('pfile', global.fromshy)
		CALL WRITELN('pfile', global.toshy)

		CALL WRITELN('pfile', global.resizes)
		CALL WRITELN('pfile', global.fromrsx)
		CALL WRITELN('pfile', global.torsx)
		CALL WRITELN('pfile', global.fromrsy)
		CALL WRITELN('pfile', global.torsy)

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




SetFirstBrush: PROCEDURE EXPOSE global.

	IF global.fromang = 0 & global.fromshx = 0 & global.fromshy = 0 & ,
 		global.fromrsx = 1000000 & global.fromrsy = 1000000 THEN
		SetCurrentBrush global.savebsh
	ELSE DO
		SetCurrentBrush 'BRUSH' global.tbshnum
		IF RC ~= 0 THEN
			RETURN
		CopyBrush global.savebshnum 'NOFRAMES'
		IF RC ~= 0 THEN
			RETURN

		IF global.fromang ~= 0 THEN DO
			RotateBrush TRUNC(global.fromang / 10 + 0.5) 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN
		END
		IF global.fromshx ~= 0 | global.fromshy ~= 0 THEN DO
			shearx = TRUNC(global.fromshx + 0.5 * SIGN(global.fromshx))
			sheary = TRUNC(global.fromshy + 0.5 * SIGN(global.fromshy))
			ShearBrush shearx sheary 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN
		END

		IF global.fromrsx ~= 1000000 | global.fromrsy ~= 1000000 THEN DO
			GetBrushAttributes 'WIDTH'
			w = TRUNC(RESULT * (global.fromrsx / 1000000) + 0.5)
			GetBrushAttributes 'HEIGHT'
			h = TRUNC(RESULT * (global.fromrsy / 1000000) + 0.5)
			IF w < 1 THEN w = 1
			IF h < 1 THEN h = 1
			SetBrushAttributes 'WIDTH' w 'HEIGHT' h 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN
		END
	END
	SetPaintMode global.savepmode
	SetPen 'FOREGROUND' global.savepen

	RETURN




DefFreehand: PROCEDURE EXPOSE global.

	IF global.points > 0 THEN DO
		CALL XorPath
		DROP global.xcoord. global.ycoord.
		global.points = 0
	END

	LockGUI
	CALL SetFirstBrush
	UnlockGUI

	button = 0
	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN
		PARSE VAR RESULT button x0 y0 .

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

	IF global.points > 0 THEN DO
		CALL XorPath
		DROP global.xcoord. global.ycoord.
		global.points = 0
	END

	LockGUI
	CALL SetFirstBrush
	UnlockGUI

	button = 0
	WaitForClick 'DOWN POINT SHOWBRUSH'
	IF RC = 0 THEN
		PARSE VAR RESULT button x0 y0 .

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

	IF global.fromshx ~= global.toshx | global.fromshy ~= global.toshy | global.shears > 1 THEN DO
		global.do_shear = 1
		shearx = ABS(global.toshx - global.fromshx)
		IF global.count > 1 THEN
			global.shear_sx =	(shearx * global.shears) / (global.count - 1)
		ELSE
			global.shear_sx =	0
		IF global.toshx < global.fromshx THEN
			global.shear_sx = -global.shear_sx
		global.min_shx = MIN(global.fromshx, global.toshx)
		global.max_shx = MAX(global.fromshx, global.toshx)

		sheary = ABS(global.toshy - global.fromshy)
		IF global.count > 1 THEN
			global.shear_sy =	(sheary * global.shears) / (global.count - 1)
		ELSE
			global.shear_sy =	0
		IF global.toshy < global.fromshy THEN
			global.shear_sy = -global.shear_sy
		global.min_shy = MIN(global.fromshy, global.toshy)
		global.max_shy = MAX(global.fromshy, global.toshy)
	END
	ELSE
		global.do_shear = 0
	global.shear_x = global.fromshx
	global.shear_y = global.fromshy

	IF global.fromrsx ~= global.torsx | global.fromrsy ~= global.torsy | global.resizes > 1 THEN DO
		global.do_resize = 1
		resizex = ABS(global.torsx - global.fromrsx)
		IF global.count > 1 THEN
			global.resize_sx = (resizex * global.resizes) / (global.count - 1)
		ELSE
			global.resize_sx =	0
		IF global.torsx < global.fromrsx THEN
			global.resize_sx = -global.resize_sx
		global.min_rsx = MIN(global.fromrsx, global.torsx)
		global.max_rsx = MAX(global.fromrsx, global.torsx)

		resizey = ABS(global.torsy - global.fromrsy)
		IF global.count > 1 THEN
			global.resize_sy = (resizey * global.resizes) / (global.count - 1)
		ELSE
			global.resize_sy =	0
		IF global.torsy < global.fromrsy THEN
			global.resize_sy = -global.resize_sy
		global.min_rsy = MIN(global.fromrsy, global.torsy)
		global.max_rsy = MAX(global.fromrsy, global.torsy)
	END
	ELSE
		global.do_resize = 0
	global.resize_x = global.fromrsx
	global.resize_y = global.fromrsy

	global.do_transf = global.do_rot | global.rot_ang ~= 0 |,
	                   global.do_shear | global.shear_x ~= 0 | global.shear_y ~= 0 |,
	                   global.do_resize | global.resize_x ~= 1000000 | global.resize_y ~= 1000000

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




PreviewStep: PROCEDURE EXPOSE global.

	pos = ARG(1)
	IF global.do_transf THEN DO
		w = global.bshw
		h = global.bshh
		hx = global.bshhx
		hy = global.bshhy

		r.0.x = 0
		r.0.y = 0
		r.1.x = w - 1
		r.1.y = 0
		r.2.x = w - 1
		r.2.y = h - 1
		r.3.x = 0
		r.3.y = h - 1

		r.4.x = 0
		r.4.y = h % 2
		r.5.x = w % 2
		r.5.y = 0
		r.6.x = w - 1
		r.6.y = h % 2

		IF global.rot_ang ~= 0 THEN DO
			GetEllipsePoint 0 0 1000 1000 TRUNC(global.rot_ang / 10 + 0.5)
			PARSE VAR RESULT px py .
			spm = px / 1000
			cpm = -(py / 1000)

			minx = 32000
			miny = 32000
			maxx = -32000
			maxy = -32000
			DO pt = 0 TO 6
				rptx = r.pt.x * cpm - r.pt.y * spm
				rpty = r.pt.x * spm + r.pt.y * cpm
				r.pt.x = TRUNC(rptx + 0.5 * SIGN(rptx))
				r.pt.y = TRUNC(rpty + 0.5 * SIGN(rpty))
				IF r.pt.x > maxx THEN maxx = r.pt.x
				IF r.pt.y > maxy THEN maxy = r.pt.y
				IF r.pt.x < minx THEN minx = r.pt.x
				IF r.pt.y < miny THEN miny = r.pt.y
			END
			w = maxx - minx + 1
			h = maxy - miny + 1

			hx1 = hx * cpm - hy * spm
			hy1 = hx * spm + hy * cpm
			hx = TRUNC(hx1 + 0.5 * SIGN(hx1))
			hy = TRUNC(hy1 + 0.5 * SIGN(hy1))
		END

		IF global.shear_x ~= 0 | global.shear_y ~= 0 THEN DO
			w0 = w
			h0 = h
			shearx = TRUNC(global.shear_x + 0.5 * SIGN(global.shear_x))
			sheary = TRUNC(global.shear_y + 0.5 * SIGN(global.shear_y))
			w2 = w + ABS(shearx)
			h2 = h + ABS(sheary)

			minx = 32000
			miny = 32000
			DO pt = 0 TO 6
				rptx = r.pt.x + (shearx * (r.pt.y / (h-1)))
				rpty = r.pt.y + (sheary * (rptx / (w2-1)))
				r.pt.x = TRUNC(rptx + 0.5 * SIGN(rptx))
				r.pt.y = TRUNC(rpty + 0.5 * SIGN(rpty))
				IF r.pt.x < minx THEN minx = r.pt.x
				IF r.pt.y < miny THEN miny = r.pt.y
			END
			w = w2
			h = h2
			hx1 = hx * (w / w0) + minx
			hy1 = hy * (h / h0) + miny
			hx = TRUNC(hx1 + 0.5 * SIGN(hx1))
			hy = TRUNC(hy1 + 0.5 * SIGN(hy1))
		END

		IF global.resize_x ~= 1000000 | global.resize_y ~= 1000000 THEN DO
			multx = global.resize_x / 1000000
			multy = global.resize_y / 1000000

			DO pt = 0 TO 6
				rptx = r.pt.x * multx
				rpty = r.pt.y * multy
				r.pt.x = TRUNC(rptx + 0.5 * SIGN(rptx))
				r.pt.y = TRUNC(rpty + 0.5 * SIGN(rpty))
			END

			hx = TRUNC(hx * multx + 0.5 * SIGN(hx))
			hy = TRUNC(hy * multy + 0.5 * SIGN(hy))
		END

		PARSE VAR pos xpos ypos .
		pxseq = ''
		DO pt = 0 TO 6
			r.pt.x = xpos - hx + r.pt.x
			r.pt.y = ypos - hy + r.pt.y
			pxseq = pxseq r.pt.x r.pt.y
			IF pt = 3 | pt = 6 THEN DO
				polypts.pt = pxseq
				pxseq = ''
			END
		END
		Undo global.prvwundo

		IF ~global.add & global.prvwundo ~= 0 THEN DO
			IF global.direct = 0 THEN
				SetFramePosition 'NEXT'
			ELSE IF global.direct = 1 THEN
				SetFramePosition 'PREVIOUS'
		END

		DrawPolygon '"'polypts.3'" COMPLEMENT'
		DrawPolygon '"'polypts.6'" COMPLEMENT'
		global.prvwundo = 2
	END
	ELSE DO
		Undo global.prvwundo

		IF ~global.add & global.prvwundo ~= 0 THEN DO
			IF global.direct = 0 THEN
				SetFramePosition 'NEXT'
			ELSE IF global.direct = 1 THEN
				SetFramePosition 'PREVIOUS'
		END

		PutBrush pos
		global.prvwundo = 1
	END

	RETURN




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
		global.shear_x = global.shear_x + global.shear_sx
		IF global.shear_sx > 0 THEN DO
			IF global.shear_x > global.max_shx THEN DO
				excd = global.shear_x - global.max_shx
				global.shear_x = global.max_shx - excd
				global.shear_sx = -global.shear_sx
			END
		END
		ELSE DO
			IF global.shear_x < global.min_shx THEN DO
				excd = global.min_shx - global.shear_x
				global.shear_x = global.min_shx + excd
				global.shear_sx = -global.shear_sx
			END
		END

		global.shear_y = global.shear_y + global.shear_sy
		IF global.shear_sy > 0 THEN DO
			IF global.shear_y > global.max_shy THEN DO
				excd = global.shear_y - global.max_shy
				global.shear_y = global.max_shy - excd
				global.shear_sy = -global.shear_sy
			END
		END
		ELSE DO
			IF global.shear_y < global.min_shy THEN DO
				excd = global.min_shy - global.shear_y
				global.shear_y = global.min_shy + excd
				global.shear_sy = -global.shear_sy
			END
		END
	END

	IF global.do_resize THEN DO
		global.resize_x = global.resize_x + global.resize_sx
		IF global.resize_sx > 0 THEN DO
			IF global.resize_x > global.max_rsx THEN DO
				excd = global.resize_x - global.max_rsx
				global.resize_x = global.max_rsx - excd
				global.resize_sx = -global.resize_sx
			END
		END
		ELSE DO
			IF global.resize_x < global.min_rsx THEN DO
				excd = global.min_rsx - global.resize_x
				global.resize_x = global.min_rsx + excd
				global.resize_sx = -global.resize_sx
			END
		END

		global.resize_y = global.resize_y + global.resize_sy
		IF global.resize_sy > 0 THEN DO
			IF global.resize_y > global.max_rsy THEN DO
				excd = global.resize_y - global.max_rsy
				global.resize_y = global.max_rsy - excd
				global.resize_sy = -global.resize_sy
			END
		END
		ELSE DO
			IF global.resize_y < global.min_rsy THEN DO
				excd = global.min_rsy - global.resize_y
				global.resize_y = global.min_rsy + excd
				global.resize_sy = -global.resize_sy
			END
		END
	END

	RETURN




PreviewBegin: PROCEDURE EXPOSE global.

	IF ~global.do_transf THEN DO
		SetCurrentBrush global.savebsh
		SetPaintMode global.savepmode
		SetPen 'FOREGROUND' global.savepen
	END
	GetFramePosition
	IF RC = 0 THEN
		global.savefrpos = RESULT
	ELSE
		global.savefrpos = 0
	global.prvwundo = 0

	RETURN




PreviewEnd: PROCEDURE EXPOSE global.

	Undo global.prvwundo
	IF ~global.do_transf THEN DO
		IF global.savebshfr > 1 THEN
			SetBrushAttributes 'FRAMEPOSITION' global.savebshfp
		SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
		SetPen 'FOREGROUND' global.xorpen
	END
	IF global.savefrpos > 0 THEN
		SetFramePosition global.savefrpos

	RETURN




PreviewPath: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_pview'" PROMPT "'global.txt_err_nopath'"'
		RETURN
	END

	CALL InitStep

	IF global.do_transf THEN DO
		IF WORD(global.savebsh, 1) ~= 'BRUSH' THEN DO
			RequestNotify 'TITLE "'global.txt_title_pview'" PROMPT "'global.txt_err_nocbsh'"'
			RETURN
		END
		IF global.tbshnum = 0 THEN DO
			RequestNotify 'TITLE "'global.txt_title_pview'" PROMPT "'global.txt_err_notbsh'"'
			RETURN
		END
	END
	LockGUI
	CALL XorPath
	CALL PreviewBegin

	DO cnt = 1 to global.count
		CALL PreviewStep( GetStep() )
		Wait 'TIME 200'
		CALL NextStep()
	END
	Wait 'TIME 200'

	CALL PreviewEnd
	CALL XorPath
	UnlockGUI

	RETURN




DrawStep: PROCEDURE EXPOSE global.

	pos = ARG(1)
	IF global.do_transf THEN DO
		SetCurrentBrush 'BRUSH' global.tbshnum
		IF RC ~= 0 THEN
			RETURN 0
		CopyBrush global.savebshnum 'NOFRAMES'
		IF RC ~= 0 THEN
			RETURN 0

		IF global.rot_ang ~= 0 THEN DO
			RotateBrush TRUNC(global.rot_ang / 10 + 0.5) 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN 0
		END
		IF global.shear_x ~= 0 | global.shear_y ~= 0 THEN DO
			shearx = TRUNC(global.shear_x + 0.5 * SIGN(global.shear_x))
			sheary = TRUNC(global.shear_y + 0.5 * SIGN(global.shear_y))
			ShearBrush shearx sheary 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN 0
		END

		IF global.resize_x ~= 1000000 | global.resize_y ~= 1000000 THEN DO
			GetBrushAttributes 'WIDTH'
			w = TRUNC(RESULT * (global.resize_x / 1000000) + 0.5)
			GetBrushAttributes 'HEIGHT'
			h = TRUNC(RESULT * (global.resize_y / 1000000) + 0.5)
			IF w < 1 THEN w = 1
			IF h < 1 THEN h = 1
			SetBrushAttributes 'WIDTH' w 'HEIGHT' h 'NOPROGRESS'
			IF RC ~= 0 THEN
				RETURN 0
		END
		SetPaintMode global.savepmode
		SetPen 'FOREGROUND' global.savepen
		PutBrush pos
		FreeBrush 'FORCE'
		SetCurrentBrush global.savebsh
		IF RC ~= 0 THEN
			RETURN 0

		IF global.savebshfr > 1 THEN DO	/* get next frame */
			PutBrush '-1000 -1000'
			Undo
		END
	END
	ELSE
		PutBrush pos

	RETURN 1




DrawIt: PROCEDURE EXPOSE global.

	IF global.points = 0 THEN DO
		RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_nopath'"'
		RETURN 0
	END

	CALL InitStep

	IF global.do_transf THEN DO
		IF WORD(global.savebsh, 1) ~= 'BRUSH' THEN DO
			RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_nocbsh'"'
			RETURN 0
		END
		IF global.tbshnum = 0 THEN DO
			RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_notbsh'"'
			RETURN 0
		END
	END

	LockGUI
	CALL XorPath
	global.pathdisp = 0
	SetCurrentBrush global.savebsh
	SetPaintMode global.savepmode
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
			RequestNotify 'TITLE "'global.txt_title_draw'" PROMPT "'global.txt_err_notmem'"'
			LEAVE
		END
		IF global.direct = 0 THEN
			SetFramePosition 'NEXT'
		ELSE IF global.direct = 1 THEN
			SetFramePosition 'PREVIOUS'
		CALL NextStep()
	END

	IF global.savebshfr > 1 THEN
		SetBrushAttributes 'FRAMEPOSITION' global.savebshfp
	SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'
	SetPen 'FOREGROUND' global.xorpen
	UnlockGUI

	RETURN 1




RotSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_brot'" ',
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

	Request '"'global.txt_title_bshr'" ',
	        '"INTSTR = ""'global.txt_gad_shears'"", 1, 32000, 'global.shears' ',
	        ' INTSTR = ""'global.txt_gad_fromshx'"", -32000, 32000, 'global.fromshx' ',
	        ' INTSTR = ""'global.txt_gad_toshx'"", -32000, 32000, 'global.toshx' ',
	        ' INTSTR = ""'global.txt_gad_fromshy'"", -32000, 32000, 'global.fromshy' ',
	        ' INTSTR = ""'global.txt_gad_toshy'"", -32000, 32000, 'global.toshy' "'
	IF RC = 0 THEN DO
		global.shears  = RESULT.1
		global.fromshx = RESULT.2
		global.toshx   = RESULT.3
		global.fromshy = RESULT.4
		global.toshy   = RESULT.5
	END

	RETURN




ResizeSettings: PROCEDURE EXPOSE global.

	Request '"'global.txt_title_bresz'" ',
	        '"INTSTR = ""'global.txt_gad_resizes'"", 1, 32000, 'global.resizes' ',
	        ' INT10000STR = ""'global.txt_gad_fromrsx'"", 00100, 320000000, 'global.fromrsx' ',
	        ' INT10000STR = ""'global.txt_gad_torsx'"", 00100, 320000000, 'global.torsx' ',
	        ' INT10000STR = ""'global.txt_gad_fromrsy'"", 00100, 320000000, 'global.fromrsy' ',
	        ' INT10000STR = ""'global.txt_gad_torsy'"", 00100, 320000000, 'global.torsy' "'
	IF RC = 0 THEN DO
		global.resizes = RESULT.1
		global.fromrsx = RESULT.2
		global.torsx   = RESULT.3
		global.fromrsy = RESULT.4
		global.torsy   = RESULT.5
	END

	RETURN




DisplayData: PROCEDURE EXPOSE global.

	direct = global.direct
	add = global.add
	rotdir = global.rotdir

	str = COMPRESS(global.txt_gad_count, '_') global.count || '0A'x ||,
	      COMPRESS(global.txt_gad_direct, '_') global.txt_gad_dirct.direct || '0A'x ||,
	      COMPRESS(global.txt_gad_add, '_') global.txt_gad_addf.add || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_rotats, '_') global.rotats || '0A'x ||,
	      COMPRESS(global.txt_gad_fromang, '_') (global.fromang / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_toang, '_') (global.toang / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_rotdir, '_') global.txt_gad_rotdr.rotdir || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_shears, '_') global.shears || '0A'x ||,
	      COMPRESS(global.txt_gad_fromshx, '_') global.fromshx || '0A'x ||,
	      COMPRESS(global.txt_gad_toshx, '_') global.toshx || '0A'x ||,
	      COMPRESS(global.txt_gad_fromshy, '_') global.fromshy || '0A'x ||,
	      COMPRESS(global.txt_gad_toshy, '_') global.toshy || '0A'x ||,
	      '0A'x ||,
	      COMPRESS(global.txt_gad_resizes, '_') global.resizes || '0A'x ||,
	      COMPRESS(global.txt_gad_fromrsx, '_') (global.fromrsx / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_torsx, '_') (global.torsx / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_fromrsy, '_') (global.fromrsy / 10000) || '0A'x ||,
	      COMPRESS(global.txt_gad_torsy, '_') (global.torsy / 10000) || '0A'x

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




Cleanup: PROCEDURE EXPOSE global.

	IF global.pathdisp THEN DO
		LockGUI
		CALL XorPath
		UnlockGUI
	END

	RETURN




Break_C:

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
