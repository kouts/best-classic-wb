/* DeliTracker - toggles filter */

address 'DELITRACKER'

options results


status G led

if result == "no" then do
	filter yes
	say "Filter is now on..."
end
else do
	filter no
	say "Filter is now off..."
end

