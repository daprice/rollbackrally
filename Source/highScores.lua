local data <const> = playdate.datastore
local scoreFile = 'highScores'

highScores = {
	vehiclesSold = 0,
	milesCranked = 0,
	valueRestored = 0,
	income = 0,
}

function loadHighScores()
	local loadedScores <const> = data.read(scoreFile)
	if loadedScores ~= nil then
		highScores = loadedScores
	end
end

function saveHighScores()
	data.write(highScores, scoreFile, false)
end