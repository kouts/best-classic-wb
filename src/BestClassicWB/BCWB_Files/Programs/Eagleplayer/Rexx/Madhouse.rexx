/* Eagleplayer-Madhouse Ansteuerung */

parse arg filename

options results

address 'rexx_EP'

status g ply

if result=yes then exit

LoadModule filename
aha=result
exit
