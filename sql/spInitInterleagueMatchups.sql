DELIMITER $$

CREATE PROCEDURE spInitInterleagueMatchups(IN season INT)
BEGIN

    -- Initialize the interleague matchups table
    CREATE TABLE IF NOT EXISTS tblInterleagueMatchups (
        seasonId INT NOT NULL,
        weekid INT NOT NULL,
        yahooTeamEspnId INT NOT NULL,
        espnTeamEspnId INT NOT NULL,
        homeDivisionId BIGINT NOT NULL,
        awayDivisionId BIGINT NOT NULL,
        FOREIGN KEY (seasonId) REFERENCES tblSeason(id),
        FOREIGN KEY (weekId) REFERENCES tblWeek(id),
        FOREIGN KEY (homeDivisionId) REFERENCES tblDivision(id),
        FOREIGN KEY (awayDivisionId) REFERENCES tblDivision(id)
	);

    -- Setup a temp table to insert records into for further action
    DROP TEMPORARY TABLE IF EXISTS tblTempInterleagueMatchups;

    CREATE TEMPORARY TABLE tblTempInterleagueMatchups (
        seasonId INT NOT NULL,
        weekid INT NOT NULL,
        yahooTeamEspnId INT NOT NULL,
        espnTeamEspnId INT NOT NULL,
        homeDivisionId BIGINT NOT NULL,
        awayDivisionId BIGINT NOT NULL
    );

    -- Get the ids of the two divisions
    SELECT id INTO @yahooDivisionId FROM tblDivision WHERE isYahoo = 1 LIMIT 1;
    SELECT id INTO @espnDivisionId FROM tblDivision WHERE isYahoo = 0 LIMIT 1;

    -- Populate the tables with our static matchup data
    INSERT INTO tblTempInterleagueMatchups (
        seasonId,
        weekId,
        yahooTeamEspnId,
        espnTeamEspnId,
        homeDivisionId,
        awayDivisionId
    )
    VALUES
        -- Week 3 Inter-league matchups 2016
        -- Yahoo league is home
        (2016, 3, 1, 9, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 3, 2, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 10, 5, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 4, 10, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 7, 8, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 2, 4, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 8, 1, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 9, 3, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 6, 6, @yahooDivisionId, @espnDivisionId),
        (2016, 3, 5, 7, @yahooDivisionId, @espnDivisionId),

        -- Week 6 Inter-league matchups 2016
        -- ESPN league is home
        (2016, 6, 1, 2, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 3, 9, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 10, 10, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 4, 5, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 7, 4, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 2, 8, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 8, 3, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 9, 1, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 6, 7, @espnDivisionId, @yahooDivisionId),
        (2016, 6, 5, 6, @espnDivisionId, @yahooDivisionId),

        -- Week 9 Inter-league matchups 2016
        -- Yahoo league is home
        (2016, 9, 1, 5, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 3, 10, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 10, 8, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 4, 4, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 7, 1, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 2, 3, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 8, 6, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 9, 7, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 6, 9, @yahooDivisionId, @espnDivisionId),
        (2016, 9, 5, 2, @yahooDivisionId, @espnDivisionId),

        -- Week 12 Inter-league matchups 2016
        -- ESPN league is home
        (2016, 12, 1, 10, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 3, 5, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 10, 4, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 4, 8, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 7, 3, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 2, 1, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 8, 7, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 9, 6, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 6, 2, @espnDivisionId, @yahooDivisionId),
        (2016, 12, 5, 9, @espnDivisionId, @yahooDivisionId),

        -- Week 3 Inter-league matchups 2017
        -- Yahoo league is home
        (2017, 3, 2, 5, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 4, 10, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 5, 1, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 9, 3, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 10, 8, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 3, 7, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 7, 2, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 1, 4, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 8, 6, @yahooDivisionId, @espnDivisionId),
        (2017, 3, 6, 9, @yahooDivisionId, @espnDivisionId),

        -- Week 6 Inter-league matchups 2017
        -- ESPN league is home
        (2017, 6, 2, 10, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 4, 5, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 5, 3, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 9, 1, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 10, 7, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 3, 8, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 7, 4, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 1, 2, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 8, 9, @espnDivisionId, @yahooDivisionId),
        (2017, 6, 6, 6, @espnDivisionId, @yahooDivisionId),

        -- Week 9 Inter-league matchups 2017
        -- Yahoo league is home
        (2017, 9, 2, 1, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 4, 3, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 5, 8, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 9, 7, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 10, 2, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 3, 4, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 7, 6, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 1, 9, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 8, 5, @yahooDivisionId, @espnDivisionId),
        (2017, 9, 6, 10, @yahooDivisionId, @espnDivisionId),

        -- Week 12 Inter-league matchups 2017
        -- ESPN is home
        (2017, 12, 2, 3, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 4, 1, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 5, 7, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 9, 8, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 10, 4, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 3, 2, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 7, 9, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 1, 6, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 8, 10, @espnDivisionId, @yahooDivisionId),
        (2017, 12, 6, 5, @espnDivisionId, @yahooDivisionId),

        -- Week 3 Inter-league matchups 2018
        -- Yahoo is home
        (2018, 3, 4, 6, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 5, 10, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 9, 4, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 3, 5, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 2, 7, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 8, 2, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 10, 9, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 6, 8, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 7, 3, @yahooDivisionId, @espnDivisionId),
        (2018, 3, 1, 1, @yahooDivisionId, @espnDivisionId),

        -- Week 6 Inter-league matchups 2018
        -- ESPN is home
        (2018, 6, 4, 10, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 5, 6, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 9, 5, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 3, 4, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 2, 2, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 8, 7, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 10, 8, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 6, 9, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 7, 1, @espnDivisionId, @yahooDivisionId),
        (2018, 6, 1, 3, @espnDivisionId, @yahooDivisionId),

        -- Week 9 Inter-league matchups 2018
        -- Yahoo is home
        (2018, 9, 4, 4, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 5, 5, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 9, 7, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 3, 2, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 2, 9, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 8, 8, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 10, 3, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 6, 1, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 7, 6, @yahooDivisionId, @espnDivisionId),
        (2018, 9, 1, 10, @yahooDivisionId, @espnDivisionId),

        -- Week 12 Inter-league matchups 2018
        -- ESPN is home
        (2018, 12, 4, 5, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 5, 4, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 9, 2, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 3, 7, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 2, 8, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 8, 9, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 10, 1, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 6, 3, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 7, 10, @yahooDivisionId, @espnDivisionId),
        (2018, 12, 1, 6, @yahooDivisionId, @espnDivisionId);

    -- Purge previous records from the year being updated
    DELETE FROM tblInterleagueMatchups WHERE seasonId = season;

    -- Write the new matchups for that year
    INSERT INTO tblInterleagueMatchups (
        seasonId,
        weekId,
        yahooTeamEspnId,
        espnTeamEspnId,
        homeDivisionId,
        awayDivisionId
    )
    SELECT seasonId, weekId, yahooTeamEspnId, espnTeamEspnId, homeDivisionId, awayDivisionId
    FROM tblTempInterleagueMatchups
    WHERE seasonId = season;

END $$
DELIMITER ;