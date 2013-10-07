/ChatCommand/CacheScript
	Command = "cachescript"

/ChatCommand/CacheScript/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	Config.Events.Cache(Params[2], Params[1])

/ChatCommand/CachedScripts
	Command = "cachedscripts"

/ChatCommand/CachedScripts/Execute(var/mob/Player, var/CommandText)
	world.log << "Cached Scripts:"
	for(var/A in Config.Events.CachedScripts)
		world.log << A

/ChatCommand/TestCache
	Command = "testcache"

/ChatCommand/TestCache/Execute(var/mob/Player, var/CommandText)
	world.log << "Cached Script [CommandText]:"
	world.log << Config.Events.GetScript(CommandText)