import "Scene"

local gfx <const> = playdate.graphics

local logoImg <const> = gfx.image.new('assets/images/logo')
local checkeredImg <const> = gfx.image.new('assets/images/checkered')

class("StartScene", {
	respondsToControls = false,
	buttonBlinker = nil,
	topCheckerSprite = nil,
	bottomCheckerSprite = nil,
	logoSprite = nil,
}).extends(Scene)

function StartScene:init()
	StartScene.super.init(self)
	self.logoSprite = gfx.sprite.new(logoImg)
	self.topCheckerSprite = gfx.sprite.new(checkeredImg)
	self.topCheckerSprite:setCenter(0, 0)
	self.topCheckerSprite:setOpaque(true)
	self.bottomCheckerSprite = gfx.sprite.new(checkeredImg)
	self.bottomCheckerSprite:setCenter(0, 1)
	self.bottomCheckerSprite:setOpaque(true)
end

function StartScene:update()
	StartScene.super.update(self)
	if self.respondsToControls and playdate.buttonJustReleased(playdate.kButtonA) then
		self:done()
	end
	if self.buttonBlinker then
		ControlHint.hints.start:setVisible(self.buttonBlinker.on)
	end
end

function StartScene:start()
	StartScene.super.start(self)
	playdate.timer.performAfterDelay(200, function()
		self.respondsToControls = true
		ControlHint.hints.start:add()
		local line <const> = playdate.geometry.lineSegment.new(200, 195, 200, 199)
		local anim <const> = gfx.animator.new(800, line, playdate.easingFunctions.inOutSine)
		anim.repeatCount = math.huge
		anim.reverses = true
		ControlHint.hints.start:setAnimator(anim)
	end, self)
	
	self.logoSprite:moveTo(200, 119)
	self.logoSprite:add()
	
	local topLine <const> = playdate.geometry.lineSegment.new(0, 0, -20, 0)
	local topAnim <const> = gfx.animator.new(1000, topLine)
	topAnim.repeatCount = math.huge
	self.topCheckerSprite:setAnimator(topAnim)
	self.topCheckerSprite:add()
	
	local bottomLine <const> = playdate.geometry.lineSegment.new(-20, 240, 0, 240)
	local bottomAnim <const> = gfx.animator.new(1000, bottomLine)
	bottomAnim.repeatCount = math.huge
	self.bottomCheckerSprite:setAnimator(bottomAnim)
	self.bottomCheckerSprite:add()
end

function StartScene:done()
	self.respondsToControls = false
	ControlHint.hints.start:remove()
	
	local topLine <const> = playdate.geometry.lineSegment.new(self.topCheckerSprite.x, self.topCheckerSprite.y, self.topCheckerSprite.x, -200)
	local bottomLine <const> = playdate.geometry.lineSegment.new(self.bottomCheckerSprite.x, self.bottomCheckerSprite.y, self.bottomCheckerSprite.x, 600)
	local logoLine <const> = playdate.geometry.lineSegment.new(self.logoSprite.x, self.logoSprite.y, self.logoSprite.x, self.logoSprite.y - 600)
	
	local topAnim <const> = gfx.animator.new(1000, topLine, playdate.easingFunctions.inQuad)
	local bottomAnim <const> = gfx.animator.new(1000, bottomLine, playdate.easingFunctions.inQuad)
	local logoAnim <const> = gfx.animator.new(1000, logoLine, playdate.easingFunctions.inQuad)
	
	self.topCheckerSprite:setAnimator(topAnim)
	self.bottomCheckerSprite:setAnimator(bottomAnim)
	self.logoSprite:setAnimator(logoAnim)
	
	playdate.timer.performAfterDelay(1200, function()
		self:finish()
	end, self)
end

function StartScene:finish()
	StartScene.super.finish(self)
	ControlHint.hints.start:remove()
	self.topCheckerSprite:remove()
	self.bottomCheckerSprite:remove()
	self.logoSprite:remove()
	gameState = GameState()
	local nextScene <const> = CarScene(gameState:getActiveCar())
	nextScene:start()
	activeScene = nextScene
end