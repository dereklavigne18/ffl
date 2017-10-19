from Daos.SeasonDao import SeasonDao
from Models.BaseCollection import BaseCollection
from Models.SeasonModel import SeasonModel


class SeasonCollection(BaseCollection):

    def modelClass(self):
        return SeasonModel

    def load(self):
        dao = SeasonDao()
        self.populate(dao.load())