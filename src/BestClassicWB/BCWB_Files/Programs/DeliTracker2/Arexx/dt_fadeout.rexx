/* DeliTracker - toggles fadeout */

address 'DELITRACKER'

options results


status G fad

if result == "no" then do
	fadeout yes
	say "Fadeout is now on..."
end
else do
	fadeout no
	say "Fadeout is now off..."
end

