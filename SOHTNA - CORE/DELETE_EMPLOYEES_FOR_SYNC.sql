-- ============================================================================
-- SAFE EMPLOYEE DELETION SCRIPT
-- ============================================================================
-- Purpose: Safely delete all employees before recreating from ReaderEvents
-- Use this script BEFORE using the sync feature to recreate employees
-- ============================================================================

PRINT '=== STEP 1: BACKUP EMPLOYEES DATA ==='
PRINT 'Creating backup table in case you need to restore...'

-- Create backup of current employees (if it doesn't exist)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employees_Backup_Before_Sync')
BEGIN
    DROP TABLE Employees_Backup_Before_Sync;
    PRINT 'Dropped old backup table'
END

SELECT * INTO Employees_Backup_Before_Sync FROM Employees;
PRINT 'Backup created: Employees_Backup_Before_Sync'

-- Show how many we're backing up
SELECT COUNT(*) as Backed_Up_Employee_Count FROM Employees_Backup_Before_Sync;

PRINT ''
PRINT '=== STEP 2: SHOW CURRENT EMPLOYEES BEFORE DELETION ==='
SELECT TOP 20 
    EmployeeID, 
    NameSurname, 
    SiteID,
    IsActive,
    CreatedDate
FROM Employees
ORDER BY EmployeeID;

PRINT ''
PRINT '=== STEP 3: DELETE ALL EMPLOYEES ==='

BEGIN TRANSACTION

DELETE FROM Employees;

PRINT 'All employees deleted.'

-- Verify deletion
DECLARE @DeletedCount INT;
SELECT @DeletedCount = COUNT(*) FROM Employees;
PRINT 'Remaining employees: ' + CAST(@DeletedCount AS NVARCHAR(10));

COMMIT TRANSACTION

PRINT ''
PRINT '=== STEP 4: VERIFY EMPLOYEES TABLE IS EMPTY ==='
SELECT COUNT(*) as Total_Employee_Records FROM Employees;

PRINT ''
PRINT '=== STEP 5: CHECK READEREVENTDATA FOR SYNC ==='
PRINT 'After deletion, the sync feature will recreate employees from ReaderEvents.'
PRINT 'Checking available events to sync:'

SELECT 
    SiteId,
    COUNT(DISTINCT PersonName) as Unique_People,
    COUNT(*) as Total_Events,
    MIN(Timestamp) as First_Event,
    MAX(Timestamp) as Last_Event
FROM ReaderEvents
WHERE PersonName IS NOT NULL
  AND PersonName <> ''
GROUP BY SiteId
ORDER BY SiteId;

PRINT ''
PRINT '=== STEP 6: READY FOR SYNC ==='
PRINT 'The Employees table is now empty and ready for sync.'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Login to the application'
PRINT '2. Go to Employee Enrollment page'
PRINT '3. Click [?? Sync Employees] button'
PRINT '4. Wait for sync to complete'
PRINT '5. New employees will be created from ReaderEvents data'
PRINT '6. SiteID will be populated with values like BH001, CT001, etc.'
PRINT ''
PRINT 'If you need to restore:'
PRINT '   SELECT * FROM Employees_Backup_Before_Sync'

PRINT ''
PRINT '=== DELETION COMPLETE ==='

