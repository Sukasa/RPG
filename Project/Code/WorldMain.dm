var/datum/Ticker/Ticker

world
	New()
		Ticker = new()
		Ticker.Start()
		Ticker.Mode = new /datum/GameMode()
		Ticker.Mode.Start()