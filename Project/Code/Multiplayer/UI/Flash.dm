/obj/Runtime/Flash
	layer = FlashLayer
	icon = 'FlashBase.dmi'
	icon_state = "White"
	alpha = 0
	color = ColorWhite

/obj/Runtime/Flash/New()
		..()
		transform *= (world.view * 2) + 1

/obj/Runtime/Flash/Init(var/client/C)
	C.screen += src
	screen_loc = "CENTER"

/obj/Runtime/Flash/proc/FlashAsync(var/Color, var/HoldTime, var/FadeTime)
	spawn
		FlashBlocking(Color, HoldTime, FadeTime)

/obj/Runtime/Flash/proc/Set(var/Color, var/Alpha = 255)
	color = Color
	alpha = Alpha

/obj/Runtime/Flash/proc/Clear()
	alpha = 0

/obj/Runtime/Flash/proc/Fade(var/ColorFrom, var/ColorTo, var/Time)
	color = ColorFrom
	alpha = 255
	animate(src, color = ColorTo, time = Time)
	sleep(Time)

/obj/Runtime/Flash/proc/FlashBlocking(var/Color, var/HoldTime, var/FadeTime)
	color = Color
	alpha = 255
	sleep(HoldTime)
	animate(src, alpha = 0, time = FadeTime)
	sleep(FadeTime)

/obj/Runtime/Flash/proc/FadeOut(var/Color, var/Time, var/Alpha = 255)
	color = Color
	animate(src, alpha = Alpha, time = Time)
	sleep(Time)

/obj/Runtime/Flash/proc/FadeIn(var/Color, var/Time, var/Alpha = 0)
	color = Color
	animate(src, alpha = Alpha, time = Time)
	sleep(Time)