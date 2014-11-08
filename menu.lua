require 'game'
require 'misc.tserial'

local gs = require 'hump.gamestate'
local lf = require 'loveframes'

menu = {}

function menu.enter()
	--menu.background = love.graphics.newImage("mainIntroBackground.jpg")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(0, 0, 255)

	lf.SetState 'menu'

	menu.frame = lf.Create 'frame'
	menu.frame:SetName('The Glorious Main Menu'):SetState('menu'):ShowCloseButton(false):SetSize(640, 480):Center()

	menu.data = lf.Create('columnlist', menu.frame)
	menu.data:SetPos(5, 30):SetSize(500, 445):AddColumn('Save Name'):AddColumn('Location'):AddColumn('Last Used'):AddColumn('Created')
	function menu.data:OnSelected(_, data)
		menu.selection = data[1]
	end

	menu.newgame = lf.Create('button', menu.frame)
	menu.newgame:SetPos(510, 30):SetSize(125, 25):SetText('New Game')
	function menu.newgame:OnClick()
		lf.SetState 'menu.input'
	end

	menu.loadgame = lf.Create('button', menu.frame)
	menu.loadgame:SetPos(510, 60):SetSize(125, 25):SetText('Load Game')
	function menu.loadgame:OnClick()
		if menu.selection then
			gs.switch(game, menu.selection)
		end
	end

	menu.deletegame = lf.Create('button', menu.frame)
	menu.deletegame:SetPos(510, 90):SetSize(125, 25):SetText('Delete Save')
	function menu.deletegame:OnClick()
		if menu.selection then
			love.filesystem.remove('saves' .. menu.selection)
		end
	end

	menu.quit = lf.Create('button', menu.frame)
	menu.quit:SetPos(510, 120):SetSize(125, 25):SetText('Quit Game')
	function menu.quit:OnClick()
		love.event.quit()
	end

	menu.nameinput = lf.Create 'frame'
	menu.nameinput:SetName('The Glorious Name Input'):SetState('menu.input'):SetSize(300, 90):ShowCloseButton(false):Center()

	menu.nameinputtext = lf.Create('textinput', menu.nameinput)
	menu.nameinputtext:SetPos(5, 30):SetSize(290, 25)

	menu.backfromname = lf.Create('button', menu.nameinput)
	menu.backfromname:SetPos(5, 60):SetSize(140, 25):SetText('Cancel')
	function menu.backfromname:OnClick()
		lf.SetState 'menu'
	end

	menu.createnewgame = lf.Create('button', menu.nameinput)
	menu.createnewgame:SetPos(150, 60):SetSize(140, 25):SetText('Start')
	function menu.createnewgame:OnClick()
		if #menu.nameinputtext:GetText() > 0 then
			gs.switch(game, menu.nameinputtext:GetText())
		end
	end

	-- Load data into the table
	if not love.filesystem.isDirectory 'saves' then
		love.filesystem.createDirectory 'saves'
	end

	local data = love.filesystem.getDirectoryItems 'saves'

	for _, i in ipairs(data) do
		local data = Tserial.unpack(love.filesystem.read(i))
		menu.data:AddRow(data.name, data.location, data.lastopened, data.created)
	end
end
