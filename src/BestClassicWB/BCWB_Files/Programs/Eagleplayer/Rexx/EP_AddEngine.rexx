/* EaglePlayer - start specified engine

   Syntax: rx EP_AddEngine.rexx Enginename

*/

parse arg enginename

address 'rexx_EP'

options results

ascengine enginename 1

say 'Eagleplayer: '||result
end
