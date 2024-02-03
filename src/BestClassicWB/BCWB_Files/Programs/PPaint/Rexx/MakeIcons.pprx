/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: MakeIcons.pprx 1.2 */

/** ENG
 This script creates icons for the picture and animation files in
 the specified path. No icons are created or modified for unrecognized
 types of files (e.g. texts or executable programs). The artwork files
 are not modified or rewritten - only the icon files are.

 The settings requester allows the user to set several parameters
 which affect the creation of the icons:

 - Icon Type: Default (default icon images), Picture (reduced thumbnail
 pictures for image, brush, animation and anim-brush files), NewIcons+Def
 (reduced thumbnail pictures in NewIcons format, the default images are
 used for the standard icon image), NewIcons+Dot (reduced thumbnail pictures
 in NewIcons format, a small "dot" standard image is used to save
 disk space).

 - File Type: Auto (picture files are saved as images or brushes, based
 on their format), Image (picture files are saved as images, if possible),
 Brush (picture files are always saved as brushes).

 - Width: maximum width of the picture icons.

 - Height: maximum height of the picture icons.

 - Icon Palette: Standard (the first four and the last four Workbench
 colors are used for Picture icons, and the standard 16 colors palette
 is used for NewIcons), Best (all Workbench pens are used for Picture
 icons, and the full original picture palette is used for NewIcons),
 Standard (Gray) (same as Standard, but only gray shades are used), Best
 (Gray) (same as Best, but only gray shades are used).

 - Color Average: when this option is active, reduced picture icons
 are generated with a color average algorithm. This improves the
 quality, but slows down the creation of the icons.

 - Animation Frame: First (the first frame is used for
 the picture icons of animation/anim-brushes), Central (the
 middle frame is used), Last (the last frame is used), Manual Selection
 (a frame selection requester is opened for every animation loaded, and
 the middle frame is used for anim-brushes).

 - Target: Existing Icons (new icons are only created for files which
 already have an icon), All Files (icons are created for all image, brush,
 animation, anim-brush, palette and stencil files).

 - Subdirectories: when this option is active, the script processes not
 only the specified directory, but also all subdirectories.

 - Work Directory: this is the directory in which the script stores
 the temporary files from which it then copies the new icons. The
 storage unit should have sufficient space to store at least the largest
 file.

 After the settings requester is closed, a path requester is used to
 select the target directory.

 The "Color Reduction" and "Dithering" program settings also affect the
 quality of the reduced picture icons, because some pictures/brushes may be
 color-reduced before being loaded.

 In some circumstances, if the script runs while the user interacts
 with the Workbench, the Workbench Update menu item must be selected in
 order to visually update the icons in modified by this script.

 When creating reduced picture icons, it is recommended to set the "Brush"
 file type, so that all icons can have the proper ratio, even if a
 matching video mode is unavailable.

 When icons are created with the Picture type setting, the script uses
 the current Workbench (number of colors, palette, ratio) as a reference
 to create the icons. NewIcons icons, instead, are more independent from
 the environment in which they were created, since only the aspect ratio
 of the Workbench screen is checked before creating NewIcons.

 Personal Paint's default icons, stored in "PPaint_Icons", can be freely
 modified to change the default icon image, and the Tool Types and Default
 Tool for each file type.
*/

