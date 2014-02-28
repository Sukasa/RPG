/obj/Environment/Sign
	name = "Sign"
	icon_state = "Sign"
	density = 1
	bound_width = 32
	bound_height = 16
	bound_x = 0
	bound_y = 0

	TestSign
		icon = 'TestSign.dmi'

/obj/Environment/Sign/Init()
	. = list( )
	var/image/overlayimage = image(src.icon, src, "Overlay", 20)
	overlayimage.alpha = 128
	world << overlayimage
	src.overlays += overlayimage

