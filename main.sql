DROP DATABASE IF EXISTS fussballmarkt;
CREATE DATABASE IF NOT EXISTS fussballmarkt;
USE fussballmarkt;

-- Tabelle 11: Log
CREATE TABLE IF NOT EXISTS Log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EventTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EventType VARCHAR(50),
    EventDetail TEXT
);

-- Tabelle 4: Trainer
CREATE TABLE IF NOT EXISTS Trainer (
    TrainerID INT AUTO_INCREMENT PRIMARY KEY,
    Vorname VARCHAR(50),
    Nachname VARCHAR(50),
    Nationalität VARCHAR(50),
    Geburtsdatum DATE
);

-- Tabelle 2: Vereine
CREATE TABLE IF NOT EXISTS Vereine (
    VereinsID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Land VARCHAR(50),
    Liga VARCHAR(50),
    Gruendungsjahr INT,
    TrainerID INT,
    FOREIGN KEY (TrainerID) REFERENCES Trainer(TrainerID)
);

-- Tabelle 1: Spieler
CREATE TABLE IF NOT EXISTS Spieler (
    SpielerID INT AUTO_INCREMENT PRIMARY KEY,
    Vorname VARCHAR(50),
    Nachname VARCHAR(50),
    Position VARCHAR(50),
    Geburtsdatum DATE,
    Nationalität VARCHAR(50),
    Marktwert DECIMAL(18, 2), 
    VereinsID INT,
    FOREIGN KEY (VereinsID) REFERENCES Vereine(VereinsID)
);

-- Tabelle 3: Transfers
CREATE TABLE IF NOT EXISTS Transfers (
    TransferID INT AUTO_INCREMENT PRIMARY KEY,
    SpielerID INT,
    VonVereinID INT,
    NachVereinID INT,
    Transfergebuehr DECIMAL(18, 2),
    Transferdatum DATE,
    FOREIGN KEY (SpielerID) REFERENCES Spieler(SpielerID),
    FOREIGN KEY (VonVereinID) REFERENCES Vereine(VereinsID),
    FOREIGN KEY (NachVereinID) REFERENCES Vereine(VereinsID)
);

-- Tabelle 5: Spiele
CREATE TABLE IF NOT EXISTS Spiele (
    SpielID INT AUTO_INCREMENT PRIMARY KEY,
    HeimVereinID INT,
    AuswaertsVereinID INT,
    Spielort VARCHAR(100),
    SpielDatum DATE,
    Ergebnis VARCHAR(20),
    FOREIGN KEY (HeimVereinID) REFERENCES Vereine(VereinsID),
    FOREIGN KEY (AuswaertsVereinID) REFERENCES Vereine(VereinsID)
);

-- Tabelle 6: Tore
CREATE TABLE IF NOT EXISTS Tore (
    TorID INT AUTO_INCREMENT PRIMARY KEY,
    SpielID INT,
    SpielerID INT,
    Torzeit TIME,
    FOREIGN KEY (SpielID) REFERENCES Spiele(SpielID),
    FOREIGN KEY (SpielerID) REFERENCES Spieler(SpielerID)
);

-- Tabelle 7: Turniere
CREATE TABLE IF NOT EXISTS Turniere (
    TurnierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Veranstaltungsort VARCHAR(100),
    Startdatum DATE,
    Enddatum DATE
);

-- Tabelle 8: Turnierteams
CREATE TABLE IF NOT EXISTS Turnierteams (
    TurnierID INT,
    VereinsID INT,
    PRIMARY KEY (TurnierID, VereinsID),
    FOREIGN KEY (TurnierID) REFERENCES Turniere(TurnierID),
    FOREIGN KEY (VereinsID) REFERENCES Vereine(VereinsID)
);

-- Tabelle 9: Verletzungen
CREATE TABLE IF NOT EXISTS Verletzungen (
    VerletzungsID INT AUTO_INCREMENT PRIMARY KEY,
    SpielerID INT,
    Verletzungsart VARCHAR(100),
    Verletzungsdatum DATE,
    FOREIGN KEY (SpielerID) REFERENCES Spieler(SpielerID)
);

