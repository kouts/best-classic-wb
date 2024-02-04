/* EaglePlayer - play previous subsong in module */

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
	  say "No SubSongs available!"
     end
     else
      do
	   prevsong
	   song=result
	   say song
      end
  end

