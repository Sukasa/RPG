
turf/Wall
	opacity = 0 //Temporary, for cover system testing
	density = 1
	icon_state = "0"

	BulletDensity = 1
	CoverValue = 100

turf/Wall/New()
	var/IS = 0
	for (var/Dir in Cardinal)
		if (istype(get_step(src, Dir), src.type))
			IS |= Dir
	src.icon_state = "[IS]"

turf/Wall/Outer_Wall
	icon = 'ExteriorWall.dmi'