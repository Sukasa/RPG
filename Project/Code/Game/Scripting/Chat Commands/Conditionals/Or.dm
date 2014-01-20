ConditionalCommand/Or
	Command = "or"

ConditionalCommand/Or/Execute(var/mob/Player, var/CommandText)
	if (RequireContext())
		return

	var/A = Context.AnyConditional()

	Context.PopConditional()
	Context.PushConditional(A && Context.AllConditionals())