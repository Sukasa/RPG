/CommandController
	var/list/AllCommands = list( )

/CommandController/New()
	var/Commands = typesof(/ChatCommand) - /ChatCommand
	for (var/Command in Commands)
		new Command(src)

/CommandController/proc/IsValidCommand(var/Command)
	return AllCommands[Command] != null

/CommandController/proc/Execute(var/mob/Executor, var/Command, var/CommandText = "", var/ScriptExecutionContext/Context)
	var/ChatCommand/CC = AllCommands[Command]
	if (!CC)
		ErrorText("Command [Command] not found!")
		if (Context)
			Context.PrintStackTrace()
		return
	if (!Executor || (Executor.Rank >= CC.MinPowerLevel) || Debug)
		if (!CC.ShouldExecute(Context))
			return
		CC.Context = Context
		CC.Execute(Executor, CommandText)
		CC.Context = null
	else
		SendUser("\red You do not have permission to do this")
