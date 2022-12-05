import "Scene"
import "PriceSprite"

local gfx <const> = playdate.graphics

chaching = playdate.sound.sampleplayer.new('assets/sounds/chaching')
local breakSound <const> = playdate.sound.sampleplayer.new('assets/sounds/breakage')
local brokenSound <const> = playdate.sound.sampleplayer.new('assets/sounds/grind')
brokenSound:setVolume(0.38)
local damageSound <const> = playdate.sound.sampleplayer.new('assets/sounds/flap')
local windingSound <const> = playdate.sound.sampleplayer.new('assets/sounds/winding')
windingSound:setVolume(0.6)
local woosh <const> = playdate.sound.sampleplayer.new('assets/sounds/woosh')
woosh:setVolume(0.6)
local woosh2 <const> = playdate.sound.sampleplayer.new('assets/sounds/woosh2')
woosh2:setVolume(0.6)
local whistle <const> = playdate.sound.sampleplayer.new('assets/sounds/whistle')
whistle:setVolume(0.4)

local badgeStart <const> = 70
local badgeHeight <const> = 24
local badgeSpacing <const> = 8

class("CarScene", {
	car = nil,
	nameSprite = nil,
	priceSprite = nil,
	finalPriceSprite = nil,
	carSprite = nil,
	sold = false,
	readyToContinue = false,
	timeIsUp = false,
	brokenHintShown = false,
	badges = nil,
	startingMileage = 0,
	startingPrice = 0,
	finalPrice = 0,
}).extends(Scene)

function CarScene:init(car)
	CarScene.super.init(self)
	self.car = table.shallowcopy(car)
	odometerSprite = odometerSprite
	odometerSprite:setValue(self.car.mileage)
	self.startingMileage = self.car.mileage
	self.startingPrice = getCarValue(self.startingMileage)
	
	self.nameSprite = gfx.sprite.new(getCarNameImage(self.car))
	self.nameSprite:setCenter(0, 0)
	self.nameSprite:setZIndex(2)
	
	self.priceSprite = PriceSprite(getCarPriceImage(self.car, -4))
	self.priceSprite:setCenter(0, 0)
	self.priceSprite:setZIndex(3)
	
	self.carSprite = gfx.sprite.new(self.car.img)
	self.carSprite:setZIndex(1)
	
	slamSprite = slamSprite
	dashSprite = dashSprite
	
	self.badges = table.create(3, 0)
end

function CarScene:update()
	local aPressed <const> = playdate.buttonJustPressed(playdate.kButtonA)
	local rightPressed <const> = playdate.buttonJustPressed(playdate.kButtonRight)
	
	if gameState.timer.timeLeft <= 0 then
		self:timeUp()
	end
	
	if not self.sold then
		local change <const> = playdate.getCrankChange()
		if self.car.durability > 0 then
			if change ~= 0 and math.abs(change) < self.car.maxCrankChange then
				playdate.display.setOffset(0, 0)
				local crankMultiplier = 10
				if odometerSprite.value < 1000 or odometerSprite.value > Odometer.maxValue - 1000 then
					crankMultiplier = 1
				elseif odometerSprite.value < 5000 then
					crankMultiplier = 5
				end
				odometerSprite:changeValue(playdate.getCrankChange() * crankMultiplier)
				
				-- adjustment sound
				if not windingSound:isPlaying() then
					windingSound:play(0)
				end
				windingSound:setRate(math.max(0.8, math.abs(change) / 10))
				
				-- cranking forward should reduce durability always
				if change > 0 then
					self.car.durability -= change
					if not damageSound:isPlaying() then
						damageSound:play(0)
					end
					damageSound:setRate(math.max(1.5, ( (math.abs(change) / 40) + 1 ) / 2))
				else
					damageSound:stop()
				end
			elseif change ~= 0 then
				-- cranking too fast
				windingSound:stop()
				local absChange <const> = math.abs(change)
				self.car.durability -= absChange
				if not damageSound:isPlaying() then
					damageSound:play(0)
				end
				damageSound:setRate(math.max(2, ( (math.abs(change) / 40) + 1 ) / 2))
				playdate.display.setOffset(math.random(-1, 1), math.random(-3, 3))
			else
				playdate.display.setOffset(0, 0)
				windingSound:stop()
				damageSound:stop()
			end
			
			if self.car.durability <= 0 then
				playdate.display.setOffset(0, 0)
				breakSound:play()
				playdate.timer.performAfterDelay(500, function()
					self:odometerBroken()
				end, self)
			end
		else
			playdate.display.setOffset(0, 0)
			if damageSound:isPlaying() then
				damageSound:stop()
			end
			if windingSound:isPlaying() then
				windingSound:stop()
			end
			
			-- TODO: make the numbers twitch a bit but not really move
			if change ~= 0 then
				-- grinding sound
				if not brokenSound:isPlaying() then
					brokenSound:play(0)
				end
				brokenSound:setRate(math.max(0.7, ( (math.abs(change) / 40) + 1 ) / 2))
			else
				brokenSound:stop()
			end
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
	odometerSprite:add()
	dashSprite:add()
	local dashPath <const> = playdate.geometry.lineSegment.new(645, 260, 400, 240)
	local dashAnimator <const> = gfx.animator.new(600, dashPath, playdate.easingFunctions.outExpo)
	dashSprite:setAnimator(dashAnimator)
	local odoPath <const> = playdate.geometry.lineSegment.new(400, 200, 155, 180)
	local odoAnimator <const> = gfx.animator.new(600, odoPath, playdate.easingFunctions.outExpo)
	odometerSprite:setAnimator(odoAnimator)
	
	self.nameSprite:add()
	local namePath <const> = playdate.geometry.lineSegment.new(-20, 6, 6, 6)
	local nameAnimator <const> = gfx.animator.new(360, namePath, playdate.easingFunctions.outQuad)
	self.nameSprite:setAnimator(nameAnimator)
	
	self.priceSprite:add()
	local pricePath <const> = playdate.geometry.lineSegment.new(0, -28, 10, 28)
	local priceAnimator <const> = gfx.animator.new(1200, pricePath, playdate.easingFunctions.outBounce)
	self.priceSprite:setAnimator(priceAnimator)
	
	self.carSprite:add()
	local carPath <const> = playdate.geometry.lineSegment.new(-100, 50, 68, 110)
	local carAnimator <const> = gfx.animator.new(800, carPath, playdate.easingFunctions.inOutSine)
	self.carSprite:setAnimator(carAnimator)
	
	playdate.timer.performAfterDelay(600, function()
		if not self.sold then
			ControlHint.hints.crank:moveTo(5, 205)
			ControlHint.hints.crank:add()
			local crankWidth, _ <const> = ControlHint.hints.crank:getSize()
			ControlHint.hints.aButton:moveTo(5 + crankWidth + 5, 205)
			ControlHint.hints.aButton:add()
		end
	end, self)
	
	playdate.ui.crankIndicator:start()
	playdate.ui.crankIndicator.clockwise = false
	
	woosh:play()
