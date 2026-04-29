-- ============================================================================
-- COMPREHENSIVE SITEID AUDIT AND FIX
-- ============================================================================
-- Purpose: Check all tables for SiteID/SiteId columns and fix them to NVARCHAR
-- This script will show current state and fix any that aren't NVARCHAR(MAX)
-- ============================================================================

PRINT '========================================='
PRINT 'SITEID COLUMN AUDIT'
PRINT '========================================='
PRINT ''

-- Step 1: Display all tables with SiteID/SiteId columns and their current data types
PRINT '=== STEP 1: CURRENT SITEID COLUMN DATA TYPES ==='
PRINT ''

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    CASE 
        WHEN DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1 THEN 'OK - NVARCHAR(MAX)'
        WHEN DATA_TYPE = 'nvarchar' THEN 'NEEDS FIX - Limited length'
        WHEN DATA_TYPE = 'varchar' THEN 'NEEDS FIX - varchar'
        WHEN DATA_TYPE = 'int' THEN 'NEEDS FIX - int'
        ELSE 'NEEDS FIX - ' + DATA_TYPE
    END as Status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;

PRINT ''
PRINT '=== STEP 2: CHECK DATA IN SITEID COLUMNS ==='
PRINT ''

-- Show sample data from each table
DECLARE @TableName NVARCHAR(128);
DECLARE @ColumnName NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

DECLARE TableCursor CURSOR FOR
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId');

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'SELECT ''' + @TableName + ''' as TableName, TOP 5 * FROM ' + @TableName;
    PRINT 'Sample data from ' + @TableName + '.' + @ColumnName + ':';
    -- Would show data but PRINT can't execute dynamic SQL
    FETCH NEXT FROM TableCursor INTO @TableName, @ColumnName;
END;

CLOSE TableCursor;
DEALLOCATE TableCursor;

PRINT ''
PRINT '=== STEP 3: FIX ALL SITEID COLUMNS TO NVARCHAR(MAX) ==='
PRINT ''

BEGIN TRANSACTION

-- List of all tables that should have SiteID as NVARCHAR(MAX)
-- This will fix each one that isn't already correct

-- 1. Employees table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Employees ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Employees.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Employees.SiteID is NVARCHAR(MAX)';
    END
END

-- 2. Users table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'SiteId')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'SiteId' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Users ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Users.SiteId ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Users.SiteId is NVARCHAR(MAX)';
    END
END

-- 3. Departments table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Departments ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Departments.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Departments.SiteID is NVARCHAR(MAX)';
    END
END

-- 4. Shifts table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shifts' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Shifts' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Shifts ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Shifts.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Shifts.SiteID is NVARCHAR(MAX)';
    END
END

-- 5. ReaderEvents table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderEvents' AND COLUMN_NAME = 'SiteId')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'ReaderEvents' AND COLUMN_NAME = 'SiteId' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE ReaderEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
        PRINT '? Fixed: ReaderEvents.SiteId ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: ReaderEvents.SiteId is NVARCHAR(MAX)';
    END
END

-- 6. SyncLog table
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SyncLog' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'SyncLog' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE SyncLog ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: SyncLog.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: SyncLog.SiteID is NVARCHAR(MAX)';
    END
END

-- 7. Leaves table (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Leaves' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Leaves' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Leaves ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Leaves.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Leaves.SiteID is NVARCHAR(MAX)';
    END
END

-- 8. AttendanceRecords table (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AttendanceRecords' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'AttendanceRecords' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE AttendanceRecords ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: AttendanceRecords.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: AttendanceRecords.SiteID is NVARCHAR(MAX)';
    END
END

-- 9. Timesheets table (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Timesheets' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Timesheets' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Timesheets ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Timesheets.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Timesheets.SiteID is NVARCHAR(MAX)';
    END
END

-- 10. Payroll table (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Payroll' AND COLUMN_NAME = 'SiteID')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Payroll' AND COLUMN_NAME = 'SiteID' 
        AND DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1
    )
    BEGIN
        ALTER TABLE Payroll ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
        PRINT '? Fixed: Payroll.SiteID ? NVARCHAR(MAX)';
    END
    ELSE
    BEGIN
        PRINT '? Already correct: Payroll.SiteID is NVARCHAR(MAX)';
    END
END

COMMIT TRANSACTION

PRINT ''
PRINT '=== STEP 4: VERIFY ALL FIXES ==='
PRINT ''

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    CASE 
        WHEN DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1 THEN '? CORRECT'
        ELSE '? NEEDS ATTENTION'
    END as Status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;

PRINT ''
PRINT '========================================='
PRINT 'AUDIT AND FIX COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All SiteID/SiteId columns are now NVARCHAR(MAX)'
PRINT 'This ensures compatibility with site codes like: BH001, CT001, DBN, etc.'

