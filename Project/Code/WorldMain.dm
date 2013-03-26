var/datum/Ticker/Ticker
var/datum/Configuration/Config
var/list/SpawnZones = list( list( ), list( ), list( ), list( ) )

world
	New()
		Ticker = new()
		Ticker.Start()
		Ticker.Mode = new /datum/GameMode()
		Ticker.Mode.Start()