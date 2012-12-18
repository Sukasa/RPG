/datum/GameMode
	var/Started = FALSE

/datum/GameMode/proc/Tick()
	return

/datum/GameMode/proc/Start()
	Started = TRUE
	return

/datum/GameMode/proc/End()
	return