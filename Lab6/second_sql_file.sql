Use Lab6;
-- =========================================
-- DataBase Population
-- =========================================
INSERT INTO Person
    (pid, firstName, lastName, email, affiliation, startDate, endDate)
VALUES
    (1, 'Sarah', 'Bouchmal', 'sarah@um6p.ma', 'Science Faculty', '2022-09-01', NULL),
    (2, 'Fatima Zahra', 'Benjaa', 'fatimazahra@um6p.ma', 'Science Faculty', '2021-01-15', NULL),
    (3, 'Sara', 'Amrani', 'sara@um6p.ma', 'Engineering Faculty', '2023-02-01', NULL),
    (4, 'Youssef', 'Mansouri', 'youssef@um6p.ma', 'Technical Services', '2020-06-01', '2025-09-01'),
    (5, 'Douaa', 'Dya', 'douaa@um6p.ma', 'Administration', '2022-03-01','2024-09-01'),
    (6, 'Karim', 'Alaoui', 'karim@um6p.ma', 'Science Faculty', '2024-09-01','2025-09-01'),
    (7, 'Lina', 'Tazi', 'lina@um6p.ma', 'Engineering Faculty', '2024-09-01', NULL),
    (8, 'Mehdi', 'Saidi', 'mehdi@um6p.ma', 'Science Faculty', '2023-09-01', NULL),
    (9, 'Imane', 'Chraibi', 'imane@um6p.ma', 'Administration', '2021-11-01', '2023-09-01'),
    (10, 'Douae', 'Charafi', 'douae@um6p.ma', 'Science Faculty', '2020-01-01', NULL),
    (11, 'Hiba', 'Kettani', 'hiba@um6p.ma', 'Engineering Faculty', '2025-09-01', NULL),
    (12, 'Anas', 'Tahiri', 'anas@um6p.ma', 'Science Faculty', '2025-09-01', NULL);


INSERT INTO Student (pid, program)
VALUES
    (6, 'Physics'),
    (7, 'Engineering'),
    (8, 'Chemistry'),
    (11, 'Physics'),
    (12, 'Biology');

INSERT INTO Employee
    (pid, phone, office, position, supervisorPid)
VALUES
    (1, '0600000001', 'A101', 'Dean', NULL),
    (2, '0600000002', 'B201', 'Professor', 1),
    (3, '0600000003', 'C301', 'Researcher', 2),
    (4, '0600000004', 'T101', 'Technician', 1),
    (5, '0600000005', 'ADM1', 'Administrator', 1),
    (9, '0600000009', 'ADM2', 'Administrator', 5),
    (10, '0600000010', 'B202', 'Professor', 2);

INSERT INTO Academic (pid)
VALUES
    (1),
    (2),
    (3),
    (10);

INSERT INTO Faculty (pid)
VALUES
    (1),
    (2),
    (3),
    (10);


INSERT INTO Administrative (pid)
VALUES
    (5),
    (9);


INSERT INTO Technical (pid)
VALUES
    (4);


INSERT INTO Advises (academicPid, studentPid)
VALUES
    (2, 6),
    (3, 7),
    (2, 8),
    (10, 11),
    (3, 12);

INSERT INTO Laboratory
    (labId, name, building, roomNumber, discipline, supervisorPid)
VALUES
    (1, 'Physics Laboratory', 'Riad5', '101', 'Physics', 2),
    (2, 'Chemistry Laboratory', 'ScienceBlock', '202', 'Chemistry', 3),
    (3, 'Engineering Laboratory', 'TechBlock', '303', 'Engineering', 10),
    (4, 'Biology Laboratory', 'Riad5', '104', 'Biology', 1),
    (5, 'Materials Laboratory', 'ResearchBlock', '405', 'Materials Science', 2);


INSERT INTO Attached (pid, labId)
VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 1),
    (5, 3),
    (6, 1),
    (7, 3),
    (10, 5);

INSERT INTO ResearchProject
    (code, title, startDate, endDate, status)
VALUES
    ('PRJ001', 'Optics Research', '2025-01-01', '2027-12-31', 'Active'),
    ('PRJ002', 'Water Quality Study', '2025-03-01', '2027-06-30', 'Active'),
    ('PRJ003', 'Smart Materials', '2024-01-01', '2026-12-31', 'Suspended'),
    ('PRJ004', 'Thermal Analysis', '2025-06-01', '2027-05-31', 'Active'),
    ('PRJ005', 'Unassigned Research', '2026-01-01', '2028-12-31', 'Proposed');


