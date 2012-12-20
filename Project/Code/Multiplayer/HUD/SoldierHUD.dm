//HUD used when playing as a Soldier.

/obj/Runtime/HUD/HUDController/SoldierHUD
	var/HUDComponents[] = list()
	var/obj/Runtime/HUD/HUDObject/InventorySlot/Selected

/obj/Runtime/HUD/HUDController/SoldierHUD/Initialize()
	for(var/obj/Runtime/HUD/HUDObject/InventorySlot/A in HUDComponents)
		Client.screen -= A
		A.SetMaster(null)

	Selected = null

	HUDComponents = list()

	for (var/X = 1, X <= Client.mob.inventory.len, X++)
		var/obj/Runtime/HUD/HUDObject/InventorySlot/Slot = new()

		Slot.SetMaster(src)
		Slot.screen_loc = "[X + 3],0"
		Slot.SlotIndex = X
		HUDComponents += Slot
		Client.screen += Slot

	Update()


/obj/Runtime/HUD/HUDController/SoldierHUD/Update()
	for(var/obj/Runtime/HUD/HUDObject/InventorySlot/Slot in HUDComponents)
		Slot.SetContents(Client.mob.inventory[Slot.SlotIndex])
	SelectSlot(Client.mob.GetActiveSlot())

/obj/Runtime/HUD/HUDController/SoldierHUD/proc/SelectSlot(var/Index)
	if (Selected)
		Selected.SetSelected(FALSE)

	Selected = HUDComponents[Index]
	Selected.SetSelected(TRUE)
	Client.mob.SetActiveSlot(Selected.SlotIndex)

/obj/Runtime/HUD/HUDController/SoldierHUD/LeftClick(var/obj/Runtime/HUD/HUDObject/HO, var/datum/Mouse/Mouse)
	if (istype(HO, /obj/Runtime/HUD/HUDObject/InventorySlot))
		SelectSlot(HO:SlotIndex)
