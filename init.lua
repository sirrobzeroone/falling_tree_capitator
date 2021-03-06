---------------------------------------------------------------------------------------------------
--                      ___________      .__  .__  .__                                           --  
--                      \_   _____/____  |  | |  | |__| ____    ____                             --
--                       |    __) \__  \ |  | |  | |  |/    \  / ___\                            --
--                       |     \   / __ \|  |_|  |_|  |   |  \/ /_/  >                           --
--                       \___  /  (____  /____/____/__|___|  /\___  /                            --
--                           \/        \/                  \//_____/                             --
-- ___________                       _________               .__  __          __                 --
-- \__    ___/______   ____   ____   \_   ___ \_____  ______ |__|/  |______ _/  |_  ___________  --
--   |    |  \_  __ \_/ __ \_/ __ \  /    \  \/\__  \ \____ \|  \   __\__  \\   __\/  _ \_  __ \ --
--   |    |   |  | \/\  ___/\  ___/  \     \____/ __ \|  |_> >  ||  |  / __ \|  | (  <_> )  | \/ --
--   |____|   |__|    \___  >\___  >  \______  (____  /   __/|__||__| (____  /__|  \____/|__|    --
--                        \/     \/          \/     \/|__|                 \/                    --
---------------------------------------------------------------------------------------------------
-- 										Original Code Oilboi                                     --
--                                         License GPLV2                                         --
---------------------------------------------------------------------------------------------------

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

-----------------------------------------------------
--                    Tree Config                  --
-----------------------------------------------------
dofile(modpath .. "/i_tree_config_default.lua")
dofile(modpath .. "/i_tree_config_moretrees.lua")

-----------------------------------------------------
bvav_settings = {}
bvav_settings.attach_scaling = 30
bvav_settings.scaling = 0.667

-----------------------------------------------------
--            Tree override on_dig                 --
-----------------------------------------------------
for tree_name,def in pairs(tree_config) do
	if minetest.registered_nodes[tree_name] then
		minetest.debug(tree_name)
		minetest.override_item(tree_name,
			{
			on_dig = function(pos, node, digger)
				local dir = minetest.facedir_to_dir(minetest.dir_to_facedir(minetest.yaw_to_dir(digger:get_look_horizontal()+(math.pi/2))))
				bvav_create_vessel(pos,dir,tree_name,node,digger)		
			end,	
		})
	end
end

----------------------------------------------------
--     Function: Throw Chopped Tree Items         -- 
----------------------------------------------------
function minetest.throw_item(pos, item, dir, height)
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

----------------------------------------------------
--               Tree Entity Setup                -- 
----------------------------------------------------
minetest.register_entity("falling_tree_capitator:tree_element", {
	initial_properties = {
						physical = true,
						collide_with_objects = false,
						pointable = false,
						collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
						visual = "wielditem",
						textures = {},
						automatic_face_movement_dir = 0.0,
						visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}
						},

	node = {},

	set_node = function(self, node)
		self.node = node
		local prop = {
			is_visible = true,
			textures = {node.name},
			visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return self.node.name
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal=1})
		if staticdata then
			self:set_node({name=staticdata})
		end
		minetest.after(0,function()
			
			if self.parent ~= nil and self.relative ~= nil then
				self.object:set_attach(self.parent, "", {x=self.relative.x,y=self.relative.y,z=self.relative.z}, {x=0,y=0,z=0})
				self.object:set_properties({visual_size = {x=bvav_settings.scaling*3, y=bvav_settings.scaling*3}})
				--self.object:set_properties({})
			else
				--this fixes issues with scaling
				self.object:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})

			end
		end)
	end,
	rotation = vector.new(0,0,0),
	on_step = function(self, dtime)
		
		if self.rotator and self.rotate_dir then
			local current_rot = self.object:get_rotation()
			
			-- Throw items on ground that made up parts of the tree:
			-- logs, leaves, sticks,saplings and fruit/attachments
			
			if math.abs(current_rot.x) > math.pi/2 or math.abs(current_rot.z) > math.pi/2 then
			
				-- Create a table of all items that may need throwing as result of the
				-- tree being cut down. This includes adding sticks(1/10 leaves) and saplings(1/20 leaves)
				-- note The below only throws 1/10 of the actual leaf nodes in the tree.
				local throw_parts={}				
				
				if type(tree_config[self.node.name].lv) == "table" then
					local leaf_total = 0
					throw_parts[self.node.name] = self.logs
					throw_parts[tree_config[self.node.name].ft] = self.frut
					
						for k,leaf_name in pairs(tree_config[self.node.name].lv) do
							-- self[leaf_name] stores count of that type 
							-- of leaf from when entity was created
							leaf_total = leaf_total + self[leaf_name]
							throw_parts[leaf_name]=self[leaf_name]/10
						end	
					
					throw_parts[tree_config[self.node.name].sp] = leaf_total/20						
					throw_parts["default:stick"] = leaf_total/10
				else
					throw_parts = {[self.node.name]                 = self.logs,
								   [tree_config[self.node.name].lv] = self.leaf/10,
								   [tree_config[self.node.name].sp] = self.leaf/20,
								   ["default:stick"]                = self.leaf/10,								   
								   [tree_config[self.node.name].ft] = self.frut}				
				end

				-- Loop through the above table and use throw_item to distribute the items.
					for node_name,node_num in pairs(throw_parts) do
					    -- "if" misses fruit if the name is set to "0"
						if node_name ~= 0 then
							for i = 1,node_num do
								local pos = self.object:get_pos()
								minetest.throw_item(pos,{name=node_name},self.rotate_dir,tree_config[self.node.name].th)
							end
						end					
					end

				minetest.sound_play("tree_thud",{pos=self.object:get_pos()})
				self.object:remove()
			end
			
			if self.rotate_dir.x ~= 0 then
				current_rot.x = current_rot.x + (dtime/(self.rotate_dir.x*2.82))
			elseif self.rotate_dir.z ~= 0 then
				current_rot.z = current_rot.z + (dtime/(self.rotate_dir.z*2.82))
			end
			self.object:set_rotation(current_rot)
		else
			if not self.parent or not self.parent:get_luaentity() then
				self.object:remove()
			end
		end
	end,
})


