/turf/proc/GetCoverValue()
	var/V = src.CoverValue
	for (var/atom/A in src)
		if (A.CoverValue > V)
			V = A.CoverValue
	return V

/turf
	var
		FloorplanIconState = null
		CameraDensity = FALSE
		step_x = 0
		step_y = 0
		OverriddenDensity = FALSE

	icon = 'black.dmi'
	icon_state = "Black"

	Entered(var/Entree)
		loc:OnEntered(src, Entree)

/turf/proc/Propagate()
	. = list( )
	for(var/Dir in Cardinal)
		var/turf/T = get_step(src, Dir)
		if (!T)
			continue
		if (T.CameraDensity < CameraDensity - 1)
			T.CameraDensity = CameraDensity - 1
			. += T

/turf/proc/Init()
	. = list( )
	for(var/obj/O in src)
		. |= O.Init()
		if (O.OverrideTurfDensity)
			density = O.density
			OverriddenDensity = TRUE
	if (isarea(loc))
		if(loc:CameraDensity)
			CameraDensity = world.view + 1
			. += src
		density |= loc.density

/turf/proc/CreateStandIn()
	var/obj/Runtime/TurfStandIn/StandIn = new(src)
	StandIn.icon = icon
	StandIn.icon_state = icon_state

/turf/proc/Neighbors()
	. = list( )
	for(var/Dir in Cardinal8)
		. += get_step(src, Dir)