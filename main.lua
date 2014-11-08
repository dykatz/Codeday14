require 'sti'
require 'menu'

function love.load()
	mode = menu
	menu.load()
end

function setCallback(name)
	love[name] = function(...)
		if type(mode[name]) == 'function' then
			mode[name](...)
		end
	end
end

setCallback 'update'
setCallback 'draw'
setCallback 'keypressed'
setCallback 'keyreleased'
setCallback 'mousepressed'
setCallback 'mousereleased'
setCallback 'focus'
setCallback 'resize'
setCallback 'visable'
setCallback 'mousefocus'
setCallback 'textinput'
