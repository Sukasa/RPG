/datum/GameMode/SplashCards
	Name = "Intro Splash Cards"
	ModeKey = "SC"

/datum/GameMode/SplashCards/Tick()
	return

/datum/GameMode/SplashCards/Start()
	SetMobLayerEnabled(FALSE)
	spawn(5)
		Config.Events.RunScript("Splashes2")

		Ticker.ChangeGameMode(/datum/GameMode/TitleScreen)


/datum/GameMode/SplashCards/End()
	return

/datum/GameMode/SplashCards/RunTicker()
	return TRUE