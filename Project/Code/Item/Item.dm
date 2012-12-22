
//An an, able to be picked up. Similar to SS13's item system, but designed to be easier to use.
/obj/Item

	name = "Generic Item"

	var/size //Size of the item. 1 = Pocket sized, 10 = Massively bulky. Probably not needed for too much.
	var/damage // Melee damage

	var/mob/owner //Person who is holding the item
	var/inventory_slot
	var/UseOnSelf = TRUE //If the item can be used on its owner

/obj/Item/proc/Owner()
	return owner

/obj/Item/proc/SetOwner(var/mob/newowner,var/slot)
	owner = newowner
	inventory_slot = slot
