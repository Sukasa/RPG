/HUD
	var
		mob/AttachedMob
		list/StaticTiles = list( )
		Initialized = FALSE
		Visible = null

		list/HealthBars = list( )
		list/AmmoBars = list( )
		list/Caps = list( )
		list/HealthBarBackgrounds = list( )
		list/AmmoBarBackgrounds = list( )

	Del()
		for (var/obj/O in StaticTiles | HealthBars | AmmoBars | Caps | HealthBarBackgrounds | AmmoBarBackgrounds)
			del O
		..()

	proc
		Initialize()
			world.log << "Init HUD"

			// Create static tiles
			for (var/X = 1, X <= 3, X++)
				for (var/Y = 1, Y <= 2, Y++)
					var/obj/Runtime/HUD/StaticTile = new()
					StaticTile.icon_state = "HUD[Y][X]"
					StaticTile.screen_loc = "NORTH-[3 - Y],WEST+[X]"

					AttachedMob.client.screen += StaticTile
					StaticTiles += StaticTile

			// Create Caps
			var/obj/Runtime/HUD/HPCap/Cap = new()

			AttachedMob.client.screen += Cap
			Caps += Cap

			Cap = new/obj/Runtime/HUD/AmmoCap()
			AttachedMob.client.screen += Cap
			Caps += Cap


			// Finish Up
			Update()
			Tick()
			Initialized = TRUE

		Update()

			// Create & Place Bars
			var/BarsNeedingAdded = round(((AttachedMob.Stats.MaxHealth + 1) / 2) - HealthBars.len)

			for(var/X = 1, X <= BarsNeedingAdded, X++)
				var/obj/Runtime/HUD/HPBar/Bar = new()

				var/BarPos = HealthBars.len * 8 // 8px per bar
				Bar.screen_loc = "NORTH-1,WEST+[round(BarPos / world.icon_size) + 4]:[BarPos % world.icon_size]"

				AttachedMob.client.screen += Bar
				HealthBars += Bar

				// Add 'Empty' bar background below the bar that's just been made
				var/obj/Runtime/HUD/BarBG/BarBG = new()
				BarBG.screen_loc = Bar.screen_loc

				AttachedMob.client.screen += BarBG
				HealthBarBackgrounds += BarBG


			for (var/obj/O in AmmoBars | AmmoBarBackgrounds)
				del O

			// Place Caps
			var/obj/Cap = Caps[1] // Health Bar Cap
			var/BarSize = HealthBars.len * 8
			Cap.screen_loc = "NORTH-1,WEST+[round(BarSize / world.icon_size) + 4]:[BarSize % world.icon_size]"

			Cap = Caps[2] // Power/Ammo Bar Cap
			BarSize = 0
			Cap.screen_loc = "NORTH-2:12,WEST+[round(BarSize / world.icon_size) + 4]:[BarSize % world.icon_size]"


			//Tick to get the alphas right
			Tick()


		UpdateVisibility()
			Visible = Ticker.Mode.ShowHUD()
			for(var/obj/O in StaticTiles | HealthBars | AmmoBars | Caps | HealthBarBackgrounds | AmmoBarBackgrounds)
				O.alpha = Visible ? 255 : 0

		Tick()
			if (Visible != Ticker.Mode.ShowHUD())
				UpdateVisibility()

			if (!Visible)
				return

			// Colour bars according to stats
			for(var/X = 1, X <= HealthBars.len, X++)
				var/obj/Bar = HealthBars[X]
				if (AttachedMob.Stats.Health >= (X + HealthBars.len))
					Bar.color = ColorWhite
					Bar.alpha = 255
				else if (AttachedMob.Stats.Health >= X)
					Bar.color = ColorGrey
					Bar.alpha = 255
				else
					Bar.alpha = 0