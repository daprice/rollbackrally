local gfx <const> = playdate.graphics

local timerFont <const> = gfx.font.new("assets/fonts/Seven Segment 39")

class("TimerDisplay", {
	timer = nil,
	separatorBlinker = nil,
	lastDrawnMs = 0,
}).extends(gfx.sprite)

function TimerDisplay:init(timer)
	self.timer = timer
	self.separatorBlinker = gfx.animation.blinker.new()
	self.separatorBlinker.onDuration = 500
	self.separatorBlinker.offDuration = 500
	self.separatorBlinker:startLoop()
	
	local height <const> = timerFont:getHeight()
	local width <const> = timerFont:getTextWidth("00:00")
	local img <const> = gfx.image.new(width, height, gfx.kColorClear)
	TimerDisplay.super.init(self, img)
	self:redraw(self.timer.timeLeft)
	self:setCenter(0, 0)
end

function TimerDisplay:redraw(msLeft)
	local img <const> = self:getImage()
	local separator = ":"
	if not self.separatorBlinker.on then
		separator = ";"
	end
	local secondsLeft <const> = math.floor((msLeft / 1000) % 60)
	local minutesLeft <const> = math.floor((msLeft / 1000) / 60)
	local secondsString = tostring(secondsLeft)
	local minutesString = tostring(minutesLeft)
	if #secondsString == 1 then
		secondsString = table.concat({ "0", secondsString })
	end
	if #minutesString == 1 then
		minutesString = table.concat({ " ", minutesString })
	end
	img:clear(gfx.kColorClear)
	gfx.pushContext(img)
	gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	timerFont:drawText(table.concat({ minutesString, separator, secondsString }), 0, 0)
	gfx.popContext()
	self:markDirty()
	self.lastDrawnMs = msLeft
end

function TimerDisplay:update()
	local msLeft <const> = self.timer.timeLeft
	if math.abs(msLeft - self.lastDrawnMs) > 500 then
		self:redraw(msLeft)
	end
end