/datum/Ticker
	var/datum/GameMode/Mode = null
	var/Ticks = 0
	var/list/HighSpeedDevices = list( )

/datum/Ticker/proc/Tick()
	Ticks++
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
		M.MoveTo()

	if (Mode && Mode.RunTicker())
		Config.NetController.Tick()

		// Mobs fasttick at 30Hz (or whatever the value of world.fps is), but only if the ticker says to.
		for (var/mob/M in world)
			M.FastTick()

		// Registered high-speed-logic devices also get fastticked at 30Hz (or whatever the value of world.fps is)
		for (var/obj/O in HighSpeedDevices)
			O.FastTick()



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
		world << "No Mode, or No Ticker"
		return TRUE
	world << "Checking Mode & Config"
	world << "M: [Mode.AllowLateJoin] C: [Config.AllowLateJoin]"
	return Mode.AllowLateJoin && Config.AllowLateJoin

/datum/Ticker/proc/Start()
	spawn
		while (TRUE)
			Tick()
			sleep(0.5) // I'm not sure why 0.5 makes the ticker run at (world.fps) specifically, but...