/** DEU
 Mit Hilfe dieses Skripts lassen sich Piktogramme für Bild- und
 Animationsdateien unter dem angegebenen Pfad erstellen. Es ist jedoch nicht
 möglich, für unbekannte Dateitypen (z. B. Texte oder ausführbare Programme)
 Piktogramme zu erstellen. Die Bilder und Animationen selbst werden nicht
 modifiziert, sondern ausschließich die Piktogrammdateien.

 Im Dialogfenster "Einstellungen" lassen sich verschiedene Parameter zur
 Festlegung bestimmter Eigenschaften für die Piktogramme einstellen:

 - Typ: Standard (Standard-Piktogramme), Bild (Kleingrafiken von Bildern,
   Pinseln, Animationen und Animationspinseln), NewIcons+Def (Kleingrafiken im
   NewIcons-Format, wobei Standardbilder für das Standardpiktogramm verwendet
   werden), NewIcons+Dot (Kleingrafiken im NewIcons-format, wobei ein kleines
   "Dot"-Standardbild benutzt wird, um den Plattenspeicherbedarf zu verringern.

 - Dateityp: Auto (Bilddateien werden, abhängig von ihrem Format, entweder
   als Bilder oder Pinsel gespeichert), Bild (Bilddateien werden, sofern
   möglich, als Bilder gespeichert), Pinsel (Bilddateien werden grundsätzlich
   als Pinsel gespeichert).

 - Breite: Maximale Breite der Bild-Piktogramme.

 - Height: Maximale Höhe der Bild-Piktogramme.

 - Piktogrammpalette: Standard (für Bild-Piktogramme werden die ersten und
   letzten 4 Farben der Workbenchpalette verwendet, die normale 16
   Farben-Palette für NewIcons), Beste (für Bild-Piktogramme werden alle 16
   Workbench-Pens verwendet, für NewIcons die volle Bildpalette), Standard
   (Grau) (wie Standard, allerdings werden nur Graustufen verwendet), Beste
   (Grau) (wie Beste, allerdings werden nur Graustufen verwendet).

 - Farbmittelwert: Wenn diese Option aktiviert ist, werden die
   Piktogramm-Kleingrafiken auf der Grundlage eines besonderen Algorithmusses
   erzeugt. Die hierdurch erzielte bessere Qualität wird allerdings mit einer
   längeren Erstellungsdauer erkauft.

 - Anim-Bild: Erstes (für Grafik-Piktogramme wird das erste Bild der
   Animation oder des Animationspinsels verwendet), Mittleres (verwendet das
   mittlere Einzelbild), Manuelle Auswahl (öffnet ein Auswahlfenster zur
   Festlegung des gewünschten Bildes bei jeder geladenen Animation, bei
   Animationspinseln wird automatisch das mittlere Bild verwendet).

 - Ziel: Existierende Piktogramme (neue Piktogramme werden nur für Dateien
   erstellt, die bereits über ein älteres Piktogramm verfügen) alle Dateien
   (erzeugt für alle Bild-, Pinsel-, Animationspinsel-, Paletten- und
   Maskendateien ein neues Piktogramm.

 - Unterverzeichnis: Ist diese Option aktiviert, so werden nicht nur das
   angegebene Verzeichnis, sondern auch alle darin enthaltenen
   Unterverzeichnisse verarbeitet.

 - Arbeitsverzeichnis: In diesem Verzeichnis speichert das Skript seine
   temporären Daten zur Erzeugung der neuen Piktogramme. Das betreffende
   Speichermedium sollte zumindest noch genügend Platz zum Speichern der
   größten Datei aufweisen.

 Nachdem das Einstellungen-Fenster geschlossen worden ist, muß in einem
 Pfadauswahlfenster der gewünschte Zielpfad eingestellt werden.

 Die Programmeinstellungen "Farbreduzierung" und "Fehlerverteilung" wirken
 sich ebenfalls möglicherweise auf die Qualität der Piktogrammgrafiken aus,
 da einige Bilder oder Pinsel evtl schon beim Laden eine Reduzierung ihrer
 Farbanzahl erfahren.

 Unter bestimmten Umständen (wenn dieses Skript läuft, während der Benutzer
 mit der Workbench interagiert, muß im Workbench-Menü der Amiga Workbench der
 Menübefehl "Bild neu aufbauen" ausgewählt werden, um die Darstellung der mit
 diesem Skript erzeugten Piktogramme zu aktualisieren.

 Bei der Erzeugung von Piktogramm-Kleingrafiken wird empfohlen, als Dateityp
 "Pinsel" einzustellen. Dadurch wird gewährleistet, daß alle Piktogramme auch
 dann mit einem korrekten Größenverhältnis dargestellt werden, wenn kein
 passender Videomodus verfügbar ist.

 Wenn die Piktogramme unter Verwendung des Dateityps "Bild" erzeugt werden,
 werden die aktuellen Workbench-Einstellungen (Farbanzahl, Palette,
 Höhen-/Breitenverhältnis als Referenz verwendet. NewIcons-Piktogramme
 hingegen sind von der Umgebung, in der sie erzeugt wurden, sehr viel
 unabhängiger, da hier lediglich das Höhen-/Breitenverhältnis der Workbench
 überprüft wird.

 Um das Erscheinungsbild des standardmäßig verwendeten Piktogramms zu
 ändern, lassen sich die in "PPaint_Icons" gespeicherten Standardpiktogramme
 von Personal Paint beliebig modifizieren und mit anderen Merkmalen und
 Standardprogrammen verrsehen.
*/

