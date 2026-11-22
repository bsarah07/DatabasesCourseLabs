-- =====================================================================
-- Part 5) Task 7: 
-- =====================================================================

-- ---------------------------------------------------------------------
-- (a) Renaming of the column
-- ---------------------------------------------------------------------
ALTER TABLE Consumable RENAME COLUMN name TO designation;

-- Execution logs of the unmodified program, before the renaming and
-- after the renaming: see the Execution Logs PDF, Part 5 - Task 7.

-- Answer (a):
-- What happens: task 4, the part that reads the view LaboratoryStockSummary,
-- fails with error 1356: the view uses a column that does not exist anymore.
-- The program prints the error and continues: tasks 3, 5 and 6 still work,
-- because they never use the column Consumable.name.
--
-- Why: a view does not keep a copy of the data. It only keeps its query,
-- and runs it again every time we use it. Our view's query still asks for
-- Consumable.name, but that column is now called designation. So the view
-- can no longer run, and anything that reads it fails. The program did
-- nothing wrong: the problem is inside the view.


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

-- Execution log of the unmodified program after the fix:
-- see the Execution Logs PDF, Part 5 - Task 7.

-- Comparison (b): the rows printed by task 4 after the fix are identical
-- to those printed before the renaming: the underlying data did not
-- change, only the name of a column, and the view still exposes it
-- under the alias consName.


-- ---------------------------------------------------------------------
-- Answer (c)
-- ---------------------------------------------------------------------
-- The program never refers to the base table Consumable: it only knows
-- the view LaboratoryStockSummary and its column names. The view is an
-- intermediate layer between the program and the tables, so when the
-- base table changed, re-defining the view was enough and the program
-- did not notice anything.
-- This illustrates LOGICAL DATA INDEPENDENCE: the logical schema (the
-- tables) can change without changing the external schema (the views)
-- used by applications, and therefore without changing the applications.
--
-- The query of task 3 would NOT survive a renaming of Laboratory.name:
-- it queries the base tables directly (WHERE l.name = %s), not a view,
-- so it would fail with an "Unknown column" error and the program itself
-- would have to be modified.


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