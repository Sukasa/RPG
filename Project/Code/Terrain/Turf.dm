/turf/proc/GetCoverValue()
	var/V = src.CoverValue
	for (var/atom/A in src)
		if (A.CoverValue > V)
			V = A.CoverValue
	return V

/turf
	var
		FloorplanIconState = null

/turf/New()
	..()
	spawn(5)
		CreateStandIn()
		icon = 'Green.dmi'
		icon_state = FloorplanIconState ? FloorplanIconState : icon_state

/turf/proc/CreateStandIn()
	var/obj/Runtime/TurfStandIn/StandIn = new(src)
	StandIn.icon = icon
	StandIn.icon_state = icon_state