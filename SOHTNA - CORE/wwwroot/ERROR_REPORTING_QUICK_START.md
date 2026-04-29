# ?? ERROR REPORTING SYSTEM - QUICK REFERENCE

## What Was Created

? **ErrorReporter.cs** - Central error reporting utility
? **Global.asax.cs Update** - Global error handler
? **Professional HTML emails** with emojis
? **Automatic exception capture**

---

## Quick Setup (5 Minutes)

### 1. Update Web.config

```xml
<appSettings>
    <add key="EmailPassword" value="YOUR_16_CHAR_APP_PASSWORD" />
    <add key="SenderEmail" value="your-email@gmail.com" />
    <add key="ErrorReportEmail" value="sales@epiqtechsa.co.za" />
</appSettings>
```

### 2. Update ErrorReporter.cs

Line ~13-15: Set your email address

```csharp
private static readonly string SenderEmail = "your-email@gmail.com";
```

### 3. Build & Deploy

```
Build ? Rebuild Solution ? Deploy
```

### Done! ?

Errors are now automatically reported to sales@epiqtechsa.co.za

---

## Email Format Preview

```
Subject: ?? ERROR REPORT - 2024-01-15 14:30:45 - NullReferenceException

Body:
?? ERROR NOTIFICATION ??
Time & Attendance Portal - Automatic Error Report

? Error Details
?? Location: EmployeeEnrollment.aspx
? Time: 2024-01-15 14:30:45
? Error Type: NullReferenceException
?? Message: Object reference not set...

?? Stack Trace
[Full stack trace with formatting]

?? Application Context
??? Server: SERVER-NAME
?? User: domain\username
?? URL: /EmployeeEnrollment.aspx
?? IP Address: 192.168.1.100
[... more context]
```

---

## How It Works

```
Unhandled Exception Occurs
          ?
Global.asax Application_Error()
          ?
ErrorReporter.ReportError()
          ?
BuildErrorReport() [HTML formatting]
          ?
SendErrorEmail() [SMTP send]
          ?
Email to sales@epiqtechsa.co.za
          ?
[If email fails] ? Log to Event Viewer
```

---

## Features

? **Professional Design** - Responsive HTML with gradient header
? **Full Context** - Server, user, URL, IP, timestamps
? **Stack Traces** - Complete trace with line numbers
? **Inner Exceptions** - Handles nested exceptions
? **Data Privacy** - Excludes passwords/tokens from form data
? **Emoji Icons** - Professional with visual elements
? **Auto-Cleanup** - Fails gracefully if email fails
? **Event Log** - Fallback logging to Windows Event Viewer

---

## For Gmail (Recommended)

1. Enable 2-Factor Authentication
2. Go to https://myaccount.google.com/apppasswords
3. Generate app password
4. Paste 16-character password in Web.config

---

## Testing

Add this to any page to test:

```csharp
throw new Exception("Test error reporting");
```

You should receive an email within seconds.

---

## Customization

**Change recipient:**
```csharp
// ErrorReporter.cs, line 13
private static readonly string ErrorReportEmail = "newemail@domain.com";
```

**Change email server:**
```csharp
private static readonly string SmtpServer = "smtp.yourprovider.com";
private static readonly int SmtpPort = 587;
```

**Change styling:**
Edit the CSS in `BuildErrorReport()` method

---

## Build Status
? SUCCESSFUL

---

## Support

For issues:
1. Check Web.config settings
2. Verify Gmail app password
3. Check Windows Event Viewer for fallback logs
4. Verify SMTP port (587) isn't blocked by firewall

---

**System-wide error reporting is now active!** ??