INSERT INTO Participates (pid, projectCode, role)
VALUES
    (1, 'PRJ001', 'PI'),
    (2, 'PRJ001', 'Co-PI'),
    (6, 'PRJ001', 'Collaborator'),
    (3, 'PRJ002', 'PI'),
    (7, 'PRJ002', 'Co-PI'),
    (10, 'PRJ003', 'PI'),
    (8, 'PRJ003', 'Collaborator'),
    (2, 'PRJ004', 'PI'),
    (11, 'PRJ004', 'Collaborator');


INSERT INTO Budget
    (budgetLine, amountGranted, amountDisbursed, startDate, endDate, managerPid)
VALUES
    ('BUD001', 50000.00, 12000.00, '2025-01-01', '2027-12-31', 1),
    ('BUD002', 30000.00, 8000.00, '2025-03-01', '2027-06-30', 2),
    ('BUD003', 25000.00, 15000.00, '2024-01-01', '2026-12-31', 3),
    ('BUD004', 40000.00, 5000.00, '2025-06-01', '2027-05-31', 10),
    ('BUD005', 10000.00, 0.00, '2026-01-01', '2028-12-31', 2);


INSERT INTO FundsPrj (budgetLine, projectCode)
VALUES
    ('BUD001', 'PRJ001'),
    ('BUD002', 'PRJ002'),
    ('BUD003', 'PRJ003'),
    ('BUD004', 'PRJ004');

INSERT INTO FundsLab (budgetLine, labId)
VALUES
    ('BUD001', 1),
    ('BUD002', 2),
    ('BUD003', 3),
    ('BUD004', 4),
    ('BUD005', 5);


INSERT INTO EquipmentModel
    (modelId, commercialName, manufacturer, category, requiredEnvironment, trainingMandatory)
VALUES
    (1, 'OptiScope X100', 'OptiTech', 'Optical Microscope', 'Clean and dry', TRUE),
    (2, 'ThermoPro T20', 'ThermoTech', 'Thermometer', 'Controlled temperature', FALSE),
    (3, 'SpectraScan 500', 'SpectraTech', 'Spectrometer', 'Low humidity', TRUE),
    (4, 'Centrifuge C300', 'LabWorks', 'Centrifuge', 'Stable surface', TRUE),
    (5, 'Unused Model Z', 'FutureLabs', 'Analyzer', 'Standard laboratory', FALSE);


INSERT INTO EquipmentUnit
    (serialNo, acquisitionDate, purchaseCost, status, portable, modelId, labId)
VALUES
    ('EQ001', '2024-01-10', 2500.00, 'InService', TRUE, 1, 1),
    ('EQ002', '2024-03-15', 450.00, 'UnderMaintenance', TRUE, 2, 1),
    ('EQ003', '2023-06-20', 7500.00, 'UnderMaintenance', FALSE, 3, 2),
    ('EQ004', '2024-08-05', 3200.00, 'OutOfService', FALSE, 4, 3),
    ('EQ005', '2025-02-12', 2700.00, 'OutOfService', TRUE, 1, 4);


INSERT INTO Certification
    (code, title, issuingAuthority, validityPeriod, safetyLevel)
VALUES
    ('CERT001', 'Optical Equipment Safety', 'RLMS Safety Office', 365, 'High'),
    ('CERT002', 'Thermal Equipment Handling', 'RLMS Safety Office', 730, 'Medium'),
    ('CERT003', 'Laser Safety', 'National Safety Institute', 365, 'High'),
    ('CERT004', 'Chemical Safety', 'RLMS Safety Office', 730, 'High'),
    ('CERT005', 'General Laboratory Safety', 'RLMS Safety Office', 365, 'Medium');


INSERT INTO Requires (modelId, certCode)
VALUES
    (1, 'CERT001'),
    (1, 'CERT005'),
    (2, 'CERT002'),
    (3, 'CERT003'),
    (4, 'CERT004');


INSERT INTO Holds
    (pid, certCode, issueDate, expirationDate, grade)
VALUES
    (2, 'CERT001', '2025-02-01', '2027-02-01', 'Good'),
    (3, 'CERT003', '2025-03-01', '2026-11-30', 'Excellent'),
    (4, 'CERT004', '2025-04-01', '2027-04-01', 'Good'),
    (6, 'CERT005', '2025-09-01', '2027-09-01', 'Pass'),
    (7, 'CERT002', '2025-10-01', '2027-10-01', 'Pass');
    


INSERT INTO Reservation
    (resId, submissionTS, plannedStart, plannedEnd, purpose, status, madeByPid, projectCode, approverPid)
