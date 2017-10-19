from Models.DivisionCollection import DivisionCollection
from Models.MatchupCollection import MatchupCollection
from Models.MatchupModel import MatchupModel
from Models.TeamCollection import TeamCollection
from Scrapers import Utils


def scrape(seasonId):
    divisions = DivisionCollection()
    divisions.load()

    yahooDivisionId = divisions.searchBy({'isYahoo': True}).id
    espnDivisionId = divisions.searchBy({'isYahoo': False}).id
    yahooData = Utils.requestDivisionData(yahooDivisionId, seasonId)
    espnData = Utils.requestDivisionData(espnDivisionId, seasonId)

    teams = TeamCollection()
    teams.load(seasonId)

    matchups = MatchupCollection()
    matchups.loadInterleague(seasonId)
    for matchup in matchups:
        if matchup.homeDivisionId == yahooDivisionId:
            matchup.homeTeam = teams.searchBy({'divisionId': yahooDivisionId, 'espnId': matchup.yahooTeamEspnId})
            matchup.homeTeamPoints = findInterleagueScore(matchup.yahooTeamEspnId, matchup.weekId, yahooData)
            matchup.awayTeam = teams.searchBy({'divisionId': espnDivisionId, 'espnId': matchup.espnTeamEspnId})
            matchup.awayTeamPoints = findInterleagueScore(matchup.espnTeamEspnId, matchup.weekId, espnData)
        else:
            matchup.awayTeam = teams.searchBy({'divisionId': yahooDivisionId, 'espnId': matchup.yahooTeamEspnId})
            matchup.awayTeamPoints = findInterleagueScore(matchup.yahooTeamEspnId, matchup.weekId, yahooData)
            matchup.homeTeam = teams.searchBy({'divisionId': espnDivisionId, 'espnId': matchup.espnTeamEspnId})
            matchup.homeTeamPoints = findInterleagueScore(matchup.espnTeamEspnId, matchup.weekId, espnData)

    addIntraleagueMatchups(matchups, teams, seasonId, yahooDivisionId, yahooData)
    addIntraleagueMatchups(matchups, teams, seasonId, espnDivisionId, espnData)

    return matchups


def addIntraleagueMatchups(matchups, teams, seasonId, divisionId, divisionData):
    for team in divisionData['teams']:
        for matchupInfo in team['scheduleItems']:
            # Skip the matchup if an interleague week or it is a non fantasy week
            if matchupInfo['matchupPeriodId'] % 3 == 0 or matchupInfo['matchupPeriodId'] > 13:
                continue
            # Skip the matchup if it already exists
            if matchups.matchupExists(
                seasonId = seasonId,
                weekId = matchupInfo['matchupPeriodId'],
                homeTeamEspnId = matchupInfo['matchups'][0]['homeTeamId'],
                homeTeamDivisionId = divisionId
            ):
                continue

            matchup = MatchupModel()
            matchup.seasonId = seasonId
            matchup.weekId = matchupInfo['matchupPeriodId']
            matchup.homeTeam = teams.searchBy({'espnId': matchupInfo['matchups'][0]['homeTeamId'], 'divisionId': divisionId})
            matchup.awayTeam = teams.searchBy({'espnId': matchupInfo['matchups'][0]['awayTeamId'], 'divisionId': divisionId})
            matchup.homeTeamPoints = matchupInfo['matchups'][0]['homeTeamScores'][0]
            matchup.awayTeamPoints = matchupInfo['matchups'][0]['awayTeamScores'][0]

            matchups.push(matchup)


def findInterleagueScore(teamId, weekId, data):
    for team in data['teams']:
        if team['teamId'] == teamId:
            selectedTeam = team
            break

    for matchup in selectedTeam['scheduleItems']:
        if matchup['matchupPeriodId'] == weekId:
            return matchup['matchups'][0]['homeTeamScores'][0]
