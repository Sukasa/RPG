/datum/GameMode
	var
		Name = ""
		AutoAssignTeams = TRUE
		AllowLateJoin = TRUE
		ModeKey = ""

/datum/GameMode/proc/Tick()
	return

/datum/GameMode/proc/Start()
	return

/datum/GameMode/proc/End()
	return

/datum/GameMode/proc/CheckEnd()
	return FALSE

/datum/GameMode/proc/RunTicker()
	return TRUE

/datum/GameMode/proc/GetAssignedTeam(var/mob/Player)
	return pick(list(TeamAttackers, TeamDefenders, TeamSpectators));