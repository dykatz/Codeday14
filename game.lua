require 'misc.tserial'

local lf = require 'loveframes'
local sti = require 'sti'

game = {}

function game:enter(from, name)
	lf.SetState 'game'

	if love.filesystem.isFile('saves/' .. name) then
		game.data = Tserial.unpack(love.filesystem.read('saves/' .. name))
	end

	game.phyworld = love.physics.newWorld(0, 0)
	game.tiledworld = sti.new 'art/GameMap'
	game.tiledworld:initWorldCollision(game.phyworld)
end

function game.update(dt)
	game.tiledworld:update(dt)
end

function game.draw()
	game.tiledworld:draw()
end

function game.save()

end
