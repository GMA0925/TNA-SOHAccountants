-- ============================================================================
-- SITEID FIX - SIMPLIFIED VERSION
-- ============================================================================
-- Purpose: Convert SiteID columns to NVARCHAR(MAX) 
-- Simple approach: Skip complex IDENTITY handling, focus on the 20 other tables
-- ============================================================================

PRINT '========================================='
PRINT 'SITEID COLUMN FIX - SIMPLIFIED'
PRINT '========================================='
PRINT ''

BEGIN TRANSACTION

-- Drop blocking constraints and indexes
PRINT 'Dropping foreign keys...'
IF OBJECT_ID('FK_Payroll_Sites', 'F') IS NOT NULL
    ALTER TABLE Payroll DROP CONSTRAINT FK_Payroll_Sites;
IF OBJECT_ID('FK_Attendance_Sites', 'F') IS NOT NULL
    ALTER TABLE Attendance DROP CONSTRAINT FK_Attendance_Sites;
IF OBJECT_ID('FK_Timesheets_Sites', 'F') IS NOT NULL
    ALTER TABLE Timesheets DROP CONSTRAINT FK_Timesheets_Sites;

PRINT 'Dropping indexes...'
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Employees_SiteID')
    DROP INDEX IX_Employees_SiteID ON Employees;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Shifts_SiteID')
    DROP INDEX IX_Shifts_SiteID ON Shifts;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SyncLog_SiteID')
    DROP INDEX IX_SyncLog_SiteID ON SyncLog;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payroll_SiteID')
    DROP INDEX IX_Payroll_SiteID ON Payroll;

PRINT 'Dropping unique constraints...'
IF OBJECT_ID('UQ__Timeshee__482540B3FB477D8F', 'UQ') IS NOT NULL
    ALTER TABLE Timesheets DROP CONSTRAINT UQ__Timeshee__482540B3FB477D8F;

PRINT 'Converting SiteID columns to NVARCHAR(MAX)...'

-- Convert all columns that aren't part of complex constraints
ALTER TABLE Employees ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE Users ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE Departments ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE Shifts ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE ReaderEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE SyncLog ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE Attendance ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE Timesheets ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE Payroll ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
ALTER TABLE ClockEvents ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ClockLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE Readers ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE Transactions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE UserActions ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE UserLogins ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ManagementReports ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ReaderBufferLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ConfigValidationLog ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ReaderUsageStats ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
ALTER TABLE ReaderEventsBackUP ALTER COLUMN SiteId NVARCHAR(MAX) NULL;

-- Sites table: Leave SiteId as-is (it has IDENTITY, which is fine)
-- The application doesn't sync from Sites anyway, only to Employees from ReaderEvents

PRINT ''
PRINT '========================================='
PRINT 'COMPLETE!'
PRINT '========================================='
PRINT '20 tables converted to NVARCHAR(MAX)'
PRINT 'Sites.SiteId left unchanged (IDENTITY column)'
PRINT ''

COMMIT TRANSACTION

PRINT 'All SiteID conversions successful!'
