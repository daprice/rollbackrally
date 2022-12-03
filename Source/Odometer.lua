local gfx <const> = playdate.graphics

local twoPi <const> = math.pi * 2

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
	miles = 0,
}).extends(gfx.sprite)

function Odometer:init()
	Odometer.super.init(self)
end

function Odometer.drawValue(value)
	local placeValues <const> = {
		(value % 1000000) / 100000,
		(value % 100000)  / 10000,
		(value % 10000)   / 1000,
		(value % 1000)    / 100,
		(value % 100)     / 10,
		(value % 10),
	}
	
	for d = 1, 6 do
		Odometer.drawDigit(placeValues[d], (d-1) * numberWidth, 0, d)
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
	end
	
	if position < 0 then
		position += 10 * numberHeight
	end
	
	odometerStrip:draw(x, y, nil, 0, position, numberWidth, numberHeight)
	if position + numberHeight > numberHeight * 10 then
		odometerStrip:draw(x, y, nil, 0, position - (numberHeight * 10), numberWidth, numberHeight)
	end
end