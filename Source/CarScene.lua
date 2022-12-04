import "Scene"
import "PriceSprite"

local gfx <const> = playdate.graphics

local badgeStart <const> = 70
local badgeHeight <const> = 24
local badgeSpacing <const> = 8

class("CarScene", {
	car = nil,
	odometerSprite = nil,
	nameSprite = nil,
	priceSprite = nil,
	finalPriceSprite = nil,
	slamSprite = nil,
	dashSprite = nil,
	sold = false,
	readyToContinue = false,
	badges = nil,
	startingMileage = 0,
}).extends(Scene)

function CarScene:init(car, odometerSprite, slamSprite, dashSprite)
	CarScene.super.init(self)
	self.car = table.shallowcopy(car)
	self.odometerSprite = odometerSprite
	odometerSprite:setValue(self.car.mileage)
	self.startingMileage = self.car.mileage
	
	self.nameSprite = gfx.sprite.new(getCarNameImage(self.car))
	self.nameSprite:setCenter(0, 0)
	self.nameSprite:setZIndex(2)
	
	self.priceSprite = PriceSprite(getCarPriceImage(self.car, -4))
	self.priceSprite:setCenter(0, 0)
	self.priceSprite:setZIndex(3)
	
	self.slamSprite = slamSprite
	self.dashSprite = dashSprite
	
	self.badges = table.create(3, 0)
end

function CarScene:update()
	local aPressed <const> = playdate.buttonJustPressed(playdate.kButtonA)
	local rightPressed <const> = playdate.buttonJustPressed(playdate.kButtonRight)
	
	if not self.sold then
		local change <const> = playdate.getCrankChange()
		if change ~= 0 and math.abs(change) < self.car.maxCrankChange then
			local crankMultiplier = 10
			if self.odometerSprite.value < 5000 then
				crankMultiplier = 5
			elseif self.odometerSprite.value < 1000 then
				crankMultiplier = 1
			end
			self.odometerSprite:changeValue(playdate.getCrankChange() * crankMultiplier)
		elseif change ~= 0 then
			print("JAMMED")
			-- TODO: something
		end
		
		if aPressed or rightPressed then
			self:sellCar()
		end
	elseif self.readyToContinue then
		if aPressed or rightPressed then
			self:done()
		end
	end
end

function CarScene:start()
	CarScene.super.start(self)
	self.odometerSprite:add()
	self.dashSprite:add()
	local dashPath <const> = playdate.geometry.lineSegment.new(645, 260, 400, 240)
	local dashAnimator <const> = gfx.animator.new(600, dashPath, playdate.easingFunctions.outExpo)
	self.dashSprite:setAnimator(dashAnimator)
	local odoPath <const> = playdate.geometry.lineSegment.new(400, 200, 155, 180)
	local odoAnimator <const> = gfx.animator.new(600, odoPath, playdate.easingFunctions.outExpo)
	self.odometerSprite:setAnimator(odoAnimator)
	
	self.nameSprite:add()
	local namePath <const> = playdate.geometry.lineSegment.new(-20, 6, 6, 6)
	local nameAnimator <const> = gfx.animator.new(360, namePath, playdate.easingFunctions.outQuad)
	self.nameSprite:setAnimator(nameAnimator)
	
	self.priceSprite:add()
	local pricePath <const> = playdate.geometry.lineSegment.new(0, -28, 10, 28)
	local priceAnimator <const> = gfx.animator.new(1200, pricePath, playdate.easingFunctions.outBounce)
	self.priceSprite:setAnimator(priceAnimator)
	
	playdate.timer.performAfterDelay(600, function()
		if not self.sold then
			ControlHint.hints.crank:moveTo(5, 205)
			ControlHint.hints.crank:add()
			local crankWidth, _ <const> = ControlHint.hints.crank:getSize()
			ControlHint.hints.aButton:moveTo(5 + crankWidth + 5, 205)
			ControlHint.hints.aButton:add()
		end
	end, self)
end

