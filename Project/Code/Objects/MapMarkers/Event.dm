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
			return !("[Config.CurrentMapName][x][y]" in Config.EventFlags)

		Execute(var/mob/Player)
			Config.EventFlags |= "[Config.CurrentMapName][x][y]"

	Disable
		icon_state = "Disable"

		PreconditionMet()
			return FALSE

	Persist
		icon_state = "Persist"

		Execute()
			return TRUE

	Dialogue
		icon_state = "Interact"
		var/DialogueText = ""
		var/DialogueName = ""
		Execute(var/mob/Player)
			Config.Events.Dialogue(Player, DialogueText, DialogueName)

	Exit
		icon_state = "Exit"
		var/MapName = ""
		var/EntranceTag = ""

		Execute(var/mob/Player)
			Config.Events.TakeExit(MapName, EntranceTag, Player)