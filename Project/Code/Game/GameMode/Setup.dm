/datum/GameMode/Setup
	Name = "Setup"

/datum/GameMode/Setup/Start()
	Config.NetController.Init()
	Config.Lang.Init()
	Config.MapLoader.Init()
	Config.Events.Init()
	Config.Audio.Init()
	Config.Particles.Init()

	// Autotile setup
	for(var/X = 0; X < 256, X++)
		var/B = X & 85
		if (((X & 5) == 5) && (X & 2))
			B |= 2
		if (((X & 20) == 20) && (X & 8))
			B |= 8
		if (((X & 80) == 80) && (X & 32))
			B |= 32
		if (((X & 65) == 65) && (X & 128))
			B |= 128
		Config.AutoTile += B

	Ticker.ChangeGameMode(/datum/GameMode/SplashCards)