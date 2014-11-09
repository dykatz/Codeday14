spritesheet = {}
spritesheet.__index = spritesheet

function spritesheet:new(image)
	return setmetatable({
		frame = 1, frametime = 0, animation = '', animations = {}, aggregate = 0,
		quad = love.graphics.newQuad(0, 0, 32, 64, image:getWidth(), image:getHeight()), image = image}, self)
end

function spritesheet:setAnimation(a)
	self.animation = a
end

function spritesheet:update(dt)
	if self.frametime > 0 then
		self.aggregate = self.aggregate + dt

		while self.aggregate > self.frametime do
			self.aggregate = self.aggregate - self.frametime
			self.frame = self.frame + 1
		end

		while self.frame > #self.animations[self.animation] do
			self.frame = self.frame - #self.animations[self.animation]
		end

		local framedata = self.animations[self.animation][self.frame]
		self.quad:setViewport(framedata.x, framedata.y, framedata.w, framedata.h)
	end
end

function spritesheet:draw(x, y)
	local _, _, dx, dy = self.quad:getViewport()
	love.graphics.draw(self.image, self.quad, x - dx / 2, y - dy)
end

function spritesheet:addAnimation(name)
	self.animations[name] = {}
	self.animation = name
	local function ret(x, y, w, h)
		table.insert(self.animations[name], {x = x, y = y, w = w, h = h})
		return ret
	end
	return ret
end
