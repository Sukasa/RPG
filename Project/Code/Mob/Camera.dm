// Basic camera entity.
/mob/Camera
	var
		PanSpeed = 1
		list/ActiveFor = list( )

	density = 0

/mob/Camera/MoveSpeed()
	return PanSpeed

/mob/Camera/proc/PanTo(var/Dest)
	Destination = Dest

/mob/Camera/proc/PanComplete()
	return !Destination

/mob/Camera/proc/SetActiveFor(var/mob/M)
	ActiveFor += M
	if (M.client)
		M.client.eye = src

/mob/Camera/proc/SetInactiveFor(var/mob/M)
	if (M.client)
		M.client.eye = Config.Cameras.Attachments[M]
	ActiveFor -= M

/mob/Camera/proc/SetInactive()
	for(var/mob/M in ActiveFor)
		if (M.client)
			M.client.eye = Config.Cameras.Attachments[M]
	ActiveFor = list( )

/mob/Camera/Attached
	PanSpeed = 32