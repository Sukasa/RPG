/mob/Camera
	// Basic camera entity.
	density = 0

	var/PanSpeed = 1
	var/list/ActiveFor = list( )

	MoveSpeed()
		return PanSpeed

	proc/PanTo(var/Dest)
		Destination = Dest

	proc/PanComplete()
		return !Destination

	proc/SetActiveFor(var/mob/M)
		ActiveFor += M
		if (M.client)
			M.client.eye = src

	proc/SetInactiveFor(var/mob/M)
		if (M.client)
			M.client.eye = Config.Cameras.Attachments[M]
		ActiveFor -= M

	proc/SetInactive()
		for(var/mob/M in ActiveFor)
			if (M.client)
				M.client.eye = Config.Cameras.Attachments[M]
		ActiveFor = list( )

	Attached
		PanSpeed = 32