# Database Tables Reference - Payroll System

## Overview
This document describes all the database tables created for the Payroll Management System (Section 1).

---

## Table Structures

### 1. **Payroll** (Master Payroll Table)
**Purpose:** Stores calculated payroll records for employees

| Column | Type | Description |
|--------|------|-------------|
| PayrollID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| SiteID | int (FK) | Reference to Sites table |
| PayPeriodStartDate | datetime | Start of pay period |
| PayPeriodEndDate | datetime | End of pay period |
| BasicSalary | decimal(10,2) | Base salary for period |
| GrossPay | decimal(10,2) | Gross pay (Basic + Allowances + Overtime) |
| TotalDeductions | decimal(10,2) | Total deductions (Tax, Loans, etc.) |
| NetPay | decimal(10,2) | Net pay (Gross - Deductions) |
| Status | nvarchar(50) | Draft, Calculated, Approved, Paid |
| PaymentDate | datetime | Date of payment |
| PaymentMethod | nvarchar(50) | Bank Transfer, Cash, Cheque |
| CreatedDate | datetime | Record creation date |
| ModifiedDate | datetime | Last modification date |
| CreatedBy | int | User ID who created record |
| ModifiedBy | int | User ID who last modified |
| Remarks | nvarchar(max) | Additional notes |

**Indexes:**
- PK: PayrollID
- IX_Payroll_EmployeeID (for quick employee lookup)
- IX_Payroll_SiteID (for site-level reports)
- IX_Payroll_PayPeriod (for date range queries)

---

### 2. **PayrollDetails** (Line Items)
**Purpose:** Stores individual components of payroll (allowances, deductions, etc.)

| Column | Type | Description |
|--------|------|-------------|
| PayrollDetailID | int (PK) | Unique identifier |
| PayrollID | int (FK) | Reference to Payroll table |
| ComponentType | nvarchar(50) | 'Allowance', 'Deduction', 'Overtime', 'Attendance' |
| ComponentName | nvarchar(100) | e.g., 'House Allowance', 'Income Tax' |
| Amount | decimal(10,2) | Component amount |
| Rate | decimal(10,4) | Rate used (for calculations) |
| Hours | decimal(10,2) | Hours worked (for overtime/attendance) |
| Description | nvarchar(max) | Details about this component |
| CreatedDate | datetime | Record creation date |

**Indexes:**
- PK: PayrollDetailID
- FK: PayrollID (for quick detail lookup)
- IX_PayrollDetails_ComponentType (for filtering)

---

### 3. **Deductions** (Employee Deductions Master)
**Purpose:** Defines recurring deductions for employees

| Column | Type | Description |
|--------|------|-------------|
| DeductionID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| DeductionType | nvarchar(50) | Tax, Loan, Insurance, Other |
| DeductionName | nvarchar(100) | e.g., 'Income Tax', 'Vehicle Loan' |
| Amount | decimal(10,2) | Fixed amount per payroll |
| PercentageOfSalary | decimal(5,2) | Percentage deduction (alternative to Amount) |
| EffectiveFromDate | datetime | Start date of deduction |
| EffectiveToDate | datetime | End date (NULL = ongoing) |
| IsActive | bit | 1 = Active, 0 = Inactive |
| CreatedDate | datetime | Record creation date |
| ModifiedDate | datetime | Last modification date |

**Indexes:**
- PK: DeductionID
- FK: EmployeeID
- IX_Deductions_IsActive (for filtering active deductions)

---

### 4. **Allowances** (Employee Allowances Master)
**Purpose:** Defines recurring allowances for employees

| Column | Type | Description |
|--------|------|-------------|
| AllowanceID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| AllowanceType | nvarchar(50) | House, Transport, Medical, Other |
| AllowanceName | nvarchar(100) | e.g., 'House Allowance', 'Travel Allowance' |
| Amount | decimal(10,2) | Fixed amount per payroll |
| PercentageOfSalary | decimal(5,2) | Percentage allowance (alternative to Amount) |
| EffectiveFromDate | datetime | Start date of allowance |
| EffectiveToDate | datetime | End date (NULL = ongoing) |
| IsActive | bit | 1 = Active, 0 = Inactive |
| CreatedDate | datetime | Record creation date |
| ModifiedDate | datetime | Last modification date |

