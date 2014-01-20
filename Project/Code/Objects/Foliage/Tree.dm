/obj/Foliage/Tree
	icon = 'OakTree.dmi'
	name = "Tree"
	icon_state = "Tree"
	density = 1
	bound_width = 24
	bound_height = 18
	bound_x = 36
	bound_y = 16
	var
		image/LeafOverlay
		FoliageBoundX = 8
		FoliageBoundY = 32
		FoliageBoundWidth = 80
		FoliageBoundHeight = 80

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
	layer -= ((x + y) / 1000)
	icon_state = "Blank"
	spawn(1)
		var/image/overlayimage = image(src.icon, src, "Trunk", OBJ_LAYER - 0.5 - ((x + y) / 1000))
		world << overlayimage
		src.overlays += overlayimage

		overlayimage = image(src.icon, src, "Shadow", ShadowLayer - 0.4 - ((x + y) / 1000))
		world << overlayimage
		src.overlays += overlayimage

		new/obj/Runtime/TreeLeaves(loc, src)