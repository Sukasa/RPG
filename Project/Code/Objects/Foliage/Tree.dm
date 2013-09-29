/obj/Foliage/Tree
	name = "Tree"
	icon_state = "Tree"
	density = 1
	bound_width = 16
	bound_height = 16
	bound_x = 24
	bound_y = 0

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
