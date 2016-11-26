local game = require 'assets/scripts/game'
local background = require 'assets/scripts/background'
local spaceship = require 'assets/scripts/spaceship'
local asteroids = require 'assets/scripts/asteroids'
local controls = require 'assets/scripts/controls'

-- LOAD
function love.load()
	game.load()	
	background.load(game)
	asteroids.load(game)
	spaceship.load(game)
end

-- UPDATE
function love.update(dt)
	game.world:update(dt)
	background.update(dt)
	asteroids.update(dt, game)
	spaceship.update(dt)
	controls.update(dt)
end

-- DRAW
function love.draw()
	background.draw()
	spaceship.draw()
	asteroids.draw()
end

-- CONTROLS
function love.keyreleased(key)
	-- sounds.keyreleased(key)
end

function love.mousereleased(key)
	-- sounds.mousereleased(key)
end