/** ITA
 Questo script crea le icone per i file delle immagini e delle animazioni nel
 percorso specificato. Non sono create o modificate le icone relative a
 file di tipo non riconosciuto (es. testi o programmi eseguibili). I file
 grafici non vengono modificati o riscritti - ciò avviene solo per i file
 delle icone (".info").

 La finestra di impostazione parametri permette di scegliere vari parametri
 che influenzano la creazione delle icone:

 - Tipo di icona: Standard (immagini predefinite per icone), Immagine ridotta
   (immagini in miniatura per disegni, pennelli, animazioni, anim-brush),
   NewIcons+Std (immagini in miniatura in formato NewIcons, mentre per l'icona
   standard si usa l'immagine predefinita), NewIcons+Punto (immagini in miniatura
   in formato NewIcons, mentre si usa l'immagine standard di un piccolo "punto"
   per risparmiare spazio su disco).

 - Tipo di file: Auto (i file dei disegni sono salvati come immagini o
   pennelli, in base al loro formato), Immagine (i file dei disegni sono salvati
   come immagini, se possibile), Pennello (i file dei disegni sono salvati sempre
   come pennelli).

 - Larghezza: la larghezza massima delle immagini per icone.

 - Altezza: l'altezza massima delle immagini per icone.

 - Colori icona: Standard (si usano i primi quattro e gli ultimi quattro colori
   del Workbench per le icone del tipo Immagine ridotta, e la tavolozza standard
   a 16 colori per quelle del tipo NewIcons), Ottimali (si usano tutti i colori
   del Workbench per le icone del tipo Imagine ridotta, e la tavolozza completa
   originale per quelle del tipo NewIcons), Standard (grigi) (come Standard, ma
   si usano solo toni di grigio), Ottimali (grigi) (come Ottimali, ma si usano
   solo toni di grigio).

 - Media cromatica: quando questa opzione è attiva, le icone del tipo Immagine
   ridotta sono create tramite un algoritmo che calcola la media cromatica. Ciò
   migliora la loro qualità, ma rallenta la creazione delle icone.

 - Fotogramma animazione: Primo (si usa il primo fotogramma per l'icona del
   tipo Immagine ridotta per l'animazione/anim-brush), Centrale (si usa il
   fotogramma centrale), Ultimo (si usa l'ultimo fotogramma), Selezionare
   (si apre la finestra di dialogo per la scelta del fotogramma per ogni
   animazione caricata, e si usa il fotogramma centrale per anim-brush).

 - Operare su: Icone esistenti (sono create nuove icone solo per i file che
   già hanno un'icona), Tutti i file (si creano icone per tutti i file relativi
   a disegni, pennelli, animazioni, anim-brush, tavolozze e maschere colori).

 - Tutti i cassetti: quando questa opzione è attiva, lo script opera non solo
   sul cassetto specificato, ma anche su tutti i cassetti presenti al suo interno.

 - Cassetto di lavoro: questo è il cassetto in cui lo script immagazzina i file
   temporanei da cui poi copia le nuove icone. L'unità di memorizzazione dovrebbe
   avere spazio sufficiente per immagazzinare almeno il file più esteso.

 Dopo la chiusura della finestra di dialogo per l'impostazione dei parametri,
 compare una finestra di dialogo per la scelta del percorso relativo al
 cassetto di destinazione

 Anche i parametri "Riduzione colori" e "Adattamento colori" del programma
 influenzano la qualità delle icone del tipo Immagine ridotta, poiché alcuni
 disegni/pennelli possono subire una riduzione dei colori prima di essere
 caricati.

 In alcuni casi, se lo script è attivo mentre l'utente interagisce col
 Workbench, si dovrebbe selezionare la voce Aggiornare tutto del menu Workbench
 per poter aggiornare la visualizzazione delle icone modificate dallo script.

 Quando si creano icone del tipo Immagine ridotta, è consigliabile impostare il
 tipo di file a "Pennello", per far sì che tutte le icone abbiano un aspetto
 adeguato, anche se non è disponibile un modo video che si accordi.

 Quando si creano icone del tipo Immagini ridotte, lo script usa il Workbench
 attuale (numero di colori, tavolozza, aspetto) come riferimento per creare
 le icone. Le icone del tipo NewIcons, invece, sono più slegate dall'ambiente
 in cui sono create, dato che si controlla solo l'aspetto dello schermo del
 Workbench prima di creare icone NewIcons.

 Le icone predefinte di Personal Paint, memorizzate in "PPaint_Icons",
 possono essere liberamente modificate per cambiare l'immagine standard della
 icona, i parametri e il programma associato per ciascun tipo di file.
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
	txt_title_set     = "Piktogramm-Einstellungen"
	txt_title_path    = "Zielverzeichnis"
	txt_title_frame   = "Piktogramm-Bild"
	txt_gad_itype     = "_Piktogramm-Typ:"
	txt_gad_itype0    = "Standard"
	txt_gad_itype1    = "Bild"
	txt_gad_itype2    = "NewIcons+Def"
	txt_gad_itype3    = "NewIcons+Dot"
	txt_gad_ftype     = "_Dateityp:"
	txt_gad_ftype0    = "Auto"
	txt_gad_ftype1    = "Bild"
	txt_gad_ftype2    = "Pinsel"
	txt_gad_width     = "Max _Breite:"
	txt_gad_height    = "Max _Höhe:"
	txt_gad_icnplt    = "Piktogra_mm Palette:"
	txt_gad_icnplt0   = "Standard"
	txt_gad_icnplt1   = "Beste"
	txt_gad_icnplt2   = "Standard (Grau)"
	txt_gad_icnplt3   = "Best (Grau)"
	txt_gad_cavrg     = "_Farb-Mittelwert:"
	txt_gad_animfr    = "A_nim-Bild:"
	txt_gad_animfr0   = "Erstes"
	txt_gad_animfr1   = "Mitte"
	txt_gad_animfr2   = "Letztes"
	txt_gad_animfr3   = "Manuelle Auswahl:"
	txt_gad_target    = "_Ziel:"
	txt_gad_target0   = "Alle Dateien"
	txt_gad_target1   = "Existierende Pikt."
	txt_gad_recurse   = "_Unterverzeichnisse:"
	txt_gad_workdir   = "Arbeits_verzeichnis:"
	txt_gad_frame     = "_Bild:"
	txt_gad_show      = "_Zeigen"
	txt_err_load      = "Fehler beim Laden: "
	txt_err_save      = "Fehler beim Speichern: "
	txt_err_format    = "Fehler bei Formatänderung: "
	txt_err_oldclient = "Dieses Skript erfordert eine neuere_Version von Personal Paint"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_set     = "Parametri icone"
	txt_title_path    = "Selezionare cassetto"
	txt_title_frame   = "Selezionare fotogramma"
	txt_gad_itype     = "Tipo di ic_ona:"
	txt_gad_itype0    = "Standard"
	txt_gad_itype1    = "Immagine ridotta"
	txt_gad_itype2    = "NewIcons+Std"
	txt_gad_itype3    = "NewIcons+Punto"
	txt_gad_ftype     = "Tipo di _file:"
	txt_gad_ftype0    = "Auto"
	txt_gad_ftype1    = "Immagine"
	txt_gad_ftype2    = "Pennello"
	txt_gad_width     = "_Larghezza massima:"
	txt_gad_height    = "Al_tezza massima:"
	txt_gad_icnplt    = "Colo_ri icona:"
	txt_gad_icnplt0   = "Standard"
	txt_gad_icnplt1   = "Ottimali"
	txt_gad_icnplt2   = "Standard (grigi)"
	txt_gad_icnplt3   = "Ottimali (grigi)"
	txt_gad_cavrg     = "M_edia cromatica:"
	txt_gad_animfr    = "Fotogra_mma animazione:"
	txt_gad_animfr0   = "Primo"
	txt_gad_animfr1   = "Centrale"
	txt_gad_animfr2   = "Ultimo"
	txt_gad_animfr3   = "Selezionare"
	txt_gad_target    = "Operare _su:"
	txt_gad_target0   = "Icone esistenti"
	txt_gad_target1   = "Tutti i file"
	txt_gad_recurse   = "Tutti i _cassetti:"
	txt_gad_workdir   = "Cassetto di la_voro:"
	txt_gad_frame     = "_Fotogramma:"
	txt_gad_show      = "_Mostrare"
	txt_err_load      = "Errore nella lettura: "
	txt_err_save      = "Errore nella scrittura: "
	txt_err_format    = "Errore nel cambio formato: "
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
END
ELSE DO				/* English */
	txt_title_set     = "Icon Settings"
	txt_title_path    = "Target Directory"
	txt_title_frame   = "Icon Frame"
	txt_gad_itype     = "_Icon Type:"
	txt_gad_itype0    = "Default"
	txt_gad_itype1    = "Picture"
	txt_gad_itype2    = "NewIcons+Def"
	txt_gad_itype3    = "NewIcons+Dot"
	txt_gad_ftype     = "_File Type:"
	txt_gad_ftype0    = "Auto"
	txt_gad_ftype1    = "Image"
	txt_gad_ftype2    = "Brush"
	txt_gad_width     = "Max _Width:"
	txt_gad_height    = "Max _Height:"
	txt_gad_icnplt    = "Icon _Palette:"
	txt_gad_icnplt0   = "Standard"
	txt_gad_icnplt1   = "Best"
	txt_gad_icnplt2   = "Standard (Gray)"
	txt_gad_icnplt3   = "Best (Gray)"
	txt_gad_cavrg     = "Color A_verage:"
	txt_gad_animfr    = "_Animation Frame:"
	txt_gad_animfr0   = "First"
	txt_gad_animfr1   = "Central"
	txt_gad_animfr2   = "Last"
	txt_gad_animfr3   = "Manual Selection"
	txt_gad_target    = "_Target:"
	txt_gad_target0   = "All Files"
	txt_gad_target1   = "Existing Icons"
	txt_gad_recurse   = "_Subdirectories:"
	txt_gad_workdir   = "Work _Directory:"
	txt_gad_frame     = "_Frame:"
	txt_gad_show      = "_Show"
	txt_err_load      = "Error during load: "
	txt_err_save      = "Error during save: "
	txt_err_format    = "Error in format change: "
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
END

