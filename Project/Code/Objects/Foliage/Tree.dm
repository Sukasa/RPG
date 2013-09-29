/obj/Foliage/Tree
	name = "Tree"
	icon = 'OakTree.dmi'
	icon_state = "Tree"
	density = 1
	bound_width = 12
	bound_height = 12
	bound_x = 25
	bound_y = 2

/obj/Foliage/Tree/New()
	..()
	spawn(1)
		var/image/OverlayImage = image(src.icon, src, "Overlay",20)
		OverlayImage.alpha = 128
		world << OverlayImage
		src.overlays += OverlayImage

		OverlayImage = image(src.icon, src, "Overlay2",20)
		OverlayImage.alpha = 128
		world << OverlayImage
		src.overlays += OverlayImage