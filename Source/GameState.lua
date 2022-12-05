local gameLength <const> = 2 * 60 * 1000 + 999

class("GameState", {
	cars = nil,
	activeCarIndex = 1,
	sales = nil,
	timer = nil,
	timerSprite = nil,
}).extends()

function GameState:init()
	self.cars = table.shallowcopy(cars)
	self:shuffleCars(false)
	self.sales = table.create(10, 0)
	self.timer = playdate.timer.new(gameLength)
	self.timer.discardOnCompletion = false
	self.timerSprite = TimerDisplay(self.timer)
	self.timerSprite:moveTo(290, 12)
	self.timerSprite:add()
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

function GameState:getNextScene()
	if self.timer.timeLeft > 0 then
		self:nextCar()
		return CarScene(self:getActiveCar())
	else
		return ScoreScene(self.sales)
	end
end

function GameState:getTotalMilesReduced()
	local miles = 0
	for s = 1, #self.sales do
		miles += self.sales[s].milesReduced
	end
	return math.floor(miles)
end

function GameState:getTotalValueAdded()
	local value = 0
	for s = 1, #self.sales do
		value += self.sales[s].valueAdded
	end
	return value
end

function GameState:getTotalIncome()
	local money = 0
	for s = 1, #self.sales do
		money += self.sales[s].finalPrice
	end
	return money
end

function GameState:getBrokenCarCount()
	local count = 0
	for c = 1, #self.sales do
		if self.sales[c].car.durability <= 0 then
			count += 1
		end
	end
	return count
end