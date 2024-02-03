/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: SaveAnimGif.pprx 1.7 */

/** ENG
 This script saves the current anim-brush as a GIF animation file. Specific
 features of the GIF animation specification can be set through a requester.

 This script checks for the differences between frames and only stores
 the smallest rectangular region containing changes. Other techniques
 are employed for additional compression. The resulting GIF animations are
 highly optimized and occupy considerably less space than GIF animations
 created with other tools available on the Amiga.

 The "Use Loop" option inserts an "Application Extension Block" into the GIF
 file (as implemented by Netscape in its Navigator software from version 2).
 This additional block, which is interpreted by most other browsers
 supporting GIF animations, specifies that the animation be repeated as many
 times as indicated by the "Loop" value. A value of 0 expressly means
 "loop continuously".

 The list of frames shows the timing value for each frame, in seconds/100.
 These values can be selected, edited and applied to one or more frames.
 Alternatively, the timing can be copied automatically from the current
 animation. If this option is selected ("From Animation"), then the
 "Delay" value is used to indicate from which animation frame the timing
 values are to be copied.

 The "Transparency" setting indicates the current transparency status of
 the anim-brush. If transparency is not required by the animation, it is
 recommended to leave this option disabled.

 Note: an "anim-brush" is a part of a full-screen animation. It can be
 either loaded or defined manually after clicking three times on the
 Define Brush tool.
*/

/** DEU
 Dieses Skript dient zum Speichern des aktuellen Anim-Brushes als
 GIF-Animation. Eine Reihe spezifischer Merkmale des Animationsformats läßt
 sich in einem dazugehörigen Dialogfenster auswählen.

 Nach der Skriptausführung werden zwei aufeinanderfolgende Frames zunächst
 auf Unterschiede untersucht. Gespeichert wird dann nur der kleinste
 rechteckige Bereich, der Unterschiede zwischen den beiden Bildern aufweist.
 Außerdem werden zum Erzielen einer weiter verbesserten Komprimierung noch
 andere Verfahren angewendet. Die daraus resultierenden hochoptimierten
 GIF-Animationen benötigen erheblich weniger Speicherplatz als solche, die
 mit anderen für den Amiga erhältlichen Tools erstellt worden sind.

 Durch die Option "Schleife aktiv:" wird der GIF-Datei eine
 Programmerweiterung ("Application Extension Block") hinzugefügt, wie sie von
 Netscape im Navigator ab Version 2 implementiert ist. Dieser auch von den
 meisten anderen Browsern, die GIF-Animationen unterstützen, interpretierte
 Block legt fest, daß die Animation so oft wiederholt wird, wie unter
 "Schleife:" angegeben. Ein Wert von 0 bewirkt das Abspielen in einer
 Endlosschleife.

 Die Frameliste zeigt den Timingwert für jedes Einzelbild in Hundertstel
 Sekunden. Diese Werte lassen sich auswählen, bearbeiten und anschließend
 einem oder mehreren Einzelbildern zuweisen. Alternativ dazu können die
 Timingwerte automatisch aus der aktuellen Animation kopiert werden. Wenn die
 entsprechende Option aktiviert ist ("Von Animation"), wird der
 "Verzögerung"-Wert verwendet, um anzuzeigen, von welchem Einzelbild der
 Animation die Timingwerte kopiert werden sollen.

 Die "Transparenz"-Einstellung gibt den aktuellen Transparenzstatus des
 Animationspinsels wieder. Erfordert die Animation keine Transparenz, so wird
 empfohlen, diese Option ausgeschaltet zu lassen.

 Hinweis: Ein Animationspinsel ist ein Bestandteil einer normalen Animation.
 Er läßt sich nach einem Dreifachklick auf das Pinseldefinitionswerkzeug
 entweder laden oder manuell definieren.
*/

