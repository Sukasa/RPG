/FileInfo
	var
		Exists
		DirectoryName
		Extension
		FullName
		ReadOnly
		CreationTimestamp
		LastAccessTimestamp
		LastWriteTimestamp
		Size
		Name
		Path

	New(var/Filename)
		..()
		if (!Config.IsDevMode)
			CRASH("Dev Tools not installed!")

		var/list/L = params2list(call("libBYONDDevTools.dll", "fileinfo")(Filename))

		if (!L)
			Exists = 0
			Path = Filename
			ErrorText("Unable to get file information for [Filename]")
			return

		Exists = L["Exists"]
		Path = L["Path"]
		if (!Exists)
			return

		DirectoryName = L["DirectoryName"]
		Extension = L["Extension"]
		FullName = L["FullName"]
		ReadOnly = L["ReadOnly"]
		CreationTimestamp = text2num(L["CreationTimestamp"])
		LastAccessTimestamp = text2num(L["LastAccessTimestamp"])
		LastWriteTimestamp = text2num(L["LastWriteTimestamp"])
		Size = L["Size"]
		Name = L["Name"]