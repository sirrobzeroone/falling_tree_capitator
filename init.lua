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
--w  == tree leaves width
--bx == branch max relative to top eg 1 == +1 higher than top of tree
--bn == branch min relative to top eg 1 == -1 below top of tree
--bw == branch width relative to trunk eg 1 == +1 & -1 out from each side
--lv == leaves name eg "default:leaves" must be supplied.
--ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
tree_config = {
				["default:tree"]       = {["h"] = 5, ["w"] = 3,["bx"] = 1,["bn"] = 1,["bw"] = 1,["lv"] = "default:leaves"       ,["ft"] = "default:apple"},
				["default:aspen_tree"] = {["h"] = 11,["w"] = 3,["bx"] = 0,["bn"] = 0,["bw"] = 0,["lv"] = "default:aspen_leaves" ,["ft"] = 0},
				["default:pine_tree"]  = {["h"] = 13,["w"] = 3,["bx"] = 0,["bn"] = 0,["bw"] = 0,["lv"] = "default:pine_needles" ,["ft"] = "default:snow"},
				["default:jungletree"] = {["h"] = 13,["w"] = 2,["bx"] = 1,["bn"] = 5,["bw"] = 1,["lv"] = "default:jungleleaves" ,["ft"] = 0},
				["default:acacia_tree"]= {["h"] = 5, ["w"] = 5,["bx"] = 2,["bn"] = 0,["bw"] = 2,["lv"] = "default:acacia_leaves",["ft"] = 0}
			  }

-----------------------------------------------------
--            Tree override on_dig                 --
-----------------------------------------------------
for k,v in pairs(tree_config) do
minetest.override_item(k,
	{
	on_dig = function(pos, node, digger)			
		bvav_create_vessel(pos,minetest.facedir_to_dir(minetest.dir_to_facedir(minetest.yaw_to_dir(digger:get_look_horizontal()+(math.pi/2)))),k,node,digger)		
	end,	
})

end


----------------------------------------------------
function minetest.throw_item(pos, item)
	-- Take item in any format
	local stack = ItemStack(item)
	local obj = minetest.add_entity(pos, "__builtin:item")
	-- Don't use obj if it couldn't be added to the map.
	if obj then
		obj:get_luaentity():set_item(stack:to_string())
		local x=math.random(-2,2)*math.random()
		local y=math.random(2,5)
		local z=math.random(-2,2)*math.random()
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
	local tree_w = tree_config[tree_type].w
	local br_min = tree_config[tree_type].bn
	local br_max = tree_config[tree_type].bx
	local br_wid = tree_config[tree_type].bw
	local leaves_type = tree_config[tree_type].lv
	local ft_nam = tree_config[tree_type].ft

-----------------------------------------------------
--         Get Tree Height for later check         --
-----------------------------------------------------
	for y = 0,tree_h do
		local p_pos = vector.new(pos.x,pos.y+y,pos.z)
		local node = minetest.get_node(p_pos).name
				
			if node == tree_type then
				h_chk = y		
			end
	
	end
--minetest.chat_send_all("high = "..h_chk)

-----------------------------------------------------
--         Get Tree Leaves for later check         --
-----------------------------------------------------
local h_pos = vector.new(pos.x,pos.y+h_chk,pos.z)
local check_leaf = minetest.find_nodes_in_area({x=h_pos.x-tree_w,y=h_pos.y-h_chk,z=h_pos.z-tree_w},{x=h_pos.x+tree_w,y=h_pos.y+3,z=h_pos.z+tree_w}, {leaves_type})
--minetest.chat_send_all("leaves = "..#check_leaf)

-----------------------------------------------------
--   "If" restores default behaviour in the event  --
--    single log or no leaves helps builders who   --
--    may use logs in structures                   --
-----------------------------------------------------

	if h_chk <= 1 or
	   #check_leaf == 0 then
		--minetest.chat_send_all("check")
		minetest.node_dig(pos, node, digger)

	else	
		--destroy and get center of tree leaves
		
		--Trunk code
		for y = 0,tree_h do
			local p_pos = vector.new(pos.x,pos.y+y,pos.z)
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
		local leaf_table = minetest.find_nodes_in_area({x=n_pos.x-tree_w,y=n_pos.y-top_y,z=n_pos.z-tree_w},{x=n_pos.x+tree_w,y=n_pos.y+3,z=n_pos.z+tree_w}, {leaves_type})
		for _,l_pos in pairs(leaf_table) do
			minetest.remove_node(l_pos)
			
			local x = l_pos.x - pos.x
			local y = l_pos.y - pos.y
			local z = l_pos.z - pos.z
			local child = spawn_bvav_element(l_pos, {name=leaves_type})
			child:get_luaentity().parent = parent			
			child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
			child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
			child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
			parent:get_luaentity().leaves = parent:get_luaentity().leaves + 1
			parent:get_luaentity().leaves_name = leaves_type
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
			local leaf_table = minetest.find_nodes_in_area({x=n_pos.x-tree_w,y=n_pos.y-(top_y-2),z=n_pos.z-tree_w},{x=n_pos.x+tree_w,y=n_pos.y+2,z=n_pos.z+tree_w},{ft_nam})
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


