# Navigation & Logout Quick Reference

## Header Layout (All Pages)

```
?????????????????????????????????????????????????????????????
?  ?? Time & Attendance Portal          ?? Logout           ?
?????????????????????????????????????????????????????????????
```

---

## Navigation Menu (All Pages)

```
?????????????????????????????????????????????????????????????
? ?? Dashboard ? ?? Reports ? ?? Sync Log ? ?? Users ?      ?
? ?? Config ? ?? Enrollment ? ?? Shifts ? CURRENT PAGE      ?
?????????????????????????????????????????????????????????????
```

---

## Menu Buttons (7 Total)

| Button | Icon | Page | Go To |
|--------|------|------|-------|
| Dashboard | ?? | All pages | Dashboard.aspx |
| Reports | ?? | All pages | Reports.aspx |
| Sync Log | ?? | All pages | SyncLog.aspx |
| User Management | ?? | All pages | UserManagement.aspx |
| Config Tools | ?? | All pages | ConfigTools.aspx |
| Employee Enrollment | ?? | All pages | EmployeeEnrollment.aspx |
| Shift Management | ?? | All pages | ShiftManagement.aspx |

---

## Logout Button

**Location:** Top-right corner of header
**Icon:** ?? Sign-out
**Text:** "Logout"
**Action:** 
1. Clear all session variables
2. Abandon session
3. Redirect to Login.aspx

---

## Active Page Indicators

When you visit each page, that button becomes active (darker blue, bold):

### Dashboard.aspx
```
?? Dashboard ? ACTIVE (darker blue, bold)
```

### Reports.aspx
```
?? Reports ? ACTIVE (darker blue, bold)
```

### SyncLog.aspx
```
?? Sync Log ? ACTIVE (darker blue, bold)
```

### UserManagement.aspx
```
?? User Management ? ACTIVE (darker blue, bold)
```

### ConfigTools.aspx
```
?? Config Tools ? ACTIVE (darker blue, bold)
```

### EmployeeEnrollment.aspx
```
?? Employee Enrollment ? ACTIVE (darker blue, bold)
```

### ShiftManagement.aspx
```
?? Shift Management ? ACTIVE (darker blue, bold)
```

---

## User Navigation Flow

### Logging In
```
Login.aspx
    ?
    Enter credentials
    ?
    Dashboard.aspx (landing page)
```

### Navigating Between Pages
```
Any Page
    ?
    Click menu button
    ?
    New page loads
    ?
    Button highlights as active
```

### Logging Out
```
Any Page
    ?
    Click "?? Logout" button (top-right)
    ?
    Session cleared
    ?
    Login.aspx
```

---

## Key Features

? **Same navigation on every page** - 7 buttons in same order
? **Logout button always visible** - Top-right corner
? **Current page highlighted** - Easy to see where you are
? **Click to navigate** - All buttons work from any page
? **Session protection** - Back button won't work after logout
? **Consistent styling** - Same colors, fonts, spacing

---

## Mobile View

On smaller screens:
- Buttons may wrap to multiple lines
- Logout button stays in top-right
- Navigation remains the same

---

## For Developers

### To Add a New Menu Item:
1. Add button to ASPX file in nav section
2. Add OnClick handler in code-behind
3. Create Click handler method that calls Response.Redirect()
4. Add same button to all other page's nav sections

### To Change Navigation Order:
1. Change button order in nav section
2. Keep order consistent across all pages

### To Modify Logout Behavior:
1. Edit btnLogout_Click() method
2. Currently clears Session and redirects to Login.aspx
3. Can add logging, audit trail, etc. here

---

## Summary

**All 4 pages now have:**
- ? Identical header with logo and logout
- ? Identical 7-button navigation menu
- ? Active page indicator
- ? Logout functionality
- ? Consistent styling
- ? Session protection

**User Experience:**
- Know where you are (active button)
- Easy navigation (same menu everywhere)
- Easy logout (always visible button)
- Protected from accidental back button access

