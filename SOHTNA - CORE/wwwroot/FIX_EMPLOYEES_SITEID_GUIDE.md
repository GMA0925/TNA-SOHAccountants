# ? FIX EMPLOYEES SITEID VALUES - Complete Guide

## Problem Identified

### Current Issue
**Employees table has incorrect SiteID values:**
```
EmployeeID  NameSurname       SiteID
16          Andrew            849484407    ? (should be BH001)
17          Ayanda Cibne      849484407    ? (should be BH001)
18          Brenden Na...     849484407    ? (should be BH001)
19          Deleni Sithole    849484407    ? (should be BH001)
20          Elphas Zakwe      849484407    ? (should be BH001)
```

**Users table has correct SiteID values:**
```
UserID  Username    SiteId
1       greg        BH001   ?
2       tech_user   CT001   ?
3       admin       BH001   ?
4       admin01     CT001   ?
5       jane_dla... DBN...  ?
```

### Root Cause
- Employees.SiteID was populated with a hash code instead of actual site identifiers
- Users.SiteId has the correct alphanumeric site codes
- Need to sync them together

---

## Solution Overview

### What Will Happen
```
BEFORE:
Employees.SiteID = 849484407
Users.SiteId = BH001

AFTER:
Employees.SiteID = BH001  ?
Users.SiteId = BH001      ?
(Values match!)
```

### Update Logic
```sql
UPDATE Employees
SET SiteID = Users.SiteId
WHERE EmployeeID = Users.UserID
```

---

## Step-by-Step Instructions

### Step 1: Open SQL Server Management Studio

1. Launch **SQL Server Management Studio (SSMS)**
2. Connect to your database server
3. Click **Connect**

---

### Step 2: Open the Fix Script

1. File ? Open ? File...
2. Select: **FIX_EMPLOYEES_SITEID_VALUES.sql**
3. Click **Open**

---

### Step 3: Review the Script

The script does 4 things:
```
1. BACKUP - Shows current data before changes
2. UPDATE - Synchronizes Employees.SiteID with Users.SiteId
3. VERIFY - Shows updated data
4. CHECK - Displays any remaining mismatches
```

---

### Step 4: Execute the Script

1. Click **Execute** (or press F5)
2. Watch the **Messages** tab
3. Review the output

---

### Step 5: Verify Results

After execution, you should see:

**Before Changes:**
```
EmployeeID  NameSurname    SiteID
16          Andrew         849484407
17          Ayanda Cibne   849484407
```

**After Changes:**
```
EmployeeID  NameSurname    SiteID
16          Andrew         BH001
17          Ayanda Cibne   BH001
```

**Mismatch Check:**
```
EmployeeID  NameSurname  EmployeeSiteID  Username   UserSiteID  Status
16          Andrew       BH001           greg       BH001       MATCH ?
17          Ayanda       BH001           tech_user  CT001       MISMATCH ??
```

---

## Understanding the Data Mapping

### How Employees and Users Relate
```
Users Table:
UserID = 1, Username = greg, SiteId = BH001

? (matches via EmployeeID = UserID)

Employees Table:
EmployeeID = 1, NameSurname = ???, SiteID should be = BH001
```

### Expected Relationships
```
UserID 1 (greg, BH001)
   ?
EmployeeID 1 (SiteID = BH001) ?

UserID 2 (tech_user, CT001)
   ?
EmployeeID 2 (SiteID = CT001) ?

UserID 3 (admin, BH001)
   ?
EmployeeID 3 (SiteID = BH001) ?
```

---

## Safety Features

### Transaction Wrapping
```sql
BEGIN TRANSACTION
-- All updates happen here
COMMIT TRANSACTION
```
**Benefit:** If something goes wrong, you can rollback

### Before/After Verification
```sql
-- Shows data before
SELECT ... FROM Employees

-- Makes changes
UPDATE Employees ...

-- Shows data after
SELECT ... FROM Employees
```
**Benefit:** You can see exactly what changed

### Mismatch Detection
```sql
SELECT ... CASE WHEN e.SiteID = u.SiteId THEN 'MATCH' ELSE 'MISMATCH'
```
**Benefit:** Identifies any remaining issues

---

## What Gets Updated

### Affected Rows
All Employees with invalid SiteID values will be updated:
```
WHERE e.SiteID IS NULL 
   OR e.SiteID NOT IN ('BH001', 'CT001', 'DBN')
   OR e.SiteID LIKE '%[0-9]%' AND LEN(e.SiteID) > 10
```

### Examples of What Gets Updated
| EmployeeID | Old SiteID | New SiteID | Source |
|------------|-----------|-----------|--------|
| 16 | 849484407 | BH001 | Users.SiteId |
| 17 | 849484407 | BH001 | Users.SiteId |
| 18 | 849484407 | CT001 | Users.SiteId |
| 19 | 849484407 | BH001 | Users.SiteId |
| 20 | 849484407 | DBN | Users.SiteId |