function spawn_bvav_element(p, node)
	local obj = core.add_entity(p, "falling_tree_capitator:tree_element")
	obj:get_luaentity():set_node(node)
	return obj
end


function bvav_create_vessel(pos,dir,tree_name,node,digger)
	local parent	
	local top_y = 0
	local h_chk = 0
	local pos_cut = pos
	local pos_top
	local x_pos
	local pos2 = pos
	local fall = false
	local first_log = false
	local trunk_pieces
	local tree_h = tree_config[tree_name].th
	local tree_t = tree_config[tree_name].tt
	local leaf_n = tree_config[tree_name].lv
	local leaf_w = tree_config[tree_name].lw
	local leaf_h = tree_config[tree_name].lh
	local brch_h = tree_config[tree_name].bx
	local brch_l = tree_config[tree_name].bn
	local brch_w = tree_config[tree_name].bw
	local frut_n = tree_config[tree_name].ft
	local frut_h = tree_config[tree_name].fx
	local frut_l = tree_config[tree_name].fn

--[[-------------------------------------------------
--  Work out Trunk type were a tree maybe any "a"  --
-----------------------------------------------------
There are 4 main trunk types single, double, cross and triple(rare), we need
to work out on the 1st trunk block cut what type of trunk type we have, once 
this is found the remaining trunk pieces @ the same y have there type written into their meta
data.

All trunk types fit into a shaped grid as below - Cutting/Target node being marked
with a T and numbers moving outwards.
						
					+---+---+---+---+---+
					| 5 | 4 | 3 | 4 | 5 |
					+---+---+---+---+---+
					| 4 | 2 | 1 | 2 | 4 |
					+---+---+---+---+---+
					| 3 | 1 | T | 1 | 3 |
					+---+---+---+---+---+
					| 4 | 2 | 1 | 2 | 4 |
					+---+---+---+---+---+
					| 5 | 4 | 3 | 4 | 5 |
					+---+---+---+---+---+

The above and below assume a trunk is intact ie no missing nodes when created			    

Logic for Double trunk 2x2
The player must always be cutting from a corner for a double trunk the remaining 3 will 
always be a T,1,1,2

Logic for Crossed trunk 3x3 in + shape
The player must always be cutting from an end node, nodes will be T,1,2,2,3 

Logic for Triple trunk 3x3 solid square
The player must always be cutting from a corner or a middle side block patterns:
T,1,1,2,3,3,4,4,5 or T,1,1,1,2,2,3,4,4 

If none of the above are true then assume single trunk even though this may result in some
large trees being treated as singles.

Array is assembled as standard cartesian coords (x=x,z=y) - the array provides a top down view
of the 5x5 area with the cut node occuping what would be 0,0 on small cartesian graph

	Grid Above							Plus/Minus X/Z							  Array Pos Num
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+
| 5 | 4 | 3 | 4 | 5 |  | -2x +2z | -1x +2z | 0x +2z | +1x +2z | +2x +2z |  | 21 | 22 | 23 | 24 | 25 |
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+
| 4 | 2 | 1 | 2 | 4 |  | -2x +1z | -1x +1z | 0x +1z | +1x +1z | +2x +1z |  | 16 | 17 | 18 | 19 | 20 |
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+
| 3 | 1 | T | 1 | 3 |  | -2x 0z  | -1x 0z  | 0x 0z  | +1x 0z  | +2x 0z  |  | 11 | 12 | 13 | 14 | 15 |
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+
| 4 | 2 | 1 | 2 | 4 |  | -2x -1z | -1x -1z | 0x -1z | +1x -1z | +2x -1z |  |  6 |  7 |  8 |  9 | 10 |
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+
| 5 | 4 | 3 | 4 | 5 |  | -2x -2z | -1x -2z | 0x -2z | +1x -2z | +2x -2z |  |  1 |  2 |  3 |  4 |  5 |
+---+---+---+---+---+--+---------+---------+--------+---------+---------+--+----+----+----+----+----+ 
		
The values are fed into the array from bottom left corner to top right so:

 -2x -2z == position 1
 +2x +2z == position 25
  0x  0z == position 13 (cut/target node)
  
If a double tree was growing with no other trees around it which occupied from 0x0z to +1x+1z 
relative to true position then:

cross_arr[14] == position stored
cross_arr[18] == position stored
cross_arr[19] == position stored
all other array values would == 0

The array created stores pos values of a section plane for all tree/log/trunk pieces that match
the cut tree/log/trunk piece name

*Note to save/reuse of code I also push the triple, cross and double trees through this code as
it simplifies checks later on.
 
]]--	
	if tree_config[tree_name].tt ~= "s" then
		local node_meta = minetest.get_meta(pos)

		if node_meta:get_string("fall_tree_cap") == "" then   -- first node cut if not single
			first_log = true
			local offset_val = {     --Bottom Left \/
								{["x"] = -2, ["z"] = -2},{["x"] = -1, ["z"] = -2},{["x"] = 0, ["z"] = -2},{["x"] = 1, ["z"] = -2},{["x"] = 2, ["z"] = -2},
								{["x"] = -2, ["z"] = -1},{["x"] = -1, ["z"] = -1},{["x"] = 0, ["z"] = -1},{["x"] = 1, ["z"] = -1},{["x"] = 2, ["z"] = -1},
								{["x"] = -2, ["z"] = 0} ,{["x"] = -1, ["z"] = 0} ,{["x"] = 0, ["z"] = 0} ,{["x"] = 1, ["z"] = 0} ,{["x"] = 2, ["z"] = 0},
								{["x"] = -2, ["z"] = 1} ,{["x"] = -1, ["z"] = 1} ,{["x"] = 0, ["z"] = 1} ,{["x"] = 1, ["z"] = 1} ,{["x"] = 2, ["z"] = 1},
								{["x"] = -2, ["z"] = 2} ,{["x"] = -1, ["z"] = 2} ,{["x"] = 0, ["z"] = 2} ,{["x"] = 1, ["z"] = 2} ,{["x"] = 2, ["z"] = 2},
							   }                                                                                                     -- Top Right /\			
			local dbl_trk ={{8,9,14},{7,8,12},{12,17,18},{14,18,19}}           -- array positions for valid double trunk
			local crs_trk ={{14,9,15,19},{18,17,19,23},{12,7,11,17},{8,3,7,9}} -- as above cross trunk/1st value center of trunk
			local trp_trk ={{9,3,4,5,8,10,14,15},{19,14,15,18,20,23,24,25},
							{17,11,12,16,18,21,22,23},{7,1,2,3,6,8,11,12}, 
							{12,6,7,8,11,16,17,18},{14,8,9,10,15,18,19,20},
							{18,12,14,17,19,22,23,24},{8,2,3,4,7,9,12,14}}      -- as above triple trunk/1st value center of trunk
			local cross_arr = {}
			
			-- Assemble our cross section array when a match is found position is stored else 0
			for k,off in pairs(offset_val) do				
				local n_name = minetest.get_node({x=pos.x+off.x,y=pos.y,z=pos.z+off.z}).name
				
				if n_name == tree_name then
					table.insert(cross_arr, {x=pos.x+off.x,y=pos.y,z=pos.z+off.z})
				else
					table.insert(cross_arr, 0)
				end				
			end
		
		-- Check from largest trunk size to smallest trunk size
			if tree_config[tree_name].tt == "a" or tree_config[tree_name].tt == "t" then
				for k,v in pairs(trp_trk) do			
					if type(cross_arr[v[1]]) =="table" and 
					   type(cross_arr[v[2]]) =="table" and
					   type(cross_arr[v[3]]) =="table" and
					   type(cross_arr[v[4]]) =="table" and
					   type(cross_arr[v[5]]) =="table" and
					   type(cross_arr[v[6]]) =="table" and
					   type(cross_arr[v[7]]) =="table" and
					   type(cross_arr[v[8]]) =="table" then
					   
					   trunk_pieces = {cross_arr[v[1]],cross_arr[v[2]],cross_arr[v[3]],
									   cross_arr[v[4]],cross_arr[v[5]],cross_arr[v[6]],
									   cross_arr[v[7]],cross_arr[v[8]],pos,["type"]="t"}
					end   
				end
			end

			if type(trunk_pieces) ~= "table" and (tree_config[tree_name].tt == "a" or tree_config[tree_name].tt == "x")then
				for k,v in pairs(crs_trk) do
					if type(cross_arr[v[1]]) =="table" and 
					   type(cross_arr[v[2]]) =="table" and
					   type(cross_arr[v[3]]) =="table" and
					   type(cross_arr[v[4]]) =="table" then
					   
					   trunk_pieces = {cross_arr[v[1]],cross_arr[v[2]],cross_arr[v[3]],
									   cross_arr[v[4]],pos,["type"]="x"}
					end   
				end						
			end
			
			if type(trunk_pieces) ~= "table" and (tree_config[tree_name].tt == "a" or tree_config[tree_name].tt == "d")  then			
				for k,v in pairs(dbl_trk) do			
					if type(cross_arr[v[1]]) =="table" and 
					   type(cross_arr[v[2]]) =="table" and 
					   type(cross_arr[v[3]]) =="table" then
					   
					   trunk_pieces = {cross_arr[v[1]],cross_arr[v[2]],cross_arr[v[3]],pos,["type"]="d"}
					end   
				end
			end
			
			if type(trunk_pieces) ~= "table" then
				trunk_pieces = {["type"]="s"}
				tree_t = "s"

			end
			
			if (tree_config[tree_name].tt == "a" and trunk_pieces.type ~= "s") or 
			   trunk_pieces.type ~= "s" then   -- "s", "d", "x", "t"; whats already set initially
			  local tree = tree_name.."_"..trunk_pieces.type
			  
			  if tree_config[tree] == nil then
				tree = tree_name
			  end
			  
					tree_h = tree_config[tree].th
					tree_t = tree_config[tree].tt
					leaf_n = tree_config[tree].lv
					leaf_w = tree_config[tree].lw
					leaf_h = tree_config[tree].lh
					brch_h = tree_config[tree].bx
					brch_l = tree_config[tree].bn
					brch_w = tree_config[tree].bw
					frut_n = tree_config[tree].ft
					frut_h = tree_config[tree].fx
					frut_l = tree_config[tree].fn
					
				-- write related node positions to all nodes meta plus tree trunk type,  
				-- skip ["type"] field using ipairs as not a position
				for k,pos in ipairs(trunk_pieces) do					
					local n_meta = minetest.get_meta(pos)
						  n_meta:set_string("fall_tree_cap",minetest.serialize(trunk_pieces))						  
				end			
			end			
		else
			local temp_p_t = node_meta:get_string("fall_tree_cap")
			local rel_pos2 = minetest.deserialize(temp_p_t)			
			local tree = tree_name.."_"..rel_pos2.type
			
			if tree_config[tree] == nil then
				tree = tree_name
			end
			
				tree_h = tree_config[tree].th
				tree_t = tree_config[tree].tt
				leaf_n = tree_config[tree].lv
				leaf_w = tree_config[tree].lw
				leaf_h = tree_config[tree].lh
				brch_h = tree_config[tree].bx
				brch_l = tree_config[tree].bn
				brch_w = tree_config[tree].bw
				frut_n = tree_config[tree].ft
				frut_h = tree_config[tree].fx
				frut_l = tree_config[tree].fn	
		end
	end	
							    -- name   
	local tree_parts = {["leaf"]={leaf_n,leaf_h,pos_cut.y,leaf_w},
					    ["logs"]={tree_name,brch_h,brch_l,brch_w},
						["frut"]={frut_n,frut_h,frut_l,leaf_w}
					   }