end

-- called a short time after the user breaks the odometer
function CarScene:odometerBroken()
	self.brokenHintShown = true
	if not self.sold then
		ControlHint.hints.broken:add()
	end
end

function CarScene:sellCar()
	self.sold = true
	self.car.mileage = odometerSprite.value
	if self.car.mileage > math.floor(Odometer.maxValue) - 1 then
		self.car.mileage = 0
	end
	self.priceSprite:crossOut()
	self.finalPrice = getCarValue(self.car.mileage)
	gameState:registerSale(self.startingPrice, self.finalPrice, self.startingMileage - self.car.mileage, self.car)
	
	brokenSound:stop()
	damageSound:stop()
	windingSound:stop()
	
	ControlHint.hints.crank:remove()
	ControlHint.hints.aButton:remove()
	ControlHint.hints.broken:remove()
	
	-- show comic effect
	local slam = slamSprite
	playdate.timer.performAfterDelay(crossOutTime + 300, function()
		slam:moveTo(0, 0)
		slam:add()
		chaching:play()
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
		-- TODO: whoosh sound as each badge comes in
	end
	
	playdate.timer.performAfterDelay(maxTime, function()
		if gameState.timer.timeLeft > 0 then
			self.readyToContinue = true
			ControlHint.hints.nextCar:moveTo(5, 205)
			ControlHint.hints.nextCar:add()
		end
	end, self)
end

function CarScene:timeUp()
	if not self.timeIsUp then
		self.sold = true
		self.timeIsUp = true
		
		brokenSound:stop()
		damageSound:stop()
		windingSound:stop()
		
		whistle:play()
		
		ControlHint.hints.crank:remove()
		ControlHint.hints.aButton:remove()
		ControlHint.hints.broken:remove()
		ControlHint.hints.nextCar:remove()
		ControlHint.hints.timeUp:add()
		
		playdate.timer.performAfterDelay(500, function()
			self.readyToContinue = true
			ControlHint.hints.continue:moveTo(5, 205)
			ControlHint.hints.continue:add()
		end, self)
	end
end

function CarScene:done()
	self.readyToContinue = false
	ControlHint.hints.nextCar:remove()
	ControlHint.hints.broken:remove()
	ControlHint.hints.timeUp:remove()
	ControlHint.hints.continue:remove()
	
	local cleanUpLeft <const> = {
		self.nameSprite,
		self.priceSprite,
		self.finalPriceSprite,
		slamSprite,
		table.unpack(self.badges)
	}
	local cleanUpRight <const> = {
		dashSprite,
		odometerSprite,
	}
	if self.timeIsUp then
		table.insert(cleanUpRight, gameState.timerSprite)
	end
	
	for l = 1, #cleanUpLeft do
		if cleanUpLeft[l] then
			local line <const> = playdate.geometry.lineSegment.new(cleanUpLeft[l].x, cleanUpLeft[l].y, cleanUpLeft[l].x - 400, cleanUpLeft[l].y)
			local anim <const> = gfx.animator.new(500, line, playdate.easingFunctions.inSine)
			cleanUpLeft[l]:setAnimator(anim)
		end
	end
	for r = 1, #cleanUpRight do
		local line <const> = playdate.geometry.lineSegment.new(cleanUpRight[r].x, cleanUpRight[r].y, cleanUpRight[r].x + 400, cleanUpRight[r].y)
		local anim <const> = gfx.animator.new(500, line, playdate.easingFunctions.inSine)
		cleanUpRight[r]:setAnimator(anim)
	end
	
	local carLine <const> = playdate.geometry.lineSegment.new(self.carSprite.x, self.carSprite.y, 500, 300)
	local carAnim <const> = gfx.animator.new(800, carLine, playdate.easingFunctions.inOutSine)
	self.carSprite:setAnimator(carAnim)
	
	playdate.timer.performAfterDelay(900, function()
		self:finish({table.unpack(cleanUpLeft), table.unpack(cleanUpRight), self.carSprite})
	end, self)
	
	woosh2:play()
end

function CarScene:finish(spritesToClean)
	-- clean up sprites, move to next scene
	for s = 1, #spritesToClean do
		if spritesToClean[s] then
			spritesToClean[s]:remove()
		end
	end
	
	local nextScene = gameState:getNextScene()
	nextScene:start()
	activeScene = nextScene
end