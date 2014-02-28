/turf/Basic
	Grass
		name = "Grass"
		icon = 'Grass.dmi'
		icon_state = "Grass0"

	Dirt
		name = "Dirt"
		icon = 'Dirt.dmi'
		icon_state = "Dirt0"


	DarkGrass
		MatchTypes = list( /turf/Decorative/DarkGrass )
		name = "Grass"
		icon = 'BigDarkGrass.dmi'
		icon_state = "255"

	DarkDirt
		name = "Dirt"
		icon = 'BigDarkDirt.dmi'
		icon_state = "255"

	Farmland
		name = "Farmland"
		icon = 'Farmland.dmi'
		icon_state = "255"

	Obsidian
		name = "Obsidian"
		icon = 'BigObsidian.dmi'
		icon_state = "255"

	Lava
		name = "Lava"
		icon = 'LavaPool.dmi'
		icon_state = "255"

	Sand
		name = "Sand"
		icon = 'BigSand.dmi'
		icon_state = "255"

	Water
		name = "Water"
		icon = 'WaterOnGrass.dmi'
		icon_state = "255"

	Pit
		name = "Pit"
		icon = 'BigPit.dmi'
		icon_state = "255"

	ObsidianPit
		name = "Obsidian Pit"
		icon = 'ObsidianPit.dmi'
		icon_state = "255"

	Clifftop
		name = "Dirt"
		icon = 'BigCliff.dmi'

		New()
			. = ..()
			icon_state = "255"

		Low
			icon_state = "Lo"

		Med
			icon_state = "Med"

		High
			icon_state = "Hi"