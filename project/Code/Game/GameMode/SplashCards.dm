/datum/GameMode/SplashCards
	Name = "Intro Splash Cards"
	ModeKey = "SC"

/datum/GameMode/SplashCards/Tick()
	return

/datum/GameMode/SplashCards/Start()
	SetMobLayerEnabled(FALSE)
	spawn(5)
		if (Config.IsDevMode)
			DebugText("\yellow Development tools enabled")
		Config.Events.RunScript("Splashes")

		Ticker.ChangeGameMode(/datum/GameMode/TitleScreen)

/datum/GameMode/SplashCards/ShowHUD()
	return FALSE

/datum/GameMode/SplashCards/End()
	return

/datum/GameMode/SplashCards/RunTicker()
	return TRUE