/** ITA
 Questo script salva l'anim-brush corrente come un'animazione GIF. Si possono
 impostare le caratteristiche peculiari di una animazione GIF tramite una
 apposita finestra di dialogo.

 Questo script controlla eventuali differenze tra fotogrammi e salva solo
 la più piccola regione rettangolare che contiene modifiche. Altre tecniche
 sono utilizzate per una compressione aggiuntiva. Le animazioni GIF risultanti
 sono altamente ottimizzate ed occupano molto meno spazio di quelle create con
 altri programmi disponibili su Amiga.

 L'opzione "Usare ciclo" inserisce un "Application Extension Block" nel file GIF
 (come implementato da Netscape nel suo programma Navigator a partire dalla
 versione 2). Questo blocco aggiuntivo, che viene interpretato dalla maggior
 parte degli altri programmi di navigazione che permettono l'uso di animazioni
 GIF, specifica che l'animazione deve essere ripetuta tante volte quante
 indicato dal valore "Ciclo". Un valore pari a 0 significa espressamente
 "ciclo continuo".

 L'elenco dei fotogrammi mostra il valore di temporizzazione per ciascun
 fotogramma, in centesimi di secondo. Tali valori possono essere selezionati,
 modificati e applicati a uno o più fotogrammi. In alternativa, la
 temporizzazione può essere copiata automaticamente dall'animazione corrente.
 Se questa opzione è attiva ("Da animazione"), si usa il valore di
 "Temporizzazione fotogrammi" per indicare da quale fotogramma dell'animazione
 si devono copiare i valori di temporizzazione.

 L'impostazione di "Trasparenza" indica lo stato attuale della trasparenza
 dell'anim-brush. Se l'animazione non richiede la trasparenza, è consigliabile
 lasciare disattivata questa opzione.

 Nota: un "anim-brush" è un pennello, e come tale in genere una (più piccola)
 parte di un'animazione a tutto schermo. Un anim-brush può essere caricare,
 oppure definito manualmente facendo click tre volte sullo strumento
 Definire pennello.
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
	txt_title_req     = 'GIF-Anim-Brush speichern'
	txt_title_set     = 'GIF-Anim-Brush-Einstellungen'
	txt_title_delay   = 'Frame-Verzögerung'
	txt_gad_delay     = 'Frame-Verzögerungen:'
	txt_gad_annot     = '_Bemerkung:'
	txt_gad_loop      = '_Schleife:'
	txt_gad_useloop   = 'Schleife ak_tiv:'
	txt_gad_transp    = '_Transparenz:'
	txt_gad_del       = '_Verzögerung:'
	txt_gad_deltype   = ' '
	txt_gad_deltype0  = '1/100\""'
	txt_gad_deltype1  = 'Von Animation'
	txt_gad_from      = 'A_b Frame:'
	txt_gad_to        = 'Bi_s Frame:'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	txt_err_oldlib    = 'Für dieses Skript ist eine neuere Version_der GIF library erforderlich'
	txt_err_notabsh   = 'Aktueller Brush_ist kein Anim-Brush'
	txt_err_notemp    = 'Zu wenig Speicher_für temporären Brush'
	txt_err_nomem     = 'Speichermangel'
	txt_err_nosave    = 'Fehler bei Datei-Ein-/Ausgabe'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_req     = 'Scrivere Anim-brush GIF'
	txt_title_set     = 'Parametri Anim-brush GIF'
	txt_title_delay   = 'Temporizzazione'
	txt_gad_delay     = 'Temporizzazione fotogrammi:'
	txt_gad_annot     = '_Note:'
	txt_gad_loop      = 'Cic_lo:'
	txt_gad_useloop   = '_Usare ciclo:'
	txt_gad_transp    = '_Transparenza:'
	txt_gad_del       = '_Temporizzazione:'
	txt_gad_deltype   = ' '
	txt_gad_deltype0  = '1/100\""'
	txt_gad_deltype1  = 'Da animazione'
	txt_gad_from      = 'Da _fotogramma:'
	txt_gad_to        = 'A f_otogramma:'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	txt_err_oldlib    = 'Questa procedura richiede_una versione più recente_della libreria GIF'
	txt_err_notabsh   = 'Il pennello attuale_non è un anim-brush'
	txt_err_notemp    = 'Impossibile creare_pennello temporaneo'
	txt_err_nomem     = 'Memoria insufficiente'
	txt_err_nosave    = 'Errore di scrittura'
END
ELSE DO				/* English */
	txt_title_req     = 'Save GIF Anim-Brush'
	txt_title_set     = 'GIF Anim-Brush Settings'
	txt_title_delay   = 'Frame Delay'
	txt_gad_delay     = 'Frame Delays:'
	txt_gad_annot     = '_Annotation:'
	txt_gad_loop      = '_Loop:'
	txt_gad_useloop   = '_Use Loop:'
	txt_gad_transp    = '_Transparency:'
	txt_gad_del       = '_Delay:'
	txt_gad_deltype   = ' '
	txt_gad_deltype0  = '1/100\""'
	txt_gad_deltype1  = 'From Animation'
	txt_gad_from      = '_From Frame:'
	txt_gad_to        = 'T_o Frame:'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	txt_err_oldlib    = 'This script requires a newer_version of the GIF library'
	txt_err_notabsh   = 'The current brush_is not an anim-brush'
	txt_err_notemp    = 'No space for temporary brush'
	txt_err_nomem     = 'Not enough memory'
	txt_err_nosave    = 'File I/O error'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
