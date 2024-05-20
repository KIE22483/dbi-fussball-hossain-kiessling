-- 1. Einfügen eines neuen Spielers und Überprüfung
INSERT INTO Spieler (Vorname, Nachname, Position, Geburtsdatum, Nationalität, Marktwert, VereinsID)
VALUES ('Test', 'Spieler', 'Mittelfeld', '1990-01-01', 'Deutsch', 1000000.00, 1);

SELECT * FROM Spieler WHERE Vorname = 'Test' AND Nachname = 'Spieler';

-- 2. Aktualisieren eines Spielers und Überprüfung
UPDATE Spieler SET Marktwert = 2000000.00 WHERE Vorname = 'Test' AND Nachname = 'Spieler';

SELECT Marktwert FROM Spieler WHERE Vorname = 'Test' AND Nachname = 'Spieler';

-- 3. Löschen eines Spielers und Überprüfung
DELETE FROM Spieler WHERE Vorname = 'Test' AND Nachname = 'Spieler';

SELECT * FROM Spieler WHERE Vorname = 'Test' AND Nachname = 'Spieler';



