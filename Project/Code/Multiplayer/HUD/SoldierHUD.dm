//HUD used when playing as a Soldier.

/obj/Runtime/HUD/HUDController/SoldierHUD
	var/HUDComponents[] = list()
	var/obj/Runtime/HUD/HUDObject/InventorySlot/Selected

/obj/Runtime/HUD/HUDController/SoldierHUD/Initialize()
	for (var/X = 1, X < 7, X++)
		var/obj/Runtime/HUD/HUDObject/InventorySlot/Slot = new()

		Slot.SetMaster(src)
		Slot.screen_loc = "[X + 4],0"
		HUDComponents += Slot
		Client.screen += Slot


/obj/Runtime/HUD/HUDController/SoldierHUD/LeftClick(var/obj/Runtime/HUD/HUDObject/HO, var/datum/Mouse/Mouse)
	if (istype(HO, /obj/Runtime/HUD/HUDObject/InventorySlot))
		if (Selected)
			Selected.SetSelected(FALSE)
		Selected = HO
		Selected.SetSelected(TRUE)