# Database Schema Fix - Missing Columns Guide

## ?? Issue Identified

The application is trying to access columns in the **Employees** table that don't exist in your database schema.

### Missing Columns Error
```
Invalid column name 'ManagerID'
Invalid column name 'Phone'
Invalid column name 'DateOfBirth'
Invalid column name 'Gender'
Invalid column name 'Address'
Invalid column name 'City'
Invalid column name 'State'
Invalid column name 'PostalCode'
Invalid column name 'EmergencyContactName'
Invalid column name 'EmergencyContactPhone'
Invalid column name 'DateOfJoin'
Invalid column name 'Position'
Invalid column name 'Status'
```

---

## ?? Solution: Add Missing Columns

### Step 1: Run the SQL Script
A script has been provided: **FIX_EMPLOYEES_TABLE_SCHEMA.sql**

**How to run it:**
1. Open SQL Server Management Studio (SSMS)
2. Connect to your database (SQL5088)
3. Open the script file: `FIX_EMPLOYEES_TABLE_SCHEMA.sql`
4. Click **Execute** (or press F5)
5. Review the output messages

### Step 2: What the Script Does
The script will:
- ? Check current table structure
- ? Add all missing columns to Employees table
- ? Use appropriate data types
- ? Set columns as nullable (optional data)
- ? Display final structure for verification

### Step 3: Verify Changes
After running the script, verify columns were added:
```sql
-- Run this to check Employees table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees'
ORDER BY ORDINAL_POSITION;
```

---

## ?? Complete Employees Table Schema

After running the script, your Employees table should have these columns:

| Column | Data Type | Nullable | Purpose |
|--------|-----------|----------|---------|
| EmployeeID | VARCHAR(50) | NO | Primary key - employee identifier |
| NameSurname | VARCHAR(200) | NO | Employee full name |
| Email | VARCHAR(255) | YES | Email address |
| Phone | VARCHAR(20) | YES | Phone number |
| DateOfBirth | DATETIME | YES | Date of birth |
| Gender | VARCHAR(1) | YES | M/F/O |
| Address | VARCHAR(255) | YES | Street address |
| City | VARCHAR(50) | YES | City name |
| State | VARCHAR(50) | YES | State/province |
| PostalCode | VARCHAR(20) | YES | Postal/ZIP code |
| EmergencyContactName | VARCHAR(200) | YES | Emergency contact name |
| EmergencyContactPhone | VARCHAR(20) | YES | Emergency contact phone |
| DateOfJoin | DATETIME | YES | Employment start date |
| Position | VARCHAR(100) | YES | Job position/title |
| Status | VARCHAR(50) | YES | Active/Inactive |
| ManagerID | VARCHAR(50) | YES | Manager's employee ID |
| DepartmentID | INT | YES | Department reference |
| SiteID | VARCHAR(50) | YES | Site identifier |
| IsActive | INT | YES | 1=Active, 0=Inactive |
| CreatedDate | DATETIME | YES | Record creation date |
| ModifiedDate | DATETIME | YES | Last modification date |

---

## ?? Affected Pages

These pages will start working after the schema is fixed:

### ? Will Be Fixed
1. **EmployeeProfile.aspx**
   - Load employee data with all fields
   - Edit personal information
   - Edit contact information
   - View employment information

2. **LeaveRequest.aspx**
   - Load employee profile data
   - Display contact information

3. **LeaveBalance.aspx**
   - Load employee information
   - Display leave balances with proper filtering

4. **AttendanceTracking.aspx**
   - Load employee data with departments
   - Display employee information in grids

5. **Other Employee-Related Pages**
   - MyClockEvents.aspx
   - EmployeePayslips.aspx
   - TimesheetEntry.aspx
   - EmployeeSettings.aspx
   - NotificationSettings.aspx

---

## ?? Step-by-Step Instructions

### For SQL Server Management Studio:

**Step 1: Connect to Database**
```
1. Open SSMS
2. Server: your-server-name
3. Database: SQL5088 (or your database name)
4. Click Connect
```

**Step 2: Open Script**
```
1. File ? Open ? File...
2. Navigate to: FIX_EMPLOYEES_TABLE_SCHEMA.sql
3. Select and Open
```

**Step 3: Execute Script**
```
1. Click Execute (or press F5)
2. Wait for completion
3. Review Messages tab for status
```

