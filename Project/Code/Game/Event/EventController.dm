/datum/EventController
	var/savefile/Scripts
	var/list/CachedScripts

/datum/EventController/proc/Set(var/Color = ColorBlack, var/Alpha = 255)
	for(var/mob/M in world)
		if (M.client)
			M.client.Flash.Set(Color, Alpha)

/datum/EventController/proc/FadeIn(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = 0)
	for(var/mob/M in world)
		if (M.client)
			spawn
				M.client.Flash.FadeIn(Color, Time, FinalAlpha)
	sleep(Time)

/datum/EventController/proc/FadeOut(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = 255)
	for(var/mob/M in world)
		if (M.client)
			spawn
				M.client.Flash.FadeOut(Color, Time, FinalAlpha)
	sleep(Time)

/datum/EventController/proc/Event(var/ScriptName, var/TriggeringEntity)

/datum/EventController/proc/Init()
	Scripts = new("SDATA")
	Scripts[".index"] >> CachedScripts
	if (!CachedScripts)
		CachedScripts = list( )

/datum/EventController/proc/Cache(var/ScriptName, var/ScriptFilename)
	world.log << "Caching [ScriptFilename] to [ScriptName]"
	var/datum/StreamReader/Reader = new(ScriptFilename)
	Scripts[ScriptName] << Reader.TextFile
	CachedScripts |= ScriptName
	Scripts[".index"] << CachedScripts
	del Reader

/datum/EventController/proc/GetScript(var/ScriptName)
	if (ScriptName in CachedScripts)
		Scripts[ScriptName] >> .
	else
		return null

/datum/EventController/proc/RunScript(var/ScriptName)
	Config.Commands.Execute(null, "run", ScriptName)