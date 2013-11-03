/obj/Interactive
	var/InteractScript = ""
	var/InteractText = ""
	var/InteractName = ""

	proc
		InteractWith(var/mob/Player)
			if (InteractScript)
				// Execute Script
				Config.Events.RunScript(InteractScript, Player)
			else if (InteractText)
				// Interact
				Config.Events.Dialogue(Player, InteractText, InteractName)