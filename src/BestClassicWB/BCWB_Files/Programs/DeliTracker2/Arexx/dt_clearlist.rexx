/* DeliTracker - remove current module from modulelist */

parse arg listnum

address 'DELITRACKER'
options results

status M num
xx=result

clearlist xx

