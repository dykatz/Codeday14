require 'misc.serial'
require 'misc.compress'

local gs = require 'hump.gamestate'
local lf = require 'loveframes'
local sti = require 'sti'

game = {}

function game:enter(from, name)
	lf.SetState 'game'
	game.ui = {}

	local quickbar = lf.Create('frame'):SetName('Quick Bar'):ShowCloseButton(false):SetPos(5, 495):SetState('game'):SetSize(400, 100)

	local launchbadge = lf.Create('button', quickbar):SetText('Manage Badges'):SetSize(190, 25):SetPos(5, 70)
	function launchbadge:OnClick()
		local badgemanager = lf.Create('frame'):SetName('Badge Manager'):SetState('game'):SetSize(400, 400):Center()
	end

	local exitgame = lf.Create('button', quickbar):SetText('Exit Game'):SetSize(95, 25):SetPos(200, 70)
	function exitgame:OnClick()
		game:save()
		gs.switch(menu)
		quickbar:Remove()
	end

	if love.filesystem.isFile('saves/' .. name) then
		game.data = deserialize(love.filesystem.read('saves/' .. name))
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
	for v, k in pairs(game.data) do
		print(v, k)
	end

	game.data.lastopened = os.date()
	love.filesystem.write('saves/' .. game.data.name, serialize(game.data))
end