**Indexes:**
- PK: AllowanceID
- FK: EmployeeID
- IX_Allowances_IsActive

---

### 5. **OvertimeRates** (Overtime Multipliers)
**Purpose:** Defines overtime payment rates by type and department

| Column | Type | Description |
|--------|------|-------------|
| OvertimeRateID | int (PK) | Unique identifier |
| DepartmentID | int (FK) | Reference to Departments (optional) |
| OvertimeType | nvarchar(50) | Standard, Holiday, Weekend |
| Multiplier | decimal(3,2) | Payment multiplier (1.5, 2.0, etc.) |
| EffectiveFromDate | datetime | Start date of rate |
| EffectiveToDate | datetime | End date (NULL = ongoing) |
| IsActive | bit | 1 = Active, 0 = Inactive |
| CreatedDate | datetime | Record creation date |
| ModifiedDate | datetime | Last modification date |

**Indexes:**
- PK: OvertimeRateID
- FK: DepartmentID
- IX_OvertimeRates_IsActive

---

### 6. **LeaveTypes** (Leave Type Master)
**Purpose:** Defines types of leave available in the organization

| Column | Type | Description |
|--------|------|-------------|
| LeaveTypeID | int (PK) | Unique identifier |
| LeaveTypeName | nvarchar(50) | Annual, Sick, Casual, Unpaid, Maternity, etc. |
| DaysPerYear | int | Number of days allocated per year |
| IsPaid | bit | 1 = Paid leave, 0 = Unpaid leave |
| Description | nvarchar(max) | Leave type description |
| IsActive | bit | 1 = Active, 0 = Inactive |
| CreatedDate | datetime | Record creation date |

**Indexes:**
- PK: LeaveTypeID
- UNIQUE: LeaveTypeName

**Default Records:**
- Annual (21 days, Paid)
- Sick (10 days, Paid)
- Casual (5 days, Paid)
- Unpaid (0 days, Unpaid)
- Maternity (120 days, Paid)
- Paternity (5 days, Paid)

---

### 7. **LeaveBalance** (Employee Leave Balance)
**Purpose:** Tracks leave balance for each employee per year

| Column | Type | Description |
|--------|------|-------------|
| LeaveBalanceID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| LeaveTypeID | int (FK) | Reference to LeaveTypes table |
| Year | int | Calendar year |
| TotalDays | decimal(10,2) | Days allocated for the year |
| UsedDays | decimal(10,2) | Days already used |
| BalanceDays | decimal(10,2) | Remaining days (TotalDays - UsedDays) |
| LastUpdated | datetime | Last update timestamp |

**Indexes:**
- PK: LeaveBalanceID
- UNIQUE: (EmployeeID, LeaveTypeID, Year)
- FK: EmployeeID

---

### 8. **LeaveRequests** (Leave Request Workflow)
**Purpose:** Tracks employee leave requests and approvals

| Column | Type | Description |
|--------|------|-------------|
| LeaveRequestID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| LeaveTypeID | int (FK) | Reference to LeaveTypes table |
| StartDate | datetime | First day of leave |
| EndDate | datetime | Last day of leave |
| NumberOfDays | decimal(10,2) | Total leave days requested |
| Reason | nvarchar(max) | Reason for leave |
| Status | nvarchar(50) | Pending, Approved, Rejected, Cancelled |
| ApprovedBy | int (FK) | Employee ID of approver |
| ApprovedDate | datetime | Date of approval |
| RejectionReason | nvarchar(max) | Reason for rejection (if applicable) |
| CreatedDate | datetime | Request creation date |
| ModifiedDate | datetime | Last modification date |

**Indexes:**
- PK: LeaveRequestID
- FK: EmployeeID
- FK: LeaveTypeID
- FK: ApprovedBy
- IX_LeaveRequests_Status
- IX_LeaveRequests_DateRange

---

