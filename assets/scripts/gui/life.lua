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
		angle = 300,
		move_up = false,
		vel = 0.3,
  		limits = {310, 270, 230},
  		angle_variation = 3
  	}
  	life.indicator.radius = tools.distance(life.indicator.x_shaft, life.indicator.y_shaft, life.indicator.x_target, life.indicator.y_target)
  	love.graphics.setLineWidth(life.indicator.width)
	-- Filter red
	life.filter = {
		color = {255, 255, 255},
		temp_num_lifes = game.lifes
	}
end

function life.update(dt, game)
	life.top.animation:update(dt) 
	-- Direction
	if life.indicator.limits[game.lifes] < life.indicator.angle then
		life.indicator.move_up = false
	elseif life.indicator.limits[game.lifes] - life.indicator.angle_variation > life.indicator.angle then 
		life.indicator.move_up = true
	end
	-- Increment
	if life.indicator.move_up then
		life.indicator.angle = life.indicator.angle + life.indicator.vel
	else
		life.indicator.angle = life.indicator.angle - life.indicator.vel
	end
	-- Calculate pos indicator
  	life.indicator.x_target, life.indicator.y_target = tools.circle_position(life.indicator.angle, life.indicator.radius, life.indicator.x_shaft, life.indicator.y_shaft)
  	-- Filter
  	if life.filter.temp_num_lifes ~= game.lifes then
  		life.filter.color = {255, 0, 0}
  		life.filter.temp_num_lifes = game.lifes
	end
  	for key, color in pairs(life.filter.color) do
  		if color < 255 then
  			life.filter.color[key] = life.filter.color[key] + 1
  		end
  	end
end

function life.draw(game)
	-- Background top
	life.top.animation:draw(life.top.img, life.top.x, life.top.y)
	-- Indicator
  	love.graphics.setColor(life.indicator.color)
	love.graphics.line(life.indicator.x_shaft, life.indicator.y_shaft, life.indicator.x_target, life.indicator.y_target)
	-- Filter
  	love.graphics.setColor(life.filter.color)
	-- Background down
	love.graphics.draw(life.down.img, life.down.x, life.down.y - 1)
end

return life