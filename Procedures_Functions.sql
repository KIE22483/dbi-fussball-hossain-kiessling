USE fussballmarkt;

DELIMITER //

DROP FUNCTION IF EXISTS SearchPlayer;
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


DROP PROCEDURE IF EXISTS AddPlayer;
DELIMITER //

CREATE PROCEDURE AddPlayer(
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN position VARCHAR(50),
    IN birth_date DATE,
    IN nationality VARCHAR(50),
    IN market_value DECIMAL(18, 2),
    IN club_id INT
)
BEGIN
    DECLARE player_count INT;
    
    SELECT COUNT(*)
    INTO player_count
    FROM Spieler
    WHERE Vorname = first_name AND Nachname = last_name AND VereinsID = club_id;
    
    -- If player doesn't exist, insert new player
    IF player_count = 0 THEN
        INSERT INTO Spieler (Vorname, Nachname, Position, Geburtsdatum, Nationalität, Marktwert, VereinsID)
        VALUES (first_name, last_name, position, birth_date, nationality, market_value, club_id);
        SELECT 'Player added successfully';
    ELSE
        SELECT 'Player already exists';
    END IF;
END //

DELIMITER ;

-- CALL AddPlayer('SIUUU', 'Mbappé', 'Forward', '1998-12-20', 'French', 150000000.00, 2);

SELECT * FROM Spieler;

DELIMITER //

DELIMITER //

DROP PROCEDURE IF EXISTS DeletePlayer;

CREATE PROCEDURE DeletePlayer(
    IN player_id INT
)
BEGIN
    DECLARE player_count INT;
    
    SELECT COUNT(*)
    INTO player_count
    FROM Spieler
    WHERE SpielerID = player_id;
    
    -- If player exists, delete the player
    IF player_count > 0 THEN
        DELETE FROM Spieler
        WHERE SpielerID = player_id;
        SELECT 'Player deleted successfully';
    ELSE
        SELECT 'Player not found';
    END IF;
END //

DELIMITER ;

-- CALL DeletePlayer(7);

SELECT * From Spieler;

DELIMITER //

DROP PROCEDURE IF EXISTS EditPlayer;

CREATE PROCEDURE EditPlayer(
    IN player_id INT,
    IN new_first_name VARCHAR(50),
    IN new_last_name VARCHAR(50),
    IN new_position VARCHAR(50),
    IN new_birth_date DATE,
    IN new_nationality VARCHAR(50),
    IN new_market_value DECIMAL(18, 2),
    IN new_club_id INT
)
BEGIN
    DECLARE player_count INT;
    
    -- Check if the player exists
    SELECT COUNT(*)
    INTO player_count
    FROM Spieler
    WHERE SpielerID = player_id;
    
    -- If player exists, update the player details
    IF player_count > 0 THEN
        UPDATE Spieler
        SET Vorname = new_first_name,
            Nachname = new_last_name,
            Position = new_position,
            Geburtsdatum = new_birth_date,
            Nationalität = new_nationality,
            Marktwert = new_market_value,
            VereinsID = new_club_id
        WHERE SpielerID = player_id;
        SELECT 'Player updated successfully';
    ELSE
        SELECT 'Player not found';
    END IF;
END //

DELIMITER ;

-- Example usage
CALL EditPlayer(1, 'Spieler', 'Eins', 'Wird zu diesem hier', '1998-12-20', 'French', 160000000.00, 2);

SELECT * FROM Spieler;

