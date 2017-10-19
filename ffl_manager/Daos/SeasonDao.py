from Daos.BaseDao import BaseDao


class SeasonDao(BaseDao):

    def load(self):
        sql = 'SELECT id, isCurrent FROM tblSeason'
        return self.execute(sql)