GetBrushAttributes 'FRAMES'
frames = RESULT

IF frames < 2 THEN DO
	RequestNotify 'PROMPT "'txt_err_notabsh'"'
	UnlockGUI
	EXIT 0
END

GetBrushNumber
bshnum = RESULT

SetCurrentBrush 'UNUSED'
IF RC ~= 0 THEN DO
	RequestNotify 'PROMPT "'txt_err_notemp'"'
	UnlockGUI
	EXIT 0
END
GetBrushNumber
tbshnum = RESULT

SetCurrentBrush 'BRUSH' bshnum
GetBrushInfo 'ANNOTATION'
frame_annot = RESULT

loop = -1
delay. = 0
IF WORD(frame_annot, 1) = 'LOOP' & WORD(frame_annot, 3) = 'DELAY' THEN DO
	loop = WORD(frame_annot, 2)
	IF ~DATATYPE(loop, 'W') THEN
		loop = -1
	DO frm = 1 TO frames
		del = WORD(frame_annot, 3+frm)
		IF DATATYPE(del, 'W') THEN
			delay.frm = del
	END
END
use_loop = (loop >= 0)
IF loop < 0 THEN
	loop = 0

fnlen = LENGTH(frames)
dsel = 1
do_req = 1
deltype = 0

GetBrushInfo 'COPYRIGHT'
annot = RESULT
max_annot_size = LENGTH(annot) * 2
IF max_annot_size < 200 THEN
	max_annot_size = 200

GetBrushAttributes 'TRANSPARENCY'
transp = RESULT
IF transp ~= 1 THEN
	transp = 0

DO WHILE do_req
	ppos = 1
	DO FOREVER
		ppos = INDEX(annot, '"', ppos)
		IF ppos = 0 THEN BREAK
		annot = INSERT('\"', annot, ppos-1)
		ppos = ppos + 3
	END

	req = '"LIST ACTION = ""'txt_gad_delay'"", 'frames', 'dsel-1', 20, 7'
	DO frm = 1 TO frames
		req = req || ', ""'RIGHT(frm, fnlen) || ':' delay.frm || '""'
	END

	req = req ||,
      ' STRING = ""'txt_gad_annot'"", 'max_annot_size', ""'annot'"" ' ||,
		' INTSTR = ""'txt_gad_loop'"", 0, 32767, 'loop' ' ||,
		' CHECK = ""'txt_gad_useloop'"", 'use_loop' ' ||,
		' CHECK = ""'txt_gad_transp'"", 'transp' "'

	Request 'RESIZE "'txt_title_set'"' req
	IF RC = 0 THEN DO
		dsel  = RESULT.1 + 1
		annot = RESULT.2
		loop  = RESULT.3
		use_loop = RESULT.4
		transp = RESULT.5

		IF RESULT = -1 THEN DO
			Request '"'txt_title_delay'" ' ||,
						'"INTSTR = ""'txt_gad_del'"", 0, 32767, 'delay.dsel' ' ||,
						' CYCLE = ""'txt_gad_deltype'"", 2, 'deltype', ""'txt_gad_deltype0'"", ""'txt_gad_deltype1'"" ' ||,
						' SEPARATOR ' ||,
						' INTSTR = ""'txt_gad_from'"", 1, 'frames', 'dsel' ' ||,
						' INTSTR = ""'txt_gad_to'"", 1, 'frames', 'dsel' "'
			IF RC = 0 THEN DO
				del     = RESULT.1
				deltype = RESULT.2
				frfrom  = RESULT.3
				frto    = RESULT.4
				frstep  = SIGN(frto - frfrom)
				IF frstep = 0 THEN
					frstep = 1
				DO frm = frfrom TO frto BY frstep
					IF deltype THEN DO
						IF del < 1 THEN
							del = 1
						GetFrameDelay 'FRAME' del
						IF RC = 0 THEN
							delay.frm = TRUNC((RESULT * 100 / 60) + 0.5)
						del = del + frstep
					END
					ELSE delay.frm = del
				END
			END
		END
		ELSE do_req = 0
	END
	ELSE DO
		UnlockGUI
		EXIT 0
	END
END

IF ~use_loop THEN
	loop = -1
frame_annot = 'LOOP' loop 'DELAY'
DO frm = 1 TO frames
	frame_annot = frame_annot delay.frm
END
SetBrushInfo 'ANNOTATION "'frame_annot'"'


