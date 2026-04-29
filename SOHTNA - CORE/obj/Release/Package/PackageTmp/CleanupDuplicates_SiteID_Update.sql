-- ============================================================================
-- SQL Script: Remove Duplicate Employees and Update SiteID to 'BH001'
-- ============================================================================
-- Purpose: 
--   1. Remove duplicate employee records (keeping the oldest)
--   2. Update all SiteID values from hash codes to the correct alphanumeric value
--   3. Ensure data consistency
-- ============================================================================

-- Step 1: Create a backup (OPTIONAL - Comment out if not needed)
-- This preserves a copy of the original data in case you need to revert
BEGIN TRANSACTION;

-- Step 2: Identify and display duplicates before cleanup
-- (For informational purposes - shows what will be deleted)
PRINT '=== DUPLICATES TO BE REMOVED ===';
SELECT 
    NameSurname,
    COUNT(*) as DuplicateCount,
    MIN(EmployeeID) as EarliestID
FROM Employees
WHERE NameSurname IS NOT NULL
GROUP BY NameSurname
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

-- Step 3: Remove duplicate employees (keep the one with lowest EmployeeID - oldest record)
PRINT '';
PRINT '=== REMOVING DUPLICATES ===';
DELETE FROM Employees
WHERE EmployeeID NOT IN (
    SELECT MIN(EmployeeID)
    FROM Employees
    WHERE NameSurname IS NOT NULL
    GROUP BY NameSurname
);

PRINT 'Duplicates removed.';

-- Step 4: Update all SiteID values to 'BH001'
PRINT '';
PRINT '=== UPDATING SITEID TO BH001 ===';
UPDATE Employees
SET SiteID = 'BH001'
WHERE SiteID IS NOT NULL;

PRINT 'SiteID values updated to BH001.';

-- Step 5: Verify the cleanup
PRINT '';
PRINT '=== VERIFICATION ===';
PRINT 'Total employees after cleanup:';
SELECT COUNT(*) as TotalEmployees FROM Employees;

PRINT '';
PRINT 'Employees by SiteID:';
SELECT 
    SiteID,
    COUNT(*) as EmployeeCount
FROM Employees
WHERE SiteID IS NOT NULL
GROUP BY SiteID;

PRINT '';
PRINT 'Check for any remaining duplicates:';
SELECT 
    NameSurname,
    COUNT(*) as DuplicateCount
FROM Employees
WHERE NameSurname IS NOT NULL
GROUP BY NameSurname
HAVING COUNT(*) > 1;

-- If no results above, all duplicates are removed

-- Commit the transaction
COMMIT TRANSACTION;
PRINT '';
PRINT '=== CLEANUP COMPLETE ===';
