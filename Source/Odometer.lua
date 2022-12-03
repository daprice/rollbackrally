local gfx <const> = playdate.graphics

local twoPi <const> = math.pi * 2

local maxValue <const> = 999999.999999

local odometerNumbers = gfx.imagetable.new("/assets/fonts/Roobert-24-Medium-Numerals-table-36-36")
local numberWidth, numberHeight <const> = odometerNumbers:getImage(1):getSize()
local odometerStrip = gfx.image.new(numberWidth, numberHeight * 10, gfx.kColorBlack)
gfx.pushContext(odometerStrip)
gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
for n = 1, 10 do
	odometerNumbers:drawImage(n, 0, (n - 1) * numberHeight)
end
gfx.popContext()


class("Odometer", {
	value = 0,
}).extends(gfx.sprite)

function Odometer:init()
	Odometer.super.init(self)
	self:setImage(gfx.image.new(numberWidth * 6 + 4, numberHeight + 4, gfx.kColorWhite))
	self:updateImage()
	self:setOpaque(true)
	self:setCenter(0, 0)
end

function Odometer:changeValue(difference)
	self.value += difference
	if self.value < 0 then
		self.value += maxValue
	elseif self.value > maxValue then
		self.value -= maxValue
	end
	self:updateImage()
end

function Odometer:updateImage()
	gfx.pushContext(self:getImage())
	Odometer.drawAll(self.value, 0, 0)
	gfx.popContext()
	self:markDirty()
end

function Odometer.drawAll(value, x, y)
	gfx.setColor(gfx.kColorWhite)
	gfx.drawRect(x, y, numberWidth * 6 + 4, numberHeight + 4)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x + 1, y + 1, numberWidth * 6 + 2, numberHeight + 2)
	Odometer.drawValue(value, x+2, y+2)
	gfx.setDitherPattern(0.75)
	gfx.fillRect(x + 2, numberHeight - 5, numberWidth * 6, 3)
	gfx.fillRect(x + 2, 2, numberWidth * 6, 3)
	gfx.setDitherPattern(0.5)
	gfx.fillRect(x + 2, numberHeight - 2, numberWidth * 6, 4)
end


function Odometer.drawValue(value, x, y)
	local placeValues <const> = {
		(value % 1000000) / 100000,
		(value % 100000)  / 10000,
		(value % 10000)   / 1000,
		(value % 1000)    / 100,
		(value % 100)     / 10,
		(value % 10),
	}
	
	for d = 1, 6 do
		Odometer.drawDigit(placeValues[d], (d-1) * numberWidth + x, y, d)
	end
end

function Odometer.drawDigit(digitValue, x, y, place)
	local position = numberHeight * digitValue
	if place ~= 6 then
		local position1 = (digitValue + (math.sin((digitValue) * twoPi) / 7))
		for _ = 1, 6 - place do
			position1 = (position1 + (math.sin((position1) * twoPi) / 7))
		end
		position = numberHeight * (position1 - 0.48 + (math.sin((position1) * twoPi) / 7))
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	else
		gfx.setImageDrawMode(gfx.kDrawModeInverted)
	end
	
	if position < 0 then
		position += 10 * numberHeight
	end
	
	odometerStrip:draw(x, y, nil, 0, position, numberWidth, numberHeight)
	if position + numberHeight > numberHeight * 10 then
		odometerStrip:draw(x, y, nil, 0, position - (numberHeight * 10), numberWidth, numberHeight)
	end
end