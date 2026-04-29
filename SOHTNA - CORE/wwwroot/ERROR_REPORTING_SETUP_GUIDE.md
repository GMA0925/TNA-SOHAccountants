# ? SYSTEM-WIDE ERROR REPORTING TOOL - COMPLETE SETUP GUIDE

## Overview

Created a comprehensive **system-wide error reporting tool** that automatically captures unhandled exceptions and sends professional HTML emails to `sales@epiqtechsa.co.za`.

---

## Components Created

### 1. **ErrorReporter.cs** (App_Code)
Central utility class that handles:
- ? Error capture and formatting
- ? HTML email generation with professional styling
- ? SMTP email delivery
- ? Fallback logging to Windows Event Viewer

### 2. **Global.asax.cs Update**
Global HTTP error handler that:
- ? Catches all unhandled exceptions
- ? Automatically calls ErrorReporter
- ? Passes page context information

---

## Email Features

### Professional Formatting
? Responsive HTML design
? Color-coded sections (gradient header, colored borders)
? Emoji icons for visual clarity
? Organized information hierarchy

### Information Included

**?? Error Details**
- Location (page/component)
- Timestamp
- Error type
- Error message

**?? Stack Trace**
- Full stack trace with formatting
- Monospace font for clarity

**?? Inner Exception**
- Inner exception type
- Inner exception message
- Inner exception stack trace

**?? Application Context**
- Server name
- Current user
- .NET version
- Operating system
- Request URL
- HTTP method
- IP address
- Hostname
- Current authenticated user
- Form data (excluding passwords/tokens)

### Email Subject
```
?? ERROR REPORT - 2024-01-15 14:30:45 - NullReferenceException
```

---

## Setup Instructions

### Step 1: Configure Web.config

Add these settings to your Web.config's `<configuration><appSettings>` section:

```xml
<appSettings>
    <!-- Error Reporting Configuration -->
    <add key="EmailPassword" value="YOUR_APP_PASSWORD_HERE" />
    <add key="SmtpServer" value="smtp.gmail.com" />
    <add key="SmtpPort" value="587" />
    <add key="SenderEmail" value="your-email@gmail.com" />
    <add key="ErrorReportEmail" value="sales@epiqtechsa.co.za" />
</appSettings>
```

### Step 2: Update ErrorReporter.cs

Update these fields with your email configuration:

```csharp
private static readonly string ErrorReportEmail = "sales@epiqtechsa.co.za";
private static readonly string SmtpServer = "smtp.gmail.com";
private static readonly int SmtpPort = 587;
private static readonly string SenderEmail = "your-email@gmail.com"; // Update this
private static readonly string SenderPassword = ""; // Read from Web.config
```

### Step 3: For Gmail Users (Recommended)

1. Enable 2-Factor Authentication on your Google Account
2. Go to: https://myaccount.google.com/apppasswords
3. Select "Mail" and "Windows Computer"
4. Google will generate a 16-character app password
5. Use this 16-character password in Web.config as `EmailPassword`

### Step 4: For Other Email Providers

Update the following in ErrorReporter.cs:

```csharp
private static readonly string SmtpServer = "smtp.yourprovider.com";
private static readonly int SmtpPort = 587; // or 465 for SSL
```

### Step 5: Build and Deploy

```
Visual Studio ? Build ? Rebuild Solution
Deploy to server
```

---

## How It Works

### Automatic Error Flow

1. **User encounters unhandled exception** anywhere in the application
2. **Global.asax Application_Error() fires**
3. **ErrorReporter.ReportError() called with exception details**
4. **Professional HTML email generated** with full context
5. **Email sent to sales@epiqtechsa.co.za**
6. **Fallback logging to Event Viewer** if email fails

### No Code Changes Required!

The error reporting is **automatic** - no need to wrap try/catch blocks everywhere.

---

## Email Template Preview

### Header
```
?? ERROR NOTIFICATION ??
Time & Attendance Portal - Automatic Error Report
```

### Error Details Section
```
? Error Details
?? Location: EmployeeEnrollment.aspx.cs
? Time: 2024-01-15 14:30:45.123
? Error Type: NullReferenceException
?? Message: Object reference not set to an instance of an object
```

### Stack Trace Section
```
?? Stack Trace
at TimeAttendance.WebForms.EmployeeEnrollment.LoadEmployees() in C:\...\EmployeeEnrollment.aspx.cs:line 350
at TimeAttendance.WebForms.EmployeeEnrollment.Page_Load(Object sender, EventArgs e) in ...
```

