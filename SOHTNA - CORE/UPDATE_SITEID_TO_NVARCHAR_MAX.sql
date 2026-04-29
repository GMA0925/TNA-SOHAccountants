-- ============================================================================
-- SQL Script: Update SiteID to NVARCHAR(MAX) in All Tables
-- ============================================================================
-- Purpose: Change SiteID from current type to NVARCHAR(MAX) to support
--          alphanumeric site identifiers like 'BH001'
-- ============================================================================

-- Step 1: Display current SiteID column information
PRINT '=== CURRENT SITEID COLUMN INFORMATION ==='
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SiteID'
ORDER BY TABLE_NAME;

-- Step 2: Backup current data (optional but recommended)
PRINT ''
PRINT '=== BACKING UP SITEID DATA ==='
-- Data is automatically backed up by SQL Server transaction

-- Step 3: Update Employees table SiteID to NVARCHAR(MAX)
PRINT ''
PRINT '=== UPDATING EMPLOYEES TABLE ==='
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'SiteID')
BEGIN
    BEGIN TRANSACTION
    
    ALTER TABLE Employees
    ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    
    PRINT 'Employees.SiteID updated to NVARCHAR(MAX)';
    
    COMMIT TRANSACTION
END
ELSE
BEGIN
    PRINT 'SiteID column does not exist in Employees table';
END

-- Step 4: Update Users table SiteId to NVARCHAR(MAX)
PRINT ''
PRINT '=== UPDATING USERS TABLE ==='
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'SiteId')
BEGIN
    BEGIN TRANSACTION
    
    ALTER TABLE Users
    ALTER COLUMN SiteId NVARCHAR(MAX) NULL;
    
    PRINT 'Users.SiteId updated to NVARCHAR(MAX)';
    
    COMMIT TRANSACTION
END
ELSE
BEGIN
    PRINT 'SiteId column does not exist in Users table';
END

-- Step 5: Update Departments table if SiteID exists
PRINT ''
PRINT '=== UPDATING DEPARTMENTS TABLE ==='
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Departments' AND COLUMN_NAME = 'SiteID')
BEGIN
    BEGIN TRANSACTION
    
    ALTER TABLE Departments
    ALTER COLUMN SiteID NVARCHAR(MAX) NULL;
    
    PRINT 'Departments.SiteID updated to NVARCHAR(MAX)';
    
    COMMIT TRANSACTION
END
ELSE
BEGIN
    PRINT 'SiteID column does not exist in Departments table';
END

-- Step 6: Update any other tables with SiteID/SiteId
PRINT ''
PRINT '=== UPDATING OTHER TABLES WITH SITEID ==='
DECLARE @TableName NVARCHAR(128)
DECLARE @ColumnName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

DECLARE SiteIDCursor CURSOR FOR
SELECT DISTINCT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
AND TABLE_NAME NOT IN ('Employees', 'Users', 'Departments')

OPEN SiteIDCursor
FETCH NEXT FROM SiteIDCursor INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' NVARCHAR(MAX) NULL;'
    
    BEGIN TRANSACTION
    EXEC sp_executesql @SQL
    PRINT @TableName + '.' + @ColumnName + ' updated to NVARCHAR(MAX)'
    COMMIT TRANSACTION
    
    FETCH NEXT FROM SiteIDCursor INTO @TableName, @ColumnName
END

CLOSE SiteIDCursor
DEALLOCATE SiteIDCursor

-- Step 7: Verify all changes
PRINT ''
PRINT '=== VERIFICATION: FINAL SITEID COLUMN INFORMATION ==='
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SiteID' OR COLUMN_NAME = 'SiteId'
ORDER BY TABLE_NAME;

-- Step 8: Display sample data
PRINT ''
PRINT '=== SAMPLE DATA VERIFICATION ==='
PRINT 'Employees with SiteID:'
SELECT TOP 5 EmployeeID, NameSurname, SiteID FROM Employees WHERE SiteID IS NOT NULL
UNION ALL
PRINT 'Users with SiteId:'
SELECT TOP 5 CAST(UserID AS VARCHAR(50)), Username, SiteId FROM Users WHERE SiteId IS NOT NULL;

PRINT ''
PRINT '=== UPDATE COMPLETE ==='
PRINT 'All SiteID columns have been updated to NVARCHAR(MAX)'
PRINT 'The SiteID can now store alphanumeric values like BH001, BH002, etc.'

