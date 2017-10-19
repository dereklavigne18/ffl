import pymysql
import requests


def save_league_information(yahoo_league_id, espn_league_id):
    years = [2016, 2017]

    # create_teams_table()
    create_matchups_table()

    for year in years:
        yahoo_league = load_league_data(yahoo_league_id, year)
        espn_league = load_league_data(espn_league_id, year)

        # save_teams(year, yahoo_league, espn_league)

        matchups = []
        teams = yahoo_league['teams'] + espn_league['teams']
        for team in teams:
            for schedule_item in team['scheduleItems']:
                item = schedule_item['matchups'][0]
                item['week'] = schedule_item['matchupPeriodId']
                matchups.append(item)

        save_division_matchups(year, matchups)
        save_interleague_matchups(year, yahoo_league, espn_league)


def save_interleague_matchups(year, yahoo_league, espn_league):
    sql = """
		INSERT INTO tblMatchups (
			`week`,
			`season`,
			`home_team_id`,
			`home_team_division`,
			`home_team_points`,
			`away_team_id`,
			`away_team_division`,
			`away_team_points`
		) VALUES
	"""

    interleague_matchups = load_interleague_matchups(year)
    for matchup in interleague_matchups:
        print(matchup['homeDivision'])
        home_division = 1 if matchup['homeDivision'] else 0
        away_division = 0 if home_division else 1
        print(home_division)

        yahoo_team = find_where(yahoo_league['teams'], ['teamId'], matchup['yahooTeamId'])
        espn_team = find_where(espn_league['teams'], ['teamId'], matchup['espnTeamId'])

        yahoo_matchup = find_where(yahoo_team['scheduleItems'], ['matchupPeriodId'], matchup['week'])
        espn_matchup = find_where(espn_team['scheduleItems'], ['matchupPeriodId'], matchup['week'])
        yahoo_score = yahoo_matchup['matchups'][0]['homeTeamScores'][0]
        espn_score = espn_matchup['matchups'][0]['homeTeamScores'][0]

        if home_division:
            home_team_id = matchup['yahooTeamId']
            away_team_id = matchup['espnTeamId']
            home_score = yahoo_score
            away_score = espn_score
        else:
            home_team_id = matchup['espnTeamId']
            away_team_id = matchup['yahooTeamId']
            home_score = espn_score
            away_score = yahoo_score

        sql += ('(' +
                str(matchup['week']) + ', ' +
                str(year) + ', ' +
                str(home_team_id) + ', ' +
                str(home_division) + ', ' +
                str(round(home_score, 1)) + ', ' +
                str(away_team_id) + ', ' +
                str(away_division) + ', ' +
                str(round(away_score, 1)) +
                '), ')

    sql = sql.rstrip(', ')
    execute_query(sql)


def save_division_matchups(year, matchups):
    sql = """
		INSERT INTO tblMatchups (
			`week`,
			`season`,
			`home_team_id`,
			`home_team_division`,
			`home_team_points`,
			`away_team_id`,
			`away_team_division`,
			`away_team_points`
		) VALUES 
	"""

    matchup_list = []
    for matchup in matchups:
        if matchup['week'] % 3 == 0 or matchup['week'] > 13:
            continue

        home_team_division = 1 if matchup['homeTeam']['division']['divisionName'] == 'Yahoo' else 0
        away_team_division = 1 if matchup['awayTeam']['division']['divisionName'] == 'Yahoo' else 0

        if matchup_exists(matchup['homeTeamId'], home_team_division, year, matchup['week'], matchup_list):
            continue

        matchup_list.append({
            'home_id': matchup['homeTeamId'],
            'home_division': home_team_division,
            'year': year,
            'week': matchup['week']
        })
        sql += ('(' +
                str(matchup['week']) + ', ' +
                str(year) + ', ' +
                str(matchup['homeTeamId']) + ', ' +
                str(home_team_division) + ', ' +
                str(round(matchup['homeTeamScores'][0], 1)) + ', ' +
                str(matchup['awayTeamId']) + ', ' +
                str(away_team_division) + ', ' +
                str(round(matchup['awayTeamScores'][0], 1)) +
                '), ')
    sql = sql.rstrip(', ')
    execute_query(sql)


