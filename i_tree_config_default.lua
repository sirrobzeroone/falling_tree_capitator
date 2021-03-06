
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
									["sp"] = "default:sapling"
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
									["sp"] = "default:aspen_sapling"									
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
									["sp"] = "default:pine_sapling"
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
									["sp"] = "default:acacia_sapling"
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
									["sp"] = "default:junglesapling"
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
									["sp"] = "default:junglesapling"
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
									["sp"] = "default:junglesapling"
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
									["sp"] = "default:junglesapling"
									}
			  }