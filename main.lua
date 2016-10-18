-- LOAD
function love.load()
	-- Configuration
	math.randomseed(os.time())
	window = { width = 1280, height = 720 }
	love.window.setMode(window.width, window.height, {resizable=false})
	font = love.graphics.newFont(40) -- Font
	love.graphics.setFont(font)
	camera = { x = 0, y = 0, width = window.width, height = window.height }
	debug = true
	play = true
	win = false
	fullscreen = false
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
  	ship = { x = canvas.width / 2, y = 0 , power = 100 }
  	ship.body = love.physics.newBody(world, ship.x, ship.y, "dynamic")
  	ship.shape = love.physics.newCircleShape(20) 
  	ship.fixture = love.physics.newFixture(ship.body, ship.shape, 1)
  	ship.fixture:setRestitution(0.9)
  	ship.img = love.graphics.newImage('assets/img/ship.png')
	-- Generates initial asteroids
	num_asteroids = 50
	max_speed_asteroids = 5
	img_asteroide = {
		love.graphics.newImage('assets/img/asteroid1.png'), 
		love.graphics.newImage('assets/img/asteroid2.png'),
		love.graphics.newImage('assets/img/asteroid3.png')
	}
	asteroids = {}
	for i=1, num_asteroids do
		temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
		asteroids[i] = { x = math.random(0, canvas.width - temp_img:getWidth()), 
		y = math.random(200, canvas.height - temp_img:getHeight()), 
		speed = math.random(1, max_speed_asteroids), 
		img = temp_img,
		angle = math.random(0, 90)}
	end
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

		if love.keyboard.isDown("right") then 
	    	ship.body:applyForce(ship.power, 0)
	  	elseif love.keyboard.isDown("left") then 
	    	ship.body:applyForce(-ship.power, 0)
	  	end
	  	if love.keyboard.isDown("up") then 
	    	ship.body:applyForce(0, -ship.power)
	  	elseif love.keyboard.isDown("down") then 
	    	ship.body:applyForce(0, ship.power)
	  	end

		-- Rotate asteroids 
		for key, value in pairs(asteroids) do
			-- Rota
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
			temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
			asteroids[table_length(asteroids) + 1] = { 
			x = canvas.width + temp_img:getWidth(), 
			y = math.random(0, canvas.height - temp_img:getHeight()), 
			speed = math.random(1, max_speed_asteroids), 
			img = temp_img,
			angle = math.random(0, 90)}
		end

		-- Camera
	  	camera.y = 0
		if camera.height / 2 <= ship.body:getY() then -- Top
			camera.y = -ship.body:getY() + (camera.height / 2)
		end
		if canvas.height - camera.height / 2 < ship.body:getY() then -- Down
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
		end

		for key, value in pairs(asteroids) do -- Asteroids
			if CheckCollision(asteroids[key].x - (asteroids[key].img:getWidth() / 2), asteroids[key].y - (asteroids[key].img:getHeight() / 2), asteroids[key].img:getWidth(), asteroids[key].img:getHeight(), ship.body:getX(), ship.body:getY(), ship.img:getWidth(), ship.img:getHeight()) then
				play = false
			end
		end
	else
		sleep(2)
		love.load()
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
			love.graphics.rectangle("line", value.x - (value.img:getWidth() / 2), value.y - (value.img:getHeight() / 2), value.img:getWidth(), value.img:getHeight())
		end
	end
	-- Ship
	love.graphics.draw(ship.img, ship.body:getX(), ship.body:getY())
	if debug then
		love.graphics.rectangle("line", ship.body:getX(), ship.body:getY(), ship.img:getWidth(), ship.img:getHeight())
	end
	-- Texts
	if not play and not win then -- Game over
		love.graphics.print('Game over', (camera.width / 2), -camera.y + (camera.height / 2))
	end
	if not play and win then -- Win
		love.graphics.print('You win!', (camera.width / 2), -camera.y + (camera.height / 2))
	end
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
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end