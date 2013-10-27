/turf/Autojoin
	var/list/MatchTypes = list( )
	icon_state = "255"
	Init()
		. = ..()
		var/B = 0
		for(var/X = 1, X <= 8, X++)
			var/turf/T = get_step(src, Cardinal8[X])
			if (!T || T.type in (MatchTypes + type))
				B |= 1 << X
		icon_state = "[Config.AutoTile[(B >> 1) + 1]]"