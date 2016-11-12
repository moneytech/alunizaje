local spaceship = require 'assets/scripts/spaceship'
local controls = require 'assets/scripts/controls'

-- LOAD
function love.load()
	-- Configuration
	math.randomseed(os.time())
	local width, height = love.window.getDesktopDimensions( display )
	window = { width = width , height = height }
	love.window.setMode(window.width, window.height)
	-- Physics
	world_meter = 64
	gravity = 2
	love.physics.setMeter(world_meter) -- Height earth in meters
  	world = love.physics.newWorld(0, gravity * world_meter, true) -- Make earth
	-- Spaceship
	spaceship.load(world)
end

-- UPDATE
function love.update(dt)
	world:update(dt)
	controls.update(dt)
	spaceship.update(dt)
end

-- DRAW
function love.draw()
	spaceship.draw()
end

-- CONTROLS
function love.keyreleased(key)
	-- sounds.keyreleased(key)
end

function love.mousereleased(key)
	-- sounds.mousereleased(key)
end