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
bvav_settings = {}
bvav_settings.attach_scaling = 30
bvav_settings.scaling = 0.667

-----------------------------------------------------
--                    Tree Config                  --
-----------------------------------------------------
--h  == tree trunk height
--t  == trunk type, s == single, x == crossed, a == asymmetric eg palm
--w  == tree leaves width
--bx == branch max relative to top eg 1 == +1 higher than top of tree
--bn == branch min relative to top eg 1 == -1 below top of tree
--bw == branch width relative to trunk eg 1 == +1 & -1 out from each side
--lv == leaves name eg "default:leaves" must be supplied.
--ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
--ftx == fruit max above trunk top
--ftn == fruit min below trunk top
tree_config = {
				["default:tree"]               = {["h"] = 5, ["t"] = "s",["w"] = 3 ,["bx"] = 1,["bn"] = 1, ["bw"] = 1, ["lv"] = "default:leaves"             ,["ft"] = "default:apple"        ,["ftx"] = 1, ["ftn"] = 3},
				["default:aspen_tree"]         = {["h"] = 11,["t"] = "s",["w"] = 3 ,["bx"] = 0,["bn"] = 0, ["bw"] = 0, ["lv"] = "default:aspen_leaves"       ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["default:pine_tree"]          = {["h"] = 13,["t"] = "s",["w"] = 3 ,["bx"] = 0,["bn"] = 0, ["bw"] = 0, ["lv"] = "default:pine_needles"       ,["ft"] = "default:snow"         ,["ftx"] = 1, ["ftn"] = 4},
				["default:jungletree"]         = {["h"] = 13,["t"] = "s",["w"] = 2 ,["bx"] = 1,["bn"] = 5, ["bw"] = 1, ["lv"] = "default:jungleleaves"       ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["default:acacia_tree"]        = {["h"] = 5, ["t"] = "s",["w"] = 5 ,["bx"] = 2,["bn"] = 0, ["bw"] = 2, ["lv"] = "default:acacia_leaves"      ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["moretrees:beech_trunk"]      = {["h"] = 8, ["t"] = "s",["w"] = 8 ,["bx"] = 1,["bn"] = 2, ["bw"] = 2, ["lv"] = "moretrees:beech_leaves"     ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["moretrees:apple_tree_trunk"] = {["h"] = 8, ["t"] = "s",["w"] = 10,["bx"] = 1,["bn"] = 5, ["bw"] = 7, ["lv"] = "moretrees:apple_tree_leaves",["ft"] = "default:apple"        ,["ftx"] = 2, ["ftn"] = 6},
				["moretrees:oak_trunk"]        = {["h"] = 22,["t"] = "x",["w"] = 14,["bx"] = 2,["bn"] = 16,["bw"] = 26,["lv"] = "moretrees:oak_leaves"       ,["ft"] = "moretrees:acorn"      ,["ftx"] = 1, ["ftn"] = 18},
				["moretrees:poplar_trunk"]     = {["h"] = 24,["t"] = "s",["w"] = 4 ,["bx"] = 0,["bn"] = 0, ["bw"] = 0, ["lv"] = "moretrees:poplar_leaves"    ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["moretrees:sequoia_trunk"]    = {["h"] = 40,["t"] = "x",["w"] = 8 ,["bx"] = 4,["bn"] = 40,["bw"] = 8, ["lv"] = "moretrees:sequoia_leaves"   ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},				
				["moretrees:birch_trunk"]      = {["h"] = 24,["t"] = "s",["w"] = 7 ,["bx"] = 3,["bn"] = 20,["bw"] = 5, ["lv"] = "moretrees:birch_leaves"     ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
		      --["moretrees:palm_trunk"]       = {["h"] = 11,["t"] = "a",["w"] = 10,["bx"] = 6,["bn"] = 0, ["bw"] = 4, ["lv"] = "moretrees:palm_leaves"      ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
				["moretrees:spruce_trunk"]     = {["h"] = 36,["t"] = "x",["w"] = 8 ,["bx"] = 3,["bn"] = 30,["bw"] = 7, ["lv"] = "moretrees:spruce_leaves"    ,["ft"] = "moretrees:spruce_cone",["ftx"] = 1, ["ftn"] = 30},
				["moretrees:cedar_trunk"]      = {["h"] = 24,["t"] = "s",["w"] = 9 ,["bx"] = 1,["bn"] = 18,["bw"] = 7, ["lv"] = "moretrees:cedar_leaves"     ,["ft"] = "moretrees:cedar_cone" ,["ftx"] = 1, ["ftn"] = 20},
				["moretrees:willow_trunk"]     = {["h"] = 15,["t"] = "x",["w"] = 12,["bx"] = 3,["bn"] = 14,["bw"] = 11,["lv"] = "moretrees:willow_leaves"    ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
		      --["moretrees:fir_trunk"]        = {["h"] = 15,["t"] = "s",["w"] = 12,["bx"] = 3,["bn"] = 14,["bw"] = 11,["lv"] = "moretrees:willow_leaves"    ,["ft"] = "moretrees:fir_cone"   ,["ftx"] = 0, ["ftn"] = 0}				
			  }

-----------------------------------------------------
--            Tree override on_dig                 --
-----------------------------------------------------
for k,v in pairs(tree_config) do

	if minetest.registered_nodes[k] then
		minetest.debug(k)
		minetest.override_item(k,
			{
			on_dig = function(pos, node, digger)			
				bvav_create_vessel(pos,minetest.facedir_to_dir(minetest.dir_to_facedir(minetest.yaw_to_dir(digger:get_look_horizontal()+(math.pi/2)))),k,node,digger)		
			end,	
		})
	end
end

----------------------------------------------------
function minetest.throw_item(pos, item)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.add_entity(pos, "__builtin:item")
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())
		local x=math.random(-4,4)*math.random()
		local y=math.random(3,6)
		local z=math.random(-4,4)*math.random()
		obj:setvelocity({x=x, y=y, z=z})
	end
	return obj
end


minetest.register_entity("treecapitator:tree_element", {
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
			
			if math.abs(current_rot.x) > math.pi/2 or math.abs(current_rot.z) > math.pi/2 then
				for i = 1,self.tree do
					local pos = self.object:get_pos()
					minetest.throw_item(pos,{name=self.node.name})
				end
				for i = 1,self.leaves/8 do
					local pos = self.object:get_pos()
					minetest.throw_item(pos,{name=self.leaves_name})
				end
				for i = 1,self.leaves/8 do
					local pos = self.object:get_pos()
					minetest.throw_item(pos,{name="default:stick"})
				end
				if tree_config[self.node.name].ft ~= 0 then
					for i = 1,self.fruit do
						local pos = self.object:get_pos()
						minetest.throw_item(pos,{name= tree_config[self.node.name].ft})
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
	local obj = core.add_entity(p, "treecapitator:tree_element")
	obj:get_luaentity():set_node(node)
	return obj
end


function bvav_create_vessel(pos,dir,tree_type,node,digger)
	local parent	
	local top_y = 0
	local h_chk = 0
	local tree_h = tree_config[tree_type].h
	local tree_t = tree_config[tree_type].t
	local tree_w = tree_config[tree_type].w
	local br_min = tree_config[tree_type].bn
	local br_max = tree_config[tree_type].bx
	local br_wid = tree_config[tree_type].bw
	local lv_typ = tree_config[tree_type].lv
	local ft_nam = tree_config[tree_type].ft
	local ft_max = tree_config[tree_type].ftx
	local ft_min = tree_config[tree_type].ftn
	local fall = false
	local x_pos
	local pos2 = pos
-----------------------------------------------------
--         Get Tree Height for later check         --
-----------------------------------------------------
	if tree_t == "a" then
		for y = 0,tree_h do
			local p_pos = vector.new(pos2.x,pos2.y+y,pos2.z)
			minetest.chat_send_all(dump(p_pos))
			local node = minetest.get_node(p_pos).name
					
				if node == tree_type then
					h_chk = y
				else
					local a_chk = minetest.find_nodes_in_area({x=p_pos.x-1,y=p_pos.y,z=p_pos.z-1},{x=p_pos.x+1,y=p_pos.y,z=p_pos.z+1}, {tree_type})
					minetest.chat_send_all(#a_chk..dump(a_chk[1]))
					if #a_chk == 1 then
						h_chk = y
						pos2 = {x=a_chk[1].x,y=pos2.y,z=a_chk[1].z}
					
					elseif #a_chk > 1 then
						minetest.log("info", "[mod]Treecapitator: asymmetric tree multiple nodes found")
						h_chk = y						
					end
					
				end		
		end	
	
	else
		for y = 0,tree_h do
			local p_pos = vector.new(pos.x,pos.y+y,pos.z)
			local node = minetest.get_node(p_pos).name
					
				if node == tree_type then
					h_chk = y		
				end		
		end
	end
--minetest.chat_send_all("high = "..h_chk)

-----------------------------------------------------
--         Get Tree Leaves for later check         --
-----------------------------------------------------
local h_pos = vector.new(pos.x,pos.y+h_chk,pos.z)
local check_leaf = minetest.find_nodes_in_area({x=h_pos.x-tree_w,y=h_pos.y-h_chk,z=h_pos.z-tree_w},{x=h_pos.x+tree_w,y=h_pos.y+2,z=h_pos.z+tree_w}, {lv_typ})
--minetest.chat_send_all("leaves = "..#check_leaf)

-----------------------------------------------------
--         Trunk thickness check                   --
-----------------------------------------------------
	if tree_t == "s" or tree_t == "a" then
		fall = true
		
	elseif tree_t == "x" and #check_leaf ~= 0 and h_chk > 1 then
		local t_check_1 = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, {tree_type})
		local t_check_2 = minetest.find_nodes_in_area({x=pos.x-2, y=pos.y, z=pos.z}, {x=pos.x+2, y=pos.y, z=pos.z}, {tree_type})
		local t_check_3 = minetest.find_nodes_in_area({x=pos.x, y=pos.y, z=pos.z-2}, {x=pos.x, y=pos.y, z=pos.z+2}, {tree_type})
		--minetest.chat_send_all ("inside_x".." "..#t_check_1.." "..#t_check_2.." "..#t_check_3)
		if #t_check_1 == 1 and #t_check_2 == 1 and #t_check_3 == 1 then
			fall = true
			
			-- Locate X trunk center for use lower down as x_pos
				local t_cent = minetest.find_nodes_in_area({x=pos.x-2, y=pos.y+2, z=pos.z-2}, {x=pos.x+2, y=pos.y+2, z=pos.z+2}, {tree_type})
				
				if t_cent[1].x == nil then
					fall = false
				else
				
					local x_max = t_cent[1].x
					local z_max = t_cent[1].z
					local x_min = t_cent[1].x
					local z_min = t_cent[1].z

						for k,v in pairs(t_cent) do

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
		end
	end

-----------------------------------------------------
--   "If" restores default behaviour in the event  --
--    single log or no leaves helps builders who   --
--    may use logs in structures                   --
-----------------------------------------------------

	if h_chk <= 1 or
	   #check_leaf == 0 or 
	   fall == false then
		--minetest.chat_send_all("check")
		minetest.node_dig(pos, node, digger)

	else	
		--destroy and get center of tree leaves
		
		--Trunk code
		for y = 0,tree_h do
			local p_pos
				if tree_t == "x" then
					p_pos = vector.new(x_pos.x,pos.y+y,x_pos.z)
				else
					p_pos = vector.new(pos.x,pos.y+y,pos.z)
				end
			local node = minetest.get_node(p_pos).name
			
			
			if node == tree_type then
				top_y = y		
				minetest.remove_node(p_pos)	

				
				if not parent then
					parent = spawn_bvav_element(p_pos, {name=tree_type})
					parent:get_luaentity().rotator = true
					parent:get_luaentity().rotate_dir = dir
					parent:get_luaentity().tree = 1
					parent:get_luaentity().leaves = 0
					parent:get_luaentity().fruit = 0
				else
					local child = spawn_bvav_element(p_pos, {name=tree_type})
					child:get_luaentity().parent = parent			
					child:get_luaentity().relative = {x=0,y=y * bvav_settings.attach_scaling,z=0}
					child:set_attach(parent, "", {x=0,y=y * bvav_settings.attach_scaling,z=0}, {x=0,y=0,z=0})
					child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
					parent:get_luaentity().tree = parent:get_luaentity().tree + 1
				end
			end
		end
		
		-- Leaf code		
		local n_pos = vector.new(pos.x,pos.y+top_y,pos.z)
		local leaf_table = minetest.find_nodes_in_area({x=n_pos.x-tree_w,y=n_pos.y-top_y,z=n_pos.z-tree_w},{x=n_pos.x+tree_w,y=n_pos.y+4,z=n_pos.z+tree_w}, {lv_typ})
		for _,l_pos in pairs(leaf_table) do
			minetest.remove_node(l_pos)
			
			local x = l_pos.x - pos.x
			local y = l_pos.y - pos.y
			local z = l_pos.z - pos.z
			local child = spawn_bvav_element(l_pos, {name=lv_typ})
			child:get_luaentity().parent = parent			
			child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
			child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
			child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
			parent:get_luaentity().leaves = parent:get_luaentity().leaves + 1
			parent:get_luaentity().leaves_name = lv_typ
		end
		
		--Branch code
		local leaf_table = minetest.find_nodes_in_area({x=n_pos.x-br_wid,y=n_pos.y-br_min,z=n_pos.z-br_wid},{x=n_pos.x+br_wid,y=n_pos.y+br_max,z=n_pos.z+br_wid},{tree_type})
		for _,l_pos in pairs(leaf_table) do
			minetest.remove_node(l_pos)
			
			local x = l_pos.x - pos.x
			local y = l_pos.y - pos.y
			local z = l_pos.z - pos.z
			local child = spawn_bvav_element(l_pos, {name=tree_type})
			child:get_luaentity().parent = parent			
			child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
			child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
			child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
			parent:get_luaentity().tree = parent:get_luaentity().tree + 1
		end
		
		--Fruit/Attached code
		if ft_nam ~= 0 then
			local leaf_table = minetest.find_nodes_in_area({x=n_pos.x-tree_w,y=n_pos.y-ft_min,z=n_pos.z-tree_w},{x=n_pos.x+tree_w,y=n_pos.y+ft_max,z=n_pos.z+tree_w},{ft_nam})
			for _,l_pos in pairs(leaf_table) do
				minetest.remove_node(l_pos)
				
				local x = l_pos.x - pos.x
				local y = l_pos.y - pos.y
				local z = l_pos.z - pos.z
				local child = spawn_bvav_element(l_pos, {name=ft_nam})
				child:get_luaentity().parent = parent			
				child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
				child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
				child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
				parent:get_luaentity().fruit = parent:get_luaentity().fruit + 1
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


