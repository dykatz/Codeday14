require 'misc.serial'
require 'misc.compress'
require 'misc.spritesheet'

local gs = require 'hump.gamestate'
local lf = require 'loveframes'
local sti = require 'sti'

game = {}

function game:enter(from, name)
	lf.SetState 'game'
	game.ui = {}

	local quickbar = lf.Create('frame'):SetName('Quick Bar'):ShowCloseButton(false):SetPos(5, 495):SetState('game'):SetSize(400, 100)

	lf.Create('image', quickbar):SetPos(200, 70):SetImage("art/icons/coin.png"):SetColor(255, 255, 255, 127)
	lf.Create('image', quickbar):SetPos(233, 70):SetImage("art/icons/xp.png"):SetColor(255, 255, 255, 127)
	lf.Create('image', quickbar):SetPos(267, 70):SetImage("art/icons/badge.png"):SetColor(255, 255, 255, 127)

	local launchbadge = lf.Create('button', quickbar):SetText('Manage Badges'):SetSize(190, 25):SetPos(5, 70)
	function launchbadge:OnClick()
		local badgemanager = lf.Create('frame'):SetName('Badge Manager'):SetState('game'):SetSize(400, 400):Center()

		local badgepointstotal = lf.Create('progressbar', badgemanager):SetPos(5, 30):SetSize(390, 25)
	end

	local exitgame = lf.Create('button', quickbar):SetText('Exit Game'):SetSize(95, 25):SetPos(300, 70)
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
		game.data.playerx = 2470
		game.data.playery = 550
	end

	game.phyworld = love.physics.newWorld(0, 0, 'dynamic')
	game.tiledworld = sti.new 'art/GameMap'
	game.tiledcollision = game.tiledworld:initWorldCollision(game.phyworld)

	game.tiledworld:convertToCustomLayer 'Player'

	local playerLayer = game.tiledworld.layers['Player']
	playerLayer.playerSprite = spritesheet:new(love.graphics.newImage('art/AdventureTileset/AdventureCharacter.png'))
	playerLayer.playerSprite:addAnimation('down')(0, 0, 32, 44)(32, 0, 32, 44)(64, 0, 32, 44)
	playerLayer.playerSprite:addAnimation('left')(0, 48, 32, 44)(32, 48, 32, 44)(64, 48, 32, 44)
	playerLayer.playerSprite:addAnimation('right')(0, 96, 32, 44)(32, 96, 32, 44)(64, 96, 32, 44)
	playerLayer.playerSprite:addAnimation('up')(0, 144, 32, 47)(32, 144, 32, 47)(64, 144, 32, 47)

	playerLayer.playerBody = love.physics.newBody(game.phyworld, game.data.playerx, game.data.playery, 'dynamic')
	playerLayer.playerBody:setFixedRotation(true)
	playerLayer.playerShape = love.physics.newRectangleShape(24, 24)
	playerLayer.playerFixture = love.physics.newFixture(playerLayer.playerBody, playerLayer.playerShape)

	function playerLayer:update(dt)
		local vx = 0
		if love.keyboard.isDown('a', 'left') and not love.keyboard.isDown('d', 'right') then
			vx = -300	
			playerLayer.playerSprite:setAnimation 'left'
		elseif not love.keyboard.isDown('a', 'left') and love.keyboard.isDown('d', 'right') then
			vx = 300
			playerLayer.playerSprite:setAnimation 'right'
		else
			vx = 0
		end

		local vy = 0
		if love.keyboard.isDown('w', 'up') and not love.keyboard.isDown('s', 'down') then
			vy = -300
			playerLayer.playerSprite:setAnimation 'up'
		elseif not love.keyboard.isDown('w', 'up') and love.keyboard.isDown('s', 'down') then
			vy = 300
			playerLayer.playerSprite:setAnimation 'down'
		else
			vy = 0
		end

		if vx ~= 0 or vy ~= 0 then self.playerSprite.frametime = 0.1 else self.playerSprite.frametime = 0 end
		self.playerBody:setLinearVelocity(vx, vy)
		self.playerSprite:update(dt)
	end

	function playerLayer:draw()
		self.playerSprite:draw(self.playerBody:getX(), self.playerBody:getY() + 12)
	end

	local enemiesLayer = game.tiledworld.layers['Enemies']
	enemiesLayer.opacity = 0.01

	for _, enemy in pairs(enemiesLayer.objects) do
		enemy.body = love.physics.newBody(game.phyworld, enemy.x, enemy.y, 'dynamic')
		enemy.shape = love.physics.newRectangleShape(24, 24)
		enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
	end

	function enemiesLayer:draw()
		love.graphics.setColor(255, 255, 255, 255)
		for _, enemy in pairs(enemiesLayer.objects) do
			love.graphics.rectangle('fill', enemy.body:getX() - 16, enemy.body:getY() - 16, 32, 32)
		end
	end
end

function game:update(dt)
	game.tiledworld:update(dt)
	game.phyworld:update(dt)
end

function game:draw()
	love.graphics.push()
	local ox = love.graphics.getWidth()/2 - game.tiledworld.layers.Player.playerBody:getX()
	local oy = love.graphics.getHeight()/2 - game.tiledworld.layers.Player.playerBody:getY()
	ox = ox > 0 and 0 or (ox < -2400 and -2400 or ox)
	oy = oy > 0 and 0 or (oy < -2600 and -2600 or oy)
	love.graphics.translate(ox, oy)
	game.tiledworld:draw()
	love.graphics.pop()
end

function game:save()
	game.data.playerx = game.tiledworld.layers.Player.playerBody:getX()
	game.data.playery = game.tiledworld.layers.Player.playerBody:getY()
	game.data.lastopened = os.date()
	love.filesystem.write('saves/' .. game.data.name, serialize(game.data))
end
