require 'misc.util'
require 'game'
require 'misc.serial'
require 'misc.compress'

local gs = require 'hump.gamestate'
local lf = require 'loveframes'

menu = {}

function menu.enter()
	lf.SetState 'menu'

	local frame = lf.Create('frame'):SetName('The Glorious Main Menu'):SetState('menu'):ShowCloseButton(false):SetSize(640, 480):Center()

	local data = lf.Create('columnlist', frame):SetPos(5, 30):SetSize(500, 445):AddColumn('Save Name'):AddColumn('Last Used'):AddColumn('Created')
	function data:OnRowSelected(_, data_)
		menu.selection = data_[1]
	end

	local newgame = lf.Create('button', frame):SetPos(510, 30):SetSize(125, 25):SetText('New Game')
	function newgame:OnClick()
		lf.SetState 'menu.input'
	end

	local nameinput = lf.Create('frame'):SetName('The Glorious Name Input'):SetState('menu.input'):SetSize(300, 90):ShowCloseButton(false):Center()
	local nameinputtext = lf.Create('textinput', nameinput):SetPos(5, 30):SetSize(290, 25)
	local backfromname = lf.Create('button', nameinput):SetPos(5, 60):SetSize(140, 25):SetText('Cancel')
	function backfromname:OnClick()
		lf.SetState 'menu'
	end

	local createnewgame = lf.Create('button', nameinput):SetPos(150, 60):SetSize(140, 25):SetText('Start')
	function createnewgame:OnClick()
		if #nameinputtext:GetText():trim() > 0 then
			gs.switch(game, nameinputtext:GetText():trim())
			nameinput:Remove()
			frame:Remove()
		end
	end

	local loadgame = lf.Create('button', frame):SetPos(510, 60):SetSize(125, 25):SetText('Load Game')
	function loadgame:OnClick()
		if menu.selection then
			gs.switch(game, menu.selection)
			nameinput:Remove()
			frame:Remove()
		end
	end

	local deletegame = lf.Create('button', frame):SetPos(510, 90):SetSize(125, 25):SetText('Delete Save')
	function deletegame:OnClick()
		if menu.selection then
			love.filesystem.remove('saves/' .. menu.selection)
			menu:reload(data)
		end
	end

	local quit = lf.Create('button', frame):SetPos(510, 120):SetSize(125, 25):SetText('Quit Game')
	function quit:OnClick()
		love.event.quit()
	end

	menu:reload(data)
end

function menu:reload(data)
	-- Load data into the table
	if not love.filesystem.isDirectory 'saves' then
		love.filesystem.createDirectory 'saves'
	end

	local savefiles = love.filesystem.getDirectoryItems 'saves'
	data:Clear()

	for _, i in ipairs(savefiles) do
		local file = deserialize(love.filesystem.read('saves/' .. i))
		data:AddRow(file.name, file.lastopened, file.created)
	end
end
