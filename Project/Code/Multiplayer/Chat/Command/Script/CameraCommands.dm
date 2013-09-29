/datum/ChatCommand/CreateCamera
	Command = "camera"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/CreateCamera/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	world.log << Params.len
	if (Params.len < 3)
		ErrorText("Not enough parameters to /camera \[[CommandText]]")
		return
	world.log << "Params: [Params[1]], [Params[2]], [Params[3]]"
	Config.Cameras.CreateCinematicCamera(locate(text2num(Params[2]), text2num(Params[3]), 1), Params[1])



/datum/ChatCommand/PanCamera
	Command = "pan"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/PanCamera/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 3)
		ErrorText("Not enough parameters to /pan \[[CommandText]]")
		return
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Params[1]]
	C.PanTo(locate(text2num(Params[2]), text2num(Params[3]), 1))



/datum/ChatCommand/PanSpeed
	Command = "panspeed"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/PanSpeed/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 2)
		ErrorText("Not enough parameters to /panspeed \[[CommandText]]")
		return
	var/mob/Camera/C = Config.Cameras.CinematicCameras[Params[1]]
	C.PanSpeed = text2num(Params[2])



/datum/ChatCommand/CamAttach
	Command = "attach"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/CamAttach/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[CommandText]
	if (C)
		for(var/mob/M in world)
			C.SetActiveFor(M)



/datum/ChatCommand/CamWait
	Command = "panwait"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/CamWait/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[CommandText]
	while (!C.PanComplete())
		sleep(1)



/datum/ChatCommand/CamDetach
	Command = "detach"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/CamDetach/Execute(var/mob/Player, var/CommandText)
	var/mob/Camera/C = Config.Cameras.CinematicCameras[CommandText]
	if (C)
		C.SetInactive()