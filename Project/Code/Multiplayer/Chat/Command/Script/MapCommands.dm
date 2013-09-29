/datum/ChatCommand/LoadRaw
	Command = "loadraw"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/LoadRaw/Execute(var/mob/Player, var/CommandText)
	if (!findtext(CommandText, ".dmm", -5))
		CommandText = "[CommandText].dmm"
	if (fexists("Project/Maps/[CommandText]"))
		Config.MapLoader.LoadRawMap("Project/Maps/[CommandText]")
	else
		Player.client.Send("\ref Cannot load file Project/Maps/[CommandText]!")



/datum/ChatCommand/LoadMap
	Command = "loadmap"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/LoadMap/Execute(var/mob/Player, var/CommandText)
	Config.MapLoader.LoadMap(CommandText)



/datum/ChatCommand/ParseMap
	Command = "parsemap"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/ParseMap/Execute(var/mob/Player, var/CommandText)
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
		Player.client.Send("\ref Cannot load file Project/Maps/[Filename]!")

