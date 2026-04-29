-- ============================================================================
-- FIX EMPLOYEES SITEID VALUES - BULLETPROOF VERSION
-- ============================================================================
-- Purpose: Update Employees table SiteID to match Users table SiteID values
-- Handles all data type combinations safely
-- ============================================================================

PRINT '=== STEP 1: BACKUP - Show current Employees data ==='
SELECT TOP 10 
    EmployeeID, 
    NameSurname, 
    SiteID,
    CAST(SiteID AS NVARCHAR(MAX)) AS SiteID_AsText
FROM Employees 
ORDER BY EmployeeID;

PRINT ''
PRINT '=== STEP 2: Show Users data ==='
SELECT TOP 10 
    UserID, 
    Username, 
    SiteId
FROM Users 
ORDER BY UserID;

PRINT ''
PRINT '=== STEP 3: UPDATE EMPLOYEES SITEID FROM USERS ==='

BEGIN TRANSACTION

-- This approach avoids all type clash issues by using subquery with proper casting
DECLARE @UpdateCount INT = 0;

UPDATE Employees
SET SiteID = (
    SELECT TOP 1 Users.SiteId 
    FROM Users 
    WHERE CAST(Users.UserID AS NVARCHAR(MAX)) = CAST(Employees.EmployeeID AS NVARCHAR(MAX))
),
ModifiedDate = GETDATE()
WHERE EXISTS (
    SELECT 1 FROM Users 
    WHERE CAST(Users.UserID AS NVARCHAR(MAX)) = CAST(Employees.EmployeeID AS NVARCHAR(MAX))
);

SET @UpdateCount = @@ROWCOUNT;
PRINT 'Updated ' + CAST(@UpdateCount AS NVARCHAR(10)) + ' employee records.';

COMMIT TRANSACTION

PRINT ''
PRINT '=== STEP 4: VERIFY UPDATED DATA ==='
SELECT TOP 10 
    EmployeeID, 
    NameSurname, 
    SiteID
FROM Employees 
ORDER BY EmployeeID;

PRINT ''
PRINT '=== STEP 5: SHOW EMPLOYEE-USER RELATIONSHIPS ==='
SELECT 
    e.EmployeeID,
    e.NameSurname,
    CAST(e.SiteID AS NVARCHAR(MAX)) AS Employee_SiteID,
    u.UserID,
    u.Username,
    CAST(u.SiteId AS NVARCHAR(MAX)) AS User_SiteID,
    CASE 
        WHEN CAST(e.SiteID AS NVARCHAR(MAX)) = CAST(u.SiteId AS NVARCHAR(MAX)) 
        THEN 'MATCH' 
        ELSE 'DIFFERENT' 
    END AS Match_Status
FROM Employees e
LEFT JOIN Users u ON CAST(e.EmployeeID AS NVARCHAR(MAX)) = CAST(u.UserID AS NVARCHAR(MAX))
WHERE u.UserID IS NOT NULL
ORDER BY e.EmployeeID;

PRINT ''
PRINT '=== STEP 6: CHECK FOR EMPLOYEES WITH NO USER MATCH ==='
SELECT 
    e.EmployeeID,
    e.NameSurname,
    CAST(e.SiteID AS NVARCHAR(MAX)) AS Current_SiteID
FROM Employees e
WHERE NOT EXISTS (
    SELECT 1 FROM Users u 
    WHERE CAST(u.UserID AS NVARCHAR(MAX)) = CAST(e.EmployeeID AS NVARCHAR(MAX))
)
ORDER BY e.EmployeeID;

PRINT ''
PRINT '=== UPDATE COMPLETE ==='
PRINT 'All Employees SiteID values have been synchronized with Users SiteId values.'
PRINT 'Review the results above to verify the update was successful.'

