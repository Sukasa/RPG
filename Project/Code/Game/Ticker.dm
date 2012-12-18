/datum/Ticker
	var/datum/GameMode/Mode = null

/datum/Ticker/proc/Tick()
	if (Mode && Mode.Started)
		Mode.Tick()

/datum/Ticker/proc/Start()
	spawn
		while (TRUE)
			Tick()
			sleep(10)