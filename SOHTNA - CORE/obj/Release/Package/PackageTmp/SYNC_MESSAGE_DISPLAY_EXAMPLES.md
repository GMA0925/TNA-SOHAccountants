# Visual Display Examples - SyncReaderEventsToEmployees

## On-Page Display Messages

All messages appear in the `lblMessage` label control on EmployeeEnrollment.aspx page.

---

## Message States

### ?? SYNCING (Blue Background)
```
?? Syncing ReaderEvents for SiteId: 1...
```
**When:** Page loads and sync starts
**Duration:** Until sync completes
**User Action:** None needed - wait for sync to finish

---

### ? SUCCESS - Employees Created (Green Background)
```
? SiteId 1: 5 new employee(s) created from ReaderEvents.
```
**When:** Sync completes and employees were created
**SiteId Value:** The site that was queried (1, 2, 3, etc.)
**Employee Count:** Number of new employees added
**User Action:** View the new employees in the grid below

---

### ?? INFO - No Changes (Green Background)
```
?? SiteId 1: No new employees found to sync.
```
**When:** Sync completes but no new employees found
**Reason:** Either no ReaderEvents for that SiteId, or all already exist as employees
**User Action:** Check ReaderEvents table to verify data exists

---

### ? ERROR (Red Background)
```
? Error syncing SiteId 1: String or binary data would be truncated
```
**When:** Database error occurs during sync
**Error Detail:** The actual SQL error message
**User Action:** Check debug output or database for details

---

## Timeline Example

### Example: User Logs In, SiteId = 1

**T+0ms:** Page loads, sync starts
```
Message: ?? Syncing ReaderEvents for SiteId: 1...
Color: Blue
```

**T+500ms:** Processing database query
```
Message: ?? Syncing ReaderEvents for SiteId: 1...
Color: Blue (unchanged)
```

**T+1000ms:** Sync completes, 3 employees created
```
Message: ? SiteId 1: 3 new employee(s) created from ReaderEvents.
Color: Green
```

**T+2000+:** Message persists until user performs next action
```
Message: ? SiteId 1: 3 new employee(s) created from ReaderEvents.
Color: Green (persists)
```

---

## Multi-Site Example

### User 1: SiteId = 1
```
Message: ? SiteId 1: 2 new employee(s) created from ReaderEvents.
Employees Created: GMA Test Account, Marc Adler (from ReaderEvents)
```

### User 2: SiteId = 2
```
Message: ?? SiteId 2: No new employees found to sync.
Employees Created: None
```

---

## With Debug Output

**Visual Display (on page):**
```
? SiteId 1: 5 new employee(s) created from ReaderEvents.
```

**Debug Output (Visual Studio Debug window):**
```
Failed to create employee Small Finger Test: Duplicate key value violates unique constraint
Failed to create employee GMA Test Account: Duplicate key value violates unique constraint
Failed to create employee Marc Adler: Duplicate key value violates unique constraint
Error syncing ReaderEvents to Employees: Operation completed with errors
```

---

## Reading the SiteId Value

The **SiteId number** in the message tells you:
- Which site's ReaderEvents were queried
- Which site the new employees belong to
- Which site had the error (if any)

**Example:**
```
? SiteId 1: 5 new employee(s) created from ReaderEvents.
           ?
           This is the user's assigned SiteId from Session["SiteId"]
```

---

## Troubleshooting with Visual Display

### Problem: Showing SiteId 2, but expecting SiteId 1
**Cause:** User is logged in with wrong account (SiteId 2 user)
**Solution:** Logout and login with correct user (SiteId 1)

### Problem: Message says "No new employees" but ReaderEvents exist
**Cause:** ReaderEvents.PersonName already matches an Employees.NameSurname
**Solution:** Delete the duplicate employee record and try again

### Problem: Error message about data truncation
**Cause:** PersonName field in ReaderEvents is longer than NameSurname in Employees
**Solution:** Trim PersonName or increase NameSurname column length

---

## Color Legend

| Color | Meaning | Action |
|-------|---------|--------|
| ?? Blue | Processing | Wait for completion |
| ?? Green | Success | Review results |
| ?? Red | Error | Check logs & troubleshoot |

---

## Message Updates Timeline

The message **updates in stages:**

1. **Page Load** ? Shows blue "Syncing..." message
2. **Query Executes** ? Message unchanged (still syncing)
3. **Processing** ? Message unchanged (still syncing)
4. **Completion** ? Message changes to green success/info
5. **Next Action** ? Message replaced by action result (save employee, etc.)

---

## What SiteId Means

**Session["SiteId"]** = The site assigned to the logged-in user

**ReaderEvents.SiteID = 1** = ReaderEvents for Site 1
**Employees.SiteID = 1** = Employees for Site 1

**Query filters to:** WHERE ReaderEvents.SiteID = Session["SiteId"]

**Result:** Only syncs employees from your assigned site!

---

## Session Variables Referenced

```csharp
Session["SiteId"]      // Your assigned site (1, 2, 3, etc.)
Session["Username"]    // Your login username
Session["Role"]        // Admin, Manager, Employee
Session["NameSurname"] // Your full name
```

The sync uses **Session["SiteId"]** to determine which ReaderEvents to process.
