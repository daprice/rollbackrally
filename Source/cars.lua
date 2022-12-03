local gfx <const> = playdate.graphics
local e <const> = 2.71828

local nameFont = gfx.font.new("assets/fonts/font-pedallica")
nameFont:setTracking(1)

local priceFont = gfx.font.new("assets/fonts/Raspberry Numeral 19")

cars = {
	{
		model = "1976 Brickle Sparrow",
		mileage = 253291.4,
		maxCrankChange = 18,
	},
	{
		model = "1982 Elgor Escapade",
		mileage = 192856,
		maxCrankChange = 18,
	},
	{
		model = "1968 Curblick El Tronado",
		mileage = 67502,
		maxCrankChange = 22,
	},
	{
		model = "1971 Coyote 208",
		mileage = 110402.3,
		maxCrankChange = 20,
	},
	{
		model = "1991 Wimblesy Phoenicial",
		mileage = 56127.1,
		maxCrankChange = 16,
	},
	{
		model = "1987 Star Van Max-E",
		mileage = 591221.6,
		maxCrankChange = 19,
	},
	{
		model = "1957 Pygmalion Pillbug",
		mileage = 89613.2,
		maxCrankChange = 19,
	},
	{
		model = "1974 Neptune Quasar",
		mileage = 124749.8,
		maxCrankChange = 17,
	},
	{
		model = "1987 Burton Badger",
		mileage = 89710.4,
		maxCrankChange = 21,
	},
}

function getCarValue(mileage)
	local maxPrice <const> = 16000
	return math.floor(maxPrice * (e ^ (-mileage / 120000)))
end

function getCarNameImage(car)
	local height <const> = nameFont:getHeight()
	local width <const> = nameFont:getTextWidth(car.model)
	local img = gfx.image.new(width, height, gfx.kColorClear)
	gfx.pushContext(img)
	nameFont:drawText(car.model, 0, 0)
	gfx.popContext()
	return img
end

function getCarPriceImage(car)
	local priceText = string.format("%d", getCarValue(car.mileage))
	local height <const> = priceFont:getHeight()
	local width <const> = priceFont:getTextWidth(priceText)
	local img = gfx.image.new(width, height, gfx.kColorClear)
	gfx.pushContext(img)
	priceFont:drawText(priceText, 0, 0)
	gfx.popContext()
	return img:rotatedImage(-4)
end