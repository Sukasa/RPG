/ChatCommand/CreateCamera
	Command = "camera"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/CreateCamera/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 3)
		ErrorText("Not enough parameters to /camera \[[CommandText]]")
		if (Context)
			Context.PrintStackTrace(Context)
		return
	Config.Cameras.CreateCinematicCamera(locate(Parse(Params[2]), Parse(Params[3]), 1), Parse(Params[1]))



/ChatCommand/PanCamera
	Command = "pan"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/PanCamera/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 3)
		ErrorText("Not enough parameters to /pan \[[CommandText]]")
		if (Context)
			Context.PrintStackTrace(Context)
		return
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Parse(Params[1])]
	C.PanTo(locate(Parse(Params[2]), Parse(Params[3]), 1))



/ChatCommand/PanSpeed
	Command = "panspeed"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/PanSpeed/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 2)
		ErrorText("Not enough parameters to /panspeed \[[CommandText]]")
		if (Context)
			Context.PrintStackTrace(Context)
		return
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Parse(Params[1])]
	C.PanSpeed = text2num(Params[2])



/ChatCommand/CamAttach
	Command = "attach"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/CamAttach/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Parse(CommandText)]
	if (C)
		for(var/mob/M in world)
			C.SetActiveFor(M)



/ChatCommand/CamWait
	Command = "panwait"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/CamWait/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Parse(CommandText)]
	while (!C.PanComplete())
		sleep(1)



/ChatCommand/CamDetach
	Command = "detach"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/CamDetach/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Parse(CommandText)]
	if (C)
		C.SetInactive()