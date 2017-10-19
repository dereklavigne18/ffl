import pymysql

from Credentials import Database


class BaseDao:

    def execute(self, sql):
        data = None
        connection = self.getConnection()

        try:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                data = cursor.fetchall()
                connection.commit()

        finally:
            connection.close()
            return data

    def getConnection(self):
        connection = pymysql.connect(
            host = Database.host(),
            user = Database.username(),
            password = Database.password(),
            db = Database.databaseName(),
            charset = 'utf8mb4',
            cursorclass = pymysql.cursors.DictCursor
        )
        return connection
