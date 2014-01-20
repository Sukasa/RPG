/area
	icon = 'Flats.dmi'
	invisibility = Invisible
	layer = TOPDOWN_LAYER + FLY_LAYER
	icon_state = "Transparent"

	var
		CameraDensity = FALSE

	proc
		OnEntered(var/turf/Turf, var/mob/Player)