debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "Odometer"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(50)

value = 0
maxChange = 20

function playdate.update()
	gfx.sprite.update()
	
	local change <const> = playdate.getCrankChange()
	if math.abs(change) < maxChange then
		value += playdate.getCrankChange() / 5
		print(value)
	else
		print("JAMMED")
	end
	
	Odometer.drawValue(value, 10, 10)
	
	if debugMode then
		playdate.drawFPS(0, 228)
	end
end