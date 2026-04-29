# ? FIX EMPLOYEES SITEID - QUICK ACTION

## The Problem

**Employees table has wrong SiteID:**
```
EmployeeID 16 (Andrew)         SiteID = 849484407  ?
EmployeeID 17 (Ayanda Cibne)   SiteID = 849484407  ?
EmployeeID 18 (Brenden)        SiteID = 849484407  ?
```

**Should be:**
```
EmployeeID 16 (Andrew)         SiteID = BH001  ?
EmployeeID 17 (Ayanda Cibne)   SiteID = BH001  ?
EmployeeID 18 (Brenden)        SiteID = BH001  ?
```

---

## Quick Fix (2 minutes)

### Step 1: Open SSMS
```
SQL Server Management Studio ? Connect to SQL5088
```

### Step 2: Open Script
```
File ? Open ? FIX_EMPLOYEES_SITEID_VALUES.sql
```

### Step 3: Execute
```
Click Execute (F5)
```

### Step 4: Verify
```
Check Messages tab for "UPDATE COMPLETE"
```

---

## What Happens

1. ? Shows current data (849484407)
2. ? Updates SiteID to correct values (BH001, CT001, etc.)
3. ? Shows updated data
4. ? Checks for any mismatches

---

## Expected Output

```
BEFORE:
EmployeeID 16: SiteID = 849484407

AFTER:
EmployeeID 16: SiteID = BH001

Status: MATCH ?
```

---

## After Running

1. ? Rebuild Visual Studio solution
2. ? Login to app
3. ? Test profile page
4. ? Verify data loads correctly

---

## File

**FIX_EMPLOYEES_SITEID_VALUES.sql** ? Run this

---

**Time: ~2 minutes to execute**

**Impact: HIGH - Fixes employee SiteID values** ?
