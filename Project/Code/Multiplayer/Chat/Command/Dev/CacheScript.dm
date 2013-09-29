/datum/ChatCommand/CacheScript
	Command = "cachescript"

/datum/ChatCommand/CacheScript/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	Config.Events.Cache(Params[2], Params[1])

/datum/ChatCommand/CachedScripts
	Command = "cachedscripts"

/datum/ChatCommand/CachedScripts/Execute(var/mob/Player, var/CommandText)
	world.log << "Cached Scripts:"
	for(var/A in Config.Events.CachedScripts)
		world.log << A

/datum/ChatCommand/TestCache
	Command = "testcache"

/datum/ChatCommand/TestCache/Execute(var/mob/Player, var/CommandText)
	world.log << "Cached Script [CommandText]:"
	world.log << Config.Events.GetScript(CommandText)