var/datum/Ticker/Ticker = new()
var/datum/Configuration/Config = new()

world
	New()
		Ticker.Start()
		Ticker.Mode = new Config.StartMode()
		spawn(10)
			Ticker.Mode.Start()