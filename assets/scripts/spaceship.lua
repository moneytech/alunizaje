local anim8 = require 'assets/scripts/vendor/anim8'
local HC = require 'assets/scripts/vendor/HC'

local spaceship = {}
local collision_debug = false
spaceship.y = 0
local press_button = false

function spaceship.load(game)
	-- power origin 1000
	body = { x = game.canvas.width / 2, y = 0 , power = 400 , size_collition = 28, polygons_collition = 8 }
	body.width = 156
	body.height = 143
	body.img = love.graphics.newImage('assets/sprites/spaceship/body.png')
	body.num_frames = 5
	body.body = love.physics.newBody(game.world, (game.canvas.width / 2) - (body.img:getWidth() / 2) , body.y, 'dynamic')
	body.shape = love.physics.newCircleShape(20) 
	body.fixture = love.physics.newFixture(body.body, body.shape, 1)
	body.fixture:setRestitution(0.9)
	local g = anim8.newGrid(body.width, body.height, body.img:getWidth(), body.img:getHeight())
  	body.animation_stop = anim8.newAnimation(g('1-1', 1), 0.1)
  	body.animation_fire = anim8.newAnimation(g('2-' .. body.num_frames, 1), 0.01)
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
  	-- Explosion
  	explosion = {
		img = love.graphics.newImage('assets/sprites/spaceship/explosion.png'),
		num_frames = 10,
		speed = 0.05,
		x = -game.canvas.width,
		y = -game.canvas.height
  	}
	g = anim8.newGrid(explosion.img:getWidth() / explosion.num_frames, explosion.img:getHeight(), explosion.img:getWidth(), explosion.img:getHeight())
  	explosion.animation = anim8.newAnimation(g('1-' .. explosion.num_frames, 1), explosion.speed, 'pauseAtEnd')
  	explosion.animation:pause()
  	explosion.claim_x = 45
  	explosion.claim_y = 40
  	-- Collision
	body.collision = {}
	body.collision.claim = 79
	body.collision.vertices = {
		 104,  40, 
		 55,  40, 
		 35,  100,
		 78,  110,
		 119,  100
	}
	body.collision.hc = HC.polygon(
		body.collision.vertices[1], 
		body.collision.vertices[2], 
		body.collision.vertices[3], 
		body.collision.vertices[4], 
		body.collision.vertices[5], 
		body.collision.vertices[6], 
		body.collision.vertices[7], 
		body.collision.vertices[8], 
		body.collision.vertices[9], 
		body.collision.vertices[10]
		)
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
  	-- Explosion
	explosion.animation:update(dt)
	-- Controls
	if CONTROL_UP then
		body.body:applyForce(0, -body.power)
		press_button = true
	end
	if CONTROL_RIGHT then
		body.body:applyForce(body.power, 0)
		press_button = true
	elseif CONTROL_LEFT then
		body.body:applyForce(-body.power, 0)
		press_button = true
	end
	if CONTROL_QUIT then
		love.event.push('quit')
	end
	-- Collision
		-- Move polygon
	body.collision.hc:moveTo(body.body:getX() + body.collision.claim, body.body:getY() + body.collision.claim)
		-- Check for collisions
    for shape, delta in pairs(HC.collisions(body.collision.hc)) do
    	game.play = false
    	game.die = true
    	explosion.x, explosion.y, explosion.enable = body.body:getX() - explosion.claim_x, body.body:getY() - explosion.claim_y, true
    	explosion.animation:resume()
    end
    if not game.play then
		body.body:setLinearVelocity(0, 0)
	end
    	-- Check game limits 
	if body.body:getY() <= 0 then -- Top game
		x, y = body.body:getLinearVelocity()
		body.body:setLinearVelocity(x, -y)
	end
	if body.body:getX() + (body.img:getWidth() / body.num_frames) - (body.collision.claim / 2) > game.canvas.width then -- Right game
		x, y = body.body:getLinearVelocity()
		body.body:setLinearVelocity(-x, y)
	end
	if body.body:getX() + (body.collision.claim / 2) < 0 then -- Left game
		x, y = body.body:getLinearVelocity()
		body.body:setLinearVelocity(-x, y)
	end
end

function spaceship.draw(game)
	if game.play then
		-- Lignt
		light.animation:draw(light.img, light.x, light.y)
		-- Spaceship
		if press_button then
			body.animation_fire:draw(body.img, body.body:getX(), body.body:getY())
		else
			body.animation_stop:draw(body.img, body.body:getX(), body.body:getY())
		end
	end
	-- Explosion
	explosion.animation:draw(explosion.img, explosion.x, explosion.y)
	-- Collision
	if collision_debug then
		body.collision.hc:draw('fill')
	end
end

return spaceship