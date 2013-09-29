/area
	icon = 'Flats.dmi'
	invisibility = 101
	layer = TURF_LAYER + 1
	icon_state = "Transparent"

	var
		CameraDensity = FALSE

	proc
		OnEntered(var/turf/Turf, var/mob/Player)