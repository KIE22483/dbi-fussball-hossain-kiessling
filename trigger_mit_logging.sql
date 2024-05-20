--Insert-Trigger für Spieler
DELIMITER //

CREATE TRIGGER LogPlayerInsert
AFTER INSERT ON Spieler
FOR EACH ROW
BEGIN
    INSERT INTO Log (EventType, EventDetail) 
    VALUES ('Insert', CONCAT('Neuer Spieler hinzugefügt: SpielerID: ', NEW.SpielerID, ', Name: ', NEW.Vorname, ' ', NEW.Nachname));
END //

DELIMITER ;

-- Update-Trigger für Spieler
DELIMITER //

CREATE TRIGGER LogPlayerUpdate
AFTER UPDATE ON Spieler
FOR EACH ROW
BEGIN
    INSERT INTO Log (EventType, EventDetail) 
    VALUES ('Update', CONCAT('SpielerID: ', OLD.SpielerID, ' wurde aktualisiert. Alter Marktwert: ', OLD.Marktwert, ', Neuer Marktwert: ', NEW.Marktwert));
END //

DELIMITER ;


-- Delete-Trigger für Spieler
DELIMITER //

CREATE TRIGGER LogPlayerDelete
AFTER DELETE ON Spieler
FOR EACH ROW
BEGIN
    INSERT INTO Log (EventType, EventDetail) 
    VALUES ('Delete', CONCAT('SpielerID: ', OLD.SpielerID, ' wurde gelöscht. Name: ', OLD.Vorname, ' ', OLD.Nachname));
END //
