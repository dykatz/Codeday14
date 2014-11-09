require 'misc.tserial'

local lf = require 'loveframes'
local sti = require 'sti'

game = {}

function game:enter(from, name)
	lf.SetState 'game'
	game.ui = {}

	lf.Create('frame'):SetName('Quick Bar'):ShowCloseButton(false):SetPos(5, 495):SetState('game'):SetSize(400, 100)

	if love.filesystem.isFile('saves/' .. name) then
		game.data = Tserial.unpack(love.filesystem.read('saves/' .. name))
	else
		game.data = {}
		game.data.name = name
		game.data.created = os.date()
	end

	game.phyworld = love.physics.newWorld(0, 0, 'dynamic')
	game.tiledworld = sti.new 'art/GameMap'
	game.tiledcollision = game.tiledworld:initWorldCollision(game.phyworld)
end

function game:update(dt)
	game.tiledworld:update(dt)
end

function game:draw()
	game.tiledworld:draw()
end

function game:save()
	game.data.location = 'world'
	game.data.lastopened = os.date()
	love.filesystem.write('saves/' .. game.data.name, Tserial.pack())
end
