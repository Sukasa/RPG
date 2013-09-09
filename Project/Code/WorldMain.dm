var/datum/Ticker/Ticker = new()
var/datum/Configuration/Config = new()

world
	New()
		Ticker.Mode = new Config.StartMode()
		Ticker.Mode.Start()
		Ticker.Start()