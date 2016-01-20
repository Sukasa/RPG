/obj/Item
	var
		CanWield = FALSE		// Set to true if the player can wield this item (false means it can be stored in inventory but not wielded/used)
		Description = ""		// Description of the item to be shown in the inventory screen
		CurrentOverlay
	New()
		..()
		if (Description == "")
			Description = "\An [name]"

/obj/Item/FastTick()
	..()
	if (Transport)
		UpdateOverlay(GetOverlay(Transport.dir, Transport.icon_state))

/obj/Item/Del()
	if (Transport)
		UnWield()
	. = ..()

// Stop wielding this item and remove it (graphically) from the wielder
/obj/Item/proc/UnWield()
	if (!Transport)
		return;

	if (ismob(Transport) && Transport:ActiveItem == src)
		Transport:ActiveItem = null

	Ticker.HighSpeedDevices -= src
	UpdateOverlay(null)
	Transport = null

// Attach this item to a mob as a wielded item
/obj/Item/proc/Wield(var/mob/Wielder)
	if (!CanWield)
		return FALSE
	Transport = Wielder

	if(ismob(Transport))
		Transport:ActiveItem = src

	Ticker.HighSpeedDevices += src

	UpdateOverlay(GetOverlay(Wielder.dir, Wielder.icon_state))

// Updates this item's overlay as displayed on the mob holding it
/obj/Item/proc/UpdateOverlay(var/NewOverlay)
	Transport.overlays -= CurrentOverlay

	CurrentOverlay = NewOverlay
	Transport.overlays += CurrentOverlay

/obj/Item/proc/GetOverlay(var/Direction, var/State)
	// Returns an image overlay to be added on to the wielding mob
	// TODO This will probably need to be heavily worked-on to handle movement/etc

/obj/Item/proc/Use()
	return
