/* TODOs:

A) When in devmode, store sound defs individually in files
B) When in devmode, if an unknown sound is created, check to see if a matching-named file exists.  Create an entry instead of failing and generate a warning notice.

*/
/SoundController
	var
		SoundEffect/CurrentBGM = null
		CurrentBGMTrackName = null

		Environment = EnvironmentGeneric
		GameVolume = 15
		MusicVolume = 15
		ChannelCounter = 0

		FreeChannelCount = MaxVoices


		list/AllocatedChannels = list(MaxVoices)
		list/AllocationEffects = list(MaxVoices)
		list/Ambiences = list( )
		list/DefinitionIndex = list( )

		savefile/Definitions = null


/SoundController/proc/Init()
	// Load sound definitions
	if (fexists("ADATA"))
		Definitions = new/savefile("ADATA")
		Definitions[".index"] >> DefinitionIndex
	else
		Definitions = new/savefile("ADATA")
	ResetSounds()


/SoundController/proc/Tick()
	for(var/SoundEffect/Effect in AllocationEffects)
		if (!Effect)
			continue
		Effect.Tick()


/SoundController/proc/ResetSounds()
	AllocatedChannels = list(MaxVoices)
	AllocationEffects = list(MaxVoices)

	FreeChannelCount = MaxVoices
	for(var/x = 1, x <= MaxVoices, x++)
		AllocatedChannels[x] = 0

	var/sound/StopAll = sound(null, channel=0)
	StopAll.status = SOUND_PAUSED | SOUND_UPDATE
	StopAll.volume = 0
	world << StopAll


/SoundController/proc/SetEnvironment(var/NewEnvironment)
	Environment = NewEnvironment


/SoundController/proc/SetBGM(var/NewTrackName, var/Async = FALSE, var/FadeTime = 1)
	if (NewTrackName == CurrentBGMTrackName) // Setting the BGM to itself will do nothing.
		return

	if (Async)
		spawn
			SetBGM(NewTrackName, FALSE, FadeTime)
		return

	CurrentBGMTrackName = NewTrackName

	if (CurrentBGM)
		// Fade current BGM
		CurrentBGM.SetFade(FadeTime / 2, 0)

		while (!CurrentBGM.FadeDone)
			CurrentBGM.TickFade()
			sleep(world.tick_lag)

	// Create new BGM
	CurrentBGM = CreateSound(NewTrackName)
	CurrentBGM.Volume = 0
	CurrentBGM.SetFade(FadeTime / 2, 1)

	// Fade it in
	while (!CurrentBGM.FadeDone)
		CurrentBGM.TickFade()
		sleep(world.tick_lag)

/SoundController/proc/CheckFreeChannel(Channel)
	AllocatedChannels[Channel]--
	if (!AllocatedChannels[Channel])
		FreeChannelCount++
		AllocationEffects[Channel] = null


/SoundController/proc/PreserveChannelAllocation(var/SoundEffect/SoundEffect)
	var/Channel = SoundEffect.Sound.channel - DynamicChannelOffset + 1
	AllocatedChannels[Channel]++
	if (SoundEffect.Definition.Duration != -1)
		spawn(SoundEffect.Definition.Duration)
			CheckFreeChannel(Channel)


/SoundController/proc/IsChannelAllocated(var/Channel)
	. = AllocatedChannels[Channel - DynamicChannelOffset + 1]


/SoundController/proc/AllocateChannel(var/SoundEffect/SoundEffect)
	if (FreeChannelCount == 0)
		return 0
	do
		ChannelCounter++
		ChannelCounter %= MaxVoices
		. = ChannelCounter + DynamicChannelOffset
	while ((!AllocatedChannels[ChannelCounter + 1]))
	AllocatedChannels[ChannelCounter + 1]++
	if (SoundEffect.Definition.Duration != -1)
		spawn(SoundEffect.Definition.Duration)
			CheckFreeChannel(ChannelCounter + 1)
	FreeChannelCount--


/SoundController/proc/StopBGM()
	if (CurrentBGM)
		CurrentBGM.Stop()


/SoundController/proc/StartBGM()
	if (CurrentBGM)
		CurrentBGM.Play()


/SoundController/proc/CreateSound(var/SoundName, var/EmissionPos)
	// See if the sound has been instantiated and cached.  If so, return it
	if (Ambiences[SoundName])
		return Ambiences[SoundName]

	var/SoundDef/Definition

	if (!DefinitionIndex[SoundName])

		if (!Config.IsDevMode)
			return null

		// Instantiate SoundEffect
		var/list/Files = GetMatchingFiles("Sounds", "[SoundName].*")

		if (Files["Count"] == 0)
			ErrorText("Unable to find matching sound for [SoundName]")
			return null
		else
			if (Files["Count"] > 1)
				ErrorText("Multiple matches for [SoundName].  Using first match [Files[1]]")
			var/FileName = Files[1]

			Definition = new()
			Definition.Name = FileName
			Definition.SoundFile = file(FileName)

			Definitions[SoundName] = Definition

	else
		Definition = Definitions[SoundName]

	if (!Definition)
		return null

	var/SoundEffect/Effect = new(Definition, EmissionPos)

	if ((Effect.Definition.SoundType & SoundTypeMask) == SoundTypeAmbience)
		Ambiences[SoundName] = Effect

	return Effect
	// And return
