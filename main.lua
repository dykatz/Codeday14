require 'sti'
require 'menu'
require 'game'

local gs = require 'hump.gamestate'

function love.load()
	gs.registerEvents()
	gs.switch(menu)
end

function love.update(dt)
	loveframes.update(dt)
end
                 
function love.draw()
	loveframes.draw()
end
 
function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end
 
function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end
 
function love.keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
end
 
function love.keyreleased(key)
	loveframes.keyreleased(key)
end

function love.textinput(text)
	loveframes.textinput(text)
end