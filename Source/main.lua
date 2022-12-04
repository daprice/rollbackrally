debugMode = true

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "animator"
import "CoreLibs/easing"
import "CoreLibs/timer"
import "CoreLibs/nineslice"
import "Odometer"
import "cars"
import "CarScene"
import "control hints"

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

local badgeLikeNewImg <const> = gfx.image.new("assets/images/badge - Like new")
local badgeMustSellImg <const> = gfx.image.new("assets/images/badge - Must sell")
local badgeNeverDrivenImg <const> = gfx.image.new("assets/images/badge - Never driven")
local badgeLowMileageImg <const> = gfx.image.new("assets/images/badge - Low mileage")
local badgeStillRunsImg <const> = gfx.image.new("assets/images/badge - Still runs")
badgeLikeNew = gfx.sprite.new(badgeLikeNewImg)
badgeLikeNew:setCenter(0, 0)
badgeLikeNew:setZIndex(10)
badgeLikeNew:setOpaque(true)
badgeMustSell = gfx.sprite.new(badgeMustSellImg)
badgeMustSell:setCenter(0, 0)
badgeMustSell:setZIndex(10)
badgeMustSell:setOpaque(true)
badgeNeverDriven = gfx.sprite.new(badgeNeverDrivenImg)
badgeNeverDriven:setCenter(0, 0)
badgeNeverDriven:setZIndex(10)
badgeNeverDriven:setOpaque(true)
badgeLowMileage = gfx.sprite.new(badgeLowMileageImg)
badgeLowMileage:setCenter(0, 0)
badgeLowMileage:setZIndex(10)
badgeLowMileage:setOpaque(true)
badgeStillRuns = gfx.sprite.new(badgeStillRunsImg)
badgeStillRuns:setCenter(0, 0)
badgeStillRuns:setZIndex(10)
badgeStillRuns:setOpaque(true)

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