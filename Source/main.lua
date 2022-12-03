debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "Odometer"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(30)

value = 0


function playdate.update()
	gfx.sprite.update()
	
	value += playdate.getCrankChange() / 100
	print(value)
	
	Odometer.drawValue(value)
	
	if debugMode then
		playdate.drawFPS(0, 228)
	end
end