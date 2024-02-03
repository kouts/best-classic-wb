/* EaglePlayer - angegebenes Module laden & abspielen */

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


