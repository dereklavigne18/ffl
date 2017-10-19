from Daos.MatchupDao import MatchupDao
from Models.BaseCollection import BaseCollection
from Models.MatchupModel import MatchupModel


class MatchupCollection(BaseCollection):

    def __init__(self):
        BaseCollection.__init__(self)
        self.dao = MatchupDao()

    def modelClass(self):
        return MatchupModel

    def loadInterleague(self, seasonId = None):
        data = self.dao.loadInterleague(seasonId)
        return self.populate(data)

    def save(self):
        self.dao.save(self)

    def matchupExists(self, seasonId = None, weekId = None, homeTeamEspnId = None, awayTeamEspnId = None, homeTeamDivisionId = None, awayTeamDivisionId = None):
        for matchup in self:
            if seasonId is not None and matchup.seasonId != seasonId:
                continue
            if weekId is not None and matchup.weekId != weekId:
                continue
            if homeTeamEspnId is not None and matchup.homeTeam.espnId != homeTeamEspnId:
                continue
            if awayTeamEspnId is not None and matchup.awayTeam.id != awayTeamEspnId:
                continue
            if homeTeamDivisionId is not None and matchup.homeTeam.divisionId != homeTeamDivisionId:
                continue
            if awayTeamDivisionId is not None and matchup.awayTeam.divisionId != awayTeamDivisionId:
                continue
            return True
        return False