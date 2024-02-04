/* EaglePlayer - play next pattern in module */

address 'rexx_EP'

options results

status m pnr
nummer=result
if nummer == "RESULT" then
 do
  say "No Module loaded!"
  exit 0
 end
 else
  do
   status p nummer jmp
    if result == "no" then
     do
	  say "No Patternjump available!"
     end
     else
      do
	   nextpatt
	   position=result
	   say position
      end
  end

