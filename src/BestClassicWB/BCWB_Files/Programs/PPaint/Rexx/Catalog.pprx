/* Personal Paint Amiga Rexx script - Copyright � 1996, 1997 Cloanto Italia srl */

/* $VER: Catalog.pprx 1.3 */

/** ENG
 This script creates reference catalogs ("thumbnails") for the images
 contained in the specified directory.

 The first requester can be used to select the catalog background
 (white, gray, or black), the number of thumbnail columns (i.e. images
 per row) and the temporary file directory used by the script. It is also
 possible to decide whether an optimized palette should be generated for
 each catalog (based on thumbnail colors) or not (the palette of the
 current environment is used). The "Test Mode" option quickly shows
 a sample catalog preview based on the current settings.

 The catalog format is based on the current image format (width, height,
 aspect ratio and number of colors). This also affects the number of
 catalog files generated.

 If not in test mode, two file requesters follow: the first one can be used
 to select the source directory, the second one to select the destination
 directory (where the catalog files will be saved), the root of the file
 name and the file format/options. If the base name contains one or more
 consecutive "0" characters, they will be used and progressively replaced
 to store the catalog number (e.g. "Cat_000.pic" becomes "Cat_001.pic",
 "Cat_002.pic", etc.).

 If a catalog file (matching the specified base name) already exists in
 the destination directory, a message asks for confirmation before deleting
 the old files.

 Several program settings affect the quality of the catalog images
 generated by this script. These settings are: Color Reduction, Dithering,
 Color Average Resize. For best-quality results, the
 Floyd-Steinberg/Best Quality dithering should be selected, the
 Color Average Resize option should be activated and an appropriate image
 format should be used (the higher the number of colors, the better):
 this is likely to slow down the generation of the catalog, but greatly
 enhances the quality of the thumbnail catalogs.
*/

/** DEU
 Dieses Skript erm�glicht die Erstellung eines Bilderkatalogs mit
 verkleinerten Abbildungen der in einem Verzeichnis enthaltenen
 Grafiken (sog. "Thumbnails").

 Im ersten Dialogfenster lassen sich Elemente wie der Seitenhintergrund
 (wahlweise Wei�, Grau oder Schwarz), Spaltenanzahl (d. h.
 die Anzahl der Bilder pro Zeile) und das tempor�re Dateiverzeichnis f�r
 das Skript festlegen. Es besteht dar�ber hinaus auch die M�glichkeit,
 f�r jeden Katalog eine (auf der Palette der Kleingrafiken
 basierende) Palette generieren zu lassen. Wird dies nicht gew�nscht,
 verwendet das Skript die Palette der aktuellen Arbeitsumgebung.
 Mit Hilfe der Option "Testmodus" l��t sich eine
 Katalogvorschau auf der Grundlage der aktuellen Einstellungen anzeigen.

 Das Format des Bilderkatalogs basiert grunds�tzlich auf dem aktuellen
 Bildformat (Breite, H�he, Seitenverh�ltnis und Anzahl der Farben).
 Auch die Anzahl der erzeugten Katalogdateien wird dadurch beeinflu�t.

 Wenn Sie sich nicht im Testmodus befinden, werden noch zwei weitere
 Dateiauswahlfenster ge�ffnet: Das erste dient zur Auswahl des Quell-,
 und das zweite entsprechend zur Festlegung des Zielverzeichnisses
 (dort werden die Katalogdateien gespeichert) sowie des Dateinamenstamms
 und einiger Optionen bez�glich des Dateiformats. Wenn der Stamm des
 Dateinamens eine oder mehrere aufeinanderfolgende Nullen "0" enth�lt,
 werden diese zur Speicherung der Katalognummer verwendet. Beispiel:
 "Katze_000.pic" wird zu "Katze_001.pic", "Katze_002.pic", usw.

 Ist im Zielverzeichnis bereits eine Katalogdatei mit dem angegebenen
 Namensstamm vorhanden, so erscheint vor dem �berschreiben der alten
 Dateien zun�chst eine Sicherheitsabfrage.

 Die Qualit�t der f�r den Bilderkatalog erzeugten Kleingrafiken l��t sich
 durch die folgenden Programmeinstellungen beeinflussen:
 Farbreduzierung, Fehlerverteilung, "Farben mit Gr��e �ndern".
 Um ein optimales Ergebnis zu erzielen, sollte wie folgt vorgegangen
 werden: Schalten Sie als Ditheringverfahren "Floyd-Steinberg" ein,
 aktivieren Sie die Option "Farben mit Gr��e �ndern", und verwenden Sie
 ein geeignetes Bildformat, wobei gilt: Je mehr Farben, desto besser.
 Dies erfordert zwar u. U. einen gr��eren Zeitaufwand, liefert aber eine
 erheblich verbesserte Qualit�t der im Bilderkatalog enthaltenen Grafiken.
*/

