USE fussballmarkt;
-- Step 1: Data Access Layer

DELIMITER //

DROP PROCEDURE IF EXISTS GetPlayerByID;

CREATE PROCEDURE GetPlayerByID(IN p_PlayerID INT)
BEGIN
    SELECT * FROM Spieler WHERE SpielerID = p_PlayerID;
END //

DELIMITER ;

CALL GetPlayerByID(1);

DELIMITER //

-- Step 2: Business Logic Layer

DROP PROCEDURE IF EXISTS TransferPlayer;

CREATE PROCEDURE TransferPlayer(
    IN p_SpielerID INT,
    IN p_VonVereinID INT,
    IN p_NachVereinID INT,
    IN p_Transfergebuehr DECIMAL(18, 2),
    IN p_Transferdatum DATE
)
BEGIN
    INSERT INTO Transfers (SpielerID, VonVereinID, NachVereinID, Transfergebuehr, Transferdatum)
    VALUES (p_SpielerID, p_VonVereinID, p_NachVereinID, p_Transfergebuehr, p_Transferdatum);

    UPDATE Spieler
    SET VereinsID = p_NachVereinID
    WHERE SpielerID = p_SpielerID;
END //

DELIMITER ;

CALL TransferPlayer(1, 1, 2, 5000000.00, '2024-05-21');

-- Step 3: Presentation Layer

CREATE OR REPLACE VIEW SpielerVerein AS
SELECT Spieler.Vorname, Spieler.Nachname, Vereine.Name AS Verein
FROM Spieler
INNER JOIN Vereine ON Spieler.VereinsID = Vereine.VereinsID;

SELECT * FROM SpielerVerein
