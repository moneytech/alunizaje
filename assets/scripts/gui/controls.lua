local anim8 = require 'assets/scripts/vendor/anim8'
local controls = {}
local BUTTONS = {}

function controls.load(game)
	-- Button left
  	local img_button_left = love.graphics.newImage('assets/sprites/gui/button_left.png')
	local left_x = PADDING
	local left_y = game.window.height - img_button_left:getHeight() - PADDING
	controls.new_button('button_left', left_x, left_y, img_button_left)
	-- Button right
  	local img_button_right = love.graphics.newImage('assets/sprites/gui/button_right.png')
	local right_x = game.window.width - (img_button_right:getWidth() / 2) - PADDING
	local right_y = game.window.height - img_button_right:getHeight() - PADDING
	controls.new_button('button_right', right_x, right_y, img_button_right)
	-- Button up
	local img_button_up = love.graphics.newImage('assets/sprites/gui/button_up.png')
	local up_x = game.window.width - (img_button_up:getWidth() / 2) - PADDING
	local up_y = right_y - img_button_up:getHeight() - PADDING
	controls.new_button('button_up', up_x, up_y, img_button_up)
end

function controls.draw()
    for key, button in pairs(BUTTONS) do
		button.animation:draw(button.img, button.x, button.y)
	end
end

function controls.keypressed(key, scancode, isrepeat)
	if key == 'escape' or key == 'q' then
		CONTROL_QUIT = true
	end
	if key == 'right' then 
		CONTROL_RIGHT = true
    elseif key == 'left' then 
    	CONTROL_LEFT = true
    end
  	if key == 'up' then 
  		CONTROL_UP = true
    end
end

function controls.keyreleased(key, scancode)
	CONTROL_UP, CONTROL_RIGHT, CONTROL_LEFT, CONTROL_QUIT = false, false, false, false
end

function controls.mousepressed(x, y, button, istouch)
	local buttons_pressends = {}
	for key, button in pairs(BUTTONS) do
		if button.x <= x and x <= (button.x + (button.img:getWidth() / 2)) and button.y <= y and y <= (button.y + button.img:getHeight()) then
			table.insert(buttons_pressends, button.name)
			button.animation:gotoFrame(2)
			mouse_actions(button.name)
		end
	end
end

function controls.mousereleased(x, y, button, istouch)
	CONTROL_UP, CONTROL_RIGHT, CONTROL_LEFT, CONTROL_QUIT = false, false, false, false
	for key, button in pairs(BUTTONS) do
		button.animation:gotoFrame(1)
	end
end

function controls.new_button(name, x, y, img)
  	img_temp = img
  	g = anim8.newGrid(img_temp:getWidth() / 2, img_temp:getHeight(), img_temp:getWidth(), img_temp:getHeight())
	table.insert(BUTTONS, {
		name=name,
		x=x,
		y=y,
		img=img_temp,
  		animation = anim8.newAnimation(g('1-2', 1), 1)
	})
end

function mouse_actions(name)
	if name == 'button_left' then
		CONTROL_LEFT = true
	elseif name == 'button_right' then
		CONTROL_RIGHT = true
	elseif name == 'button_up' then
		CONTROL_UP = true
	end
end

return controls