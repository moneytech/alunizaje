local game = require 'assets/scripts/game'
local background = require 'assets/scripts/background'
local spaceship = require 'assets/scripts/spaceship'
local asteroids = require 'assets/scripts/asteroids'
local moon = require 'assets/scripts/moon'
local controls = require 'assets/scripts/gui/controls'
local life = require 'assets/scripts/gui/life'
local camera = require 'assets/scripts/camera'

-- LOAD
function love.load()
	game.load()	
	camera.load(game)
	background.load(game)
	asteroids.load(game)
	moon.load(game)
	spaceship.load(game)
	controls.load(game)
	life.load(game)
end

-- UPDATE
function love.update(dt)
	if DEBUG then
		require('assets/scripts/vendor/lovebird').update()
	end
	game.world:update(dt)
	background.update(dt)
	asteroids.update(dt, game)
	moon.update()
	spaceship.update(dt, game)
	life.update(dt, game)
	camera.update(game, spaceship)
end

-- DRAW
function love.draw()
	camera.gcam:draw(function(l,t,w,h)
		background.draw()
		moon.draw()
		spaceship.draw(game)
		asteroids.draw()
	end)
	controls.draw()
	life.draw()
end

-- CONTROLS
function love.keypressed(key, scancode, isrepeat)
	controls.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	controls.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch)
	controls.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	controls.mousereleased(x, y, button, istouch)
end