function CarScene:sellCar()
	self.sold = true
	self.car.mileage = self.odometerSprite.value
	if self.car.mileage > math.floor(Odometer.maxValue) then
		self.car.mileage = 0
	end
	self.priceSprite:crossOut()
	
	ControlHint.hints.crank:remove()
	ControlHint.hints.aButton:remove()
	
	-- show comic effect
	local slam = self.slamSprite
	playdate.timer.performAfterDelay(crossOutTime + 300, function()
		slam:moveTo(0, 0)
		slam:add()
		-- TODO: cha ching sound
	end)
	
	-- show final price
	self.finalPriceSprite = PriceSprite(getCarPriceImage(self.car, 0))
	self.finalPriceSprite:setCenter(0, 0)
	self.finalPriceSprite:setZIndex(10)
	self.finalPriceSprite:add()
	local path <const> = playdate.geometry.lineSegment.new(13, -28, 13, 30)
	local anim <const> = gfx.animator.new(1200, path, playdate.easingFunctions.outBounce, crossOutTime)
	self.finalPriceSprite:setAnimator(anim)
	
	-- show badges
	local maxTime = 1200 + crossOutTime
	if self.car.mileage < 25000 then
		table.insert(self.badges, badgeLowMileage)
	end
	if self.car.mileage < 5000 then
		table.insert(self.badges, badgeLikeNew)
	end
	if self.car.mileage < 10 then
		table.insert(self.badges, badgeNeverDriven)
	end
	if self.car.mileage > 500000 then
		table.insert(self.badges, badgeStillRuns)
	end
	if self.car.mileage == self.startingMileage then
		table.insert(self.badges, badgeMustSell)
	end
	for b = 1, #self.badges do
		local badgeY <const> = badgeStart + (b-1) * (badgeSpacing + badgeHeight)
		local badgePath <const> = playdate.geometry.lineSegment.new(-177, badgeY, 0, badgeY)
		local animTime <const> = crossOutTime + 1000 + (b - 1) * 200
		local badgeAnim <const> = gfx.animator.new(800, badgePath, playdate.easingFunctions.outSine, animTime)
		if animTime+ 800 > maxTime then
			maxTime = animTime + 800
		end
		self.badges[b]:setAnimator(badgeAnim)
		self.badges[b]:add()
	end
	
	playdate.timer.performAfterDelay(maxTime, function()
		self.readyToContinue = true
		ControlHint.hints.nextCar:moveTo(5, 205)
		ControlHint.hints.nextCar:add()
	end, self)
end

function CarScene:done()
	self.readyToContinue = false
	ControlHint.hints.nextCar:remove()
	
	local cleanUpLeft <const> = {
		self.nameSprite,
		self.priceSprite,
		self.finalPriceSprite,
		self.slamSprite,
		table.unpack(self.badges)
	}
	local cleanUpRight <const> = {
		self.dashSprite,
		self.odometerSprite,
	}
	
	for l = 1, #cleanUpLeft do
		local line <const> = playdate.geometry.lineSegment.new(cleanUpLeft[l].x, cleanUpLeft[l].y, cleanUpLeft[l].x - 400, cleanUpLeft[l].y)
		local anim <const> = gfx.animator.new(500, line, playdate.easingFunctions.inSine)
		cleanUpLeft[l]:setAnimator(anim)
	end
	for r = 1, #cleanUpRight do
		local line <const> = playdate.geometry.lineSegment.new(cleanUpRight[r].x, cleanUpRight[r].y, cleanUpRight[r].x + 400, cleanUpRight[r].y)
		local anim <const> = gfx.animator.new(500, line, playdate.easingFunctions.inSine)
		cleanUpRight[r]:setAnimator(anim)
	end
	
	playdate.timer.performAfterDelay(800, function()
		self:finish({table.unpack(cleanUpLeft), table.unpack(cleanUpRight)})
	end, self)
end

function CarScene:finish(spritesToClean)
	-- clean up sprites, move to next scene
	for s = 1, #spritesToClean do
		spritesToClean[s]:remove()
	end
	
	activeCarIndex += 1
	local nextScene = CarScene(cars[activeCarIndex], self.odometerSprite, self.slamSprite, self.dashSprite)
	nextScene:start()
	activeScene = nextScene
end