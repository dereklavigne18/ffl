if __name__ == '__main__':
    from Daos.BaseDao import BaseDao

    dao = BaseDao()
    dao.execute('CALL spIncrementWeek()')
