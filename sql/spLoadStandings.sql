DELIMITER $$

CREATE PROCEDURE spLoadStandings ()
BEGIN

    CREATE TEMPORARY TABLE IF NOT EXISTS tblTempStandings (
        id INT NOT NULL,
        location NVARCHAR(32) NOT NULL,
        nickname NVARCHAR(32) NOT NULL,
        pointsFor FLOAT NOT NULL,
        pointsAgainst FLOAT NOT NULL
    );

    TRUNCATE TABLE tblTempStandings;

    SELECT id INTO @currentWeekId FROM tblWeek WHERE isCurrent = 1 LIMIT 1;

    INSERT INTO tblTempStandings (id, location, nickname, pointsFor, pointsAgainst)
	SELECT
	    t.id,
        t.location,
        t.nickname,
        CASE WHEN (t.id = m.homeTeamId) THEN m.homeTeamPoints ELSE m.awayTeamPoints END AS pointsFor,
        CASE WHEN (t.id = m.homeTeamId) THEN m.awayTeamPoints ELSE m.homeTeamPoints END AS pointsAgainst
	FROM tblTeam t
	INNER JOIN tblMatchup m ON t.id = m.homeTeamId OR t.id = m.awayTeamId
	INNER JOIN tblSeason s ON s.id = t.seasonId
	INNER JOIN tblWeek w ON w.id = m.weekId
	WHERE s.isCurrent = 1 AND w.Id < @currentWeekId;

	SELECT
	    id,
	    location,
	    nickname,
	    SUM(CASE WHEN pointsFor > pointsAgainst THEN 1 ELSE 0 END) AS wins,
	    SUM(CASE WHEN pointsFor < pointsAgainst THEN 1 ELSE 0 END) AS losses,
	    SUM(CASE WHEN pointsFor = pointsAgainst THEN 1 ELSE 0 END) AS ties,
	    ROUND(SUM(pointsFor), 2) AS pointsFor,
	    ROUND(SUM(pointsAgainst), 2) AS pointsAgainst
	FROM tblTempStandings
    GROUP BY id, location, nickname
    ORDER BY wins DESC, ties DESC, pointsFor DESC;

END $$
DELIMITER ;
