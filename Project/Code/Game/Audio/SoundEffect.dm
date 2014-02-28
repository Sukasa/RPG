/SoundEffect
	var
		Volume = 100
		SoundDef/Definition
		sound/Sound
		Paused
		ExclusiveMode
		list/AmbienceEmitters = list( )

		FadeStart
		FadeTime
		FadeTo
		FadeFrom
		FadeDone

/SoundEffect/New(var/SoundDef/Def)
	Definition = Def
	Paused = FALSE

	Sound = sound(Definition.SoundFile)
	Sound.environment = Definition.Environment || Config.Audio.Environment
	Sound.falloff = Definition.Falloff
	Sound.repeat = Definition.Repeat
	Sound.frequency = Definition.Frequency

/SoundEffect/proc/TickFade()
	if (!Sound)
		ErrorText("Fade on unintialized sound effect")
		return
	if (!FadeDone)
		Sound.status = Paused ? SOUND_UPDATE | SOUND_PAUSED : SOUND_UPDATE
		Sound.volume = lerp(FadeFrom, FadeTo, (world.time - FadeStart) / FadeTime) * Config.Audio.GameVolume * Volume * Definition.VolumeMultiplier
		world << Sound

		FadeDone = (world.time - FadeStart) >= FadeTime
/SoundEffect/proc/Pause(var/Emitter)
	if (!ExclusiveMode)
		return
	Sound.status |= SOUND_UPDATE
	Sound.status ^= SOUND_PAUSED
	world << Sound
	Paused = !Paused

/SoundEffect/proc/Play(var/Emitter)
	if (!ExclusiveMode)
		Sound.status = 0
		Sound.volume = Config.Audio.GameVolume * Volume * Definition.VolumeMultiplier
		world << Sound
	else if (Emitter && (Definition.SoundType & SoundTypeAmbience))
		AmbienceEmitters += Emitter
