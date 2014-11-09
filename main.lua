require 'sti'
require 'menu'
require 'game'

local lf = require 'loveframes'
local gs = require 'hump.gamestate'

function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(51, 77, 77)

	gs.registerEvents()
	gs.switch(menu)
end

function love.update(dt)
	lf.update(dt)
end
                 
function love.draw()
	lf.draw()
end
 
function love.mousepressed(x, y, button)
	lf.mousepressed(x, y, button)
end
 
function love.mousereleased(x, y, button)
	lf.mousereleased(x, y, button)
end
 
function love.keypressed(key, unicode)
	lf.keypressed(key, unicode)
end
 
function love.keyreleased(key)
	lf.keyreleased(key)
end

function love.textinput(text)
	lf.textinput(text)
end