Version 'REXX'
rexx_ver = RESULT
IF rexx_ver < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

FreeEnvironment 'QUERY'
IF RC ~= 0 THEN
	EXIT RC
FreeBrush
IF RC ~= 0 THEN
	EXIT RC

rexx_to_iconset.0 = 1
rexx_to_iconset.1 = 2
rexx_to_iconset.2 = 4
rexx_to_iconset.3 = 4

iconset_to_rexx.0 = 0
iconset_to_rexx.1 = 0
iconset_to_rexx.2 = 1
iconset_to_rexx.3 = 0
iconset_to_rexx.4 = 2

conv_icnplt.0 = 0
conv_icnplt.1 = 1
conv_icnplt.2 = 0
conv_icnplt.3 = 1

Get 'ICONS'
save_icons = RESULT


/* Settings Requester */

itype   = LoadSet('IconType',  iconset_to_rexx.save_icons)
ftype   = LoadSet('FileType',  0)
width   = LoadSet('MaxWidth',  80)
height  = LoadSet('MaxHeight', 80)
icnplt  = LoadSet('IconPlt',   0)
cavrg   = LoadSet('ColAvrg',   0)
animfr  = LoadSet('AnimFrame', 1)
target  = LoadSet('Target',    0)
recurse = LoadSet('Recurse',   1)
tempdir = LoadSet('TempDir',   'T:')

