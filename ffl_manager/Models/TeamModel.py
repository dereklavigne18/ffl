from Models.BaseModel import BaseModel


class TeamModel(BaseModel):

    def __init__(self):
        self.id = None
        self.espnId = None
        self.seasonId = None
        self.location = None
        self.nickname = None
        self.abbreviation = None
        self.divisionId = None
        self.ownerFirstName = None
        self.ownerLastName = None