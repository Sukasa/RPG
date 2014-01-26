/obj/Runtime/TreeLeaves
	var/Crosses = 0
	density = 0

	New(var/Loc, var/obj/Foliage/Tree/Source)
		bound_x = Source.FoliageBoundX
		bound_y = Source.FoliageBoundY
		bound_width = Source.FoliageBoundWidth
		bound_height = Source.FoliageBoundHeight

		layer = OverlayLayer - ((x + y) / 1000)

		icon = Source.icon
		icon_state = "Overlay"

	Crossed(var/atom/movable/O)
		if (ismob(O) && !istype(O, /mob/Camera))
			if (!Crosses)
				animate(src, alpha = 96, time = 2)
			Crosses++

	Uncrossed(var/atom/movable/O)
		if (ismob(O) && !istype(O, /mob/Camera))
			Crosses--
		if (!Crosses)
			animate(src, alpha = 255, time = 2)