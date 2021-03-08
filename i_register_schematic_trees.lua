

local d_name																	-- Decoration name
local size																		-- Schematic dimensions, standard pos format eg (x=5,y=12,z=5)
local leaves = {}																-- Table to store leaf node names
local fruit  = {}																-- Table to store fruit/atatched node names
local schem_table= {} 															-- Table to store text conversion of schematic

y = 0

for dec_name,defs in pairs(minetest.registered_decorations) do
	if string.find(dec_name, "default:apple_tree") then
		
		local schem_filepath = defs.schematic									-- file path to schematic mts binary file
		local schematic = minetest.read_schematic(schem_filepath, "all") 		-- Reads in all probabilities of nodes from .mts file		
		size = schematic.size													-- stored in standard pos format eg (x=5,y=12,z=5)
		d_name = dec_name                                               
		local ts = ""															-- ts = (t)emporary (s)tring variable
		local nt_name															-- Node type name used for L, T, A, F
		local sc_lay = 1
		schem_table={}
		schem_table[d_name]={}
		
		for i = 1,#schematic.data do											-- Read-in every defined node in schematic
			local grp = minetest.registered_nodes[schematic.data[i].name].groups -- Get the groups our current specified schematic node has
		
			if grp.leaves == 1 then												-- Check Leaves
				nt_name = "L"
					if #leaves == 0 then										-- This if block adds the leaf names for later use
						table.insert(leaves,schematic.data[i].name)				-- to table leaves
					else
						for k,v in pairs(leaves) do								-- we dont need to add a leaf name multiple times						
							if v ~= schematic.data[i].name then					-- so check if name exists if it does dont add.
								table.insert(leaves,schematic.data[i].name)
							end
						
						end
					end
				
			elseif grp.tree == 1 then 											-- Check tree/trunk/log etc
				nt_name = "T"
			elseif string.find(schematic.data[i].name, "air") then				-- Air has no groups so I just use the name check
				nt_name = "A"
			else																-- If its not one of the three above then for trees it must be fruit/attachments.
				nt_name = "F"
					if #fruit == 0 then 										-- This if block adds the fruit names for later use
						table.insert(fruit,schematic.data[i].name)				-- to table fruit
					else
						for k,v in pairs(fruit) do								-- we dont need to add a fruit name multiple times 						
							if v ~= schematic.data[i].name then					-- so check if name exists if it does dont add.
								table.insert(fruit,schematic.data[i].name)
							end
						
						end
					end				
			end
			-------------------------------------------------------------------------------------
			-- The below block of code below takes the nt_name and inserts it into schem_table --
			--    However it stores them as each sc_lay = a whole layer as a single string     --
			--  formated as: AAAAA/nAAAAA/nAAAAA/nAAAAA/nAAAAA, this allows for debugging and  --
			--       is easier to find some settings from than a full table structure.         --
			--   This also changes slices from Y vertical slices to X/Z horizontal slices      --
			-- The overall "for" loop "i=i, #schematic.data" is moving through the Y slices    --
			-- as we process through each Y slice we are actually get the 1st (then 2nd, 3rd..)--
			-- row of each X/z horizontal layer. So code below assembles the XZ slices slowly  --
			-- as each Y slice is processed.                                                   -- 
			-------------------------------------------------------------------------------------
			
			if i/schematic.size.x ~= math.floor(i/schematic.size.x) then		-- if it dosent divide evenly we arent at the end of a row
				ts = ts.." "..nt_name
			else                                                            	-- if it divides we are at the end of a row
				ts = ts.." "..nt_name                                       	-- Add our end value
				
				if sc_lay < schematic.size.y then                           	-- if sc_lay is less than schematic y size we are still processing that X row through all X layers                                                    
					if schem_table[d_name][sc_lay] == nil then                  -- A check do we have any data in this X/Z layer yet                      
						schem_table[d_name][sc_lay] =ts.."\n"                   -- If not add the data
					else
						schem_table[d_name][sc_lay] = schem_table[d_name][sc_lay]..ts.."\n" -- If we do then append new row of layer data to existing data
					end
					ts = ""														-- Reset our ts string to blank
					sc_lay=sc_lay+1												-- Add one to our layer counter as next row belongs on the next horizontal layer up
				else                                                        	-- Once we are at our last node on our last X layer vertically we write that data and then reset all
					if schem_table[d_name][sc_lay] == nil then                  -- counters as the next lot of data represents next Y slice ie Moving from "Y slice 1" to "Y slice 2"
					   schem_table[d_name][sc_lay] =ts.."\n"
					else
						schem_table[d_name][sc_lay] = schem_table[d_name][sc_lay]..ts.."\n"
					end
					sc_lay = 1													-- reset our layer counter
					ts = ""														-- naturally blank our temp string
				end
			end
		end		
		schem_table[d_name]["size"] = size										-- store the size value for the tree
		schem_table[d_name]["leaves"] = leaves									-- store leaf name(s)
		schem_table[d_name]["fruit"] = fruit									-- store leaf fruit(s)
		
			--[[minetest.debug(dump(schem_table[d_name]["leaves"]))				-- for debugging assistance
				minetest.debug(dump(schem_table[d_name]["fruit"]))
			for k,v in ipairs(schem_table[d_name]) do							
				minetest.debug(d_name.." X/Z Slice: Y= "..k.." of "..schem_table[d_name].size.y)
				minetest.debug("\n"..v)
		 end]]--
		
	end
end

--------------------------------------------------------------
-- A table now exists which has all targetted tree      	--
-- schematics recorded inside and structured as below:    	--
--                                                      	--
-- schem_table = {["tree_name 1"] = {[1] = Layer String,	--
--								     [2] = Layer String,	--
--                                    ...					--
--								     [5] = Layer String},	--
-- 				  ["tree_name 2"] = {[1] = Layer String,	--
--									 ...					--
--                                  }						--                  
-- 				 }											--
--------------------------------------------------------------

