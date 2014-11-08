require 'game'

local gs = require 'hump.gamestate'
local lf = require 'loveframes'

menu = {}

function menu.enter()
	--menu.background = love.graphics.newImage("mainIntroBackground.jpg")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(0, 0, 255)

	lf.SetState 'menu'

	menu.frame = lf.Create 'frame'
	menu.frame:SetName('The Glorious Main Menu'):SetState('menu'):SetDraggable(false):ShowCloseButton(false):SetSize(640, 480):Center()

	menu.data = lf.Create('columnlist', menu.frame)
	menu.data:SetPos(5, 30):SetSize(600, 445):AddColumn('Save Name'):AddColumn('Last Used'):AddColumn('Location')
end
