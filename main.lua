function table_length(T)
 	local count = 0
 	for _ in pairs(T) do count = count + 1 end
 	return count
end

function love.load(arg)
	-- Configuración
	math.randomseed(os.time())
	love.window.setMode(1280, 720, {resizable=false})
	love.window.setTitle( 'Alunizaje' )
	fondo = { x = 0, y = 0, img = love.graphics.newImage('assets/img/fondo.jpg') }
	game_height = 2880
	game_width = 1280
	gravedad = 2
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
		y = math.random(0, game_height - temp_img:getHeight()), 
		speed = math.random(1, max_speed), 
		img = temp_img,
		angle = math.random(0, 90)}
	end
end

function love.update(dt)
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
end

function love.draw()
  	-- Camara
  	camara_y = -nave.body:getY() + (game_height / 8) - nave.img:getHeight()
	if (game_height / 8) - nave.img:getHeight() <= nave.body:getY() then 
  		love.graphics.translate(0, camara_y)
  	end
	if game_height - (game_height / 6) < nave.body:getY() then
 		love.graphics.translate(0, -game_height)
  	end
  	
	-- Fondo
	love.graphics.draw(fondo.img, fondo.x, fondo.y)

	-- Asteroides
	for key, value in pairs(asteroides) do
		love.graphics.draw(value.img, value.x, value.y, value.angle, 1, 1, value.img:getWidth() / 2, value.img:getHeight() / 2)
	end

	-- Nave
	love.graphics.draw(nave.img, nave.body:getX(), nave.body:getY())
end

