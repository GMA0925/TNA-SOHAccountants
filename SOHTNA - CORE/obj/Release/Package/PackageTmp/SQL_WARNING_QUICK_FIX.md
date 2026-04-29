# ? QUICK FIX - BUILD SQL FILE WARNING

## Problem
Build warning/error about SQL files not found during packaging:
```
Could not find file 'DIAGNOSE_EMPLOYEE_PROFILE_ISSUE.sql'
```

## Root Cause
Diagnostic SQL files (created for setup/debugging) are being included in the package build.

## Quick Fix

### Option A: Delete Diagnostic SQL Files (Recommended)

These files are **NOT needed** for the running application. They're only for setup.

**Delete these from Solution Explorer:**
- DIAGNOSE_EMPLOYEE_PROFILE_ISSUE.sql
- DIAGNOSE_EMPLOYEE_PROFILE_FIX.sql
- FIX_EMPLOYEES_SITEID_*.sql
- DELETE_EMPLOYEES_FOR_SYNC.sql
- UPDATE_SITEID_TO_NVARCHAR_MAX.sql
- CleanupDuplicates_SiteID_Update.sql

**Keep Database_Scripts/ and SQL_Scripts/ folders** (legitimate setup scripts)

### Option B: Keep Files but Exclude from Package

If you want to keep them for reference:

1. Right-click each SQL file
2. Properties ? Build Action ? "None"
3. Rebuild

### Option C: Move to Documentation Folder

1. Create folder: `DocumentationScripts/`
2. Move all diagnostic .sql files there
3. Rebuild

---

## Steps (Option A - Recommended)

1. **Open Solution Explorer** in Visual Studio
2. **Find SQL files** in project root
3. **Delete** the diagnostic ones (listed above)
4. **Keep** Database_Scripts and SQL_Scripts folders
5. **Rebuild:**
   ```
   Build ? Rebuild Solution
   ```

---

## Result

? **Clean build with 0 warnings**
? **No impact on application**
? **Smaller release package**

---

## Build Status After Fix

```
Build succeeded with 0 errors, 0 warnings ?
```

