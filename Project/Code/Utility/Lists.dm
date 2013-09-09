/proc/InsertList(var/Index, var/list/Container, var/Insert)
	Container.len++
	for(var/X = Container.len, X > Index, X--)
		Container[X] = Container[X - 1]
	Container[Index] = Insert

/proc/JoinList(var/A)
	for (var/aB in A)
		. = "[.], [aB]"
	. = copytext(., 3)