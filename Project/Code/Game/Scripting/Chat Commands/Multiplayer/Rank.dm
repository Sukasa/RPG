/ChatCommand/Rank
	Command = "rank"
	MinPowerLevel = RankUnranked

/ChatCommand/Rank/Execute(var/mob/Player, var/CommandText)
	SendUser("\cyan Your rank is [Player.Rank] ([RankTitles[Player.Rank]])")