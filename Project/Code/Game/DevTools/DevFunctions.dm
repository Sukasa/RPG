proc/GetMatchingFiles(var/SearchDirectory, var/FilePattern)
	. = params2list(call("libBYONDDevTools.dll", "matchingfiles")(SearchDirectory, FilePattern))