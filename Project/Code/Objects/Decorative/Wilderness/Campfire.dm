/obj/Decorative/Wilderness/Campfire
	var/list/CrossingMobs = list()

	icon = 'Cooking.dmi'
	icon_state = "Campfire"
	bound_x = 10
	bound_y = 10
	bound_width = 15
	bound_height = 15

	Crossed(var/mob/M)
		if (!istype(M))
			return
		CrossingMobs |= M

	Uncrossed(var/mob/M)
		if (!istype(M))
			return
		CrossingMobs -= M

	SlowTick()
		for(var/mob/M in CrossingMobs)
			// Harm Mob
			M << "Burn"
			continue