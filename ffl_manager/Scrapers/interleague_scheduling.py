import pymysql

connection = pymysql.connect(
    host='localhost',
    user='squidward',
    password='tenticles',
    db='ffl',
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)

try:
    with connection.cursor() as cursor:
        sql = """
			CREATE TABLE IF NOT EXISTS `tblInterleagueMatchups` (
				`year` INT NOT NULL,
				`week` INT NOT NULL,
				`yahooTeamId` INT NOT NULL,
				`espnTeamId` INT NOT NULL,
				`homeDivision` TINYINT(1) NOT NULL
			);

			INSERT INTO `tblInterleagueMatchups` (`year`, `week`, `yahooTeamId`, `espnTeamId`, `homeDivision`)
			VALUES
				-- Week 3 Inter-league matchups 2016
				-- Yahoo league is home
				(2016, 3, 1, 9, 1),
				(2016, 3, 3, 2, 1),
				(2016, 3, 10, 5, 1),
				(2016, 3, 4, 10, 1),
				(2016, 3, 7, 8, 1),
				(2016, 3, 2, 4, 1),
				(2016, 3, 8, 1, 1),
				(2016, 3, 9, 3, 1),
				(2016, 3, 6, 6, 1),
				(2016, 3, 5, 7, 1),

				-- Week 6 Inter-league matchups 2016
				-- ESPN league is home
				(2016, 6, 1, 2, 0),
				(2016, 6, 3, 9, 0),
				(2016, 6, 10, 10, 0),
				(2016, 6, 4, 5, 0),
				(2016, 6, 7, 4, 0),
				(2016, 6, 2, 8, 0),
				(2016, 6, 8, 3, 0),
				(2016, 6, 9, 1, 0),
				(2016, 6, 6, 7, 0),
				(2016, 6, 5, 6, 0),

				-- Week 9 Inter-league matchups 2016
				-- Yahoo league is home
				(2016, 9, 1, 5, 1),
				(2016, 9, 3, 10, 1),
				(2016, 9, 10, 8, 1),
				(2016, 9, 4, 4, 1),
				(2016, 9, 7, 1, 1),
				(2016, 9, 2, 3, 1),
				(2016, 9, 8, 6, 1),
				(2016, 9, 9, 7, 1),
				(2016, 9, 6, 9, 1),
				(2016, 9, 5, 2, 1),

				-- Week 12 Inter-league matchups 2016
				-- ESPN league is home
				(2016, 12, 1, 10, 0),
				(2016, 12, 3, 5, 0),
				(2016, 12, 10, 4, 0),
				(2016, 12, 4, 8, 0),
				(2016, 12, 7, 3, 0),
				(2016, 12, 2, 1, 0),
				(2016, 12, 8, 7, 0),
				(2016, 12, 9, 6, 0),
				(2016, 12, 6, 2, 0),
				(2016, 12, 5, 9, 0),

				-- Week 3 Inter-league matchups 2017
				-- Yahoo league is home
				(2017, 3, 2, 5, 1),
				(2017, 3, 4, 10, 1),
				(2017, 3, 5, 1, 1),
				(2017, 3, 9, 3, 1),
				(2017, 3, 10, 8, 1),
				(2017, 3, 3, 7, 1),
				(2017, 3, 7, 2, 1),
				(2017, 3, 1, 4, 1),
				(2017, 3, 8, 6, 1),
				(2017, 3, 6, 9, 1),

				-- Week 6 Inter-league matchups 2017
				-- ESPN league is home
				(2017, 6, 2, 10, 0),
				(2017, 6, 4, 5, 0),
				(2017, 6, 5, 3, 0),
				(2017, 6, 9, 1, 0),
				(2017, 6, 10, 7, 0),
				(2017, 6, 3, 8, 0),
				(2017, 6, 7, 4, 0),
				(2017, 6, 1, 2, 0),
				(2017, 6, 8, 9, 0),
				(2017, 6, 6, 6, 0),

				-- Week 9 Inter-league matchups 2017
				-- Yahoo league is home
				(2017, 9, 2, 1, 1),
				(2017, 9, 4, 3, 1),
				(2017, 9, 5, 8, 1),
				(2017, 9, 9, 7, 1),
				(2017, 9, 10, 2, 1),
				(2017, 9, 3, 4, 1),
				(2017, 9, 7, 6, 1),
				(2017, 9, 1, 9, 1),
				(2017, 9, 8, 5, 1),
				(2017, 9, 6, 10, 1),

				-- Week 12 Inter-league matchups 2017
				-- ESPN is home
				(2017, 12, 2, 3, 0),
				(2017, 12, 4, 1, 0),
				(2017, 12, 5, 7, 0),
				(2017, 12, 9, 8, 0),
				(2017, 12, 10, 4, 0),
				(2017, 12, 3, 2, 0),
				(2017, 12, 7, 9, 0),
				(2017, 12, 1, 6, 0),
				(2017, 12, 8, 10, 0),
				(2017, 12, 6, 5, 0)
		"""
        cursor.execute(sql)
    connection.commit()

finally:
    connection.close()
