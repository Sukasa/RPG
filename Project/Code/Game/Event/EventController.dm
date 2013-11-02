/EventController
	var/savefile/Scripts
	var/list/CachedScripts

/EventController/proc/Set(var/Color = ColorBlack, var/Alpha = 255)
	for(var/mob/M in world)
		if (M.client)
			M.client.Flash.Set(Color, Alpha)

/EventController/proc/FadeIn(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = 0)
	for(var/mob/M in world)
		if (M.client)
			M.client.Flash.FadeIn(Color, Time, FinalAlpha)
	sleep(Time)

/EventController/proc/FadeOut(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = 255)
	for(var/mob/M in world)
		if (M.client)
			spawn
				M.client.Flash.FadeOut(Color, Time, FinalAlpha)
	sleep(Time)

/EventController/proc/Init()
	Scripts = new("SDATA")
	Scripts[".index"] >> CachedScripts
	if (!CachedScripts)
		CachedScripts = list( )

/EventController/proc/Dialogue(var/mob/Player, var/Text, var/Name, var/Params)
	var/QueuedDialogue/QD

	if (Text == "")
		return

	if (istype(Text, /QueuedDialogue))
		QD = Text
	else
		QD = new()
		QD.Text = Text
		QD.Name = Name
		QD.Params = Params

	Player.client.QueuedDialogue.Enqueue(QD)

	if (!istype(Config.Menus.CurrentMenus[Player], /Menu/Dialogue))
		var/Menu = Config.Menus.CreateMenu(Player, /Menu/Dialogue)
		Config.Menus.PushMenu(Player, Menu)

/EventController/proc/Cache(var/ScriptName, var/ScriptFilename)

	world.log << "Caching [ScriptFilename] to [ScriptName]"
	var/StreamReader/Reader = new(ScriptFilename)

	Scripts[ScriptName] << Reader.TextFile

	CachedScripts |= ScriptName
	Scripts[".index"] << CachedScripts
	del Reader

/EventController/proc/GetScript(var/ScriptName)
	if (ScriptName in CachedScripts)
		Scripts[ScriptName] >> .
	else
		return null

/EventController/proc/RunScriptDetached(var/ScriptName, var/mob/Player = null)
	spawn
		RunScript(ScriptName, Player)

/EventController/proc/RunScript(var/ScriptName, var/mob/Player = null)
	if (IsClient(Player))
		Player = Player:mob
	Config.Commands.Execute(Player, "run", ScriptName)

/EventController/proc/TakeExit(var/MapName, var/EntranceTag, var/mob/Player)
	spawn
		Ticker.Suspend()

		FadeOut()

		sleep(1)
		var/SleepTime = 0

		if (lentext(MapName))
			if (fexists("Project/Maps/[MapName]"))
				SleepTime = Config.MapLoader.LoadRawMap("Project/Maps/[MapName]")
			else if (fexists("Project/Maps/[MapName].dmm"))
				SleepTime = Config.MapLoader.LoadRawMap("Project/Maps/[MapName].dmm")
			else
				SleepTime = Config.MapLoader.LoadMap(MapName)

		if (lentext(EntranceTag))
			var/T = locate(EntranceTag)
			if (T)
				if (!T:loc)
					ErrorText("Entrance [EntranceTag] has null loc!")

				Player.Move(T:loc)
				Config.Cameras.Warp(Player)
			else
				ErrorText("Unable to find entrance [EntranceTag]!")

		sleep(SleepTime) // I don't know why I need this, but w/o the fade-in doesn't work.
		Ticker.Start()
		FadeIn()