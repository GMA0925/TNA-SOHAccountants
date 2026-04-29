# ? SQL DIAGNOSTIC SCRIPT - FIXED

## Problem Found

**Error Message:**
```
Msg 156, Level 15, State 1, Line 132
Incorrect syntax near the keyword 'PRINT'.
```

**Root Cause:**
The original script had a syntax error:
```sql
SELECT ... FROM Employees WHERE ...
UNION ALL
PRINT 'Users with SiteId:'     ? ? INVALID - Can't PRINT in UNION
SELECT ...
```

---

## Solution Applied

Created a corrected diagnostic script: **DIAGNOSE_EMPLOYEE_PROFILE_FIX.sql**

**Key Fixes:**
- ? Removed invalid UNION ALL with PRINT statements
- ? Separated each SELECT into independent statements
- ? Added proper PRINT statements between queries
- ? All syntax is now valid SQL

---

## How to Use the Fixed Script

### Step 1: Open SQL Server Management Studio
```
Launch SSMS
Connect to SQL5088 database
```

### Step 2: Open the Fixed Script
```
File ? Open ? File...
Select: DIAGNOSE_EMPLOYEE_PROFILE_FIX.sql
```

### Step 3: Execute
```
Click Execute (or press F5)
```

### Step 4: Review Results
```
Messages tab ? Shows diagnostic information
Results tab ? Shows data from each query
```

---

## What This Script Does

| Step | Purpose | Shows |
|------|---------|-------|
| 1 | Check Employees table | Sample employee records |
| 2 | Check Users table | Sample user records |
| 3 | Column types | Data types for all columns |
| 4 | User-Employee relationship | How Users map to Employees |
| 5 | Missing relationships | Employees without Users |
| 6 | Sample record details | Complete employee profile |
| 7 | Sample data | Both tables sample data |
| 8 | SiteID types | All SiteID column types |
| 9 | Departments data | Department records |

---

## Expected Output

When you run the script, you should see:

```
=== CHECKING EMPLOYEES TABLE ===
EmployeeID  NameSurname        Email              Phone
16          John Doe           john@company.com   +1234567890

=== CHECKING USERS TABLE ===
UserID  Username   Role   SiteId   NameSurname
16      testuser   User   BH001    John Doe

=== CHECKING COLUMN DATA TYPES ===
COLUMN_NAME    DATA_TYPE      IS_NULLABLE
EmployeeID     int            0
NameSurname    nvarchar(150)  0
Email          nvarchar(100)  1
...

=== CHECKING USER-EMPLOYEE RELATIONSHIPS ===
UserID  Username   UserName   EmployeeID  EmployeeName
16      testuser   John Doe   16          John Doe

=== SITEID COLUMN DATA TYPES ===
TABLE_NAME  COLUMN_NAME  DATA_TYPE       CHARACTER_MAXIMUM_LENGTH
Employees   SiteID       nvarchar        -1 (MAX)
Users       SiteId       nvarchar        -1 (MAX)
```

---

## What to Look For

### ? Good Signs
- Employees and Users have matching records
- SiteID is nvarchar(MAX)
- No NULL values in critical fields
- All column types are appropriate
- Relationships show proper joins

### ?? Potential Issues
- No data in Employees table
- SiteID not NVARCHAR(MAX)
- Users don't match Employees
- Missing profile columns
- NULL SiteID values

---

## Next Steps

### If Everything Looks Good
1. ? Run UPDATE_SITEID_TO_NVARCHAR_MAX.sql (if not done)
2. ? Rebuild Visual Studio solution
3. ? Test Employee Profile page
4. ? Verify data loads correctly

### If Issues Found
1. ?? Review the diagnostic output
2. ?? Run FIX_EMPLOYEES_TABLE_SCHEMA.sql if columns missing
3. ?? Add sample data if tables are empty
4. ?? Verify user-employee relationships

---

## File Details

**File Name:** `DIAGNOSE_EMPLOYEE_PROFILE_FIX.sql`

**Changes Made:**
- ? Removed invalid UNION ALL syntax
- ? Separated all queries with proper PRINT statements
- ? All 9 diagnostic checks included
- ? Comprehensive output formatting

**Status:** Ready to use

---

## Commands to Run (In Order)

```sql
-- 1. Check structure (this script)
DIAGNOSE_EMPLOYEE_PROFILE_FIX.sql

-- 2. Fix schema if needed
FIX_EMPLOYEES_TABLE_SCHEMA.sql

-- 3. Update SiteID type if needed
UPDATE_SITEID_TO_NVARCHAR_MAX.sql

-- 4. Rebuild solution
-- 5. Test application
```

---

**Status:** ? FIXED AND READY TO USE

Run the corrected diagnostic script to verify your database setup!

