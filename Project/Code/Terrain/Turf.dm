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

	icon = 'black.dmi'
	icon_state = "Black"

/turf/New()
	..()

/turf/proc/Propagate()
	. = list( )
	for(var/Dir in Cardinal8)
		var/turf/T = get_step(src, Dir)
		if (!T)
			continue
		if (T.CameraDensity < CameraDensity - 1)
			T.CameraDensity = CameraDensity - 1
			if (T.CameraDensity > 1)
				. += T

/turf/proc/Init()
	if (Config.CreateTurfStandIns)
		CreateStandIn()
		icon = 'Green.dmi'
		SetCursor(CursorGreen)
		icon_state = FloorplanIconState ? FloorplanIconState : icon_state
	if (isarea(loc) && loc:CameraDensity)
		CameraDensity = world.view
		return list(src)
	return list( )

/turf/proc/CreateStandIn()
	var/obj/Runtime/TurfStandIn/StandIn = new(src)
	StandIn.icon = icon
	StandIn.icon_state = icon_state
	StandIn.SetCursor(CursorGreen)