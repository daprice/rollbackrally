debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "Odometer"

local gfx <const> = playdate.graphics

playdate.display.setRefreshRate(50)

local odometer <const> = Odometer()
odometer:add()

maxChange = 20

function playdate.update()
	gfx.sprite.update()
	
	local change <const> = playdate.getCrankChange()
	if change ~= 0 and math.abs(change) < maxChange then
		odometer:changeValue(playdate.getCrankChange() / 5)
	elseif change ~= 0 then
		print("JAMMED")
	end
	
	if debugMode then
		playdate.drawFPS(0, 228)
	end
end