-----------------------------------------------------
--         Get middle of trunk for X & T           --
-----------------------------------------------------
	if tree_t == "x" or tree_t == "t" then 
		
		local t_pos
		
		if first_log then
			t_pos = trunk_pieces
		else
			local n_meta = minetest.get_meta(pos)
			local temp_p_t = n_meta:get_string("fall_tree_cap")
			t_pos = minetest.deserialize(temp_p_t)
		end
			t_pos.type = nil
			
			local x_max = t_pos[1].x
			local z_max = t_pos[1].z
			local x_min = t_pos[1].x
			local z_min = t_pos[1].z

				for k,v in pairs(t_pos) do

					if v.x > x_max then
						x_max = v.x
					end

					if v.x < x_min then
						x_min = v.x
					end

					if v.z > z_max then
						z_max = v.z
					end

					if v.z < z_min then
						z_min = v.z
					end			
				end	
				
				local x_temp = (x_max+x_min)/2
				local z_temp = (z_max+z_min)/2
				x_pos = {x=x_temp,y=pos.y,z=z_temp}	
	end
	
-----------------------------------------------------
--         Get Tree Height for later check         --
-----------------------------------------------------

	for y = 0,tree_h do		
		local t_pos
		
		if tree_t == "x" or tree_t == "t"  then
			t_pos = vector.new(x_pos.x,pos.y+y,x_pos.z)
		else
			t_pos = vector.new(pos.x,pos.y+y,pos.z)
		end	
	
		local node = minetest.get_node(t_pos).name
			if node == tree_name then
				h_chk = y
				pos_top = t_pos				
			end	
	end
	
	if pos_top == nil then	
		if tree_t == "x" or tree_t == "t"  then
			pos_top = vector.new(x_pos.x,pos.y,x_pos.z)
		else
			pos_top = vector.new(pos.x,pos.y,pos.z)
		end	
	
	end

