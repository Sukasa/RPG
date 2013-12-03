/obj/Interactive/Trunk
	icon = 'Chests.dmi'
	name = "Trunk"
	icon_state = "Trunk"
	density = TRUE

	var/OpenedScript = ""
	var/OpenedText = ""
	var/OpenedName = ""
	var/IsOpened = FALSE

	Init()
		if ("[Config.CurrentMapName][x][y]" in Config.EventFlags)
			Opened()

	proc
		Opened()
			icon_state = "Open[initial(icon_state)]"
			Config.EventFlags |= "[Config.CurrentMapName][x][y]"
			IsOpened = TRUE

	InteractWith(var/mob/Player)
		if (!IsOpened)
			Opened()
			..()
		else if (InteractScript)
			Config.Events.RunScript(OpenedScript, Player)
		else if (OpenedText)
			Config.Events.Dialogue(Player, OpenedText, OpenedName)

	Chest
		name = "Chest"
		icon_state = "Chest"

		var/Locked = TRUE
		var/UnlockKey = ""

		var/LockedScript = ""
		var/LockedText = ""
		var/LockedName = ""

		InteractWith(var/mob/Player)
			if (Locked)
				if (InteractScript)
					Config.Events.RunScript(LockedScript, Player)
				else if (LockedText)
					Config.Events.Dialogue(Player, LockedText, LockedName)
			else
				..()