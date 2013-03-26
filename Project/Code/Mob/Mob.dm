mob
	var
		datum/Point/Destination
		SubStepX
		SubStepY
		SmoothMove


		list/inventory
		inv_selected = 1
		stunned = 0

		var/obj/Runtime/flash/hud_flash


	sight = SEE_TURFS


/mob/New()
	..()
	inventory = new /list(9)
	hud_flash = new /obj/Runtime/flash()
	SetCursor('TargetRed.dmi')

/mob/proc/GetCoverPenalty()
	return 0

/mob/proc/Attack(var/datum/Mouse/Mouse, var/ForceAttack)
	return

/mob/proc/SetMoveTarget(var/datum/Mouse/Mouse)
	Destination = Mouse.Pos.Clone()
	//TODO Movement cursor
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
	if (!SmoothMove)
		return
		Destination = null
	else
		SmoothMove--

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
//	world << inventory.len
	return inventory[inv_selected]


/mob/proc/MoveSpeed()
	if(stunned)
		if(stunned <= 100)
			return 5-(stunned/30)
		else
			return 1

	else
		return 5


/mob/proc/CanAttack()
	return stunned<5

/mob/proc/Stun(var/severity)
	return


/mob/proc/Grab_Item(var/obj/Item/item,var/inventory_slot)
	if(inventory_slot > inventory.len)
		world << "Out of range"
		return
	if(inventory[inventory_slot] != null)
		Drop_Item(inventory_slot)

	item.SetOwner(src,inventory_slot)

	item.loc = src

	inventory[inventory_slot] = item

/mob/proc/Drop_Item(var/inventory_slot)
	if(inventory_slot > inventory.len)
		return

	var/obj/Item/item = inventory[inventory_slot]
	if(!item)
		return
	item.loc = src.loc

/mob/proc/SetActiveSlot(var/InventoryIndex)
	inv_selected = InventoryIndex

/mob/proc/GetActiveSlot()
	return inv_selected

/mob/Login()
	..()
	client.screen += hud_flash


/mob/proc/flash_screen()
	flick('FlashWhite.dmi',hud_flash)
