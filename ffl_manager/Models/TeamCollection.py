from Daos.TeamDao import TeamDao
from Models.BaseCollection import BaseCollection
from Models.TeamModel import TeamModel


class TeamCollection(BaseCollection):

    def __init__(self):
        BaseCollection.__init__(self)
        self.dao = TeamDao()

    def modelClass(self):
        return TeamModel

    def load(self, seasonId = None):
        self.populate(self.dao.load(seasonId))

    def save(self):
        self.dao.save(self)