VALUES
    (1, '2026-10-20 09:00:00', '2026-11-02 09:00:00', '2026-11-02 11:00:00',
     'Microscope experiment', 'Approved', 6, 'PRJ001', 2),
    (2, '2026-10-21 10:00:00', '2026-11-04 13:00:00', '2026-11-04 15:00:00',
     'Temperature measurements', 'Pending', 7, 'PRJ002', NULL),
    (3, '2026-10-15 11:00:00', '2026-10-25 09:00:00', '2026-10-25 10:00:00',
     'Spectrometer experiment', 'Rejected', 8, 'PRJ003', 3),
    (4, '2026-10-16 12:00:00', '2026-10-27 14:00:00', '2026-10-27 16:00:00',
     'Cancelled thermal test', 'Cancelled', 11, 'PRJ004', NULL),
    (5, '2026-10-10 08:00:00', '2026-10-18 10:00:00', '2026-10-18 12:00:00',
     'Completed optics experiment', 'Completed', 6, 'PRJ001', 1);


INSERT INTO Reserves (resId, serialNo)
VALUES
    (1, 'EQ001'),
    (1, 'EQ002'),
    (2, 'EQ002'),
    (3, 'EQ003'),
    (4, 'EQ004'),
    (5, 'EQ001'),
    (5, 'EQ005');

INSERT INTO Maintenance
    (serialNo, startTS, endTS, type, description, cost, outcome, technicalPid)
VALUES
    ('EQ001', '2026-02-01 09:00:00', '2026-02-01 11:00:00',
     'Preventive', 'Lens cleaning and inspection', 150.00, 'Resolved', 4),
    ('EQ003', '2026-03-10 10:00:00', '2026-03-10 13:00:00',
     'Corrective', 'Spectrometer alignment', 450.00, 'Resolved', 4),
    ('EQ004', '2026-10-20 09:00:00', '2026-10-20 15:00:00',
     'Corrective', 'Centrifuge motor repair', 600.00, 'FollowUpRequired', 4);

INSERT INTO CalibrationRecord
    (serialNo, calibDate, calibrationType, result, nextDueDate, remarks)
VALUES
    ('EQ001', '2026-01-15', 'Optical calibration', 'Pass', '2027-01-15', 'Within tolerance'),
    ('EQ002', '2026-02-15', 'Temperature calibration', 'Pass', '2027-02-15', 'Accurate readings'),
    ('EQ003', '2026-03-20', 'Spectral calibration', 'Fail', '2026-11-15', 'Requires adjustment'),
    ('EQ004', '2026-04-10', 'Mechanical calibration', 'Pass', '2027-04-10', 'Normal operation'),
    ('EQ005', '2026-05-05', 'Optical calibration', 'Adjusted', '2027-05-05', 'Within tolerance');


INSERT INTO Consumable
    (consId, name, unitOfMeasure, hazardLevel, reorderThreshold)
VALUES
    (1, 'Lens Cleaning Solution', 'litre', 'Low', 5.00),
    (2, 'Laboratory Gloves', 'box', 'Low', 10.00),
    (3, 'Ethanol', 'litre', 'Flammable', 8.00),
    (4, 'Distilled Water', 'litre', 'Low', 15.00),
    (5, 'Chemical Reagent X', 'bottle', 'High', 3.00);

INSERT INTO Supplier
    (suppId, name, contactEmail, phone)
VALUES
    (1, 'LabSupply Morocco', 'sales@labsupply.ma', '0522000001'),
    (2, 'Scientific Instruments Ltd', 'orders@sciinst.ma', '0522000002'),
    (3, 'ChemSource', 'contact@chemsource.ma', '0522000003'),
    (4, 'Research Materials Co', 'info@researchmat.ma', '0522000004'),
    (5, 'Global Lab Equipment', 'sales@globallab.ma', '0522000005');


INSERT INTO Supplies
    (suppId, consId, labId, unitPrice)
VALUES
    (1, 1, 1, 25.00),
    (2, 2, 1, 40.00),
    (3, 3, 2, 35.00),
    (4, 4, 4, 12.00),
    (5, 5, 5, 90.00),
    (3, 3, 3, 34.00),
    (1, 1, 2, 27.00),
    (1, 1, 3, 30.00),
    (2, 1, 1, 23.00),
    (3, 2, 1, 38.00),
    (4, 3, 2, 33.00);


INSERT INTO Stocks
    (labId, consId, quantityOnHand, lastRestockDate, storageCondition, technicalPid, monitoringSince)