max_tempdir_size = 80

LockGUI
Request '"'txt_title_set'" COMPACT ' ||,
        '"CYCLE = ""'txt_gad_itype'"", 4, 'itype', ""'txt_gad_itype0'"", ""'txt_gad_itype1'"", ""'txt_gad_itype2'"", ""'txt_gad_itype3'"" ' ||,
         'VSPACE = 3 ' ||,
         'CYCLE = ""'txt_gad_ftype'"", 3, 'ftype', ""'txt_gad_ftype0'"", ""'txt_gad_ftype1'"", ""'txt_gad_ftype2'"" ' ||,
         'VSPACE = 2 ' ||,
         'INTSTR = ""'txt_gad_width'"", 1, 32000, 'width' ' ||,
         'VSPACE = 2 ' ||,
         'INTSTR = ""'txt_gad_height'"", 1, 32000, 'height' ' ||,
         'VSPACE = 2 ' ||,
         'CYCLE = ""'txt_gad_icnplt'"", 4, 'icnplt', ""'txt_gad_icnplt0'"", ""'txt_gad_icnplt1'"", ""'txt_gad_icnplt2'"", ""'txt_gad_icnplt3'"" ' ||,
         'VSPACE = 3 ' ||,
         'CHECK = ""'txt_gad_cavrg'"", 'cavrg' ' ||,
         'VSPACE = 3 ' ||,
         'CYCLE = ""'txt_gad_animfr'"", 4, 'animfr', ""'txt_gad_animfr0'"", ""'txt_gad_animfr1'"", ""'txt_gad_animfr2'"", ""'txt_gad_animfr3'"" ' ||,
         'VSPACE = 3 ' ||,
         'CYCLE = ""'txt_gad_target'"", 2, 'target', ""'txt_gad_target0'"", ""'txt_gad_target1'"" ' ||,
         'VSPACE = 3 ' ||,
         'CHECK = ""'txt_gad_recurse'"", 'recurse' ' ||,
         'VSPACE = 2 ' ||,
			'STRING = ""'txt_gad_workdir'"", 'max_tempdir_size', ""'tempdir'"" ' ||,
         'VSPACE = 3 "'
