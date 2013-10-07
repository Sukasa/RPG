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
			spawn
				M.client.Flash.FadeIn(Color, Time, FinalAlpha)
	sleep(Time)

/EventController/proc/FadeOut(var/Color = ColorBlack, var/Time = 8, var/FinalAlpha = 255)
	for(var/mob/M in world)
		if (M.client)
			spawn
				M.client.Flash.FadeOut(Color, Time, FinalAlpha)
	sleep(Time)

/EventController/proc/Event(var/ScriptName, var/TriggeringEntity)

/EventController/proc/Init()
	Scripts = new("SDATA")
	Scripts[".index"] >> CachedScripts
	if (!CachedScripts)
		CachedScripts = list( )

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

/EventController/proc/RunScript(var/ScriptName)
	Config.Commands.Execute(null, "run", ScriptName)