VALUES
    (1, 1, 5.00, '2026-10-01', NULL, 4, '2025-01-01'),
    (1, 2, 25.00, '2026-10-10', 'Dry storage', 4, '2025-02-01'),
    (2, 3, 4.00, '2026-09-15', 'Flammable cabinet', 4, '2025-03-01'),
    (4, 4, 20.00, '2026-10-05', NULL, 4, '2025-04-01'),
    (3, 2, 12.00, '2026-09-20', 'Dry storage', 4, '2025-05-01');

INSERT INTO Consumes
    (resId, labId, consId, quantityUsed)
VALUES
    (1, 1, 1, 0.50),
    (1, 1, 2, 2.00),
    (2, 2, 3, 1.00),
    (5, 1, 1, 0.25),
    (5, 3, 2, 1.00);
-- =========================================
-- Part 2 : DML queries
-- =========================================
INSERT INTO Person (pid,firstName,lastName,email,affiliation,startDate,endDate)
   VALUES (13,'Hayat','nani','Hayat@um6p.ma','Science Faculty','2023-02-01',NULL);
INSERT INTO EquipmentUnit (serialNo, acquisitionDate, purchaseCost, status, portable, modelId, labId)
   VALUES ('EQ006','2026-02-12',3000.00,'InService',TRUE,3,1);
INSERT INTO Reservation
    (resId, submissionTS, plannedStart, plannedEnd,
     purpose, status, madeByPid, projectCode, approverPid)
   VALUES
    (6, '2026-10-20 09:00:00',
     '2026-11-02 09:00:00', '2026-11-02 11:00:00',
     'Laboratory equipment testing', 'Pending', 6, 'PRJ001', NULL);
  INSERT INTO Reserves (resId, serialNo)
  VALUES (6, 'EQ001');
UPDATE Reservation 
   SET status='Approved',
       approverPid=3
   WHERE resId=2;
 UPDATE Stocks
SET quantityOnHand = 8.00
WHERE labId = 1
  AND consId = 1;
INSERT INTO Consumes
    (resId, labId, consId, quantityUsed)
VALUES
    (1, 2, 3, 0.50);
UPDATE Reservation
SET status = 'Cancelled'
WHERE status = 'Pending'
AND projectCode IN (
    SELECT code
    FROM ResearchProject
    WHERE status = 'Cancelled'
);
DELETE FROM EquipmentModel
WHERE modelId = 5;
-- =========================================
-- Part 3 : Queries
-- =========================================


/*
1. List all persons, showing their identifier, first name, last name, and email address,
ordered by last name and then first name.
*/

select P.pid , P.lastName, P.firstName, P.email
from Person P
order by P.lastName, P.firstName;


-- question2

SELECT DISTINCT discipline
FROM Laboratory;

-- question 3
SELECT Person.pid
   FROM Person
   WHERE Person.email LIKE '%@um6p.ma';

/*
4. List all currently active persons, i.e., persons whose end date is not set.
*/

select *
from Person
where Person.endDate is  Null;

/*
5. List all reservations whose planned start time falls between two given timestamps (e.g.,
the month of November 2026).
We chose reservations happening in November 2026 too.
*/

select *
from Reservation R
where R.plannedStart > '2026-11-01' and R.plannedEnd <= '2026-11-30';

-- question6

SELECT
    P.firstName,
    P.lastName,
    RP.title AS projectTitle,
    PA.role
FROM Person P
JOIN Participates PA
    ON P.pid = PA.pid
JOIN ResearchProject RP
    ON PA.projectCode = RP.code;
    
-- question 7
SELECT Budget.budgetline,Person.firstName,Person.lastName
   FROM Budget, Person
   WHERE Budget.managerPid=Person.pid;

/*
8. List every reservation together with the full name of the person who made it and the
title of the associated research project.
*/

select r.*,CONCAT(p.firstName, ' ', p.lastName) AS fullName, rp.title
from Reservation r, Person p, ResearchProject rp
where r.madeByPid=p.pid and r.projectCode=rp.code;

/*
9. List the equipment units included in each reservation. Display the reservation identifier,
equipment serial number, equipment model commercial name, and laboratory name
*/

select R.resId, EU.serialNo, EM.commercialName, L.name
from Reservation R, Reserves Re, Equipmentunit EU, Equipmentmodel EM, laboratory L
where R.resId = Re.resId
 and Re.serialNo = EU.serialNo
 and EU.modelId = EM.modelID
 and EU.labId = L.labId;

-- question10

SELECT
    R.resId,
    P.firstName,
    P.lastName
FROM Reservation R
JOIN Person P
    ON R.approverPid = P.pid
