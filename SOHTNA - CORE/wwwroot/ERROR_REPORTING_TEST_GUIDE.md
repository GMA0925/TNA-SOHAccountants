# ?? ERROR REPORTING SYSTEM - TEST GUIDE

## Quick Test (2 Minutes)

### Test Method 1: Simple Exception (Recommended)

1. **Open any .aspx.cs file** (e.g., EmployeeProfile.aspx.cs)

2. **Find Page_Load method:**
   ```csharp
   protected void Page_Load(object sender, EventArgs e)
   {
       if (!IsPostBack)
       {
           // Add this line to test
           throw new Exception("?? Testing error reporting system");
       }
   }
   ```

3. **Build and Run** (F5 or Ctrl+Shift+B then run)

4. **Navigate to that page** - The error should trigger

5. **Check email** at sales@epiqtechsa.co.za for the error report

6. **Remove the test exception** before deploying to production

---

## Test Method 2: Navigation to Invalid Page

1. **Run the application** (F5)

2. **Navigate to a non-existent page:**
   ```
   https://localhost:####/InvalidPage12345.aspx
   ```

3. **This will trigger a 404 error**

4. **Check email** at sales@epiqtechsa.co.za

5. **Email should contain:**
   - ?? ERROR NOTIFICATION
   - ? Error Details (404 or server error)
   - ?? URL: /InvalidPage12345.aspx
   - ?? Stack Trace
   - ?? Application Context

---

## Expected Email Content

When you test, you should receive an email like this:

**From:** sales@epiqtechsa.co.za
**To:** sales@epiqtechsa.co.za
**Subject:** ?? ERROR REPORT - 2024-01-15 14:30:45 - Exception

**Body (HTML):**
```
?? ERROR NOTIFICATION ??
Time & Attendance Portal - Automatic Error Report

? Error Details
?? Location: EmployeeProfile.aspx.cs
? Time: 2024-01-15 14:30:45.123
? Error Type: Exception
?? Message: ?? Testing error reporting system

?? Stack Trace
at TimeAttendance.WebForms.EmployeeProfile.Page_Load(Object sender, EventArgs e)
at System.Web.UI.Control.OnLoad(EventArgs e)
at System.Web.UI.Page.ProcessRequestMain(Boolean includeStagesBeforeAsyncPoint, Boolean includeStagesAfterAsyncPoint)

?? Application Context
??? Server: [YOUR_COMPUTER]
?? User: [YOUR_USERNAME]
.NET Version: 4.8.4515.0
?? OS: Microsoft Windows 10 Enterprise
?? URL: https://localhost:12345/EmployeeProfile.aspx
?? HTTP Method: GET
?? IP Address: 127.0.0.1
?? Host: [YOUR_HOSTNAME]
?? Current User: [YOUR_USERNAME]

?? This is an automated error report sent from the Time & Attendance Portal
?? If this email contains sensitive information, please handle it carefully
Generated: 2024-01-15 14:30:45 UTC
```

---

## Verification Checklist

### ? Email Received
- [ ] Email arrived at sales@epiqtechsa.co.za
- [ ] From: sales@epiqtechsa.co.za
- [ ] Subject contains: ?? ERROR REPORT
- [ ] Subject contains: timestamp
- [ ] Subject contains: error type

### ? Email Content
- [ ] Header shows: ?? ERROR NOTIFICATION ??
- [ ] Error Details section present
- [ ] Location/page shown correctly
- [ ] Error message displayed
- [ ] Stack trace included with line numbers
- [ ] Application Context shows server info
- [ ] Current user shown
- [ ] IP Address shown
- [ ] Timestamp included

### ? HTML Formatting
- [ ] Email has professional design
- [ ] Colors show correctly (purple header)
- [ ] All emoji display correctly
- [ ] Text is readable
- [ ] Sections are clearly separated
- [ ] Code is in monospace font

---

## If Email Doesn't Arrive

