/* EaglePlayer - load and play next module from current list or directory
   (C) 1993-1997 Defect Softworks
*/

/* Arguments */

address 'rexx_EP'

options results

nextmodule

if result == "no" then do
	say "Module not loaded !"
end
else do
	say "Module loaded !"
end

