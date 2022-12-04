local gfx <const> = playdate.graphics
local e <const> = 2.71828

nameFont = gfx.font.new("assets/fonts/font-pedallica")
nameFont:setTracking(1)

priceFont = gfx.font.new("assets/fonts/Raspberry Numeral 19")

cars = {
	{
		model = "Burton Badger",
		year = 1987,
		mileage = 89710.4,
		maxCrankChange = 21,
		durability = 720,
	},
	{
		model = "Brickle Sparrow",
		year = 1976,
		mileage = 253291.4,
		maxCrankChange = 18,
		durability = 360,
	},
	{
		model = "Elgor Escapade",
		year = 1982,
		mileage = 192856,
		maxCrankChange = 18,
		durability = 360,
	},
	{
		model = "Curblick El Tronado",
		year = 1968,
		mileage = 67502,
		maxCrankChange = 22,
		durability = 360,
	},
	{
		model = "Coyote 208",
		year = 1971,
		mileage = 110402.3,
		maxCrankChange = 20,
		durability = 360,
	},
	{
		model = "Wimbleston Phoenicial",
		year = 1991,
		mileage = 26127.1,
		maxCrankChange = 16,
		durability = 360,
	},
	{
		model = "Star Van Max-E",
		year = 1987,
		mileage = 591221.6,
		maxCrankChange = 19,
		durability = 360,
	},
	{
		model = "Pygmalion Pillbug",
		year = 1957,
		mileage = 89613.2,
		maxCrankChange = 19,
		durability = 360,
	},
	{
		model = "Neptune Quasar",
		year = 1974,
		mileage = 19449.8,
		maxCrankChange = 17,
		durability = 360,
	},
}

function getCarValue(mileage)
	local maxPrice <const> = 16000 - 101 -- 15999 max with the 100 base price
	return math.floor(maxPrice * (e ^ (-mileage / 40000)) + 100)
end

function getCarNameImage(car)
	local text <const> = table.concat({ string.format("%d", car.year), ' ', car.model })
	return getNameImage(text)
end

function getNameImage(text)
	local height <const> = nameFont:getHeight()
	local width <const> = nameFont:getTextWidth(text)
	local img = gfx.image.new(width, height, gfx.kColorClear)
	gfx.pushContext(img)
	nameFont:drawText(text, 0, 0)
	gfx.popContext()
	return img
end

function getCarPriceImage(car, angle)
	return getPriceImage(getCarValue(car.mileage), angle)
end

function getPriceImage(price, angle)
	local priceText = "$" .. string.format("%d", price)
	local height <const> = priceFont:getHeight()
	local width <const> = priceFont:getTextWidth(priceText)
	local img = gfx.image.new(width, height, gfx.kColorClear)
	gfx.pushContext(img)
	priceFont:drawText(priceText, 0, 0)
	gfx.popContext()
	return img:rotatedImage(angle)
end