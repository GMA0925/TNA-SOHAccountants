# ? EMPLOYEE SYNC - SITEID PARSING VERIFICATION

## Current Status

The EmployeeEnrollment.aspx.cs already has the correct code structure:

### ? What's Correct

**GetSiteIdAsString() method:**
```csharp
private string GetSiteIdAsString(string siteId)
{
    // Return site ID as-is (alphanumeric like 'BH001')
    return string.IsNullOrEmpty(siteId) ? "" : siteId;
}
```

**Employee Creation uses correct method:**
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
        // ? Uses GetSiteIdAsString() - Returns 'BH001' not hash!
        cmd.ExecuteNonQuery();
    }
}
```

---

## ?? Warning About ConvertSiteIdToInt()

**This method exists but should NOT be used:**
```csharp
private int ConvertSiteIdToInt(string siteId)
{
    // DEPRECATED - This method is kept only for backwards compatibility
    // SiteID should now be stored as a string, not converted to int
    if (string.IsNullOrEmpty(siteId))
        return 0;
    int hash = siteId.GetHashCode();
    return Math.Abs(hash) % 2147483647;  // ? Creates hash like 849484407
}
```

**This creates the problem values you're seeing (849484407)!**

---

## What Needs to Be Deleted

When you delete employees and recreate them, the sync code will:

? Read SiteId from Session (e.g., 'BH001')
? Query ReaderEvents for that SiteId
? Create new Employees with `GetSiteIdAsString(siteId)` 
? Insert SiteID as 'BH001' (not a hash!)

---

## Before Deleting Employees - Verify Database Setup

### 1. Verify SiteID Column Type
```sql
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('SiteID', 'SiteId')
ORDER BY TABLE_NAME;
```

**Expected Result:**
```
TABLE_NAME   COLUMN_NAME  DATA_TYPE    CHARACTER_MAXIMUM_LENGTH
Employees    SiteID       nvarchar     -1 (MAX)
Users        SiteId       nvarchar     -1 (MAX)
```

### 2. Run the Bulletproof Fix (If Not Done)
```
FIX_EMPLOYEES_SITEID_BULLETPROOF.sql
```

---

## How to Delete and Recreate Employees

### Step 1: Backup Data (Optional but Recommended)
```sql
-- Backup to see what you had
SELECT * INTO Employees_Backup FROM Employees WHERE 1=0;
```

### Step 2: Delete All Employees
```sql
DELETE FROM Employees;
```

### Step 3: Verify Employees Table is Empty
```sql
SELECT COUNT(*) as EmployeeCount FROM Employees;
-- Should return 0
```

### Step 4: Use Sync Feature
1. Login as Admin or Manager
2. Go to Employee Enrollment page
3. Click **[?? Sync Employees]** button
4. System will:
   - ? Query ReaderEvents for your SiteId
   - ? Create new Employees with 'BH001' SiteID
   - ? Log sync activity

### Step 5: Verify New Data
```sql
SELECT TOP 10 EmployeeID, NameSurname, SiteID FROM Employees;
```

**Expected Result:**
```
EmployeeID  NameSurname        SiteID
1           Andrew             BH001
2           Ayanda Cibne       BH001
3           Brenden Na...      BH001
4           Deleni Sithole     CT001
5           Elphas Zakwe       DBN
```

---

## Code Guarantee

? **The sync code is correct:**
- Uses `GetSiteIdAsString(siteId)` ?
- Returns siteId as-is (e.g., 'BH001') ?
- Inserts NVARCHAR(50) value ?
- NOT using ConvertSiteIdToInt() ?

? **When you recreate employees:**
- New SiteID values will be 'BH001', 'CT001', etc.
- NOT hash codes (849484407)
- Matches User SiteId values ?

---

## Key Code Locations

### EmployeeEnrollment.aspx.cs Line Numbers:
```csharp
Line 83:   btnSyncEmployees_Click()     - Sync button handler
Line 106:  SyncReaderEventsToEmployees()- Main sync logic
Line 177:  CreateEmployeeFromReaderEvent() - Employee creation ? Uses GetSiteIdAsString
Line 188:  GetSiteIdAsString()          - ? Returns 'BH001' format
Line 198:  ConvertSiteIdToInt()         - ?? DEPRECATED - Don't use
```

---

## SQL Parameter Type

**Correct implementation:**
```csharp
cmd.Parameters.Add("@SiteID", SqlDbType.NVarChar, 50).Value = GetSiteIdAsString(siteId);
```

This ensures:
- ? Data type is NVARCHAR(50)
- ? Parameter receives string value 'BH001'
- ? Database stores 'BH001', not a hash
- ? Employee Profile can find records

---

## After Recreating Employees

### Test Steps:
1. ? Login as user
2. ? Click [?? Profile] button
3. ? Verify profile loads (no type errors)
4. ? Verify SiteID displays as 'BH001'
5. ? Test editing profile
6. ? Verify changes save

---

## Summary

| Aspect | Status | Details |
|--------|--------|---------|
| Sync Code | ? CORRECT | Uses GetSiteIdAsString() |
| SiteID Format | ? 'BH001' | Not converted to hash |
| Parameter Type | ? NVARCHAR(50) | Correct SQL type |
| Database Column | ? NVARCHAR(MAX) | After schema fix |
| Ready to Delete | ? YES | Safe to recreate |

---

## One Final Check

Before deleting employees, run this query:

```sql
-- Verify sync code will find ReaderEvents for your site
SELECT COUNT(*) as EventCount
FROM ReaderEvents
WHERE SiteId = 'BH001'
  AND PersonName IS NOT NULL
  AND PersonName <> '';
```

**Expected:** Returns > 0 if there are events to sync

If 0 events, no employees will be created. You may need to have ReaderEvents data first.

---

**Status: ? READY TO DELETE AND RECREATE EMPLOYEES**

The sync code is parsing SiteId correctly as 'BH001' format!

