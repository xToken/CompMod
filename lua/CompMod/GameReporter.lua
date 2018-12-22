-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GameReporter.lua
-- - Dragon

gDisableCompModReporting = false
local kCompModReportingURL = "https://s8dhscedtd.execute-api.us-east-2.amazonaws.com/default/RecordRoundStats"

-- This is a mashup of data usually collected by wonitor and vanilla ns2 round stats systems.  Add more stats when i get around to it.
local function GatherRoundData(winningTeam)
	local Gamerules = GetGamerules()
	local playerRanking = Gamerules.playerRanking
	local gameTime = playerRanking:GetRelativeRoundTime()
	local winningTeamType = winningTeam and winningTeam.GetTeamType and winningTeam:GetTeamType() or kNeutralTeamType
	local numHives = Gamerules:GetTeam2().GetNumCapturedTechPoints and Gamerules:GetTeam2():GetNumCapturedTechPoints() or 0;
	local numCCs = Gamerules:GetTeam1().GetNumCapturedTechPoints and Gamerules:GetTeam1():GetNumCapturedTechPoints() or 0;
	local teamStats = {}
	local aT = math.pow( 2, 1 / 600 )
	local sT = 1
	local eT = math.pow( aT, gameTime * -1 )
	local roundTimeWeighted = sT - eT
	
	for i, team in ipairs( Gamerules:GetTeams() ) do
		local numPlayers, numRookies = team:GetNumPlayers()

		local teamNumber = team:GetTeamNumber()
		local teamInfo = GetEntitiesForTeam("TeamInfo", teamNumber)
		local kills = 0
		local rtCount = 0
		if table.count(teamInfo) > 0 then
			kills = teamInfo[1].GetKills and teamInfo[1]:GetKills() or 0
			rtCount = teamInfo[1].GetNumCapturedResPoints and teamInfo[1]:GetNumCapturedResPoints() or 0
		end

		teamStats[i] = {numPlayers=numPlayers, numRookies=numRookies, rtCount=rtCount, kills=kills}
	end

	local gameInfo = GetGameInfoEntity()

	local roundInfo = {

		serverIp = Server.GetIpAddress(),
		port = Server.GetPort(),
		name = Server.GetName(),
		host_os = jit.os,
		mapName = Shared.GetMapName(),
		player_slots = Server.GetMaxPlayers(),
		build = Shared.GetBuildNumber(),
		tournamentMode = GetTournamentModeEnabled(),
		rookie_only = ( Server.GetConfigSetting("rookie_only") == true ),
		conceded = ( GetGamerules():GetTeam1():GetHasConceded() or GetGamerules():GetTeam2():GetHasConceded() ),
		gameMode = GetGamemode(),
		time = Shared.GetGMTString( false ),

		length = tonumber( string.format( "%.2f", gameTime ) ),
		startLocation1 = Gamerules.startingLocationNameTeam1,
		startLocation2 = Gamerules.startingLocationNameTeam2,
		winner = winningTeamType,

		team1players = teamStats[1].numPlayers,
		team1rookies = teamStats[1].numRookies,
		team1skill = teamStats[1].teamSkill,
		team1kills = teamStats[1].kills,
		team1RTs = teamStats[1].rtCount,
		team1CCs = numCCs,
		
		team2players = teamStats[2].numPlayers,
		team2rookies = teamStats[2].numRookies,
		team2skill = teamStats[2].teamSkill,
		team2kills = teamStats[2].kills,
		team2RTs = teamStats[2].rtCount,
		team2Hives = numHives,
		
		averageSkill = gameInfo:GetAveragePlayerSkill(),
		players = {}
	}
	
	for _, playerData in ipairs(playerRanking.capturedPlayerData) do
		table.insert(roundInfo.players, 
		{
			nickname = playerData.nickname or "",
			playTime = playerData.playTime,
			marineTime = playerData.marineTime,
			alienTime = playerData.alienTime,
			teamNumber = playerData.teamNumber,
			kills = playerData.kills,
			deaths = playerData.deaths,
			assists = playerData.assists,
			score = playerData.score or 0,
			isCommander = ( playerData.commanderTime / gameTime ) > 0.75,
			commanderTime = playerData.commanderTime,
        })
	end
	
	Shared.SendHTTPRequest(kCompModReportingURL, "POST", { data = json.encode(roundInfo) } )
	
end


local originalNS2GamerulesEndGame
	originalNS2GamerulesEndGame = Class_ReplaceMethod("NS2Gamerules", "EndGame",
		function(self, winningTeam, autoConceded)
			originalNS2GamerulesEndGame(self, winningTeam, autoConceded)
			if not gDisableCompModReporting then
				GatherRoundData(winningTeam)
			end
		end
	)