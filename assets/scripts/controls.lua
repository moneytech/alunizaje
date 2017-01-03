local controls = {}
local buttons = {}

function controls.load(game)
	controls.padding = 50
	controls.img_right = love.graphics.newImage('assets/sprites/hui/button.png')
	controls.right_x = game.window.width - controls.img_right:getWidth() - controls.padding
	controls.right_y = game.window.height - controls.img_right:getHeight() - controls.padding
end

function controls.update(dt)
	-- Keyboard
    	-- Mouse
	if love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		-- Up
		if x > button_up.x and x < button_up.x + button.img:getWidth() and y > button_up.y + camera.y and y < button_up.y + button.img:getHeight() + camera.y then
  			control_up = true
		end
		-- Right
		if x > button_right.x and x < button_right.x + button.img:getWidth() and y > button_right.y + camera.y and y < button_right.y + button.img:getHeight() + camera.y then
  			control_right = true
  		elseif x > button_left.x and x < button_left.x + button.img:getWidth() and y > button_left.y + camera.y and y < button_left.y + button.img:getHeight() + camera.y then
  			control_left = true
		end
	end
end

function controls.draw()
	love.graphics.draw(controls.img_right, controls.right_x, controls.right_y)
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
end

function controls.mousereleased(x, y, button, istouch)
end

return controls