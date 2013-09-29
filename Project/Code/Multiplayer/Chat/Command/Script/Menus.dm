/datum/ChatCommand/ShowMenu
	Command = "showmenu"
	MinPowerLevel = RankUnranked

/datum/ChatCommand/ShowMenu/Execute(var/mob/Player, var/CommandText)
	// showmenu typepath
	var/MenuType = text2path(CommandText)
	if (MenuType)
		var/Menu = Config.Menus.CreateMenu(Player, MenuType)
		Config.Menus.PushMenu(Player, Menu)

/datum/ChatCommand/WaitNoMenus
	Command = "waitmenu"
	MinPowerLevel = RankUnranked

/datum/ChatCommand/WaitNoMenus/Execute(var/mob/Player, var/CommandText)