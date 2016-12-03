local anim8 = require 'assets/scripts/vendor/anim8'

local spaceship = {}
local collision_debug = true
spaceship.y = 0
local press_button = false

function spaceship.load(game)
	-- power origin 1000
	body = { x = game.canvas.width / 2, y = 0 , power = 400 , size_collition = 28, polygons_collition = 8 }
	body.width = 156
	body.height = 143
	body.img = love.graphics.newImage('assets/sprites/spaceship/body.png')
	body.body = love.physics.newBody(game.world, (game.canvas.width / 2) - (body.img:getWidth() / 2) , body.y, 'dynamic')
	body.shape = love.physics.newCircleShape(20) 
	body.fixture = love.physics.newFixture(body.body, body.shape, 1)
	body.fixture:setRestitution(0.9)
	local g = anim8.newGrid(body.width, body.height, body.img:getWidth(), body.img:getHeight())
  	body.animation_stop = anim8.newAnimation(g('1-1', 1), 0.1)
  	body.animation_fire = anim8.newAnimation(g('2-5', 1), 0.01)
  	-- Light
  	light = {
  		img = love.graphics.newImage('assets/sprites/spaceship/light.png'),
  		y = body.y
  	}
  	light.x = body.x + (body.img:getWidth() / 2) + (light.img:getWidth() / 2)
  	light.num_frames = 11
  	light.width = 74
  	light.height = 66
	g = anim8.newGrid(light.width, light.height, light.img:getWidth(), light.img:getHeight())
  	light.animation = anim8.newAnimation(g('1-' .. light.num_frames, 1), 0.05)
  	-- Collision
  	body.collision = {}
  	body.collision[1] = {x=66, y=35, width=28, height=5, name={name='spaceship_1'}}
  	body.collision[2] = {x=56, y=40, width=48, height=5, name={name='spaceship_2'}}
  	body.collision[3] = {x=54, y=45, width=54, height=10, name={name='spaceship_3'}}
  	body.collision[4] = {x=50, y=55, width=60, height=10, name={name='spaceship_4'}}
  	body.collision[5] = {x=46, y=65, width=66, height=10, name={name='spaceship_5'}}
  	body.collision[6] = {x=44, y=75, width=70, height=10, name={name='spaceship_6'}}
  	body.collision[7] = {x=40, y=85, width=78, height=20, name={name='spaceship_7'}}
  	body.collision[8] = {x=53, y=105, width=50, height=4, name={name='spaceship_8'}}
	for key, value in pairs(body.collision) do
  		game.collisions:add(
  			body.collision[key].name, 
  			body.body:getX() + body.collision[key].x, 
  			body.body:getY() + body.collision[key].y, 
  			body.collision[key].width, 
  			body.collision[key].height
  		)
  end
end

function spaceship.update(dt, game)
	-- Spaceship
	body.animation_fire:update(dt)
	press_button = false
	spaceship.y = body.body:getY()
	-- Light
	light.animation:update(dt)
  	light.x = body.body:getX() + 43
  	light.y = body.body:getY() - 15
	-- Controls
	if control_up then
		body.body:applyForce(0, -body.power)
		press_button = true
	end
	if control_right then
		body.body:applyForce(body.power, 0)
		press_button = true
	elseif control_left then
		body.body:applyForce(-body.power, 0)
		press_button = true
	end
	if control_quit then
		love.event.push('quit')
	end
	-- Collision
	for key, value in pairs(body.collision) do
  		game.collisions:move(
  			body.collision[key].name, 
			body.body:getX() + body.collision[key].x, 
			body.body:getY() + body.collision[key].y
		)
  	end
end

function spaceship.draw()
	light.animation:draw(light.img, light.x, light.y)
	if press_button then
		body.animation_fire:draw(body.img, body.body:getX(), body.body:getY())
	else
		body.animation_stop:draw(body.img, body.body:getX(), body.body:getY())
	end
	if collision_debug then
		for key, value in pairs(body.collision) do
			love.graphics.rectangle(
				'fill', 
				body.body:getX() + body.collision[key].x, 
  				body.body:getY() + body.collision[key].y, 
  				body.collision[key].width, 
  				body.collision[key].height
  			)
		end
	end
end

return spaceship