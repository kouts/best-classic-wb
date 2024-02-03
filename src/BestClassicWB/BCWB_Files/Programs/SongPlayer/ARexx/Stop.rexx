/* Arexx Stop command of SongPlayer */

MYPORT = 'SONGPLAYER.1'

IF ~SHOW( 'P', MYPORT ) THEN DO
   SAY 'SongPlayer is not running.'
   EXIT 10
END

ADDRESS VALUE MYPORT
OPTIONS RESULTS

STOP
