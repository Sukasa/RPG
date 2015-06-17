/obj/Item
	var
		CanWield = FALSE		// Set to true if the player can wield this item (false means it can be stored in inventory but not wielded/used)
		Description = "An Item"	// Description of the item to be shown in the inventory screen

/obj/Item/proc/Wield(mob/Wielder)
	Mount(Wielder)