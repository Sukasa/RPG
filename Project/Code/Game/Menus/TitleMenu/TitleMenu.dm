/Menu/TitleScreen
	var
		EnterEnabled = FALSE
		obj/Runtime/TitleGraphic/TitleGraphic
		obj/Text

/Menu/TitleScreen/Init()

	// Create title graphic
	TitleGraphic = new()
	PersistentElements += TitleGraphic


	Text = Config.Text.Create("Development Copy\nThis software is not authorized for distribution", FontFace = /Font/SakkalMajalla24, Width = 608, Align = AlignCenter, MaxLines = 9)
	Text.screen_loc = "1,CENTER-5"
	Text.alpha = AlphaOpaque
	StaticElements += Text

	if (Config.IsDevMode)
		Text = Config.Text.Create("DevMode", FontFace = /Font/SakkalMajalla24, Width = 608, Align = AlignCenter, Color = ColorYellow)
		Text.screen_loc = "1,1:16"
		Text.alpha = AlphaOpaque
		StaticElements += Text


	// Create 'press start' text
	Text = Config.Text.Create("Title.PressEnter", FontFace = /Font/LaconicShadow48, Width = 608, Align = AlignCenter)
	Text.screen_loc = "1,CENTER-3"
	Text.alpha = 0
	StaticElements += Text

	..()

	spawn
		animate(TitleGraphic, alpha = 255, time = 30)
		sleep(30)
		animate(Text, alpha=255, time=20)
		sleep(15)
		EnterEnabled = TRUE
		sleep(25)
		animate(Text, alpha = 128, time = 40, loop = -1)
		animate(alpha = 192, time = 40)

/Menu/TitleScreen/Input(var/Control)
	if (EnterEnabled && Control == ControlEnter)
		EnterEnabled = FALSE
		Config.Audio.CurrentBGM.SetFade(15, 40)
		Config.Audio.CurrentBGM.FadeAsync()
		animate(Text, alpha = 0, time = 6)

		// You can't animate the pixel_* of screen objects anymore (it was a bug), so recreate the original effect here (Sinusoidal easing, etc).
		// E: ter13 suggested animate()'ing the transform property.  I should probably do that instead.
		spawn
			var/RiseTime = 20
			for(var/n = 0, n <= RiseTime, n += world.tick_lag)
				TitleGraphic.screen_loc = "3, 10:[round(-48 * (cos(180 * n / RiseTime) - 1))]"
				sleep(world.tick_lag)
			TitleGraphic.screen_loc = "3, 12"

		spawn(15)
			var/Menu/M = Config.Menus.CreateMenu(Client, /Menu/GameMenu)
			Config.Menus.SwapMenu(Client, M)
		Config.Events.FadeOut(Time = 13, FinalAlpha = 128)