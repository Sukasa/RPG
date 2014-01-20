/ChatCommand/Run
	Command = "run"
	MinPowerLevel = RankProgrammer

/ChatCommand/Run/Execute(var/mob/Player, var/CommandText)
	// Get script

	CommandText = Parse(CommandText)

	var/ScriptName = CommandText
	var/StreamReader/Reader = new(Config.Events.GetScript(ScriptName) || ScriptName)

	if (Reader.EOF())
		ErrorText("Null script error loading [ScriptName]")
		if (Context)
			Context.PrintStackTrace(Context)
		return

	Reader.StripCarriageReturns()

	if (isnull(Context))
		Context = new()
	else
		var/ScriptExecutionContext/NewContext = new()
		NewContext.Variables = Context.Variables
		NewContext.Parent = Context
		Context = NewContext
	Context.ScriptName = ScriptName

	// Loop through each line, executing it as you go
	while (!Reader.EOF())
		Context.ScriptLine++
		Reader.Skip(Space, Tab)
		var/ScriptCommand = Reader.TakeUntil(Space, LineFeed)
		if (!lentext(ScriptCommand))
			Reader.Advance()
			continue
		if (Reader.EOF() || Reader.Char() == LineFeed)
			Config.Commands.Execute(Player, ScriptCommand, "", Context)
		else
			Reader.Advance()
			var/ScriptCommandText = Reader.TakeUntil(LineFeed)
			Config.Commands.Execute(Player, ScriptCommand, ScriptCommandText, Context)
		if (Context.AbortScriptExecution)
			break
		Reader.Advance()



/ChatCommand/Spawn	// Kind of like Run, but forces a new script execution context
	Command = "spawn"
	MinPowerLevel = RankProgrammer

/ChatCommand/Spawn/Execute(var/mob/Player, var/CommandText)
	spawn
		var/ScriptExecutionContext/NewContext = new()
		NewContext.StopAbortPropagation = TRUE
		NewContext.ScriptName = "<Spawned Thread>"
		NewContext.ScriptLine = "N/A"
		NewContext.Variables = Context.Variables
		NewContext.Parent = Context
		Config.Commands.Execute(Player, "run", Parse(CommandText), NewContext)


/ChatCommand/RunAs
	Command = "as"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/RunAs/Execute(var/mob/Player, var/CommandText)
	var/Space = findtext(CommandText, " ")
	var/RunAs = Config.Clients[Parse(copytext(CommandText, 1, Space))]
	RunAs = RunAs:mob
	var/LSpace = Space
	Space = findtext(CommandText, " ", Space + 1)
	var/Command = Parse(copytext(CommandText, LSpace + 1, Space))

	Config.Commands.Execute(RunAs, Command, copytext(CommandText, Space + 1), Context)