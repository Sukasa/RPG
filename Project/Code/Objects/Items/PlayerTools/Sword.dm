/obj/Item/Sword
	name = "Scout's Sword"
	Description = "A basic sword, rough around the edges and a little dull"
	icon = 'Items.dmi'
	icon_state = "sword"

/obj/Item/Sword/GetOverlay(var/Direction, var/State)
	// Returns an image overlay to be added on to the wielding mob
	// TODO This will probably need to be heavily worked-on to handle movement/etc

/obj/Item/Sword/Use()
	// Flick animation state on player
/*	(
	how? - need proc on player

	Should be simple - something like Wielder.PlayAnimation("AnimationName", InputFreezeTime, [MovementFreezeTime])
	So, this could do Wielder.PlayAnimation("SwingBasicSword"), which flick()'s the target, pauses their input for (InputFreezeTime) frames,
	and optionally freezes their movement for an additional (InputFreezeTime) frames

	)*/
	// Flick sword-swing
	// Hit-scan by creating hit test object and Move()'ing to position?
	return