/obj/Foliage/Tree
	icon = 'GreenTree.dmi'
	name = "Tree"
	icon_state = "Tree"
	density = 1
	bound_width = 24
	bound_height = 24
	bound_x = 36
	bound_y = 16

	PalmTree
		icon = 'PalmTree.dmi'
		bound_width = 16
		bound_height = 16
		bound_x = 24
		bound_y = 0

	PineTree
		icon = 'PineTree.dmi'

	DeadTree
		icon = 'DeadTree.dmi'

	DeadTreeHole
		icon = 'DeadTreeHole.dmi'

	ThinTree1
		icon = 'ThinTree1.dmi'
		bound_x = 8
		bound_width = 16
		bound_height = 16
		bound_y = 0

	ThinTree2
		icon = 'ThinTree2.dmi'
		bound_x = 8
		bound_y = 4
		bound_width = 16
		bound_height = 16

/obj/Foliage/Tree/New()
	..()
	spawn(1)
		var/image/overlayimage = image(src.icon, src, "Overlay", OverlayLayer)
		overlayimage.alpha = 128
		world << overlayimage
		src.overlays += overlayimage

		var/image/shadowimage = image(src.icon, src, "Shadow", ShadowLayer)
		shadowimage.alpha = 128
		world << shadowimage
		src.overlays += shadowimage
