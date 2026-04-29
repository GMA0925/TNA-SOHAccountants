# Pay Rates Implementation Guide

## Overview
This document provides a comprehensive guide to implementing hourly, weekly, and monthly pay rates in the TimeAttendance system.

## Database Changes

### Tables Modified/Created

#### 1. Employees Table (Modified)
Added three new columns:
- `HourlyRate` (DECIMAL(10, 2)) - NULL by default
- `WeeklyRate` (DECIMAL(10, 2)) - NULL by default
- `MonthlyRate` (DECIMAL(10, 2)) - NULL by default

```sql
ALTER TABLE Employees
ADD HourlyRate DECIMAL(10, 2) NULL,
    WeeklyRate DECIMAL(10, 2) NULL,
    MonthlyRate DECIMAL(10, 2) NULL;
```

#### 2. EmployeeRateHistory Table (New)
Tracks all rate changes for audit purposes:

```sql
CREATE TABLE EmployeeRateHistory (
    RateHistoryID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID NVARCHAR(50) NOT NULL,
    HourlyRate DECIMAL(10, 2) NULL,
    WeeklyRate DECIMAL(10, 2) NULL,
    MonthlyRate DECIMAL(10, 2) NULL,
    EffectiveDate DATETIME DEFAULT GETDATE(),
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_EmployeeRateHistory_EmployeeID 
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);
```

### Stored Procedures

#### 1. sp_GetEmployeeRates
Returns current rates for an employee:
```sql
EXEC sp_GetEmployeeRates @EmployeeID = 'EMP001'
```

#### 2. sp_UpdateEmployeeRates
Updates employee rates and logs history:
```sql
EXEC sp_UpdateEmployeeRates 
    @EmployeeID = 'EMP001',
    @HourlyRate = 25.50,
    @WeeklyRate = 1020.00,
    @MonthlyRate = 4420.00
```

#### 3. sp_GetEmployeeRateHistory
Retrieves rate history for an employee:
```sql
EXEC sp_GetEmployeeRateHistory @EmployeeID = 'EMP001', @NumberOfRecords = 10
```

### Views

#### vw_EmployeeWithRates
A convenient view combining employee data with rates:
```sql
SELECT * FROM vw_EmployeeWithRates WHERE EmployeeID = 'EMP001'
```

## Code Changes

### EmployeeEnrollment.aspx

#### New UI Elements Added:
1. **Pay Rates Section** - Styled section with three rate input fields
2. **Hourly Rate TextBox** - For hourly wage input
3. **Weekly Rate TextBox** - For weekly wage input
4. **Monthly Rate TextBox** - For monthly wage input
5. **GridView Columns** - Added three new columns to display rates

#### Styling:
- New `.rate-section` CSS class for visual distinction
- `.rate-info` class for helpful hints under inputs
- Blue-themed styling consistent with application design

### EmployeeEnrollment.aspx.cs

#### New Methods:

**1. ParseDecimal(string value)**
Safely parses string input to decimal:
```csharp
private decimal? ParseDecimal(string value)
{
    if (string.IsNullOrWhiteSpace(value))
        return null;
    
    if (decimal.TryParse(value, out decimal result))
        return result;
    
    return null;
}
```

**2. LogRateHistory(SqlConnection conn, string employeeId, decimal? hourlyRate, decimal? weeklyRate, decimal? monthlyRate)**
Logs rate changes to history table:
```csharp
private void LogRateHistory(SqlConnection conn, string employeeId, 
    decimal? hourlyRate, decimal? weeklyRate, decimal? monthlyRate)
{
    // Inserts record into EmployeeRateHistory
}
```

#### Modified Methods:

**1. btnSave_Click()**
- Now captures hourly, weekly, and monthly rates
- Parses decimal values safely
- Inserts rates into Employees table
- Logs rate history
- Updated success message

**2. ClearForm()**
- Clears three new rate TextBox controls

**3. LoadEmployees()**
- Now selects HourlyRate, WeeklyRate, MonthlyRate from database
- Displays rates in GridView with currency formatting

**4. gvEmployees_RowUpdating()**
- Maintains existing update functionality
- Ready for future rate editing capability

## Usage Examples

### Creating an Employee with Rates

```csharp
// User fills in form:
txtEmpId.Text = "EMP001"
txtName.Text = "John Smith"
txtDepartmentEnroll.SelectedValue = "1"
txtHourlyRate.Text = "25.50"
txtWeeklyRate.Text = "1020.00"
txtMonthlyRate.Text = "4420.00"

// Click Save
// System automatically:
// 1. Inserts employee with rates
// 2. Logs rate history
// 3. Shows success message
```

### Querying Rates

