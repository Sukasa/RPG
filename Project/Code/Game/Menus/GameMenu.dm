/Menu/GameMenu
	// The game menu.  Allows the player to select which game to play or erase.
	var
		list/Files = list( FALSE, FALSE, FALSE )



/Menu/GameMenu/Init()
	//Check if savegames exist

	for (var/X = 1, X <= 3, X++)
		Files[X] = fexists("SAVE[X]")
