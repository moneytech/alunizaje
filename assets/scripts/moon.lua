local tools = require 'assets/scripts/tools'

moon = {}

function moon.load(game)
	local imgs = {
		love.graphics.newImage('assets/sprites/moon/body1.png'), 
		love.graphics.newImage('assets/sprites/moon/body2.png'), 
		love.graphics.newImage('assets/sprites/moon/body3.png')
	}
	moon.img = imgs[math.random(1, tools.table_length(imgs))]
	moon.x = 0
	moon.y = game.canvas.height - moon.img:getHeight()
	moon.bodys = {}
	-- Repeat
	if moon.img:getWidth() < game.window.width then
		for i = 1, math.ceil(game.window.width / moon.img:getWidth()) do
			moon.bodys[i] = (i - 1) * moon.img:getWidth()
		end
	end
end

function moon.update()
end

function moon.draw(game)
	for key, tile in pairs(moon.bodys) do
		love.graphics.draw(moon.img, tile, moon.y)
	end
end

return moon