```csharp
// Get current rates
using (SqlCommand cmd = new SqlCommand("EXEC sp_GetEmployeeRates @EmployeeID", conn))
{
    cmd.Parameters.AddWithValue("@EmployeeID", "EMP001");
    // Returns: EmployeeID, NameSurname, HourlyRate, WeeklyRate, MonthlyRate, etc.
}

// Get rate history
using (SqlCommand cmd = new SqlCommand("EXEC sp_GetEmployeeRateHistory @EmployeeID", conn))
{
    cmd.Parameters.AddWithValue("@EmployeeID", "EMP001");
    // Returns last 10 rate changes
}
```

## Deployment Instructions

### Step 1: Database Setup
1. Open SQL Server Management Studio
2. Connect to your TimeAttendance database
3. Run the script: `01_Add_Pay_Rates_To_Employees.sql`
4. Verify all tables, stored procedures, and views are created

### Step 2: Code Update
1. Update your EmployeeEnrollment.aspx file with new rate input fields
2. Update EmployeeEnrollment.aspx.cs with new methods and modifications
3. Rebuild the solution
4. Verify no compilation errors

### Step 3: Testing
1. Create a new employee with rates
2. Verify rates appear in the employee grid
3. Check EmployeeRateHistory table for logged entries
4. Test rate calculations if implemented

## Data Validation

### Current Validations:
- Required fields: Employee ID, Name, Department
- Optional: Hourly, Weekly, Monthly rates (can be NULL)
- Rate TextBox type="Number" provides client-side validation
- Server-side ParseDecimal() validates decimal format

### Recommended Additional Validations:
```csharp
// Validate rate values are positive
if (hourlyRate.HasValue && hourlyRate.Value < 0)
    throw new InvalidOperationException("Rates cannot be negative");

// Validate rate consistency (optional business logic)
if (hourlyRate.HasValue && weeklyRate.HasValue)
{
    decimal expectedWeekly = hourlyRate.Value * 40; // 40-hour week
    if (Math.Abs(weeklyRate.Value - expectedWeekly) > 100) // Allow variance
        lblMessage.Text = "?? Weekly rate seems inconsistent with hourly rate";
}
```

## Calculations and Formulas

If implementing payroll calculations:

```
Weekly Rate = Hourly Rate × 40 hours
Monthly Rate = Hourly Rate × 173.33 hours (average per month)
Bi-weekly Rate = Hourly Rate × 80 hours
Annual Salary = Hourly Rate × 2080 hours
```

## Reporting Queries

### Get all employees with their current rates:
```sql
SELECT * FROM vw_EmployeeWithRates 
WHERE Status = 'Active'
ORDER BY DepartmentName, NameSurname;
```

### Find employees with no rates set:
```sql
SELECT EmployeeID, NameSurname, PayType
FROM Employees
WHERE (HourlyRate IS NULL OR WeeklyRate IS NULL OR MonthlyRate IS NULL)
AND IsActive = 1
ORDER BY NameSurname;
```

### Get rate change history for an employee:
```sql
EXEC sp_GetEmployeeRateHistory @EmployeeID = 'EMP001', @NumberOfRecords = 20;
```

### Calculate average rates by department:
```sql
SELECT 
    d.DepartmentName,
    AVG(e.HourlyRate) AS AvgHourlyRate,
    AVG(e.WeeklyRate) AS AvgWeeklyRate,
    AVG(e.MonthlyRate) AS AvgMonthlyRate,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.IsActive = 1
GROUP BY d.DepartmentID, d.DepartmentName
ORDER BY d.DepartmentName;
```

## Troubleshooting

### Rates not saving
1. Check that txtHourlyRate, txtWeeklyRate, txtMonthlyRate controls exist in ASPX
2. Verify protected field declarations in code-behind
3. Check SQL column names: HourlyRate, WeeklyRate, MonthlyRate
4. Review error message for validation issues

### Rates not displaying in GridView
1. Verify LoadEmployees() SELECT statement includes rate columns
2. Check that GridView has BoundField columns for rates
3. Verify DataFormatString="{0:C2}" for currency formatting
4. Check gvEmployees.DataBind() is called after data load

### History not logging
1. Verify EmployeeRateHistory table exists
2. Check foreign key constraint on EmployeeID
3. Ensure LogRateHistory() method is called in btnSave_Click()

## Future Enhancements

1. **Rate Editing**: Add ability to edit existing employee rates with effective date
2. **Rate Approval Workflow**: Add approval process for rate changes
3. **Payroll Integration**: Calculate pay based on rates and hours worked
4. **Rate Escalation**: Automatic annual or periodic rate increases
5. **Overtime Calculations**: Apply overtime multipliers to rates
6. **Shift Differentials**: Different rates for different shifts
7. **Reports**: Generate payroll and rate analysis reports
