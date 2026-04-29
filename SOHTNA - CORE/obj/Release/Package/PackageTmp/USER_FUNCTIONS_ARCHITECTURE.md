# User Functions Data Flow & Architecture

## Session Flow

```
Login.aspx
    ?
[User enters credentials]
    ?
Query: SELECT UserID, Role, SiteId, NameSurname FROM Users
    ?
[Validate SiteId - must be alphanumeric like 'BH001']
    ?
[Set Session variables]
    - Session["UserID"] = UserID (string)
    - Session["Username"] = Username
    - Session["Role"] = Role
    - Session["SiteId"] = SiteId (string)
    - Session["NameSurname"] = NameSurname
    - Session.Timeout = 30 minutes
    ?
Redirect to Dashboard.aspx
```

---

## User Page Architecture

```
User Page Structure
??? Page_Load()
?   ??? Check Session["Username"] - if null, redirect to Login
?   ??? If not IsPostBack:
?   ?   ??? Display Assembly Version
?   ?   ??? Load data from database
?   ?   ??? Bind to GridView/Labels
?   ??? Return
??? GetEmployeeId() ? returns Session["UserID"] as string
??? GetSiteId() ? returns Session["SiteId"] as string
??? LoadData Methods (execute on Page_Load)
?   ??? LoadEmployees()
?   ??? LoadLeaveTypes()
?   ??? LoadProjects()
?   ??? etc.
??? Event Handlers (btnSave_Click, btnSubmit_Click, etc.)
?   ??? Validate input
?   ??? Get UserID and SiteId
?   ??? Execute database operations
?   ??? Show success/error message
??? Helper Methods
    ??? ShowMessage(message, type)
    ??? CalculateTotals()
    ??? etc.
```

---

## Database Query Patterns

### Standard Select with Filters
```csharp
string query = @"
    SELECT * FROM Table
    WHERE EmployeeID = @EmployeeID
    AND SiteID = @SiteID
    AND Date BETWEEN @StartDate AND @EndDate
    ORDER BY Date DESC";

SqlCommand cmd = new SqlCommand(query, conn);
cmd.Parameters.AddWithValue("@EmployeeID", empId);      // string
cmd.Parameters.AddWithValue("@SiteID", siteId);         // string
cmd.Parameters.AddWithValue("@StartDate", startDate);   // DateTime
cmd.Parameters.AddWithValue("@EndDate", endDate);       // DateTime
```

### Insert with Generated ID
```csharp
string query = @"
    INSERT INTO Table (EmployeeID, SiteID, Description, CreatedDate)
    VALUES (@EmployeeID, @SiteID, @Description, GETDATE())";

SqlCommand cmd = new SqlCommand(query, conn);
cmd.Parameters.AddWithValue("@EmployeeID", empId);      // string
cmd.Parameters.AddWithValue("@SiteID", siteId);         // string
cmd.Parameters.AddWithValue("@Description", description); // string
```

### Update with Validation
```csharp
string query = @"
    UPDATE Table
    SET Column1 = @Value1,
        ModifiedDate = GETDATE()
    WHERE ID = @ID
    AND EmployeeID = @EmployeeID";  // Security: Only update own records

SqlCommand cmd = new SqlCommand(query, conn);
cmd.Parameters.AddWithValue("@Value1", value1);
cmd.Parameters.AddWithValue("@ID", id);
cmd.Parameters.AddWithValue("@EmployeeID", empId);  // Prevent access to others' data
```

---

## Common Method Patterns

### Load Data Method
```csharp
private void LoadData()
{
    try
    {
        string empId = GetEmployeeId();
        string siteId = GetSiteId();
        
        using (SqlConnection conn = new SqlConnection(_connStr))
        {
            string query = @"SELECT * FROM Table WHERE EmployeeID = @EmpID";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@EmpID", empId);
            
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            
            gvGrid.DataSource = dt;
            gvGrid.DataBind();
        }
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
        ShowMessage($"Error loading data: {ex.Message}", "error");
    }
}
```

### Submit/Save Method
```csharp
protected void btnSubmit_Click(object sender, EventArgs e)
{
    try
    {
        // 1. Validate input
        if (string.IsNullOrEmpty(txtInput.Text))
        {
            ShowMessage("Please enter required field", "warning");
            return;
        }
        
        // 2. Get user context
        string empId = GetEmployeeId();
        string siteId = GetSiteId();
        
        // 3. Execute database operation
        using (SqlConnection conn = new SqlConnection(_connStr))
        {
            string query = @"INSERT INTO Table (...) VALUES (...)";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@EmployeeID", empId);
            cmd.Parameters.AddWithValue("@SiteID", siteId);
            
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        
        // 4. Provide feedback
        ShowMessage("Operation completed successfully", "success");
        
        // 5. Reload data
        LoadData();
        ClearForm();
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
        ShowMessage($"Error: {ex.Message}", "error");
    }
}
```

