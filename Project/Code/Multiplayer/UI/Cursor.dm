obj/Runtime/CursorBase
	name = "Cursor"
	icon = 'Blank.dmi'
	var/list/ClientCursors = list( )

obj/Runtime/CursorBase/New()
	//Prevent infinite loop

atom/var/obj/Runtime/CursorBase/CursorObject

atom/New()
	..()
	CursorObject = new/obj/Runtime/CursorBase()

atom/proc/SetCursor(var/Icon)
	CursorObject.icon = Icon

atom/proc/SetClientCursor(var/Ref, var/Icon)
	CursorObject.ClientCursors[Ref] = Icon

client/proc/UpdateCursor(var/atom/Object)
	if (IsAtom(Object))
		mouse_pointer_icon = Object.CursorObject.ClientCursors[mob] || Object.CursorObject.icon

client/MouseEntered(var/atom/Object, var/Location, var/Control, var/Params)
	UpdateCursor(Object)