
turf
	Wall
		opacity = 1
		density = 1
		icon_state = "0"

		New()
			var/IS = 0
			for (var/Dir in Cardinal)
				if (istype(get_step(src, Dir), src.type))
					IS |= Dir
			src.icon_state = "[IS]"

		Outer_Wall
			icon = 'ExteriorWall.dmi'