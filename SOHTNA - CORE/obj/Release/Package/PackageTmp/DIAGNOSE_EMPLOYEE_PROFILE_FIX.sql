-- ============================================================================
-- DIAGNOSTIC SCRIPT: Check Employee Profile Issues
-- ============================================================================
-- Purpose: Verify database structure and data for Employee Profile feature
-- ============================================================================

-- Step 1: Check if Employees table has data
PRINT '=== CHECKING EMPLOYEES TABLE ==='
SELECT TOP 10 
    EmployeeID, 
    NameSurname, 
    Email, 
    Phone
FROM Employees
ORDER BY EmployeeID;

-- Step 2: Check if Users table has data
PRINT ''
PRINT '=== CHECKING USERS TABLE ==='
SELECT TOP 10 
    UserID, 
    Username, 
    Role, 
    SiteId, 
    NameSurname
FROM Users
ORDER BY UserID;

-- Step 3: Check for data type mismatches
PRINT ''
PRINT '=== CHECKING COLUMN DATA TYPES ==='
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees'
ORDER BY ORDINAL_POSITION;

-- Step 4: Check for matching records between Users and Employees
PRINT ''
PRINT '=== CHECKING USER-EMPLOYEE RELATIONSHIPS ==='
SELECT 
    u.UserID,
    u.Username,
    u.NameSurname as UserName,
    e.EmployeeID,
    e.NameSurname as EmployeeName
FROM Users u
LEFT JOIN Employees e ON u.UserID = e.EmployeeID
ORDER BY u.UserID;

-- Step 5: Check for employees without matching users
PRINT ''
PRINT '=== EMPLOYEES WITHOUT MATCHING USERS ==='
SELECT 
    e.EmployeeID,
    e.NameSurname
FROM Employees e
LEFT JOIN Users u ON e.EmployeeID = u.UserID
WHERE u.UserID IS NULL
ORDER BY e.EmployeeID;

-- Step 6: If data exists, show sample employee record
PRINT ''
PRINT '=== SAMPLE EMPLOYEE RECORD (Full Details) ==='
SELECT TOP 1 
    e.EmployeeID, 
    e.NameSurname, 
    e.Email, 
    e.Phone, 
    e.DateOfBirth, 
    e.Gender, 
    e.Address, 
    e.City, 
    e.State, 
    e.PostalCode,
    e.EmergencyContactName, 
    e.EmergencyContactPhone,
    e.DateOfJoin, 
    e.Position, 
    e.Status,
    e.DepartmentID,
    e.ManagerID,
    e.SiteID,
    e.IsActive,
    e.CreatedDate,
    e.ModifiedDate,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmployeeID IS NOT NULL
ORDER BY e.EmployeeID;

-- Step 7: Show sample data from both tables
PRINT ''
PRINT '=== SAMPLE EMPLOYEES DATA ==='
SELECT TOP 5 EmployeeID, NameSurname, SiteID 
FROM Employees 
WHERE SiteID IS NOT NULL
ORDER BY EmployeeID;

PRINT ''
PRINT '=== SAMPLE USERS DATA ==='
SELECT TOP 5 UserID, Username, SiteId 
FROM Users 
WHERE SiteId IS NOT NULL
ORDER BY UserID;

-- Step 8: Check SiteID column types
PRINT ''
PRINT '=== SITEID COLUMN DATA TYPES ==='
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;

-- Step 9: Verify Departments table exists and has data
PRINT ''
PRINT '=== CHECKING DEPARTMENTS TABLE ==='
SELECT TOP 10 
    DepartmentID, 
    DepartmentName, 
    SiteID
FROM Departments
ORDER BY DepartmentID;

-- Final Status
PRINT ''
PRINT '=== DIAGNOSTIC COMPLETE ==='
PRINT 'Review the results above to identify any data issues or missing relationships.'
PRINT 'Common issues:'
PRINT '  - No data in Employees or Users tables'
PRINT '  - SiteID type mismatch (not NVARCHAR(MAX))'
PRINT '  - Missing relationships between Users and Employees'
PRINT '  - NULL values in required fields'

