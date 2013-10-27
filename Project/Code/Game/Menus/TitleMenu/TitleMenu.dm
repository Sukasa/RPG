/Menu/TitleScreen
	var
		EnterEnabled = FALSE
		obj/Runtime/TitleGraphic/TG
		obj/Text

/Menu/TitleScreen/Init()

	// Create title graphic
	TG = new()
	PersistentElements += TG


	// Create 'press start' text
	Text = Config.Text.Create("Title.PressEnter", FontFace = /Font/LaconicShadow48, Width = 608, Align = AlignCenter)
	Text.screen_loc = "1,CENTER-3"
	Text.alpha = 0
	StaticElements += Text

	..()

	spawn
		animate(TG, alpha = 255, time = 30)
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
		animate(TG, pixel_y = 64, time = 14, easing = SINE_EASING)
		animate(Text, alpha = 0, time = 6)
		spawn(14)
			sleep(0.3)
			TG.pixel_y = 0
			TG.screen_loc = "3, 12"
		spawn(15)
			var/Menu/M = Config.Menus.CreateMenu(Client, /Menu/GameMenu)
			Config.Menus.SwapMenu(Client, M)
		Config.Events.FadeOut(Time = 13, FinalAlpha = 128)