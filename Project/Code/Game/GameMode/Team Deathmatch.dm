/datum/GameMode/TeamDeathmatch
	Name = "Team Deathmatch"
	ModeKey = "TDM"

/datum/GameMode/TeamDeathmatch/Tick()
	return

/datum/GameMode/TeamDeathmatch/Start()
	GameText("Begin!")
	for (var/mob/M in world)
		if (M.client)
			M.Respawn()
	return

/datum/GameMode/TeamDeathmatch/End()
	return