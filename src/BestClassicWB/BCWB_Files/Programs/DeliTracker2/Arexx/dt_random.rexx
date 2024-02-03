/* DeliTracker - toggles random module */

address 'DELITRACKER'

options results


status G rmo

if result == "no" then do
	randmod yes
	say "Random is now on..."
end
else do
	randmod no
	say "Random is now off..."
end

