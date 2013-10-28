/obj/Environment/CliffFace
	icon = 'Cliff.dmi'
	density = 1

	Side
		West
			icon_state = "W"
			bound_width = 20
			dir = WEST

		East
			icon_state = "E"
			bound_width = 20
			bound_x = 12
			dir = EAST

		North
			icon_state = "N"
			bound_height = 16
			bound_y = 12
			dir = NORTH

		South
			icon_state = "S"
			bound_height = 21
			dir = SOUTH

	Ramp
		density = 0
		West
			icon_state = "StairsW"
		East
			icon_state = "StairsE"
		North
			icon_state = "StairsN"
		South
			icon_state = "StairsS"

	OuterCorner
		NorthEast
			icon_state = "NEo"
			bound_height = 28
			bound_width = 32

		NorthWest
			icon_state = "NWo"
			bound_height = 28

		SouthEast
			icon_state = "SEo"

		SouthWest
			icon_state = "SWo"

	InnerCorner
		NorthWest
			icon_state = "NWi"
			bound_width = 20
			bound_height = 16
			bound_y = 12

		NorthEast
			icon_state = "NEi"
			bound_width = 20
			bound_height = 16
			bound_x = 12
			bound_y = 12

		SouthWest
			icon_state = "SWi"
			bound_width = 20
			bound_height = 21

		SouthEast
			icon_state = "SEi"
			bound_width = 20
			bound_height = 21
			bound_x = 12