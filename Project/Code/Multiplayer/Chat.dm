/mob/verb/Say(var/Text as text)
	Text = "<[name]> [Text]"
	for(var/mob/M in world)
		if (!M.client)
			continue
		var/client/C = M.client
		if (C.SubscribedChannels & client.CanAddress)
			C.Chatbox.WriteLine(Text)