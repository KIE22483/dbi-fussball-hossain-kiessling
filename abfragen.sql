use fussballmarkt;

SELECT * FROM Spieler;

SELECT * FROM Spieler WHERE Nationalität = "Argentinien";
#Expected: Messi

SELECT * FROM Spieler WHERE Marktwert > 100000000.00;

#Alle Spieler mit deren Vereinen
SELECT Spieler.Vorname, Spieler.Nachname, Vereine.Name AS Verein
FROM Spieler
INNER JOIN Transfers ON Spieler.SpielerID = Transfers.SpielerID
INNER JOIN Vereine ON Transfers.NachVereinID = Vereine.VereinsID;

#Anzahl Spieler pro Nationalität
SELECT Nationalität, COUNT(*) AS Anzahl_Spieler
FROM Spieler
GROUP BY Nationalität;

#Spieler pro Verein
SELECT Vereine.Name AS Verein, COUNT(Spieler.SpielerID) AS Anzahl_Spieler
FROM Vereine
LEFT JOIN Transfers ON Vereine.VereinsID = Transfers.NachVereinID
LEFT JOIN Spieler ON Transfers.SpielerID = Spieler.SpielerID
GROUP BY Vereine.VereinsID
ORDER BY Anzahl_Spieler DESC;

#Spieler mit Tore, sortiert nach Tore
SELECT Spiele.SpielID, Spiele.SpielDatum, COUNT(Tore.TorID) AS Tore
FROM Spiele
LEFT JOIN Tore ON Spiele.SpielID = Tore.SpielID
GROUP BY Spiele.SpielID, Spiele.SpielDatum
ORDER BY Tore DESC;

#Verletzungen des Jahres 2023
SELECT Spieler.Vorname, Spieler.Nachname, Verletzungen.Verletzungsart, Verletzungen.Verletzungsdatum
FROM Spieler
INNER JOIN Verletzungen ON Spieler.SpielerID = Verletzungen.SpielerID
WHERE YEAR(Verletzungen.Verletzungsdatum) = '2023-04-05';


SELECT Vereine.Name AS Verein, AVG(Spieler.Marktwert) AS Durchschnittlicher_Marktwert
FROM Spieler
JOIN Vereine ON Spieler.VereinsID = Vereine.VereinsID
GROUP BY Vereine.Name;


