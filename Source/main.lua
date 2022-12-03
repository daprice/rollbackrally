debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(30)

function playdate.update()
	gfx.sprite.update()
	if debugMode then
		playdate.drawFPS(30, 210)
	end
end