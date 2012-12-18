var/datum/Ticker/Ticker

world
	New()
		Ticker = new()
		Ticker.Start()