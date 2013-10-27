/Savegame
	var/list/EventFlags = list( )

	var/Point/Location = null

	var/CurrentMap = ""
	var/list/LoadedChunks = list( )

	var/list/KeyItems = list( )
	var/list/Inventory = list( )
	var/list/Equipped = list( )

	var/list/Controls = list( )
	var/Language = DefaultLanguage
	var/MusicVolume = DefaultBGMVolume
	var/SoundVolume = DefaultSFXVolume
	var/FancyGraphics = TRUE

	var/IsNewGame = TRUE
	var/SaveSlot = 0

	proc
		ImportCurrentState()
			// Load Savegame with current progress info

			// Location
			var/client/C = Config.Clients[1]
			Location = new/Point(C.mob)

			// Map Info
			CurrentMap = Config.MapLoader.CurrentMap
			/* LoadedChunks = Config.Maps.LoadedChunks */

			// Progress
			EventFlags = Config.EventFlags

			// Options
			MusicVolume = Config.MusicVolume
			SoundVolume = Config.SFXVolume
			Language = Config.Lang.CurrentLang
			Controls = Config.CommandKeys
			FancyGraphics = Config.FancyGraphics

			// Inventory
			/*
			KeyItems = Config.KeyItems
			Inventory = Config.Inventory
			Equipped = Config.Equipped
			*/

			SaveSlot = Config.SaveSlot
			IsNewGame = FALSE

		Load()
			if (IsNewGame)
				return
			// Load from save

			// Set Options
			Config.Lang.LoadLanguageFile(Language)

			Config.MusicVolume = MusicVolume
			Config.SFXVolume = SoundVolume
			Config.CommandKeys = Controls
			Config.FancyGraphics = FancyGraphics

			// Load player state
			Config.EventFlags = EventFlags

			/*

			Config.KeyItems = KeyItems
			Config.Inventory = Inventory
			Config.Equipped = Equipped

			*/

			// Load Map

			Config.MapLoader.LoadMap(CurrentMap)

			/*

			Config.MapLoader.LoadChunks(LoadedChunks)

			*/

			// Set position
			var/client/C = Config.Clients[1]
			var/mob/M = C.mob
			M.WarpTo(Location)

		Save()
			if (!SaveSlot)
				return

			var/savefile/Save = new/savefile("SAVE[SaveSlot]")
			Save << src
			del Save