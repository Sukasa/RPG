/datum/Ticker
	var/datum/GameMode/Mode = null
	var/Ticks = 0

/datum/Ticker/proc/Tick()
	Ticks++
	if (Ticks % 20 == 0)
		//Game Mode, Machinery, etc tick at 1Hz
		if (Mode && Mode.RunTicker())
			Mode.Tick()
			for (var/mob/M in world)
				M.SlowTick()

	// Mobs move at 20Hz
	for (var/mob/M in world)
		M.MoveTo()
		M.FastTick()

//Whether to allow a NEW player to join in
/datum/Ticker/proc/AllowJoin()
	return TRUE
	if (!Mode || !Mode.RunTicker())
		world << "No Mode, or No Ticker"
		return TRUE
	world << "Checking Mode & Config"
	world << "M: [Mode.AllowLateJoin] C: [Config.AllowLateJoin]"
	return Mode.AllowLateJoin && Config.AllowLateJoin

/datum/Ticker/proc/Start()
	spawn
		while (TRUE)
			Tick()
			sleep(0.5)

/datum/Ticker/proc/BeginRound(var/GameModeType)
	Mode = new GameModeType()
	if (Mode.AutoAssignTeams)
		AutoAssignTeams()

