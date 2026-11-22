-- Part 4
-- Q1
DELIMITER //

CREATE TRIGGER CheckParticipationInsert
BEFORE INSERT ON Participates
FOR EACH ROW
BEGIN

    -- Rule 1: Administrative staff cannot participate
    IF EXISTS (
        SELECT *
        FROM Administrative A
        WHERE A.pid = NEW.pid
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Administrative staff cannot participate in research projects';
    END IF;

    -- Rule 2: PI and Co-PI must belong to Academic
    IF NEW.role IN ('PI', 'Co-PI')
       AND NOT EXISTS (
           SELECT *
           FROM Academic A
           WHERE A.pid = NEW.pid
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'PI or Co-PI must belong to Academic';
    END IF;

    -- Rules 3 and 4: At most one PI and one Co-PI per project
    IF NEW.role IN ('PI', 'Co-PI')
       AND EXISTS (
           SELECT *
           FROM Participates P
           WHERE P.projectCode = NEW.projectCode
             AND P.role = NEW.role
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'A project cannot have more than one PI or Co-PI';
    END IF;

END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER CheckParticipationUpdate
BEFORE UPDATE ON Participates
FOR EACH ROW
BEGIN

    -- Rule 1: Administrative staff cannot participate
    IF EXISTS (
        SELECT *
        FROM Administrative A
        WHERE A.pid = NEW.pid
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Administrative staff cannot participate in research projects';
    END IF;

    -- Rule 2: PI and Co-PI must belong to Academic
    IF NEW.role IN ('PI', 'Co-PI')
       AND NOT EXISTS (
           SELECT *
           FROM Academic A
           WHERE A.pid = NEW.pid
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'PI or Co-PI must belong to Academic';
    END IF;

    -- Rules 3 and 4
    IF NEW.role IN ('PI', 'Co-PI')
       AND EXISTS (
           SELECT *
           FROM Participates P
           WHERE P.projectCode = NEW.projectCode
             AND P.role = NEW.role
             AND NOT (
                 P.pid = OLD.pid
                 AND P.projectCode = OLD.projectCode
             )
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'A project cannot have more than one PI or Co-PI';
    END IF;

END //

DELIMITER ;
/*the first one is before insert the second one is before update*/


-- Q2/a
DELIMITER //


CREATE TRIGGER prevent_double_booking
BEFORE INSERT ON Reserves
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Reserves rs
        JOIN Reservation r
            ON rs.resId = r.resId
        JOIN Reservation new_r
            ON new_r.resId = NEW.resId
        WHERE rs.serialNo = NEW.serialNo
          AND r.status = 'Approved'
          AND new_r.status = 'Approved'
          AND new_r.plannedStart < r.plannedEnd
          AND new_r.plannedEnd > r.plannedStart
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Double booking: equipment already reserved';
    END IF;
END //


DELIMITER ;




-- Q2/b

DELIMITER //

CREATE TRIGGER prevent_double_booking_update
BEFORE UPDATE ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.status = 'Approved' AND EXISTS (
        SELECT 1
        FROM Reserves rs1
        JOIN Reserves rs2
            ON rs1.serialNo = rs2.serialNo
        JOIN Reservation r2
            ON rs2.resId = r2.resId
        WHERE rs1.resId = NEW.resId
          AND rs2.resId <> NEW.resId
          AND r2.status = 'Approved'
          AND NEW.plannedStart < r2.plannedEnd
          AND NEW.plannedEnd > r2.plannedStart
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Double booking: reservation conflicts with another approved reservation';
    END IF;
END //

DELIMITER ;


-- Q3
DELIMITER //

CREATE TRIGGER check_equipment_certification
BEFORE INSERT ON Reserves
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Reservation r
        JOIN EquipmentUnit eu
            ON eu.serialNo = NEW.serialNo
        JOIN EquipmentModel em
            ON em.modelId = eu.modelId
        JOIN Requires req
            ON req.modelId = em.modelId
        WHERE r.resId = NEW.resId
          AND NOT EXISTS (
              SELECT 1
              FROM Holds h
              WHERE h.pid = r.madeByPid
                AND h.certCode = req.certCode
                AND h.expirationDate >= DATE(r.plannedStart)
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Reservation rejected: person lacks a valid required certification';
    END IF;
END //

DELIMITER ;



-- Q4
DELIMITER //

CREATE TRIGGER ValidateConsumption
BEFORE INSERT ON Consumes
FOR EACH ROW
BEGIN
    DECLARE q DECIMAL(12,2);

    -- 1. Check that the quantity is positive
    IF NEW.quantityUsed <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity used must be positive';
    END IF;

    -- 2. Check that the corresponding stock entry exists
    IF NOT EXISTS (
        SELECT *
        FROM Stocks S
        WHERE S.labId = NEW.labId
          AND S.consId = NEW.consId
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No corresponding stock entry exists';
    END IF;

    -- 3. Retrieve the available quantity
    SELECT S.quantityOnHand INTO q
    FROM Stocks S
    WHERE S.labId = NEW.labId
      AND S.consId = NEW.consId;

    -- 4. Check that sufficient stock is available
    IF NEW.quantityUsed > q THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

END //

DELIMITER ;/*this trigger is a before trigger its operation is insert*/
DELIMITER //

CREATE TRIGGER UpdateStockAfterConsumption
AFTER INSERT ON Consumes
FOR EACH ROW
BEGIN
    UPDATE Stocks
    SET quantityOnHand = quantityOnHand - NEW.quantityUsed
    WHERE labId = NEW.labId
      AND consId = NEW.consId;
END //

DELIMITER ;/*this trigger is an after trigger its operation is insert*/ 
-- Valid consumption: 
INSERT INTO Consumes (resId, labId, consId, quantityUsed)
VALUES (2, 1, 2, 3.00);

-- Q5
-- Task 5(a) - AFTER INSERT on Maintenance: maintenance starts
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER MaintenanceStarts
AFTER INSERT ON Maintenance
FOR each row
BEGIN 
Update EquipmentUnit
SET EquipmentUnit.status = 'UnderMaintenance'
WHERE serialNO=New.serialNo;
END//
DELIMITER ;

-- ---------------------------------------------------------------------
-- Task 5(b) - AFTER UPDATE on Maintenance: maintenance resolved
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER Maintenanceisresolved
AFTER UPDATE ON Maintenance
FOR each row
BEGIN 
IF OLD.outcome <> 'Resolved' and NEW.outcome='Resolved' THEN
UPDATE EquipmentUnit
SET EquipmentUnit.status='InService'
WHERE serialNO=New.serialNo;
END IF;
END//
DELIMITER ;


-- Q6
-- Task 6(a) - BEFORE INSERT on Student and on Employee: disjointness (PE2)
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER DisjointnessStudent
BEFORE INSERT ON Student 
FOR each row
BEGIN 
IF EXISTS (SELECT 1 from Employee WHERE pid=NEW.pid) THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This person is already an employee';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER DisjointnessEmployee
BEFORE INSERT ON Employee
FOR each row
BEGIN 
IF EXISTS (SELECT 1 from Student WHERE pid=NEW.pid) THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This person is already an student';
END IF;
END//
DELIMITER ;



-- ---------------------------------------------------------------------
-- Task 6(b) - Faculty and administrative staff report to the dean (PE5)
--   BEFORE INSERT on Faculty, BEFORE INSERT on Administrative,
--   BEFORE UPDATE on Employee (supervisor changes)
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER FacultyReports
BEFORE INSERT ON Faculty
FOR each row
BEGIN 
IF  NOT EXISTS (SELECT 1 FROM Employee WHERE pid=(SELECT supervisorPid from Employee WHERE pid=NEW.pid) AND position='dean') THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The Faculty member should report to the dean';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER AdministrativeReports
BEFORE INSERT ON Administrative
FOR each row
BEGIN 
IF  NOT EXISTS (SELECT 1 FROM Employee WHERE pid=(SELECT supervisorPid from Employee WHERE pid=NEW.pid) AND position='dean') THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The administrative staff member should report to the dean';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER EmployeeUpdateTrigger
BEFORE UPDATE ON Employee
FOR each row
BEGIN 
IF( EXISTS (select 1 FROM Faculty WHERE pid=New.pid) or EXISTS ( SELECT 1 FROM Administrative WHERE pid=New.pid)) and Not EXISTS(SELECT 1 FROM Employee WHERE pid=NEW.supervisorPid and position='dean') THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='This employee should report to the dean';
END IF;
END//
DELIMITER ;







-- ---------------------------------------------------------------------
-- Task 6(c) - The dean has no supervisor (PE5)
--   BEFORE INSERT and BEFORE UPDATE on Employee
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER supervisorIdtriggerInsert
BEFORE INSERT ON Employee
FOR each row
BEGIN 
IF NEW.position='dean' and NEW.supervisorPid is NOT NULL THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The dean should not report to anyone';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER supervisorIdtriggerUpdate
BEFORE UPDATE ON Employee
FOR each row
BEGIN 
IF NEW.position='dean' and NEW.supervisorPid is NOT NULL THEN 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The dean should not report to anyone';
END IF;
END//
DELIMITER ;



-- List all triggers
SHOW TRIGGERS;

