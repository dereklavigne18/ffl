DELIMITER $$

CREATE PROCEDURE spLoadMatchups ()
BEGIN

		CREATE TEMPORARY TABLE IF NOT EXISTS tblTempScores (
        id INT NOT NULL,
        pointsFor FLOAT NOT NULL,
        pointsAgainst FLOAT NOT NULL
    );

    TRUNCATE TABLE tblTempScores;

    SELECT id INTO @currentWeekId FROM tblWeek WHERE isCurrent = 1 LIMIT 1;

    INSERT INTO tblTempScores (id, pointsFor, pointsAgainst)
	SELECT
	    t.id,
        CASE WHEN (t.id = m.homeTeamId) THEN m.homeTeamPoints ELSE m.awayTeamPoints END AS pointsFor,
        CASE WHEN (t.id = m.homeTeamId) THEN m.awayTeamPoints ELSE m.homeTeamPoints END AS pointsAgainst
	FROM tblTeam t
	INNER JOIN tblMatchup m ON t.id = m.homeTeamId OR t.id = m.awayTeamId
	INNER JOIN tblSeason s ON s.id = t.seasonId
	INNER JOIN tblWeek w ON w.id = m.weekId
	WHERE s.isCurrent = 1 AND w.Id < @currentWeekId;


    CREATE TEMPORARY TABLE IF NOT EXISTS tblTempHomeStandings (
        id INT NOT NULL,
        rank INT NOT NULL,
        wins INT NOT NULL,
        losses INT NOT NULL,
        ties INT NOT NULL,
        pointsFor FLOAT NOT NULL,
        pointsAgainst FLOAT NOT NULL
    );

    TRUNCATE TABLE tblTempHomeStandings;

    SET @rank = 0;

	INSERT INTO tblTempHomeStandings (id, rank, wins, losses, ties, pointsFor, pointsAgainst)
	SELECT
		s.id,
        (@rank := @rank + 1) AS rank,
        s.wins,
        s.losses,
        s.ties,
        s.pointsFor,
        s.pointsAgainst
	FROM (
		SELECT
			id,
			SUM(CASE WHEN pointsFor > pointsAgainst THEN 1 ELSE 0 END) AS wins,
			SUM(CASE WHEN pointsFor < pointsAgainst THEN 1 ELSE 0 END) AS losses,
			SUM(CASE WHEN pointsFor = pointsAgainst THEN 1 ELSE 0 END) AS ties,
			ROUND(SUM(pointsFor), 2) AS pointsFor,
			ROUND(SUM(pointsAgainst), 2) AS pointsAgainst
		FROM tblTempScores
		GROUP BY id
		ORDER BY wins DESC, ties DESC, pointsFor DESC
	) as s;

    CREATE TEMPORARY TABLE tblTempAwayStandings LIKE tblTempHomeStandings;

    INSERT INTO tblTempAwayStandings
    SELECT * FROM tblTempHomeStandings;

    SELECT
       home.id AS homeId,
       homeStanding.rank AS homeRank,
       home.location AS homeLocation,
       home.nickname AS homeNickname,
       home.abbreviation AS homeAbbreviation,
       home.ownerFirstName AS homeOwnerFirstName,
       home.ownerLastName AS homeOwnerLastName,
       homeStanding.wins AS homeWins,
       homeStanding.losses AS homeLosses,
       homeStanding.ties AS homeTies,
       homeStanding.pointsFor AS homePointsFor,
       homeUser.id AS homeUserId,
       homeUser.username AS homeUserUsername,
       homeUser.realName AS homeUserRealName,
       homeUser.email AS homeUserEmail,
       away.id AS awayId,
       awayStanding.rank AS awayRank,
       away.location AS awayLocation,
       away.nickname AS awayNickname,
       away.abbreviation AS awayAbbreviation,
       away.ownerFirstName AS awayOwnerFirstName,
       away.ownerLastName AS awayOwnerLastName,
       awayStanding.wins AS awayWins,
       awayStanding.losses AS awayLosses,
       awayStanding.ties AS awayTies,
       awayStanding.pointsFor AS awayPointsFor,
       awayUser.id AS awayUserId,
       awayUser.username AS awayUserUsername,
       awayUser.realName AS awayUserRealName,
       awayUser.email AS awayUserEmail
    FROM tblMatchup m
    INNER JOIN tblWeek w ON w.id = m.weekId
    INNER JOIN tblSeason s ON s.id = m.seasonId
    INNER JOIN tblTeam home ON home.id = m.homeTeamId
    INNER JOIN tblTeam away ON away.id = m.awayTeamId
    INNER JOIN tblTempHomeStandings homeStanding ON home.id = homeStanding.id
    INNER JOIN tblTempAwayStandings awayStanding ON away.id = awayStanding.id
    LEFT JOIN tbljoinTeamsUsers homeUserJoin ON home.espnId = homeUserJoin.espnTeamId AND home.divisionId = homeUserJoin.divisionId AND home.seasonId = homeUserJoin.seasonId
    LEFT JOIN tbljoinTeamsUsers awayUserJoin ON away.espnId = awayUserJoin.espnTeamId AND away.divisionId = awayUserJoin.divisionId AND away.seasonId = awayUserJoin.seasonId
    LEFT JOIN tblSlackUsers homeUser ON homeUserJoin.userId = homeUser.id
    LEFT JOIN tblSlackUsers awayUser ON awayUserJoin.userId = awayUser.id
    WHERE w.isCurrent = 1 AND s.isCurrent = 1;

    DROP TEMPORARY TABLE tblTempAwayStandings;
    DROP TEMPORARY TABLE tblTempHomeStandings;


END $$
DELIMITER ;
