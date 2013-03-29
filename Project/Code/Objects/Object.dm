/obj/New()
	..()
	if (!istype(src, /obj/Item))
		SetCursor(CursorYellow)
	if (!findtext(src, "\improper") && !findtext(src, "\proper"))
		name = "\improper [name]"

/obj/proc/Interact(var/mob/User)
	return FALSE // TRUE means that the item can be interacted with.  FALSE causes the item to not respond, and thus have the user's item used on it