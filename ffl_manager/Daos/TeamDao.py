import json

from Daos.BaseDao import BaseDao


class TeamDao(BaseDao):

    def load(self, seasonId = None):
        sql = '''
          SELECT
            id,
            espnId,
            seasonId,
            location,
            nickname,
            abbreviation,
            divisionId,
            ownerFirstName,
            ownerLastName
          FROM tblTeam
        '''
        if seasonId:
            sql += 'WHERE seasonId = ' + str(seasonId)

        return self.execute(sql)

    def save(self, teams):
        sql = '''
            CREATE TEMPORARY TABLE IF NOT EXISTS tblTempTeam (
                espnId INT NOT NULL,
                seasonId INT NOT NULL,
                location NVARCHAR(32) NOT NULL,
                nickname NVARCHAR(32) NOT NULL,
                abbreviation NVARCHAR(8) NOT NULL,
                divisionId BIGINT NOT NULL,
                ownerFirstName NVARCHAR(64) NOT NULL,
                ownerLastName NVARCHAR(64) NOT NULL
            );

            TRUNCATE TABLE tblTempTeam;

            INSERT INTO tblTempTeam (
                espnId,
                seasonId,
                location,
                nickname,
                abbreviation,
                divisionId,
                ownerFirstName,
                ownerLastName
            ) VALUES {};

            UPDATE tblTeam t
            INNER JOIN tblTempTeam tt
                ON t.espnId = tt.espnId AND t.seasonId = tt.seasonId AND t.divisionId = tt.divisionId
            SET
                t.location = tt.location,
                t.nickname = tt.nickname,
                t.abbreviation = tt.abbreviation,
                t.ownerFirstName = tt.ownerFirstName,
                t.ownerLastName = tt.ownerLastName;

            INSERT INTO tblTeam (
                espnId,
                seasonId,
                location,
                nickname,
                abbreviation,
                divisionId,
                ownerFirstName,
                ownerLastName
            ) SELECT
                tt.espnId,
                tt.seasonId,
                tt.location,
                tt.nickname,
                tt.abbreviation,
                tt.divisionId,
                tt.ownerFirstName,
                tt.ownerLastName
            FROM tblTempTeam tt
            LEFT JOIN tblTeam t
                ON tt.espnId = t.espnId AND tt.seasonId = t.seasonId AND tt.divisionId = t.divisionId
            WHERE t.espnId IS NULL AND t.seasonId IS NULL AND t.divisionId IS NULL;

            DROP TEMPORARY TABLE tblTempTeam;
        '''

        values = ''
        for team in teams:
            values += '({}, {}, {}, {}, {}, {}, {}, {}),'.format(
                team.espnId,
                team.seasonId,
                json.dumps(team.location),
                json.dumps(team.nickname),
                json.dumps(team.abbreviation),
                team.divisionId,
                json.dumps(team.ownerFirstName),
                json.dumps(team.ownerLastName)
            )
        values = values.rstrip(',')

        sql = sql.format(values)
        self.execute(sql)
