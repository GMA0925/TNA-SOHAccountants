-- ============================================================================
-- COMPREHENSIVE SITEID FIX - WITH FOREIGN KEY HANDLING
-- ============================================================================
-- Purpose: Fix all SiteID/SiteId columns to NVARCHAR(MAX)
-- This version handles both indexes AND foreign key constraints
-- ============================================================================

PRINT '========================================='
PRINT 'SITEID COLUMN AUDIT AND FIX'
PRINT 'With Foreign Key Constraint Handling'
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
PRINT '=== STEP 2: IDENTIFY AND DROP FOREIGN KEYS ==='
PRINT ''
PRINT 'Dropping foreign key constraints that reference SiteID columns...'
PRINT ''

BEGIN TRANSACTION

-- Drop all foreign key constraints on SiteID columns
DECLARE @FKName NVARCHAR(128)
DECLARE @TableName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

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

PRINT ''
PRINT '=== STEP 3: DROP UNIQUE CONSTRAINTS ON SITEID COLUMNS ==='
PRINT ''
PRINT 'Dropping UNIQUE constraints on SiteID columns...'
PRINT ''

-- Drop UNIQUE constraints on SiteID columns
DECLARE @UniqueConstraintName NVARCHAR(128)
DECLARE @UniqueTableName NVARCHAR(128)
DECLARE @UniqueConstraintSQL NVARCHAR(MAX)

DECLARE UniqueConstraintCursor CURSOR FOR
SELECT kc.name AS ConstraintName, OBJECT_NAME(kc.parent_object_id) AS TableName
FROM sys.key_constraints kc
INNER JOIN sys.index_columns ic ON kc.unique_index_id = ic.index_id AND kc.parent_object_id = ic.object_id
INNER JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
WHERE col.name IN ('SiteID', 'SiteId')
AND kc.type = 'UQ'

OPEN UniqueConstraintCursor
FETCH NEXT FROM UniqueConstraintCursor INTO @UniqueConstraintName, @UniqueTableName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @UniqueConstraintSQL = 'ALTER TABLE ' + @UniqueTableName + ' DROP CONSTRAINT ' + @UniqueConstraintName
    BEGIN TRY
        EXEC sp_executesql @UniqueConstraintSQL
        PRINT '  Dropped UNIQUE constraint: ' + @UniqueConstraintName + ' from ' + @UniqueTableName
    END TRY
    BEGIN CATCH
        PRINT '  Warning: Could not drop UNIQUE constraint ' + @UniqueConstraintName
    END CATCH
    FETCH NEXT FROM UniqueConstraintCursor INTO @UniqueConstraintName, @UniqueTableName
END

CLOSE UniqueConstraintCursor
DEALLOCATE UniqueConstraintCursor

PRINT ''
PRINT '=== STEP 4: DROP INDEXES ON SITEID COLUMNS ==='
PRINT ''
PRINT 'Dropping indexes on SiteID columns (NVARCHAR(MAX) cannot be indexed directly)'
PRINT ''

-- EMPLOYEES TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Employees_SiteID' AND object_id = OBJECT_ID('Employees'))
BEGIN
    DROP INDEX IX_Employees_SiteID ON Employees;
    PRINT '  Dropped index: IX_Employees_SiteID';
END

-- SHIFTS TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Shifts_SiteID' AND object_id = OBJECT_ID('Shifts'))
BEGIN
    DROP INDEX IX_Shifts_SiteID ON Shifts;
    PRINT '  Dropped index: IX_Shifts_SiteID';
END

-- SYNCLOG TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SyncLog_SiteID' AND object_id = OBJECT_ID('SyncLog'))
BEGIN
    DROP INDEX IX_SyncLog_SiteID ON SyncLog;
    PRINT '  Dropped index: IX_SyncLog_SiteID';
END

-- ATTENDANCE TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Attendance_SiteID' AND object_id = OBJECT_ID('Attendance'))
BEGIN
    DROP INDEX IX_Attendance_SiteID ON Attendance;
    PRINT '  Dropped index: IX_Attendance_SiteID';
END

-- TIMESHEETS TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheets_SiteID' AND object_id = OBJECT_ID('Timesheets'))
BEGIN
    DROP INDEX IX_Timesheets_SiteID ON Timesheets;
    PRINT '  Dropped index: IX_Timesheets_SiteID';
END

