local anim8 = require 'assets/scripts/vendor/anim8'

local spaceship = {}

function spaceship.load(world)
	local canvas = {}
	canvas.width = 500
	-- power origin 1000
	spaceship = { x = canvas.width / 2, y = 0 , power = 400 , size_collition = 28, polygons_collition = 8 }
	spaceship.img = love.graphics.newImage('assets/sprites/spaceship/body.png')
	spaceship.body = love.physics.newBody(world, (canvas.width / 2) - (spaceship.img:getWidth() / 2) , spaceship.y, 'dynamic')
	spaceship.shape = love.physics.newCircleShape(20) 
	spaceship.fixture = love.physics.newFixture(spaceship.body, spaceship.shape, 1)
	spaceship.fixture:setRestitution(0.9)
	local g = anim8.newGrid(98, 93, spaceship.img:getWidth(), spaceship.img:getHeight())
  	spaceship.animation = anim8.newAnimation(g('1-1', 1), 0.1)
end

function spaceship.update(dt)
	spaceship.animation:update(dt)
	-- Controls
	if control_up then
		spaceship.body:applyForce(0, -spaceship.power)
	end
	if control_right then
		spaceship.body:applyForce(spaceship.power, 0)
	elseif control_left then
		spaceship.body:applyForce(-spaceship.power, 0)
	end
	if control_quit then
		love.event.push('quit')
	end
end

function spaceship.draw()
	spaceship.animation:draw(spaceship.img, spaceship.body:getX(), spaceship.body:getY())
end

return spaceship