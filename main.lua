local game = require 'assets/scripts/game'
local background = require 'assets/scripts/background'
local spaceship = require 'assets/scripts/spaceship'
local asteroids = require 'assets/scripts/asteroids'
local moon = require 'assets/scripts/moon'
local controls = require 'assets/scripts/controls'
local camera = require 'assets/scripts/camera'

-- LOAD
function love.load()
	game.load()	
	camera.load(game)
	background.load(game)
	asteroids.load(game)
	moon.load(game)
	spaceship.load(game)
end

-- UPDATE
function love.update(dt)
	game.world:update(dt)
	background.update(dt)
	asteroids.update(dt, game)
	moon.update()
	spaceship.update(dt, game)
	camera.update(game, spaceship)
	controls.update(dt)
end

-- DRAW
function love.draw()
	camera.gcam:draw(function(l,t,w,h)
		background.draw()
		moon.draw()
		spaceship.draw()
		asteroids.draw()
	end)
end

-- CONTROLS
function love.keyreleased(key)
	-- sounds.keyreleased(key)
end

function love.mousereleased(key)
	-- sounds.mousereleased(key)
end