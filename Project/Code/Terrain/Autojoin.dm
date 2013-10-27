/turf/Autojoin
	icon_state = "255"
	Init()
		. = ..()
		var/B = 0
		for(var/X = 1, X <= 8, X++)
			var/turf/T = get_step(src, Cardinal8[X])
			if (!T || istype(T, type))
				B |= AutoJoinBits8[X]
		icon_state = "[Config.AutoTile[B + 1]]"