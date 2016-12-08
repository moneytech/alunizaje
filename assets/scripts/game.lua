local game = {}

function game.load()
	-- Configuration
	math.randomseed(os.time())
	local width, height = love.window.getDesktopDimensions( display )
	game.window = { width = width , height = height }
	game.canvas = { width = width, height = 2880 }
	love.window.setMode(game.window.width, game.window.height)
	game.level = 1
	-- Physics
	local world_meter = 64
	local gravity = 2
	love.physics.setMeter(world_meter) -- Height earth in meters
  	game.world = love.physics.newWorld(0, gravity * world_meter, true) -- Make earth
  	-- Collisions
  	--game.collisions = HC.new(150)
end

return game