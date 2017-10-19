DELIMITER $$

CREATE PROCEDURE spInitSlackAccounts ()
BEGIN

	DROP TABLE IF EXISTS tbljoinTeamsUsers;
    DROP TABLE IF EXISTS tblSlackUsers;
    
    CREATE TABLE tblSlackUsers (
		id NVARCHAR(16) NOT NULL,
        username NVARCHAR(64) NOT NULL,
        realName NVARCHAR(64) NOT NULL,
        email NVARCHAR(64) NOT NULL,
        PRIMARY KEY (id)
    );
    
    CREATE TABLE tbljoinTeamsUsers (
		userId NVARCHAR(16) NOT NULL,
        espnTeamId INT NOT NULL,
        seasonId INT NOT NULL,
        divisionId BIGINT NOT NULL,
        FOREIGN KEY (userId) REFERENCES tblSlackUsers(id),
        FOREIGN KEY (seasonId) REFERENCES tblSeason(id),
        FOREIGN KEY (divisionId) REFERENCES tblDivision(id)
	);
    
    INSERT INTO tblSlackUsers (id, username, realName, email)
    VALUES
		('U7FJMTERZ', 'aciampi77', 'Adam Ciampi', 'aciampi77@gmail.com'),
        ('U79V5RHC2', 'danieltlawson17', 'Daniel Lawson', 'danieltlawson17@gmail.com'),
        ('U779JGZ8T', 'dbarnas91', 'Donny Barnas', 'dbarnas91@gmail.com'),
        ('U78S0SA5P', 'devgarvey', 'Devin Garvey', 'devgarvey@gmail.com'),
        ('U776JLZ1T', 'dlavigne18', 'Squiward', 'dlavigne18@yahoo.com'),
        ('U7GHH1FSA', 'grip.t', 'Timmy Grip', 'grip.t@husky.neu.edu'),
        ('U7A8JPJG6', 'hurleyr22', 'Ryan', 'hurleyr22@yahoo.com'),
        ('U7AJ55YSX', 'jbarnas93', 'Joe B', 'jbarnas93@gmail.com'),
        ('U7DNKBLPP', 'maclanewalsh', 'Maclane Walsh', 'maclanewalsh@gmail.com'),
        ('U78S15TPT', 'mdaley0477', 'Mark Daley', 'mdaley0477@gmail.com'),
        ('U7DHPR9RU', 'michaelrmiceli', 'Michael Miceli', 'michaelrmiceli@gmail.com'),
        ('U77D94YPN', 'psemeter', 'Patrick Semeter', 'psemeter@gmail.com'),
        ('U776K8TA9', 'rloftus23', 'King Joffrey', 'rloftus23@gmail.com'),
        ('U7A8GRNDU', 'rsulliva18', 'Ryan Sullivan', 'rsulliva18@gmail.com'),
        ('U779K39SM', 'sdherald', 'Scotty Herald', 'sdherald@yahoo.com'),
        ('U77UMES2J', 'seanmitsock', 'Sean Mitsock', 'seanmitsock@yahoo.com'),
        ('U7E47R25B', 'shrinjoy', 'Shrinjoy', 'shrinjoy@bu.edu');
	
    INSERT INTO tbljoinTeamsUsers (userId, espnTeamId, seasonId, divisionId)
	VALUES
		-- Map 2016 ESPN teams to their slack owners
		('U7FJMTERZ', 1, 2016, 1363114),
        ('U79V5RHC2', 9, 2016, 1363114),
        ('U779JGZ8T', 4, 2016, 1363114),
        ('U78S0SA5P', 2, 2016, 1363114),
        ('U7GHH1FSA', 3, 2016, 1363114),
        ('U7AJ55YSX', 10, 2016, 1363114),
        ('U7E47R25B', 5, 2016, 1363114),
        
        -- Map 2016 Yahoo teams to their slack owners
        ('U776JLZ1T', 4, 2016, 1372219),
        ('U7DNKBLPP', 1, 2016, 1372219),
        ('U78S15TPT', 3, 2016, 1372219),
        ('U7DHPR9RU', 2, 2016, 1372219),
        ('U77D94YPN', 6, 2016, 1372219),
        ('U776K8TA9', 8, 2016, 1372219),
        ('U7A8GRNDU', 9, 2016, 1372219),
        ('U779K39SM', 7, 2016, 1372219),
        ('U77UMES2J', 5, 2016, 1372219),
        
        -- Map 2017 ESPN teams to their slack owners
		('U7FJMTERZ', 1, 2017, 1363114),
        ('U79V5RHC2', 9, 2017, 1363114),
        ('U779JGZ8T', 4, 2017, 1363114),
        ('U78S0SA5P', 2, 2017, 1363114),
        ('U7GHH1FSA', 3, 2017, 1363114),
        ('U7AJ55YSX', 10, 2017, 1363114),
        ('U7E47R25B', 5, 2017, 1363114),
        ('U78S15TPT', 8, 2017, 1363114),
        
        -- Map 2017 Yahoo teams to their slack owners
        ('U776JLZ1T', 4, 2017, 1372219),
        ('U7DNKBLPP', 1, 2017, 1372219),
        ('U7A8JPJG6', 3, 2017, 1372219),
        ('U7DHPR9RU', 2, 2017, 1372219),
        ('U77D94YPN', 6, 2017, 1372219),
        ('U776K8TA9', 8, 2017, 1372219),
        ('U7A8GRNDU', 9, 2017, 1372219),
        ('U779K39SM', 7, 2017, 1372219),
        ('U77UMES2J', 5, 2017, 1372219);
    
END $$
DELIMITER ;