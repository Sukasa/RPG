/* TODOs:

A) When in devmode, store sound defs individually in files
B) when in devmode, if an unknown sound is created, check to see if a matching-named file exists.  Create an entry instead of failing and generate a warning notice.

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


/SoundController/proc/ResetSounds()
	AllocatedChannels = list(MaxVoices)
	FreeChannelCount = MaxVoices


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

/SoundController/proc/FreeChannel(Channel)
	AllocatedChannels[Channel - DynamicChannelOffset + 1] = FALSE
	FreeChannelCount++


/SoundController/proc/AllocateChannel()
	if (FreeChannelCount == 0)
		return 0
	do
		ChannelCounter++
		ChannelCounter %= 512
		. = ChannelCounter
	while ((!AllocatedChannels[ChannelCounter + DynamicChannelOffset]))
	AllocatedChannels[ChannelCounter + 1] = TRUE
	FreeChannelCount--


/SoundController/proc/StopBGM()
	if (CurrentBGM)
		CurrentBGM.Stop()


/SoundController/proc/StartBGM()
	if (CurrentBGM)
		CurrentBGM.Play()


/SoundController/proc/CreateSound(var/SoundName, var/Attach, var/EmissionPos)
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
		else
			if (Files["Count"] > 1)
				ErrorText("Multiple matches for [SoundName].  Using first match [Files[1]]")
			var/FileName = Files[1]

			Definition = new()
			Definition.Name = FileName
			Definition.SoundFile = file(FileName)
	else
		Definition = Definitions[SoundName]

	if (!Definition)
		return null

	var/SoundEffect/Effect = new(Definition, Attach, EmissionPos)

	if ((Effect.Definition.SoundType & SoundTypeMask) == SoundTypeAmbience)
		Ambiences[SoundName] = Effect

	return Effect
	// And return


/SoundController/proc/PlaySoundEffect(var/atom/Source, var/SoundEffect/Sound)
	// Get sound effect type

	// If ambience, create if necessary else add to list of emitters for sound


/SoundController/proc/StopSoundEffect(var/atom/Source, var/SoundEffect/Sound)
