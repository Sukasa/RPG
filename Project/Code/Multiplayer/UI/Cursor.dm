obj/Runtime/CursorBase
	name = "Cursor"
	icon = null
	var/list/MobCursors = list( )

atom/var/obj/Runtime/CursorBase/CursorObject

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
		mouse_pointer_icon = Object.CursorObject.MobCursors[mob] || Object.CursorObject.icon

client/MouseEntered(var/atom/Object, var/Location, var/Control, var/Params)
	UpdateCursor(Object)
