local sti = require 'sti'
require 'menu'
require 'game'

local lf = require 'loveframes'
local gs = require 'hump.gamestate'

function love.load()
	love.physics.setMeter(32)
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(51, 77, 77)

	gs.registerEvents()
	gs.switch(menu)
	
	 map = sti.new("art/GameMap")

    -- Create a custom layer
    map:addCustomLayer("Sprite Layer", 2)

    -- Create a local shortcut to work with
    local spriteLayer = map.layers["WalkThroughable village"]

    -- Add custom data
    spriteLayer.sprites = {}

    -- Create some data
    local sprite = {
        image = love.graphics.newImage("art/AdventureTileset/guy.png"),
        x = 128,
        y = 128,
        r = 0
    }

    -- Insert the data into the layer
    table.insert(spriteLayer.sprites, sprite)

    -- Override draw callback
    function spriteLayer:draw()
        -- Draw the sprites
        for _, sprite in ipairs(self.sprites) do
            love.graphics.draw(sprite.image, math.floor(sprite.x), math.floor(sprite.y), sprite.r)
        end
    end
end

function love.update(dt)
	lf.update(dt)
	map:update(dt)
end
                 
function love.draw()
	lf.draw()
	map:draw()
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
