
turf/Wall
	opacity = 0
	density = 1
	icon_state = "0"

	BulletDensity = 1
	CoverValue = 100
	var
		Prefix = ""

turf/Wall/Init()
	var/IS = 0
	for (var/Dir in Cardinal)
		if (istype(get_step(src, Dir), src.type))
			IS |= Dir
	src.icon_state = "[Prefix][IS]"
	..()