/** ITA
 Questo script crea cataloghi di riferimento ("miniature") delle immagini
 presenti nel cassetto specificato.

 Si pu� usare la prima finestra di dialogo per scegliere lo sfondo del
 catalogo (bianco, grigio o nero), il numero di colonne per le miniature
 (numero di immagini per riga) e il cassetto temporaneo per file usato
 dallo script. � anche possibile decidere se creare una tavolozza ottimizzata
 per ciascun catalogo (in base ai colori delle miniature) o no (si utilizza
 la tavolozza dell'ambiente corrente). L'opzione "Prova" visualizza in modo
 rapido un'anteprima di esempio del catalogo in base alle impostazioni correnti.

 Il formato del catalogo si basa su quello dell'immagine corrente (larghezza,
 altezza, aspetto e numero di colori). Ci� determina anche il numero di
 file di catalogo generati.

 Se non si � in modo prova, si aprono due finestre per scelta file: la prima
 si pu� usare per selezionare il cassetto di origine, la seconda per indicare
 quello di destinazione (quello in cui saranno salvati i file dei cataloghi),
 radice (parte costante) del nome file e formato/opzioni file. Se il nome di
 base del file contiene uno o pi� caratteri "0" consecutivi, essi saranno usati
 e progressivamente incrementati per immagazzinare il numero di riferimento
 all'interno del catalogo (es. "Cat_000.pic" diventa "Cat_001.pic",
 "Cat_002.pic", ecc.).

 Se nel cassetto di destinazione esiste gi� un file di catalogo (avente un
 nome base coincidente con quello specificato), un messaggio chieder� conferma
 prima della cancellazione dei vecchi file.

 Diverse impostazioni del programma influenzano la qualit� delle immagini del
 catalogo generate da questo script. Questi parametri sono: Riduzione colori,
 Adattamento colori, Rimodellamento con media. Per avere i migliori risultati
 in termini qualitativi, si dovrebbe attivare Floyd-Steinberg/Qualit� ottimale,
 Rimodellamento con media e usare un formato immagine appropriato (quanto pi�
 sar� alto il numero di colori, tanto pi� sar� migliore il risultato); ci�
 probabilmente rallenter� la creazione del catalogo, ma innalzer� di molto la
 qualit� dei cataloghi con immagini in miniatura.
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
	txt_test_tname    = 'Test.pic'
	txt_title_set     = 'Katalogeinstellungen'
	txt_title_font    = 'Font ausw�hlen'
	txt_title_src     = 'Quellverzeichnis ausw�hlen'
	txt_title_dst     = 'Format und Namensstamm ausw�hlen'
	txt_title_del     = 'Achtung'
	txt_gad_bkg       = '_Hintergrund:'
	txt_gad_bkg0      = 'Wei�'
	txt_gad_bkg1      = 'Grau'
	txt_gad_bkg2      = 'Schwarz'
	txt_gad_colmn     = '_Spalten:'
	txt_gad_recurse   = '_Unterverzeichnisse:'
	txt_gad_workdir   = 'Ar_beitsverzeichnis:'
	txt_gad_makeplt   = '_Palette erzeugen:'
	txt_gad_test      = '_Test:'
	txt_gad_yes       = '_Ja'
	txt_gad_no        = '_Nein'
	txt_msg_del0      = 'Sollen bestehende Alben'
	txt_msg_del1      = 'gel�scht werden?'
	txt_err_oldclient = 'F�r dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	txt_err_resize    = 'Fehler bei Gr��enberechnung: '
	txt_err_load      = 'Fehler beim Laden: '
	txt_err_save      = 'Fehler beim Speichern: '
	txt_err_creduc    = 'Fehler bei Farbreduzierung: '
	txt_err_cremap    = 'Fehler bei Farbneuberechnung: '
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_test_tname    = 'Prova.pic'
	txt_title_set     = 'Parametri catalogo'
	txt_title_font    = 'Selezionare font'
	txt_title_src     = 'Selezionare cassetto immagini'
	txt_title_dst     = 'Selezionare nome e formato catalogo'
	txt_title_del     = 'Attenzione'
	txt_gad_bkg       = '_Sfondo:'
	txt_gad_bkg0      = 'Bianco'
	txt_gad_bkg1      = 'Grigio'
	txt_gad_bkg2      = 'Nero'
	txt_gad_colmn     = 'C_olonne:'
	txt_gad_recurse   = "Tutti i _cassetti:"
	txt_gad_workdir   = 'Cassetto di la_voro:'
	txt_gad_makeplt   = 'Creare _tavolozza:'
	txt_gad_test      = '_Prova:'
	txt_gad_yes       = '_S�'
	txt_gad_no        = '_No'
	txt_msg_del0      = 'I cataloghi esistenti'
	txt_msg_del1      = 'devono essere cancellati?'
	txt_err_oldclient = 'Questa procedura richiede_una versione pi� recente_di Personal Paint'
	txt_err_resize    = 'Errore nel ridimensionamento: '
	txt_err_load      = 'Errore nella lettura: '
	txt_err_save      = 'Errore nella scrittura: '
	txt_err_creduc    = 'Errore nella riduzione colori: '
	txt_err_cremap    = 'Errore nell''adattamento colori: '
END
ELSE DO				/* English */
	txt_test_tname    = 'Test.pic'
	txt_title_set     = 'Catalog Settings'
	txt_title_font    = 'Select Font'
	txt_title_src     = 'Select Source Directory'
	txt_title_dst     = 'Select Format and Root Name'
	txt_title_del     = 'Attention'
	txt_gad_bkg       = '_Background:'
	txt_gad_bkg0      = 'White'
	txt_gad_bkg1      = 'Gray'
	txt_gad_bkg2      = 'Black'
	txt_gad_colmn     = 'C_olumns:'
	txt_gad_recurse   = '_Subdirectories:'
	txt_gad_workdir   = '_Work Directory:'
	txt_gad_makeplt   = '_Make Palette:'
	txt_gad_test      = '_Test:'
	txt_gad_yes       = '_Yes'
	txt_gad_no        = '_No'
	txt_msg_del0      = 'Should existing catalog files'
	txt_msg_del1      = 'be deleted?'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	txt_err_resize    = 'Error during resize: '
	txt_err_load      = 'Error during load: '
	txt_err_save      = 'Error during save: '
	txt_err_creduc    = 'Color reduction error: '
	txt_err_cremap    = 'Color remap error: '
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

