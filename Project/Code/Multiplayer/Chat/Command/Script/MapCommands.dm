/ChatCommand/LoadRaw
	Command = "loadraw"
	MinPowerLevel = RankPlayer

/ChatCommand/LoadRaw/Execute(var/mob/Player, var/CommandText)
	Ticker.Suspend()
	if (!findtext(CommandText, ".dmm", -5))
		CommandText = "[CommandText].dmm"
	if (fexists("Project/Maps/[CommandText]"))
		var/S = Config.MapLoader.LoadRawMap("Project/Maps/[CommandText]")
		sleep(S) // I don't know why I need this, but w/o the fade-in doesn't work.
	else
		ErrorText("Cannot load file Project/Maps/[CommandText]!")
	Ticker.Start()

/ChatCommand/LoadMap
	Command = "loadmap"
	MinPowerLevel = RankPlayer

/ChatCommand/LoadMap/Execute(var/mob/Player, var/CommandText)
	Ticker.Suspend()
	var/S = Config.MapLoader.LoadMap(CommandText)
	sleep(S) // I don't know why I need this, but w/o the fade-in doesn't work.
	Ticker.Start()

/ChatCommand/ParseMap
	Command = "parsemap"
	MinPowerLevel = RankPlayer

/ChatCommand/ParseMap/Execute(var/mob/Player, var/CommandText)
	var/Filename = copytext(CommandText, 1, findtext(CommandText, " "))
	var/MapID = copytext(CommandText, findtext(CommandText, " ") + 1)
	if (!findtext(Filename, ".dmm", -5))
		Filename = "[Filename].dmm"
	if (fexists("Project/Maps/[Filename]"))
		Config.MapLoader.ImportMap("Project/Maps/[Filename]", MapID)
		Config.MapLoader.LoadImportedMap(MapID)
		Config.MapLoader.ParseMap()
		Config.MapLoader.SaveMap(MapID)
	else
		ErrorText("Cannot load file Project/Maps/[Filename]!")