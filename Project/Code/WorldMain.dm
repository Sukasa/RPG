var/datum/Ticker/Ticker = new()
var/datum/Configuration/Config = new()

world
	New()
		..()
		Config.IsDevMode = fexists("libBYONDDevTools.dll")
		Ticker.Mode = new Config.StartMode()
		Ticker.Mode.Start()
		Ticker.Start()