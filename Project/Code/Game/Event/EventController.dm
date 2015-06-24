/EventController
	var/savefile/Scripts
	var/list/CachedScripts
	var/list/CacheTimestamps
	var/Parser/Parser

// Sets the fader to a specific colour and alpha.  Useful for tints, etc
/EventController/proc/SetFade(var/Color = ColorBlack, var/Alpha = AlphaOpaque)
	for(var/mob/M in world)
		if (M.client)
			M.client.Flash.Set(Color, Alpha)

// Fade in the screen.  By default, fades from black to clear in 0.8 seconds
/EventController/proc/FadeIn(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = AlphaTransparent)
	for(var/mob/M in world)
		if (M.client)
			M.client.Flash.FadeIn(Color, Time, FinalAlpha)
	sleep(Time + 1)

// Fade out the screen.  By default, fades to black over 0.8 seconds
/EventController/proc/FadeOut(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = AlphaOpaque)
	for(var/mob/M in world)
		if (M.client)
			spawn
				M.client.Flash.FadeOut(Color, Time, FinalAlpha)
	sleep(Time + 1)

// Initializes the event controller, script parser, etc
/EventController/proc/Init()
	Scripts = new("SDATA")
	Scripts[".index"] >> CachedScripts
	if (!CachedScripts)
		CachedScripts = list( )
	Scripts[".stamp"] >> CacheTimestamps
	if (!CacheTimestamps)
		CacheTimestamps = list( )

	Parser = new()
	Parser.Functions = ScriptFunctions
	Parser.Constants = ScriptConstants

// Queues up dialog for the player.  IF the player does not already have a dialogue "menu" open, one will be opened for them
/EventController/proc/Dialogue(var/mob/Player, var/QueuedDialogue/Text, var/Name, var/Params)
	if (istype(Player, /QueuedDialogue))
		Text = Player
		Player = Text.Player

	var/QueuedDialogue/QD

	if (Text == "")
		return

	if (istype(Text))
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

// Cache a named script file from disk
/EventController/proc/Cache(var/ScriptName, var/ScriptFilename, var/Timestamp = 0)

	DebugText("Caching [ScriptFilename] to [ScriptName]")
	var/StreamReader/Reader = new(ScriptFilename)

	Scripts[ScriptName] << Reader.TextFile

	CachedScripts |= ScriptName
	CacheTimestamps[ScriptName] = Timestamp
	Scripts[".index"] << CachedScripts
	Scripts[".stamp"] << CacheTimestamps
	del Reader

// Retrieves a script from cache.  If the dev tools are installed, will cache first from disk
// Otherwise if no results are available, the Script Name will be returned verbatim.
/EventController/proc/GetScript(var/ScriptName)
	if (Config.IsDevMode)
		var/FileInfo/Info = new("Scripts/[ScriptName].txt")
		if (Info.LastWriteTimestamp > CacheTimestamps[ScriptName])
			Cache(ScriptName, "Scripts/[ScriptName].txt", Info.LastWriteTimestamp)

	if (ScriptName in CachedScripts)
		Scripts[ScriptName] >> .
	else
		. = ScriptName

// Runs a script 'detached' and returns to the caller
/EventController/proc/RunScriptDetached(var/ScriptName, var/mob/Player = null)
	spawn
		RunScript(ScriptName, Player)

// Runs a script and does not return to the caller until it completes
/EventController/proc/RunScript(var/ScriptName, var/mob/Player = null)
	var/ASTNode/Node = Parser.ParseScript(GetScript(ScriptName))
	if (Node)
		Node.Context = new /ScriptExecutionContext()
		Node.Execute()

// Fades out the map, loads a new map (if it exists), and then moves the player to
// a named entrance tag before fading in
/EventController/proc/TakeExit(var/MapName, var/EntranceTag, var/mob/Player)
	spawn
		FadeOut()
		if (lentext(MapName))
			if (fexists("Project/Maps/[MapName]"))
				Config.MapLoader.LoadRawMap("Project/Maps/[MapName]")
			else if (fexists("Project/Maps/[MapName].dmm"))
				Config.MapLoader.LoadRawMap("Project/Maps/[MapName].dmm")
			else
				Config.MapLoader.LoadMap(MapName)

		if (lentext(EntranceTag))
			var/T = locate(EntranceTag)
			if (T)
				if (!T:loc)
					ErrorText("Entrance [EntranceTag] has null loc!")

				Player.Move(T:loc)
				Config.Cameras.Warp(Player)
			else
				ErrorText("Unable to find entrance [EntranceTag]!")

		FadeIn()