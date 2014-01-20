/obj/MapMarker/Location
	icon_state = "Radar"

	Init()
		. = ..()
		Config.Locations[tag] = list(x, y, z)