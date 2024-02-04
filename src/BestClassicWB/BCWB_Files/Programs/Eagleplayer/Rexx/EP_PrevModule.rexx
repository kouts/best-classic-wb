/* EaglePlayer - vorheriges Module in Dir-Liste laden & abspielen */

address 'rexx_EP'

options results

prevmodule

if result == "no" then do
	say "Module not loaded !"
end
else do
	say "Module loaded !"
end