srcdir      = LoadSet('SourceDir',  'PPaint:Pictures', 0)
dstdir      = LoadSet('DestDir',    'PPaint:Pictures', 0)
dstfile     = LoadSet('DestFile',   '000_Catalog.pic', 0)
dstformat   = LoadSet('DestFormat', '', 0)
fontpath    = LoadSet('FontPath',   'FONTS:', 0)
fontname    = LoadSet('FontName',   'CGTriumvirate', 0)
fontsize    = LoadSet('FontSize',    12, 0)
fontstyle   = LoadSet('FontStyle',   's', 0)
backgr      = LoadSet('Background',  0)
columns     = LoadSet('Columns',     5)
makepalette = LoadSet('MakePalette', 1)
recurse     = LoadSet('Recurse',     0)
tempdir     = LoadSet('TempDir',     'T:')
test        = LoadSet('Test',        0)

max_tempdir_size = 80

FreeEnvironment 'QUERY'
IF RC ~= 0 THEN
	EXIT RC
FreeBrush
IF RC ~= 0 THEN
	EXIT RC

Request '"'txt_title_set'" ' ||,
			'"CYCLE = ""'txt_gad_bkg'"", 3, 'backgr', ""'txt_gad_bkg0'"", ""'txt_gad_bkg1'"", ""'txt_gad_bkg2'"" ' ||,
			' INTSTR = ""'txt_gad_colmn'"", 1, 32767, 'columns' ' ||,
			' STRING = ""'txt_gad_workdir'"", 'max_tempdir_size', ""'tempdir'"" ' ||,
			' CHECK = ""'txt_gad_makeplt'"", 'makepalette' ' ||,
			' CHECK = ""'txt_gad_recurse'"", 'recurse' ' ||,
			' CHECK = ""'txt_gad_test'"", 'test' "'
