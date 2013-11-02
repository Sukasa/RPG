/obj/Environment/Cave
	name = "Rock"
	density = TRUE
	layer = 8

	Mushrooms
		icon = 'CaveObstacles.dmi'
		name = "Mushroom"
		Red
			icon_state = "RedShroom"

		Brown
			icon_state = "BrownShroom"

	Rocks
		SmallRocks
			icon = 'CaveObstacles.dmi'

			Med
				Single
					icon_state = "Rock"
				SingleAlt
					icon_state = "Rock2"

			Dark
				Single
					icon_state = "DarkRock"
				Stones
					icon_state = "DarkStones"

		TallRocks
			icon = 'CaveObstacles2.dmi'
			Med
				icon_state = "SpikeRock"

			Grey
				icon_state = "GreySpike"

		LargeRocks
			icon = 'CaveObstacles3.dmi'
			bound_width = 48
			bound_height = 64

			Single
				icon_state = "BigRock1"

			Alt
				icon_state = "BigRock2"

		Spikes
			icon = 'CaveObstacles.dmi'
			name = "Stalagmite"

			Dirt
				icon_state = "LightSpikes"

			DarkDirt
				icon_state = "DarkSpikes"

			Obsidian
				icon_state = "ObsidianSpikes"