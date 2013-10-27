mob
	var
		Point/Destination = null
		SubStepX = 0
		SubStepY = 0
		SmoothMove = 0

		Team = TeamUnknown

		// These are OR'd with team and rank-based channel config
		BroadcastChannels = Debug ? ChannelAll : ChannelNone
		SubscribedChannels = Debug ? ChannelAll : ChannelNone

		list/Inventory[9]
		inv_selected = 1
		stunned = 0

		obj/Runtime/flash/hud_flash
		Rank = RankUnranked

		list/Damage[7]

		Spectate = FALSE // Does the user wish to spectate this round?

		InteractScript = null
		list/InteractText = ""
		InteractName = null

/mob/New()
	..()
	hud_flash = new /obj/Runtime/flash()
	SetCursor(CursorRed)
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
	//TODO Movement cursor?
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

	var/obj/MapMarker/Interactible/A = locate(/obj/MapMarker/Interactible) in T

	if (A)
		A.InteractWith(src)
	else
		for(var/mob/M in T)
			if (M != src && P.Intersects(M))
				return


/mob/proc/WarpTo(var/datum/Point/Target = Destination)
	Destination = new/Point(Destination)
	step_y = Destination.FineY - (bound_height / 2) - bound_y
	step_x = Destination.FineX - (bound_width / 2) - bound_x
	Move(locate(Destination.TileX, Destination.TileY, z))

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
		return
	Destination = null

/mob/proc/Health()
	return 1000

/mob/proc/Accuracy()
	return 100

/mob/proc/Dead()
	return FALSE

/mob/proc/Stunned()
	return stunned

/mob/proc/Stutter()
	return FALSE

/mob/proc/Blurred()
	return FALSE

/mob/proc/SelectedItem()
	return Inventory[inv_selected]

/mob/proc/MoveSpeed()
	if(stunned)
		if(stunned <= 100)
			return 5-(stunned/30)
		else
			return 1
	else
		. = 5
		if (client && client.Keys["shift"])
			. += 5

/mob/proc/CanAttack()
	return stunned<5

/mob/proc/Stun(var/severity)
	return

/mob/proc/GrabItem(var/obj/Item/NewItem, var/InventorySlot = 0)
	if(InventorySlot > Inventory.len)
		DebugText("GrabItem Out of range: \icon [src] [src] [InventorySlot]")
		return

	if (InventorySlot == 0)
		InventorySlot = Inventory.Find(null)
		if (!InventorySlot)
			SendUser(src, "\red Your inventory is full")
			return

	if(Inventory[InventorySlot])
		Drop_Item(InventorySlot)

	SendUser(src, "You pick up \the [NewItem]")

	NewItem.loc = src
	Inventory[InventorySlot] = NewItem
	if (client && client.HUD)
		client.HUD.Update()

/mob/proc/Drop_Item(var/InventorySlot)
	if(InventorySlot > Inventory.len)
		return
	var/obj/Item/item = Inventory[InventorySlot]
	if(!item)
		return
	item.loc = src.loc
	if (client && client.HUD)
		client.HUD.Update()

/mob/proc/SetActiveSlot(var/InventoryIndex)
	inv_selected = InventoryIndex

/mob/proc/GetActiveSlot()
	return inv_selected

/mob/Login()
	..()
	client.screen += hud_flash

/mob/proc/flash_screen()
	flick('FlashWhite.dmi',hud_flash)

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
	stunned = initial(stunned)
	sight = initial(sight)
	SubStepX = 0
	SubStepY = 0
	Ticker.Mode.OnPlayerSpawn(src)
	if (client)
		Config.Cameras.Attach(src)
	//if (client)
		//client.edge_limit = "SOUTHWEST to NORTHEAST"
