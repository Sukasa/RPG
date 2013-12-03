Stack
	var/list/Items = list( )

	proc
		Push(var/Item)
			Items.InsertList(1, list(Item))

		Pop()
			. = Peek()
			Items.Cut(1, 2)

		Peek()
			ASSERT(Items.len)
			. = Items[1]

		IsEmpty()
			return Items.len == 0

		Count()
			return Items.len

		Clear()
			Items = list( )