RequestFile '"'txt_title_req'" SAVEMODE'
IF RC = 0 THEN DO
	PARSE VALUE RESULT WITH '"' fname '"'
	tempfile = 'T:PP_AnGif.'PRAGMA('ID')

	GetBrushAttributes 'FRAMEFIRST'
	sv_frmin = RESULT
	GetBrushAttributes 'FRAMELAST'
	sv_frmax = RESULT
	GetBrushAttributes 'LENGTH'
	sv_frlen = RESULT
	GetBrushAttributes 'FRAMEPOSITION'
	sv_frpos = RESULT
	Get 'ICONS'
	sv_icons = RESULT

	GetBrushAttributes 'WIDTH'
	bwidth = RESULT
	GetBrushAttributes 'HEIGHT'
	bheight = RESULT

	GetBrushAttributes 'TRANSPARENTCOLOR'
	transpcol = RESULT
	GetBrushAttributes 'COLORS'
	bcolors = RESULT
	plt_size = bcolors * 3

	Get 'PATHBSH'
	PARSE VAR RESULT '"' sv_pathbsh '"'

	IF transp = 1 THEN
		pckinfo = '09'x
	ELSE
		pckinfo = '00'x

	DO bdepth = 1 TO 8
		IF bcolors = (2 ** bdepth) THEN
			BREAK
	END

	tbmap.0 = 0
	tbmap.1 = 0
	tbnum = 0
	gfile_open = 0
	global_plt = ''
	err_msg = ''

	SIGNAL ON Break_C

	AllocateBitmap bwidth bheight bdepth
	IF RC = 0 THEN DO
		tbmap.0 = RESULT

		AllocateBitmap bwidth bheight bdepth
		IF RC = 0 THEN DO
			tbmap.1 = RESULT

			SetBrushAttributes 'FRAMEFIRST 1 FRAMELAST' frames 'LENGTH' frames
			Set '"ICONS = 0"'

			DO frm = 1 TO frames
				SetCurrentBrush 'BRUSH' bshnum
				IF RC ~= 0 THEN DO
					err_msg = txt_err_nomem
					BREAK
				END

				SetBrushAttributes 'FRAMEPOSITION' frm
				IF RC ~= 0 THEN DO
					err_msg = txt_err_nomem
					BREAK
				END

				GetBitmap '0 0 BITMAP' tbmap.tbnum 'FROMBRUSH'
				tbnum = 1 - tbnum

				GetBrushColors
				local_plt = RESULT

				IF frm = 1 THEN DO
					dx0 = 0
					dy0 = 0
					dx1 = bwidth - 1
					dy1 = bheight - 1
					global_plt = local_plt
				END
				ELSE DO
					IF transp = 1 THEN
						GetBrushAttributes 'BOUNDARIES'
					ELSE
						GetBitmapDelta tbmap.0 tbmap.1

					PARSE VAR RESULT dx0 dy0 dx1 dy1 .
					IF dx0 < 0 THEN DO
						dx0 = 0
						dy0 = 0
						dx1 = 0
						dy1 = 0
					END
					IF transp ~= 1 & global_plt ~== local_plt THEN DO		/* IExplorer bug */
						dx0 = 0
						dy0 = 0
						dx1 = bwidth - 1
						dy1 = bheight - 1
					END
				END

				SetCurrentBrush 'BRUSH' tbshnum
				IF RC ~= 0 THEN DO
					err_msg = txt_err_nomem
					BREAK
				END

				CopyBrush bshnum dx0 dy0 dx1 dy1 'NOFRAMES'
				IF RC ~= 0 THEN DO
					err_msg = txt_err_nomem
					BREAK
				END

				SaveBrush tempfile 'FORCE QUIET NOPROGRESS FORMAT "GIF" OPTIONS "GIF89=1" "PROGDSP=0" "SCRFMT=0"'
				IF RC ~= 0 THEN DO
					IF RC = 46 | RC = 47 THEN
						err_msg = txt_err_oldlib
					ELSE
						err_msg = txt_err_nosave
					BREAK
				END

				IF ~OPEN('tfile', tempfile, 'R') THEN DO
					err_msg = txt_err_nosave
					BREAK
				END

				IF frm = 1 THEN DO
					IF ~OPEN('gfile', fname, 'W') THEN DO
						err_msg = txt_err_nosave
						BREAK
					END
					gfile_open = 1
					data = READCH('tfile', 13)		/* sign + screen descriptor */
					bxpix = BITOR(BITAND(SUBSTR(data, 11, 1), '07'x), '80'x)
					CALL WRITECH('gfile', data)

					plt_data = READCH('tfile', plt_size)	/* palette */
					CALL WRITECH('gfile', plt_data)
					do_plt = 0

					IF use_loop THEN
						CALL WRITECH('gfile', '21FF0B'x || 'NETSCAPE2.0' || '0301'x || IntelWord(loop) || '00'x)

					IF annot ~= '' THEN DO		/* annotation */
						CALL WRITECH('gfile', '21FE'x)
						alen = LENGTH(annot)
						apos = 1
						DO WHILE alen > 0
							IF alen <= 255 THEN
								aln = alen
							ELSE
								aln = 255
							CALL WRITECH('gfile', D2C(aln) || SUBSTR(annot, apos, aln))
							apos = apos + aln
							alen = alen - aln
						END
						CALL WRITECH('gfile', '00'x)
					END
				END
				ELSE DO
					CALL SEEK('tfile', 13, 'B')
					plt_data = READCH('tfile', plt_size)
					do_plt = (global_plt ~== local_plt)
				END

				DO FOREVER
					code = READCH('tfile', 1)

					IF code = ',' THEN DO	/* image */
						/* gfx control */
						CALL WRITECH('gfile', '21F904'x || pckinfo || IntelWord(delay.frm) || D2C(transpcol) || '00'x)

						data = READCH('tfile', 9)		/* Get image descriptor */
						imginfo = SUBSTR(data, 9, 1)
						IF do_plt THEN
							imginfo = BITOR(BITAND(imginfo, '40'x), bxpix)

						/* image descriptor */
						CALL WRITECH('gfile', ',' || IntelWord(dx0) || IntelWord(dy0) || IntelWord(dx1-dx0+1) || IntelWord(dy1-dy0+1) || imginfo)

						IF do_plt THEN
							CALL WRITECH('gfile', plt_data)

						tpos = SEEK('tfile', 0, 'C')
						epos = SEEK('tfile', 0, 'E')
						dsize = epos - tpos - 1
						CALL SEEK('tfile', tpos, 'B')

						/* image data */
						DO WHILE dsize > 0
							IF dsize > 65000 THEN
								tsize = 65000
							ELSE
								tsize = dsize
							data = READCH('tfile', tsize)
							CALL WRITECH('gfile', data)
							dsize = dsize - tsize
						END
						BREAK
					END
					ELSE IF code = '!' THEN DO		/* extension */
						CALL SEEK('tfile', 1, 'C')
						length = 1
						DO WHILE length ~= 0
							length = C2D(READCH('tfile', 1))
							IF length > 0 THEN
								CALL SEEK('tfile', length, 'C')
						END
					END
					ELSE BREAK
				END

				CALL CLOSE('tfile')
			END

			CALL WRITECH('gfile', ';')
			CALL CLOSE('gfile')
			gfile_open = 0

			ADDRESS COMMAND 'Delete >NIL: 'tempfile

			SetCurrentBrush 'BRUSH' tbshnum
			IF RC = 0 THEN
				FreeBrush 'FORCE'

			SetCurrentBrush 'BRUSH' bshnum
			IF RC = 0 THEN
				SetBrushAttributes 'FRAMEFIRST' sv_frmin 'FRAMELAST' sv_frmax 'LENGTH' sv_frlen 'FRAMEPOSITION' sv_frpos

			Set '"ICONS =' sv_icons '"'

			FreeBitmap tbmap.1
		END
		ELSE err_msg = txt_err_nomem

		FreeBitmap tbmap.0
	END
	ELSE err_msg = txt_err_nomem

	IF err_msg ~= '' THEN
		RequestNotify 'PROMPT "'err_msg'"'

	Set '"PATHBSH=""'sv_pathbsh'"" "'
END
UnlockGUI

EXIT 0




IntelWord: PROCEDURE

	value = ARG(1)

	hibyte = value % 256
	lobyte = value - (hibyte * 256)

	RETURN D2C(lobyte) || D2C(hibyte)




Break_C:

	IF gfile_open THEN
		CALL CLOSE('gfile')

	ADDRESS COMMAND 'Delete >NIL: 'tempfile

	SetCurrentBrush 'BRUSH' tbshnum
	IF RC = 0 THEN
		FreeBrush 'FORCE'

	SetCurrentBrush 'BRUSH' bshnum
	IF RC = 0 THEN
		SetBrushAttributes 'FRAMEFIRST' sv_frmin 'FRAMELAST' sv_frmax 'LENGTH' sv_frlen 'FRAMEPOSITION' sv_frpos

	Set '"ICONS =' sv_icons '"'

	IF tbmap.1 ~= 0 THEN
		FreeBitmap tbmap.1

	IF tbmap.0 ~= 0 THEN
		FreeBitmap tbmap.0

	Set '"PATHBSH=""'sv_pathbsh'"" "'

	RETURN
