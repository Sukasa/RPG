/proc/InsertList(var/Index, var/list/Container, var/Insert)
	Container.Insert(Index, list(Insert))
//	Container.len++
//	for(var/X = Container.len, X > Index, X--)
//		Container[X] = Container[X - 1]
//	Container[Index] = Insert

/proc/JoinList(var/list/A, var/Separator = ", ")
	for (var/aB in A)
		. = "[.][Separator][aB]"
	. = copytext(., lentext(Separator) + 1)

/proc/Pop(var/list/L)
	. = L[1]
	L.Cut(1, 2)

/proc/Push(var/list/L, var/Item)
	L.Insert(1, Item)