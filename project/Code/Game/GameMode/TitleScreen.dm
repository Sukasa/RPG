/datum/GameMode/TitleScreen
	Name = "Title Screen"
	ModeKey = "TS"

	var/mob/Camera/Camera

/datum/GameMode/TitleScreen/Tick()
	if (Camera && Camera.PanComplete())
		Camera.PanTo(locate(rand(10, world.maxx - 10), rand(10, world.maxy - 10), 1))
	return

/datum/GameMode/TitleScreen/Start()
	Config.MapLoader.LoadMap("Title")
	SetMobLayerEnabled(TRUE)
	Camera = Config.Cameras.CreateCinematicCamera(get_turf(locate(10, world.maxy - 10, 1)))
	Camera.PanSpeed = 2.5
	Camera.PanTo(locate(world.maxx - 10, 10, 1))
	for(var/mob/M in world)
		if (M.client)
			Camera.SetActiveFor(M)
	Config.Events.FadeIn()
	Config.Commands.Execute(null, "as", "1 showmenu /Menu/TitleScreen")

/datum/GameMode/TitleScreen/End()
	return

/datum/GameMode/TitleScreen/ShowHUD()
	return FALSE