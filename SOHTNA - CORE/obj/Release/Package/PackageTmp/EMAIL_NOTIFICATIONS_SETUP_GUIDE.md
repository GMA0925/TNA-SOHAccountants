# Email Notifications Setup & Testing Guide

## Overview
The Time & Attendance application now has improved error notification system with the following features:
- ? Secure configuration (no hardcoded passwords)
- ? Retry logic with exponential backoff
- ? Automatic fallback to Windows Event Viewer
- ? Detailed HTML-formatted error reports
- ? Configuration validation
- ? Optional enable/disable toggle

---

## Configuration Steps

### 1. Update Web.config Settings

Open `Web.config` and configure the following settings under `<appSettings>`:

```xml
<!-- Email Configuration for Error Reporting -->
<add key="SmtpServer" value="YOUR_SMTP_SERVER" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="YOUR_SENDER_EMAIL@domain.com" />
<add key="SenderPassword" value="YOUR_SMTP_PASSWORD" />
<add key="ErrorReportEmail" value="ADMIN_EMAIL@domain.com" />
<add key="EnableEmailNotifications" value="true" />
```

### 2. SMTP Server Configuration

Choose the appropriate settings based on your email provider:

#### Gmail (with App Password)
```
SmtpServer: smtp.gmail.com
SmtpPort: 587
EnableSsl: Yes (port 587 uses TLS/STARTTLS)
SenderEmail: your-email@gmail.com
SenderPassword: Your Gmail App Password (not your regular password)
```

#### Microsoft 365 / Office 365
```
SmtpServer: smtp.office365.com
SmtpPort: 587
EnableSsl: Yes (port 587 uses TLS/STARTTLS)
SenderEmail: your-email@company.com
SenderPassword: Your Office 365 Password
```

#### Custom Mail Server (cPanel/Plesk)
```
SmtpServer: mail.yourdomain.com
SmtpPort: 587 (or 465 for SSL, or 25 for unsecured)
EnableSsl: Yes (for port 587), No (for port 25)
SenderEmail: your-email@yourdomain.com
SenderPassword: Your email account password
```

### 3. Security Best Practices

**Important**: Never hardcode production credentials in Web.config!

#### Option A: Use Web.config Encryption (Recommended for .NET Framework)
```powershell
# Run Command Prompt as Administrator
cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
aspnet_regiis -pf "C:\path\to\Web.config" DataProtectionConfigurationProvider
```

#### Option B: Use Environment Variables (IIS)
1. Set environment variables on the server:
   - `SMTP_SERVER`
   - `SMTP_PORT`
   - `SENDER_EMAIL`
   - `SENDER_PASSWORD`
   - `ERROR_REPORT_EMAIL`

2. Update ErrorReporter.cs to read from environment:
```csharp
private static readonly string SmtpServer = 
    Environment.GetEnvironmentVariable("SMTP_SERVER") ?? 
    GetAppSetting("SmtpServer", "");
```

#### Option C: Use Azure Key Vault
Store sensitive credentials in Azure Key Vault and retrieve them at runtime.

---

## Testing Email Notifications

### Method 1: Manual Testing in Debug

Create a test page (e.g., `Test.aspx.cs`):

```csharp
protected void Page_Load(object sender, EventArgs e)
{
    try
    {
        // Simulate an error to test email notification
        throw new InvalidOperationException("This is a test error to verify email notifications are working.");
    }
    catch (Exception ex)
    {
        // This will trigger the error email
        TimeAttendance.WebForms.App_Code.ErrorReporter.ReportError(ex, "Test.aspx - Page_Load");
    }
}
```

### Method 2: Using SMTP Test Tool

Install and use a tool like **MailCatcher** or **Papercut** to capture SMTP traffic:

```powershell
# Download and run Papercut (Windows)
https://github.com/ChangemakerStudios/Papercut-SMTP
```

### Method 3: Verify Windows Event Viewer

If email fails, check Windows Event Viewer:
1. Open Event Viewer
2. Navigate to: Windows Logs ? Application
3. Look for entries from "TimeAttendanceApp" source
4. Check the message for email configuration or SMTP errors

### Expected Email Subjects
- `?? ERROR REPORT - 2024-01-15 10:30:45 - NullReferenceException`
- `?? ERROR REPORT - 2024-01-15 10:30:45 - ArgumentException`

---

## Troubleshooting

### Issue: Email Not Sending

**Check the following in order:**

