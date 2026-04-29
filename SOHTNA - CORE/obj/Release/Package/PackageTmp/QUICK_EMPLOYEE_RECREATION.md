# ? QUICK ACTION - DELETE & RECREATE EMPLOYEES

## ? Code Verification Complete

The sync code is **CORRECT** and will parse SiteId as 'BH001' ?

**Key Method:**
```csharp
private string GetSiteIdAsString(string siteId)
{
    return string.IsNullOrEmpty(siteId) ? "" : siteId;  // Returns 'BH001'
}
```

---

## 5-Step Process

### Step 1: Delete Employees
```sql
Run: DELETE_EMPLOYEES_FOR_SYNC.sql
(This creates a backup first)
```

### Step 2: Rebuild Solution
```
Visual Studio ? Build ? Rebuild Solution
```

### Step 3: Login & Navigate
```
1. Open app and login (Admin/Manager)
2. Go to: Employee Enrollment page
```

### Step 4: Click Sync Button
```
Click: [?? Sync Employees]
Wait for success message
```

### Step 5: Verify
```sql
SELECT TOP 10 EmployeeID, NameSurname, SiteID FROM Employees;
```

**Should show:**
```
EmployeeID  NameSurname        SiteID
1           Andrew             BH001  ?
2           Ayanda Cibne       BH001  ?
3           Brenden Na...      BH001  ?
(Not 849484407 - that's the old problem!)
```

---

## Files You Need

1. **DELETE_EMPLOYEES_FOR_SYNC.sql** - Run this in SSMS
2. **EmployeeEnrollment.aspx.cs** - Already correct (no changes!)
3. **EMPLOYEE_RECREATION_COMPLETE_GUIDE.md** - Detailed instructions

---

## What Gets Created

When you click Sync:
- ? Reads SiteId from your login session
- ? Queries ReaderEvents for that SiteId
- ? Creates employees with:
  - **SiteID = 'BH001'** (the text value, not hash!)
  - **NameSurname** from ReaderEvents
  - **IsActive = 1**
  - **CreatedDate = now**

---

## After Sync

1. ? Profile page will load correctly
2. ? No type conversion errors
3. ? SiteID shows as 'BH001'
4. ? All filtering works correctly

---

## Timeline

```
Delete:    1 minute
Rebuild:   2 minutes
Login:     1 minute
Sync:      1 minute
Verify:    1 minute
Test:      2 minutes
TOTAL:    ~8 minutes
```

---

## ?? Ready to Go!

**The sync code is verified correct!**

No code changes needed - just:
1. Run DELETE_EMPLOYEES_FOR_SYNC.sql
2. Rebuild solution
3. Click Sync button
4. Done! ?

---

**Status: READY - CODE VERIFIED - SAFE TO DELETE & RECREATE** ??

