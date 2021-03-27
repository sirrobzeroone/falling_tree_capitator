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

-- Global table named the same as mod to allow for easier
-- identification if someone is looking at all globals loaded.
falling_tree_capitator = {}
falling_tree_capitator.tree_config = {}
falling_tree_capitator.bvav_settings = {}
falling_tree_capitator.bvav_settings.attach_scaling = 30
falling_tree_capitator.bvav_settings.scaling = 0.667
-----------------------------------------------------
--                    Tree Config                  --
-----------------------------------------------------
dofile(modpath .. "/i_functions_utility.lua")
dofile(modpath .. "/i_register_tree_entity.lua")
dofile(modpath .. "/i_register_schematic_trees.lua")
dofile(modpath .. "/i_register_moretrees.lua")

--minetest.debug("db: "..dump(falling_tree_capitator.tree_config))

-----------------------------------------------------
--       Tree override on_dig and on_punch         --
-----------------------------------------------------
for tree_name,def in pairs(falling_tree_capitator.tree_config) do
	if minetest.registered_nodes[tree_name] then
		minetest.override_item(tree_name,
			{				
			on_dig = function(pos, node, digger)
						local digger_pos = digger:get_pos()
						local eye_height = digger:get_properties().eye_height
						local eye_offset = digger:get_eye_offset()
						digger_pos.y = digger_pos.y + eye_height
						digger_pos = vector.add(digger_pos, eye_offset)
						
						-- get wielded item range 5 is engine default
						-- order tool/item range >> hand_range >> fallback 5
						local tool_range = digger:get_wielded_item():get_definition().range	or nil					
						local hand_range						
							for key, val in pairs(minetest.registered_items) do								
								if key == "" then
									hand_range = val.range or nil
								end
							end
						local wield_range = tool_range or hand_range or 5
						
						-- determine ray end position
						local look_dir = digger:get_look_dir()
						look_dir = vector.multiply(look_dir, wield_range)
						local end_pos = vector.add(look_dir, digger_pos)

						-- get pointed_thing
						local ray = {}
						local ray = minetest.raycast(digger_pos, end_pos, false, false)
						local ray_pt = ray:next()
						
						local normal = ray_pt.intersection_normal						
						
					-- intersection_normal provides the node face dir eg facing +/- X/Z/Y. However
					-- this is used later to rotate the entity which rotates around that axis.
					-- So if the face chopped is an X face and the player is facing the tree
					-- the tree will fall to the left (rotating around X axis). As we want the tree 
					-- to fall towards the cut face we need to reverse the X/Z values, we must also
					-- reverse +- for intersection_normal.z.
						local dir = {x=-1*normal.z, y=normal.y,z=normal.x}

						bvav_create_vessel(pos,dir,tree_name,node,digger)

						
					 end,	
		})
	end
end

function spawn_bvav_element(p, node)
	local obj = core.add_entity(p, "falling_tree_capitator:tree_element")
	obj:get_luaentity():set_node(node)
	return obj
end


function bvav_create_vessel(pos,dir,tree_name,node,digger)
	local parent	
	local pos_top
	local x_pos
	local trunk_pieces
	local top_y = 0
	local h_chk = 0
	local pos2 = pos
	local is_fall = false
	local is_first_log = false

	
	local tree_h
	local tree_t
	local leaf_n
	local leaf_w
	local leaf_h
	local brch_h
	local brch_l
	local brch_w
	local frut_n
	local frut_h
	local frut_l

