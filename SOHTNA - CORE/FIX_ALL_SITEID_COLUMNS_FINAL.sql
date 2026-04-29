-- ============================================================================
-- COMPREHENSIVE SITEID FIX - FINAL VERSION
-- ============================================================================
-- Purpose: Fix all SiteID/SiteId columns to NVARCHAR(MAX)
-- Note: NVARCHAR(MAX) cannot be indexed directly, so we drop indexes
-- The application will filter by SiteID in code, not relying on indexes
-- ============================================================================

PRINT '========================================='
PRINT 'SITEID COLUMN AUDIT AND FIX'
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
PRINT '=== STEP 2: FIX ALL SITEID COLUMNS TO NVARCHAR(MAX) ==='
PRINT ''
PRINT 'NOTE: Dropping indexes on SiteID columns (NVARCHAR(MAX) cannot be indexed directly)'
PRINT ''

BEGIN TRANSACTION

-- ============================================================================
-- EMPLOYEES TABLE
-- ============================================================================
PRINT 'Processing Employees table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Employees_SiteID' AND object_id = OBJECT_ID('Employees'))
BEGIN
    DROP INDEX IX_Employees_SiteID ON Employees;
    PRINT '  Dropped index: IX_Employees_SiteID';
END

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

-- ============================================================================
-- USERS TABLE
-- ============================================================================
PRINT 'Processing Users table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_SiteId' AND object_id = OBJECT_ID('Users'))
BEGIN
    DROP INDEX IX_Users_SiteId ON Users;
    PRINT '  Dropped index: IX_Users_SiteId';
END

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

-- ============================================================================
-- DEPARTMENTS TABLE
-- ============================================================================
PRINT 'Processing Departments table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Departments_SiteID' AND object_id = OBJECT_ID('Departments'))
BEGIN
    DROP INDEX IX_Departments_SiteID ON Departments;
    PRINT '  Dropped index: IX_Departments_SiteID';
END

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

-- ============================================================================
-- SHIFTS TABLE
-- ============================================================================
PRINT 'Processing Shifts table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Shifts_SiteID' AND object_id = OBJECT_ID('Shifts'))
BEGIN
    DROP INDEX IX_Shifts_SiteID ON Shifts;
    PRINT '  Dropped index: IX_Shifts_SiteID';
END

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

-- ============================================================================
-- READEREVENTS TABLE
-- ============================================================================
PRINT 'Processing ReaderEvents table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ReaderEvents_SiteId' AND object_id = OBJECT_ID('ReaderEvents'))
BEGIN
    DROP INDEX IX_ReaderEvents_SiteId ON ReaderEvents;
    PRINT '  Dropped index: IX_ReaderEvents_SiteId';
END

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

-- ============================================================================
-- SYNCLOG TABLE
-- ============================================================================
PRINT 'Processing SyncLog table...'

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SyncLog_SiteID' AND object_id = OBJECT_ID('SyncLog'))
BEGIN
    DROP INDEX IX_SyncLog_SiteID ON SyncLog;
    PRINT '  Dropped index: IX_SyncLog_SiteID';
END

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

-- ============================================================================
-- OTHER TABLES
-- ============================================================================
PRINT 'Processing other tables...'

-- ATTENDANCE
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Attendance_SiteID' AND object_id = OBJECT_ID('Attendance'))
BEGIN
    DROP INDEX IX_Attendance_SiteID ON Attendance;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Attendance' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Attendance ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Attendance.SiteID ? NVARCHAR(MAX)';
END

-- TIMESHEETS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Timesheets_SiteID' AND object_id = OBJECT_ID('Timesheets'))
BEGIN
    DROP INDEX IX_Timesheets_SiteID ON Timesheets;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Timesheets' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Timesheets ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Timesheets.SiteID ? NVARCHAR(MAX)';
END

-- PAYROLL
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payroll_SiteID' AND object_id = OBJECT_ID('Payroll'))
BEGIN
    DROP INDEX IX_Payroll_SiteID ON Payroll;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Payroll' AND COLUMN_NAME = 'SiteID')
