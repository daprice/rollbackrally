debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "animator"
import "CoreLibs/easing"
import "CoreLibs/timer"
import "Odometer"
import "cars"
import "CarScene"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(50)

local odometer <const> = Odometer()
odometer:setZIndex(3)

local slamImage <const> = gfx.image.new("assets/images/Slam")
local slam <const> = gfx.sprite.new(slamImage)
slam:setCenter(0, 0)
slam:setZIndex(9)
slam:moveTo(0, 0)

local dashImage <const> = gfx.image.new("assets/images/Dashboard")
local dash <const> = gfx.sprite.new(dashImage)
dash:setCenter(1, 1)
dash:setZIndex(2)

local activeScene = CarScene(cars[1], odometer, slam, dash)
activeScene:start()

function playdate.update()
	activeScene:update()
	playdate.timer.updateTimers()
	gfx.sprite.update()
	
	if debugMode then
		playdate.drawFPS(0, 228)
	end
end