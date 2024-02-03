/* Eagleplayer-Madhouse Ansteuerung */

parse arg filename

options results

address 'rexx_EP'

status g ply

if results=yes then exit

LoadModule filename
aha=result
exit
