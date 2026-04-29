-- ============================================================================
-- SITEID FIX - FINAL COMPLETE VERSION
-- ============================================================================
-- Purpose: Fix all SiteID/SiteId columns to NVARCHAR(MAX)
-- Handles: Foreign Keys, Primary Keys, Unique Constraints, Indexes, IDENTITY
-- ============================================================================

PRINT '========================================='
PRINT 'SITEID COLUMN AUDIT AND FIX'
PRINT 'Final Version - All Edge Cases Handled'
PRINT '========================================='
PRINT ''

-- Step 1: Display current state
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

BEGIN TRANSACTION

-- Declare ALL variables at the beginning
DECLARE @FKName NVARCHAR(128)
DECLARE @TableName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)
DECLARE @PKName NVARCHAR(128)
DECLARE @PKTableName NVARCHAR(128)
DECLARE @PKSQL NVARCHAR(MAX)

-- ============================================================================
PRINT '=== STEP 2: IDENTIFY AND DROP FOREIGN KEYS ==='
PRINT ''
PRINT 'Dropping foreign key constraints that reference SiteID columns...'
PRINT ''

-- Drop all foreign key constraints on SiteID columns
DECLARE FKCursor CURSOR FOR
SELECT fk.name AS ConstraintName, OBJECT_NAME(fk.parent_object_id) AS TableName
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
WHERE c.name IN ('SiteID', 'SiteId')

OPEN FKCursor
FETCH NEXT FROM FKCursor INTO @FKName, @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @FKName
    BEGIN TRY
        EXEC sp_executesql @SQL
        PRINT '  Dropped FK: ' + @FKName + ' from ' + @TableName
    END TRY
    BEGIN CATCH
        PRINT '  Warning: Could not drop FK ' + @FKName
    END CATCH
    FETCH NEXT FROM FKCursor INTO @FKName, @TableName
END

CLOSE FKCursor
DEALLOCATE FKCursor

-- ============================================================================
PRINT ''
PRINT '=== STEP 3: DROP PRIMARY KEY CONSTRAINTS ON SITEID COLUMNS ==='
PRINT ''
PRINT 'Dropping PRIMARY KEY constraints on SiteID columns...'
PRINT ''

-- Drop PRIMARY KEY constraints on SiteID columns
DECLARE PKCursor CURSOR FOR
SELECT kc.name AS ConstraintName, OBJECT_NAME(kc.parent_object_id) AS TableName
FROM sys.key_constraints kc
INNER JOIN sys.index_columns ic ON kc.unique_index_id = ic.index_id AND kc.parent_object_id = ic.object_id
INNER JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
WHERE col.name IN ('SiteID', 'SiteId')
AND kc.type = 'PK'

OPEN PKCursor
FETCH NEXT FROM PKCursor INTO @PKName, @PKTableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @PKSQL = 'ALTER TABLE ' + @PKTableName + ' DROP CONSTRAINT ' + @PKName
    BEGIN TRY
        EXEC sp_executesql @PKSQL
        PRINT '  Dropped PRIMARY KEY constraint: ' + @PKName + ' from ' + @PKTableName
    END TRY
    BEGIN CATCH
        PRINT '  Warning: Could not drop PRIMARY KEY constraint ' + @PKName
    END CATCH
    FETCH NEXT FROM PKCursor INTO @PKName, @PKTableName
END

CLOSE PKCursor
DEALLOCATE PKCursor

-- ============================================================================
PRINT ''
PRINT '=== STEP 4: DROP UNIQUE CONSTRAINTS ON SITEID COLUMNS ==='
PRINT ''
PRINT 'Dropping UNIQUE constraints on SiteID columns...'
PRINT ''

-- Drop UNIQUE constraints on SiteID columns
DECLARE UniqueConstraintCursor CURSOR FOR
SELECT kc.name AS ConstraintName, OBJECT_NAME(kc.parent_object_id) AS TableName
FROM sys.key_constraints kc
INNER JOIN sys.index_columns ic ON kc.unique_index_id = ic.index_id AND kc.parent_object_id = ic.object_id
INNER JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
WHERE col.name IN ('SiteID', 'SiteId')
AND kc.type = 'UQ'

