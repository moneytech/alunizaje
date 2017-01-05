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
	if game.die then
		game.lifes = game.lifes - 1
		game.die = false
	end
end

return game