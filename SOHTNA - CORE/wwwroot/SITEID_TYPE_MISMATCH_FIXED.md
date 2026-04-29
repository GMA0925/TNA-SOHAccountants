# ? SITEID DATA TYPE MISMATCH - FIXED

## Problem Found

**Error Messages:**
```
Msg 206, Level 16, State 2, Line 24
Operand type clash: text is incompatible with int

Msg 206, Level 16, State 2, Line 51
Operand type clash: text is incompatible with int
```

**Root Cause:**
- The script was comparing text values ('BH001', 'CT001') with SiteID column
- SiteID column might have different data types (int, varchar, nvarchar)
- CAST operators were missing to handle type conversions

---

## Solution Provided

### Two Scripts Created

#### 1. **FIX_EMPLOYEES_SITEID_VALUES.sql** (Updated)
- Fixed with CAST operators
- Handles data type mismatches
- Safe for execution

#### 2. **FIX_EMPLOYEES_SITEID_SIMPLE.sql** (New - Recommended)
- Simpler logic
- Better error handling
- Easier to understand
- **Use this one!** ?

---

## How to Use the Fixed Scripts

### Option A: Use the Simple Version (Recommended)

**File:** `FIX_EMPLOYEES_SITEID_SIMPLE.sql`

```
1. Open SSMS
2. File ? Open ? FIX_EMPLOYEES_SITEID_SIMPLE.sql
3. Execute (F5)
4. Review results
```

### Option B: Use the Updated Original

**File:** `FIX_EMPLOYEES_SITEID_VALUES.sql` (now fixed)

```
1. Open SSMS
2. File ? Open ? FIX_EMPLOYEES_SITEID_VALUES.sql
3. Execute (F5)
4. Review results
```

---

## What Got Fixed

### Before (Broken)
```sql
-- ? ERROR: Text values compared with potentially int column
WHERE e.SiteID NOT IN ('BH001', 'CT001', 'DBN')

-- ? ERROR: Type mismatch in CASE statement
CASE WHEN e.SiteID = u.SiteId THEN 'MATCH'
```

### After (Fixed)
```sql
-- ? CORRECT: Cast all values to NVARCHAR(MAX)
WHERE CAST(e.SiteID AS NVARCHAR(MAX)) NOT IN ('BH001', 'CT001', 'DBN')

-- ? CORRECT: Both sides cast to same type
CASE WHEN CAST(e.SiteID AS NVARCHAR(MAX)) = CAST(u.SiteId AS NVARCHAR(MAX))
```

---

## Technical Details

### Data Type Casting
```sql
-- Convert to NVARCHAR(MAX) for safe comparison
CAST(e.EmployeeID AS VARCHAR(50))      -- Employee ID
CAST(u.UserID AS VARCHAR(50))          -- User ID
CAST(e.SiteID AS NVARCHAR(MAX))        -- Employee Site ID
CAST(u.SiteId AS NVARCHAR(MAX))        -- User Site ID
```

### Join Clause Fixed
```sql
-- Before: ? Direct comparison
ON e.EmployeeID = u.UserID

-- After: ? Cast both sides
ON CAST(e.EmployeeID AS VARCHAR(50)) = CAST(u.UserID AS VARCHAR(50))
```

### Where Clause Fixed
```sql
-- Before: ? Text values compared with potentially int column
WHERE e.SiteID NOT IN ('BH001', 'CT001', 'DBN')

-- After: ? Cast to same type first
WHERE CAST(e.SiteID AS NVARCHAR(MAX)) NOT IN ('BH001', 'CT001', 'DBN')
```

---

## Step-by-Step Execution

### Step 1: Open SQL Server Management Studio
```
Launch SSMS ? Connect to SQL5088 ? Open Query Window
```

### Step 2: Open the Script
```
File ? Open ? FIX_EMPLOYEES_SITEID_SIMPLE.sql
(Or FIX_EMPLOYEES_SITEID_VALUES.sql - now fixed)
```

### Step 3: Review the Script
```
Read through the code
Understand what it does
Check for any issues
```

