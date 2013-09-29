//usr << browse(Tile, "window=picture;file=[ImageX]-[ImageY]-[ImageZ].png;display=0")

/datum/ChatCommand/ProcIcon
	Command = "pc"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/ProcIcon/Execute(var/mob/Player, var/CommandText)
	var/icon/Icon = icon('PalmTree.dmi')
	var/icon/IconY = icon('PalmTree.dmi', "Blank")

	for(var/X = 1, X <= 64, X++)
		for (var/Y = 1, Y <= 96, Y++)
			var/PixelX = Icon.GetPixel(X, Y, "Trunk")
			var/PixelG = Icon.GetPixel(X, Y, "Shadow")

			world.log << "X: [PixelX]"
			world.log << "G: [PixelG]"

			if (PixelG && PixelX)
				var/list/RGBX = ParseRGB(PixelX)
				var/list/RGBG = ParseRGB(PixelG)

				world.log << JoinList(RGBX)
				world.log << JoinList(RGBG)

				if (RGBG[4] in 1 to 254)
					var/list/RGBA = list(Inverse(RGBX[1], RGBG[1], RGBG[4]), Inverse(RGBX[2], RGBG[2], RGBG[4]), Inverse(RGBX[3], RGBG[3], RGBG[4]))
					IconY.DrawBox(rgb(RGBA[1], RGBA[2], RGBA[3]), X, Y)

	usr << browse(IconY, "window=picture;file=ICON.png;display=0")


/datum/ChatCommand/ProcIcon/proc/Inverse(var/X, var/G, var/A)
	return (X - (G * (A / 255))) / (1 - (A / 255))

/datum/ChatCommand/ProcIcon/proc/ParseRGB(var/RGB)
	var/list/L[4]
	L[4] = 255

	RGB = copytext(RGB, 2)
	L[1] = Hex2Num(copytext(RGB, 1, 3))
	L[2] = Hex2Num(copytext(RGB, 3, 5))
	L[3] = Hex2Num(copytext(RGB, 5, 7))
	if (lentext(RGB) > 6)
		L[4] = Hex2Num(copytext(RGB, 7))

	return L

/datum/ChatCommand/ProcIcon/proc/Hex2Num(var/Hex)
	var/C = 0
	Hex = uppertext(Hex)
	for(var/X = 1, X <= lentext(Hex), X++)
		var/ASCII = text2ascii(Hex, X)
		if (ASCII > 57)
			ASCII -= 7
		C *= 16
		C += ASCII - 48
	return C