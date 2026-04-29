# ? SITEID TO NVARCHAR(MAX) - QUICK ACTION GUIDE

## What Needs to Be Done

Change SiteID column from limited size to NVARCHAR(MAX) to support alphanumeric values like 'BH001'.

---

## Current State (from screenshot)

```
Employees.SiteID: nvarchar(MAX) ? Already done! ?
```

Great news! The Employees table already has SiteID as NVARCHAR(MAX)!

---

## What Still Needs to be Done

Check other tables:
- [ ] Users table - SiteId column
- [ ] Departments table - SiteID column (if exists)
- [ ] Any other tables with SiteID

---

## Quick Fix (2 Options)

### Option A: Use the SQL Script (Recommended)
1. Open SSMS
2. Open new query
3. Copy/paste: `UPDATE_SITEID_TO_NVARCHAR_MAX.sql`
4. Execute (F5)
5. Done! ?

### Option B: Click YES on the Dialog
You see a dialog in SSMS asking:
```
"Changing the column to the selected datatype will delete its indexes.
Do you want to change the datatype and delete the indexes?"
```

**Click: [YES]**

---

## Verify Success

Run this SQL:
```sql
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;
```

**Expected Result:**
```
All rows should show: DATA_TYPE = nvarchar
                     CHARACTER_MAXIMUM_LENGTH = -1 (MAX)
```

---

## After Completing This

1. ? Rebuild Visual Studio solution
2. ? Test profile page loads correctly
3. ? Test edits save successfully
4. ? All SiteID conversions work

---

## Time Required

**~5 minutes** to complete

---

## Files Provided

1. **UPDATE_SITEID_TO_NVARCHAR_MAX.sql** - Run this script
2. **SITEID_NVARCHAR_MAX_GUIDE.md** - Detailed instructions

---

**Next Step:** Click YES on the SSMS dialog OR run the SQL script

