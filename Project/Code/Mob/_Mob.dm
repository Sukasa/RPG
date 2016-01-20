/mob
	var

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

		FreezeTime = 0
		StunTime = 0

		obj/Item/ActiveItem = null

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

/mob/proc/PlayAnimation(var/Animation, var/InputPauseTime = 0, var/MovementPauseTime = 0)
	FreezeTime = InputPauseTime
	StunTime = FreezeTime + MovementPauseTime
	flick(Animation, src)
	return

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
		if (ActiveItem)
			ActiveItem.Use()
		else
			for(var/mob/M in T)
				if (M != src && P.Intersects(M))
					return

/mob/MoveSpeed()
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
	if (FreezeTime)
		FreezeTime--
	if (StunTime)
		StunTime--