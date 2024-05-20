-- Search function
USE fussballmarkt;

DELIMITER / / CREATE FUNCTION SearchPlayer(last_name VARCHAR(50)) RETURNS VARCHAR(255) READS SQL DATA BEGIN DECLARE player_info VARCHAR(255);

SELECT
    CONCAT(
        'Player found: ',
        Vorname,
        ' ',
        Nachname,
        ', Position: ',
        Position,
        ', Geburtsdatum: ',
        Geburtsdatum
    ) INTO player_info
FROM
    Spieler
WHERE
    Nachname = last_name;

IF player_info IS NULL THEN RETURN 'Player not found';

ELSE RETURN player_info;

END IF;

END / / DELIMITER;

SELECT
    SearchPlayer('Ronaldo');

-- Ermittlung des Gesamtmarktwerts eines Vereins
SELECT
    Vereine.Name AS Vereinsname,
    SUM(Spieler.Marktwert) AS Gesamtmarktwert
FROM
    Vereine
    JOIN Spieler ON Vereine.VereinsID = Spieler.VereinsID
GROUP BY
    Vereine.Name;

--  Top-Scorer pro Turnier
SELECT
    Turniere.Name AS Turnier,
    Spieler.Vorname,
    Spieler.Nachname,
    COUNT(Tore.TorID) AS Tore
FROM
    Turniere
    JOIN Turnierteams ON Turniere.TurnierID = Turnierteams.TurnierID
    JOIN Spiele ON Turnierteams.VereinsID IN (Spiele.HeimVereinID, Spiele.AuswaertsVereinID)
    JOIN Tore ON Spiele.SpielID = Tore.SpielID
    JOIN Spieler ON Tore.SpielerID = Spieler.SpielerID
WHERE
    Turniere.TurnierID = 1 -- ID des Turniers
GROUP BY
    Turniere.Name,
    Spieler.Vorname,
    Spieler.Nachname
ORDER BY
    Tore DESC
LIMIT
    3;

-- Auswertung der Transferaktivitäten eines Vereins
SELECT
    Verein.Name,
    SUM(
        CASE
            WHEN Transfers.VonVereinID = Verein.VereinsID THEN Transfers.Transfergebuehr
            ELSE 0
        END
    ) AS Summe_Ausgehende_Transfers,
    SUM(
        CASE
            WHEN Transfers.NachVereinID = Verein.VereinsID THEN Transfers.Transfergebuehr
            ELSE 0
        END
    ) AS Summe_Eingehende_Transfers
FROM
    Vereine AS Verein
    LEFT JOIN Transfers ON Verein.VereinsID IN (Transfers.VonVereinID, Transfers.NachVereinID)
GROUP BY
    Verein.Name;

-- Spieler mit den meisten Verletzungen
SELECT
    Spieler.Vorname,
    Spieler.Nachname,
    COUNT(Verletzungen.VerletzungsID) AS Anzahl_Verletzungen
FROM
    Spieler
    JOIN Verletzungen ON Spieler.SpielerID = Verletzungen.SpielerID
GROUP BY
    Spieler.Vorname,
    Spieler.Nachname
ORDER BY
    Anzahl_Verletzungen DESC
LIMIT
    1;

-- Trigger zur Überprüfung der Spielerdaten
DELIMITER / / CREATE TRIGGER CheckMarktwert BEFORE
UPDATE
    ON Spieler FOR EACH ROW BEGIN IF NEW.Marktwert < 0 THEN SIGNAL SQLSTATE '45000'
SET
    MESSAGE_TEXT = 'Marktwert darf nicht negativ sein';

END IF;

END / / DELIMITER;

-- Erstellung eines Cursors zur Iteration über Spielerdaten     
-- Erstellt ein Beispiel mit einem Cursor, der durch alle Spieler iteriert und deren Marktwert um 10% erhöht, wenn sie in den letzten 6 Monaten kein Tor erzielt haben.
DELIMITER / / CREATE PROCEDURE UpdateMarktwertNoGoals() BEGIN DECLARE done INT DEFAULT 0;

DECLARE pSpielerID INT;

DECLARE SpielerCursor CURSOR FOR
SELECT
    SpielerID
FROM
    Spieler;

DECLARE CONTINUE HANDLER FOR NOT FOUND
SET
    done = 1;

OPEN SpielerCursor;

read_loop: LOOP FETCH SpielerCursor INTO pSpielerID;

IF done THEN LEAVE read_loop;

END IF;

-- Erhöhung des Marktwerts um 10%, wenn der Spieler in den letzten 6 Monaten kein Tor erzielt hat
IF NOT EXISTS (
    SELECT
        1
    FROM
        Tore
        JOIN Spiele ON Tore.SpielID = Spiele.SpielID
    WHERE
        Tore.SpielerID = pSpielerID
        AND Spiele.SpielDatum > DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
) THEN
UPDATE
    Spieler
SET
    Marktwert = Marktwert * 1.10
WHERE
    SpielerID = pSpielerID;

END IF;

END LOOP;

CLOSE SpielerCursor;

END / / DELIMITER;