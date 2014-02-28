/proc/ScriptShowMenu(var/Player, var/MenuType, var/list/Params)
	MenuType = text2path(MenuType)
	if (ispath(MenuType, /Menu))
		var/Menu = Config.Menus.CreateMenu(Player, MenuType, Params)
		return Config.Menus.PushMenu(Player, Menu)
	else
		ErrorText("[Params[1]] is not a known menu type!")