IF RC ~= 0 THEN
	EXIT RC
backgr  = RESULT.1
columns = RESULT.2
tempdir = RESULT.3
makepalette = RESULT.4
recurse = RESULT.5
test    = RESULT.6

delete_old = 0

RequestFont '"'txt_title_font'" PATH "'fontpath'" NAME "'fontname'" SIZE "'fontsize'" STYLE "'fontstyle'"'
IF RC ~= 0 THEN
	EXIT RC
PARSE VALUE RESULT WITH '"' fontpath '" "' fontname '"' fontsize fontstyle

IF ~test THEN DO
	RequestPath '"'txt_title_src'" PATH "'srcdir'"'
	IF RC ~= 0 THEN
		EXIT RC
	PARSE VALUE RESULT WITH '"' srcdir '"'

	RequestFile 'TITLE "'txt_title_dst'" PATH "'dstdir'" FILE "'dstfile'" SAVEMODE LISTFORMATS FORCE' dstformat
	IF RC ~= 0 THEN
		EXIT RC
	PARSE VALUE RESULT WITH '"' dstdfile '"' dstformat
	ppos = MAX(LASTPOS(':', dstdfile), LASTPOS('/', dstdfile)) + 1
	dstdir = LEFT(dstdfile, ppos-1)
	dstfile = SUBSTR(dstdfile, ppos)

	IF RIGHT(dstdir, 1) = '/' THEN
		dst = LEFT(dstdfile, ppos-2)
	ELSE
		dst = dstdir
	same_srcdst = (dst == srcdir)

	tmpfname = 'T:pprx_cat.'PRAGMA('ID')
	destpattern = CatalogFName(dstfile, 0, 1)

	LockGUI
	IF recurse & same_srcdst THEN
		ADDRESS COMMAND 'List >'tmpfname' "'srcdir'" NOHEAD PAT="'destpattern'" LFORMAT="%s%s" FILES ALL'
	ELSE
		ADDRESS COMMAND 'List >'tmpfname' "'dstdir'" NOHEAD PAT="'destpattern'" LFORMAT="%s%s" FILES'
	UnlockGUI

	oldfiles = 0
	IF OPEN('listfile', tmpfname, 'R') THEN DO
		IF LENGTH(READLN('listfile')) > 0 THEN
			oldfiles = 1
		CALL CLOSE('listfile')
	END
	ADDRESS COMMAND 'Delete >NIL: 'tmpfname
	IF oldfiles THEN DO
		Request '"'txt_title_del'" ' ||,
					'"TEXT = ""'txt_msg_del0'"" ' ||,
					' TEXT = ""'txt_msg_del1'"" ' ||,
					' ACTION = ""'txt_gad_yes'"" ACTION = ""'txt_gad_no'"" ACTION = CANCEL"'
		IF RC ~= 0 THEN
			EXIT RC
		IF RESULT = 1 THEN
			delete_old = 1
	END
END



LockGUI

CALL SaveSet('SourceDir',   srcdir)
CALL SaveSet('DestDir',     dstdir)
CALL SaveSet('DestFile',    dstfile)
CALL SaveSet('DestFormat',  dstformat)
CALL SaveSet('FontPath',    fontpath)
CALL SaveSet('FontName',    fontname)
CALL SaveSet('FontSize',    fontsize)
CALL SaveSet('FontStyle',   fontstyle)
CALL SaveSet('Background',  backgr)
CALL SaveSet('Columns',     columns)
CALL SaveSet('MakePalette', makepalette)
CALL SaveSet('Recurse',     recurse)
CALL SaveSet('TempDir',     tempdir)
CALL SaveSet('Test',        test)



