proc/ScriptLoadMap(var/Map)
	Config.MapLoader.LoadMap(Map)

proc/ScriptLoadChunk(var/MapName, var/Location)
	Config.MapLoader.LoadMap(MapName, Location)