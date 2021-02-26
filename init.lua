bvav_settings = {}
bvav_settings.attach_scaling = 30
bvav_settings.scaling = 0.667

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
					minetest.throw_item(pos,{name="default:tree"})
				end
				for i = 1,self.leaves do
					local pos = self.object:get_pos()
					minetest.throw_item(pos,{name="default:leaves"})
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


function bvav_create_vessel(pos,dir)
	local parent
	local base_y = 0
	local top_y = 0
	--analyze
	for y = 0,-4,-1 do
		local p_pos = vector.new(pos.x,pos.y+y,pos.z)
		local node = minetest.get_node(p_pos).name
		if node == "default:tree" then
			base_y = y
		end
	end
	--adjust pos
	pos = vector.new(pos.x,pos.y+base_y,pos.z)
	
	--destroy and get center of tree leaves
	for y = 0,5 do
		local p_pos = vector.new(pos.x,pos.y+y,pos.z)
		local node = minetest.get_node(p_pos).name
		if node == "default:tree" then
			top_y = y
			minetest.remove_node(p_pos)
			if not parent then
				parent = spawn_bvav_element(p_pos, {name="default:tree"})
				parent:get_luaentity().rotator = true
				parent:get_luaentity().rotate_dir = dir
				parent:get_luaentity().tree = 0
				parent:get_luaentity().leaves = 0
			else
				local child = spawn_bvav_element(p_pos, {name="default:tree"})
				child:get_luaentity().parent = parent			
				child:get_luaentity().relative = {x=0,y=y * bvav_settings.attach_scaling,z=0}
				child:set_attach(parent, "", {x=0,y=y * bvav_settings.attach_scaling,z=0}, {x=0,y=0,z=0})
				child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
				parent:get_luaentity().tree = parent:get_luaentity().tree + 1
			end
		end
	end
	
	local n_pos = vector.new(pos.x,pos.y+top_y,pos.z)
	local leaf_table = minetest.find_nodes_in_area(vector.subtract(n_pos,3), vector.add(n_pos,3), {"default:leaves"})
	for _,l_pos in pairs(leaf_table) do
		minetest.remove_node(l_pos)
		
		local x = l_pos.x - pos.x
		local y = l_pos.y - pos.y
		local z = l_pos.z - pos.z
		local child = spawn_bvav_element(l_pos, {name="default:leaves"})
		child:get_luaentity().parent = parent			
		child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
		child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
		child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
		parent:get_luaentity().leaves = parent:get_luaentity().leaves + 1
	end
	
	local leaf_table = minetest.find_nodes_in_area(vector.subtract(n_pos,3), vector.add(n_pos,3), {"default:tree"})
	for _,l_pos in pairs(leaf_table) do
		minetest.remove_node(l_pos)
		
		local x = l_pos.x - pos.x
		local y = l_pos.y - pos.y
		local z = l_pos.z - pos.z
		local child = spawn_bvav_element(l_pos, {name="default:tree"})
		child:get_luaentity().parent = parent			
		child:get_luaentity().relative = {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}
		child:set_attach(parent, "", {x=x * bvav_settings.attach_scaling,y=y * bvav_settings.attach_scaling,z=z * bvav_settings.attach_scaling}, {x=0,y=0,z=0})
		child:set_properties({visual_size = {x=bvav_settings.scaling, y=bvav_settings.scaling}})
		parent:get_luaentity().leaves = parent:get_luaentity().leaves + 1
	end
	minetest.sound_play("tree_fall",{object=parent})
end


minetest.override_item("default:tree",
	{
	on_dig = function(pos, node, digger)
		print("tets")
		bvav_create_vessel(pos,minetest.facedir_to_dir(minetest.dir_to_facedir(minetest.yaw_to_dir(digger:get_look_horizontal()+(math.pi/2)))))
	end,
	
})

minetest.override_item("default:pine_tree",
	{
	on_dig = function(pos, node, digger)
		print("tets")
		bvav_create_vessel(pos,minetest.facedir_to_dir(minetest.dir_to_facedir(minetest.yaw_to_dir(digger:get_look_horizontal()+(math.pi/2)))))
	end,
	
})