-- Tabelle 10: MedizinischesPersonal
CREATE TABLE IF NOT EXISTS MedizinischesPersonal (
    PersonalID INT AUTO_INCREMENT PRIMARY KEY,
    Vorname VARCHAR(50),
    Nachname VARCHAR(50),
    Fachgebiet VARCHAR(100),
    Nationalität VARCHAR(50),
    Lizenznummer VARCHAR(50)
);

-- Trainer
INSERT INTO Trainer (Vorname, Nachname, Nationalität, Geburtsdatum) VALUES
('Jürgen', 'Klopp', 'Deutsch', '1967-06-16'),
('Pep', 'Guardiola', 'Spanisch', '1971-01-18'),
('José', 'Mourinho', 'Portugiesisch', '1963-01-26');

-- Vereine
INSERT INTO Vereine (Name, Land, Liga, Gruendungsjahr, TrainerID) VALUES
('FC Bayern München', 'Deutschland', 'Bundesliga', 1900, 2),
('FC Barcelona', 'Spanien', 'La Liga', 1899, 3),
('Manchester United', 'England', 'Premier League', 1878, 1);

-- Spieler
INSERT INTO Spieler (Vorname, Nachname, Position, Geburtsdatum, Nationalität, Marktwert, VereinsID) VALUES
('Lionel', 'Messi', 'Stürmer', '1987-06-24', 'Argentinisch', 100000000.00, 2),
('Cristiano', 'Ronaldo', 'Stürmer', '1985-02-05', 'Portugiesisch', 95000000.00, 3),
('Robert', 'Lewandowski', 'Stürmer', '1988-08-21', 'Polnisch', 80000000.00, 1);

-- Transfers
INSERT INTO Transfers (SpielerID, VonVereinID, NachVereinID, Transfergebuehr, Transferdatum) VALUES
(1, NULL, 2, 70.00, '2021-08-05'),
(2, NULL, 3, 60.00, '2021-07-01'),
(3, NULL, 1, 50.00, '2022-09-10');

-- Spiele
INSERT INTO Spiele (HeimVereinID, AuswaertsVereinID, Spielort, SpielDatum, Ergebnis) VALUES
(1, 3, 'Allianz Arena', '2024-05-05', '2:1'),
(2, 1, 'Camp Nou', '2024-05-06', '3:0'),
(3, 2, 'Old Trafford', '2024-05-07', '1:1');

-- Tore
INSERT INTO Tore (SpielID, SpielerID, Torzeit) VALUES
(1, 1, '00:35'),
(2, 2, '15:10'),
(3, 3, '22:55');

-- Turniere
INSERT INTO Turniere (Name, Veranstaltungsort, Startdatum, Enddatum) VALUES
('UEFA Champions League', 'Europa', '2024-06-01', '2024-06-30'),
('FIFA World Cup', 'Weltweit', '2026-06-10', '2026-07-10');

-- Turnierteams
INSERT INTO Turnierteams (TurnierID, VereinsID) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 2);

-- Verletzungen
INSERT INTO Verletzungen (SpielerID, Verletzungsart, Verletzungsdatum) VALUES
(1, 'Muskelverletzung', '2024-04-15'),
(2, 'Knöchelverletzung', '2024-03-20'),
(3, 'Knieverletzung', '2024-05-01');

-- MedizinischesPersonal
INSERT INTO MedizinischesPersonal (Vorname, Nachname, Fachgebiet, Nationalität, Lizenznummer) VALUES
('Anna', 'Müller', 'Physiotherapie', 'Deutsch', 'PT12345'),
('John', 'Smith', 'Orthopädie', 'Englisch', 'ORTH6789'),
('María', 'García', 'Sportmedizin', 'Spanisch', 'SPMD4567');

