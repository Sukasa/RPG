/obj/Container
	var/Lidded = 0
	var/Open = 0

/obj/Container/Interact(var/mob/User)
	if (!Lidded)
		if (length(contents) && prob(80))
			var/obj/Item/Found = pick(contents)
			SendUser("You search \the [src] and find \a [Found]")
			User.GrabItem(Found)
		else
			SendUser("You search \the [src] but find nothing")
	else
		Open = !Open
		density = !Open
		if (Open)
			for(var/obj/Item/I in src)
				I.loc = loc
			 icon_state = "[icon_state]_o"
		else
			Absorb()
			icon_state = initial(icon_state)
	return TRUE

/obj/Container/proc/Absorb()
	for(var/obj/Item/I in loc)
		I.loc = src

/obj/Container/New()
	..()
	spawn
		Absorb()