Get 'COLORS'
cnum = RESULT
Get 'IMAGEW'
imgwidth = RESULT
Get 'IMAGEH'
imgheight = RESULT
GetImageAttributes 'DPIX'
hdpi = RESULT
GetImageAttributes 'DPIY'
imgratio = hdpi / RESULT
Get 'CAVRESIZE'
cavrg = RESULT

hgap  = TRUNC((imgwidth / columns) / 6)
tilew = TRUNC((imgwidth - (hgap * (columns + 1))) / columns)
hgap  = TRUNC((imgwidth - (tilew * columns)) / (columns + 1))
vgap  = hgap % imgratio
tileh = tilew % imgratio
txgap = vgap % 10

htgap = imgwidth % 100
thmbw = tilew - (htgap * 2)
vtgap = htgap % imgratio
thmbh = tileh - (vtgap * 2)

CALL FindPens

GetArea
areasets = RESULT
SetArea 'FILLSOLID'
tmpfname = ''
tmpdname = ''

Get 'GCLIP'
saveclip = RESULT
Set '"GCLIP=0"'

SIGNAL ON Break_C

IF test THEN DO
	CALL InitPage
	brushw = thmbw
	brushh = (thmbh % 3) * 2
	brushname = txt_test_tname
	DO UNTIL AddTile(0)
	END
	CALL Break_C
	EXIT 0
END

dir_trail = RIGHT(tempdir, 1)
IF dir_trail ~= ':' & dir_trail ~= '/' THEN
	tempdir = tempdir || '/'
tempdir = tempdir || PRAGMA('ID')
ADDRESS COMMAND 'MakeDir >NIL: "'tempdir'"'
IF RC ~= 0 THEN
	EXIT RC
tempdir = tempdir || '/'

tmpdname = 'T:pprx_dcat.'PRAGMA('ID')
tmpfname = 'T:pprx_cat.'PRAGMA('ID')
tmpfname2 = tmpfname || '.2'

IF OPEN('listfile', tmpdname, 'W') THEN DO
	CALL WRITELN('listfile', srcdir)
	CALL CLOSE('listfile')
END
IF recurse THEN
	ADDRESS COMMAND 'List >>'tmpdname' "'srcdir'" NOHEAD LFORMAT="%s%s" DIRS ALL'