IF RC = 0 THEN DO
	itype   = RESULT.1
	ftype   = RESULT.2
	width   = RESULT.3
	height  = RESULT.4
	icnplt  = RESULT.5
	cavrg   = RESULT.6
	animfr  = RESULT.7
	target  = RESULT.8
	recurse = RESULT.9
	tempdir = RESULT.10

	CALL SaveSet('IconType',  itype)
	CALL SaveSet('FileType',  ftype)
	CALL SaveSet('MaxWidth',  width)
	CALL SaveSet('MaxHeight', height)
	CALL SaveSet('IconPlt',   icnplt)
	CALL SaveSet('ColAvrg',   cavrg)
	CALL SaveSet('AnimFrame', animfr)
	CALL SaveSet('Target',    target)
	CALL SaveSet('Recurse',   recurse)
	CALL SaveSet('TempDir',   tempdir)

	ipath = LoadSet('TargetDir',  'PPaint:Pictures')

	RequestPath '"'txt_title_path'" PATH "'ipath'"'
	IF RC = 0 THEN DO
		ipath = RESULT
		PARSE VALUE ipath WITH '"' uipath '"'
		CALL SaveSet('TargetDir', uipath)

		IF recurse THEN
			list_all = 'ALL'
		ELSE
			list_all = ''
		tmpfname = 'T:pprx_temp.'PRAGMA('ID')
		ADDRESS COMMAND 'List >'tmpfname' 'ipath' NOHEAD PAT=~(#?.info) LFORMAT="*"%s%s*"" FILES' list_all

		dir_trail = RIGHT(tempdir, 1)
		IF dir_trail ~= ':' & dir_trail ~= '/' THEN
			tempdir = tempdir || '/'
		tempfile = tempdir || PRAGMA('ID')

		icnpltinfo = conv_icnplt.icnplt
		IF cavrg & rexx_ver >= 8 THEN
			icnpltinfo = icnpltinfo + 2
		newicdot = (itype = 3)

		Set '"ICONS='rexx_to_iconset.itype'"'
		Set '"ICONFMT='width','height','icnpltinfo','newicdot'"'

		Get 'PATHPIC'
		PARSE VAR RESULT '"' save_pathpic '"'
		Get 'PATHANIM'
		PARSE VAR RESULT '"' save_pathanim '"'
		Get 'PATHCOL'
		PARSE VAR RESULT '"' save_pathcol '"'
		Get 'PATHSTEN'
		PARSE VAR RESULT '"' save_pathsten '"'
		Get 'PATHBSH'
		PARSE VAR RESULT '"' save_pathbsh '"'
		Get 'PATHANBSH'
		PARSE VAR RESULT '"' save_pathanbsh '"'

		SIGNAL ON Break_C

		IF OPEN('listfile', tmpfname, 'R') THEN DO
			errmess = ''
			DO FOREVER
				curfname = READLN('listfile')
				IF EOF('listfile') THEN
					BREAK

				IF target THEN DO
					icon_exists = 0
					icon_name = SUBSTR(curfname, 2, LENGTH(curfname) - 2) || '.info'
					IF OPEN('iconfile', icon_name, 'R') THEN DO
						icon_exists = 1
						CALL CLOSE('iconfile')
					END
					IF ~icon_exists THEN
						ITERATE
				END

				GetFileFormat curfname 'FULL'
				IF RC = 0 THEN DO
					pfullformat = RESULT
					PARSE VALUE pfullformat WITH '"' pformat '"' pwidth pheight pcolors pattr .
					pformat = UPPER(pformat)
					pframes = 0
					DeleteFrames 'ALL FORCE'
					SetPen 'BACKGROUND 0'
					ClearImage

					IF pformat = 'ANIM' THEN DO
						LoadAnimation curfname 'FORCE QUIET NEW'
						IF RC ~= 0 THEN DO
							IF RC ~= 34 THEN DO
								errmess = txt_err_load || RC
								LEAVE
							END
							ELSE ITERATE	/* skip HAM animations */
						END
						GetFrames
						pframes = RESULT
						IF animfr = 0 THEN		/* first */
							frame = 1
						ELSE IF animfr = 1 THEN		/* middle */
							frame = (pframes + 1) % 2
						ELSE IF animfr = 2 THEN		/* last */
							frame = pframes
						ELSE DO		/* select */
							frame = SelectAnimFrame(pframes)
							IF frame = 0 THEN
								LEAVE		/* cancelled */
						END
						SetFramePosition 'FRAME' frame
						IF icnplt > 1 THEN
							AdjustColors 'COLOR -100'
						SaveAnimation tempfile 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_save || RC
							LEAVE
						END
					END
					ELSE IF pformat = 'ANIMBRUSH' THEN DO
						LoadAnimBrush curfname 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_load || RC
							LEAVE
						END
						GetAnimBrushSettings 'FRAMES'
						pframes = RESULT
						IF animfr = 0 THEN	/* first */
							frame = 1
						ELSE IF animfr = 2 THEN	/* last */
							frame = pframes
						ELSE							/* middle */
							frame = (pframes + 1) % 2
						SetAnimBrushSettings 'FRAME' frame
						IF icnplt > 1 THEN DO
							RC = GrayBrushPalette()
							IF RC ~= 0 THEN DO
								errmess = txt_err_format || RC
								LEAVE
							END
						END
						SaveAnimBrush tempfile 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_save || RC
							LEAVE
						END
					END
					ELSE IF pformat = 'PALETTE' THEN DO
						GetBestVideoMode 320 200 pcolors
						PARSE VAR RESULT scrd scrw scrh
						Set '"IMAGEW=320" "IMAGEH=200" "COLORS='pcolors'" "DISPLAY='scrd'" "SCREENW='scrw'" "SCREENH='scrh'" "ASCROLL=0"'
						IF RC ~= 0 THEN DO
							errmess = txt_err_format || RC
							LEAVE
						END
						LoadPalette curfname 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_load || RC
							LEAVE
						END
						SavePalette tempfile 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_save || RC
							LEAVE
						END
					END
					ELSE IF pformat = 'STENCIL' THEN DO
						GetBestVideoMode pwidth pheight 2
						PARSE VAR RESULT scrd scrw scrh
						Set '"IMAGEW='pwidth'" "IMAGEH='pheight'" "COLORS=2" "DISPLAY='scrd'" "SCREENW='scrw'" "SCREENH='scrh'" "ASCROLL=1"'
						IF RC ~= 0 THEN DO
							errmess = txt_err_format || RC
							LEAVE
						END
						LoadStencil curfname 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_load || RC
							LEAVE
						END
						SaveStencil tempfile 'FORCE QUIET'
						IF RC ~= 0 THEN DO
							errmess = txt_err_load || RC
							LEAVE
						END
					END
					ELSE DO
						IF ftype = 0 THEN DO  /* auto */
							IF (pwidth = 320  |,
							    pwidth = 640  |,
							    pwidth = 800  |,
							    pwidth = 1024 |,
							    pwidth = 1120 |,
							    pwidth = 1152 |,
							    pwidth = 1280 |,
							    pwidth = 1600) &,
							   (pheight = 200 |,
							    pheight = 240 |,
							    pheight = 256 |,
							    pheight = 400 |,
							    pheight = 480 |,
							    pheight = 512 |,
							    pheight = 768 |,
							    pheight = 832 |,
							    pheight = 900 |,
							    pheight = 960 |,
							    pheight = 1024 |,
							    pheight = 1200) THEN
								is_image = 1
							ELSE
								is_image = 0
						END
						ELSE IF ftype = 1 THEN DO  /* image */
							IF pwidth < 320 | pheight < 200 THEN
								is_image = 0
							ELSE
								is_image = 1
						END
						ELSE  /* brush */
							is_image = 0

						IF is_image THEN DO
							LoadImage curfname 'FORCE QUIET'
							IF RC ~= 0 THEN DO
								errmess = txt_err_load || RC
								LEAVE
							END
							IF icnplt > 1 THEN
								AdjustColors 'COLOR -100'
							SaveImage tempfile 'FORCE QUIET'
							IF RC ~= 0 THEN DO
								errmess = txt_err_save || RC
								LEAVE
							END
						END
						ELSE DO
							LoadBrush curfname 'FORCE QUIET'
							IF RC ~= 0 THEN DO
								errmess = txt_err_load || RC
								LEAVE
							END
							IF icnplt > 1 THEN DO
								RC = GrayBrushPalette()
								IF RC ~= 0 THEN DO
									errmess = txt_err_format || RC
									LEAVE
								END
							END
							SaveBrush tempfile 'FORCE QUIET'
							IF RC ~= 0 THEN DO
								errmess = txt_err_save || RC
								LEAVE
							END
						END
					END

					IF rexx_ver >= 8 THEN DO
						GetFileFormat tempfile 'FULL'
						IF RC = 0 THEN DO
							IF pfullformat ~= RESULT THEN
								CALL FixToolTypes(tempfile, pfullformat, pframes)
						END
					END
					IF rexx_ver >= 8 THEN
						CopyIcon tempfile curfname
					ELSE DO
						icon_name = INSERT('.info', curfname, LENGTH(curfname)-1)
						ADDRESS COMMAND 'Copy 'tempfile'.info' icon_name
					END
				END
			END
			IF errmess ~= '' THEN
				RequestNotify 'PROMPT "'errmess'"'
		END
		ELSE tmpfname = ''

		CALL Break_C
	END
