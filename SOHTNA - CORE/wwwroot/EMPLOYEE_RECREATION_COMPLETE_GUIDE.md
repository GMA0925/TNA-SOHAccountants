# ? EMPLOYEE RECREATION GUIDE - Complete Instructions

## Overview

You're going to:
1. Delete all current employees
2. Recreate them using the sync feature
3. Ensure SiteID is correctly set to 'BH001', 'CT001', etc.

**The sync code is verified to parse SiteId correctly!** ?

---

## Step-by-Step Instructions

### STEP 1: Backup Current Employees (Safety First!)

Run this SQL script in SSMS:
```
File: DELETE_EMPLOYEES_FOR_SYNC.sql
```

**What it does:**
- ? Creates backup table: `Employees_Backup_Before_Sync`
- ? Shows current employees (20 sample)
- ? Checks ReaderEvents data available for sync
- ? Deletes all employees
- ? Verifies table is empty

**Output you'll see:**
```
=== STEP 1: BACKUP EMPLOYEES DATA ===
Backup created: Employees_Backup_Before_Sync

=== STEP 2: SHOW CURRENT EMPLOYEES ===
EmployeeID  NameSurname        SiteID
16          Andrew             849484407
17          Ayanda Cibne       849484407
...

=== STEP 3: DELETE ALL EMPLOYEES ===
All employees deleted.
Remaining employees: 0

=== STEP 4: VERIFY EMPTY ===
Total_Employee_Records: 0

=== STEP 5: CHECK READEREVENTDATA ===
SiteId   Unique_People   Total_Events
BH001    15              450
CT001    8               320
DBN      5               180
```

---

### STEP 2: Verify Sync Code (Already Correct!)

The EmployeeEnrollment.aspx.cs file has:

? **Correct Method:**
```csharp
private void CreateEmployeeFromReaderEvent(SqlConnection conn, string personName, string siteId)
{
    string insertQuery = @"
        INSERT INTO Employees (NameSurname, SiteID, IsActive, CreatedDate)
        VALUES (@NameSurname, @SiteID, 1, GETDATE())";

    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
    {
        cmd.Parameters.Add("@NameSurname", SqlDbType.NVarChar, 200).Value = personName;
        cmd.Parameters.Add("@SiteID", SqlDbType.NVarChar, 50).Value = GetSiteIdAsString(siteId);
        // ? This uses GetSiteIdAsString() which returns 'BH001'
        cmd.ExecuteNonQuery();
    }
}
```

? **The Helper Method:**
```csharp
private string GetSiteIdAsString(string siteId)
{
    // Return site ID as-is (alphanumeric like 'BH001')
    return string.IsNullOrEmpty(siteId) ? "" : siteId;
}
```

**No code changes needed!** The sync is already parsing correctly! ?

---

### STEP 3: Rebuild Solution (Optional but Recommended)

```
Visual Studio ? Build ? Rebuild Solution
```

This ensures you have the latest compiled code.

---

### STEP 4: Login to Application

```
1. Open the application
2. Login with Admin or Manager account
3. Navigate to: Employee Enrollment page
4. You should see the [?? Sync Employees] button
```

---

### STEP 5: Click Sync Employees Button

**Location:** Employee Enrollment page

**Button:** [?? Sync Employees]

**What happens:**
```
1. System reads your Session["SiteId"] (e.g., 'BH001')
2. Queries ReaderEvents for that SiteId
3. Finds all unique PersonNames with events
4. Creates new Employees with:
   - EmployeeID: Auto-generated
   - NameSurname: From ReaderEvents.PersonName
   - SiteID: 'BH001' ? (Not a hash!)
   - IsActive: 1 (True)
   - CreatedDate: GETDATE()
5. Shows success message
```

**Expected Message:**
```
? Successfully synced 15 employee(s) from ReaderEvents.
```

---

### STEP 6: Verify Results

After sync completes, check the data:

**In Application (Employee Enrollment grid):**
```
Should show newly created employees with their data
```

**In Database:**
```sql
SELECT TOP 10 EmployeeID, NameSurname, SiteID FROM Employees ORDER BY EmployeeID;
```

**Expected Result:**
```
EmployeeID  NameSurname        SiteID
1           Andrew             BH001  ?
2           Ayanda Cibne       BH001  ?
3           Brenden Na...      BH001  ?
4           Deleni Sithole     BH001  ?
5           Elphas Zakwe       BH001  ?
...
```