### Step 1: Check Inbox and Spam
- [ ] Check sales@epiqtechsa.co.za inbox
- [ ] Check spam/junk folder
- [ ] Check email filters

### Step 2: Check Event Viewer
1. Open Event Viewer
2. Navigate to: Windows Logs ? Application
3. Look for entries from: TimeAttendanceApp
4. Check for error messages about SMTP

**Windows Command:**
```
eventvwr.msc
```

### Step 3: Verify Configuration
Check Web.config has correct settings:
```xml
<add key="SmtpServer" value="mail.epiqtechsa.co.za" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="sales@epiqtechsa.co.za" />
<add key="SenderPassword" value="0925Greg@#!!!" />
```

### Step 4: Test SMTP Connection
**Command Prompt:**
```
telnet mail.epiqtechsa.co.za 587
```

Should respond with:
```
Connected to mail.epiqtechsa.co.za.
Escape character is '^]'.
```

### Step 5: Check Network/Firewall
- [ ] Port 587 not blocked by firewall
- [ ] Corporate proxy not blocking SMTP
- [ ] Network connectivity to mail.epiqtechsa.co.za available

---

## Production Testing

Before deploying to production, perform these tests:

### Test 1: NullReferenceException
```csharp
protected void btnTest_Click(object sender, EventArgs e)
{
    object obj = null;
    obj.ToString(); // Will throw NullReferenceException
}
```

### Test 2: Database Error
```csharp
protected void btnTest_Click(object sender, EventArgs e)
{
    // Invalid connection string
    string badConnection = "Invalid connection string";
    SqlConnection conn = new SqlConnection(badConnection);
    conn.Open(); // Will throw SqlException
}
```

### Test 3: Division by Zero
```csharp
protected void btnTest_Click(object sender, EventArgs e)
{
    int x = 10;
    int y = 0;
    int result = x / y; // Will throw DivideByZeroException
}
```

---

## Success Indicators

### ? System is Working When:

1. **Exception is thrown** ? Email sent within 3-5 seconds
2. **Email arrives at sales@epiqtechsa.co.za** ? Configuration correct
3. **Email contains full stack trace** ? System working properly
4. **Email shows error location** ? Context captured correctly
5. **Email is professionally formatted** ? Design working properly

---

## Cleanup After Testing

### Remove Test Code
Delete any test exceptions you added:
```csharp
// REMOVE THIS BEFORE PRODUCTION
throw new Exception("?? Testing error reporting system");
```

### Clean Up Test Files
Remove any test files created during testing

### Verify Settings
Ensure Web.config is correct:
```xml
<!-- These should be your real production values -->
<add key="SenderEmail" value="sales@epiqtechsa.co.za" />
<add key="ErrorReportEmail" value="sales@epiqtechsa.co.za" />
```

---

## Post-Test Deployment

Once testing is complete:

1. **Remove all test code** from .aspx.cs files
2. **Rebuild solution** (Ctrl+Shift+B)
3. **Run full application test** to ensure no broken functionality
4. **Deploy to production** with confidence
5. **Monitor error emails** for real errors

---

## Troubleshooting Checklist

| Issue | Solution |
|-------|----------|
| Email not received | Check inbox, spam, and Event Viewer |
| Wrong sender address | Verify Web.config SenderEmail |
| Authentication failed | Check SenderPassword, no extra spaces |
| Connection timeout | Check firewall, port 587 access |
| Missing stack trace | Check exception type, should be in email |
| Poor HTML formatting | Check email client, try different client |

---

## Test Summary

**Estimated Time:** 5 minutes
**Success Rate:** Should be 100% if configuration correct
**Next Step:** Deploy to production once verified

---

## Need Help?

If emails aren't arriving:

1. Check Event Viewer: `eventvwr.msc`
2. Review Web.config settings
3. Test SMTP: `telnet mail.epiqtechsa.co.za 587`
4. Verify credentials are exact
5. Check firewall/network connectivity

---

**Once you successfully receive a test email, your error reporting system is ready for production!** ??
