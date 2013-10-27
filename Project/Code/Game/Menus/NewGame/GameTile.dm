/obj/Runtime/GameTile
	icon = 'GameTile.dmi'
	icon_state = "Tile"
	layer = UILayer

	New()
		overlays += Config.Text.Create("Menu.NewGame", FontFace = /Font/LaconicShadow48, PixelX = 16, PixelY = 48)

	proc
		ShowSavegame(var/Savegame/Savegame)
			// Make the tile show a savegame's status instead of 'New Game'
			overlays = null
			overlays += Config.Text.Create("Menu.Game[Savegame.SaveSlot]", FontFace = /Font/LaconicShadow48, PixelX = 16, PixelY = 48)

			// Draw progress overlays, health bar, etc

		Reset()
			overlays = null
			overlays += Config.Text.Create("Menu.NewGame", FontFace = /Font/LaconicShadow48, PixelX = 16, PixelY = 48)