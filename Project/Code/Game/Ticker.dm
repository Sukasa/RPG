/datum/Ticker
	var/datum/GameMode/Mode = null
	var/Ticks = 0
	var/list/HighSpeedDevices = list( )
	var/State = TickerNotStarted

/datum/Ticker/proc/Tick()
	if (State != TickerRunning)
		return

	Ticks++
	//world.log << "[Ticks]"
	if (Ticks % world.fps == 0)
		//Game Mode, Machinery, etc slowtick at 1Hz
		if (Mode)
			Mode.Tick()

		if (Mode && Mode.RunTicker())
			for (var/mob/M in world)
				M.SlowTick()
			for(var/obj/Machinery/O in world)
				O.SlowTick()

	// Mobs move at 30Hz (or whatever the value of world.fps is)
	for (var/mob/M in world)
		if (!istype(M, /mob/Camera))
			M.MoveTo()

	Config.Cameras.Tick()

	Config.Menus.Tick()

	// Handle the player's (players'?) input.
	for (var/client/C)
		C.KeyTick()

	if (Mode && Mode.RunTicker())
		// Signalling, etc ticks at 30Hz
		Config.NetController.Tick()

		// Mobs fasttick at 30Hz (or whatever the value of world.fps is), but only if the game mode says to.
		for (var/mob/M in world)
			M.FastTick()

		// Registered high-speed-logic devices also get fastticked at 30Hz (or whatever the value of world.fps is)
		for (var/obj/O in HighSpeedDevices)
			O.FastTick()

	Config.Audio.Tick()

/datum/Ticker/proc/ChangeGameMode(var/NewMode)
	Mode.End()
	Mode = new NewMode()
	if (Mode.AutoAssignTeams)
		AutoAssignTeams()
	Mode.Start()

//Whether to allow a NEW player to join in
/datum/Ticker/proc/AllowJoin()
	return TRUE
	if (!Mode || !Mode.RunTicker())
		return TRUE
	return Mode.AllowLateJoin && Config.AllowLateJoin

/datum/Ticker/proc/Start()
	if (State == TickerNotStarted)
		spawn
			while(TRUE)
				Tick()
				sleep(world.tick_lag)
	State = TickerRunning

/datum/Ticker/proc/Suspend()
	State = TickerSuspended