# Email Notifications - Quick Start

## What Was Fixed?

Your email notification system had **6 critical issues** that have now been fixed:

1. ? **Hardcoded passwords removed** (SECURITY FIX)
2. ? **SMTP SSL/TLS handling corrected** (now supports port 25, 465, 587)
3. ? **Timeout increased** (from 10s to 30s)
4. ? **Retry logic added** (automatic 2 attempts with backoff)
5. ? **Configuration validation added** (clear error messages)
6. ? **Code cleanup** (removed redundant methods)

---

## Quick Configuration (5 minutes)

### Step 1: Open Web.config
Find the `<appSettings>` section and add your email configuration:

```xml
<add key="SmtpServer" value="mail.yourdomain.com" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="sender@yourdomain.com" />
<add key="SenderPassword" value="YOUR_PASSWORD" />
<add key="ErrorReportEmail" value="admin@yourdomain.com" />
<add key="EnableEmailNotifications" value="true" />
```

### Step 2: Choose Your SMTP Provider

**Gmail:**
```xml
<add key="SmtpServer" value="smtp.gmail.com" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="your-email@gmail.com" />
<add key="SenderPassword" value="YOUR_GMAIL_APP_PASSWORD" />
```

**Office 365:**
```xml
<add key="SmtpServer" value="smtp.office365.com" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="your-email@company.com" />
<add key="SenderPassword" value="YOUR_OFFICE365_PASSWORD" />
```

**Custom Mail Server:**
```xml
<add key="SmtpServer" value="mail.yourcompany.com" />
<add key="SmtpPort" value="587" />
<add key="SenderEmail" value="your-email@company.com" />
<add key="SenderPassword" value="YOUR_EMAIL_PASSWORD" />
```

### Step 3: Test
Create a test error by temporarily adding this code to a page:
```csharp
throw new InvalidOperationException("Test error");
```

### Step 4: Check Results
1. Open Windows Event Viewer ? Applications
2. Look for "TimeAttendanceApp" events
3. Should see "Error report successfully sent" message
4. Check your ErrorReportEmail inbox for the HTML email

---

## Configuration Reference

| Setting | Required | Purpose |
|---------|----------|---------|
| SmtpServer | Yes | SMTP server hostname |
| SmtpPort | Yes | 587 (TLS), 465 (SSL), or 25 (Unsecured) |
| SenderEmail | Yes | Email to send from |
| SenderPassword | Yes | SMTP password |
| ErrorReportEmail | Yes | Email to receive error reports |
| EnableEmailNotifications | No | Set to "false" to disable |

---

## Port Selection Guide

| Port | Type | When to Use |
|------|------|------------|
| **587** | TLS (STARTTLS) | ? Most common (Gmail, Office 365, etc.) |
| **465** | SSL (Implicit) | Some mail servers |
| **25** | Unsecured | Internal mail servers only |

---

## Troubleshooting

### Email Not Arriving?
1. Check Windows Event Viewer for error messages
2. Verify SmtpServer, SmtpPort, and credentials are correct
3. Test SMTP connection from server with telnet:
   ```
   telnet mail.yourdomain.com 587
   ```

### Authentication Failed?
1. Verify password is correct
2. For Gmail: Use App Password, not your login password
3. Verify sender email has SMTP access enabled

### Timeout Errors?
1. Increase timeout in ErrorReporter.cs (line with `smtpClient.Timeout`)
2. Check network connectivity to SMTP server
3. Verify firewall allows outbound traffic on SMTP port

---

## What Happens Now

### When an Error Occurs:
1. System catches the exception
2. Validates email configuration
3. Builds detailed HTML error report
4. Attempts to send email
5. If fails, retries automatically (up to 2 attempts)
6. Logs result to Windows Event Viewer
7. If all fails, error is still logged to Event Viewer as fallback

### Email Contains:
- Error message and type
- Stack trace with line numbers
- Inner exception details
- Server information
- Web request details (URL, IP, user)
- Form data (passwords filtered out)
- Timestamp

---

## Important Notes

?? **Security**: 
- Change passwords from hardcoded defaults
- Encrypt Web.config for production
- Don't commit passwords to version control
- Consider using environment variables for sensitive data

?? **Testing**:
- Always test with your actual SMTP configuration
- Test from your production server environment
- Verify email delivery before going live

?? **Gmail Users**:
- Use App Password, not your regular password
- Enable "Less secure app access" OR use App Password
- 2FA may be required

---

## Additional Resources

For detailed setup and troubleshooting, see:
- **EMAIL_NOTIFICATIONS_SETUP_GUIDE.md** - Complete documentation
- **EMAIL_NOTIFICATIONS_FIXES_SUMMARY.md** - What was fixed and why

---

## Support Checklist

Before contacting support, verify:
- [ ] Web.config settings are filled in (not empty)
- [ ] SMTP server and port are correct for your provider
- [ ] Credentials are correct
- [ ] Firewall allows outbound SMTP traffic
- [ ] Checked Windows Event Viewer for error messages
- [ ] Tested email delivery with test error

---

**Status**: ? Build successful - Ready to configure and test
