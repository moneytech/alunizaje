-- LOAD
function love.load()
	-- Configuration
	math.randomseed(os.time())
	window = { width = 1280, height = 720 }
	fullscreen = false
	love.window.setMode(window.width, window.height, {resizable=false})
	font = love.graphics.newFont('assets/font/space_age.ttf', 40) -- Font
	love.graphics.setFont(font)
	text_restart = { text = 'You die!' }
	text_restart.size = font:getWidth(text_restart.text)
	text_good = { text = 'Good' }
	text_good.size = font:getWidth(text_good.text)
	camera = { x = 0, y = 0, width = window.width, height = window.height }
	debug = false
	play = true
	win = false
	level = { num = 1, x = 50, y = 50 }
	love.window.setFullscreen(fullscreen)
	love.window.setTitle('Alunizaje')
	background = { x = 0, y = 0, img = love.graphics.newImage('assets/img/background.jpg') }
	canvas = { width = 1280, height = 2880 }
	gravity = 2
	moon_margin = 100
	-- Physics
	love.physics.setMeter(64) -- Height earth in meters
  	world = love.physics.newWorld(0, gravity * 64, true) -- Make earth
  	-- Ship
  	ship = { x = canvas.width / 2, y = 0 , power = 1000 , size_collition = 28, polygons_collition = 8 }
  	ship.img = love.graphics.newImage('assets/img/ship.png')
  	ship.body = love.physics.newBody(world, (canvas.width / 2) - (ship.img:getWidth() / 2) , ship.y, 'dynamic')
  	ship.shape = love.physics.newCircleShape(20) 
  	ship.fixture = love.physics.newFixture(ship.body, ship.shape, 1)
  	ship.fixture:setRestitution(0.9)
	-- Generates initial asteroids
	asteroids_collision = 40
	asteroids_collision_polygon = 8
	max_speed_asteroids = 5
	img_asteroide = {
		love.graphics.newImage('assets/img/asteroid1.png'), 
		love.graphics.newImage('assets/img/asteroid2.png')
	}
	restart(level.num)
end

-- UPDATE
function love.update(dt)
	if play then
		-- Phytics world
		world:update(dt)
		-- Controls
		if love.keyboard.isDown('escape') or love.keyboard.isDown('q') then
			love.event.push('quit')
		end
		if love.keyboard.isDown('right') then 
	    	ship.body:applyForce(ship.power, 0)
	  	elseif love.keyboard.isDown('left') then 
	    	ship.body:applyForce(-ship.power, 0)
	  	end
	  	if love.keyboard.isDown('up') then 
	    	ship.body:applyForce(0, -ship.power)
	  	elseif love.keyboard.isDown('down') then 
	    	ship.body:applyForce(0, ship.power)
	  	end

		-- Rotate asteroids 
		for key, value in pairs(asteroids) do
			value.angle = asteroids[key].angle + (dt * math.pi / 10)
			value.x = asteroids[key].x - asteroids[key].speed
		end
		-- Destroy asteroids
		for key, value in pairs(asteroids) do
			if value.x + asteroids[key].img:getWidth() < 0 then
				table.remove(asteroids, key)
			end
		end

		-- Create asteroids
		if table_length(asteroids) < num_asteroids then
			local temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
			asteroids[table_length(asteroids) + 1] = { 
			x = canvas.width + temp_img:getWidth(), 
			y = math.random(0, canvas.height - temp_img:getHeight()), 
			speed = math.random(1, max_speed_asteroids), 
			img = temp_img,
			angle = math.random(0, 90)}
		end

		-- Camera
	  	camera.y = 0
		if camera.height / 3 <= ship.body:getY() then -- Top
			camera.y = -ship.body:getY() + (camera.height / 3)
		end
		if canvas.height - ((camera.height / 3) * 2) < ship.body:getY() then -- Down
			camera.y = 	-canvas.height + camera.height
		end

		-- Collision
		if ship.body:getY() <= 0 then -- Top game
			x, y = ship.body:getLinearVelocity()
			ship.body:setLinearVelocity(x, -y)
		end
		if ship.body:getX() + ship.img:getWidth() > canvas.width then -- Right game
			x, y = ship.body:getLinearVelocity()
			ship.body:setLinearVelocity(-x, y)
		end
		if ship.body:getX() < 0 then -- Left game
			x, y = ship.body:getLinearVelocity()
			ship.body:setLinearVelocity(-x, y)
		end
		if ship.body:getY() + ship.img:getHeight() + moon_margin >= canvas.height then -- Down game
			ship.body:setLinearVelocity(0, 0)
			win = true
			play = false
			level.num = level.num + 1
		end

		for key, value in pairs(asteroids) do -- Asteroids
			local asteroid_temp = {
				x = asteroids[key].x,
				y = asteroids[key].y,
				radius = asteroids_collision	
			}
			local ship_temp = {
				x = ship.body:getX() + (ship.img:getWidth() / 2),
				y = ship.body:getY() + (ship.img:getHeight() / 2),
				radius = ship.size_collition
			}
			if checkCircleCollision(asteroid_temp, ship_temp) then
				play = false
			end
		end
	else
		sleep(2)
		restart(level.num)
	end
end

-- DRAW
function love.draw()
	-- Camera
  	love.graphics.translate(0, camera.y)
	-- Background
	love.graphics.draw(background.img, background.x, background.y)
	-- Asteroids
	for key, value in pairs(asteroids) do
		love.graphics.draw(value.img, value.x, value.y, value.angle, 1, 1, value.img:getWidth() / 2, value.img:getHeight() / 2)
		if debug then
			love.graphics.circle('line', value.x, value.y, asteroids_collision, ship.polygons_collition)
		end
	end
	-- Ship
	love.graphics.draw(ship.img, ship.body:getX(), ship.body:getY())
	if debug then
		love.graphics.circle('line', ship.body:getX() + (ship.img:getWidth() / 2), ship.body:getY() + (ship.img:getHeight() / 2), ship.size_collition, ship.polygons_collition)
	end
	-- Texts
	if not play and not win then -- Game over
		love.graphics.print(text_restart.text, (camera.width / 2) - (text_restart.size / 2), -camera.y + (camera.height / 2))
	end
	if not play and win then -- Win
		love.graphics.print(text_good, (camera.width / 2) - (text_good.size / 2), -camera.y + (camera.height / 2))
	end
	love.graphics.print('Level ' .. level.num, level.x, level.y + -camera.y)
end

---------------------------------  Functions
-- Get Table length
function table_length(T)
 	local count = 0
 	for _ in pairs(T) do count = count + 1 end
 	return count
end

-- Pause system n seconds
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

-- Collision detection function.
function checkCircleCollision(circle1, circle2)
	local distance = math.sqrt((circle1.x - circle2.x) ^ 2 + (circle1.y - circle2.y) ^ 2)
	return distance <= circle1.radius + circle2.radius
end

function restart(level_arg)
	num_asteroids = level_arg * 5
	-- Generate asteroids
	asteroids = {}
	for i=1, num_asteroids do
		local temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
		asteroids[i] = { 
			x = math.random(0, canvas.width - temp_img:getWidth()), 
			y = math.random(200, canvas.height - temp_img:getHeight()), 
			speed = math.random(1, max_speed_asteroids), 
			img = temp_img,
			angle = math.random(0, 90)
		}
	end
	-- Set ship position
  	ship.body = love.physics.newBody(world, (canvas.width / 2) - (ship.img:getWidth() / 2) , ship.y, 'dynamic')
	win = false
	play = true
end