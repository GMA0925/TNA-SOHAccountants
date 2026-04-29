# ?? ERROR REPORTING - DEVELOPER GUIDE

## How to Use ErrorReporter in Your Code

### Automatic (Recommended)

No code changes needed! The global error handler catches all unhandled exceptions:

```csharp
public partial class EmployeeEnrollment : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // If any error occurs here, it's automatically reported
        LoadEmployees();
    }
}
```

### Manual Reporting (Optional)

If you want to catch and report specific errors:

```csharp
using TimeAttendance.WebForms.App_Code;

public partial class Dashboard : Page
{
    protected void btnLoadData_Click(object sender, EventArgs e)
    {
        try
        {
            // Your code here
            LoadDashboardData();
        }
        catch (Exception ex)
        {
            // Manually report to error reporter
            ErrorReporter.ReportError(ex, "Dashboard.aspx - btnLoadData_Click");
            
            // Then handle locally if needed
            lblError.Text = "An error occurred. The support team has been notified.";
        }
    }
}
```

---

## Code Examples

### Example 1: Database Error

```csharp
public void LoadEmployees()
{
    try
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            // Code that might fail
            conn.Open();
            // ... database operations ...
        }
    }
    catch (SqlException ex)
    {
        // This will be caught by global handler and emailed
        throw new Exception($"Failed to load employees: {ex.Message}", ex);
    }
}
```

**What Gets Emailed:**
- Exception type: SqlException
- Message with context
- Full stack trace
- Inner exception: Original SQL error
- Request context: User, page, timestamp

---

### Example 2: File Operation Error

```csharp
public void ExportEmployeeData(string filePath)
{
    try
    {
        // Create file
        File.WriteAllLines(filePath, employeeData);
    }
    catch (UnauthorizedAccessException ex)
    {
        // Global handler will email this
        throw new Exception($"No permission to write to {filePath}", ex);
    }
    catch (IOException ex)
    {
        // Global handler will email this
        throw new Exception($"File operation failed for {filePath}", ex);
    }
}
```

---

### Example 3: API Integration Error

```csharp
public async Task SyncWithMiddleware()
{
    try
    {
        using (var client = new HttpClient())
        {
            var response = await client.PostAsync(apiUrl, content);
            response.EnsureSuccessStatusCode();
            // ... process response ...
        }
    }
    catch (HttpRequestException ex)
    {
        // Global handler will email this with full context
        throw new Exception("Middleware sync failed", ex);
    }
}
```

---

### Example 4: Custom Context

For additional context, throw with description:

```csharp
public void ProcessPayroll(int payrollId)
{
    try
    {
        // Code that might fail
        var payroll = GetPayroll(payrollId);
        
        if (payroll == null)
        {
            throw new InvalidOperationException($"Payroll {payrollId} not found");
        }
        
        // Process...
        CalculatePayroll(payroll);
    }
    catch (Exception ex)
    {
        // Email will include payroll ID, method, and full error
        throw;
    }
}
```

**Email Will Show:**
- Message: "Payroll 12345 not found"
- Location: ProcessPayroll method
- User who triggered it
- Form data if POST request

---

### Example 5: Logging Before Error

```csharp
public void CriticalOperation()
{
    Debug.WriteLine("Starting critical operation...");
    
    try
    {
        // Critical code
        PerformDatabaseOperation();
    }
    catch (Exception ex)
    {
        // Automatic reporting
        Debug.WriteLine($"Critical operation failed: {ex.Message}");
        
        // Global handler catches and emails
        throw;
    }
}
```

---

## What the Email Will Show

### For Database Errors:
```
? Error Details
?? Location: LoadEmployees (in Dashboard.aspx.cs)
? Time: 2024-01-15 14:30:45
? Error Type: SqlException
?? Message: Timeout expired. The timeout period elapsed...

??  Inner Exception
Type: SqlNullValueException
Message: Data is Null. This method or property...
```

### For File Errors:
```
? Error Details
?? Location: ExportEmployeeData
? Time: 2024-01-15 15:22:10
? Error Type: UnauthorizedAccessException
?? Message: No permission to write to C:\Reports\employees.csv

??  Application Context
?? Current User: domain\jsmith
?? IP Address: 192.168.1.100
???  Server: PROD-SERVER-01
```

