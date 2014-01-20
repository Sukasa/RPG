/ChatCommand/ShowMenu
	Command = "showmenu"
	MinPowerLevel = RankUnranked

/ChatCommand/ShowMenu/Execute(var/mob/Player, var/CommandText)
	// showmenu typepath
	var/list/Params = ParamList(CommandText)
	var/MenuType = text2path(Params[1])
	if (ispath(MenuType, /Menu))
		var/Menu = Config.Menus.CreateMenu(Player, MenuType, Params)
		Config.Menus.PushMenu(Player, Menu)
	else
		ErrorText("[Params[1]] is not a known menu type!")
		if (Context)
			Context.PrintStackTrace(Context)

/ChatCommand/WaitNoMenus
	Command = "waitmenu"
	MinPowerLevel = RankUnranked

/ChatCommand/WaitNoMenus/Execute(var/mob/Player, var/CommandText)