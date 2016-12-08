local controls = {}

function controls.load(game)
	controls.padding = 50
	controls.img_right = love.graphics.newImage('assets/sprites/hui/button.png')
	controls.right_x = game.window.width - controls.img_right:getWidth() - controls.padding
	controls.right_y = game.window.height - controls.img_right:getHeight() - controls.padding
end

function controls.update(dt)
	control_up, control_right, control_left, control_quit = false, false, false, false
		-- Keyboard
	if love.keyboard.isDown('escape') or love.keyboard.isDown('q') then
		control_quit = true
	end
	if love.keyboard.isDown('right') then 
		control_right = true
    elseif love.keyboard.isDown('left') then 
    	control_left = true
    end
  	if love.keyboard.isDown('up') then 
  		control_up = true
    end
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

return controls