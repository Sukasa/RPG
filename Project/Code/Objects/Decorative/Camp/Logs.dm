/obj/Decorative/Camp/Logs
	icon = 'Resources.dmi'
	icon_state = "Logs2"

	var/IconBase = "Logs"

	Init()
		var/T = round(Config.CampResources["Wood"] / 5) - (XYNoise(10) - 2)
		T = min(T, 2)
		T = max(T, 0)
		icon_state = IconBase + "[T]"
		density = T > 0