/obj/Runtime/HUD/HUDObject/InventorySlot
	icon_state = "InvSlot"
	icon = 'HUD.dmi'
	name = "Open Slot"

	var
		obj/Item/SlotItem = null
		Quantity = 1


/obj/Runtime/HUD/HUDObject/InventorySlot/proc/SetSelected(var/Selected)
	if (Selected)
		icon_state = "InvSlotS"
	else
		icon_state = "InvSlot"

/obj/Runtime/HUD/HUDObject/InventorySlot/proc/SetContents(var/obj/Item/NewItem, var/NewQuantity = 1)
	SlotItem = NewItem
	if (SlotItem)
		name = SlotItem.name
	else
		name = "Open Slot"

	Quantity = NewQuantity
	Redraw()
	return

/obj/Runtime/HUD/HUDObject/InventorySlot/proc/SetQuantity(var/NewQuantity = 1)
	Quantity = NewQuantity
	Redraw()
	return

/obj/Runtime/HUD/HUDObject/InventorySlot/proc/Redraw()
	overlays = null
	if (SlotItem)
		overlays += SlotItem
	if (Quantity != 1 || TRUE)
		var/obj/Runtime/Letter = new()
		Letter.icon_state = "[Quantity + 48]"
		Letter.pixel_y = 4
		Letter.pixel_x = 26
		overlays += Quantity
	return