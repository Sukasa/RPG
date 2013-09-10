mob
	var
		datum/Point/Destination = null
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

/mob/New()
	..()
	hud_flash = new /obj/Runtime/flash()
	SetCursor(CursorRed)

/mob/proc/GetCoverPenalty()
	return 0

/mob/proc/Interact(var/datum/Mouse/Mouse, var/ForceAttack)
	return

/mob/proc/SetMoveTarget(var/datum/Mouse/Mouse)
	Destination = Mouse.Pos.Clone()
	//TODO Movement cursor?
	return

/mob/proc/MoveTo(var/datum/Point/Target = Destination)
	Destination = Target
	if (!Target)
		return
	var/Angle = GetAngleTo(Destination)
	var/MoveSpeed = min(MoveSpeed(), GetDistanceTo(Destination) * 32)

	var/NewStepX = (MoveSpeed * sin(Angle)) + step_x
	var/NewStepY = (MoveSpeed * cos(Angle)) + step_y

	var/OffsetX = 0
	var/OffsetY = 0

	if (NewStepX < 0)
		NewStepX += 32
		OffsetX--
	else if (NewStepX >= 32)
		NewStepX -= 32
		OffsetX++

	if (NewStepY < 0)
		NewStepY += 32
		OffsetY--
	else if (NewStepY >= 32)
		NewStepY -= 32
		OffsetY++

	NewStepY += SubStepY
	NewStepX += SubStepX

	SubStepX = NewStepX % 1
	SubStepY = NewStepY % 1

	//TODO rework this so that if you're trying to hit a wall diagonally, you don't suddenly move at a slower pace.
	SmoothMove = 2
	Move(locate(x + OffsetX, y, z), 0, round(NewStepX), step_y)
	Move(locate(x, y + OffsetY, z), 0, step_x, round(NewStepY))

	if (GetDistanceTo(Destination) <= (1 / 32))
		Destination = null

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
	var/Locs = Config.SpawnZones[Team]
	var/atom/movable/SpawnSpot = pick(Locs)
	Move(locate(SpawnSpot.x + rand(0, 9), SpawnSpot.y + rand(0, 6), SpawnSpot.z))
	Destination = null
	stunned = initial(stunned)
	sight = initial(sight)
	SubStepX = 0
	SubStepY = 0
	Ticker.Mode.OnPlayerSpawn(src)
	//if (client)
		//client.edge_limit = "SOUTHWEST to NORTHEAST"
