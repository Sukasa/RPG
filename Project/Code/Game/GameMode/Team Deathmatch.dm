/datum/GameMode/TeamDeathmatch
	Name = "Team Deathmatch"
	ModeKey = "TDM"
	AutoAssignTeams = TRUE

/datum/GameMode/TeamDeathmatch/Tick()
	return

/datum/GameMode/TeamDeathmatch/Start()
	GameText("\red TEAM DEATHMATCH!")
	return

/datum/GameMode/TeamDeathmatch/End()
	return