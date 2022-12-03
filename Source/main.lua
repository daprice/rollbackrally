debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "animator"
import "CoreLibs/easing"
import "Odometer"
import "cars"
import "CarScene"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(50)

local odometer <const> = Odometer()

local activeScene = CarScene(cars[1], odometer)
activeScene:start()

function playdate.update()
	activeScene:update()
	gfx.sprite.update()
	
	if debugMode then
		playdate.drawFPS(0, 228)
	end
end