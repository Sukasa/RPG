/proc/InsertList(var/Index, var/list/Container, var/Insert)
	Container.len++
	for(var/X = Container.len, X > Index, X--)
		Container[X] = Container[X - 1]
	Container[Index] = Insert

/proc/JoinList(var/list/A, var/Separator = ", ")
	for (var/aB in A)
		. = "[.][Separator][aB]"
	. = copytext(., lentext(Separator) + 1)

/proc/Pop(var/list/L)
	. = L[1]
	L.Cut(1, 2)

/proc/Push(var/list/L, var/Item)
	L.Insert(1, Item)

proc/Split(var/Haystack, var/Delimiter)
	. = list( )
	var/Pos = findtextEx(Haystack, Delimiter)
	while (Pos)
		. += copytext(Haystack, 1, Pos)
		Haystack = copytext(Haystack, Pos + lentext(Delimiter))
		Pos = findtextEx(Haystack, Delimiter)
	. += Haystack