/area/Event
	icon_state = "Orange"
	var/global/list/Triggered = list( )

	OnEntered(var/turf/Turf, var/mob/Entree)
		if ((Turf in Triggered) || !Entree.client || Ticker.State != TickerRunning)
			return
		var/list/Turfs = list(Turf)
		var/list/Events = list( )

		for(var/X = 1, X <= Turfs.len, X++)
			var/turf/T = Turfs[X]
			if (T && T.loc == src)
				Turfs |= T.Neighbors()
				Events |= locate(/obj/MapMarker/Event) in T

		Triggered |= Turfs

		for(var/obj/MapMarker/Event/E in Events)
			if (!E.PreconditionMet())
				return
		var/Persist = FALSE

		for(var/obj/MapMarker/Event/E in Events)
			Persist |= E.Execute(Entree)

		if (Persist)
			spawn(2)
				while(TRUE)
					sleep(1)
					for(var/turf/T in Turfs)
						if(Entree in T)
							continue
					break
				Triggered -= Turfs
