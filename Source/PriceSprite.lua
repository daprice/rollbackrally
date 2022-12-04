local gfx <const> = playdate.graphics

crossOutSample = playdate.sound.sampleplayer.new("assets/sounds/pen")

crossOutTime = 800

class("PriceSprite", {
	crossOutAnimator = nil,
}).extends(gfx.sprite)

function PriceSprite:init(img)
	PriceSprite.super.init(self, img)
end

function PriceSprite:crossOut()
	local width, _ <const> = self:getSize()
	self.crossOutAnimator = gfx.animator.new(crossOutTime, 6, width - 6, playdate.easingFunctions.inQuad)
	
	crossOutSample:setRate(0.3)
	crossOutSample:play()
end

function PriceSprite:update()
	if self.crossOutAnimator and not self.crossOutAnimator:ended() then
		local _, height <const> = self:getSize()
		local endPoint <const> = self.crossOutAnimator:currentValue()
		local line <const> = playdate.geometry.lineSegment.new(6, height/2, endPoint, height/2)
		gfx.pushContext(self:getImage())
		gfx.setColor(gfx.kColorBlack)
		gfx.setLineWidth(6)
		gfx.setLineCapStyle(gfx.kLineCapStyleRound)
		gfx.drawLine(line)
		gfx.popContext()
		self:markDirty()
	end
end