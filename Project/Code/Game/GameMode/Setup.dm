/datum/GameMode/Setup
	Name = "Setup"

/datum/GameMode/Setup/Start()
	DebugText("Setup")
	Config.NetController.Init()
	Config.Lang.Init()
	Config.MapLoader.Init()
	Config.Events.Init()

	Ticker.ChangeGameMode(/datum/GameMode/SplashCards)