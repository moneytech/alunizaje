local gamera = require 'assets/scripts/vendor/gamera'

camera = {}
local limit = 200

function camera.load(game)
	camera.gcam = gamera.new(0, 0, game.window.width, game.window.height)
	camera.gcam:setWorld(0, 0, game.canvas.width, game.canvas.height)
end

function camera.update(game, spaceship)
	camera.gcam:setPosition(0, spaceship.y + limit)
end

return camera