### Message Display Method
```csharp
private void ShowMessage(string message, string type)
{
    lblMessage.Text = message;
    lblMessage.CssClass = $"{type}-message";  // CSS: error-message, warning-message, success-message
    lblMessage.Visible = true;
}
```

---

## User Access Control

### Role-Based Pages
- **User Role**: 
  - MyClockEvents ?
  - LeaveRequest ?
  - LeaveBalance ?
  - LeaveHistory ?
  - TimesheetEntry ?
  - TimesheetHistory ?
  - EmployeeProfile ?
  - EmployeePayslips ?
  - AttendanceTracking ?
  - EmployeeSettings ?
  - NotificationSettings ?

- **Manager Role**: Above + Approval pages
- **Admin Role**: Full access to all pages

### Data Access Control Pattern
```csharp
protected void Page_Load(object sender, EventArgs e)
{
    if (Session["Username"] == null)
    {
        Response.Redirect("Login.aspx");
        return;
    }
    
    // Optional: Check role
    string role = Session["Role"]?.ToString();
    if (role != "Admin" && role != "Manager")
    {
        Response.Redirect("Dashboard.aspx");
        return;
    }
}

// Only access own records
private void LoadData()
{
    string empId = GetEmployeeId();  // Current user's ID
    
    // Query filters by empId - can't access others' data
    string query = "SELECT * FROM Table WHERE EmployeeID = @EmpID";
}
```

---

## Error Handling Pattern

```
User Action
    ?
Try Block
    ?? Input Validation
    ?? Get Session Data
    ?? Database Operation
    ?? Success ? Show success message & reload data
    ?
Exception Caught
    ?? Log to Debug Output
    ?? Show user-friendly error message
    ?? Prevent data loss
```

---

## Session Timeout Handling

```
Session Set (Page_Load in Login.aspx)
    ?
Session.Timeout = 30  // 30 minutes
    ?
[User navigates pages]
    ?
Each Page Check: if (Session["Username"] == null)
    ?? YES: Redirect to Login.aspx
    ?? NO: Continue normally
    ?
[30 minutes inactivity]
    ?
Session expires
    ?
Next page load
    ?
Session["Username"] is NULL
    ?
Redirect to Login.aspx
```

---

## Key Technical Details

### Parameter Safety
All queries use parameterized queries with `SqlCommand.Parameters.AddWithValue()` to prevent SQL injection.

### Resource Management  
All database connections use `using` statements to ensure proper disposal:
```csharp
using (SqlConnection conn = new SqlConnection(_connStr))
{
    // Connection automatically closed and disposed
}
```

### Data Type Consistency
- **UserID**: String (from Users.UserID)
- **SiteID**: String (alphanumeric like 'BH001')
- **Dates**: DateTime
- **Numbers**: Decimal (for money), Int (for counts)
- **Flags**: Int (0=false, 1=true) or Boolean

### Debug Output
All errors logged to Visual Studio Output window:
```csharp
System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
```

---

## Performance Considerations

1. **DataAdapter Pattern**: Used for batch loading data into DataTable
   - Efficient for displaying multiple rows
   - GridView binding automatic

2. **Index Requirements**: Ensure database indexes on:
   - `Users.Username` (Login lookup)
   - `Employees.EmployeeID` (User data access)
   - `Employees.SiteID` (Site filtering)
   - Tables with EmployeeID and dates (TimeRange queries)

3. **Query Optimization**: All queries include:
   - WHERE clauses to filter data
   - ORDER BY for sorted display
   - INNER/LEFT JOINs only when necessary

---

## Common Debugging

### Page Loads Blank
- Check Session["Username"] - may be null
- Check assembly version display
- Verify database connection string
- Check for exceptions in try-catch blocks

### Data Not Displaying
- Verify table joins are correct
- Check WHERE clause parameters
- Ensure GridView.DataBind() is called
- Check if GridView has columns defined

### Save Not Working
- Verify all required fields are entered
- Check database table structure
- Review SQL syntax in INSERT/UPDATE statements
- Check parameter types match database columns

### Session Issues
- Verify Login.aspx sets all required session variables
- Check session timeout setting
- Verify each page checks Session["Username"] in Page_Load
- Check browser cookie settings allow sessions

