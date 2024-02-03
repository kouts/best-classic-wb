/* DeliTracker - toggles quickstart */

address 'DELITRACKER'

options results


status G qst

if result == "no" then do
	quick yes
	say "Quickstart is now on..."
end
else do
	quick no
	say "Quickstart is now off..."
end

