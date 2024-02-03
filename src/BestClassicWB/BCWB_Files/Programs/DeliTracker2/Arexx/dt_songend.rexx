/* DeliTracker - toggles songend */

address 'DELITRACKER'

options results


status G end

if result == "no" then do
	SongEnd yes
	say "Songend is now on..."
end
else do
	SongEnd no
	say "Songend is now off..."
end

