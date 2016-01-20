/obj/Runtime/TreeShadow
	var/Crosses = 0
	layer = ShadowLayer
	density = 0

	New(var/Loc, var/obj/Foliage/Tree/Source)
		bound_x = Source.ShadowBoundX
		bound_y = Source.ShadowBoundY
		bound_width = Source.ShadowBoundWidth
		bound_height = Source.ShadowBoundHeight

		icon = Source.icon
		icon_state = "Overlay"

		step_x = Source.step_x
		step_y = Source.step_y

	Crossed(var/atom/movable/O)
		if (ismob(O) && !istype(O, /mob/Camera))
			if (!Crosses)
				animate(src, alpha = 64, time = 2)
			Crosses++

	Uncrossed(var/atom/movable/O)
		if (ismob(O) && !istype(O, /mob/Camera))
			Crosses--
		if (!Crosses)
			animate(src, alpha = AlphaOpaque, time = 2)