WHERE R.status = 'Approved';

-- question 11
SELECT Laboratory.name,  Consumable.name, Stocks.quantityOnHand, Person.firstName,Person.lastName
    FROM Stocks,Laboratory,Consumable,Person
    WHERE Stocks.consid=Consumable.consid and Stocks.labid=Laboratory.labid and Stocks.technicalPid=Person.pid;

/*
12. Count the number of equipment units in each laboratory.
*/

select labId, count(serialNo) as numEqUn
from EquipmentUnit
group by labId;

/*
13. For each consumable, return the total quantity used across all reservations.
We assume that the final output should only have the consumable id and name and the total quanity. If, otherwise, it is easy to add CC.name, C.unitOfMeasure, C hazardlevel, C.reorderThreshold, 
*/

select C.consId, C.name, sum(CR.quantityused) AS quantity
from Consumable C, Reservation R, Consumes CR
where C.consId = CR.consId
 and R.resId = CR.resId 
GROUP by C.consId;

-- question14

SELECT
    L.name AS laboratoryName,
    COUNT(E.serialNo) AS numberOfUnits
FROM Laboratory L
JOIN EquipmentUnit E
    ON L.labId = E.labId
GROUP BY L.labId
HAVING COUNT(E.serialNo) > 3;

-- question 15:
SELECT ResearchProject.title, SUM(Budget.amountGranted) AS total_amount
FROM ResearchProject, FundsPrj, Budget
WHERE ResearchProject.code = FundsPrj.projectCode
  AND FundsPrj.budgetLine = Budget.budgetLine
GROUP BY FundsPrj.projectCode,
         ResearchProject.title;


/*
16. For each laboratory and equipment category, return the number of equipment units
and their average purchase cost.
*/

select eq.labId, mo.category, count(serialNo) as numEqUn, avg(purchaseCost) as AVGPurchaseCost
from EquipmentUnit eq,  EquipmentModel mo where eq.modelId=mo.modelId 
group by eq.labId, mo.category;

/*
17. For each supplier, count the number of distinct consumables that the supplier can provide across all laboratories.
*/

select S.suppId, S.name, COUNT(Su.suppId) AS count
from supplier S, supplies Su
where S.suppId = Su.suppId 
GROUP by S.suppId;

-- question18

SELECT
    L.name,
    C.name,
    MIN(S.unitPrice) AS lowestPrice
FROM Supplies S
JOIN Laboratory L
    ON S.labId = L.labId
JOIN Consumable C
    ON S.consId = C.consId
GROUP BY S.labId, S.consId;

-- question 19
SELECT Consumes.resId,Person.firstName, Person.lastName, SUM(Consumes.quantityUsed) AS total_quantity_used
    FROM Consumes, Person, Reservation
    WHERE Person.pid=Reservation.madeByPid and reservation.resId=Consumes.resId
    GROUP BY Consumes.resId,Person.firstName,Person.lastName;

/*
20. Using a set operation, list the identifiers and full names of persons who both supervise
a laboratory and manage a budget.
*/

select  p.pid,CONCAT(p.firstName, ' ', p.lastName) AS fullName
from Person p, Laboratory l
where p.pid=l.supervisorPid
INTERSECT
select  p.pid,CONCAT(p.firstName, ' ', p.lastName) AS fullName
from Person p, Budget b
where p.pid=b.managerPid;

/*
21. List the persons who have never made any reservation (use EXCEPT or NOT IN)
*/

select P.pid , P.lastName, P.firstName, P.email
from Reservation R, Person P
Except 
select P.pid , P.lastName, P.firstName, P.email
from Reservation R, Person P
where R.madeByPid = P.pid;

-- question22

SELECT
    E.serialNo,
    E.status,
    E.modelId,
    E.labId
FROM EquipmentUnit E
WHERE NOT EXISTS (
    SELECT *
    FROM Reserves R
    WHERE R.serialNo = E.serialNo
);

-- question 23 : 
SELECT E.serialNo
    FROM EquipmentUnit E
    WHERE E.purchaseCost >= ALL( SELECT E2.purchaseCost
                                FROM Equipmentunit E2);
/*
24. For each equipment model that requires at least one certification, list the persons who
hold ALL the certifications required by that model.
*/

SELECT Distinct r.modelId AS model, p.pid
FROM Person p, requires r
WHERE NOT EXISTS (
    (SELECT req.certCode
     FROM requires req
     WHERE req.modelId = r.modelId)

    EXCEPT

    (SELECT h.certCode
     FROM holds h
     WHERE h.pid = p.pid)
);
