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
						visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}
						},

	node = {},
	set_node = function(self, node)
					self.node = node
					local prop = {
						is_visible = true,
						textures = {node.name},
						visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}
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
							self.object:set_properties({visual_size = {x=falling_tree_capitator.bvav_settings.scaling*3, y=falling_tree_capitator.bvav_settings.scaling*3}})
							--self.object:set_properties({})
						else
							--this fixes issues with scaling
							self.object:set_properties({visual_size = {x=falling_tree_capitator.bvav_settings.scaling, y=falling_tree_capitator.bvav_settings.scaling}})

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
						
						local tree_type = self.ttype
						local throw_ref_table = {["logs"] = self.logs,
												 ["leaf"] = falling_tree_capitator.tree_config[self.node.name][tree_type].lv,
												 ["fruit"] = falling_tree_capitator.tree_config[self.node.name][tree_type].ft}
						local throw_parts = {}				
						local throw_parts2={}
						local leaf_total = 0

						
						for k,obj_tab in pairs(throw_ref_table) do
						
							if type(obj_tab) == "table" then
								for k2,name in pairs(obj_tab) do						
									
									if k == "leaf" then
										leaf_total = leaf_total + self[name]
										throw_parts[name]=self[name]/10
										
									else 
										throw_parts[name]=self[name]
									end
									
								end
												
							else
								throw_parts[self.node.name]=obj_tab
							end
						end
						
						throw_parts[falling_tree_capitator.tree_config[self.node.name][tree_type].sp] = leaf_total/20						
						throw_parts["default:stick"] = leaf_total/10

						-- Loop through the above table and use throw_item to distribute the items.
							for node_name,node_num in pairs(throw_parts) do
								-- "if" misses fruit if the name is set to "0"
								if node_name ~= 0 then
									for i = 1,node_num do
										local pos = self.object:get_pos()
										falling_tree_capitator.throw_item(pos,{name=node_name},self.rotate_dir,falling_tree_capitator.tree_config[self.node.name][tree_type].th)
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
			 end
})