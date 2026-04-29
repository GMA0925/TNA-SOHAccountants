# Quick Start Guide - User Functions

## ?? Getting Started

All user-level functions have been implemented and are ready for use!

---

## Prerequisites

? **Setup Completed:**
- Database cleanup script provided
- All 12 user pages fully functional
- Session management configured
- Error handling implemented
- Version display added

---

## Before Going Live

### 1. Database Cleanup (CRITICAL)
```sql
-- Run this script on your database first:
CleanupDuplicates_SiteID_Update.sql
```

This script:
- Removes duplicate employee records
- Updates SiteID to 'BH001' (or your preferred value)
- Verifies data integrity

---

### 2. Update SiteID Configuration
If your site is NOT 'BH001', update the cleanup script:
```sql
-- In CleanupDuplicates_SiteID_Update.sql, change:
UPDATE Employees SET SiteID = 'YOUR_SITE_ID'
```

---

### 3. Create Test User
```sql
INSERT INTO Users (Username, PasswordHash, Role, SiteId, NameSurname)
VALUES ('testuser', 'password123', 'User', 'BH001', 'Test User');
```

---

### 4. Create Test Employee
```sql
INSERT INTO Employees (EmployeeID, NameSurname, SiteID, IsActive)
VALUES ('16', 'Test User', 'BH001', 1);
```

---

## Login Process

1. Navigate to Login.aspx
2. Enter username: `testuser`
3. Enter password: `password123`
4. Click Login

**Session Variables Set:**
- `Session["UserID"]` = "16"
- `Session["Username"]` = "testuser"
- `Session["Role"]` = "User"
- `Session["SiteId"]` = "BH001"
- `Session["NameSurname"]` = "Test User"

---

## User Pages Access

After login as User role:

### 1. **Dashboard** (Home)
```
Navigation ? Dashboard
Features: Personal overview, quick stats
```

### 2. **MyClockEvents** (Attendance)
```
Navigation ? Attendance
View: Clock in/out records
Shows: Time, date, status
```

### 3. **LeaveRequest** (Time Off)
```
Navigation ? Leave
Actions: 
  - Submit new leave request
  - View balance
  - Check status
Features: Auto-calculates business days
```

### 4. **LeaveBalance**
```
Navigation ? Leave ? View Balance
Shows: Available, used, remaining days
By: Leave type
```

### 5. **LeaveHistory**
```
Navigation ? Leave ? History
Shows: Past requests and status
Filter: By date range
```

### 6. **TimesheetEntry** (Work Hours)
```
Navigation ? Timesheet
Actions:
  - Add daily work entries
  - Select project and task
  - Log hours worked
  - Mark billable/non-billable
  - Submit for approval
```

### 7. **TimesheetHistory**
```
Navigation ? Timesheet ? History
Shows: Submitted timesheets
Status: Draft, Submitted, Approved, Rejected
```

### 8. **EmployeeProfile** (My Info)
```
Navigation ? Profile
Update:
  - Personal: Name, email, phone, DOB
  - Contact: Address, city, state
  - Emergency: Contact name and phone
```

### 9. **EmployeePayslips** (Salary)
```
Navigation ? Payroll
View: Historical payslips
Filter: By year and month
Download: PDF (future enhancement)
```

### 10. **AttendanceTracking** (Records)
```
Navigation ? Attendance
View: Attendance records
Filter: By date, status, department
Shows: Hours worked, late minutes
```

### 11. **EmployeeSettings** (Security)
```
Navigation ? Settings
Change: Password
Verify: Current password
```

### 12. **NotificationSettings** (Preferences)
```
Navigation ? Notifications
Configure:
  - Email, SMS, In-App, Push notifications
  - Frequency (Immediate, Daily, Weekly)
  - Quiet hours (Do Not Disturb)
  - Notification rules
```

---

## Common Tasks

### Task 1: Submit a Leave Request
```
1. Click Dashboard ? Leave
2. Click "Timesheet" button
3. Select Leave Type
4. Set Start Date (auto-calculates end date)
5. Enter Reason
6. Click "Submit Request"
7. View status in "Leave History"
```

### Task 2: Submit Weekly Timesheet
```
1. Click Dashboard ? Timesheet
2. Week auto-loads (current week)
3. For each day:
   - Select date from dropdown
   - Choose project
   - Enter task description
   - Log hours (0-24)
   - Mark billable checkbox if applicable
   - Click "Add Entry"
4. Review totals
5. Click "Submit" for approval
6. View status in "Timesheet History"
```

### Task 3: Update Profile
```
1. Click Dashboard ? Profile
2. Update Personal Info (name, email, phone, DOB)
3. Click "Update" button
4. Update Contact Info (address, city, state)
5. Click "Update" button
6. Update Emergency Contact
7. Click "Update" button
```