IF OPEN('dirlistfile', tmpdname, 'R') THEN DO
	cancelled = 0
	catnum = 1
	DO FOREVER
		srcdir = READLN('dirlistfile')
		IF EOF('dirlistfile') THEN
			LEAVE

		IF recurse & same_srcdst THEN DO
			dstdir = srcdir
			dir_trail = RIGHT(dstdir, 1)
			IF dir_trail ~= ':' & dir_trail ~= '/' THEN
				dstdir = dstdir || '/'
		END

		IF delete_old THEN DO
			dir_trail = RIGHT(dstdir, 1)
			IF dir_trail ~= ':' & dir_trail ~= '/' THEN
				deldir = dstdir || '/'
			ELSE
				deldir = dstdir
			ADDRESS COMMAND 'Delete >NIL: "'deldir || destpattern'"'
			ADDRESS COMMAND 'Delete >NIL: "'deldir || destpattern'.info"'
		END

		ADDRESS COMMAND 'List >'tmpfname' "'srcdir'" NOHEAD PAT=~(#?.info) LFORMAT="%s%s" FILES'
		IF RC = 0 THEN DO
			ADDRESS COMMAND 'Sort 'tmpfname tmpfname'.s'
			IF RC = 0 THEN DO
				ADDRESS COMMAND 'Delete >NIL: 'tmpfname
				tmpfname = tmpfname'.s'
			END
		END

		IF OPEN('listfile', tmpfname, 'R') THEN DO
			errmess = ''
			done = 0
			IF (~recurse) | same_srcdst THEN
				catnum = 1

			DO UNTIL done
				CALL InitPage
				thmbcolors = ''
				gottn = 0
				DO FOREVER
					fname = READLN('listfile')
					IF EOF('listfile') THEN DO
						done = 1
						LEAVE
					END
					LoadBrush '"'fname'" QUIET FORCE NOPROGRESS'
					IF RC = 0 THEN DO
						GetBrushAttributes 'WIDTH'
						bw = RESULT
						GetBrushAttributes 'HEIGHT'
						bh = RESULT
						GetBrushAttributes 'DPIX'
						bhdpi = RESULT
						GetBrushAttributes 'DPIY'
						bvdpi = RESULT
						bratio = bhdpi / bvdpi

						brushw = thmbw;
						brushh = TRUNC(((brushw / (bw / bh)) * bratio) / imgratio)
						IF brushh > thmbh THEN DO
							brushh = thmbh;
							brushw = TRUNC(((brushh / (bh / bw)) / bratio) * imgratio)
						END

						IF cavrg = 0 THEN
							SetBrushAttributes 'WIDTH 'brushw' HEIGHT 'brushh' NOPROGRESS'
						ELSE
							SetBrushAttributes 'WIDTH 'brushw' HEIGHT 'brushh' COLORS 256 EXTENDPALETTE NOPROGRESS'
						IF RC = 0 THEN DO
							IF makepalette THEN DO
								BrushColorStatistics 'COLORS COMPACT NOPROGRESS'
								IF RC = 0 THEN DO
									thcolors = RESULT
									IF (LENGTH(thmbcolors) + LENGTH(thcolors)) < 65535 THEN
										thmbcolors = thmbcolors thcolors
								END
							END
							ppos = MAX(LASTPOS(':', fname), LASTPOS('/', fname)) + 1
							brushname = SUBSTR(fname, ppos)

							SaveBrush '"'tempdir || brushname'" QUIET FORCE NOPROGRESS'
							IF RC = 0 THEN DO
								gottn = 1
								IF AddTile(0) THEN
									LEAVE
							END
							ELSE DO
								done = 1
								errmess = txt_err_resize || RC
								LEAVE
							END
						END
					END
					ELSE DO
						IF RC ~= 38 THEN DO	/* unrecognized format? */
							done = 1
							errmess = txt_err_load || RC
							LEAVE
						END
					END
				END

				IF errmess ~= '' | gottn = 0 THEN
					LEAVE

				IF makepalette THEN DO
					ReduceColors cnum '"'thmbcolors'"'
					IF RC ~= 0 THEN DO
						done = 1
						IF RC = 5 THEN
							cancelled = 1
						ELSE
							errmess = txt_err_creduc || RC
						LEAVE
					END
				END
				ELSE RC = 0

				IF RC = 0 THEN DO
					IF makepalette THEN DO
						SetColors 'COLORS "'RESULT'"'
						CALL FindPens
					END

					tmpfname2 = tmpfname || '.2'
					ADDRESS COMMAND 'List >'tmpfname2' "'tempdir'" NOHEAD PAT=~(#?.info) LFORMAT="%s%s" FILES'
					IF RC = 0 THEN DO
						ADDRESS COMMAND 'Sort 'tmpfname2 tmpfname2'.s'
						IF RC = 0 THEN DO
							ADDRESS COMMAND 'Delete >NIL: 'tmpfname2
							tmpfname2 = tmpfname2'.s'
						END
					END
					IF OPEN('listfile2', tmpfname2, 'R') THEN DO
						CALL InitPage

						DO FOREVER
							fname = READLN('listfile2')
							IF EOF('listfile2') THEN
								LEAVE
							LoadBrush '"'fname'" QUIET FORCE NOPROGRESS'
							IF RC = 0 THEN DO
								GetBrushAttributes 'WIDTH'
								brushw = RESULT
								GetBrushAttributes 'HEIGHT'
								brushh = RESULT

								RemapBrush 'NOPROGRESS'
								IF RC = 0 THEN DO
									ppos = MAX(LASTPOS(':', fname), LASTPOS('/', fname)) + 1
									brushname = SUBSTR(fname, ppos)
									IF AddTile(1) THEN
										LEAVE
								END
								ELSE DO
									done = 1
									errmess = txt_err_cremap || RC
									LEAVE
								END
							END
							ELSE DO
								done = 1
								errmess = txt_err_load || RC
								LEAVE
							END
						END
						CALL CLOSE('listfile2')

						SaveImage '"'dstdir || CatalogFName(dstfile, catnum)'" FORCE QUIET' dstformat
						IF RC ~= 0 THEN DO
							done = 1
							IF RC = 5 THEN
								cancelled = 1
							ELSE
								errmess = txt_err_save || RC
						END
						catnum = catnum + 1
					END
					ADDRESS COMMAND 'Delete >NIL: 'tmpfname2
				END
				ADDRESS COMMAND 'Delete >NIL: "'tempdir'#?" QUIET'
			END
			CALL CLOSE('listfile')
		END
		IF errmess ~= '' THEN DO
			RequestNotify 'PROMPT "'errmess'"'
			LEAVE
		END
		IF cancelled THEN
			LEAVE
	END
	CALL CLOSE('dirlistfile')