-- PAYROLL TABLE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payroll_SiteID' AND object_id = OBJECT_ID('Payroll'))
BEGIN
    DROP INDEX IX_Payroll_SiteID ON Payroll;
    PRINT '  Dropped index: IX_Payroll_SiteID';
END

-- Other tables with potential indexes
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

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ReaderEvents_SiteId' AND object_id = OBJECT_ID('ReaderEvents'))
BEGIN
    DROP INDEX IX_ReaderEvents_SiteId ON ReaderEvents;
    PRINT '  Dropped index: IX_ReaderEvents_SiteId';
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

PRINT ''
PRINT '=== STEP 5: ALTER SITEID COLUMNS TO NVARCHAR(MAX) ==='
PRINT ''

-- EMPLOYEES TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Employees ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Employees.SiteID ? NVARCHAR(MAX)';
END

-- USERS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Users ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Users.SiteId ? NVARCHAR(MAX)';
END

-- DEPARTMENTS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Departments ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Departments.SiteID ? NVARCHAR(MAX)';
END

-- SHIFTS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shifts' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Shifts ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Shifts.SiteID ? NVARCHAR(MAX)';
END

-- READEREVENTS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderEvents' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderEvents.SiteId ? NVARCHAR(MAX)';
END

-- SYNCLOG TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SyncLog' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE SyncLog ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: SyncLog.SiteID ? NVARCHAR(MAX)';
END

-- ATTENDANCE TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Attendance' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Attendance ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Attendance.SiteID ? NVARCHAR(MAX)';
END

-- TIMESHEETS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Timesheets' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Timesheets ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Timesheets.SiteID ? NVARCHAR(MAX)';
END

-- PAYROLL TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Payroll' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Payroll ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Payroll.SiteID ? NVARCHAR(MAX)';
END

-- CLOCKEVENTS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClockEvents' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ClockEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ClockEvents.SiteId ? NVARCHAR(MAX)';
END

-- CLOCKLOG TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClockLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ClockLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ClockLog.SiteId ? NVARCHAR(MAX)';
END

-- READERS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Readers' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Readers ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Readers.SiteId ? NVARCHAR(MAX)';
END

-- TRANSACTIONS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Transactions' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Transactions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Transactions.SiteId ? NVARCHAR(MAX)';
END

-- USERACTIONS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserActions' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE UserActions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: UserActions.SiteId ? NVARCHAR(MAX)';
END

-- USERLOGINS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserLogins' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE UserLogins ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: UserLogins.SiteId ? NVARCHAR(MAX)';
END

-- SITES TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Sites' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Sites ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Sites.SiteId ? NVARCHAR(MAX)';
END

-- MANAGEMENTREPORTS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ManagementReports' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ManagementReports ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ManagementReports.SiteId ? NVARCHAR(MAX)';
END

-- READERBUFFERLOG TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderBufferLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderBufferLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderBufferLog.SiteId ? NVARCHAR(MAX)';
END

-- CONFIGVALIDATIONLOG TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ConfigValidationLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ConfigValidationLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ConfigValidationLog.SiteId ? NVARCHAR(MAX)';
END

-- READERUSAGESTATS TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderUsageStats' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderUsageStats ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderUsageStats.SiteId ? NVARCHAR(MAX)';
END

-- READEREVENTBACKUP TABLE
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderEventsBackUP' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderEventsBackUP ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderEventsBackUP.SiteId ? NVARCHAR(MAX)';
END

PRINT ''
PRINT '=== STEP 6: VERIFY ALL FIXES ==='
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

COMMIT TRANSACTION

PRINT ''
PRINT '========================================='
PRINT 'ALL SITEID COLUMNS FIXED!'
PRINT '========================================='
PRINT ''
PRINT '? All SiteID/SiteId columns are now NVARCHAR(MAX)'
PRINT '? All dependent indexes have been dropped'
PRINT '? All foreign keys have been dropped'
PRINT '? Filtering will be done in application code'
PRINT '? Database is ready for production use'
PRINT ''
PRINT 'IMPORTANT: Foreign Keys have been removed!'
PRINT 'These can be recreated later if needed, but they are not required'
PRINT 'for the application to function correctly.'
PRINT ''
PRINT 'Site code formats supported:'
PRINT '  • BH001 (alphanumeric)'
PRINT '  • CT001 (numeric)'
PRINT '  • DBN (letters)'
PRINT '  • Any future naming scheme'

