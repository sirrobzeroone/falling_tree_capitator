----------------------------------------------------
--        Auto Register Schematic Trees           -- 
----------------------------------------------------                                                             
local schem_table= {}                                                           -- Table to store text conversion of schematic

--[[for dec_name,defs in pairs(minetest.registered_decorations) do	
	if string.find(dec_name, "tree") then
		minetest.debug("just name: "..dec_name)
	end
end]]--

for dec_name,defs in pairs(minetest.registered_decorations) do
	if string.find(dec_name, "tree") and not string.find(dec_name, "sapling") then
		local d_name                                                            -- Decoration name
		local size                                                              -- Schematic dimensions, standard pos format eg (x=5,y=12,z=5)
		local leaves = {}                                                       -- Table to store leaf node names
		local fruit  = {}                                                       -- Table to store fruit/atatched node names
		local trunk = ""
		local schematic	

		local schem_filepath = defs.schematic                                   -- file path to schematic mts binary file
		
		if type(schem_filepath) == "table" then                                 -- some schematics stored as lua tables                           
			schematic = schem_filepath		
		else		
			schematic = minetest.read_schematic(schem_filepath, "all")          -- Reads in all probabilities of nodes from .mts file
		end
	
		if schematic ~= nil then 			
			size = schematic.size                                                   -- stored in standard pos format eg (x=5,y=12,z=5)
			d_name = dec_name
			local ts = ""                                                           -- ts = (t)emporary (s)tring variable
			local nt_name                                                           -- Node type name used for L, T, A, F
			local sc_lay = 1
			schem_table[d_name]={}
			local grps = {}
			local grp = {}
		
			for i = 1,#schematic.data do                                            -- Read-in every defined node in schematic
				local temp_name = schematic.data[i].name
			
				if not minetest.registered_nodes[temp_name] then                    -- Any node not registered treat as air.
					temp_name = "air"
				end	
				
				grps[temp_name] = minetest.registered_nodes[temp_name].groups
				grp = grps[temp_name]                                           -- Get the groups our current specified schematic node has

				if grp.leaves == 1 then                                             -- Check Leaves
					nt_name = "L"
					leaves[temp_name] = 1                                           -- Far quicker to set to key, than use a loop 
					
				elseif grp.tree == 1 then                                           -- Check tree/trunk/log etc
					nt_name = "T"
					trunk = temp_name
				
				elseif grp.soil == 1 then                                           -- Check for Soil replace with air
					nt_name = "A"
					
				elseif string.find(temp_name, "air") then                           -- Air has no groups so I just use the name check
					nt_name = "A"
					
				else                                                                -- If its not one of the three above then for trees it must be fruit/attachments
					nt_name = "F"
					fruit[temp_name]=1
				end
				-------------------------------------------------------------------------------------
				--   The block of code below takes the nt_name and inserts it into schem_table     --
				--    However it stores them as each sc_lay = a whole layer as a single string     --
				--  formated as: AAAAA/nAAAAA/nAAAAA/nAAAAA/nAAAAA, this allows for debugging and  --
				--       is easier to find some settings from than a full table structure.         --
				--   This also changes slices from Y vertical slices to X/Z horizontal slices      --
				-- The overall "for" loop "i=i, #schematic.data" is moving through the Y slices    --
				-- as we process through each Y slice we are actually get the 1st (then 2nd, 3rd..)--
				-- row of each X/z horizontal layer. So code below assembles the XZ slices slowly  --
				-- as each Y slice is processed.                                                   -- 
				-------------------------------------------------------------------------------------
				
				if i/schematic.size.x ~= math.floor(i/schematic.size.x) then        -- if it dosent divide evenly we arent at the end of a row
					ts = ts.." "..nt_name
				else                                                                -- if it divides we are at the end of a row
					ts = ts.." "..nt_name                                           -- Add our end value
					
					if sc_lay < schematic.size.y then                               -- if sc_lay is less than schematic y size we are still processing that X row through all X layers                                                    
						if schem_table[d_name][sc_lay] == nil then                  -- A check do we have any data in this X/Z layer yet                      
							schem_table[d_name][sc_lay] =ts.."\n"                   -- If not add the data
						else
							schem_table[d_name][sc_lay] = schem_table[d_name][sc_lay]..ts.."\n" -- If we do then append new row of layer data to existing data
						end
						ts = ""                                                     -- Reset our ts string to blank
						sc_lay=sc_lay+1                                             -- Add one to our layer counter as next row belongs on the next horizontal layer up
					else                                                            -- Once we are at our last node on our last X layer vertically we write that data and then reset all
						if schem_table[d_name][sc_lay] == nil then                  -- counters as the next lot of data represents next Y slice ie Moving from "Y slice 1" to "Y slice 2"
						   schem_table[d_name][sc_lay] =ts.."\n"
						else
							schem_table[d_name][sc_lay] = schem_table[d_name][sc_lay]..ts.."\n"
						end
						sc_lay = 1                                                  -- reset our layer counter
						ts = ""                                                     -- naturally blank our temp string
					end
				end
			end		
			schem_table[d_name]["size"] = size                                      -- store the size value for the tree
			schem_table[d_name]["leaves"] = leaves                                  -- store leave(s) node name
			schem_table[d_name]["fruit"] = fruit                                    -- store fruit(s) node name
			schem_table[d_name]["trunk"] = trunk                                    -- store trunk node name
			