### 9. **Attendance** (Daily Attendance)
**Purpose:** Tracks daily attendance and working hours

| Column | Type | Description |
|--------|------|-------------|
| AttendanceID | int (PK) | Unique identifier |
| EmployeeID | int (FK) | Reference to Employees table |
| SiteID | int (FK) | Reference to Sites table |
| AttendanceDate | date | Date of attendance |
| Status | nvarchar(50) | Present, Absent, Leave, Holiday, LatePresent |
| TimeIn | datetime | Clock in time |
| TimeOut | datetime | Clock out time |
| HoursWorked | decimal(10,2) | Total hours worked in day |
| IsLate | bit | 1 = Late arrival |
| LateMinutes | int | Number of minutes late |
| Remarks | nvarchar(max) | Additional notes |
| CreatedDate | datetime | Record creation date |
| ModifiedDate | datetime | Last modification date |

**Indexes:**
- PK: AttendanceID
- UNIQUE: (EmployeeID, AttendanceDate)
- FK: EmployeeID
- IX_Attendance_Date
- IX_Attendance_Status

---

## Key Relationships

### Master Data Flow:
```
Employees (with HourlyRate, MonthlyRate, PayType)
    ??? Allowances (recurring allowances)
    ??? Deductions (recurring deductions)
    ??? Attendance (daily time tracking)
    ??? Payroll (calculated pay records)
            ??? PayrollDetails (pay components)

Departments
    ??? OvertimeRates (overtime multipliers)

LeaveTypes
    ??? LeaveBalance (employee balance per year)
    ??? LeaveRequests (leave workflow)
```

---

## SQL Queries Examples

### Get Employee Payroll for a Period:
```sql
SELECT p.PayrollID, e.NameSurname, p.BasicSalary, p.GrossPay, p.NetPay, p.Status
FROM Payroll p
INNER JOIN Employees e ON p.EmployeeID = e.EmployeeID
WHERE p.PayPeriodStartDate >= '2024-01-01' 
  AND p.PayPeriodEndDate <= '2024-01-31'
ORDER BY e.NameSurname
```

### Get Active Allowances for Employee:
```sql
SELECT AllowanceName, Amount
FROM Allowances
WHERE EmployeeID = 1 
  AND IsActive = 1
  AND EffectiveFromDate <= GETDATE()
  AND (EffectiveToDate IS NULL OR EffectiveToDate >= GETDATE())
```

### Check Leave Balance:
```sql
SELECT e.NameSurname, lt.LeaveTypeName, lb.TotalDays, lb.UsedDays, lb.BalanceDays
FROM LeaveBalance lb
INNER JOIN Employees e ON lb.EmployeeID = e.EmployeeID
INNER JOIN LeaveTypes lt ON lb.LeaveTypeID = lt.LeaveTypeID
WHERE YEAR(lb.LastUpdated) = YEAR(GETDATE())
  AND lb.EmployeeID = 1
```

### Get Hours Worked:
```sql
SELECT EmployeeID, SUM(HoursWorked) as TotalHours
FROM Attendance
WHERE AttendanceDate BETWEEN '2024-01-01' AND '2024-01-31'
  AND Status = 'Present'
GROUP BY EmployeeID
```

---

## Constraints & Validations

- **Payroll.StartDate < Payroll.EndDate** (checked in application)
- **Attendance.TimeIn < Attendance.TimeOut** (checked in application)
- **Attendance.AttendanceDate must be date only** (no time component)
- **LeaveRequest.StartDate <= LeaveRequest.EndDate** (checked in application)
- **All amounts are decimal(10,2)** for consistency and precision

---

## Performance Considerations

- Indexes on foreign keys for fast joins
- Indexes on date columns for range queries
- Index on Status fields for filtering
- Unique constraints prevent duplicate records
- SiteID columns enable multi-tenant queries

---

## Backup Recommendations

Backup the following tables regularly:
1. Payroll (most important)
2. PayrollDetails
3. Attendance
4. LeaveRequests

These contain transactional data that should be preserved.

---

**Database schema successfully implemented!** ?
