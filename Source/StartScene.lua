import "Scene"

local gfx <const> = playdate.graphics

class("StartScene", {
	respondsToControls = false,
	buttonBlinker = nil,
}).extends(Scene)

function StartScene:init()
	StartScene.super.init(self)
end

function StartScene:update()
	StartScene.super.update(self)
	if self.respondsToControls and playdate.buttonJustReleased(playdate.kButtonA) then
		self:finish()
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
		if not playdate.getReduceFlashing() then
			self.buttonBlinker = gfx.animation.blinker.new()
			self.buttonBlinker.offDuration = 800
			self.buttonBlinker.onDuration = 1600
			self.buttonBlinker:startLoop()
		end
	end, self)
end

function StartScene:finish()
	StartScene.super.finish(self)
	ControlHint.hints.start:remove()
	gameState = GameState()
	local nextScene <const> = CarScene(gameState:getActiveCar())
	nextScene:start()
	activeScene = nextScene
end