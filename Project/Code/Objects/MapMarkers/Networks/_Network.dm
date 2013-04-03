/obj/MapMarker/Network
	CanTarget = FALSE
	var/Dirs = 0
	var/NetNum = 0

/obj/MapMarker/Network/New()
	invisibility = 80
	Dirs = text2num(icon_state)