1. **Verify Configuration**
   ```csharp
   // Add this to Test.aspx to see current settings:
   Response.Write($"SmtpServer: {GetAppSetting("SmtpServer")}<br/>");
   Response.Write($"SmtpPort: {GetAppSetting("SmtpPort")}<br/>");
   Response.Write($"SenderEmail: {GetAppSetting("SenderEmail")}<br/>");
   Response.Write($"ErrorReportEmail: {GetAppSetting("ErrorReportEmail")}<br/>");
   Response.Write($"EnableEmailNotifications: {GetAppSetting("EnableEmailNotifications")}<br/>");
   ```

2. **Check Windows Event Viewer**
   - Look for "TimeAttendanceApp" source messages
   - Check for SMTP authentication failures
   - Look for port connection issues

3. **Test SMTP Connectivity**
   ```powershell
   # Test connection from server
   Test-NetConnection -ComputerName smtp.gmail.com -Port 587
   ```

4. **Verify Credentials**
   - Gmail: Use "App Passwords", not regular password
   - Office 365: May need MFA app password
   - Custom servers: Verify user has SMTP access enabled

5. **Check Firewall Rules**
   - Ensure outbound SMTP port (587/465/25) is allowed
   - Check IIS Application Pool permissions
   - Verify antivirus isn't blocking SMTP

### Issue: "Timeout" in Event Viewer

Increase the SMTP timeout in ErrorReporter.cs:
```csharp
smtpClient.Timeout = 30000; // Currently 30 seconds
// Increase to 60000 (60 seconds) if needed
```

### Issue: "Authentication Failed"

1. Verify username and password are correct
2. For Gmail: Use App Password, not regular password
3. Check if account has SMTP enabled
4. Verify sender email matches the authenticated account

### Issue: "EnableSSL" Errors

The code now automatically handles SSL/TLS:
- Port 587 ? Uses EnableSsl = true (STARTTLS)
- Port 465 ? Uses EnableSsl = false (Implicit SSL)
- Port 25 ? Uses EnableSsl = false (Unsecured)

---

## Configuration Validation Checklist

- [ ] SmtpServer is configured and not empty
- [ ] SmtpPort is set to correct value (587, 465, or 25)
- [ ] SenderEmail is configured with valid email format
- [ ] SenderPassword is set and correct
- [ ] ErrorReportEmail is configured with valid email format
- [ ] EnableEmailNotifications is set to "true"
- [ ] Web.config is encrypted (for sensitive deployments)
- [ ] IIS App Pool has appropriate permissions
- [ ] Firewall allows outbound SMTP traffic
- [ ] SMTP server allows authentication from IIS server IP

---

## Monitoring Email Notifications

### Check Success Rate

Monitor Windows Event Viewer for messages:
- "Error report successfully sent for:"
- "Failed to send error email after X attempts"

### Enable Debug Logging

Add to your Global.asax:
```csharp
protected void Application_Error()
{
    Exception ex = Server.GetLastError();
    if (ex != null)
    {
        System.Diagnostics.Debug.WriteLine($"Error caught: {ex.Message}");
        ErrorReporter.ReportError(ex, "Global.asax - Application_Error");
    }
}
```

### Production Monitoring

For production environments, consider:
1. Setting up an email delivery confirmation system
2. Creating an admin dashboard to view error reports
3. Setting up alerts when email delivery fails
4. Archiving error emails for compliance

---

## Features Summary

### Automatic Retry Logic
- Attempts to send email up to 2 times
- Uses exponential backoff (2s, 4s between retries)
- Logs final failure to Windows Event Viewer

### Secure Password Handling
- Passwords read from Web.config (can be encrypted)
- No hardcoded credentials in source code
- Optional: Use environment variables or Key Vault

### Detailed Error Reports
The email includes:
- ? Error message and type
- ? Stack trace with line numbers
- ? Inner exception details
- ? Server environment information
- ? Web request context (URL, IP, user)
- ? Form data (excluding passwords/tokens)
- ? Timestamp with timezone
- ? Formatted HTML for readability

### Fallback Mechanism
If email fails, errors are logged to Windows Event Viewer as automatic fallback.

---

## Support

For questions or issues with email notifications:
1. Check Windows Event Viewer for detailed error messages
2. Review this troubleshooting guide
3. Test SMTP connectivity from the server
4. Verify all Web.config settings are correct
5. Contact your email provider for SMTP credentials verification