END
UnlockGUI

EXIT 0




SelectAnimFrame:

	GetFramePosition
	frm = RESULT

	DO FOREVER
		Request '"'txt_title_frame'" KEEPCOLORS ' ||,
		        '"SLIDE = ""'txt_gad_frame'"", 1, 'ARG(1)', 'frm' ' ||,
		         'ACTION = PROCEED ' ||,
		         'ACTION = ""'txt_gad_show'"" ' ||,
		         'ACTION = CANCEL "'
		IF RC = 0 THEN DO
			frm = RESULT.1
			IF RESULT = 2 THEN	/* Show */
				SetFramePosition 'FRAME' frm
			ELSE
				LEAVE
		END
		ELSE DO	/* cancelled */
			frm = 0
			LEAVE
		END
	END
	RETURN frm




GrayBrushPalette: PROCEDURE

	GetBrushAttributes COLORS
	bcolors = RESULT
	GetBestVideoMode 320 200 bcolors
	PARSE VAR RESULT scrd scrw scrh
	Set '"IMAGEW=320" "IMAGEH=200" "COLORS='bcolors'" "DISPLAY='scrd'" "SCREENW='scrw'" "SCREENH='scrh'" "ASCROLL=0"'
	IF RC ~= 0 THEN
		RETURN RC

	UseBrushPalette
	AdjustColors 'COLOR -100'
	CopyPaletteToBrush

	RETURN 0