### Application Context Section
```
?? Application Context
??? Server: SERVER-NAME
?? User: DOMAIN\Username
.NET Version: 4.0.30319.42000
?? OS: Microsoft Windows 10 Enterprise
?? URL: https://timeattendance.local/EmployeeEnrollment.aspx
?? HTTP Method: POST
?? IP Address: 192.168.1.100
?? Host: user-pc.domain.com
?? Current User: domain\jdoe
```

### Footer
```
?? This is an automated error report sent from the Time & Attendance Portal
?? If this email contains sensitive information, please handle it carefully
Generated: 2024-01-15 14:30:45 UTC
```

---

## Security Considerations

? **Password Protection**
- Email password stored in Web.config (not in code)
- Web.config should be restricted in IIS

? **Data Privacy**
- Form data included but passwords/tokens excluded
- HTML encoding prevents injection attacks

? **Error Details**
- Stack traces help developers debug
- Should not expose sensitive logic

?? **Recommendation**
- Monitor these error emails
- Act on errors reported
- Consider implementing error notification in admin panel

---

## Testing the Error Reporter

### Manual Test - Create an Error

Add this to any page's Page_Load:

```csharp
protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
    {
        // Test error reporting
        throw new Exception("Test error from EmployeeProfile.aspx");
    }
}
```

### Expected Result

1. Error is thrown
2. Global.asax Application_Error catches it
3. ErrorReporter.ReportError() is called
4. Email is sent to sales@epiqtechsa.co.za within seconds
5. Email contains full details with professional formatting

### Check Event Viewer

Windows Server:
```
Event Viewer ? Windows Logs ? Application ? Source: TimeAttendanceApp
```

---

## Troubleshooting

### Email Not Sending

**Check:**
1. ? Web.config has correct EmailPassword
2. ? SenderEmail is correct Gmail address
3. ? Gmail has 2FA enabled and app password created
4. ? Firewall allows port 587 (SMTP)
5. ? Network connectivity to smtp.gmail.com

**Enable Debug:**
Add to ErrorReporter.SendErrorEmail():
```csharp
smtpClient.ServicePointManager.ServerCertificateValidationCallback = 
    (s, certificate, chain, sslPolicyErrors) => true;
```

### SMTP Authentication Failed

**Solution:**
1. Check email/password in Web.config
2. Regenerate app password from Google
3. Ensure 2FA is enabled on Google account
4. Try using a simpler email provider first for testing

### Event Log Disabled

**Fallback:**
ErrorReporter automatically tries event log but fails gracefully. Email is primary method.

---

## Production Recommendations

### 1. Email Monitoring
- Create email rule to forward to admin notification system
- Set up alerts for "ERROR REPORT" subject lines

### 2. Error Dashboard
- Consider adding a page that displays recent errors
- Show error count, frequency, affected users

### 3. Response Process
- Define SLA for error response
- Assign owner to monitor these emails
- Log errors in issue tracking system

### 4. Analysis
- Track error frequency trends
- Identify recurring issues
- Prioritize bug fixes based on error frequency

### 5. Notification
- Consider Slack/Teams integration
- Send alerts to on-call support
- Mobile notifications for critical errors

---

## Customization

### Change Email Recipient

In ErrorReporter.cs:
```csharp
private static readonly string ErrorReportEmail = "newemail@domain.com";
```

### Change SMTP Server

In ErrorReporter.cs:
```csharp
private static readonly string SmtpServer = "smtp.yourprovider.com";
private static readonly int SmtpPort = 587; // or 465
```

### Modify Email Template

Update the `BuildErrorReport()` method:
- Change colors in CSS section
- Add/remove emoji
- Reorder information sections
- Change HTML structure

### Add Custom Fields

In `BuildErrorReport()`, add custom context:
```csharp
report.AppendLine($"<p><span class='label'>?? Client:</span> <span class='value'>{GetClientName()}</span></p>");
```

---

## Build Status
? **SUCCESSFUL** - No compilation errors

---

## Summary

| Feature | Status |
|---------|--------|
| Global error capture | ? Complete |
| Professional HTML email | ? Complete |
| Emoji formatting | ? Complete |
| Full context details | ? Complete |
| SMTP configuration | ? Complete |
| Fallback logging | ? Complete |
| Security | ? Implemented |
| Setup guide | ? Included |

---

**System-wide error reporting is now active and ready for production!** ??
