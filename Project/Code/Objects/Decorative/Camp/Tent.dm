/obj/Decorative/Camp/Tent

	icon = 'Tent.dmi'
	icon_state = "Tent"
	layer = ObjectLayer;


	New()
		..()

		// Create bounding boxes here

		var/obj/Runtime/Dummy = new()
		Dummy.density = 1
		Dummy.loc = loc

		Dummy.bound_x = 6
		Dummy.bound_y = 6
		Dummy.bound_height = 101
		Dummy.bound_width = 40

		Dummy = new()
		Dummy.density = 1
		Dummy.loc = loc

		Dummy.bound_x = 80
		Dummy.bound_y = 6
		Dummy.bound_height = 101
		Dummy.bound_width = 40

		Dummy = new()
		Dummy.density = 1
		Dummy.loc = loc

		Dummy.bound_x = 44
		Dummy.bound_y = 45
		Dummy.bound_height = 70
		Dummy.bound_width = 40

		Dummy = new()
		Dummy.icon = icon
		Dummy.icon_state = "Topper"
		Dummy.loc = loc
		Dummy.layer = StructureLayer
		Dummy.BaseLayer = StructureLayer
		Dummy.ReCalcLayer();

		ReCalcLayer();


