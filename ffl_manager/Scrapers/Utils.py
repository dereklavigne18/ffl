import requests


def executeRequest(url):
    return requests.get(url).json()


def requestDivisionData(divisionId, seasonId):
    url = 'http://games.espn.com/ffl/api/v2/teams?leagueId=' + str(divisionId) + '&seasonId=' + str(seasonId)
    return executeRequest(url)
