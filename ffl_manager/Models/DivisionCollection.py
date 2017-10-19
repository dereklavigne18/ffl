from Daos.DivisionDao import DivisionDao
from Models.BaseCollection import BaseCollection
from Models.DivisionModel import DivisionModel


class DivisionCollection(BaseCollection):

    def modelClass(self):
        return DivisionModel

    def load(self):
        dao = DivisionDao()
        data = dao.load()
        self.populate(data)