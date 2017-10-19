DELIMITER $$

CREATE PROCEDURE spIncrementWeek ()
BEGIN

    SELECT id INTO @currentWeekId FROM tblWeek WHERE isCurrent = 1 LIMIT 1;

    UPDATE tblWeek
    SET isCurrent = CASE WHEN (id = @currentWeekId + 1) THEN 1 ELSE 0 END;

END $$
DELIMITER ;