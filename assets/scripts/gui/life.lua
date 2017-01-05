local anim8 = require 'assets/scripts/vendor/anim8'
local tools = require 'assets/scripts/tools'

local life = {}

function life.load(game)
	local PADDING = 50
	-- Up
  	life.top = {
  		x = PADDING,
  		y = PADDING, 
  		img = love.graphics.newImage('assets/sprites/gui/life_top.png'),
  		num_frames = 2
  	}
  	g = anim8.newGrid(life.top.img:getWidth() / life.top.num_frames, life.top.img:getHeight(), life.top.img:getWidth(), life.top.img:getHeight())
  	life.top.animation = anim8.newAnimation(g('1-' .. life.top.num_frames, 1), 1)
  	life.top.animation:gotoFrame(1)
  	life.top.animation:pause()
  	-- Down
  	life.down = {
  		img = love.graphics.newImage('assets/sprites/gui/life_down.png'),
  		x = PADDING,
  		y = life.top.y + life.top.img:getHeight()
  	}
  	-- Indicator
  	life.indicator = {
  		x_shaft = life.down.x + (life.down.img:getWidth() / 2),
		y_shaft = life.down.y + (life.down.img:getHeight() / 2),
		x_target = life.top.x + (life.top.img:getWidth() / 2 / life.top.num_frames),
		y_target = life.top.y + (life.top.img:getHeight() / 2),
		width = 10,
		color = {0, 0, 0},
		angle = 230,
		move_up = false
  	}
  	life.indicator.radius = tools.distance(life.indicator.x_shaft, life.indicator.y_shaft, life.indicator.x_target, life.indicator.y_target)
  	love.graphics.setLineWidth(life.indicator.width)
end

function life.update(dt, game)
	life.top.animation:update(dt) 
	-- 1 230 240
	if game.life == 3 then
	end	
  	life.indicator.x_target, life.indicator.y_target = tools.circle_position(life.indicator.angle, life.indicator.radius, life.indicator.x_shaft, life.indicator.y_shaft)
end

function life.draw()
	-- Background top
	life.top.animation:draw(life.top.img, life.top.x, life.top.y)
	-- Indicator
  	love.graphics.setColor(life.indicator.color)
	love.graphics.line(life.indicator.x_shaft, life.indicator.y_shaft, life.indicator.x_target, life.indicator.y_target)
  	love.graphics.setColor(255, 255, 255)
	-- Background down
	love.graphics.draw(life.down.img, life.down.x, life.down.y)
end

return life