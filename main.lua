-- LOAD
function love.load()
	-- Configuration
	math.randomseed(os.time())
	width, height = love.window.getDesktopDimensions( display )
	window = { width = width , height = height }
	fullscreen = false
	love.window.setMode(window.width, window.height, {resizable=true})
	font_main = love.graphics.newFont('assets/font/main.ttf', 80) -- Font
	love.graphics.setFont(font_main)
	text_restart = { text = 'You die' }
	text_restart.size = font_main:getWidth(text_restart.text)
	text_good = { text = 'Good' }
	text_good.size = font_main:getWidth(text_good.text)
	camera = { x = 0, y = 0, width = window.width, height = window.height }
	debug = false
	play = true
	win = false
	level = { num = 1, x = 50, y = 50, max = 20 }
	love.window.setFullscreen(fullscreen, 'exclusive')
	love.window.setTitle('Alunizaje')
	background = { x = 0, y = 0, img = love.graphics.newImage('assets/img/background.png') }
	canvas = { width = width, height = 2880 }
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
  	-- Fire
  	fire = {}
  	fire.img = love.graphics.newImage('assets/sprite/fire.png')
  	fire.num_frames = 4
  	fire.pos_frame = 0
  	fire.visible = false
  	fire.distance_ship = 10 
  	fire.frame_width = fire.img:getWidth() / fire.num_frames
  	fire.frames = {
                 love.graphics.newQuad(fire.frame_width * 0, 0, fire.frame_width, fire.frame_width, fire.img:getWidth(), fire.img:getHeight()),
                 love.graphics.newQuad(fire.frame_width * 1, 0, fire.frame_width, fire.frame_width, fire.img:getWidth(), fire.img:getHeight()),
                 love.graphics.newQuad(fire.frame_width * 2, 0, fire.frame_width, fire.frame_width, fire.img:getWidth(), fire.img:getHeight()),
                 love.graphics.newQuad(fire.frame_width * 3, 0, fire.frame_width, fire.frame_width, fire.img:getWidth(), fire.img:getHeight())
             }
    -- Explosion
  	explosion = {}
  	explosion.img = love.graphics.newImage('assets/sprite/explosion.png')
  	explosion.num_frames = 11 
  	explosion.pos_frame = 1
  	explosion.active = false
  	explosion.finish = false
  	explosion.time = 0
  	explosion.speed = 0.05
  	explosion.frame_width = explosion.img:getWidth() / explosion.num_frames
  	explosion.frame_height = explosion.img:getHeight()
  	explosion.frames = {
                 love.graphics.newQuad(explosion.frame_width * 0, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 1, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 2, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 3, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 4, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 5, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 6, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 7, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 8, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 9, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight()),
                 love.graphics.newQuad(explosion.frame_width * 10, 0, explosion.frame_width, explosion.frame_height, explosion.img:getWidth(), explosion.img:getHeight())
             }

	-- Button
	control_up, control_right, control_left, control_quit = false, false, false, false
  	button = {}
  	button.img = love.graphics.newImage('assets/sprite/button.png')
  	button.num_frames = 2
  	button.frame_width = button.img:getWidth() / button.num_frames
  	button.frame_height = button.img:getHeight()
  	button.frames = {
                 love.graphics.newQuad(button.frame_width * 0, 0, button.frame_width, button.frame_height, button.img:getWidth(), button.img:getHeight()),
                 love.graphics.newQuad(button.frame_width * 1, 0, button.frame_width, button.frame_height, button.img:getWidth(), button.img:getHeight())
             }
    button_up = {}
    button_up.x = window.width - button.img:getWidth()
    button_up.y = level.y + (camera.height / 4) + -camera.y
	-- Generates initial asteroids
	asteroids_collision = 40
	asteroids_collision_polygon = 8
	max_speed_asteroids = 5
	img_asteroide = {
		love.graphics.newImage('assets/img/asteroid1.png'), 
		love.graphics.newImage('assets/img/asteroid2.png'),
		love.graphics.newImage('assets/img/asteroid3.png')
	}
	-- Audios
	sounds = {}
	sounds.die = love.audio.newSource('assets/audio/sound/die.wav', 'static')	
	sounds.explosion = love.audio.newSource('assets/audio/sound/explosion_bit.wav', 'static')	
	sounds.ambient_1 = love.audio.newSource('assets/audio/sound/ambient_1.wav')	
	sounds.complete = love.audio.newSource('assets/audio/sound/complete.wav')	
	sounds.fire = love.audio.newSource('assets/audio/sound/fire.wav', 'static')	
	sounds.ambient_1:setLooping(true)
	sounds.ambient_1:play()

	restart(level.num)
