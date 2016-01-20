var/Ticker/Ticker = new()
var/datum/Configuration/Config = new()

world
	New()
		..()
		Config.IsDevMode = fexists("libBYONDDevTools.dll")
		if (Config.IsDevMode)
			RegisterDevScriptFunctions()
			call("libBYONDDevTools.dll", "usemillenniumepoch")() // Use Millenium epoch for timestamps due to BYOND's numeric limits
		Ticker.Mode = new Config.StartMode()
		Ticker.Mode.Start()
		Ticker.Start()