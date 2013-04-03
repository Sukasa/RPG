/obj/MapMarker/Network
	CanTarget = FALSE
	var/Dirs = 0
	var/datum/Network/Network = null

/obj/MapMarker/Network/New()
	invisibility = 80
	Dirs = text2num(icon_state)