END

CALL Break_C

EXIT 0




InitPage:

	SetPen 'BACKGROUND 'colbackg
	ClearImage

	clmn = 1
	ypos = vgap
	xpos = hgap

	RETURN




FindPens:

	penpass = 0

	DO FOREVER
		IF backgr = 0 THEN
			FindColor '"255 255 255"'
		ELSE IF backgr = 1 THEN
			FindColor '"213 213 213"'
		ELSE
			FindColor '"0 0 0"'
		colbackg = RESULT

		IF penpass = 0 THEN
			FindColor '"213 213 213"'
		ELSE
			FindColor '"213 213 213" EXCLUDE "'colbackg'"'
		coltile = RESULT

		IF backgr = 2 THEN
			FindColor '"255 255 255"'
		ELSE
			FindColor '"0 0 0"'
		coltext = RESULT

		FindColor '"0 0 0"'
		colblack = RESULT
		FindColor '"68 68 68"'
		coldark1 = RESULT
		FindColor '"140 140 140"'
		coldark2 = RESULT
		FindColor '"255 255 255"'
		collight1 = colbackg
		FindColor '"240 240 240"'
		collight2 = RESULT

		penpass = penpass + 1
		IF penpass > 1 THEN
			LEAVE
		IF collight1 ~= coltile & coldark1 ~= coltile THEN
			LEAVE
	END

	RETURN




CatalogFName:
	basefname = ARG(1)
	catlgnum  = ARG(2)
	IF ARG() > 2 THEN
		pattern_fname = ARG(3)
	ELSE
		pattern_fname = 0

	npos1 = INDEX(basefname, '0')
	IF npos1 = 0 THEN DO
		IF pattern_fname THEN
			RETURN basefname || '.???'
		ELSE
			RETURN basefname || '.' || RIGHT(catlgnum, 3, "0")
	END

	ndigits = 1
	bfnlen = LENGTH(basefname)
	DO npos = npos1 + 1 TO bfnlen
		IF SUBSTR(basefname, npos, 1) = '0' THEN
			ndigits = ndigits + 1
		ELSE
			LEAVE
	END
	IF pattern_fname THEN
		catgfname = LEFT(basefname, npos1 - 1) || '#?' || SUBSTR(basefname, npos)
	ELSE
		catgfname = LEFT(basefname, npos1 - 1) || RIGHT(catlgnum, ndigits, "0") || SUBSTR(basefname, npos)

	RETURN catgfname



