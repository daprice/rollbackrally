function getQuote()
	local income <const> = gameState:getTotalIncome()
	local valueAdded <const> = gameState:getTotalValueAdded()
	local miles <const> = gameState:getTotalMilesReduced()
	local count <const> = #gameState.sales
	local brokenCars <const> = gameState:getBrokenCarCount()
	
	local quoteTable = {
		"If I wasn't honest, why would I call myself Honest Rod?",
		"Honest Rod’s Rollback Rally is by far the best game in this game jam - honest!",
	}
	
	if count == 1 then
		table.insert(quoteTable, "One down... hey, how come you only did one car? I have a whole lot!")
	end
	
	if valueAdded <= 0 then
		quoteTable = {
			"I'm not sure you're \"honest\" enough for this business."
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
	end
	
	return table.concat({ "\"", quoteTable[math.random(1, #quoteTable)], "\"\n  - Honest Rod"})
end