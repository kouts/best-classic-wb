/* DeliTracker remote Conotrol (written for Testpurposes) */
/* This is a script for controlling Delitracker from CLI  */


address 'DELITRACKER'

predefined = 'Data:Modules/NoiseTracker/mod.Enola Gay'
qf=0

do until qf=1 

     say
     say " DeliTracker remote Controllpanel "
     say
     say " Play Faster		[+]	Play Slower		[-]"
     say " Next Song		[6]	Prev Song		[4]"
     say " Next Subsong		[3]	Prev Subsong		[1]"
     say " Next Pattern		[9]	Prev Pattern		[7]" 
     say " Open windows		[5]	Close windows		[8]"
     say " Volume Slide		[[]	Balance Slide		[]]"
     say " Select Module(s)	[*]	Play predefined		[\]"
     say " Predefine		[/]	Quit DeliTracker     	[.]"
     say

     say 'Your choice > ' ; pull Input

     if Input = '+' then faster

     if Input = '-' then slower

     if Input = '6' then nextsong

     if Input = '4' then prevsong

     if Input = '3' then nextsubsong

     if Input = '1' then prevsubsong

     if Input = '9' then nextpattern

     if Input = '7' then prevpattern

     if Input = '5' then showgui

     if Input = '8' then hidegui

     if Input = '*' then playmod

     if Input = '\' then playmod predefined

     if Input = '.' then do
			   quit
			   qf=1
     			 end

     if Input = '/' then do
		      say "Song>"
		      pull predefined
		      end

     if Input = '[' then do
		      do Volume = 32 to 64
     			 'Volume' Volume
   		      end Volume
   		      do Volume = 64 to 0 by -1
     			 'Volume' Volume
   		      end Volume
   		      do Volume = 0 to 64
     			 'Volume' Volume
   		      end Volume
		    end

     if Input = ']' then do
		      do Balance = 64 to -64 by -1
     			 'Balance' Balance
   		      end Balance
		      do Balance = -64 to 64
     			 'Balance' Balance
   		      end Balance
		      do Balance = 64 to 0 by -1
     			 'Balance' Balance
   		      end Balance
		    end

end

