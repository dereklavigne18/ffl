from Models.TeamCollection import TeamCollection
from Models.TeamModel import TeamModel
from Scrapers import Utils


def scrape(divisionId, seasonId):
    data = Utils.requestDivisionData(divisionId, seasonId)

    teams = TeamCollection()
    for teamData in data['teams']:
        team = TeamModel()
        team.espnId = teamData['teamId']
        team.seasonId = seasonId
        team.divisionId = divisionId
        team.nickname = teamData['teamNickname']
        team.location = teamData['teamLocation']
        team.abbreviation = teamData['teamAbbrev']

        # Since teams can have multiple owners make sure the primary one gets registered
        for owner in teamData['owners']:
            if owner['primaryOwner']:
                team.ownerFirstName = owner['firstName']
                team.ownerLastName = owner['lastName']

        teams.push(team)

    return teams
