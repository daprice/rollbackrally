debugMode = true

function playdate.keyPressed(key)
	if key == 't' then
		print("Finishing game time immediately!")
		gameState.timer.duration = 1
	end
end