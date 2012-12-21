var/datum/Ticker/Ticker
var/datum/Configuration/Config

world
	New()
		Ticker = new()
		Ticker.Start()
		Ticker.Mode = new /datum/GameMode()
		Ticker.Mode.Start()