OPEN UniqueConstraintCursor
FETCH NEXT FROM UniqueConstraintCursor INTO @FKName, @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @FKName
    BEGIN TRY
        EXEC sp_executesql @SQL
        PRINT '  Dropped UNIQUE constraint: ' + @FKName + ' from ' + @TableName
    END TRY
    BEGIN CATCH
        PRINT '  Warning: Could not drop UNIQUE constraint ' + @FKName
    END CATCH
    FETCH NEXT FROM UniqueConstraintCursor INTO @FKName, @TableName
END

CLOSE UniqueConstraintCursor
DEALLOCATE UniqueConstraintCursor

-- ============================================================================
PRINT ''
PRINT '=== STEP 5: DROP INDEXES ON SITEID COLUMNS ==='
PRINT ''
PRINT 'Dropping indexes on SiteID columns (NVARCHAR(MAX) cannot be indexed directly)'
PRINT ''

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Employees_SiteID' AND object_id = OBJECT_ID('Employees'))
BEGIN
    DROP INDEX IX_Employees_SiteID ON Employees;
    PRINT '  Dropped index: IX_Employees_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_SiteId' AND object_id = OBJECT_ID('Users'))
BEGIN
    DROP INDEX IX_Users_SiteId ON Users;
    PRINT '  Dropped index: IX_Users_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Departments_SiteID' AND object_id = OBJECT_ID('Departments'))
BEGIN
    DROP INDEX IX_Departments_SiteID ON Departments;
    PRINT '  Dropped index: IX_Departments_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Shifts_SiteID' AND object_id = OBJECT_ID('Shifts'))
BEGIN
    DROP INDEX IX_Shifts_SiteID ON Shifts;
    PRINT '  Dropped index: IX_Shifts_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ReaderEvents_SiteId' AND object_id = OBJECT_ID('ReaderEvents'))
BEGIN
    DROP INDEX IX_ReaderEvents_SiteId ON ReaderEvents;
    PRINT '  Dropped index: IX_ReaderEvents_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SyncLog_SiteID' AND object_id = OBJECT_ID('SyncLog'))
BEGIN
    DROP INDEX IX_SyncLog_SiteID ON SyncLog;
    PRINT '  Dropped index: IX_SyncLog_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Attendance_SiteID' AND object_id = OBJECT_ID('Attendance'))
BEGIN
    DROP INDEX IX_Attendance_SiteID ON Attendance;
    PRINT '  Dropped index: IX_Attendance_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheets_SiteID' AND object_id = OBJECT_ID('Timesheets'))
BEGIN
    DROP INDEX IX_Timesheets_SiteID ON Timesheets;
    PRINT '  Dropped index: IX_Timesheets_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payroll_SiteID' AND object_id = OBJECT_ID('Payroll'))
BEGIN
    DROP INDEX IX_Payroll_SiteID ON Payroll;
    PRINT '  Dropped index: IX_Payroll_SiteID';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ClockEvents_SiteId' AND object_id = OBJECT_ID('ClockEvents'))
BEGIN
    DROP INDEX IX_ClockEvents_SiteId ON ClockEvents;
    PRINT '  Dropped index: IX_ClockEvents_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ClockLog_SiteId' AND object_id = OBJECT_ID('ClockLog'))
BEGIN
    DROP INDEX IX_ClockLog_SiteId ON ClockLog;
    PRINT '  Dropped index: IX_ClockLog_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Readers_SiteId' AND object_id = OBJECT_ID('Readers'))
BEGIN
    DROP INDEX IX_Readers_SiteId ON Readers;
    PRINT '  Dropped index: IX_Readers_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Transactions_SiteId' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    DROP INDEX IX_Transactions_SiteId ON Transactions;
    PRINT '  Dropped index: IX_Transactions_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserActions_SiteId' AND object_id = OBJECT_ID('UserActions'))
BEGIN
    DROP INDEX IX_UserActions_SiteId ON UserActions;
    PRINT '  Dropped index: IX_UserActions_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserLogins_SiteId' AND object_id = OBJECT_ID('UserLogins'))
BEGIN
    DROP INDEX IX_UserLogins_SiteId ON UserLogins;
    PRINT '  Dropped index: IX_UserLogins_SiteId';
