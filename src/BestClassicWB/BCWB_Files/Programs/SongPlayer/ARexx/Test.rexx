/* Test of some Arexx functions of SongPlayer */

MYPORT = 'SONGPLAYER.1'

IF ~SHOW( 'P', MYPORT ) THEN DO
   SAY 'SongPlayer is not running.'
   EXIT 10
END

ADDRESS VALUE MYPORT
OPTIONS RESULTS

EXPAND ON
v = 64
DO until ( v = 0 )
   VOLUME v
   v = v - 1
END
EXPAND OFF

FILTER ON
DO until ( v = 64 )
   v = v + 1
   VOLUME v
END
FILTER OFF

b = 0
DO until ( b = -64 )
   b = b - 1
   BALANCE b
END

DO until ( b = 64 )
   b = b + 1
   BALANCE b
END

PAUSE ON
DO until ( b = 0 )
   b = b - 1
   BALANCE b
END
PAUSE OFF



