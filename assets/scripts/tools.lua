local tools = {}

-- Get Table length
function tools.table_length(T)
 	local count = 0
 	for _ in pairs(T) do count = count + 1 end
 	return count
end

-- Pause system n seconds
local clock = os.clock
function tools.sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

-- Collision detection function
function tools.check_circle_collision(circle1, circle2)
	local distance = math.sqrt((circle1.x - circle2.x) ^ 2 + (circle1.y - circle2.y) ^ 2)
	return distance <= circle1.radius + circle2.radius
end

-- Deep copy table
function tools.clone_table(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[tools.clone_table(orig_key)] = tools.clone_table(orig_value)
        end
        setmetatable(copy, tools.clone_table(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return tools