for tree_name,def_str in pairs(schem_table) do

	-- set variables for registration
local tree = {}	
tree.th = 0													-- th == tree trunk height max
tree.tt = "s"												-- tt == trunk type, s == single, x == crossed, d == double, t== triple, a = all, s == special eg palm
tree.lv = ""												-- lv == leaves name eg "default:leaves"
tree.lw = 0													-- lw == leaves max (radius) from center trunk eg 1 == +1 & -1 out from each side
tree.lh = 0													-- lh == leaves max height above trunk height max
tree.bx = 0													-- bx == branch max relative to top eg 1 == +1 above trunk height max
tree.bn = 0													-- bn == branch min relative to top eg 1 == -1 below trunk height max
tree.bw = 0													-- bw == branch max (radius) from center trunk eg 1 == +1 & -1 out from each side
tree.ft = 0													-- ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
tree.fx = 0													-- fx == fruit max above trunk height max
tree.fn = 0													-- fn == fruit min below trunk height max
tree.sp = ""													-- sp == sapling name

local b_wide = {}
local cnx = math.ceil(def_str.size.x/2) -- center_node_x
local cnz = math.ceil(def_str.size.z/2) -- center_node_z

------------------------------------------------------------------------------
--  Create a proper 2d table (array) of values from def_str for this tree   --
------------------------------------------------------------------------------

	for y_hgt = 1,def_str.size.y do	
		local z_pos = 1
		b_wide[y_hgt] = {}
		b_wide[y_hgt][z_pos] = {}
		
			local temp = def_str[y_hgt]                		 -- copy layer string to temp variable	
			temp = string.gsub(temp, "\n", "n")        		 -- remove \  leave n to show end of row
			temp = string.gsub(temp, " ", "")          		 -- remove spaces			
				
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
--  workout trunk height = th  --
---------------------------------
for y_hgt = 1,def_str.size.y do
	local temp = def_str[y_hgt]
	temp = string.gsub(temp, "\n", "")      		 	-- remove \n  leave n to show end of row
	temp = string.gsub(temp, " ", "")					-- remove spaces
														-- The above means middle of trunk is in the middle of the string													
	if (def_str.size.x % 2 == 0) then 					-- Check for odd or even X/Z dimensions if odd single mid node, even 4 mid nodes.
		local mid_node = (def_str.size.x*def_str.size.z)/2-- Calculate even mid nodes - use 2d array
		local mid_hgh = mid_node + 1
		local mid_low = mid_node
	
		if b_wide[y_hgt][mid_hgh][mid_hgh] == "T" and   -- Check the 4 center locations for T
		   b_wide[y_hgt][mid_hgh][mid_low] == "T" and   -- note hopefully no-one puts a single trunk tree in an even sized mts
		   b_wide[y_hgt][mid_low][mid_hgh] == "T" and
		   b_wide[y_hgt][mid_low][mid_low] == "T" then
		   
			tree.th = y_hgt
		end   	
	else
			
		local mid_node = math.ceil((def_str.size.x*def_str.size.z)/2)       -- calulate odd mid node number
			if string.sub(temp, mid_node, mid_node) == "T" then
				tree.th = y_hgt
			end	
	end
end

---------------------------------
--   workout tree type = tt    --
---------------------------------
	local _, t_count = string.gsub(def_str[3], "T", "")		-- Magic line found on Internet - Finds all "T" in string and rtns count
															-- layer 3 selected to avoid any tree bottoms/bases
	if t_count == 4 then									-- may need to improve this later. 
		tree.tt = "d"
		
	elseif t_count == 5 then
		tree.tt = "x"
		
	elseif t_count == 9 then
		tree.tt = "t"
		
	else
		tree.tt = "s"
	end

---------------------------------
--     leave name(s) = lv      --
---------------------------------
	if #def_str.leaves == 1 then
		tree.lv = def_str.leaves[1]
	else
		for k,v in pairs(leaves) do
		 table.insert(tree.lv, v) 
		end
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
					minetest.debug("inside"..rowx.." "..i)
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
		for zi=1,size.z do
			for xi=1, size.x do			
			
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
	if #def_str.fruit == 1 then
		tree.ft = def_str.fruit[1]
		
	elseif #def_str.fruit > 1 then
		
		for k,ft_name in pairs(def_str.fruit) do
			table.insert(tree.ft, ft_name) 
		end
		
	end

---------------------------------
--    Fruit max height = fx    --
---------------------------------
	if tree.ft ~= 0 then	
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
	if tree.ft ~= 0 then
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
local drops = minetest.registered_nodes[tree.lv].drop

for k,v in pairs(drops.items) do

	local item_name = v.items[1]	
	local item_name_grp = minetest.registered_nodes[item_name].groups

		if item_name_grp.sapling == 1 then
			tree.sp = item_name 
		end
end



minetest.debug("tree height: "..tree.th)
minetest.debug("tree type: "..tree.tt)
minetest.debug("tree leaves: "..tree.lv)
minetest.debug("tree leaf width: "..tree.lw)
minetest.debug("tree leaf height: "..tree.lh)
minetest.debug("tree branch above trunk top: "..tree.bx)
minetest.debug("tree branch below trunk top: "..tree.bn)
minetest.debug("tree branch wide: "..tree.bw)
minetest.debug("tree fruit: "..tree.ft)
minetest.debug("tree fruit above trunk top: "..tree.fx)
minetest.debug("tree fruit below trunk top: "..tree.fn)
minetest.debug("tree sapling: "..tree.sp)


end


