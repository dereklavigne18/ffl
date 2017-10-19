DELIMITER $$

CREATE PROCEDURE spInit(
	IN currentSeason INT,
	IN currentWeek INT
)
BEGIN

	-- Create the division table
	CREATE TABLE IF NOT EXISTS tblDivision (
		id BIGINT NOT NULL,
		isYahoo TINYINT(1),
		PRIMARY KEY (id)
	);

	INSERT INTO tblDivision (id, isYahoo)
	VALUES
		(1372219, 1),
		(1363114, 0);

	-- Create the season listing.
	CREATE TABLE IF NOT EXISTS tblSeason (
		id INT NOT NULL,
		isCurrent TINYINT(1) NOT NULL,
		PRIMARY KEY (id)
	);

	INSERT INTO tblSeason (id, isCurrent)
	VALUES
		(2016, 2016 = currentSeason),
		(2017, 2017 = currentSeason);

	-- Create the week listing.
	CREATE TABLE IF NOT EXISTS tblWeek (
		id INT NOT NULL,
		isCurrent TINYINT(1) NOT NULL,
		PRIMARY KEY (id)
	);

	INSERT INTO tblWeek (id, isCurrent)
	VALUES
		(1, 1 = currentWeek),
		(2, 2 = currentWeek),
		(3, 3 = currentWeek),
		(4, 4 = currentWeek),
		(5, 5 = currentWeek),
		(6, 6 = currentWeek),
		(7, 7 = currentWeek),
		(8, 8 = currentWeek),
		(9, 9 = currentWeek),
		(10, 10 = currentWeek),
		(11, 11 = currentWeek),
		(12, 12 = currentWeek),
		(13, 13 = currentWeek),
		(14, 14 = currentWeek),
		(15, 15 = currentWeek),
		(16, 16 = currentWeek),
		(17, 17 = currentWeek);

	-- Create the teams table
	CREATE TABLE IF NOT EXISTS tblTeam (
		id INT NOT NULL AUTO_INCREMENT,
		espnId INT NOT NULL,
		seasonId INT NOT NULL,
		location NVARCHAR(32) NOT NULL,
		nickname NVARCHAR(32) NOT NULL,
		abbreviation NVARCHAR(8) NOT NULL,
		divisionId BIGINT NOT NULL,
		ownerFirstName NVARCHAR(64) NOT NULL,
		ownerLastName NVARCHAR(64) NOT NULL,
		PRIMARY KEY (id),
		FOREIGN KEY (seasonId) REFERENCES tblSeason(id),
		FOREIGN KEY (divisionId) REFERENCES tblDivision(id)
	);

	-- Create the matchups table to track the results of each week
	CREATE TABLE IF NOT EXISTS tblMatchup (
 		id INT NOT NULL AUTO_INCREMENT,
 		seasonId INT NOT NULL,
 		weekId INT NOT NULL,
 		homeTeamId INT NOT NULL,
 		homeTeamPoints FLOAT NULL,
 		awayTeamId INT NOT NULL,
 		awayTeamPoints FLOAT NULL,
 		PRIMARY KEY (id),
 		FOREIGN KEY (seasonId) REFERENCES tblSeason(id),
 		FOREIGN KEY (weekId) REFERENCES tblWeek(id),
 		FOREIGN KEY (homeTeamId) REFERENCES tblTeam(id),
 		FOREIGN KEY (awayTeamId) REFERENCES tblTeam(id)
 	);

END $$
DELIMITER ;