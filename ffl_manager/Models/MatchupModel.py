from Models.BaseModel import BaseModel

class MatchupModel(BaseModel):

    def __init__(self):
        self.seasonId = None
        self.weekId = None
        self.yahooTeamEspnId = None
        self.espnTeamEspnId = None
        self.homeDivisionId = None
        self.awayDivisionId = None
        self.homeTeam = None
        self.awayTeam = None
        self.homeTeamPoints = None
        self.awayTeamPoints = None