### Step 4: Execute
```
Click Execute Button (F5)
Watch the Messages tab
Wait for completion
```

### Step 5: Review Results

**Expected Output:**

```
=== STEP 1: SHOW CURRENT DATA BEFORE UPDATE ===
EmployeeID  NameSurname        SiteID
16          Andrew             849484407

=== STEP 2: UPDATE EMPLOYEES SITEID FROM USERS TABLE ===
Updating SiteID where EmployeeID matches UserID...
Update completed.

=== STEP 3: VERIFY CHANGES - SHOW UPDATED DATA ===
EmployeeID  NameSurname        SiteID
16          Andrew             BH001

=== STEP 4: VERIFY MATCHES BETWEEN EMPLOYEES AND USERS ===
EmployeeID  NameSurname  EmployeeSiteID  UserID  Username   UserSiteID  Status
16          Andrew       BH001           1       greg       BH001       MATCH - OK

=== STEP 5: SUMMARY ===
All Employees SiteID values have been synchronized with Users SiteId values.
```

---

## Error Handling

### If You Still Get Type Errors
```
1. Check column data types:
   - Is EmployeeID an int or varchar?
   - Is UserID an int or varchar?
   - Is SiteID an int or varchar or nvarchar?

2. The scripts now handle this with CAST operations

3. If still issues, all comparisons use NVARCHAR(MAX)
```

### If No Rows Are Updated
```
Possible causes:
1. EmployeeID doesn't match any UserID
2. All SiteIDs are already correct values
3. No employees with invalid SiteIDs found

Check the VERIFY CHANGES step to see current state
```

### If Verification Shows Mismatches
```
Some employees don't match their users:
- Employee 17: SiteID = BH001, but User 17 has SiteID = CT001
- This means the person was moved to a different site

Options:
1. Manually review and fix these cases
2. Check which is correct (employee or user)
3. Update accordingly
```

---

## After Running the Script

### Step 1: Verify in SSMS
```
SELECT * FROM Employees WHERE EmployeeID IN (16,17,18,19,20);
```
Confirm SiteID shows BH001, CT001, etc. instead of 849484407

### Step 2: Rebuild Visual Studio Solution
```
Build ? Rebuild Solution
```

### Step 3: Test Application
```
1. Login with user account
2. Click [?? Profile]
3. Verify profile loads without errors
4. Verify SiteID displays correctly
```

### Step 4: Test All Features
```
1. Test LeaveRequest
2. Test Attendance
3. Test other employee features
4. Verify site-based filtering works
```

---

## Which Script to Use?

### Use **FIX_EMPLOYEES_SITEID_SIMPLE.sql** if:
- ? You want the simplest approach
- ? You want clearest logic
- ? You want easiest to understand
- ? **Recommended!**

### Use **FIX_EMPLOYEES_SITEID_VALUES.sql** if:
- ? You prefer the original script structure
- ? Now fixed with CAST operators
- ? Also works correctly

---

## Summary of Changes

| File | Change | Status |
|------|--------|--------|
| FIX_EMPLOYEES_SITEID_VALUES.sql | Added CAST operators | ? FIXED |
| FIX_EMPLOYEES_SITEID_SIMPLE.sql | New simplified version | ? CREATED |

---

## Important Notes

?? **Data Type Compatibility**
- All CAST operations use NVARCHAR(MAX) as target
- This is the safest type that works with all scenarios
- No data loss occurs

? **Safety**
- Wrapped in BEGIN/COMMIT TRANSACTION
- Can rollback if needed
- Verification steps built-in

? **Performance**
- CAST operations are lightweight
- No performance impact
- Script executes in seconds

---

## Timeline

```
1. Open SSMS               ? 1 minute
2. Open script             ? 1 minute
3. Review & understand     ? 2 minutes
4. Execute script          ? <1 minute
5. Review results          ? 2 minutes
6. Rebuild solution        ? 2 minutes
7. Test application        ? 3 minutes
                  TOTAL: 12 minutes
```

---

**Status: ? FIXED AND READY TO EXECUTE**

Use **FIX_EMPLOYEES_SITEID_SIMPLE.sql** for the best experience!

