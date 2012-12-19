client
	show_popup_menus = FALSE
	var
		obj/Runtime/Chatbox/Chatbox = new()
		BroadcastChannels = ChannelAll
		SubscribedChannels = ChannelAll

/client/New()
	..()
	screen += Chatbox
	src.mob.x = 10
	src.mob.y = 12


/client/Move()
	return