-----------------------------------------------------
--         Get Tree Leaves for later check         --
-----------------------------------------------------
	local l_pos
	if tree_t == "x" or tree_t == "t"  then
		l_pos = vector.new(x_pos.x,x_pos.y,x_pos.z)
	else
		l_pos = vector.new(pos.x,pos.y,pos.z)
	end

	local check_leaf = minetest.find_nodes_in_area({x=l_pos.x-leaf_w,y=l_pos.y,z=l_pos.z-leaf_w},
											   {x=pos_top.x+leaf_w,y=pos_top.y+leaf_h,z=pos_top.z+leaf_w}, 
											   leaf_n)

-----------------------------------------------------
--       Trunk thickness/last log check            --
-----------------------------------------------------
	if tree_t == "s" then
		fall = true
		
	else		
		local last_log = true			
			if not first_log then                                -- first_log == true, no change to anything and no checks
			
				local n_meta = minetest.get_meta(pos)
				local temp_p_t = n_meta:get_string("fall_tree_cap")
				local t_pos = minetest.deserialize(temp_p_t)
				t_pos.type = nil
					for k,pos2 in pairs(t_pos) do
						if pos2.x ~= pos.x or
						   pos2.y ~= pos.y or
						   pos2.z ~= pos.z then  -- remove nodes own pos reference

							local t_node = minetest.get_node(pos2).name					
							if t_node == tree_name then					
								last_log = false
							end					
						end								
					end			
			end
			
			if last_log and not first_log then
				fall = true
			end
	end

