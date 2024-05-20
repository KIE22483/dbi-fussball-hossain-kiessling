-- 1. Data Access Layer
CREATE PROCEDURE GetPlayerByID(IN PlayerID INT)
BEGIN
    SELECT * FROM Spieler WHERE SpielerID = PlayerID;
END;

-- Business Logic Layer
CREATE PROCEDURE TransferPlayer(IN SpielerID INT, IN VonVereinID INT, IN NachVereinID INT, IN Transfergebuehr DECIMAL(18, 2), IN Transferdatum DATE)
BEGIN
    INSERT INTO Transfers (SpielerID, VonVereinID, NachVereinID, Transfergebuehr, Transferdatum)
    VALUES (SpielerID, VonVereinID, NachVereinID, Transfergebuehr, Transferdatum);

    UPDATE Spieler
    SET VereinsID = NachVereinID
    WHERE SpielerID = SpielerID;
END;

-- Presentation Layer
CREATE VIEW SpielerVerein AS
SELECT Spieler.Vorname, Spieler.Nachname, Vereine.Name AS Verein
FROM Spieler
INNER JOIN Vereine ON Spieler.VereinsID = Vereine.VereinsID;