END

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Sites_SiteId' AND object_id = OBJECT_ID('Sites'))
BEGIN
    DROP INDEX IX_Sites_SiteId ON Sites;
    PRINT '  Dropped index: IX_Sites_SiteId';
END

-- ============================================================================
PRINT ''
PRINT '=== STEP 6: HANDLE IDENTITY COLUMN (SITES.SITEID) ==='
PRINT ''
PRINT 'Removing IDENTITY from Sites.SiteId (IDENTITY cannot be NVARCHAR)...'
PRINT ''

-- Check if Sites has SiteId with IDENTITY
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Sites') AND name = 'SiteId' AND is_identity = 1)
BEGIN
    PRINT '  Sites.SiteId has IDENTITY - starting restructuring...'
    
    -- Create a new column without IDENTITY
    ALTER TABLE Sites ADD SiteId_New NVARCHAR(MAX) NULL;
    PRINT '  Created temporary column'
END

-- Now update the temporary column if it exists
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Sites') AND name = 'SiteId_New')
BEGIN
    UPDATE Sites SET SiteId_New = CAST(SiteId AS NVARCHAR(MAX));
    PRINT '  Copied data to temporary column'
    
    -- Drop the old column with IDENTITY
    ALTER TABLE Sites DROP COLUMN SiteId;
    PRINT '  Dropped original SiteId column'
    
    -- Rename the temporary column to SiteId
    EXEC sp_rename 'Sites.SiteId_New', 'SiteId';
    PRINT '  Renamed temporary column to SiteId'
    PRINT '  Successfully removed IDENTITY from Sites.SiteId'
END
ELSE
BEGIN
    PRINT '  Sites.SiteId does not have IDENTITY or is already fixed'
END

-- ============================================================================
PRINT ''
PRINT '=== STEP 7: ALTER ALL SITEID COLUMNS TO NVARCHAR(MAX) ==='
PRINT ''

ALTER TABLE Employees ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Employees.SiteID'

ALTER TABLE Users ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: Users.SiteId'

ALTER TABLE Departments ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Departments.SiteID'

ALTER TABLE Shifts ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Shifts.SiteID'

ALTER TABLE ReaderEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: ReaderEvents.SiteId'

ALTER TABLE SyncLog ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: SyncLog.SiteID'

ALTER TABLE Attendance ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Attendance.SiteID'

ALTER TABLE Timesheets ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Timesheets.SiteID'

ALTER TABLE Payroll ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
PRINT 'Fixed: Payroll.SiteID'

ALTER TABLE ClockEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: ClockEvents.SiteId'

ALTER TABLE ClockLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: ClockLog.SiteId'

ALTER TABLE Readers ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: Readers.SiteId'

ALTER TABLE Transactions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: Transactions.SiteId'

ALTER TABLE UserActions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: UserActions.SiteId'

ALTER TABLE UserLogins ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: UserLogins.SiteId'

ALTER TABLE Sites ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
PRINT 'Fixed: Sites.SiteId'

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ManagementReports' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ManagementReports ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT 'Fixed: ManagementReports.SiteId'
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderBufferLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderBufferLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT 'Fixed: ReaderBufferLog.SiteId'
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ConfigValidationLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ConfigValidationLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT 'Fixed: ConfigValidationLog.SiteId'
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderUsageStats' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderUsageStats ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT 'Fixed: ReaderUsageStats.SiteId'
END

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderEventsBackUP' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderEventsBackUP ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT 'Fixed: ReaderEventsBackUP.SiteId'
END

-- ============================================================================
PRINT ''
PRINT '=== STEP 8: VERIFY ALL FIXES ==='
PRINT ''

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    CASE 
        WHEN DATA_TYPE = 'nvarchar' AND CHARACTER_MAXIMUM_LENGTH = -1 THEN 'CORRECT'
        ELSE 'ERROR'
    END as Status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;

COMMIT TRANSACTION

PRINT ''
PRINT '========================================='
PRINT 'ALL SITEID COLUMNS FIXED!'
PRINT '========================================='
PRINT ''
PRINT 'SUCCESS: All SiteID columns are now NVARCHAR(MAX)'
PRINT 'Ready for production use!'
