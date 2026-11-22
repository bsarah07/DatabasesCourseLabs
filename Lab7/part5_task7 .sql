-- =====================================================================
-- Part 5) Task 7: A schema change
-- Answers to (a), (b) and (c): see the report.
-- Execution logs (before the renaming, after the renaming, after the
-- fix): see the Execution Logs PDF, Part 5 - Task 7.
-- =====================================================================

-- ---------------------------------------------------------------------
-- (a) Renaming of the column
-- ---------------------------------------------------------------------
ALTER TABLE Consumable RENAME COLUMN name TO designation;


-- ---------------------------------------------------------------------
-- (b) Fix: re-define the view so that it reads the new column while
--     keeping the same output column name (consName). The program is
--     not modified and the column is not renamed back.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW LaboratoryStockSummary AS
SELECT Stocks.labId, Laboratory.name AS labName, Stocks.consId,
       Consumable.designation AS consName,
       unitOfMeasure, quantityOnHand, reorderThreshold, technicalPid, monitoringSince,
       CASE WHEN quantityOnHand <= reorderThreshold THEN 'LOW' ELSE 'OK' END AS stockLevel
FROM Laboratory, Consumable, Stocks
WHERE Stocks.consId = Consumable.consId AND Stocks.labId = Laboratory.labId;


-- ---------------------------------------------------------------------
-- (d) Rename the column back and re-create the original view
-- ---------------------------------------------------------------------
ALTER TABLE Consumable RENAME COLUMN designation TO name;

CREATE OR REPLACE VIEW LaboratoryStockSummary AS
SELECT Stocks.labId, Laboratory.name AS labName, Stocks.consId,
       Consumable.name AS consName,
       unitOfMeasure, quantityOnHand, reorderThreshold, technicalPid, monitoringSince,
       CASE WHEN quantityOnHand <= reorderThreshold THEN 'LOW' ELSE 'OK' END AS stockLevel
FROM Laboratory, Consumable, Stocks
WHERE Stocks.consId = Consumable.consId AND Stocks.labId = Laboratory.labId;

SELECT * FROM LaboratoryStockSummary;
