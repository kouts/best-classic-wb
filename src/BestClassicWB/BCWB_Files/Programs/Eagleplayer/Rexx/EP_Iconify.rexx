/* Eagleplayeransteuerung über Diropus
   (c) 1993-96 DEFECT
   Aktiviert den IconifyModus
*/

parse arg Zustand

if zustand="" then zustand=-1

options results
if (pos('rexx_EP',SHOW('Ports')) = 0) then 
 do
  address 'DOPUS.1'
  toptext 'No Eagleplayer found'
  exit
 end
address 'rexx_EP'
iconify zustand
AHA=result
address 'DOPUS.1'
toptext 'Eagleplayer: '||AHA
exit
