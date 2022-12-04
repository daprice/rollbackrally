local gameLength <const> = 3 * 60 * 1000

class("GameState", {
	cars = nil,
	activeCarIndex = 1,
	sales = nil,
	timer = nil,
}).extends()

function GameState:init()
	self.cars = table.shallowcopy(cars)
	self:shuffleCars(false)
	self.sales = table.create(10, 0)
	self.timer = playdate.timer.new(gameLength)
	self.timer.discardOnCompletion = false
end

function GameState:shuffleCars(randomizeAttributes)
	for c = 1, #self.cars do
		self.cars[c].rand = math.random()
		if randomizeAttributes then
			self.cars[c].mileage = math.random(20000, 500000) + math.random()
			self.cars[c].year = math.random(1955, 1993)
		end
	end
	table.sort(self.cars, function(c1, c2)
		return c1.rand < c2.rand
	end)
end

function GameState:getActiveCar()
	return self.cars[self.activeCarIndex]
end

function GameState:nextCar()
	self.activeCarIndex += 1
	if self.activeCarIndex > #self.cars then
		self.activeCarIndex = 1
		self:shuffleCars(true)
	end
end

function GameState:registerSale(originalPrice, finalPrice, milesReduced, car)
	table.insert(self.sales, {
		originalPrice = originalPrice,
		finalPrice = finalPrice,
		milesReduced = milesReduced,
		valueAdded = finalPrice - originalPrice,
		car = table.shallowcopy(car),
	})
end