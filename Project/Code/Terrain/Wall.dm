
turf/Wall
	opacity = 1
	density = 1
	icon_state = "0"

	BulletDensity = 1
	CoverValue = 100
	var
		Prefix = ""

turf/Wall/New()
	..()
	var/IS = 0
	for (var/Dir in Cardinal)
		if (istype(get_step(src, Dir), src.type))
			IS |= Dir
	src.icon_state = "[Prefix][IS]"

turf/Wall/Outer_Wall
	icon = 'ExteriorWall.dmi'

turf/Wall/Inner_Wall
	icon = 'InteriorWall.dmi'