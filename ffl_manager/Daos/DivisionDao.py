from Daos.BaseDao import BaseDao


class DivisionDao(BaseDao):

    def load(self):
        sql = 'SELECT id, isYahoo FROM tblDivision'
        return self.execute(sql)