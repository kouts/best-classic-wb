/* EaglePlayer - play next subsong in module */

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
   status p nummer sub
    if result == "no" then
     do
	  say "No subsongs available!"
     end
     else
      do
	   nextsong
	   song=result
	   say song
      end
  end
