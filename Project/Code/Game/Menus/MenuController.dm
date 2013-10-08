/MenuController
	var
		list/CurrentMenus = list( )
		list/MenuStack = list( )
// Features: Setting / changing a menu for a client


//--------------------------------------------------------------


/MenuController/proc/Tick()
	for(var/C in CurrentMenus)
		var/Menu/M = CurrentMenus[C]
		if (M)
			M.Tick()


//--------------------------------------------------------------


// Creates a new menu for the supplied player and returns it without performing any initialization
/MenuController/proc/CreateMenu(var/Player, var/MenuType, var/list/Params)
	var/Menu/NewMenu = new MenuType(Params)
	if (ismob(Player))
		Player = Player:client
	NewMenu.Client = Player
	return NewMenu

// Changes CurrentMenu to the provided (instantiated) menu, without pushing or popping
/MenuController/proc/SwapMenu(var/Player, var/Menu)
	DeInitCurrent(Player)
	CurrentMenus[Player] = Menu

// Changes CurrentMenu to the provided (instantiated) menu, and saves the previous menu
/MenuController/proc/PushMenu(var/Player, var/Menu/Menu)
	var/Stack/Stack = CheckCreateStack(Player)
	HideCurrent(Player)
	Stack.Push(CurrentMenus[Player])
	CurrentMenus[Player] = Menu
	Menu.Init()

// Terminates the current menu, and pops the previous one
/MenuController/proc/PopMenu(var/Player)
	var/Stack/Stack = CheckCreateStack(Player)
	DeInitCurrent(Player)
	CurrentMenus[Player] = Stack.IsEmpty() ? null :Stack.Pop()
	ShowCurrent()


//--------------------------------------------------------------


/MenuController/proc/CheckCreateStack(var/Player)
	if (!MenuStack[Player])
		MenuStack[Player] = new/Stack()
	return MenuStack[Player]

/MenuController/proc/DeInitCurrent(var/Player)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		world.log << "Deinit"
		Menu.DeInit()
		del Menu


/MenuController/proc/HideCurrent(var/Player)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Hide()


/MenuController/proc/ShowCurrent(var/Player)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Show()