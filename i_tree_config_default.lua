
-- th == tree trunk height max
-- tt == trunk type, s == single, x == crossed, d == double, t== triple, a = all, s == special eg palm
-- lv == leaves name eg "default:leaves"
-- lw == leaves max (radius) from center trunk eg 1 == +1 & -1 out from each side
-- lh == leaves max height above trunk height max
-- bx == branch max relative to top eg 1 == +1 above trunk height max
-- bn == branch min relative to top eg 1 == -1 below trunk height max
-- bw == branch max (radius) from center trunk eg 1 == +1 & -1 out from each side 
-- ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
-- fx == fruit max above trunk height max
-- fn == fruit min below trunk height max

tree_config = {
				["default:tree"] = {
									["th"] = 5,
									["tt"] = "s",
									["lv"] = "default:leaves",
									["lw"] = 3,
									["lh"] = 3,
									["bx"] = 1,
									["bn"] = 1,
									["bw"] = 1,
									["ft"] = "default:apple",
									["fx"] = 1,
									["fn"] = 3,
									},
		   ["default:aspen_tree"] = {
									["th"] = 11,
									["tt"] = "s",
									["lv"] = "default:aspen_leaves",
									["lw"] = 3,
									["lh"] = 2,
									["bx"] = 0,
									["bn"] = 0,
									["bw"] = 0,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									},
		    ["default:pine_tree"] = {
									["th"] = 13,
									["tt"] = "s",
									["lv"] = "default:pine_needles",
									["lw"] = 3,
									["lh"] = 2,
									["bx"] = 0,
									["bn"] = 0,
									["bw"] = 0,
									["ft"] = "default:snow",
									["fx"] = 1,
									["fn"] = 4,
									},
		  ["default:acacia_tree"] = {
									["th"] = 5,
									["tt"] = "s",
									["lv"] = "default:acacia_leaves",
									["lw"] = 5,
									["lh"] = 3,
									["bx"] = 2,
									["bn"] = 0,
									["bw"] = 2,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									},
		   ["default:jungletree"] = {
									["th"] = 13,
									["tt"] = "a",
									["lv"] = "default:jungleleaves",
									["lw"] = 2,
									["lh"] = 3,
									["bx"] = 1,
									["bn"] = 5,
									["bw"] = 1,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									},
		   ["default:jungletree_d"] = {
									["th"] = 16,
									["tt"] = "d",
									["lv"] = "default:jungleleaves",
									["lw"] = 3,
									["lh"] = 3,
									["bx"] = 1,
									["bn"] = 5,
									["bw"] = 1,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									},									
		   ["default:jungletree_x"] = {
									["th"] = 16,
									["tt"] = "x",
									["lv"] = "default:jungleleaves",
									["lw"] = 3,
									["lh"] = 3,
									["bx"] = 1,
									["bn"] = 5,
									["bw"] = 1,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									},
			["default:jungletree_t"] = {
									["th"] = 24,
									["tt"] = "t",
									["lv"] = "default:jungleleaves",
									["lw"] = 3,
									["lh"] = 5,
									["bx"] = 3,
									["bn"] = 16,
									["bw"] = 3,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0,
									}
			  }
			  
			  
			  
			  --                    Tree Config                  --
-----------------------------------------------------
--h  == tree trunk height max
--t  == trunk type, s == single, x == crossed, a == asymmetric eg palm
--w  == tree leaves width
--bx == branch max relative to top eg 1 == +1 higher than top of tree
--bn == branch min relative to top eg 1 == -1 below top of tree
--bw == branch width relative to trunk eg 1 == +1 & -1 out from each side
--lv == leaves name eg "default:leaves" must be supplied.
--ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
--ftx == fruit max above trunk top
--ftn == fruit min below trunk top

-- th == tree trunk height max
-- tt == trunk type, s == single, x == crossed, d == double, a = all,  s == special eg palm
-- lv == leaves name eg "default:leaves" must be supplied.
-- lw == leaves max width (radius) from center trunk eg 1 == +1 & -1 out from each side
-- lh == leaves plus height above trunk max height
-- bx == branch max relative to top eg 1 == +1 higher than top of tree
-- bn == branch min relative to top eg 1 == -1 below top of tree
-- bw == branch width relative to trunk  
-- ft == 0 == no fruit/nuts/attached, "name:of_node" == yes fruit/nuts/attached
-- fx == fruit max above trunk top
-- fn == fruit min below trunk top

--tree_config = {



	--		  }
--[[
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
]]--