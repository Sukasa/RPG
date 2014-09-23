/Menu/GameMenu
	var
		const
			GameALocation = "WEST + 3, NORTH - 10"
			GameBLocation = "WEST + 3, NORTH - 13"
			GameCLocation = "WEST + 3, NORTH - 16"
			EraseLocation = "WEST + 3:16, NORTH - 18:16"

		list/GameLocations = list(GameALocation, GameBLocation, GameCLocation)
		list/CursorLocations = list( "WEST+2:12, NORTH-9:8", "WEST+2:12, NORTH-12:8", "WEST+2:12, NORTH-15:8", "WEST+2:28, NORTH-18:24" )

		list/Saves[3]
		CursorPos = 0
		EraseMode = FALSE

		obj/Runtime/GameTile/GT
		obj/EraseText
		obj/Runtime/DialogueAdvance/DA

	Init()
		var/Savegame/Save
		// Create tiles
		for(var/X = 1, X <= 3, X++)
			GT = new()
			GT.screen_loc = GameLocations[X]
			StaticElements += GT
			if (fexists("SAVE[X]"))
				var/savefile/SF = new("SAVE[X]")
				SF >> Save
				GT.ShowSavegame(Save)
				Saves[X] = Save
		// Draw Erase text
		EraseText = Config.Text.Create("Menu.Erase", FontFace = /Font/LaconicShadow48, Color = ColorRed)
		EraseText.screen_loc = EraseLocation
		DynamicElements += EraseText
		// Draw cursor
		DA = new()
		DynamicElements += DA
		Highlight()
		..()

	Input(var/ControlCode)
		if (ControlCode == ControlDown)
			CursorPos++
			CursorPos = (CursorPos + 4) % 4
			Highlight()
		else if (ControlCode == ControlUp)
			CursorPos--
			CursorPos = (CursorPos + 4) % 4
			Highlight()
		else if (ControlCode == ControlEnter)
			if (CursorPos == 3)
				EraseMode = !EraseMode
				EraseText()
			else
				if (EraseMode)
					Saves[CursorPos + 1] = null
					fdel("SAVE[CursorPos+1]")
					GT.Reset()
					EraseMode = FALSE
					EraseText()
				else
					Config.Audio.SetBGM(null, TRUE, 75)
					// Load a save or start a new game
					Config.SaveSlot = CursorPos + 1
					if (Saves[CursorPos + 1])
						var/Savegame/S = Saves[CursorPos + 1]
						Config.Events.FadeOut()
						FadeOut()
						Ticker.ChangeGameMode(/datum/GameMode)
						sleep(1)
						S.Load()
					else
						// New Game
						Config.Events.FadeOut()
						FadeOut()
						Ticker.ChangeGameMode(/datum/GameMode)
						Config.Events.RunScriptDetached("NewGame", Player)
					ExitMenu()

	proc
		EraseText()
			DynamicElements -= EraseText
			del EraseText
			EraseText = Config.Text.Create(EraseMode ? "Menu.CancelErase" : "Menu.Erase", FontFace = /Font/LaconicShadow48, Color = ColorRed)
			EraseText.screen_loc = EraseLocation
			Client.screen += EraseText
			DynamicElements += EraseText

		Highlight()
			DA.screen_loc = CursorLocations[CursorPos + 1]
			if (GT)
				GT.icon_state = "Tile"
			if (CursorPos < 3)
				GT = StaticElements[CursorPos + 1]
				GT.icon_state = "Selected"