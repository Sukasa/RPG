//TODO we should probably refactor this code into applicable subfolders

atom
	var
		CoverValue = 0		// Worthiness of an atom as cover.  100 is full protection, 0 is no protection
		BulletDensity = 0	// Whether you can fire over/through an atom.  Doesn't affect the ability of that atom to give cover.
		CanTarget = TRUE	// Whether you can target an atom directly.  Right-clicking an object with this set to false will just fire in that general direction
		InteractRange = 0

atom/movable/proc/GetFineX()
	return (src.x * 32) + src.step_x

atom/movable/proc/GetFineY()
	return (src.y * 32) + src.step_y

atom/movable/proc/GetCover()
	var/list/CoverInfo[9]
	var/Index = 1
	for (var/Direction in Cardinal8)
		var/turf/T = get_step(src, Direction)
		CoverInfo[Index] = T.GetCoverValue()
		Index += 1
	CoverInfo[9] = CoverInfo[1] // This is used to make later calculations in the cover mechanic much simpler
	return CoverInfo

// Returns the angle to the passed atom, where 0° is due north
atom/movable/proc/GetAngleTo(var/atom/movable/To)
	var/datum/Point/P = new(src)
	return P.GetAngleTo(To)

// Returns the Distance to the passed atom
atom/proc/GetDistanceTo(var/atom/movable/To)
	var/atom/A = src
	while (!isturf(A.loc))
		A = A.loc
	var/datum/Point/P = new(A)
	return P.GetDistanceTo(To)

atom/proc/Shot(var/atom/shooter,var/item/ranged/weapon)
	return

atom/proc/SlowTick()
	return

atom/proc/FastTick()
	return

atom/proc/SendHearers(var/Text)
	for (var/mob/M in hearers())
		if (M.client)
			M.client.Send(Text)

atom/proc/SendOHearers(var/Text)
	for (var/mob/M in ohearers())
		if (M.client)
			M.client.Send(Text)

atom/movable/proc/UserInRange(var/User = usr, var/Range)
	if (isnum(User))
		Range = User
		User = usr
	Range = Range || 1.5
	return GetDistanceTo(User) <= Range