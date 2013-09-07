obj/Runtime/CursorBase
	name = "Cursor"
	icon = null
	var/list/MobCursors = list( )

atom/var/obj/Runtime/CursorBase/CursorObject

atom/New()
	..()
	CursorObject = new/obj/Runtime/CursorBase()

obj/Runtime/CursorBase/New()
	//Prevent infinite loop

datum/proc/GetCursor(var/Icon)
	if (isicon(Icon))
		return Icon
	else if (isfile(Icon))
		return icon(Icon)
	else
		return Config.DefaultCursors[Icon]

atom/proc/SetCursor(var/Icon)
	CursorObject.icon = GetCursor(Icon)

atom/proc/SetMobCursor(var/Ref, var/Icon)
	CursorObject.MobCursors[Ref] = GetCursor(Icon)

client/proc/UpdateCursor(var/atom/Object)
	if (!EnableCursor)
		return
	if (IsAtom(Object))
		var/obj/Item/SelectedItem = mob.SelectedItem()
		mouse_pointer_icon = (SelectedItem && SelectedItem.TargetCursor(Object)) || Object.CursorObject.MobCursors[mob] || Object.CursorObject.icon

client/MouseEntered(var/atom/Object, var/Location, var/Control, var/Params)
	UpdateCursor(Object)