-----------------------------------------------------
--   "If" restores default behaviour in the event  --
--    single log or no leaves helps builders who   --
--    may use logs in structures                   --
-----------------------------------------------------

	if fall == false or 
	   h_chk <= 1 or
	   #check_leaf == 0 then	   
	   -- Does normal node dig
		minetest.node_dig(pos, node, digger)
	else			
	-----------------------------------------------------
	--                Main Tree Trunk Code             --
	-----------------------------------------------------
		
		local n_meta = minetest.get_meta(pos)
		local temp_p_t = n_meta:get_string("fall_tree_cap")
		local z_pos = minetest.deserialize(temp_p_t)	
		local t_cent
		
		if z_pos == nil then
			z_pos = {pos}
			t_cent = pos
		else
			t_cent = z_pos[1]
		end
				
		for y = 0,h_chk do
				--minetest.remove_node(pos)
				for k,v in ipairs(z_pos) do    -- dodges key == "type"
						
						local npos_t = vector.new({x=v.x,y=v.y+y,z=v.z})
						local node = minetest.get_node(npos_t).name
						
						if node == tree_name or
						   (y == 0 and k == 1) then
							minetest.remove_node(npos_t)	
							
							if not parent then
								parent = spawn_bvav_element(npos_t, {name=tree_name})
								parent:get_luaentity().rotator = true
								parent:get_luaentity().rotate_dir = dir
								parent:get_luaentity().logs = 1
								parent:get_luaentity().leaf = 0
								parent:get_luaentity().frut = 0

								
							else
								local child = spawn_bvav_element(npos_t, {name=tree_name})
								child:get_luaentity().parent = parent			
								child:get_luaentity().relative = {x=(npos_t.x - t_cent.x )* bvav_settings.attach_scaling,
																  y=y * bvav_settings.attach_scaling,
																  z=(npos_t.z-t_cent.z)* bvav_settings.attach_scaling}
								child:set_attach(parent, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
								child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
								parent:get_luaentity().logs = parent:get_luaentity().logs + 1
							end
						end
				end
		end

	-----------------------------------------------------
	--    Tree Parts; Leaves, Branches and fruit       --
	-----------------------------------------------------
	for k,v in pairs(tree_parts) do			
			local tp_pos
			if tree_t == "x" or tree_t == "t" then
				tp_pos = vector.new(x_pos.x,x_pos.y,x_pos.z)
			else
				tp_pos = vector.new(pos.x,pos.y,pos.z)
			end
			
			if type(v[1]) =="table" then			
				for k2,v2 in pairs(v[1])do
					local parts_table = minetest.find_nodes_in_area({x=tp_pos.x-v[4],y=tp_pos.y,z=tp_pos.z-v[4]},{x=tp_pos.x+v[4],y=pos_top.y+v[2],z=tp_pos.z+v[4]}, v2)
					parent:get_luaentity()[v2] = 0
					
					for _,l_pos in pairs(parts_table) do
						minetest.remove_node(l_pos)

						local x = l_pos.x - tp_pos.x
						local y = l_pos.y - tp_pos.y
						local z = l_pos.z - tp_pos.z
						local child = spawn_bvav_element(l_pos, {name=v2})
						child:get_luaentity().parent = parent			
						child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
						child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
						child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
						parent:get_luaentity()[v2] = parent:get_luaentity()[v2] + 1
					end	
				end			
			else
				local parts_table = minetest.find_nodes_in_area({x=tp_pos.x-v[4],y=tp_pos.y,z=tp_pos.z-v[4]},{x=tp_pos.x+v[4],y=pos_top.y+v[2],z=tp_pos.z+v[4]}, v[1])

				for _,l_pos in pairs(parts_table) do
					minetest.remove_node(l_pos)

					local x = l_pos.x - tp_pos.x
					local y = l_pos.y - tp_pos.y
					local z = l_pos.z - tp_pos.z
					local child = spawn_bvav_element(l_pos, {name=v[1]})
					child:get_luaentity().parent = parent			
					child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
					child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
					child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
					parent:get_luaentity()[k] = parent:get_luaentity()[k] + 1
				end
			end

		end
				
		minetest.sound_play("tree_fall",{object=parent})
			
		--- taken from item.lua line 574 ---
		local def = core.registered_nodes[node.name]
		local wielded = digger and digger:get_wielded_item()
		local diggername = digger:get_player_name()
		if wielded then
			local wdef = wielded:get_definition()
			local tp = wielded:get_tool_capabilities()
			local dp = core.get_dig_params(def and def.groups, tp)
			if wdef and wdef.after_use then
				wielded = wdef.after_use(wielded, digger, node, dp) or wielded
			else
				-- Wear out tool
				if not core.is_creative_enabled(diggername) then
					wielded:add_wear(dp.wear*parent:get_luaentity().tree)
					if wielded:get_count() == 0 and wdef.sound and wdef.sound.breaks then
						core.sound_play(wdef.sound.breaks, {
							pos = pos,
							gain = 0.5
						}, true)
					end
				end
			end
			digger:set_wielded_item(wielded)
		end
		--- end taken from item.lua line 574 ---
		
	end

end


