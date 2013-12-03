/ChatCommand/Run
	Command = "run"
	MinPowerLevel = RankProgrammer

/ChatCommand/Run/Execute(var/mob/Player, var/CommandText, var/datum/ScriptExecutionContext/Context)
	// Get script

	CommandText = Parse(CommandText)

	var/StreamReader/Reader = new(Config.Events.GetScript(CommandText) || CommandText)

	if (Reader.EOF())
		ErrorText("NULL SCRIPT!")
		return

	Reader.StripCarriageReturns()

	if (isnull(Context))
		Context = new()

	// Loop through each line, executing it as you go
	while (!Reader.EOF())
		var/ScriptCommand = Reader.TakeUntil(Space, LineFeed)
		if (!lentext(ScriptCommand))
			Reader.Advance()
			continue
		if (Reader.EOF() || Reader.Char() == LineFeed)
			Config.Commands.Execute(Player, ScriptCommand)
		else
			Reader.Advance()
			var/ScriptCommandText = Reader.TakeUntil(LineFeed)
			Config.Commands.Execute(Player, ScriptCommand, ScriptCommandText, Context)
		Reader.Advance()



/ChatCommand/Spawn	// Kind of like Run, but forces a new script execution context
	Command = "spawn"
	MinPowerLevel = RankProgrammer

/ChatCommand/Spawn/Execute(var/mob/Player, var/CommandText, var/datum/ScriptExecutionContext/Context)
	spawn
		Config.Commands.Execute(Player, "run", Parse(CommandText))


/ChatCommand/RunAs
	Command = "as"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/RunAs/Execute(var/mob/Player, var/CommandText, var/datum/ScriptExecutionContext/Context)
	var/Space = findtext(CommandText, " ")
	var/RunAs = Config.Clients[Parse(copytext(CommandText, 1, Space))]
	RunAs = RunAs:mob
	var/LSpace = Space
	Space = findtext(CommandText, " ", Space + 1)
	var/Command = Parse(copytext(CommandText, LSpace + 1, Space))

	Config.Commands.Execute(RunAs, Command, copytext(CommandText, Space + 1), Context)