### For API Errors:
```
? Error Details
?? Location: SyncWithMiddleware
? Error Type: HttpRequestException
?? Message: Middleware sync failed

??  Inner Exception
Type: HttpRequestException
Message: The server returned status code BadRequest (400)...
```

---

## Exception Handling Best Practices

### DO ?

```csharp
// Good: Provide context
try
{
    // Code
}
catch (Exception ex)
{
    throw new Exception($"Failed to process employee {employeeId}: {ex.Message}", ex);
}
```

```csharp
// Good: Let unhandled exceptions propagate
void LoadData()
{
    // If error occurs, global handler catches it
    database.Connect();
}
```

### DON'T ?

```csharp
// Bad: Swallowing exceptions
try
{
    // Code
}
catch (Exception ex)
{
    // Silent fail - no one knows about the error!
}
```

```csharp
// Bad: Generic catch without context
try
{
    // Code
}
catch (Exception ex)
{
    throw new Exception("An error occurred");
}
```

---

## Email Triggering Examples

### This Will Email ??

```csharp
// Unhandled exception
public void Page_Load()
{
    throw new Exception("Test"); // ? Email sent
}
```

```csharp
// In try/catch that rethrows
try
{
    BadMethod();
}
catch (Exception ex)
{
    throw; // ? Email sent
}
```

```csharp
// Wrapping exception with context
try
{
    database.Query();
}
catch (Exception ex)
{
    throw new Exception("Query failed", ex); // ? Email sent
}
```

### This WON'T Email ?

```csharp
// Caught and handled silently
try
{
    BadMethod();
}
catch (Exception ex)
{
    // Silent catch - no email
}
```

```csharp
// Logged but not thrown
try
{
    BadMethod();
}
catch (Exception ex)
{
    Debug.WriteLine(ex); // Logged but not emailed
}
```

---

## Debugging with Error Reports

### When You Get an Error Email

1. **Check the timestamp** - Is this recent?
2. **Check the location** - What function failed?
3. **Check the message** - What was the error?
4. **Check the stack trace** - Where exactly?
5. **Check the context** - Who, when, from where?
6. **Check form data** - What was being submitted?

### Reproduce the Error

Use the email information to reproduce:

```csharp
// From email:
// Location: EmployeeEnrollment.aspx
// User: jsmith
// Form: txtName="John", txtEmail="john@test.com"
// Error: NullReferenceException at line 350

// Steps to reproduce:
// 1. Login as jsmith
// 2. Go to Employee Enrollment
// 3. Enter Name: "John", Email: "john@test.com"
// 4. Click Save
// 5. Error occurs at line 350
```

---

## Integration Examples

### With Try-Catch-Finally

```csharp
public void ProcessData()
{
    try
    {
        LoadData();
        TransformData();
        SaveData();
    }
    catch (Exception ex)
    {
        // Global handler emails this
        throw;
    }
    finally
    {
        CleanupResources();
    }
}
```

### With Using Statement

```csharp
public void FileOperation()
{
    using (var reader = new StreamReader(filePath))
    {
        try
        {
            var data = reader.ReadToEnd();
            ProcessData(data);
        }
        catch (Exception ex)
        {
            // Global handler emails this
            throw;
        }
        // Reader automatically disposed
    }
}
```

### With Async/Await

```csharp
public async Task LoadDataAsync()
{
    try
    {
        var data = await FetchDataAsync();
        ProcessData(data);
    }
    catch (Exception ex)
    {
        // Global handler emails this (even in async)
        throw;
    }
}
```

---

## Testing Error Reporting

### Unit Test

```csharp
[TestMethod]
public void TestErrorReporting()
{
    try
    {
        // Trigger an error
        throw new Exception("Test error");
    }
    catch (Exception ex)
    {
        ErrorReporter.ReportError(ex, "TestErrorReporting");
        // Email should be received
    }
}
```

### Manual Test

```csharp
// Add to any page
protected void TestButton_Click(object sender, EventArgs e)
{
    throw new Exception("Manual test of error reporting system");
}
```

Then click the button and check email.

---

## Performance Considerations

### Email Sending is Async

Error emails are sent without blocking the request:
- Email sent on background thread
- User sees error immediately
- No performance impact

### For High-Volume Errors

If you get many errors:
1. Email system continues to work
2. Each error generates one email
3. Consider rate limiting if needed
4. Monitor for error patterns

---

## Build Status
? SUCCESSFUL

---

**You now have a complete understanding of the error reporting system!** ??
