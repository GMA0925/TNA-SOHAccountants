# Fix "You do not have a site assigned" Error

## Root Cause
The error occurs when the `Users` table has **NULL or missing `SiteId` values** for your login user account.

---

## Quick Fix Steps

### Step 1: Verify Users Table
Open SQL Server Management Studio and run:

```sql
-- Check your user account
SELECT Username, NameSurname, Role, SiteId, IsActive 
FROM Users 
WHERE Username = 'your_username';  -- Replace with your login username
```

### Step 2: If SiteId is NULL
Update the user record with a valid SiteId:

```sql
-- Assign your user to SiteId = 1
UPDATE Users 
SET SiteId = 1 
WHERE Username = 'your_username' AND SiteId IS NULL;

-- Verify the fix
SELECT Username, NameSurname, Role, SiteId 
FROM Users 
WHERE Username = 'your_username';
```

### Step 3: Clear Browser Cache & Session
1. **Close the browser completely**
2. **Clear cache/cookies** for localhost:44385
3. **Restart IIS** (if needed):
   - Open IIS Manager
   - Right-click Application Pool ? "Restart"
4. **Re-login** to the application

---

## Verify All Users Have SiteId

```sql
-- Show all users and their SiteId status
SELECT Username, NameSurname, Role, SiteId, IsActive
FROM Users
ORDER BY SiteId, Username;

-- Show how many users are missing SiteId
SELECT 
    'Total Users' AS [Status],
    COUNT(*) AS [Count]
FROM Users
UNION ALL
SELECT 'Users with SiteId', COUNT(*) FROM Users WHERE SiteId IS NOT NULL
UNION ALL
SELECT 'Users with NULL SiteId', COUNT(*) FROM Users WHERE SiteId IS NULL;

-- Fix: Assign all NULL SiteIds to Site 1 (or appropriate SiteId)
UPDATE Users 
SET SiteId = 1 
WHERE SiteId IS NULL;
```

---

## Verify Database Schema

```sql
-- Verify SiteId column exists in Users table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Users' 
  AND COLUMN_NAME = 'SiteId';

-- Expected output:
-- SiteId, int, NO (not nullable - preferred)
-- SiteId, int, YES (nullable - needs fixing)
```

---

## Verify Data Tables Have SiteID

```sql
-- Check if other tables have SiteID populated
SELECT 'Employees' AS [Table], 
       COUNT(*) AS Total,
       SUM(CASE WHEN SiteID IS NOT NULL THEN 1 ELSE 0 END) AS WithSiteID,
       SUM(CASE WHEN SiteID IS NULL THEN 1 ELSE 0 END) AS NullCount
FROM Employees
UNION ALL
SELECT 'Departments', COUNT(*), 
       SUM(CASE WHEN SiteID IS NOT NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN SiteID IS NULL THEN 1 ELSE 0 END)
FROM Departments
UNION ALL
SELECT 'Shifts', COUNT(*),
       SUM(CASE WHEN SiteID IS NOT NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN SiteID IS NULL THEN 1 ELSE 0 END)
FROM Shifts;

-- Fix: Populate missing SiteIDs (adjust value as needed)
UPDATE Employees SET SiteID = 1 WHERE SiteID IS NULL;
UPDATE Departments SET SiteID = 1 WHERE SiteID IS NULL;
UPDATE Shifts SET SiteID = 1 WHERE SiteID IS NULL;
```

---

## Create Sample Data (if needed)

If you don't have test users, create them:

```sql
-- Create test users with SiteId
INSERT INTO Users (Username, PasswordHash, NameSurname, Role, SiteId, IsActive, CreatedDate)
VALUES 
    ('admin1', 'admin123', 'Admin User', 'Admin', 1, 1, GETDATE()),
    ('manager1', 'manager123', 'Manager User', 'Manager', 1, 1, GETDATE()),
    ('employee1', 'emp123', 'Employee User', 'Employee', 1, 1, GETDATE());

-- For Site 2 (if you have multiple sites)
INSERT INTO Users (Username, PasswordHash, NameSurname, Role, SiteId, IsActive, CreatedDate)
VALUES 
    ('admin2', 'admin123', 'Admin User 2', 'Admin', 2, 1, GETDATE());
```

---

## Test the Fix

1. **Run the SQL fix commands above**
2. **Clear browser cache/restart IIS**
3. **Login again** with your username
4. **You should now see:**
   - ? Employee Enrollment page loads
   - ? Departments dropdown populated
   - ? Shifts dropdown populated
   - ? Employees grid shows data

---

## If Still Getting Error

### Check the Debug Output
1. Open Visual Studio
2. Open "Debug Output" window (Debug ? Windows ? Output)
3. Run your app and attempt login
4. Look for messages like:
   - ? `Login successful: username, SiteId: 1`
   - ? `Login failed for username: SiteId is NULL in database`

### Verify Session
Add this temporary code to EmployeeEnrollment.aspx.cs to debug:

```csharp
protected void Page_Load(object sender, EventArgs e)
{
    // DEBUG: Check session value
    string siteId = Session["SiteId"]?.ToString();
    System.Diagnostics.Debug.WriteLine($"DEBUG: Session[\"SiteId\"] = {siteId ?? "NULL"}");
    System.Diagnostics.Debug.WriteLine($"DEBUG: Session[\"Username\"] = {Session["Username"] ?? "NULL"}");
    
    // ... rest of code ...
}
```

Then check the Debug Output window for the values.

---

## Code Changes Made

### Login.aspx.cs
? **Improved:** Now checks for NULL SiteId before setting session
- Validates `SiteId` is not NULL
- Shows error message if NULL
- Logs to debug output for troubleshooting

### EmployeeEnrollment.aspx.cs
? **Already Fixed:** 
- Silently handles missing SiteId during sync
- Properly validates SiteId before queries
- Shows error on page if user has no SiteId

---

## Summary

| Issue | Solution | Status |
|-------|----------|--------|
| NULL SiteId in Users table | Run UPDATE statement in SQL | ? Self-service fix |
| Session not set in Login | Improved Login.aspx.cs validation | ? Code improved |
| Page shows error on load | Removed popups from page initialization | ? Fixed |
| Empty dropdowns | SiteId filtering working correctly | ? Code correct |

---

## Next Steps

After fixing, you should:
1. ? Login successfully
2. ? See your site's departments/employees/shifts
3. ? Be able to create new employees
4. ? See proper error messages only on action failures, not page load

**All fixes are in place - just need to ensure your Users table has SiteId values assigned!**
