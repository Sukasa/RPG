/obj/MapMarker/Event



	proc/PreconditionMet()
		return TRUE

	proc/Execute()

	Event
		icon_state = "Script"
		var/ScriptCommand = ""

		Execute(var/mob/Player)
			if (Config.Events.GetScript(ScriptCommand) || fexists(ScriptCommand))
				Config.Commands.Execute(null, "run", ScriptCommand)
			else
				var/Space = findtext(ScriptCommand, " ")
				var/Command = copytext(ScriptCommand, 1, Space)
				Config.Commands.Execute(null, Command, copytext(ScriptCommand, Space + 1))

	OneShotPermanent
		icon_state = "OneShot"

		PreconditionMet()
			return !("[Config.CurrentMapName][x][y]" in Config.OneShots)

		Execute(var/mob/Player)
			Config.OneShots |= "[Config.CurrentMapName][x][y]"

	Disable
		icon_state = "Disable"

		PreconditionMet()
			return FALSE

	Exit
		icon_state = "Exit"
		var/MapName = ""
		var/EntranceTag = ""
		Execute(var/mob/Player)
			spawn
				Config.Events.FadeOut()
				sleep(1)
				if (lentext(MapName))
					if (fexists("Project/Maps/[MapName]"))
						Config.MapLoader.LoadRawMap("Project/Maps/[MapName]")
					else
						Config.MapLoader.LoadMap(MapName)

				if (lentext(EntranceTag))
					var/T = locate(EntranceTag)
					Player.Move(T:loc)
					Config.Cameras.Warp(Player)

				Config.Events.FadeIn()