end

-- UPDATE
function love.update(dt)
	-- Sprite
	if not explosion.finish and explosion.active then -- Explosion
		explosion.time = explosion.time + dt
		if explosion.time > explosion.speed then
			explosion.pos_frame = explosion.pos_frame + 1
			explosion.time = 0
		end
		if explosion.pos_frame > explosion.num_frames then
			sleep(1)
			restart(level.num)
		end
	end
	-- Restart
	if not explosion.active and not play then
		sleep(3)
		restart(level.num)
	end
	if play then
		-- Phytics world
		world:update(dt)
		-- Sprite
	    fire.visible = false
		if fire.pos_frame < fire.num_frames then -- Fire
			fire.pos_frame = fire.pos_frame + 1
		else
			fire.pos_frame = 1
		end
		-- Controls
		control_up, control_right, control_left, control_quit = false, false, false, false
			-- Keyboard
		if love.keyboard.isDown('escape') or love.keyboard.isDown('q') then
			control_quit = true
		end
		if love.keyboard.isDown('right') then 
			control_right = true
	    elseif love.keyboard.isDown('left') then 
	    	control_left = true
	    end
	  	if love.keyboard.isDown('up') then 
	  		control_up = true
	    end
	    	-- Mouse
		if love.mouse.isDown(1) then
			local x, y = love.mouse.getPosition()
			-- Up
			if x > button_up.x and x < button_up.x + button.img:getWidth() and y > button_up.y + camera.y and y < button_up.y + button.img:getHeight() + camera.y then
	  			control_up = true
			end
		end
		-- Ship move
		if control_up then
			ship.body:applyForce(0, -ship.power)
			fire.visible = true
			sounds.fire:play()
		end
		if control_right then
			ship.body:applyForce(ship.power, 0)
			fire.visible = true
			sounds.fire:play()
		elseif control_left then
			ship.body:applyForce(-ship.power, 0)
			fire.visible = true
			sounds.fire:play()
		end
		if control_quit then
			love.event.push('quit')
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
			y = math.random(window.height / 2, canvas.height - temp_img:getHeight()), 
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
			sounds.complete:play()
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
				sounds.die:play()
				sounds.explosion:play()
				explosion.active = true
			end
		end
	end
end

-- DRAW
function love.draw()
	-- Camera
  	love.graphics.translate(0, camera.y)
	-- Background
	love.graphics.draw(background.img, background.x, background.y, 0, 2, 1)
	-- Ship
	if not explosion.active then
		love.graphics.draw(ship.img, ship.body:getX(), ship.body:getY())
		if debug then
			love.graphics.circle('line', ship.body:getX() + (ship.img:getWidth() / 2), ship.body:getY() + (ship.img:getHeight() / 2), ship.size_collition, ship.polygons_collition)
		end
	end
	-- Fire
	if fire.visible and not explosion.active then
		love.graphics.draw(fire.img, fire.frames[fire.pos_frame], ship.body:getX(), ship.body:getY() + ship.img:getHeight() + fire.distance_ship)
	end
	-- Asteroids
	for key, value in pairs(asteroids) do
		love.graphics.draw(value.img, value.x, value.y, value.angle, 1, 1, value.img:getWidth() / 2, value.img:getHeight() / 2)
		if debug then
			love.graphics.circle('line', value.x, value.y, asteroids_collision, ship.polygons_collition)
		end
	end
	-- Explosion
	if explosion.active then
		love.graphics.draw(explosion.img, explosion.frames[explosion.pos_frame], ship.body:getX(), ship.body:getY() + ship.img:getHeight() / 2)
	end
	-- Controls
		-- Up
    button_up.y = level.y + (camera.height / 4) + -camera.y
	local button_frame_up = button.frames[1]
	if control_up then
		button_frame_up = button.frames[2]
	end
	love.graphics.draw(button.img, button_frame_up, button_up.x, button_up.y)
	-- Texts
	if not play and not win then -- Game over
		love.graphics.print(text_restart.text, (camera.width / 2) - (text_restart.size / 2), -camera.y + (camera.height / 2))
	end
	if not play and win then -- Win
		love.graphics.print(text_good, (camera.width / 2) - (text_good.size / 2), -camera.y + (camera.height / 2))
	end
	love.graphics.print('Level ' .. level.num, level.x, level.y + -camera.y) -- Score
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
	explosion.pos_frame = 1
	explosion.active = false
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

-- Controls
function love.keyreleased(key)
	sounds.fire:stop()
end

function love.mousereleased(key)
	sounds.fire:stop()
end