--[[-------------------------------------------------
--    Work out Trunk type were a tree maybe any    --
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
large trees being treated as singles - assuming we have a registered "s" for that tree if not
then tree node is treated as an individual log/trunk node like standard MT Game behaviour.

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

	local node_meta = minetest.get_meta(pos)
	if node_meta:get_string("fall_tree_cap") == "" then   -- first node cut if not single
		is_first_log = true
		local offset_val = {     --Bottom Left \/
							{["x"] = -2, ["z"] = -2},{["x"] = -1, ["z"] = -2},{["x"] = 0, ["z"] = -2},{["x"] = 1, ["z"] = -2},{["x"] = 2, ["z"] = -2},
							{["x"] = -2, ["z"] = -1},{["x"] = -1, ["z"] = -1},{["x"] = 0, ["z"] = -1},{["x"] = 1, ["z"] = -1},{["x"] = 2, ["z"] = -1},
							{["x"] = -2, ["z"] = 0} ,{["x"] = -1, ["z"] = 0} ,{["x"] = 0, ["z"] = 0} ,{["x"] = 1, ["z"] = 0} ,{["x"] = 2, ["z"] = 0},
							{["x"] = -2, ["z"] = 1} ,{["x"] = -1, ["z"] = 1} ,{["x"] = 0, ["z"] = 1} ,{["x"] = 1, ["z"] = 1} ,{["x"] = 2, ["z"] = 1},
							{["x"] = -2, ["z"] = 2} ,{["x"] = -1, ["z"] = 2} ,{["x"] = 0, ["z"] = 2} ,{["x"] = 1, ["z"] = 2} ,{["x"] = 2, ["z"] = 2},
						   }                                                                                                     -- Top Right /\			
		local dbl_trunk ={{8,9,14},{7,8,12},{12,17,18},{14,18,19}}           -- array positions for valid double trunk
		local crs_trunk ={{14,9,15,19},{18,17,19,23},{12,7,11,17},{8,3,7,9}} 
		local trp_trunk ={{9,3,4,5,8,10,14,15},{19,14,15,18,20,23,24,25},
						{17,11,12,16,18,21,22,23},{7,1,2,3,6,8,11,12}, 
						{12,6,7,8,11,16,17,18},{14,8,9,10,15,18,19,20},
						{18,12,14,17,19,22,23,24},{8,2,3,4,7,9,12,14}} 
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
		if falling_tree_capitator.tree_config[tree_name]["t"] then
			for k,v in pairs(trp_trunk) do			
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

		if type(trunk_pieces) ~= "table" and falling_tree_capitator.tree_config[tree_name]["x"] then
			for k,v in pairs(crs_trunk) do
				if type(cross_arr[v[1]]) =="table" and 
				   type(cross_arr[v[2]]) =="table" and
				   type(cross_arr[v[3]]) =="table" and
				   type(cross_arr[v[4]]) =="table" then
				   
				   trunk_pieces = {cross_arr[v[1]],cross_arr[v[2]],cross_arr[v[3]],
								   cross_arr[v[4]],pos,["type"]="x"}
				end   
			end						
		end
		
		if type(trunk_pieces) ~= "table" and falling_tree_capitator.tree_config[tree_name]["d"] then			
			for k,v in pairs(dbl_trunk) do			
				if type(cross_arr[v[1]]) =="table" and 
				   type(cross_arr[v[2]]) =="table" and 
				   type(cross_arr[v[3]]) =="table" then
				   
				   trunk_pieces = {cross_arr[v[1]],cross_arr[v[2]],cross_arr[v[3]],pos,["type"]="d"}
				end   
			end
		end
		
		if type(trunk_pieces) ~= "table" then
			trunk_pieces = {["type"]="s"}
		end
		
		 local tree = tree_name
		 
		 -- catch any odd tree finds that dont have a config tree type that matches
		 -- and simply set these too default values which result in log/trunk node being
		 -- treated as an individual node.
		 if falling_tree_capitator.tree_config[tree][trunk_pieces.type] == nil then   
			tree_h = 1
			tree_t = "s"
			leaf_n = {"falling_tree_capitator:leaf_name_place_holder"}
			leaf_w = 1
			leaf_h = 1
			brch_h = 1
			brch_l = 1
			brch_w = 1
			frut_n = {}
			frut_h = 0
			frut_l = 0		 
		else 
			tree_h = falling_tree_capitator.tree_config[tree][trunk_pieces.type].th
			tree_t = falling_tree_capitator.tree_config[tree][trunk_pieces.type].tt
			leaf_n = falling_tree_capitator.tree_config[tree][trunk_pieces.type].lv
			leaf_w = falling_tree_capitator.tree_config[tree][trunk_pieces.type].lw
			leaf_h = falling_tree_capitator.tree_config[tree][trunk_pieces.type].lh
			brch_h = falling_tree_capitator.tree_config[tree][trunk_pieces.type].bx
			brch_l = falling_tree_capitator.tree_config[tree][trunk_pieces.type].bn
			brch_w = falling_tree_capitator.tree_config[tree][trunk_pieces.type].bw
			frut_n = falling_tree_capitator.tree_config[tree][trunk_pieces.type].ft
			frut_h = falling_tree_capitator.tree_config[tree][trunk_pieces.type].fx
			frut_l = falling_tree_capitator.tree_config[tree][trunk_pieces.type].fn
		end
	-- write related node positions to all nodes meta plus tree trunk type,  
	-- skip ["type"] field using ipairs as not a position
		
		if trunk_pieces.type ~= "s" then
			for k,pos in ipairs(trunk_pieces) do					
				local n_meta = minetest.get_meta(pos)
					  n_meta:set_string("fall_tree_cap",minetest.serialize(trunk_pieces))						  
			end
		end

		
	else
		local temp_p_t = node_meta:get_string("fall_tree_cap")
		local rel_pos2 = minetest.deserialize(temp_p_t)			
		local tree = tree_name
		
			tree_h = falling_tree_capitator.tree_config[tree][rel_pos2.type].th
			tree_t = falling_tree_capitator.tree_config[tree][rel_pos2.type].tt
			leaf_n = falling_tree_capitator.tree_config[tree][rel_pos2.type].lv
			leaf_w = falling_tree_capitator.tree_config[tree][rel_pos2.type].lw
			leaf_h = falling_tree_capitator.tree_config[tree][rel_pos2.type].lh
			brch_h = falling_tree_capitator.tree_config[tree][rel_pos2.type].bx
			brch_l = falling_tree_capitator.tree_config[tree][rel_pos2.type].bn
			brch_w = falling_tree_capitator.tree_config[tree][rel_pos2.type].bw
			frut_n = falling_tree_capitator.tree_config[tree][rel_pos2.type].ft
			frut_h = falling_tree_capitator.tree_config[tree][rel_pos2.type].fx
			frut_l = falling_tree_capitator.tree_config[tree][rel_pos2.type].fn	
	end

							    -- name 
	local tree_parts = {}
	local tree_parts = {["leaf"]={leaf_n,leaf_h,pos.y,leaf_w},
					    ["logs"]={tree_name,brch_h,brch_l,brch_w},
						["frut"]={frut_n,frut_h,frut_l,leaf_w}
					   }

-----------------------------------------------------
--         Get middle of trunk for X & T           --
-----------------------------------------------------
	if tree_t == "x" or tree_t == "t" then 
		
		local t_pos
		
		if is_first_log then
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
		is_fall = true
		
	else		
		local is_last_log = true			
			if not is_first_log then                                -- is_first_log == true, no change to anything and no checks
			
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
								is_last_log = false
							end					
						end								
					end			
			end
			
			if is_last_log and not is_first_log then
				is_fall = true
			end
	end

-----------------------------------------------------
--   "If" restores default behaviour in the event  --
--    single log or no leaves helps builders who   --
--    may use logs in structures                   --
-----------------------------------------------------

	if is_fall == false or 
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
								parent:get_luaentity().ttype = tree_t

								
							else
								local child = spawn_bvav_element(npos_t, {name=tree_name})
								child:get_luaentity().parent = parent			
								child:get_luaentity().relative = {x=(npos_t.x - t_cent.x )* falling_tree_capitator.bvav_settings.attach_scaling,
																  y=y * falling_tree_capitator.bvav_settings.attach_scaling,
																  z=(npos_t.z-t_cent.z)* falling_tree_capitator.bvav_settings.attach_scaling}
								child:set_attach(parent, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
								child:set_properties({visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}})
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
						child:get_luaentity().relative = {x=x * falling_tree_capitator.bvav_settings.attach_scaling,y=y * falling_tree_capitator.bvav_settings.attach_scaling,z=z * falling_tree_capitator.bvav_settings.attach_scaling}
						child:set_attach(parent, "", {x=x * falling_tree_capitator.bvav_settings.attach_scaling,y=y * falling_tree_capitator.bvav_settings.attach_scaling,z=z * falling_tree_capitator.bvav_settings.attach_scaling}, {x=0,y=0,z=0})
						child:set_properties({visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}})
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
					child:get_luaentity().relative = {x=x * falling_tree_capitator.bvav_settings.attach_scaling,y=y * falling_tree_capitator.bvav_settings.attach_scaling,z=z * falling_tree_capitator.bvav_settings.attach_scaling}
					child:set_attach(parent, "", {x=x * falling_tree_capitator.bvav_settings.attach_scaling,y=y * falling_tree_capitator.bvav_settings.attach_scaling,z=z * falling_tree_capitator.bvav_settings.attach_scaling}, {x=0,y=0,z=0})
					child:set_properties({visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}})
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


