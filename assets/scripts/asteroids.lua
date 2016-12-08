local HC = require 'assets/scripts/vendor/HC'
local tools = require 'assets/scripts/tools'

local asteroids = {}
local collision_debug = false
local imgs = nil

function asteroids.load(game)
	imgs = {
		love.graphics.newImage('assets/sprites/asteroids/asteroid01.png'), 
		love.graphics.newImage('assets/sprites/asteroids/asteroid02.png'), 
		love.graphics.newImage('assets/sprites/asteroids/asteroid03.png'), 
		love.graphics.newImage('assets/sprites/asteroids/asteroid04.png') 
	}
	asteroids.num = game.level * 5
	asteroids.max_speed = 5
	asteroids.collision_size = 50

	-- Make asteroids
	asteroids.bodys = {}
	for i = 1, asteroids.num do
		make_asteroid(i, game, true)
	end
end

function asteroids.update(dt, game)
	-- Move asteroids
	for key, asteroid in pairs(asteroids.bodys) do
		-- Rotate 
		asteroid.angle = asteroid.angle + (dt * math.pi / 10)
		-- Move
		asteroid.x = asteroid.x - asteroid.speed
		-- Collisions
		asteroid.collision:moveTo(asteroid.x, asteroid.y)
	end
	-- Destroy asteroids
	for key, asteroid in pairs(asteroids.bodys) do
		if asteroid.x + asteroid.img:getWidth() < 0 then
			HC.remove(asteroid.collision)
			table.remove(asteroids.bodys, key)
		end
	end
	-- Create asteroids
	if tools.table_length(asteroids.bodys) < asteroids.num then
		make_asteroid(tools.table_length(asteroids.bodys) + 1, game, false)
	end
end

function asteroids.draw()
	for key, asteroid in pairs(asteroids.bodys) do
		love.graphics.draw(asteroid.img, asteroid.x, asteroid.y, asteroid.angle, 1, 1, asteroid.img:getWidth() / 2, asteroid.img:getHeight() / 2)
		if collision_debug then
			asteroid.collision:draw('fill')	
		end
	end	
end

function make_asteroid(pos, game, x_random)
	local temp_img = imgs[math.random(1, tools.table_length(imgs))]
	asteroids.bodys[pos] = { 
		x = game.canvas.width + temp_img:getWidth(), 
		y = math.random(game.window.height / 2, game.canvas.height - temp_img:getHeight()), 
		speed = math.random(1, asteroids.max_speed), 
		img = temp_img,
		angle = math.random(0, 90),
		collision = HC.circle(0, 0, asteroids.collision_size)
	}
	if x_random then
		asteroids.bodys[pos].x = math.random(0, game.canvas.width - temp_img:getWidth())
	end
end

return asteroids