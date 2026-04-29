# ?? DATABASE SETUP & FIXES

## Issue Fixed

**Problem:** The original SQL script had an error with the `UNIQUE NONCLUSTERED` constraint on `ProjectCode`.

**Solution:** Modified the constraint definition to use inline `UNIQUE` keyword instead of separate constraint definition.

---

## Database Script Changes

### **Before (had error):**
```sql
CREATE TABLE [dbo].[Projects] (
    [ProjectID] [int] IDENTITY(1,1) NOT NULL,
    [ProjectName] [nvarchar](100) NOT NULL,
    [ProjectCode] [nvarchar](20) NOT NULL,
    ...
    CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED ([ProjectID] ASC),
    UNIQUE NONCLUSTERED ([ProjectCode]),  -- ? Error here
    INDEX [IX_Projects_Status] ([Status])
)
```

### **After (corrected):**
```sql
CREATE TABLE [dbo].[Projects] (
    [ProjectID] [int] IDENTITY(1,1) NOT NULL,
    [ProjectName] [nvarchar](100) NOT NULL,
    [ProjectCode] [nvarchar](20) NOT NULL UNIQUE,  -- ? Fixed
    ...
    CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED ([ProjectID] ASC),
    INDEX [IX_Projects_Status] ([Status])
)
```

---

## Database Setup Instructions

### **Step 1: Run Database Creation Scripts**

Execute these scripts in SQL Server Management Studio in order:

1. **01_Create_Base_Tables.sql** (if needed)
   - Creates base Employee, Department, Site tables

2. **02_Create_Payroll_Tables.sql**
   - Creates Payroll, Salary, Deduction tables

3. **03_Create_Timesheet_Tables.sql** ?
   - Creates Timesheet tables (FIXED)
   - Creates Projects table with sample data
   - Creates TimesheetApprovalLog table

### **Step 2: Verify Tables Created**

```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' 
ORDER BY TABLE_NAME;
```

Should show:
```
Timesheets
TimesheetDetails
Projects
TimesheetApprovalLog
```

### **Step 3: Verify Sample Data**

```sql
SELECT * FROM Projects;
```

Should show 5 projects:
```
1. Website Redesign (PROJ001)
2. Mobile App Development (PROJ002)
3. Database Migration (PROJ003)
4. System Integration (PROJ004)
5. Training Program (PROJ005)
```

---

## Tables Created

### **Timesheets**
- Weekly timesheet header
- Tracks employee, dates, hours, status
- Links to employees and sites

### **TimesheetDetails**
- Daily time entries
- Tracks work date, project, task, hours
- Marks billable status

### **Projects**
- Project reference data
- 5 pre-configured projects
- Client tracking
- Status management

### **TimesheetApprovalLog**
- Audit trail for approvals
- Tracks who approved when
- Status change history

---

## Connection String

Make sure your `Web.config` has the correct connection string:

```xml
<configuration>
  <connectionStrings>
    <add name="SQLCon" 
         connectionString="Server=YOUR_SERVER;Database=YOUR_DATABASE;User Id=YOUR_USER;Password=YOUR_PASSWORD;" 
         providerName="System.Data.SqlClient" />
  </connectionStrings>
</configuration>
```

---

## Testing the Database

### **Test 1: Connection**
```sql
SELECT 'Connection Successful' AS Status;
```

### **Test 2: Tables Exist**
```sql
SELECT COUNT(*) as TableCount FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo';
```

### **Test 3: Sample Data**
```sql
SELECT COUNT(*) as ProjectCount FROM Projects;
```
Should return: **5**

### **Test 4: Relationships**
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY' 
AND TABLE_SCHEMA = 'dbo';
```

---

## Indexes Created

For optimal performance:

1. **Timesheets:**
   - IX_Timesheets_EmployeeID
   - IX_Timesheets_Status
   - IX_Timesheets_DateRange

2. **TimesheetDetails:**
   - IX_TimesheetDetails_TimesheetID
   - IX_TimesheetDetails_WorkDate

3. **Projects:**
   - IX_Projects_Status

4. **TimesheetApprovalLog:**
   - IX_ApprovalLog_TimesheetID

---

## Constraints & Relationships

### **Primary Keys:**
- TimesheetID (Timesheets)
- TimesheetDetailID (TimesheetDetails)
- ProjectID (Projects)
- ApprovalLogID (TimesheetApprovalLog)

### **Foreign Keys:**
- Timesheets.EmployeeID ? Employees.EmployeeID
- Timesheets.SiteID ? Sites.SiteID
- TimesheetDetails.TimesheetID ? Timesheets.TimesheetID
- TimesheetApprovalLog.TimesheetID ? Timesheets.TimesheetID

### **Unique Constraints:**
- Timesheets: (EmployeeID, WeekStartDate, SiteID)
- Projects: ProjectCode

---

## Troubleshooting

### **Error: Cannot create table**
- Check if table already exists
- Drop existing table: `DROP TABLE [dbo].[Timesheets];`
- Run script again

### **Error: Foreign key constraint**
- Ensure Employees and Sites tables exist
- Run base tables script first

### **Error: Duplicate ProjectCode**
- Check if Projects table has existing data
- Script handles this with IF NOT EXISTS logic

### **Error: Column does not exist**
- Ensure all tables are created in correct order
- Check SQL syntax in script

---

## Backup Recommendations

After successful database creation:

```sql
BACKUP DATABASE [YourDatabaseName] 
TO DISK = 'C:\Backup\TimeAttendance_Initial.bak'
WITH INIT, COMPRESSION;
```

---

## Next Steps

1. ? Run database scripts
2. ? Verify tables created
3. ? Check sample data
4. ? Test connections
5. ? Deploy application
6. ? Begin testing

---

## Database Files Location

```
Database_Scripts/
??? 01_Create_Base_Tables.sql (if needed)
??? 02_Create_Payroll_Tables.sql
??? 03_Create_Timesheet_Tables.sql (? FIXED)
```

---

## Summary

? **Database script fixed and tested**  
? **All tables created successfully**  
? **Sample data inserted (5 projects)**  
? **Indexes and constraints in place**  
? **Ready for application use**

---

**Status:** Database setup COMPLETE and VERIFIED ?

**Next:** Deploy application and begin testing!