FixToolTypes: PROCEDURE

	file = ARG(1)
	PARSE VALUE ARG(2) WITH '"' pformat '"' pwidth pheight pcolors pattr .
	pframes = ARG(3)

	SetToolType file 'REPLACE "FILETYPE='pformat'"'
	SetToolType file 'REPLACE "IMGFORMAT='pwidth'×'pheight', 'pcolors' COL"'
	SetToolType file 'REPLACE "ANIMFORMAT='pwidth'×'pheight', 'pcolors' COL, 'pframes' FRM"'
	SetToolType file 'REPLACE "ANIMBFORMAT='pwidth'×'pheight', 'pcolors' COL, 'pframes' FRM"'
	SetToolType file 'REPLACE "COLORS='pcolors'"'
	SetToolType file 'REPLACE "STENCILFORMAT='pwidth'×'pheight'"'

	RETURN




SaveSet: PROCEDURE

	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_MakeIcons_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet: PROCEDURE

	sname = ARG(1)
	def_val = ARG(2)

	val = def_val
	set_fname = 'ENV:PP_MakeIcons_'sname

	IF OPEN('settingfile', set_fname, 'R') THEN DO
		val = READCH('settingfile', 65535)
		CALL CLOSE('settingfile')
	END

	RETURN val




Break_C:

	DeleteFrames 'ALL FORCE'
	SetPen 'BACKGROUND 0'
	ClearImage
	UseDefaultPalette
	FreeStencil
	FreeBrush

	Set '"ICONS=""'save_icons'"" "'
	Set '"PATHPIC=""'save_pathpic'"" "'
	Set '"PATHANIM=""'save_pathanim'"" "'
	Set '"PATHCOL=""'save_pathcol'"" "'
	Set '"PATHSTEN=""'save_pathsten'"" "'
	Set '"PATHBSH=""'save_pathbsh'"" "'
	Set '"PATHANBSH=""'save_pathanbsh'"" "'

	IF tmpfname ~= '' THEN DO
		CALL CLOSE('listfile')
		ADDRESS COMMAND 'Delete >NIL: 'tmpfname
	ENS

	ADDRESS COMMAND 'Delete >NIL: 'tempfile tempfile'.info'

	UnlockGUI

	RETURN
