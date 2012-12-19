/datum/Ticker
	var/datum/GameMode/Mode = null
	var/Ticks = 0

/datum/Ticker/proc/Tick()
	Ticks++
	if (Ticks % 20 == 0)
		//Game Mode, Machinery, etc tick at 1Hz
		if (Mode && Mode.Started)
			Mode.Tick()
			for (var/mob/M in world)
				M.Tick()

	// Mobs move at 20Hz
	for (var/mob/M in world)
		M.MoveTo()

/datum/Ticker/proc/Start()
	spawn
		while (TRUE)
			Tick()
			sleep(0.5)