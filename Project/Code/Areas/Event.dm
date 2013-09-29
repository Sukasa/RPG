/area/Event
	icon_state = "Orange"
	var/Triggered = list( )

	OnEntered(var/turf/Turf, var/mob/Entree)
		if (Turf in Triggered || !Entree.client)
			return
		var/list/Turfs = list(Turf)
		var/list/Events = list( )
		for(var/X = 1, X <= Turfs.len, X++)
			var/turf/T = Turfs[X]
			if (T && T.loc == src)
				Turfs |= T.Neighbors()
				Events |= locate(/obj/MapMarker/Event) in T
		for(var/obj/MapMarker/Event/E in Events)
			if (!E.PreconditionMet())
				return
		Triggered |= Turfs
		for(var/obj/MapMarker/Event/E in Events)
			E.Execute(Entree)