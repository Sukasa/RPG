/obj/Autojoin
	proc
		Init()
			AutoJoin()

	LightBush
		name = "Bush"
		icon = 'BigLightBush.dmi'
		icon_state = "0"

	Clifftop
		var/Height = 1

		icon = 'BigCliff.dmi'

		Low
			layer = 4
			icon_state = "Top1"

		Med
			Height = 2
			layer = 5
			icon_state = "Top2"

		High
			Height = 3
			layer = 6
			icon_state = "Top3"

		Init()
			..()

			if (icon_state in CliffFaceStates)
				var/HeightLayer = layer - CliffFaceOffset
				for (var/X = 1, X <= Height, X++)
					var/turf/T = locate(x, y - X, z)
					if (T)
						var/obj/O = new(T)
						O.icon = icon
						O.layer = (HeightLayer - X)
						if (X < Height)
							O.icon_state = "Face[icon_state]"
						else
							O.icon_state = "Base[icon_state]"
							O.bound_height = 8
							O.bound_y = 24
						O.density = TRUE
						O.bound_width = bound_width
						O.bound_x = bound_x