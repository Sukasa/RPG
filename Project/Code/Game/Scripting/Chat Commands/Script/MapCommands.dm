/ChatCommand/LoadRaw
	Command = "loadraw"
	MinPowerLevel = RankPlayer

/ChatCommand/LoadRaw/Execute(var/mob/Player, var/CommandText)
	Ticker.Suspend()
	if (!findtext(CommandText, ".dmm", -5))
		CommandText = "[CommandText].dmm"
	if (fexists("Project/Maps/[CommandText]"))
		Config.MapLoader.LoadRawMap("Project/Maps/[CommandText]")
	else
		ErrorText("Cannot load file Project/Maps/[CommandText]!")
		if (Context)
			Context.PrintStackTrace(Context)
	Ticker.Start()

/ChatCommand/LoadMap
	Command = "loadmap"
	MinPowerLevel = RankPlayer

/ChatCommand/LoadMap/Execute(var/mob/Player, var/CommandText)
	Config.MapLoader.LoadMap(CommandText)

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
		if (Context)
			Context.PrintStackTrace(Context)

/ChatCommand/LoadChunkAt
	Command = "loadmapchunk"

/ChatCommand/LoadChunkAt/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)

	var/list/L = Config.Locations[Parse(Params[2])]
	var/MapName = Parse(Params[1])

	if (!L)
		ErrorText("Unable to load chunk: Location [Parse(Params[2])] not found!")
		return

	if (!Config.MapLoader.IsValidMap(MapName))
		ErrorText("Unable to load chunk: Map [MapName] not cached!")
		return

	Config.MapLoader.LoadMap(MapName, locate(L[1], L[2], L[3]))