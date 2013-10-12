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

/EventController/proc/RunScript(var/ScriptName, var/mob/Player = null)
	Config.Commands.Execute(Player, "run", ScriptName)