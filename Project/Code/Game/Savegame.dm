/Savegame
	var/list/EventFlags = list( )
	var/list/GlobalVariables = list( )

	var/Point/Location = null
	var/PlayerGraphics = null

	var/CurrentMap = ""
	var/list/LoadedChunks = list( )

	var/list/KeyItems = list( )
	var/list/Inventory = list( )
	var/list/Equipped = list( )
	var/list/CampResources = list( "Wood" = 0, "Metal" = 0, "Stone" = 0)
	var/list/Controls = list( )

	var/Language = DefaultLanguage
	var/MusicVolume = DefaultBGMVolume
	var/SoundVolume = DefaultSFXVolume
	var/FancyGraphics = TRUE

	var/IsNewGame = TRUE
	var/SaveSlot = 0
	var/MobStats/PlayerStats = new/MobStats/PlayerStats

	proc
		ImportCurrentState()
			// Load Savegame with current progress info

			// Location
			var/client/C = Config.Clients[1]
			Location = new/Point(C.mob)
			PlayerGraphics = C.mob.icon

			// Map Info
			CurrentMap = Config.MapLoader.CurrentMap
			/* LoadedChunks = Config.Maps.LoadedChunks */

			// Progress
			EventFlags = Config.EventFlags
			GlobalVariables = Config.Globals

			// Options
			MusicVolume = Config.MusicVolume
			SoundVolume = Config.SFXVolume
			Language = Config.Lang.CurrentLang
			Controls = Config.CommandKeys
			FancyGraphics = Config.FancyGraphics
			CampResources = Config.CampResources

			// Inventory
			/*
			KeyItems = Config.KeyItems
			Inventory = Config.Inventory
			Equipped = Config.Equipped
			*/
			PlayerStats = C.mob.Stats

			SaveSlot = Config.SaveSlot
			IsNewGame = FALSE

		Load()
			if (IsNewGame)
				return
			// Load from save
			var/client/C = Config.Clients[1]
			var/mob/M = C.mob

			// Set Options
			Config.Lang.LoadLanguageFile(Language)

			Config.MusicVolume = MusicVolume
			Config.SFXVolume = SoundVolume
			Config.CommandKeys = Controls
			Config.FancyGraphics = FancyGraphics

			// Load player state
			Config.EventFlags = EventFlags
			Config.Globals = GlobalVariables
			Config.CampResources = CampResources

			/*

			Config.KeyItems = KeyItems
			Config.Inventory = Inventory
			Config.Equipped = Equipped

			*/

			// Load Map
			M.Stats = PlayerStats

			if (findtext(CurrentMap, ".dmm"))
				Config.MapLoader.LoadRawMap(CurrentMap)
			else
				Config.MapLoader.LoadMap(CurrentMap)

			/*

			Config.MapLoader.LoadChunks(LoadedChunks)

			*/

			// Cleanup & Positioning

			Config.Menus.PopMenu(M)
			Ticker.ChangeGameMode(/datum/GameMode)

			M.icon = PlayerGraphics
			M.WarpTo(Location)
			Config.Cameras.Warp(M)
			Config.Events.FadeIn()

		Save()
			if (!SaveSlot)
				return

			var/savefile/Save = new/savefile("SAVE[SaveSlot]")
			Save << src
			del Save