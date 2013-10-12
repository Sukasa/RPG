/obj/MapMarker/Interactible
	icon_state = "Interact"

	var/ScriptName = null
	var/InteractText = null
	var/InteractName = null

	proc
		InteractWith(var/mob/Player)
			if (ScriptName)
				// Execute Script
				Config.Events.RunScript(ScriptName, Player)
			else if (InteractText)
				// Interact
				Config.Events.Dialogue(Player, InteractText, InteractName)