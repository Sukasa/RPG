/obj
	layer = ObjectLayer
	var
		OverrideTurfDensity = FALSE		// Set to true to force the turf/autojoin object this object is on to match this object's density

/obj/New()
	..()

	// If the name for an item isn't explictly listed as a proper/improper noun, make it improper for the purposes of text handling
	if (!findtext(src, "\improper") && !findtext(src, "\proper"))
		name = "\improper [name]"

/obj/proc/Interact(var/mob/User)
	return FALSE // TRUE means that the item can be interacted with.  FALSE causes the item to not respond, and thus have the user's item used on it

/obj/proc/Init() // Do initialization after map load
	. = list( )

/obj/proc/PostProcess() // Handle any special logic needed for map post-processing