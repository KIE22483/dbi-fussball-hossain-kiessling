USE fussballmarkt;

DELIMITER //

CREATE FUNCTION SearchPlayer(last_name VARCHAR(50))
RETURNS VARCHAR(255)
READS SQL DATA
BEGIN
    DECLARE player_info VARCHAR(255);
    
    SELECT CONCAT('Player found: ', Vorname, ' ', Nachname, ', Position: ', Position, ', Geburtsdatum: ', Geburtsdatum)
    INTO player_info
    FROM Spieler
    WHERE Nachname = last_name;
    
    IF player_info IS NULL THEN
        RETURN 'Player not found';
    ELSE
        RETURN player_info;
    END IF;
END //

DELIMITER ;

SELECT SearchPlayer('Ronaldo');