def matchup_exists(home_id, home_division, year, week, matchups):
    for matchup in matchups:
        if matchup['home_id'] == home_id and matchup['home_division'] == home_division and matchup['year'] == year and \
                        matchup['week'] == week:
            return True
    return False


def save_teams(year, yahoo_league, espn_league):
    teams = yahoo_league['teams'] + espn_league['teams']

    sql = """
		INSERT INTO tblTeams (
			`id`,
            `year`,
			`nickname`,
			`location`,
			`abbreviation`,
			`division_id`,
			`waiver_rank`,
			`owner_first_name`,
			`owner_last_name`,
			`photo_url`,
			`is_manager`
		) VALUES
	"""
    for team in teams:
        division_name = team['division']['divisionName']
        division_id = 1 if division_name == 'Yahoo' else 0

        team_owner = None
        for owner in team['owners']:
            if owner['primaryOwner']:
                team_owner = owner

        is_manager = 1 if team_owner['leagueManager'] else 0
        try:
            logo_url = team['logoUrl']
        except KeyError as e:
            logo_url = team_owner['photoUrl']

        sql += (
            "(" +
            str(team['teamId']) + ", " +
            str(year) + ", " +
            "'" + team['teamNickname'] + "', " +
            "'" + team['teamLocation'] + "', " +
            "'" + team['teamAbbrev'] + "', " +
            str(division_id) + ", " +
            str(team['waiverRank']) + ", " +
            "'" + team_owner['firstName'] + "', " +
            "'" + team_owner['lastName'] + "', " +
            "'" + logo_url + "', " +
            str(is_manager) +
            "), "
        )

    sql = sql.rstrip(', ')
    print(sql)
    # execute_query(sql)


def get_connection():
    connection = pymysql.connect(
        host='localhost',
        user='squidward',
        password='tenticles',
        db='ffl',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    return connection


def execute_query(sql):
    data = None
    connection = get_connection()

    try:
        with connection.cursor() as cursor:
            cursor.execute(sql)
            data = cursor.fetchall()
            connection.commit()

    finally:
        connection.close()
        return data


def load_interleague_matchups(year):
    sql = """
		SELECT *
		FROM tblInterleagueMatchups
        WHERE year = """ + str(year)
    return execute_query(sql)


def load_league_data(league_id, year):
    url = 'http://games.espn.com/ffl/api/v2/teams?leagueId=' + str(league_id) + '&seasonId=' + str(year)
    response = requests.get(url)
    return response.json()


def find_where(array, attrs, val):
    for item in array:
        curr = item
        for attr in attrs:
            curr = curr[attr]
        if curr == val:
            return item
    return None


def create_teams_table():
    sql = """
		CREATE TABLE IF NOT EXISTS `tblTeams` (
			`id` INT NOT NULL,
            `year` INT NOT NULL,
			`nickname` VARCHAR(256) NOT NULL,
			`location` VARCHAR(256) NOT NULL,
			`abbreviation` VARCHAR(8) NOT NULL,
			`division_id` BIT NOT NULL,
			`waiver_rank` INT NOT NULL,
			`owner_first_name` VARCHAR(256) NOT NULL,
			`owner_last_name` VARCHAR(256) NOT NULL,
			`photo_url` VARCHAR(2048) NOT NULL,
			`is_manager` BIT NOT NULL
		);
	"""
    execute_query(sql)


def create_matchups_table():
    sql = """
		CREATE TABLE IF NOT EXISTS `tblMatchups` (
			`week` INT NOT NULL,
			`season` INT NOT NULL,
			`home_team_id` INT NOT NULL,
			`home_team_division` BIT NOT NULL,
			`home_team_points` DOUBLE(7, 2),
			`away_team_id` INT NOT NULL,
			`away_team_division` BIT NOT NULL,
			`away_team_points` DOUBLE(7, 2)
		);
	"""
    execute_query(sql)


if __name__ == '__main__':
    YAHOO_LEAGUE_ID = 1372219
    ESPN_LEAGUE_ID = 1363114

    save_league_information(YAHOO_LEAGUE_ID, ESPN_LEAGUE_ID)
