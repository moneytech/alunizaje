function table_length(T)
 	local count = 0
 	for _ in pairs(T) do count = count + 1 end
 	return count
end

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

function love.load()
	-- Configuración
	math.randomseed(os.time())
	camara_width = 1280
	camara_height = 720
	debug = false
	play = true
	win = false
	font = love.graphics.newFont(40)
	love.graphics.setFont(font)
	love.window.setMode(camara_width, camara_height, {resizable=false})
	-- love.window.setFullscreen(true)
	love.window.setTitle('Alunizaje')
	fondo = { x = 0, y = 0, img = love.graphics.newImage('assets/img/fondo.jpg') }
	game_height = 2880
	game_width = 1280
	gravedad = 2
	distancia_luna = 100
	-- Fisicas
	love.physics.setMeter(64) -- Altura del mundo en metros
  	world = love.physics.newWorld(0, gravedad * 64, true) -- Crea el mundo físico

  	-- Nave fisicas
  	nave = {}
	nave_x = game_width / 2
	nave_y = 0
  	nave.body = love.physics.newBody(world, nave_x, nave_y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  	nave.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  	nave.fixture = love.physics.newFixture(nave.body, nave.shape, 1) -- Attach fixture to body and give it a density of 1.
  	nave.fixture:setRestitution(0.9) --let the ball bounce
  	nave.power = 100
  	nave.img = love.graphics.newImage('assets/img/nave.png')

	-- Genera los asteroides
	num_asteroides = 50
	max_speed = 5
	img_asteroide = {
		love.graphics.newImage('assets/img/asteroide1.png'), 
		love.graphics.newImage('assets/img/asteroide2.png'),
		love.graphics.newImage('assets/img/asteroide3.png')
	}
	asteroides = {}
	for i=1, num_asteroides do
		temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
		asteroides[i] = { x = math.random(0, game_width - temp_img:getWidth()), 
		y = math.random(200, game_height - temp_img:getHeight()), 
		speed = math.random(1, max_speed), 
		img = temp_img,
		angle = math.random(0, 90)}
	end
end

function love.update(dt)
	if play then
		-- Fisicas del mundo
		world:update(dt)

		-- Controles
		if love.keyboard.isDown('escape') then
			love.event.push('quit')
		end

		if love.keyboard.isDown("right") then 
	    	nave.body:applyForce(nave.power, 0)
	  	elseif love.keyboard.isDown("left") then 
	    	nave.body:applyForce(-nave.power, 0)
	  	end
	  	if love.keyboard.isDown("up") then 
	    	nave.body:applyForce(0, -nave.power)
	  	elseif love.keyboard.isDown("down") then 
	    	nave.body:applyForce(0, nave.power)
	  	end


		-- Asteroides rotar
		for key, value in pairs(asteroides) do
			-- Rota
			value.angle = asteroides[key].angle + (dt * math.pi / 10)
			value.x = asteroides[key].x - asteroides[key].speed
		end

		-- Asteroides destruir
		for key, value in pairs(asteroides) do
			-- Destruye los que salen de pantalla
			if value.x + asteroides[key].img:getWidth() < 0 then
				table.remove(asteroides, key)
			end
		end

		-- Asteroides crear
		if table_length(asteroides) < num_asteroides then
			temp_img = img_asteroide[math.random(1, table_length(img_asteroide))]
			asteroides[table_length(asteroides) + 1] = { 
			x = game_width + temp_img:getWidth(), 
			y = math.random(0, game_height - temp_img:getHeight()), 
			speed = math.random(1, max_speed), 
			img = temp_img,
			angle = math.random(0, 90)}
		end

		-- Camara
	  	camara_y = 0
		if camara_height / 2 <= nave.body:getY() then -- Superior
			camara_y = -nave.body:getY() + (camara_height / 2)
		end
		if game_height - camara_height / 2 < nave.body:getY() then --Inferior
			camara_y = 	-game_height + camara_height
		end

		-- Colision
		if nave.body:getY() <= 0 then -- Arriba del juego
			x, y = nave.body:getLinearVelocity()
			nave.body:setLinearVelocity(x, -y)
		end
		if nave.body:getX() + nave.img:getWidth() > game_width then -- Derecha del juego
			x, y = nave.body:getLinearVelocity()
			nave.body:setLinearVelocity(-x, y)
		end
		if nave.body:getX() < 0 then -- Izquierda del juego
			x, y = nave.body:getLinearVelocity()
			nave.body:setLinearVelocity(-x, y)
		end
		if nave.body:getY() + nave.img:getHeight() + distancia_luna >= game_height then -- Abajo del juego
			nave.body:setLinearVelocity(0, 0)
			win = true
			play = false
		end

		for key, value in pairs(asteroides) do -- Con asteroides
			if CheckCollision(asteroides[key].x - (asteroides[key].img:getWidth() / 2), asteroides[key].y - (asteroides[key].img:getHeight() / 2), asteroides[key].img:getWidth(), asteroides[key].img:getHeight(), nave.body:getX(), nave.body:getY(), nave.img:getWidth(), nave.img:getHeight()) then
				play = false
			end
		end
	else
		sleep(2)
		love.load()
	end
end

function love.draw()
	-- Camara
  	love.graphics.translate(0, camara_y)
  	
	-- Fondo
	love.graphics.draw(fondo.img, fondo.x, fondo.y)

	-- Asteroides
	for key, value in pairs(asteroides) do
		love.graphics.draw(value.img, value.x, value.y, value.angle, 1, 1, value.img:getWidth() / 2, value.img:getHeight() / 2)
		if debug then
			love.graphics.rectangle("line", value.x - (value.img:getWidth() / 2), value.y - (value.img:getHeight() / 2), value.img:getWidth(), value.img:getHeight())
		end
	end

	-- Nave
	love.graphics.draw(nave.img, nave.body:getX(), nave.body:getY())
	if debug then
		love.graphics.rectangle("line", nave.body:getX(), nave.body:getY(), nave.img:getWidth(), nave.img:getHeight())
	end

	-- Textos
	if not play and not win then
		love.graphics.print('Game over', (camara_width / 2), -camara_y + (camara_height / 2))
	end
	if not play and win then
		love.graphics.print('You win!', (camara_width / 2), -camara_y + (camara_height / 2))
	end
end