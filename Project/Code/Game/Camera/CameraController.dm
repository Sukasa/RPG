/datum/CameraController
	// Camera controller.  Handles camera scroll, both scripted and in respect to scroll boundaries.
	var/list/AllCameras = list( )
	var/list/CinematicCameras = list( )
	var/list/Attachments = list ( ) // Mob->Camera Associations


/datum/CameraController/proc/Init()
	AllCameras = list( )
	CinematicCameras = list( )
	Attachments = list ( )

/datum/CameraController/proc/Tick()
	// TODO Cinematic camera ticks
	for(var/mob/M in Attachments)
		var/mob/Camera/C = Attachments[M]
		C.Destination = GetBestCameraDestinationCandidate(C, M)
		if (C.Destination == M.loc)
			C.Destination = M
		else if (C.Destination)
			C.Destination = new/datum/Point(C.Destination)

			if (C.Destination:TileX == M.x)
				C.Destination:CopyXOffset(M)
			else if (C.Destination:TileX > M.x)
				C.Destination.SetXOffset(M.bound_width / 2)
			else
				C.Destination.SetXOffset(31 + (M.bound_width / 2))

			if (C.Destination:TileY == M.y)
				C.Destination:CopyYOffset(M)
			else if (C.Destination:TileY > M.y)
				C.Destination.SetYOffset(M.bound_height / 2)
			else
				C.Destination.SetYOffset(31 + (M.bound_height / 2))


	for(var/mob/Camera/C in AllCameras)
		C.MoveTo()

/datum/CameraController/proc/Attach(var/mob/M)
	var/mob/Camera/Attached/C = new()
	Attachments[M] = C
	AllCameras += C
	C.loc = M.loc
	if (M.client)
		M.client.eye = C

/datum/CameraController/proc/CameraCross(var/mob/M)
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

/datum/CameraController/proc/GetBestCameraDestinationCandidate(var/mob/Camera/C, var/mob/M)
	var/list/Turfs = CameraCross(M)
	var/Dist = Infinity
	for(var/turf/T in Turfs)
		if (Dist > C.GetDistanceTo(T))
			Dist = C.GetDistanceTo(T)
			. = T