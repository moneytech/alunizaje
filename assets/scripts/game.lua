local game = {}

function game.load()
	-- Configuration
	math.randomseed(os.time())
	PADDING = 50
	game.lifes = 3
	local width, height = love.window.getDesktopDimensions( display )
	game.window = { width = width , height = height }
	game.canvas = { width = width, height = 2880 }
	love.window.setMode(game.window.width, game.window.height)
	game.level = 1
	game.play = true
	game.die = false
	-- Physics
	DEBUG = true
	local world_meter = 64
	local gravity = 2
	love.physics.setMeter(world_meter) -- Height earth in meters
  	game.world = love.physics.newWorld(0, gravity * world_meter, true) -- Make earth
end

function game.update(dt)
end

function game.draw()
	if DEBUG then
		love.graphics.print('FPS: ' .. love.timer.getFPS(), 50, 50)
	end
end

return game