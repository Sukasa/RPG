/obj/Runtime/TreeLeaves
	var/Crosses = 0
	density = 0
	layer = OverlayLayer

	New(var/Loc, var/obj/Foliage/Tree/Source)
		..()
		bound_x = Source.FoliageBoundX
		bound_y = Source.FoliageBoundY
		bound_width = Source.FoliageBoundWidth
		bound_height = Source.FoliageBoundHeight

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