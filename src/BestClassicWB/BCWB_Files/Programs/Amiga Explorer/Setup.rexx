/* Cloanto Amiga Explorer Rexx script - Copyright © 2000 Cloanto ® - http://cloanto.com */

/* $VER: Setup.rexx 1.0 */

binfname = 'RAM:Setup2'
blocksize = 512

IF OPEN('serfile', 'SER:', 'R') THEN DO
	IF OPEN('binfile', binfname, 'W') THEN DO
		DO FOREVER
			data = READCH('serfile', blocksize)
			datalen = LENGTH(data)
			IF datalen > 0 THEN DO
				IF WRITECH('binfile', data) ~= datalen THEN DO
					SAY 'Error writing file.'
					datalen = 0
				END
			END
			IF datalen ~= blocksize | EOF('serfile') THEN BREAK
		END
		CALL CLOSE('binfile')
	END
	CALL CLOSE('serfile')
END

ADDRESS COMMAND 'Run >NIL:' binfname
