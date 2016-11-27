local anim8 = require 'assets/scripts/vendor/anim8'

local spaceship = {}
local press_button = false

function spaceship.load(game)
	-- power origin 1000
	spaceship = { x = game.canvas.width / 2, y = 0 , power = 400 , size_collition = 28, polygons_collition = 8 }
	spaceship.width = 156
	spaceship.height = 143
	spaceship.img = love.graphics.newImage('assets/sprites/spaceship/body.png')
	spaceship.body = love.physics.newBody(game.world, (game.canvas.width / 2) - (spaceship.img:getWidth() / 2) , spaceship.y, 'dynamic')
	spaceship.shape = love.physics.newCircleShape(20) 
	spaceship.fixture = love.physics.newFixture(spaceship.body, spaceship.shape, 1)
	spaceship.fixture:setRestitution(0.9)
	local g = anim8.newGrid(spaceship.width, spaceship.height, spaceship.img:getWidth(), spaceship.img:getHeight())
  	spaceship.animation_stop = anim8.newAnimation(g('1-1', 1), 0.1)
  	spaceship.animation_fire = anim8.newAnimation(g('2-5', 1), 0.01)
  	-- Light
  	light = {
  		img = love.graphics.newImage('assets/sprites/spaceship/light.png'),
  		y = spaceship.y
  	}
  	light.x = spaceship.x + (spaceship.img:getWidth() / 2) + (light.img:getWidth() / 2)
  	light.num_frames = 9
  	light.width = 16
  	light.height = 16
	g = anim8.newGrid(light.width, light.height, light.img:getWidth(), light.img:getHeight())
  	light.animation = anim8.newAnimation(g('1-' .. light.num_frames, 1), 0.1)
end

function spaceship.update(dt)
	-- Spaceship
	spaceship.animation_fire:update(dt)
	press_button = false
	-- Light
	light.animation:update(dt)
  	light.x = spaceship.body:getX() + (spaceship.width / 2) + (light.width / 2)
  	light.y = spaceship.body:getY()
	-- Controls
	if control_up then
		spaceship.body:applyForce(0, -spaceship.power)
		press_button = true
	end
	if control_right then
		spaceship.body:applyForce(spaceship.power, 0)
		press_button = true
	elseif control_left then
		spaceship.body:applyForce(-spaceship.power, 0)
		press_button = true
	end
	if control_quit then
		love.event.push('quit')
	end
end

function spaceship.draw()
	light.animation:draw(light.img, light.x, light.y)
	if press_button then
		spaceship.animation_fire:draw(spaceship.img, spaceship.body:getX(), spaceship.body:getY())
	else
		spaceship.animation_stop:draw(spaceship.img, spaceship.body:getX(), spaceship.body:getY())
	end
end

return spaceship