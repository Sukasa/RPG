/datum/MenuController
	var
		list/CurrentMenus = list( )
		list/MenuStack = list( )
// Features: Setting / changing a menu for a client


//--------------------------------------------------------------


/datum/MenuController/proc/Tick()
	for(var/C in CurrentMenus)
		var/datum/Menu/M = CurrentMenus[C]
		if (M)
			M.Tick()


//--------------------------------------------------------------


// Creates a new menu for the supplied player and returns it without performing any initialization
/datum/MenuController/proc/CreateMenu(var/Player, var/MenuType)
	var/datum/Menu/NewMenu = new MenuType()
	if (ismob(Player))
		Player = Player:client
	NewMenu.Client = Player
	return NewMenu

// Changes CurrentMenu to the provided (instantiated) menu, without pushing or popping
/datum/MenuController/proc/SwapMenu(var/Player, var/Menu)
	DeInitCurrent(Player)
	CurrentMenus[Player] = Menu

// Changes CurrentMenu to the provided (instantiated) menu, and saves the previous menu
/datum/MenuController/proc/PushMenu(var/Player, var/datum/Menu/Menu)
	var/list/Stack = CheckCreateStack(Player)
	HideCurrent(Player)
	Push(Stack, CurrentMenus[Player])
	CurrentMenus[Player] = Menu
	Menu.Init()

// Terminates the current menu, and pops the previous one
/datum/MenuController/proc/PopMenu(var/Player)
	var/list/Stack = CheckCreateStack(Player)
	DeInitCurrent(Player)
	CurrentMenus[Player] = Pop(Stack)
	ShowCurrent()


//--------------------------------------------------------------


/datum/MenuController/proc/CheckCreateStack(var/Player)
	if (!MenuStack[Player])
		MenuStack[Player] = list( )
	return MenuStack[Player]

/datum/MenuController/proc/DeInitCurrent(var/Player)
	var/datum/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.DeInit()
		del Menu


/datum/MenuController/proc/HideCurrent(var/Player)
	var/datum/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Hide()


/datum/MenuController/proc/ShowCurrent(var/Player)
	var/datum/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Show()