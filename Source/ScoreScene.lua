import "cars"
import "quotes"

local gfx <const> = playdate.graphics

quoteFont = gfx.font.new('assets/fonts/font-pedallica-fun-14')

local margin <const> = 20
local padding <const> = 16
local innerPadding <const> = 4
local scoreNameHeight <const> = nameFont:getHeight()
local scoreValueHeight <const> = priceFont:getHeight()

class("ScoreScene", {
	sales = nil,
	scoresSprite = nil,
	itemsDrawn1 = 0,
	itemsDrawn2 = 0,
}).extends(Scene)

function ScoreScene:init(sales)
	ScoreScene.super.init(self)
	self.sales = sales
	local scoresImg <const> = gfx.image.new(400, 240, gfx.kColorWhite)
	self.scoresSprite = gfx.sprite.new(scoresImg)
	self.scoresSprite:setOpaque(true)
	self.scoresSprite:setCenter(0, 0)
	self.scoresSprite:moveTo(0, 0)
	self.scoresSprite:add()
end

function ScoreScene:start()
	ScoreScene.super.start(self)
	ControlHint.hints.continue:remove()
	
	playdate.timer.performAfterDelay(200, function()
		self:addScore('Vehicles sold', #self.sales, 1)
		crossOutSample:setRate(1)
		crossOutSample:play()
	end, self)
	
	playdate.timer.performAfterDelay(1000, function()
		self:addScore('Miles cranked away', gameState:getTotalMilesReduced(), 1)
		crossOutSample:setRate(1)
		crossOutSample:play()
	end, self)
	
	playdate.timer.performAfterDelay(1800, function()
		self:addScore('Value "restored"', "$" .. gameState:getTotalValueAdded(), 2)
		chaching:play()
	end, self)
	
	playdate.timer.performAfterDelay(2600, function()
		self:addScore('Total income', "$" .. gameState:getTotalIncome(), 2)
		chaching:play()
	end, self)
	
	playdate.timer.performAfterDelay(3200, function()
		gfx.pushContext(self.scoresSprite:getImage())
		gfx.setFont(quoteFont)
		gfx.drawTextInRect(getQuote(), 20, 150, 360, 80)
		gfx.popContext()
		self.scoresSprite:markDirty()
	end, self)
end

function ScoreScene:addScore(name, value, column)
	local xCenter = 100
	if column == 2 then
		xCenter = 300
	end
	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	local nameImg <const> = getNameImage(name)
	local valueImg <const> = getPriceImage(value, math.random(-4, 4))
	local startY <const> = margin + (self["itemsDrawn" .. column] * (scoreNameHeight + scoreValueHeight + padding + innerPadding))
	local targetImg <const> = self.scoresSprite:getImage()
	gfx.pushContext(targetImg)
	nameImg:draw(xCenter - nameImg.width/2, startY)
	valueImg:draw(xCenter - valueImg.width/2, startY + scoreNameHeight + innerPadding)
	gfx.popContext()
	self.scoresSprite:markDirty()
	
	self["itemsDrawn" .. column] += 1
end