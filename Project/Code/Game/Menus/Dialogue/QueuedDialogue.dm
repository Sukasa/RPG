QueuedDialogue
	var/Name = null
	var/Text = null
	var/Params = null

	// Old scripting stuff.  Needs to be stripped out after tech demo.
	var/ScriptYes = null
	var/ScriptNo = null

	// New scripting stuff
	var/IsPrompt = FALSE
	var/Result = DialogueResultPending
	var/Player = null
	var/Hold = FALSE