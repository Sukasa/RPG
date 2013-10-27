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
	NewMenu.Player = NewMenu.Client.mob
	return NewMenu

// Changes CurrentMenu to the provided (instantiated) menu, without pushing or popping
/MenuController/proc/SwapMenu(var/Player, var/Menu/Menu)
	if (ismob(Player))
		Player = Player:client

	PersistMenus(Player, Menu)
	DeInitCurrent(Player, TRUE)
	CurrentMenus[Player] = Menu
	Menu.Init()

// Changes CurrentMenu to the provided (instantiated) menu, and saves the previous menu
/MenuController/proc/PushMenu(var/datum/Player, var/Menu/Menu)
	if (ismob(Player))
		Player = Player:client
	var/Stack/Stack = CheckCreateStack(Player)

	PersistMenus(Player, Menu)
	HideCurrent(Player)

	if (CurrentMenus[Player])
		Stack.Push(CurrentMenus[Player])

	CurrentMenus[Player] = Menu
	Menu.Init()

// Terminates the current menu, and pops the previous one
/MenuController/proc/PopMenu(var/Player)
	if (ismob(Player))
		Player = Player:client
	var/Stack/Stack = CheckCreateStack(Player)

	DeInitCurrent(Player)
	CurrentMenus[Player] = Stack.IsEmpty() ? null :Stack.Pop()
	ShowCurrent()


//--------------------------------------------------------------



/MenuController/proc/PersistMenus(var/Player, var/Menu/ToMenu)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		ToMenu.PersistentElements = Menu.PersistentElements

/MenuController/proc/CheckCreateStack(var/Player)
	if (!MenuStack[Player])
		MenuStack[Player] = new/Stack()
	return MenuStack[Player]

/MenuController/proc/DeInitCurrent(var/Player, var/IsSwap = FALSE)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		DePersist(Player, Menu, IsSwap)
		Menu.DeInit()
		del Menu

/MenuController/proc/DePersist(var/Player, var/Menu/Menu, var/IsSwap = FALSE)
	var/Stack/Stack = CheckCreateStack(Player)
	if (!Stack.IsEmpty())
		var/Menu/NextMenu = Stack.Peek()
		if (NextMenu)
			Menu.StaticElements |= (Menu.PersistentElements - NextMenu.PersistentElements)
			Menu.PersistentElements = list( )
	else if (!IsSwap)
		Menu.StaticElements |= Menu.PersistentElements
		Menu.PersistentElements = list( )

/MenuController/proc/HideCurrent(var/Player)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Hide()


/MenuController/proc/ShowCurrent(var/Player)
	var/Menu/Menu = CurrentMenus[Player]
	if (Menu)
		Menu.Show()