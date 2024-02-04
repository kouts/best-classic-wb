/* EaglePlayer - Stop Playing */

address 'rexx_EP'

options results
status G fil

if result == "no" then do
	say "No Module loaded !"
end
else do

 status G ply

 if result == "no" then do
	say "Eagleplayer doesn`t play anyway at the moment!"
 end
 else
	Stop
	say "Playing now stopped !"
 end

end