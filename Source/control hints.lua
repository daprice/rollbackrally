local gfx <const> = playdate.graphics

local pillNineSlice = gfx.nineSlice.new("assets/images/pill", 4, 4, 8, 8)

local hintFont <const> = gfx.getSystemFont()
local padding <const> = 4

class("ControlHint").extends(gfx.sprite)

function ControlHint:init(text)
	local textHeight <const> = hintFont:getHeight()
	local textWidth <const> = hintFont:getTextWidth(text)
	local img <const> = gfx.image.new(textWidth + padding*2, textHeight + padding*2, gfx.kColorClear)
	gfx.pushContext(img)
	pillNineSlice:drawInRect(0, 0, img:getSize())
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	hintFont:drawText(text, 4, 4)
	gfx.popContext()
	ControlHint.super.init(self, img)
	self:setZIndex(100)
end

ControlHint.hints = {}

ControlHint.hints.crank = ControlHint("🎣 Wind")
ControlHint.hints.crank:setCenter(0, 0)

ControlHint.hints.aButton = ControlHint("Ⓐ Sell")
ControlHint.hints.aButton:setCenter(0, 0)