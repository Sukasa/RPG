/obj/MapMarker/Zone
	name = "Zone"
	icon = 'Zones10x7.dmi'

	Spawn
		name = "Spawn Zone"
		var/Team = 0;
		layer = 99

		Attackers
			icon_state = "Red"
			Team = TeamAttackers

		Defenders
			icon_state = "Blue"
			Team = TeamDefenders

		Pregame
			icon_state = "Orange"
			Team = TeamPregame

		Spectator
			icon_state = "White"
			Team = TeamSpectators

		New()
			var/list/L = SpawnZones[Team]
			L += loc
			. = ..()