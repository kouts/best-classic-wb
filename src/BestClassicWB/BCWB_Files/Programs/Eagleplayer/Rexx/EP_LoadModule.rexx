/* EaglePlayer - LOAD required module and play it

   alternative: 
   call 'Eagleplayer loadmodule="..."' from shell 
*/

parse arg filename

address 'rexx_EP'

options results

Loadmodule filename

if result == "no" then do
	say "Module not loaded!"
end
else do
	say "Module loaded!"
end


