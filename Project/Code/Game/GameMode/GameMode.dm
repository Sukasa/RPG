/datum/GameMode
	var
		Name = ""
		AutoAssignTeams = TRUE
		AllowLateJoin = TRUE
		ModeKey = ""
		list/Commands = list( )
		DefaultCanVote = FALSE

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

/datum/GameMode/proc/SetMobLayerEnabled(var/Enabled)
	for(var/mob/M in world)
		M.invisibility = Enabled ? 0 : 101
	Config.MobLayerEnabled = Enabled