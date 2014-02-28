proc/ScriptSpawn(var/P)
	var/Path = P
	if (!ispath(Path))
		Path = text2path(Path)
		if (!Path)
			ErrorText("Failed to spawn object of type [P]")
			return null

	. = new Path(args.Copy(2))

proc/ScriptKill(var/K)
	if (!istype(K, /atom/movable) || istype(K, world.mob))
		return // No killing the player, no killing stuff that doesn't move.
	del K

proc/ScriptIsType(var/A, var/Type)
	if(!ispath(Type))
		Type = text2path(Type)
	return istype(A, Type)