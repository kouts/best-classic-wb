/* start DeliTracker */

if show('P','DELITRACKER') == '0' then do

  address 'COMMAND'

  "run <>NIL: Data:DeliTracker2"

  "waitforport DELITRACKER"

end

say 'DeliTracker is running'

