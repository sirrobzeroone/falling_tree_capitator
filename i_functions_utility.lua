




----------------------------------------------------
--         Function: intersect_normal             -- 
----------------------------------------------------
-- Converts a pointed_thing pos group to an intersection_normal
-- output is structured as {x = 0, y = 0, z = 0} same as minetest:api 
-- for pointed_thing.
-- 0 = not that face, +1 = positive that face, -1 = negative that face

function falling_tree_capitator.intersect_normal(player,pointed_thing) 
	local output = {x=0,y=0,z=0}
	local node_pos = pointed_thing.under
	local node_fine_pos = minetest.pointed_thing_to_face_pos(player,pointed_thing)		
	local node_fine = {}
	      node_fine.x = node_fine_pos.x - node_pos.x
	      node_fine.y = node_fine_pos.y - node_pos.y
	      node_fine.z = node_fine_pos.z - node_pos.z
	for axis,value in pairs(output) do
	
		if node_fine[axis] == 0.5 then
			output[axis] = 1			
		elseif node_fine[axis] == -0.5 then
			output[axis] = -1
		end
		
	end
	return output
end

----------------------------------------------------
--            Function: throw_items               -- 
----------------------------------------------------
function falling_tree_capitator.throw_item(pos, item, dir, height)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.add_entity(pos, "__builtin:item")
	local pos_f = {x=-1, y=3, z=-1}
	local pos_t = {x=2, y=6, z=2}
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())			
			if dir.x > 0 then
				pos_t.z = -1.25*height
				
			elseif dir.x < 0 then
				pos_t.z = 1.25*height	
				
			elseif dir.z > 0 then
				pos_t.x = 1.25*height
				
			else 
				pos_t.x = -1.25*height
			end		
		local x=math.random(pos_f.x,pos_t.x)*math.random()
		local y=math.random(pos_f.y,pos_t.y)
		local z=math.random(pos_f.z,pos_t.z)*math.random()
		obj:setvelocity({x=x, y=y, z=z})
	end
	return obj
end