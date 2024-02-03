/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: Register.pprx 1.1 */

/** ENG
 This script collect information about the user and prints out a
 registration card.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT
ELSE
	PPPORT = 'PPAINT'

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

image_path = 'PPaintCD:Pictures/CloantoSW/'

/* normal font */
font_name = 'Times'
font_size = 15

/* fallback font */
font_name2 = 'topaz'
font_size2 = 8

data_maxx = 310
data_maxy = 348

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_req_title     = 'Personal Paint 7.1 Registrierkarte'
	txt_gad_name      = 'Vor- und Zu_name:'
	txt_gad_email     = 'E-_Mail:'
	txt_gad_addr1     = 'S_traße:'
	txt_gad_addr2     = '_Land, PLZ, Ort:'
	txt_gad_snum      = '_Seriennummer:'
	txt_gad_pfrom     = '_Händler:'
	txt_gad_pdate     = '_Kaufdatum:'
	txt_gad_paid      = '_Rechnungbetrag:'
	txt_gad_comm      = '_Bemerkungen zu Personal Paint:'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	image_name        = 'Register_deu.pic'
	data_pos.1        = '144 75'
	data_pos.2        = '83 94'
	data_pos.3        = '77 113'
	data_pos.4        = '125 132'
	data_pos.5        = '124 151'
	data_pos.6        = '85 170'
	data_pos.7        = '103 189'
	data_pos.8        = '135 208'
	data_pos.9        = '37 255'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	txt_req_title     = 'Scheda di registrazione Personal Paint 7.1'
	txt_gad_name      = '_Nome e cognome:'
	txt_gad_email     = 'E-_mail:'
	txt_gad_addr1     = '_Indirizzo:'
	txt_gad_addr2     = '_CAP, città e sigla pr.:'
	txt_gad_snum      = 'N_umero di serie programma:'
	txt_gad_pfrom     = 'Acqui_stato presso:'
	txt_gad_pdate     = '_Data di acquisto:'
	txt_gad_paid      = 'Impo_rto pagato:'
	txt_gad_comm      = '_Osservazioni su Personal Paint:'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	image_name        = 'Register_ita.pic'
	data_pos.1        = '141 75'
	data_pos.2        = '81 94'
	data_pos.3        = '88 113'
	data_pos.4        = '156 132'
	data_pos.5        = '201 151'
	data_pos.6        = '143 170'
	data_pos.7        = '132 189'
	data_pos.8        = '128 208'
	data_pos.9        = '37 255'
END
ELSE DO				/* English */
	txt_req_title     = 'Personal Paint 7.1 Registration Card'
	txt_gad_name      = '_Name:'
	txt_gad_email     = 'E-_Mail:'
	txt_gad_addr1     = 'Complete _Address:'
	txt_gad_addr2     = ' '
	txt_gad_snum      = '_Serial Number:'
	txt_gad_pfrom     = 'Purchased _From:'
	txt_gad_pdate     = 'Purchase _Date:'
	txt_gad_paid      = 'Amoun_t Paid:'
	txt_gad_comm      = 'C_omments on Personal Paint:'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	image_name        = 'Register_eng.pic'
	data_pos.1        = '75 75'
	data_pos.2        = '83 94'
	data_pos.3        = '147 113'
	data_pos.4        = '147 127'
	data_pos.5        = '123 148'
	data_pos.6        = '134 167'
	data_pos.7        = '124 186'
	data_pos.8        = '114 205'
	data_pos.9        = '37 255'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

FreeEnvironment 'QUERY'
IF RC ~= 0 THEN
	EXIT RC

LockGUI
DeleteFrames 'ALL FORCE'

LoadImage '"'image_path || image_name'" FORCE QUIET'
IF RC = 0 THEN DO
	req = '"STRING = ""'txt_gad_name'"",  160, """" ' ||,
			' STRING = ""'txt_gad_email'"", 160, """" ' ||,
			' STRING = ""'txt_gad_addr1'"", 160, """" ' ||,
			' STRING = ""'txt_gad_addr2'"", 160, """" ' ||,
			' STRING = ""'txt_gad_snum'"",  160, """" ' ||,
			' STRING = ""'txt_gad_pfrom'"", 160, """" ' ||,
			' STRING = ""'txt_gad_pdate'"", 160, """" ' ||,
			' STRING = ""'txt_gad_paid'"",  160, """" ' ||,
			' STRING = ""'txt_gad_comm'"",  900, """" "'

	Request 'RESIZE "'CENTER(txt_req_title, 75)'" 'req
	IF RC = 0 THEN DO
		DO d = 1 TO 9
			data.d = RESULT.d
		END

		FontExists 'NAME "'font_name'" SIZE 'font_size
		IF RC ~= 0 THEN DO
			font_name = font_name2
			font_size = font_size2
		END
		SetPen 'FOREGROUND 1'

		DO d = 1 TO 8
			PARSE VAR data_pos.d xp .
			StencilRectangle xp 0 data_maxx data_maxy
			Text 'TEXT "'DoubleQuotes(data.d)'" FONTNAME "'font_name'" FONTSIZE 'font_size' X 'data_pos.d' BASELINEPOSITION'
		END

		Text 'TEXT "/" FONTNAME "'font_name'" FONTSIZE 'font_size' X 0 Y 0'
		PARSE VAR RESULT . . x1 .
		space_width = x1 + 1
		Undo

		PARSE VAR data_pos.9 x0 yp .
		xp = x0
		rwn = 0
		comment = DoubleQuotes(data.9)
		comment_words = WORDS(comment)
		StencilRectangle xp 0 data_maxx data_maxy

		DO w = 1 to comment_words
			Text 'TEXT "'WORD(comment, w)'" FONTNAME "'font_name'" FONTSIZE 'font_size' X 'xp yp' BASELINEPOSITION'
			PARSE VAR RESULT . . x1 .
			rwn = rwn + 1
			IF x1 > data_maxx & rwn > 1 THEN DO
				Undo
				w = w - 1
				xp = x0
				yp = yp + font_size
				rwn = 0
			END
			ELSE DO
				xp = x1 + 1 + space_width
				IF xp > data_maxx THEN DO
					xp = x0
					yp = yp + font_size
					rwn = 0
				END
			END
			IF yp > data_maxy THEN
				LEAVE
		END
		FreeStencil

		Set '"PRINT = 1, 0"'
		Set '"PRINTSYS = 0x40, 0, 0, 8, 7"'
		Set '"PRINTLAY = 0x01, 1, 210000, 297000, 0, 12700, 0, 0, 80, 0, 148500, 105000, 0, 0, 3, 0, 2"'
	END
END
UnlockGUI
EXIT 0




DoubleQuotes: PROCEDURE

	text = ARG(1)

	pos = 1
	DO FOREVER
		pos = INDEX(text, '"', pos)
		IF pos = 0 THEN
			BREAK
		text = INSERT('"', text, pos)
		pos = pos + 2
	END

	RETURN text
