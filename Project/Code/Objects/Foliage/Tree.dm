/obj/Foliage/Tree
	icon = 'OakTree.dmi'
	name = "Tree"
	icon_state = "Blank"
	density = 0
	bound_width = 80
	bound_height = 80
	bound_x = 8
	bound_y = 32
	var/Crosses = 0
	var/image/LeafOverlay

	OakTree
		icon = 'OakTree.dmi'

	PalmTree
		icon = 'PalmTree.dmi'

	PineTree
		icon = 'PineTree.dmi'

	DeadTree
		icon = 'DeadTree.dmi'

	ThinTree1
		icon = 'ThinTree1.dmi'
		bound_x = 8

	ThinTree2
		icon = 'ThinTree2.dmi'
		bound_x = 8
		bound_y = 4

/obj/Foliage/Tree/New()
	..()
	layer -= ((x + y) / 500)
	spawn(1)
		var/image/overlayimage = image(src.icon, src, "Trunk", OBJ_LAYER - 0.5 - ((x + y) / 500))
		world << overlayimage
		src.overlays += overlayimage
		LeafOverlay = image(src.icon, src, "Overlay", OverlayLayer - 0.5 - ((x + y) / 500))
		world << LeafOverlay
		src.overlays += LeafOverlay

/obj/Foliage/Tree/Crossed(var/atom/movable/O)
	if (ismob(O))
		Crosses++
	src.overlays -= LeafOverlay
	LeafOverlay.alpha = 96
	src.overlays += LeafOverlay

/obj/Foliage/Tree/Uncrossed(var/atom/movable/O)
	if (ismob(O))
		Crosses--
	if (!Crosses)
		src.overlays -= LeafOverlay
		LeafOverlay.alpha = 255
		src.overlays += LeafOverlay