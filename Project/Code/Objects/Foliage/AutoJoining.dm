/obj/Autojoin
	icon_state = "0"
	Init()
		. = ..()
		AutoJoin()

	LightBush
		name = "Bush"
		icon = 'BigLightBush.dmi'

	LavaPool
		MatchTypes = list( /turf/Basic/Lava )
		name = "Lava Pool"
		icon = 'LavaPool.dmi'
		density = TRUE

	DarkGrass
		MatchTypes = list( /turf/Basic/DarkGrass, /turf/Decorative/DarkGrass )
		name = "Dark Grass"
		icon = 'BigDarkGrass.dmi'

	Water
		MatchTypes = list( /turf/Basic/Water )
		name = "Water"
		icon = 'WaterOnGrass.dmi'
		density = TRUE

	CavePool
		MatchTypes = list( /turf/Basic/Water )
		name = "Pool"
		icon = 'BigWater.dmi'
		density = TRUE

	DirtPit
		MatchTypes = list( /turf/Basic/Pit )
		name = "Pit"
		icon = 'BigPit.dmi'
		density = TRUE

	ObsidianPit
		MatchTypes = list( /turf/Basic/ObsidianPit )
		name = "Obsidian Pit"
		icon = 'ObsidianPit.dmi'
		density = TRUE

	Dirt
		MatchTypes = list( /turf/Basic/Dirt, /turf/Basic/Clifftop )
		name = "Dirt"
		icon = 'BigDirt.dmi'

	Sand
		MatchTypes = list( /turf/Basic/Sand )
		name = "Sand"
		icon = 'BigSand.dmi'

	Farmland
		MatchTypes = list( /turf/Basic/Farmland )
		name = "Farmland"
		icon = 'Farmland.dmi'

	DarkDirt
		MatchTypes = list( /turf/Basic/DarkDirt )
		name = "Dirt"
		icon = 'BigDarkDirt.dmi'

	Obsidian
		MatchTypes = list( /turf/Basic/Obsidian )
		name = "Obsidian"
		icon = 'BigObsidian.dmi'

	Clifftop
		var/Height = 1
		icon = 'BigCliff.dmi'

		Low
			MatchTypes = list( /turf/Basic/Clifftop/Low )
			layer = 5
			icon_state = "Top1"

		Med
			MatchTypes = list( /turf/Basic/Clifftop/Med )
			Height = 2
			layer = 6
			icon_state = "Top2"

		High
			MatchTypes = list( /turf/Basic/Clifftop/High )
			Height = 3
			layer = 7
			icon_state = "Top3"

		Cavewall
			Height = 3
			layer = 7
			icon_state = "Editor"
			icon = 'CaveWalls.dmi'

		Init()
			. = ..()
			. += src

			var/list/L = CliffBounds[icon_state]
			if (L)
				density = TRUE
				for(var/Param in L)
					vars[Param] = L[Param]

			if (icon_state in CliffFaceStates)
				var/HeightLayer = layer - CliffFaceOffset
				for (var/X = 1, X <= Height, X++)
					var/turf/T = locate(x, y - X, z)
					if (T)
						var/obj/Runtime/CliffFace/O = new(T)
						O.icon = icon
						O.layer = (HeightLayer - X)
						O.bound_x = bound_x
						O.bound_y = bound_y
						O.bound_width = bound_width
						O.bound_height = bound_height
						if (X < Height)
							O.icon_state = "Face[icon_state]"
						else
							O.icon_state = "Base[icon_state]"
							O.bound_height = 8
							O.bound_y = 24
						. += O
		PostProcess()
			if (icon_state in TopCliffs)
				layer += 0.1
			for (var/obj/Autojoin/Clifftop/C in loc)
				if (C.layer > layer)
					if(C.icon_state == "255")
						del src
					var/list/L = BoundsOverrides[C.icon_state]
					if (L)
						for(var/Param in L)
							vars[Param] = L[Param]