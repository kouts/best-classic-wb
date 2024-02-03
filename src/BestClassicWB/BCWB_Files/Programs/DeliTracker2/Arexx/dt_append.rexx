/* DeliTracker - toggles append */

address 'DELITRACKER'

options results


status G app

if result == "no" then do
	Append yes
	say "Append is now on..."
end
else do
	Append no
	say "Append is now off..."
end

