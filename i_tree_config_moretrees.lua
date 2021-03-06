
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
-- sp == sapling name

tree_config["moretrees:beech_trunk"] = {
									["th"] = 8,
									["tt"] = "s",
									["lv"] = "moretrees:beech_leaves",
									["lw"] = 4,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 2,
									["bw"] = 2,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}
									
tree_config["moretrees:apple_tree_trunk"] = {
									["th"] = 8,
									["tt"] = "s",
									["lv"] = "moretrees:apple_tree_leaves",
									["lw"] = 9,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 5,
									["bw"] = 7,
									["ft"] = "default:apple",
									["fx"] = 2,
									["fn"] = 6
									}
			 
tree_config["moretrees:oak_trunk"] = {
									["th"] = 22,
									["tt"] = "x",
									["lv"] = "moretrees:oak_leaves",
									["lw"] = 11,
									["lh"] = 4,
									["bx"] = 2,
									["bn"] = 16,
									["bw"] = 10,
									["ft"] = "moretrees:acorn",
									["fx"] = 1,
									["fn"] = 18
									}
									
tree_config["moretrees:poplar_trunk"] = {
									["th"] = 24,
									["tt"] = "s",
									["lv"] = "moretrees:poplar_leaves",
									["lw"] = 4,
									["lh"] = 4,
									["bx"] = 0,
									["bn"] = 0,
									["bw"] = 0,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}
									
tree_config["moretrees:sequoia_trunk"] = {
									["th"] = 40,
									["tt"] = "x",
									["lv"] = "moretrees:sequoia_leaves",
									["lw"] = 9,
									["lh"] = 4,
									["bx"] = 4,
									["bn"] = 30,
									["bw"] = 8,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}
									
tree_config["moretrees:birch_trunk"] = {
									["th"] = 19,
									["tt"] = "s",
									["lv"] = "moretrees:birch_leaves",
									["lw"] = 7,
									["lh"] = 5,
									["bx"] = 4,
									["bn"] = 12,
									["bw"] = 5,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}

tree_config["moretrees:spruce_trunk"] = {
									["th"] = 32,
									["tt"] = "x",
									["lv"] = "moretrees:spruce_leaves",
									["lw"] = 9,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 27,
									["bw"] = 6,
									["ft"] = "moretrees:spruce_cone",
									["fx"] = 1,
									["fn"] = 28
									}

tree_config["moretrees:cedar_trunk"] = {
									["th"] = 22,
									["tt"] = "s",
									["lv"] = "moretrees:cedar_leaves",
									["lw"] = 9,
									["lh"] = 4,
									["bx"] = 3,
									["bn"] = 17,
									["bw"] = 7,
									["ft"] = "moretrees:cedar_cone",
									["fx"] = 1,
									["fn"] = 18
									}

tree_config["moretrees:willow_trunk"] = {
									["th"] = 15,
									["tt"] = "x",
									["lv"] = "moretrees:willow_leaves",
									["lw"] = 12,
									["lh"] = 4,
									["bx"] = 3,
									["bn"] = 13,
									["bw"] = 11,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}	

tree_config["moretrees:rubber_tree_trunk"] = {
									["th"] = 10,
									["tt"] = "d",
									["lv"] = "moretrees:rubber_tree_leaves",
									["lw"] = 8,
									["lh"] = 7,
									["bx"] = 6,
									["bn"] = 6,
									["bw"] = 6,
									["ft"] = 0,
									["fx"] = 0,
									["fn"] = 0
									}

tree_config["moretrees:jungletree_trunk"] = {
									["th"] = 11,
									["tt"] = "a",
									["lv"] = {"default:jungleleaves","moretrees:jungletree_leaves_red","moretrees:jungletree_leaves_yellow"},
									["lw"] = 6,
									["lh"] = 1,
									["bx"] = 0,
									["bn"] = 5,
									["bw"] = 3,
									["ft"] = "vines:vine",
									["fx"] = 2,
									["fn"] = 11
									}

tree_config["moretrees:jungletree_trunk_d"] = {
									["th"] = 34,
									["tt"] = "d",
									["lv"] = {"default:jungleleaves","moretrees:jungletree_leaves_red","moretrees:jungletree_leaves_yellow"},
									["lw"] = 8,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 26,
									["bw"] = 6,
									["ft"] = "vines:vine",
									["fx"] = 2,
									["fn"] = 34
									}

tree_config["moretrees:jungletree_trunk_x"] = {
									["th"] = 24,
									["tt"] = "x",
									["lv"] = {"default:jungleleaves","moretrees:jungletree_leaves_red","moretrees:jungletree_leaves_yellow"},
									["lw"] = 8,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 12,
									["bw"] = 6,
									["ft"] = "vines:vine",
									["fx"] = 2,
									["fn"] = 24
									}

tree_config["moretrees:jungletree_trunk_t"] = {
									["th"] = 34,
									["tt"] = "t",
									["lv"] = {"default:jungleleaves","moretrees:jungletree_leaves_red","moretrees:jungletree_leaves_yellow"},
									["lw"] = 8,
									["lh"] = 2,
									["bx"] = 1,
									["bn"] = 26,
									["bw"] = 6,
									["ft"] = "vines:vine",
									["fx"] = 2,
									["fn"] = 34
									}									
--tree_config = {			
--		      ["moretrees:palm_trunk"]       = {["h"] = 11,["t"] = "a",["w"] = 10,["bx"] = 6,["bn"] = 0, ["bw"] = 4, ["lv"] = "moretrees:palm_leaves"      ,["ft"] = 0                      ,["ftx"] = 0, ["ftn"] = 0},
--		      ["moretrees:fir_trunk"]        = {["h"] = 15,["t"] = "s",["w"] = 12,["bx"] = 3,["bn"] = 14,["bw"] = 11,["lv"] = "moretrees:willow_leaves"    ,["ft"] = "moretrees:fir_cone"   ,["ftx"] = 0, ["ftn"] = 0}				
--			  }"moretrees:rubber_tree_trunk""moretrees:fir_trunk"