---

## Expected Results

### Step 1 Output (Backup/Current)
```
=== STEP 1: BACKUP - Display current data ===
EmployeeID  NameSurname        SiteID
16          Andrew             849484407
17          Ayanda Cibne       849484407
...

UserID  Username      SiteId
1       greg          BH001
2       tech_user     CT001
3       admin         BH001
4       admin01       CT001
5       jane_dla...   DBN...
```

### Step 2 Output (Update)
```
=== STEP 2: UPDATE EMPLOYEES SITEID FROM USERS TABLE ===
Updated: Employees SiteID values
```

### Step 3 Output (Verify)
```
=== STEP 3: VERIFY CHANGES ===
EmployeeID  NameSurname        SiteID
16          Andrew             BH001
17          Ayanda Cibne       BH001
18          Brenden Na...      BH001
19          Deleni Sithole     CT001
20          Elphas Zakwe       DBN
```

### Step 4 Output (Mismatch Check)
```
=== STEP 4: CHECK FOR MISMATCHES ===
EmployeeID  NameSurname   EmployeeSiteID  Username      UserSiteID  Status
16          Andrew        BH001           greg          BH001       MATCH
17          Ayanda        BH001           tech_user     CT001       MISMATCH ??
18          Brenden       BH001           admin         BH001       MATCH
19          Deleni        CT001           admin01       CT001       MATCH
20          Elphas        DBN             jane_dla...   DBN         MATCH
```

---

## If There Are Mismatches

### Mismatch Example
```
EmployeeID 17: Employees.SiteID = BH001 but Users.SiteId = CT001
```

### Explanation
- Employee 17 might have been moved to a different site
- Or user record has the wrong SiteId
- Need manual review

### How to Fix
```sql
-- Option 1: Update the user's SiteId
UPDATE Users SET SiteId = 'BH001' WHERE UserID = 17;

-- Option 2: Update the employee's SiteId
UPDATE Employees SET SiteID = 'CT001' WHERE EmployeeID = 17;

-- Choose the correct one based on where the person actually works
```

---

## Impact on Application

### Login Flow
```csharp
// User logs in
Session["SiteId"] = "BH001"  // ? Now matches Employees.SiteID
```

### Profile Page
```csharp
// When loading employee data
WHERE e.SiteID = @SiteID  // ? Now finds the correct record
```

### Filtering
```csharp
// Site-based filtering now works
WHERE e.SiteID = Session["SiteId"]  // ? Matches correctly
```

---

## Troubleshooting

### Issue: Script Shows "0 rows affected"
**Meaning:** All SiteIDs are already correct
**Action:** No problem! Data is already good

### Issue: Script Shows Mismatches
**Meaning:** Some employees don't match their users
**Action:** Review the mismatch output and fix manually if needed

### Issue: Error During Execution
**Meaning:** Check the error message in SSMS
**Action:** Common causes:
- Permissions issue ? Run as admin
- SiteID column doesn't exist ? Run schema fix script first
- Data type mismatch ? Ensure both columns are NVARCHAR(MAX)

### Issue: Changes Didn't Apply
**Meaning:** Check if transaction was committed
**Action:** Verify in Messages tab that "UPDATE COMPLETE" message appears

---

## Rollback (If Needed)

If you need to undo changes:

```sql
-- Rollback (only works if transaction not committed)
ROLLBACK TRANSACTION;

-- Or restore from backup
RESTORE DATABASE [SQL5088] FROM DISK = 'backup_file.bak';
```

---

## After Running This Script

### Step 1: Test Application
```
1. Login with user account
2. Check Session["SiteId"]
3. Verify it matches Employees.SiteID
```

### Step 2: Test Profile Page
```
1. Click [?? Profile]
2. Verify employee data loads
3. Verify SiteID displays correctly
```

### Step 3: Test Filtering
```
1. Test employee lookup by site
2. Verify site-based filtering works
3. Check department/site relationships
```

---

## Summary

| Aspect | Before | After |
|--------|--------|-------|
| Employees.SiteID | 849484407 | BH001 |
| Matches Users.SiteId | ? No | ? Yes |
| Application works | ? No | ? Yes |
| Errors | ? Yes | ? None |

---

## Timeline

| Step | Time |
|------|------|
| Open SSMS | 1 min |
| Open script | 1 min |
| Review script | 2 min |
| Execute script | <1 min |
| Review results | 2 min |
| Test application | 3 min |
| **TOTAL** | **~10 minutes** |

---

## Build & Deploy

### After Running Script

1. ? No application code changes needed
2. ? Rebuild solution (just to be safe)
3. ? Test with real user login
4. ? Deploy when ready

---

**Status:** Ready to Execute

**Next Action:** Run FIX_EMPLOYEES_SITEID_VALUES.sql

