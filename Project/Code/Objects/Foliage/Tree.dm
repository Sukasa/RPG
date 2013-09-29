/obj/Foliage/Tree
	name = "Tree"
	icon = 'OakTree.dmi'
	icon_state = "Tree"
	density = 1
	bound_width = 16
	bound_height = 16
	bound_x = 24
	bound_y = 0

	PalmTree
		icon = 'PalmTree.dmi'

	PineTree
		icon = 'PineTree.dmi'

/*	DeadTree
		icon = 'DeadTree.dmi'
*/
/obj/Foliage/Tree/New()
	..()
	spawn(1)
		var/image/overlayimage = image(src.icon, src, "Overlay", 20)
		overlayimage.alpha = 128
		world << overlayimage
		src.overlays += overlayimage

		var/image/shadowimage = image(src.icon, src, "Shadow", 21)
		shadowimage.alpha = 128
		world << shadowimage
		src.overlays += shadowimage
