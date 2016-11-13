local tools = require 'assets/scripts/tools'

local asteroids = {}

function asteroids.load(game)
	local imgs = {
		love.graphics.newImage('assets/sprites/asteroids/1.png'), 
		love.graphics.newImage('assets/sprites/asteroids/2.png'), 
		love.graphics.newImage('assets/sprites/asteroids/3.png') 
	}
	local num = game.levelaa * 5
	local max_speed = 5
	-- Generate asteroids
	asteroids.bodys = {}
	for i=1, num do
		local temp_img = imgs[math.random(1, tools.table_length(imgs))]
		asteroids.bodys[i] = { 
			x = math.random(0, game.canvas.width - temp_img:getWidth()), 
			y = math.random(game.window.height / 2, game.canvas.height - temp_img:getHeight()), 
			speed = math.random(1, max_speed), 
			img = temp_img,
			angle = math.random(0, 90)
		}
	end
end

function asteroids.update(dt, game)
	-- Rotate asteroids 
	for key, asteroid in pairs(asteroids.bodys) do
		value.angle = asteroid.angle + (dt * math.pi / 10)
		value.x = asteroid.x - asteroid.speed
	end
	-- Destroy asteroids
	for key, asteroid in pairs(asteroids.bodys) do
		if value.x + asteroid.img:getWidth() < 0 then
			table.remove(asteroid, key)
		end
	end
	-- Create asteroids
	if tools.table_length(asteroids.bodys) < asteroids.num then
		local temp_img = imgs[math.random(1, table_length(imgs))]
		asteroids.bodys[table_length(asteroids.bodys) + 1] = { 
		x = game.canvas.width + temp_img:getWidth(), 
		y = math.random(game.window.height, game.canvas.height - temp_img:getHeight()), 
		speed = math.random(1, max_speed), 
		img = temp_img,
		angle = math.random(0, 90)}
	end
end

return asteroids