--[[	minetest.debug(dump(schem_table[d_name]["leaves"]))                         -- for debugging assistance
		minetest.debug(dump(schem_table[d_name]["fruit"]))
		for k,v in ipairs(schem_table[d_name]) do
			minetest.debug(d_name.." X/Z Slice: Y= "..k.." of "..schem_table[d_name].size.y)
			minetest.debug("\n"..v)
		end]]--
		 
		end
	end
end


--------------------------------------------------------------
-- A table now exists which has all targetted tree          --
-- schematics recorded inside and structured as below:      --
--                                                          --
-- schem_table = {["tree_name 1"] = {[1] = Layer String,    --
--                                   [2] = Layer String,    --
--                                    ...                   --
--                                   [5] = Layer String},   --
--                ["tree_name 2"] = {[1] = Layer String,    --
--                                   ...                    --
--                                  }                       --
--               }                                          --
--------------------------------------------------------------


for tree_name,def_str in pairs(schem_table) do
-- set variables for registration
local tree = {}	
tree.th = 0                                                 -- th == tree trunk height max
tree.tt = "s"                                               -- tt == trunk type, s == single, x == crossed, d == double, t== triple, a = all, s == special eg palm
tree.lv = {}                                                -- lv == leaves name eg "default:leaves"
tree.lw = 0                                                 -- lw == leaves max (radius) from center trunk eg 1 == +1 & -1 out from each side
tree.lh = 0                                                 -- lh == leaves max height above trunk height max
tree.bx = 0                                                 -- bx == branch max relative to top eg 1 == +1 above trunk height max
tree.bn = 0                                                 -- bn == branch min relative to top eg 1 == -1 below trunk height max
tree.bw = 0                                                 -- bw == branch max (radius) from center trunk eg 1 == +1 & -1 out from each side
tree.ft = {}                                                -- ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
tree.fx = 0                                                 -- fx == fruit max above trunk height max
tree.fn = 0                                                 -- fn == fruit min below trunk height max
tree.sp = ""                                                -- sp == sapling name

local ref_name
local b_wide = {}
local cnx = math.ceil(def_str.size.x/2) -- center_node_x
local cnz = math.ceil(def_str.size.z/2) -- center_node_z
local th_start = math.ceil(def_str.size.y * 0.25)
------------------------------------------------------------------------------
--  Create a proper 2d table (array) of values from def_str for this tree   --
------------------------------------------------------------------------------
	for y_hgt = 1,def_str.size.y do	
		local z_pos = 1
		b_wide[y_hgt] = {}
		b_wide[y_hgt][z_pos] = {}
		
			local temp = def_str[y_hgt]                      -- copy layer string to temp variable
			temp = string.gsub(temp, "\n", "n")              -- remove \  leave n to show end of row
			temp = string.gsub(temp, " ", "")                -- remove spaces
				
			for x_pos = 1, #temp do
				t2 = string.sub (temp,x_pos, x_pos)
				
				if t2 ~= "n" then
					table.insert(b_wide[y_hgt][z_pos], t2)
					
				else
					z_pos = z_pos+1
					b_wide[y_hgt][z_pos]={}
				end		
			end
	end
---------------------------------
--   workout tree type = tt    --
---------------------------------
	local _, t_count = string.gsub(def_str[th_start], "T", "")     -- Magic line found on Internet - Finds all "T" in string and rtns count
                                                            -- layer 3 selected to avoid any tree bottoms/bases
	if t_count == 4 then                                    -- may need to improve this later. 
		tree.tt = "d"
		
	elseif t_count == 5 then
		tree.tt = "x"
		
	elseif t_count == 9 then
		tree.tt = "t"
		
	else
		tree.tt = "s"
	end
	
