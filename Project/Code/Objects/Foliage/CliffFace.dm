/obj/Runtime/CliffFace
	var/global/list/NonDenseStates = list("Face199", "Face247", "Face223")
	density = TRUE

	PostProcess()
		for (var/obj/Autojoin/Clifftop/C in loc)
			if (C.icon_state == "255")
				del src
			var/list/L = BoundsOverrides[C.icon_state]
			if (L)
				for(var/Param in L)
					vars[Param] = L[Param]
		if (icon_state in NonDenseStates)
			density = FALSE