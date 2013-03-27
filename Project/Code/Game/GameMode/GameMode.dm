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

/datum/GameMode/proc/RunTicker()
	return TRUE

/datum/GameMode/proc/OnPlayerJoin(var/mob/Player)
	return

/datum/GameMode/proc/OnPlayerDisconnect(var/mob/Player)
	return

/datum/GameMode/proc/OnPlayerSpawn(var/mob/Player)
	return

/datum/GameMode/proc/OnPlayerDeath(var/mob/Player)
	return

/datum/GameMode/proc/GetAssignedTeam(var/mob/Player)
	return pick(list(TeamAttackers, TeamDefenders, TeamSpectators));

/datum/GameMode/proc/Command(var/Command, var/CommandParams[])
	return