---------------------------------
--  workout trunk height = th  --
---------------------------------
	local center={}
	local cnt = 1
	
	for kz,rowz in pairs(b_wide[th_start]) do              -- same height as tree.tt
		for kx,rowx in pairs(rowz) do
			if rowx == "T" then
				center[cnt] = {}
				center[cnt].x = kx                  -- store x
				center[cnt].z = kz                  -- store z
				cnt = cnt+1
			end
		end
	end

	local th_cnt = th_start
	for y_hgt = th_cnt,def_str.size.y do                -- start same height as tree.tt
		local cnt = 0
		for k,v in pairs(center)do
			if b_wide[y_hgt][v.z][v.x] == "T" then
				cnt = cnt+1
			end
		end
		
		if cnt == #center then
			tree.th = y_hgt
		end
	end

-- update center location as some trunks are not 
-- centered inside schematic file
	cnx = center[1].x
	cnz = center[1].z

---------------------------------
--     leave name(s) = lv      --
---------------------------------
	for name,v in pairs(def_str.leaves) do
		table.insert(tree.lv, name) 
	end

---------------------------------
--      leave width = lw       --
---------------------------------
	if def_str.size.x > def_str.size.z then
		tree.lw = math.floor(def_str.size.x/2)
	else
		tree.lw = math.floor(def_str.size.z/2)
	end

---------------------------------
--      leave height = lh      --
---------------------------------
	tree.lh = def_str.size.y - tree.th

---------------------------------
--   Branch max height = bx    --
---------------------------------
	for i = tree.th+1,def_str.size.y do
		local _, t_count = string.gsub(def_str[i], "T", "")
			if t_count > 0 then
				tree.bx = i-tree.th
			end
	end

---------------------------------
--   Branch min height = bn    --
---------------------------------
	tree.bn = tree.th*-1

	local bn_b_wide = b_wide

     --remove known trunk locations from table
	for i = 1,def_str.size.y do
		if tree.tt == "d" then
			bn_b_wide[i][cnz][cnx]     = "X"
			bn_b_wide[i][cnz][cnx+1]   = "X"
			bn_b_wide[i][cnz+1][cnx]   = "X"
			bn_b_wide[i][cnz+1][cnx+1] = "X"
			
		elseif tree.tt == "x" then
			bn_b_wide[i][cnz][cnx]   = "X"
			bn_b_wide[i][cnz][cnx+1] = "X"
			bn_b_wide[i][cnz][cnx-1] = "X"
			bn_b_wide[i][cnz-1][cnx] = "X"
			bn_b_wide[i][cnz+1][cnx] = "X"
			
		elseif tree.tt == "t" then
			bn_b_wide[i][cnz][cnx]     = "X"
			bn_b_wide[i][cnz][cnx+1]   = "X"
			bn_b_wide[i][cnz][cnx-1]   = "X"
			bn_b_wide[i][cnz-1][cnx]   = "X"
			bn_b_wide[i][cnz-1][cnx+1] = "X"
			bn_b_wide[i][cnz-1][cnx-1] = "X"
			bn_b_wide[i][cnz+1][cnx]   = "X"
			bn_b_wide[i][cnz+1][cnx+1] = "X"
			bn_b_wide[i][cnz+1][cnx-1] = "X"
		else
			bn_b_wide[i][cnz][cnx] = "X"
		end

	-- Loop over table looking for "T" at the lowest Y
		if tree.bn <= i*-1 then
			for k,rowz in pairs(bn_b_wide[i]) do
				for k,rowx in pairs(rowz) do
					if rowx == "T" then
						if tree.bn < i*-1 then
							tree.bn = i*-1
						end
					end
				end
			end
		end
	end
	tree.bn = tree.bn + tree.th

---------------------------------
--    Branch min width = bw    --
---------------------------------

	for k,node_type in pairs(b_wide) do
		for zi=1,def_str.size.z do
			for xi=1, def_str.size.x do			
			
				local branch_check = node_type[zi][xi]

				if branch_check == "T" then
					if xi > zi then
						local offset = math.abs(cnx - xi)
							if offset > tree.bw then
								tree.bw = offset
							end				
					else
						local offset = math.abs(cnz - zi)
							if offset > tree.bw then
								tree.bw = offset
							end					
					end			
				end	
				
			end
		end
	end

---------------------------------
--       Fruit name = ft       --
---------------------------------
	for name,v in pairs(def_str.fruit) do
		table.insert(tree.ft, name) 
	end

