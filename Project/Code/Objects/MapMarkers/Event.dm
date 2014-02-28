/obj/MapMarker/Event
	proc/PreconditionMet()
		return TRUE

	proc/Execute()
		return FALSE

	Event
		icon_state = "Script"
		var/ScriptCommand = ""

		Execute(var/mob/Player)
			Config.Events.RunScript(ScriptCommand, Player)

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