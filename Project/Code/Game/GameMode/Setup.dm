/datum/GameMode/Setup
	Name = "Setup"

/datum/GameMode/Setup/Start()
	Config.NetController.Init()
	Config.Lang.Init()
	Config.MapLoader.Init()

	//Ticker.ChangeGameMode(/datum/GameMode/SplashCards)