---------------------------------
--    Fruit max height = fx    --
---------------------------------
	if #tree.ft ~= 0 then
		for i = tree.th,def_str.size.y do
			local _, t_count = string.gsub(def_str[i], "F", "")
			if t_count > 0 then
				tree.fx = i-tree.th
			end	
			
		end
	end


---------------------------------
--    Fruit min height = fn    --
---------------------------------
	if #tree.ft ~= 0 then
		tree.fn = def_str.size.y
		
		for i = 1,def_str.size.y do	
			local _, t_count = string.gsub(def_str[i], "F", "")
			if t_count > 1 and tree.fn > i then
				tree.fn = i-tree.th
			end	
			
		end
	end

---------------------------------
--      Sapling name = sp      --
---------------------------------
	
	if type(tree.lv) == "table" then
		for k,leaf in pairs(tree.lv) do
			local drops = minetest.registered_nodes[leaf].drop

			if drops ~= nil then

				for k,v in pairs(drops.items) do

					local item_name = v.items[1]	
					local item_name_grp = minetest.registered_nodes[item_name].groups

						if item_name_grp.sapling == 1 then
							tree.sp = item_name 
						end
				end
			end	
		end
		
	else
		local drops = minetest.registered_nodes[tree.lv].drop	
		
		for k,v in pairs(drops.items) do

			local item_name = v.items[1]	
			local item_name_grp = minetest.registered_nodes[item_name].groups

				if item_name_grp.sapling == 1 then
					tree.sp = item_name 
				end
		end
	
	end

	
-- debugging	
--[[
	local tree_sum = {[def_str.trunk] = {
									["th"] = tree.th,
									["tt"] = tree.tt,
									["lv"] = tree.lv,
									["lw"] = tree.lw,
									["lh"] = tree.lh,
									["bx"] = tree.bx,
									["bn"] = tree.bn,
									["bw"] = tree.bw,
									["ft"] = tree.ft,
									["fx"] = tree.fx,
									["fn"] = tree.fn,
									["sp"] = tree.sp
									}}

 local tree_debug =""
	 for k,v in pairs(tree_sum[def_str.trunk]) do
 
		tree_debug = tree_debug.."\n"..k..":"..minetest.serialize(v)
 
	end
	 tree_debug = string.gsub(tree_debug, "return", "")
	 minetest.debug("\n"..def_str.trunk..tree_debug) 
]]--
-----------------------------------------------------------
-- Check if tree_name and tree.tt are already registered --
--    and either update values or register new record    --
-----------------------------------------------------------		

	if not falling_tree_capitator.tree_config[def_str.trunk] then                                   -- Check if tree top table exists if not create 
		falling_tree_capitator.tree_config[def_str.trunk] = {}		
	end 

	
	if not falling_tree_capitator.tree_config[def_str.trunk][tree.tt] then                              -- If tree already has a config record we need to check
		
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt] = {} 
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["th"] = tree.th
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["tt"] = tree.tt
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["lv"] = tree.lv
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["lw"] = tree.lw
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["lh"] = tree.lh
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["bx"] = tree.bx
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["bn"] = tree.bn
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["bw"] = tree.bw
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["ft"] = tree.ft
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["fx"] = tree.fx
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["fn"] = tree.fn
		falling_tree_capitator.tree_config[def_str.trunk][tree.tt]["sp"] = tree.sp

		--minetest.debug("db: "..dump(falling_tree_capitator.tree_config))
		
	elseif falling_tree_capitator.tree_config[def_str.trunk][tree.tt] then

		local tree_config_data = falling_tree_capitator.tree_config[def_str.trunk][tree.tt]
		for k,v in pairs(tree_config_data) do
			local rev_tab = {}
			local fin_tab = {}
			if type(v) ~= "table" then
			
				if tree[k] > tree_config_data[k] then
			   
			       tree_config_data[k] = tree[k]

				end
				
			else
				for k2,v2 in pairs(v) do       -- swap values to keys			
					rev_tab[v2] = 1					
				end
				
				for k3,v3 in pairs(tree[k]) do --insert new values as keys, anythign same will simply overwrite
				
				rev_tab[v3] = 1
								
				end
				
				for k4,v4 in pairs(rev_tab) do	 -- swap keys back to values			
					table.insert(fin_tab, k4) 					
				end	
				
				tree_config_data[k] = fin_tab	-- update config data with new values	
			end
		end
	
	else
		--register nothing
	end
end