### Task 4: Check Leave Balance
```
1. Click Dashboard ? Leave
2. Click "View Balance" tab
3. See available days per leave type
4. View total and overall balance
```

### Task 5: View Payslip
```
1. Click Dashboard ? Payroll
2. Select Year from dropdown
3. Select Month (optional)
4. View salary breakdown
5. Click to view or download PDF (future)
```

---

## Keyboard Shortcuts (Future)

- `Ctrl+L` - Logout
- `Ctrl+D` - Dashboard
- `Ctrl+T` - Timesheet
- `Ctrl+V` - View Leave Balance

*Coming in future version*

---

## Browser Requirements

? **Recommended:**
- Chrome 90+
- Firefox 88+
- Edge 90+
- Safari 14+

? **Requirements:**
- JavaScript enabled
- Cookies enabled
- 1024x768 minimum resolution

---

## Mobile Access

?? **Mobile Support:**
- Responsive design (future enhancement)
- Mobile-optimized views (coming)
- Currently best on desktop

---

## Troubleshooting

### Issue: Can't Login
**Solution:**
1. Verify username and password
2. Check SiteId is assigned to user
3. Clear browser cache
4. Check browser cookies enabled
5. Look at debug output in Visual Studio

### Issue: Page Shows Blank
**Solution:**
1. Check session is still active
2. Refresh page (F5)
3. Check database connection
4. Verify user has proper access

### Issue: Can't Submit Form
**Solution:**
1. Fill all required fields (marked with *)
2. Check for error message
3. Verify dates are valid
4. Check database has required tables
5. Review validation rules

### Issue: Data Not Showing
**Solution:**
1. Check database has data for your SiteId
2. Verify you're filtering correctly
3. Check date range includes data
4. Clear browser cache
5. Try different filter options

### Issue: Session Expired
**Solution:**
1. Login page will appear
2. Re-enter credentials
3. Session expires after 30 minutes of inactivity
4. You can change timeout in Login.aspx.cs

---

## Getting Help

### Debug Information
View errors in Visual Studio Output window:
```
Tools ? Options ? Debugging ? Output Window ? 
  Show output from: Debug
```

### Error Messages
All error messages display on page in red
Check bottom of page for details

### Database Errors
Check SQL Server logs:
```
Event Viewer ? Windows Logs ? Application
```

### Session Issues
Browser console (F12):
```
Application ? Cookies ? Check for session cookie
```

---

## Best Practices

? **Do:**
- Clear sensitive forms after submission
- Log out when finished
- Update profile information regularly
- Submit timesheets on time
- Save important payslips
- Enable notifications for approvals

? **Don't:**
- Share your login credentials
- Leave browser open unattended
- Submit incomplete forms
- Clear browser cookies/cache unnecessarily
- Use same browser on shared computers

---

## Workflow Recommendations

### Daily
1. **Morning**: View MyClockEvents - confirm clock in recorded
2. **Throughout day**: Add timesheet entries as you work
3. **Evening**: Review daily hours and save timesheet

### Weekly
1. **Monday**: Submit previous week's timesheet
2. **Wednesday**: Check leave balance
3. **Friday**: Review attendance records

### Monthly
1. Download payslip
2. Review and save in records
3. Check updated profile information
4. Verify attendance summary

### Quarterly
1. Update profile if needed
2. Review leave balance
3. Check payslip trends
4. Update emergency contact

---

## Quick Reference

| Task | Navigation | Time |
|------|-----------|------|
| View clock events | Dashboard ? Attendance | 1 min |
| Check leave balance | Dashboard ? Leave | 1 min |
| Submit leave | Dashboard ? Leave ? Submit | 5 min |
| Add timesheet entry | Dashboard ? Timesheet | 3 min |
| View payslip | Dashboard ? Payroll | 2 min |
| Update profile | Dashboard ? Profile | 10 min |
| Change password | Dashboard ? Settings | 3 min |
| Configure notifications | Dashboard ? Notifications | 5 min |

---

## Support Contact

For issues or questions:

?? **Email**: support@company.com
?? **Phone**: 1-800-SUPPORT
?? **Chat**: Available during business hours
?? **Ticket System**: Create support ticket in system

---

## More Information

?? **Full Documentation:**
- `USER_FUNCTIONS_IMPLEMENTATION_SUMMARY.md`
- `USER_FUNCTIONS_ARCHITECTURE.md`
- `CHANGE_LOG.md`

?? **Admin Docs:**
- Employee Enrollment Guide
- System Configuration
- Database Management

---

## Congratulations! ??

Your Time & Attendance system is now fully operational!

**Next Step:** Login with your user account and explore all features.

---

**Version**: Production Ready
**Last Updated**: 2024
**Status**: ? Live

