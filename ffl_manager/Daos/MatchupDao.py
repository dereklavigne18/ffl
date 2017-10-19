from Daos.BaseDao import BaseDao


class MatchupDao(BaseDao):

    def loadInterleague(self, seasonId = None):
        sql = '''
            SELECT
                seasonId,
                weekId,
                yahooTeamEspnId,
                espnTeamEspnId,
                homeDivisionId,
                awayDivisionId
            FROM tblInterleagueMatchups
        '''
        if seasonId:
            sql += 'WHERE seasonId = ' + str(seasonId)

        return self.execute(sql)

    def save(self, matchups):
        sql = '''
            CREATE TEMPORARY TABLE IF NOT EXISTS tblTempMatchup (
                seasonId INT NOT NULL,
                weekId INT NOT NULL,
                homeTeamId INT NOT NULL,
                homeTeamPoints FLOAT NULL,
                awayTeamId INT NOT NULL,
                awayTeamPoints FLOAT NULL
            );

            TRUNCATE TABLE tblTempMatchup;

            INSERT INTO tblTempMatchup (
                seasonId,
                weekId,
                homeTeamId,
                homeTeamPoints,
                awayTeamId,
                awayTeamPoints
            ) VALUES {};

            UPDATE tblMatchup m
            INNER JOIN tblTempMatchup tm
                ON m.seasonId = tm.seasonId AND m.weekId = tm.weekId AND m.homeTeamId = tm.homeTeamId
            SET
                m.homeTeamPoints = tm.homeTeamPoints,
                m.awayTeamId = tm.awayTeamId,
                m.awayTeamPoints = tm.awayTeamPoints;

            INSERT INTO tblMatchup (
                seasonId,
                weekId,
                homeTeamId,
                homeTeamPoints,
                awayTeamId,
                awayTeamPoints
            ) SELECT
                tm.seasonId,
                tm.weekId,
                tm.homeTeamId,
                tm.homeTeamPoints,
                tm.awayTeamId,
                tm.awayTeamPoints
            FROM tblTempMatchup tm
            LEFT JOIN tblMatchup m
                ON m.seasonId = tm.seasonId AND m.weekId = tm.weekId AND m.homeTeamId = tm.homeTeamId
            WHERE m.seasonId IS NULL AND m.weekId IS NULL AND m.homeTeamId IS NULL;

            DROP TEMPORARY TABLE tblTempMatchup;
        '''

        values = ''
        for matchup in matchups:
            values += '({}, {}, {}, {}, {}, {}),'.format(
                matchup.seasonId,
                matchup.weekId,
                matchup.homeTeam.id,
                matchup.homeTeamPoints,
                matchup.awayTeam.id,
                matchup.awayTeamPoints
            )
        values = values.rstrip(',')

        sql = sql.format(values)
        self.execute(sql)