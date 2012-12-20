client
	show_popup_menus = FALSE
	var
		obj/Runtime/Chatbox/Chatbox = new()
		obj/Runtime/HUD/HUDController/HUD
		BroadcastChannels = ChannelAll
		SubscribedChannels = ChannelAll

/client/New()
	..()
	screen += Chatbox
	src.mob.x = 10
	src.mob.y = 12
	HUD = new/obj/Runtime/HUD/HUDController/SoldierHUD(src)
	HUD.Initialize()


/client/Move()
	return
