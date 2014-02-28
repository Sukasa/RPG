mob
	var
		Point/Destination = null
		SubStepX = 0
		SubStepY = 0
		SmoothMove = 0

		MobStats/Stats = new()

		Team = TeamUnknown

		// These are OR'd with team and rank-based channel config
		BroadcastChannels = Debug ? ChannelAll : ChannelNone
		SubscribedChannels = Debug ? ChannelAll : ChannelNone

		Rank = RankUnranked

		Spectate = FALSE // Does the user wish to spectate this round?

		InteractScript = null
		list/InteractText = ""
		InteractName = null
	layer = MobLayer

/mob/New()
	..()
	if (!Config.MobLayerEnabled)
		invisibility = Invisible
	if (!IsList(InteractText))
		InteractText = Split(InteractText, ",")
		if (!InteractName)
			InteractName = name

/mob/proc/GetCoverPenalty()
	return 0

/mob/proc/Interact(var/datum/Mouse/Mouse, var/ForceAttack)
	return

/mob/proc/SetMoveTarget(var/datum/Mouse/Mouse)
	Destination = Mouse.Pos.Clone()
	return

/mob/proc/InteractWith(var/mob/Player)
	if (InteractScript)
		// Execute Script
		Config.Events.RunScript(InteractScript, Player)
	else
		// Interact
		Config.Events.Dialogue(Player, pick(InteractText), InteractName)

/mob/proc/Use()
	var/Point/P = new(src)
	P.Center(src)
	P.Polar(DirectionAngles[dir + 1], 24)

	var/turf/T = locate(P.TileX, P.TileY, z)

	var/obj/MapMarker/Interactible/A = locate() in T
	var/obj/Interactive/B = locate() in T

	if (A)
		A.InteractWith(src)
	else if (B)
		B.InteractWith(src)
	else
		for(var/mob/M in T)
			if (M != src && P.Intersects(M))
				return


/mob/proc/WarpTo(var/Point/Target = Destination)
	if (!istype(Target, /Point))
		Target = new/Point(Target)
	step_y = Target.FineY - (bound_height / 2) - bound_y
	step_x = Target.FineX - (bound_width / 2) - bound_x
	Move(locate(Target.TileX, Target.TileY, z))

/mob/proc/MoveTo(var/datum/Target = Destination)
	Destination = Target
	if (!Target)
		return

	var/Angle = GetAngleTo(Destination)
	var/MoveSpeed = min(MoveSpeed(), GetDistanceTo(Destination) * world.icon_size)

	var/NewStepX = (MoveSpeed * sin(Angle)) + step_x + SubStepX
	var/NewStepY = (MoveSpeed * cos(Angle)) + step_y + SubStepY

	var/OffsetX = 0
	var/OffsetY = 0

	if (NewStepX < 0)
		NewStepX += world.icon_size
		OffsetX--
	else if (NewStepX >= world.icon_size)
		NewStepX -= world.icon_size
		OffsetX++

	if (NewStepY < 0)
		NewStepY += world.icon_size
		OffsetY--
	else if (NewStepY >= world.icon_size)
		NewStepY -= world.icon_size
		OffsetY++

	SubStepX = NewStepX % 1
	SubStepY = NewStepY % 1

	if (GetDistanceTo(Destination) <= 1 / world.icon_size)
		if (IsMovable(Destination))
			Move(Destination:loc, 0, Destination:step_x, Destination:step_y)
		Destination = null
	else
		SmoothMove = 2
		Move(locate(x + OffsetX, y, z), 0, round(NewStepX), step_y)
		Move(locate(x, y + OffsetY, z), 0, step_x, round(NewStepY))

/mob/Move()
	..()
	if (SmoothMove)
		SmoothMove--
	else
		Destination = null

/mob/proc/MoveSpeed()
	. = Stats.MovementSpeed
	if (client && client.Keys["Shift"] && Stats.Stamina)
		. += Stats.MovementSpeed


/mob/proc/Respawn()
	if (Rank == RankUnranked)
		Rank = Config.Ranks[ckey] || (client ? Config.Ranks[client.address] : null) || RankPlayer
	if (Rank == RankBanned)
		Team = TeamSpectators
		Config.Teams[TeamSpectators] += src
	else if (Team == TeamUnknown)
		Team = Ticker.Mode.GetAssignedTeam(src)
	var/list/Locs = Config.SpawnZones[Team]
	var/atom/movable/SpawnSpot = locate(1, 1, 1)
	if (Locs.len)
		SpawnSpot = pick(Locs)
	Move(locate(SpawnSpot.x + rand(0, 9), SpawnSpot.y + rand(0, 6), SpawnSpot.z))
	Destination = null
	sight = initial(sight)
	SubStepX = 0
	SubStepY = 0
	Ticker.Mode.OnPlayerSpawn(src)
	if (client)
		Config.Cameras.Attach(src)
		if (client.HUD)
			if(!client.HUD.Initialized)
				client.HUD.Initialize()
			else
				client.HUD.Update()

/mob/FastTick()
	..()
	if (client && client.HUD)
		client.HUD.Tick()