**Step 4: Verify**
```
1. Open new Query window
2. Run verification SQL (see above)
3. Confirm all columns exist
```

### Alternative: Copy-Paste Method

If you prefer, you can:
1. Open the SQL script file in Notepad
2. Copy all the content
3. Open SSMS and create new query
4. Paste the content
5. Execute

---

## ? Quick Fix (If Script Fails)

If the script has issues, you can add columns individually:

```sql
-- Run each ALTER TABLE statement separately
ALTER TABLE Employees ADD Phone VARCHAR(20) NULL;
ALTER TABLE Employees ADD Email VARCHAR(255) NULL;
ALTER TABLE Employees ADD DateOfBirth DATETIME NULL;
ALTER TABLE Employees ADD Gender VARCHAR(1) NULL;
ALTER TABLE Employees ADD Address VARCHAR(255) NULL;
ALTER TABLE Employees ADD City VARCHAR(50) NULL;
ALTER TABLE Employees ADD State VARCHAR(50) NULL;
ALTER TABLE Employees ADD PostalCode VARCHAR(20) NULL;
ALTER TABLE Employees ADD EmergencyContactName VARCHAR(200) NULL;
ALTER TABLE Employees ADD EmergencyContactPhone VARCHAR(20) NULL;
ALTER TABLE Employees ADD DateOfJoin DATETIME NULL;
ALTER TABLE Employees ADD Position VARCHAR(100) NULL;
ALTER TABLE Employees ADD Status VARCHAR(50) NULL;
ALTER TABLE Employees ADD ManagerID VARCHAR(50) NULL;
ALTER TABLE Employees ADD ModifiedDate DATETIME NULL DEFAULT GETDATE();
```

---

## ? Verification Checklist

After running the script:

- [ ] Script executed without errors
- [ ] Messages show all columns added (or already exist)
- [ ] Verification query shows 20+ columns
- [ ] No "Invalid column name" errors

---

## ?? Next Steps

### Step 1: Run the Schema Fix Script
```
Execute: FIX_EMPLOYEES_TABLE_SCHEMA.sql
```

### Step 2: Rebuild Solution
```
In Visual Studio:
Build ? Rebuild Solution
```

### Step 3: Test Pages
```
1. Login to application
2. Navigate to Employee Profile
3. Verify all data loads
4. Try editing information
5. Verify changes save
```

### Step 4: Verify Other Pages
```
1. Test LeaveRequest
2. Test AttendanceTracking
3. Test EmployeePayslips
4. Test other user pages
```

---

## ?? Data Migration (If Needed)

If you have existing employee data in other tables, you can migrate it:

```sql
-- Example: Migrate phone numbers from another table
UPDATE e
SET e.Phone = s.PhoneNumber
FROM Employees e
INNER JOIN SourceTable s ON e.EmployeeID = s.EmployeeID
WHERE e.Phone IS NULL;
```

---

## ?? Backup Reminder

**IMPORTANT**: Always backup your database before running schema changes:

```sql
-- Backup command
BACKUP DATABASE [SQL5088]
TO DISK = 'C:\Backups\SQL5088_Backup.bak'
WITH INIT, NAME = 'Pre-Schema-Fix Backup';
```

---

## ? Troubleshooting

### Issue: Script says "Column already exists"
**Solution**: This is normal if you've already added some columns. The script checks before adding.

### Issue: Permission denied error
**Solution**: You need db_owner or ddl_admin role. Contact your DBA.

### Issue: Script times out
**Solution**: The Employees table might be very large. Run commands one at a time.

### Issue: Still getting "Invalid column" error after running script
**Solution**: 
1. Verify script ran successfully
2. Clear application cache (Ctrl+Shift+Delete)
3. Restart IIS if hosted on server
4. Rebuild and redeploy application

---

## ?? Support

If you encounter issues:

1. **Check the Messages tab** in SSMS for error details
2. **Verify database connection** before running script
3. **Review error logs** in Event Viewer
4. **Check user permissions** for database modifications

---

## ?? Related Files

- **FIX_EMPLOYEES_TABLE_SCHEMA.sql** - The schema fix script
- **EmployeeProfile.aspx.cs** - Uses these columns
- All user-facing pages that reference employee data

---

**Status**: Ready to Execute
**Priority**: HIGH (blocks multiple features)
**Estimated Time**: 2-5 minutes

Once the schema is fixed, all employee-related pages will work correctly!

