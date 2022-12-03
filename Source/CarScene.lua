import "Scene"
import "PriceSprite"

local gfx <const> = playdate.graphics

class("CarScene", {
	car = nil,
	odometerSprite = nil,
	nameSprite = nil,
	priceSprite = nil,
	crossOutSprite = nil,
	finalPriceSprite = nil,
	slamSprite = nil,
	dashSprite = nil,
	sold = false,
}).extends(Scene)

function CarScene:init(car, odometerSprite, slamSprite, dashSprite)
	CarScene.super.init(self)
	self.car = table.shallowcopy(car)
	self.odometerSprite = odometerSprite
	odometerSprite:setValue(self.car.mileage)
	
	self.nameSprite = gfx.sprite.new(getCarNameImage(self.car))
	self.nameSprite:setCenter(0, 0)
	self.nameSprite:setZIndex(2)
	
	self.priceSprite = PriceSprite(getCarPriceImage(self.car, -4))
	self.priceSprite:setCenter(0, 0)
	self.priceSprite:setZIndex(3)
	
	self.slamSprite = slamSprite
	self.dashSprite = dashSprite
end

function CarScene:update()
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
		
		local aPressed <const> = playdate.buttonJustPressed(playdate.kButtonA)
		local rightPressed <const> = playdate.buttonJustPressed(playdate.kButtonRight)
		if aPressed or rightPressed then
			self:sellCar()
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
end

function CarScene:sellCar()
	self.sold = true
	self.car.mileage = self.odometerSprite.value
	self.priceSprite:crossOut()
	
	-- show comic effect
	local slam = self.slamSprite
	playdate.timer.performAfterDelay(crossOutTime + 300, function()
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
end