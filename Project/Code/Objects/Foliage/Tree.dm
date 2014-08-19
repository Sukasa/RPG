/obj/Foliage/Tree
	icon = 'OakTree.dmi'
	name = "Tree"
	icon_state = "Tree"
	density = 1
	bound_width = 24
	bound_height = 18
	bound_x = 36
	bound_y = 16
	var
		FoliageBoundX = 8
		FoliageBoundY = 32
		FoliageBoundWidth = 80
		FoliageBoundHeight = 80

		global
			list/Overlays = list()

	PalmTree
		icon = 'PalmTree.dmi'

	PineTree
		icon = 'PineTree.dmi'

	DeadTree
		icon = 'DeadTree.dmi'

	ThinTree1
		icon = 'ThinTree1.dmi'
		bound_x = 8

	ThinTree2
		icon = 'ThinTree2.dmi'
		bound_x = 8
		bound_y = 4

	BigTree
		icon = 'BigTree.dmi'
		bound_x = 50
		bound_y = 12

	JapTree
		icon = 'JapTree.dmi'
		bound_x = 56
		bound_y = 28
		bound_width = 16

	SakuraTree
		icon = 'SakuraTree.dmi'
		bound_x = 50
		bound_y = 12

/obj/Foliage/Tree/Init()
	. = list()
	layer -= ((x + y - 1) / 1000)
	icon_state = "Blank"

	var/Key = "[type]"

	if (!Overlays["[Key]-Trunk"])
		Overlays["[Key]-Trunk"] = image(src.icon, src, "Trunk", OBJ_LAYER - ((x + y) / 1000))
	if (!Overlays["[Key]-Shadow"])
		Overlays["[Key]-Shadow"] =  image(src.icon, src, "Shadow", ShadowLayer - ((x + y) / 1000))

	src.overlays += Overlays["[Key]-Trunk"]
	src.overlays += Overlays["[Key]-Shadow"]

	new/obj/Runtime/TreeLeaves(loc, src)
