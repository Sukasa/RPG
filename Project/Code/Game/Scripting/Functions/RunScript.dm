/proc/ScriptRun(var/ScriptName, var/Detached)
	if (!Detached)
		Config.Events.RunScript(ScriptName)
	else
		Config.Events.RunScriptDetached(ScriptName)