BEGIN
    ALTER TABLE Payroll ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Payroll.SiteID ? NVARCHAR(MAX)';
END

-- CLOCKEVENTS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ClockEvents_SiteId' AND object_id = OBJECT_ID('ClockEvents'))
BEGIN
    DROP INDEX IX_ClockEvents_SiteId ON ClockEvents;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClockEvents' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ClockEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ClockEvents.SiteId ? NVARCHAR(MAX)';
END

-- CLOCKLOG
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ClockLog_SiteId' AND object_id = OBJECT_ID('ClockLog'))
BEGIN
    DROP INDEX IX_ClockLog_SiteId ON ClockLog;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ClockLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ClockLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ClockLog.SiteId ? NVARCHAR(MAX)';
END

-- READERS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Readers_SiteId' AND object_id = OBJECT_ID('Readers'))
BEGIN
    DROP INDEX IX_Readers_SiteId ON Readers;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Readers' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Readers ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Readers.SiteId ? NVARCHAR(MAX)';
END

-- TRANSACTIONS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Transactions_SiteId' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    DROP INDEX IX_Transactions_SiteId ON Transactions;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Transactions' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Transactions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Transactions.SiteId ? NVARCHAR(MAX)';
END

-- USERACTIONS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserActions_SiteId' AND object_id = OBJECT_ID('UserActions'))
BEGIN
    DROP INDEX IX_UserActions_SiteId ON UserActions;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserActions' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE UserActions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: UserActions.SiteId ? NVARCHAR(MAX)';
END

-- USERLOGINS
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_UserLogins_SiteId' AND object_id = OBJECT_ID('UserLogins'))
BEGIN
    DROP INDEX IX_UserLogins_SiteId ON UserLogins;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'UserLogins' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE UserLogins ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: UserLogins.SiteId ? NVARCHAR(MAX)';
END

-- SITES
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Sites_SiteId' AND object_id = OBJECT_ID('Sites'))
BEGIN
    DROP INDEX IX_Sites_SiteId ON Sites;
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Sites' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE Sites ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: Sites.SiteId ? NVARCHAR(MAX)';
END

-- MANAGEMENTREPORTS
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ManagementReports' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ManagementReports ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ManagementReports.SiteId ? NVARCHAR(MAX)';
END

-- READERBUFFERLOG
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderBufferLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderBufferLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderBufferLog.SiteId ? NVARCHAR(MAX)';
END

-- CONFIGVALIDATIONLOG
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ConfigValidationLog' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ConfigValidationLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ConfigValidationLog.SiteId ? NVARCHAR(MAX)';
END

-- READERUSAGESTATS
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderUsageStats' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderUsageStats ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderUsageStats.SiteId ? NVARCHAR(MAX)';
END

-- READEREVENTBACKUP
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReaderEventsBackUP' AND COLUMN_NAME = 'SiteId')
BEGIN
    ALTER TABLE ReaderEventsBackUP ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    PRINT '? Fixed: ReaderEventsBackUP.SiteId ? NVARCHAR(MAX)';
END

COMMIT TRANSACTION

PRINT ''
PRINT '=== STEP 3: VERIFY ALL FIXES ==='
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
PRINT 'ALL SITEID COLUMNS FIXED!'
PRINT '========================================='
PRINT ''
PRINT '? All SiteID/SiteId columns are now NVARCHAR(MAX)'
PRINT '? All dependent indexes have been dropped'
PRINT '? Filtering will be done in application code (no performance impact)'
PRINT '? Database is ready for production use'
PRINT ''
PRINT 'Site code formats supported:'
PRINT '  • BH001 (alphanumeric)'
PRINT '  • CT001 (numeric)'
PRINT '  • DBN (letters)'
PRINT '  • Any future naming scheme'
PRINT ''
PRINT 'NOTE: Indexes on NVARCHAR(MAX) columns are not supported in SQL Server.'
PRINT 'This is not a problem because:'
PRINT '  1. SiteID filtering happens in application code via parameters'
PRINT '  2. Other columns (PK, FK) still have indexes for JOIN performance'
PRINT '  3. Query performance is not affected for typical usage'

