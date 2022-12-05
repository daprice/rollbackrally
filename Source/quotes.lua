function getQuote()
	local income <const> = gameState:getTotalIncome()
	local valueAdded <const> = gameState:getTotalValueAdded()
	local miles <const> = gameState:getTotalMilesReduced()
	local count <const> = #gameState.sales
	local brokenCars <const> = gameState:getBrokenCarCount()
	local brandNewCars <const> = gameState:getFullyRestoredCount()
	
	local quoteTable = {
		"If I wasn't honest, why would I call myself Honest Rod?",
		"Honest Rod’s Rollback Rally is by far my favorite game in this game jam - honest!",
		"The customer is always right... to buy a car from Honest Rod's Classic Cars!",
		"I'm the founder, director, chairman, and CEO of Honest Rod's Classic Cars. What about you?",
		"You know our cars are good when the big dealerships and auto industry regulators are simultaneously upset.",
		"Those aren't angry customers, they're plants by a competitor out to get me.",
		"The mechanic down the road has stopped buying cars from me. Does he hate freedom?",
		"AutoCenter Technical Institute gave me an honorary degree for my work restoring these cars.",
		"More and more over time, as we hew closer to brand new cars, Honest Rod will earn the trust of the people.",
		"Don't trust your mechanic to inspect my cars - he's biased!",
		"Buy a car from Honest Rod and reduce your dependence on socialist public transportation.",
		"As Honest Rod pursues the goal of elevating classic cars, auto industry elite will try everything to stop that from happening.",
		"I love when people complain about my cars... after they buy one!",
		"At the end of the day, if Honest Rod's is indeed the best source for low mileage cars, more people will buy them.",
	}
	
	if count == 1 then
		quoteTable = {
			"One down... hey, how come you only did one car? I have a whole lot!",
		}
	end
	
	if valueAdded <= 0 then
		quoteTable = {
			"I'm not sure you're \"honest\" enough for this business.",
		}
	end
	
	if count == 0 then
		quoteTable = {
			"You gotta start somewhere. Somewhere else.",
		}
	end
	
	if miles < 0 then
		quoteTable = {
			"You're going nowhere in life, and backwards in this game.",
		}
	end
	
	if brokenCars / count > 0.6 then
		table.insert(quoteTable, "I'm not responsible for any damage discovered after a sale. You are.")
		table.insert(quoteTable, "Current lemon law is a massive tax on my business and desperately needs reform.")
		table.insert(quoteTable, "You break it, some sucker will buy it anyway.")
		table.insert(quoteTable, "Slow down, you're breaking the cars!")
		table.insert(quoteTable, "Crank a little slower, you're breaking the cars!")
		table.insert(quoteTable, "Slow down, you're breaking the cars!")
		table.insert(quoteTable, "Careful with that crank, you're breaking the cars!")
	end
	
	if brandNewCars >= 1 then
		table.insert(quoteTable, "If you don't believe these cars are new, just look at the odometer!")
		table.insert(quoteTable, "I started up one of the cars you worked on. What a symphony! The percussion just adds character!")
		table.insert(quoteTable, "A customer asked me to thank the person who discovered an undriven classic car. I told them 'you're welcome'!")
	end
	
	return table.concat({ "\"", quoteTable[math.random(1, #quoteTable)], "\"\n  - Honest Rod"})
end