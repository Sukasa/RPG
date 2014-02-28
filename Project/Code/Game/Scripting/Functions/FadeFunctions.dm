proc/ScriptFadeIn()
	Config.Events.FadeIn()

proc/ScriptFadeOut()
	Config.Events.FadeOut()

proc/ScriptSetFade(var/Color = ColorBlack, var/Alpha = 255)
	Config.Events.SetFade(Color, Alpha)