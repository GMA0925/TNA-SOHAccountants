# ?? URGENT: Database Schema Fix Required

## Problem
The application is getting "Invalid column name" errors because the Employees table is missing required columns.

## Solution
**Run this SQL script immediately:**
```
FIX_EMPLOYEES_TABLE_SCHEMA.sql
```

---

## How to Fix (5 Minutes)

### Quick Steps:
1. **Open SQL Server Management Studio (SSMS)**
2. **Connect to your database**
3. **Open file**: `FIX_EMPLOYEES_TABLE_SCHEMA.sql`
4. **Click Execute** (or press F5)
5. **Wait for completion** - watch the Messages tab
6. **Rebuild solution** in Visual Studio
7. **Test the application** - errors should be gone

---

## What Gets Fixed

? Employee Profile will load correctly
? Leave Request will work
? Attendance Tracking will display data
? All user pages will function
? Profile editing will work
? Database operations will succeed

---

## Missing Columns Being Added

```
Phone
Email
DateOfBirth
Gender
Address
City
State
PostalCode
EmergencyContactName
EmergencyContactPhone
DateOfJoin
Position
Status
ManagerID
ModifiedDate
```

---

## After Running the Script

1. ? Rebuild your Visual Studio solution
2. ? Run the application
3. ? Try logging in
4. ? Navigate to Employee Profile
5. ? All should work!

---

## If You Get Errors Running the Script

**Option 1**: Run columns one at a time:
```sql
ALTER TABLE Employees ADD Phone VARCHAR(20) NULL;
ALTER TABLE Employees ADD Email VARCHAR(255) NULL;
-- ... etc
```

**Option 2**: Contact your DBA for permissions

**Option 3**: Check `DATABASE_SCHEMA_FIX_GUIDE.md` for troubleshooting

---

## Files Provided

- ? **FIX_EMPLOYEES_TABLE_SCHEMA.sql** - Run this!
- ? **DATABASE_SCHEMA_FIX_GUIDE.md** - Full instructions

---

**Time to Fix**: ~5 minutes
**Impact**: HIGH - Fixes all employee-related features
**Priority**: URGENT - Do this now

