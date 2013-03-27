var/datum/Ticker/Ticker
var/datum/Configuration/Config = new()

world
	New()
		Ticker = new()
		Ticker.Start()
		Ticker.Mode = new /datum/GameMode/PreGame()
		spawn(10)
			Ticker.Mode.Start()