AddTile:
	with_brush = ARG(1)

	SetPen 'FOREGROUND 'coltile
	DrawRectangle xpos ypos xpos+tilew-1 ypos+tileh-1 'FILL'

	xp0 = xpos + htgap + ((thmbw - brushw) % 2)
	yp0 = ypos + vtgap + ((thmbh - brushh) % 2)

	IF collight1 ~= coltile & coldark1 ~= coltile THEN DO
		xp1 = xp0 + brushw - 1
		yp1 = yp0 + brushh - 1
		xps1 = xpos + tilew - 1
		yps1 = ypos + tileh - 1

		SetPen 'FOREGROUND 'collight1
		DrawRectangle xp0    yp1+1  xp1+1   yp1+1 'FILL'
		DrawRectangle xp1+1  yp1+1  xp1+1   yp0-1 'FILL'
		DrawRectangle xpos    yps1  xpos    ypos  'FILL'
		DrawRectangle xpos    ypos  xps1-1  ypos  'FILL'
		SetPen 'FOREGROUND 'coldark1
		DrawRectangle xp0-1  yp1+1  xp0-1   yp0-1 'FILL'
		DrawRectangle xp0-1  yp0-1  xp1     yp0-1 'FILL'
		DrawRectangle xpos+1  yps1  xps1    yps1  'FILL'
		DrawRectangle xps1    yps1  xps1    ypos  'FILL'

		IF collight1 ~= collight2 & coldark1 ~= coldark2 THEN DO
			SetPen 'FOREGROUND 'collight2
			DrawRectangle xp0-1    yp1+2  xp1+2   yp1+2  'FILL'
			DrawRectangle xp1+2    yp1+2  xp1+2   yp0-2  'FILL'
			DrawRectangle xpos+1  yps1-1  xpos+1  ypos+1 'FILL'
			DrawRectangle xpos+1  ypos+1  xps1-2  ypos+1 'FILL'
			SetPen 'FOREGROUND 'coldark2
			DrawRectangle xp0-2    yp1+2  xp0-2   yp0-2  'FILL'
			DrawRectangle xp0-2    yp0-2  xp1+1   yp0-2  'FILL'
			DrawRectangle xpos+2  yps1-1  xps1-1  yps1-1 'FILL'
			DrawRectangle xps1-1  yps1-1  xps1-1  ypos+1 'FILL'
		END
	END

	IF with_brush THEN DO
		SetPaintMode 'REPLACE'
		SetBrushHandle 'UPPERLEFT'
		PutBrush xp0 yp0
	END
	ELSE DO
		SetPen 'FOREGROUND 'colblack
		DrawRectangle xp0 yp0 xp0+brushw-1 yp0+brushh-1 'FILL'
	END

	textyp = ypos + tileh + txgap
	textx0 = xpos - hgap
	textx1 = xpos + tilew + hgap - 1
	SetPen 'FOREGROUND 'coltext
	VectorText 'TEXT "'brushname'" FONTPATH "'fontpath'" FONTNAME "'fontname'" X0 'textx0' Y0 'textyp' X1 'textx1' Y1' (textyp + fontsize - 1) 'CENTER ANTIALIAS 2 KEEPRATIO KEEPBASELINE'
	IF RC ~= 0 THEN
		Text 'TEXT "'brushname'" FONTPATH "'fontpath'" FONTNAME "'fontname'" FONTSIZE 'fontsize' FONTSTYLE "'fontstyle'" X' (xpos + (tilew % 2)) ' Y 'textyp' CENTER'

	last_one = 0
	xpos = xpos + tilew + hgap
	clmn = clmn + 1
	IF clmn > columns THEN DO
		clmn = 1
		xpos = hgap
		totvgap = tileh + txgap + fontsize + (vgap % 3)
		ypos = ypos + totvgap
		IF (ypos + totvgap) > imgheight THEN
			last_one = 1
	END

	RETURN last_one




SaveSet:
	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_Catal_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet:
	sname = ARG(1)
	def_val = ARG(2)
	IF ARG() > 2 THEN
		request_quote = ARG(3)
	ELSE
		request_quote = 1

	val = def_val
	set_fname = 'ENV:PP_Catal_'sname

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





Break_C:

	IF tmpfname ~= '' THEN DO
		ADDRESS COMMAND 'Delete >NIL: "'tempdir'" ALL QUIET'
		ADDRESS COMMAND 'Delete >NIL: 'tmpfname tmpfname2
	END
	IF tmpdname ~= '' THEN
		ADDRESS COMMAND 'Delete >NIL: 'tmpdname

	FreeBrush 'FORCE'
	SelectSquareBrush 1
	SetArea areasets
	Set '"GCLIP='saveclip'"'
	UnlockGUI

	RETURN 1