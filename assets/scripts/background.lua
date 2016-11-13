local anim8 = require 'assets/scripts/vendor/anim8'
local tools = require 'assets/scripts/tools'

local background = {}
local stars = {}

function background.load(game)
	num_stars = 100
	local star = {}
	star.num_frames = 8
	star.ani_speed = .1
	star.width_frame = 16
	star.height_frame = 16
	star.img = love.graphics.newImage('assets/sprites/background/star.png')
	local g = anim8.newGrid(star.width_frame, star.height_frame, star.img:getWidth(), star.img:getHeight())
  	star.animation = anim8.newAnimation(g('1-' .. star.num_frames, 1), star.ani_speed)
	for i = 1, num_stars do
		local temp_star = tools.clone_table(star)
  		temp_star.animation = anim8.newAnimation(g('1-' .. star.num_frames, 1), math.random(star.ani_speed, star.ani_speed / 2))
		temp_star.animation:gotoFrame(math.random(1, star.num_frames))
		temp_star.x = math.random(-star.width_frame , game.canvas.width)
		temp_star.y = math.random(-star.height_frame, game.canvas.height)
	  	stars[i] = temp_star
	end
end

function background.update(dt)
	for key, star in pairs(stars) do
		star.animation:update(dt)
	end
end

function background.draw()
	for key, star in pairs(stars) do
		star.animation:draw(star.img, star.x, star.y)
	end
end

return background