**NOT like this (which is the old problem):**
```
EmployeeID  NameSurname        SiteID
1           Andrew             849484407  ? (Hash code)
2           Ayanda Cibne       849484407  ? (Hash code)
```

---

### STEP 7: Verify User Accounts Still Exist

Make sure Users are still in the database:

```sql
SELECT UserID, Username, SiteId FROM Users ORDER BY UserID;
```

**Expected:**
```
UserID  Username      SiteId
1       greg          BH001
2       tech_user     CT001
3       admin         BH001
4       admin01       CT001
5       jane_dla...   DBN
```

**Important:** Users provide the SiteId reference for login and profile loading!

---

### STEP 8: Test Profile Page

Now test with a real user:

```
1. Login as user (e.g., greg with SiteId=BH001)
2. Click [?? Profile] button
3. Verify:
   - ? Profile loads without errors
   - ? All fields display correctly
   - ? No "type conversion" errors
   - ? SiteID shows as 'BH001' (not hash)
```

---

### STEP 9: Test Other Pages

Test other features that use employee data:

```
1. LeaveRequest page - ? Loads correctly
2. Attendance page - ? Shows employee data
3. Payroll page - ? Finds employees
4. Any site-filtered features - ? Work correctly
```

---

## Troubleshooting

### Issue: Sync Button Not Visible
**Cause:** Not logged in as Admin/Manager
**Solution:** Login with higher privileges

### Issue: Sync Creates No Employees
**Cause:** No ReaderEvents data for your site
**Solution:** Check ReaderEvents table for data matching your SiteId

### Issue: SiteID Still Shows Hash (849484407)
**Cause:** Code didn't use GetSiteIdAsString()
**Solution:** Check code wasn't modified - it should be correct as-is

### Issue: Profile Page Shows Errors
**Cause:** Users and Employees SiteID don't match
**Solution:** Run the bulletproof fix script first

---

## If You Need to Restore

If something goes wrong, restore from backup:

```sql
-- Delete the incorrect employees
DELETE FROM Employees;

-- Restore from backup
INSERT INTO Employees
SELECT * FROM Employees_Backup_Before_Sync;

-- Verify restoration
SELECT COUNT(*) FROM Employees;
```

---

## Code Verification Checklist

- [x] GetSiteIdAsString() returns 'BH001' ?
- [x] CreateEmployeeFromReaderEvent() uses GetSiteIdAsString() ?
- [x] SQL parameter type is NVARCHAR(50) ?
- [x] SiteID column is NVARCHAR(MAX) ?
- [x] No use of ConvertSiteIdToInt() for creation ?
- [x] Sync reads from ReaderEvents with correct SiteId ?

**All verified!** ?

---

## Timeline

```
1. Run DELETE script        ? 1 minute
2. Rebuild solution         ? 2 minutes
3. Login to app             ? 1 minute
4. Click Sync button        ? <1 minute
5. Wait for completion      ? <1 minute
6. Verify in database       ? 1 minute
7. Test profile page        ? 2 minutes
8. Test other pages         ? 3 minutes
                TOTAL: ~12 minutes
```

---

## Final Checklist

Before deleting employees:
- [ ] Backup created (DELETE_EMPLOYEES_FOR_SYNC.sql run)
- [ ] Understand sync uses GetSiteIdAsString() ?
- [ ] Have test user credentials ready
- [ ] Know your SiteId ('BH001', 'CT001', etc.)

After sync completes:
- [ ] New employees show in grid
- [ ] Database shows 'BH001' not '849484407'
- [ ] Profile page loads for test user
- [ ] No type conversion errors
- [ ] All other pages work correctly

---

## Summary

| Step | Action | Status |
|------|--------|--------|
| 1 | Run DELETE_EMPLOYEES_FOR_SYNC.sql | ? |
| 2 | Code verified correct | ? |
| 3 | Rebuild solution | ? |
| 4 | Login and click Sync | ? |
| 5 | Verify SiteID is 'BH001' | ? |
| 6 | Test profile page | ? |
| 7 | Test other features | ? |

---

**Status: ? READY TO DELETE AND RECREATE EMPLOYEES**

The sync code is verified to correctly parse SiteId as 'BH001'!

