/datum/GameMode
	var
		Name = ""
		AutoAssignTeams = TRUE
		AllowLateJoin = TRUE
		ModeKey = ""
		list/Commands = list( )

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
	return LateAssign(Player)

/datum/GameMode/proc/Command(var/mob/Executor, var/Command, var/CommandParams[])
	return