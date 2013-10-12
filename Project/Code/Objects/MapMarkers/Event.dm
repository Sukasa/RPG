/obj/MapMarker/Event
	proc/PreconditionMet()
		return TRUE

	proc/Execute()
		return FALSE

	Event
		icon_state = "Script"
		var/ScriptCommand = ""

		Execute(var/mob/Player)
			if (Config.Events.GetScript(ScriptCommand) || fexists(ScriptCommand))
				Config.Commands.Execute(Player, "run", ScriptCommand)
			else
				var/Space = findtext(ScriptCommand, " ")
				var/Command = copytext(ScriptCommand, 1, Space)
				Config.Commands.Execute(Player, Command, copytext(ScriptCommand, Space + 1))

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

	Persist
		icon_state = "Persist"

		Execute()
			return TRUE

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
					if (T)
						Player.Move(T:loc)
						Config.Cameras.Warp(Player)
					else
						ErrorText("Unable to find entrance [EntranceTag]!")

				Config.Events.FadeIn()