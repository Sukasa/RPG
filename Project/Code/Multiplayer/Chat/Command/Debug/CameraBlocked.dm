/datum/ChatCommand/CamBlocked
	Command = "cb"

/datum/ChatCommand/CamBlocked/Execute(var/mob/Player, var/CommandText)
	for(var/turf/T in world)
		if (T.CameraDensity)
			T.overlays += icon('Flats.dmi', "Red")