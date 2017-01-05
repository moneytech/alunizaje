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

-- Print table
function tools.print_r(t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function tools.distance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function tools.circle_position(angle, radius, x_center, y_center)
    local angle_temp = angle * math.pi / 180
    return x_center + radius * math.cos(angle_temp), y_center + radius * math.sin(angle_temp)
end

return tools