require 'game'

local gs = require 'hump.gamestate'

menu = {}

function menu.enter()
	--menu.background = love.graphics.newImage("mainIntroBackground.jpg")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(0, 0, 255)

	menu.stage = 'intro'
end

function menu.keyreleased(k)
	if menu.stage == 'intro' then
	
		if k == ' ' then
			menu.stage = 'select'
		elseif k == 'escape' then
			love.event.quit()
		end
	
	elseif menu.stage == 'select' then
	
		if k == ' ' or k == 'return' then
			gs.switch(game)
		elseif k == 'escape' then
			menu.stage = 'intro'
		end
	
	end
end
