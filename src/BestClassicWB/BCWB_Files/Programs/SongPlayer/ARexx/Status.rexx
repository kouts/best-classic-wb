/* Simple rexx test file for SongPlayer */

options results
options FailAt 100
address 'SONGPLAYER.1'

drop result
get_time
secs = result
get_selected
sel = result
get_state
sta = result
say 'time='secs' secs  state='sta'  selected='sel

exit
