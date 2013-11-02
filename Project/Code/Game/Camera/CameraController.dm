/CameraController
	// Camera controller.  Handles camera scroll, both scripted and in respect to scroll boundaries.
	var/list/AllCameras = list( )
	var/list/CinematicCameras = list( )
	var/list/Attachments = list ( ) // Mob->Camera Associations


/CameraController/proc/Init()
	AllCameras = list( )
	CinematicCameras = list( )
	Attachments = list ( )

/CameraController/proc/Tick()
	for(var/mob/M in Attachments)
		if (!Attachments[M])
			Attachments -= M
		else
			CameraTick(Attachments[M], M)

	for(var/mob/Camera/C in AllCameras)
		C.MoveTo()

/CameraController/proc/CameraTick(var/mob/Camera/C, var/mob/M)
	C.Destination = GetBestCameraDestinationCandidate(C, M)
	if (M in C.Destination)
		C.Destination = M
	else if (C.Destination)

		C.Destination = new/Point(C.Destination)

		if (C.Destination:TileX == M.x)
			C.Destination:CopyXOffset(M)
		else if (C.Destination:TileX < M.x)
			C.Destination.SetXOffset(31)

		if (C.Destination:TileY == M.y)
			C.Destination:CopyYOffset(M)
		else if (C.Destination:TileY < M.y)
			C.Destination.SetYOffset(31)

/CameraController/proc/Warp(var/mob/M)
	if (Attachments[M])
		var/mob/Camera/C = Attachments[M]
		CameraTick(C, M)
		C.WarpTo()

/CameraController/proc/Attach(var/mob/M)
	var/mob/Camera/Attached/C = new()
	Attachments[M] = C
	AllCameras += C
	C.loc = M.loc
	if (M.client)
		M.client.eye = C

/CameraController/proc/CreateCinematicCamera(var/Location, var/Name)
	var/mob/Camera/C = new(Location)
	if (Name)
		CinematicCameras[Name] = C
	AllCameras += C
	return C

/CameraController/proc/CameraCross(var/mob/M)
	. = list( )
	for (var/Dir in Cardinal)
		var/list/Turfs = GetSteps(M, Dir, world.view)
		var/X
		for(X = 1, X <= min(world.view + 1, Turfs.len), X++)
			var/turf/T = Turfs[X]
			if (!T.CameraDensity)
				break
		if (X <= Turfs.len)
			. |= Turfs[X]

/CameraController/proc/GetBestCameraDestinationCandidate(var/mob/Camera/C, var/mob/M)
	var/list/Turfs = CameraCross(M)
	var/Dist = Infinity
	for(var/turf/T in Turfs)
		if (Dist > C.GetDistanceTo(T))
			Dist = C.GetDistanceTo(T)
			. = T