using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace TimeAttendance.WebForms
{
    public partial class EmployeeSelfService
    {
        private string _connStr = Properties.Settings.Default.SQLCon;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Display Assembly Version
                System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
                System.Reflection.AssemblyName assemblyName = assembly.GetName();
                lblVersion.Text = string.Format("v{0}", assemblyName.Version.ToString());

                LoadEmployeeData();
                LoadDashboardStats();
                LoadRecentActivity();
            }
        }

        private int GetEmployeeId()
        {
            string userIdStr = Session["EmployeeID"]?.ToString();
            if (string.IsNullOrWhiteSpace(userIdStr) || !int.TryParse(userIdStr, out int empId))
            {
                throw new InvalidOperationException("Employee ID not found in session.");
            }
            return empId;
        }

        private void LoadEmployeeData()
        {
            try
            {
                int empId = GetEmployeeId();

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT e.EmployeeID, e.NameSurname, e.Email, e.Phone, e.DateOfJoin, e.Position,
                               d.DepartmentName, m.NameSurname as ManagerName
                        FROM Employees e
                        LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
                        LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
                        WHERE e.EmployeeID = @EmployeeID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@EmployeeID", empId);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Welcome section
                            lblEmployeeName.Text = reader["NameSurname"].ToString();
                            lblEmployeeID.Text = reader["EmployeeID"].ToString();
                            lblDepartment.Text = reader["DepartmentName"] != DBNull.Value ? reader["DepartmentName"].ToString() : "N/A";

                            // Employee Information section
                            lblEmpID.Text = reader["EmployeeID"].ToString();
                            lblFullName.Text = reader["NameSurname"].ToString();
                            lblDeptName.Text = reader["DepartmentName"] != DBNull.Value ? reader["DepartmentName"].ToString() : "N/A";
                            lblPosition.Text = reader["Position"] != DBNull.Value ? reader["Position"].ToString() : "N/A";
                            lblEmail.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : "N/A";
                            lblPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "N/A";
                            
                            if (reader["DateOfJoin"] != DBNull.Value)
                            {
                                DateTime joinDate = Convert.ToDateTime(reader["DateOfJoin"]);
                                lblStartDate.Text = joinDate.ToString("yyyy-MM-dd");
                            }
                            else
                            {
                                lblStartDate.Text = "N/A";
                            }

                            lblManager.Text = reader["ManagerName"] != DBNull.Value ? reader["ManagerName"].ToString() : "N/A";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading employee data: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        private void LoadDashboardStats()
        {
            try
            {
                int empId = GetEmployeeId();
                int currentYear = DateTime.Now.Year;
                int currentMonth = DateTime.Now.Month;

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    // Get today's attendance
                    string attendanceQuery = "SELECT Status FROM Attendance WHERE EmployeeID = @EmpID AND CAST(AttendanceDate AS DATE) = CAST(GETDATE() AS DATE)";
                    SqlCommand attendanceCmd = new SqlCommand(attendanceQuery, conn);
                    attendanceCmd.Parameters.AddWithValue("@EmpID", empId);
                    
                    conn.Open();
                    object attendanceResult = attendanceCmd.ExecuteScalar();
                    lblTodayStatus.Text = attendanceResult != null ? attendanceResult.ToString() : "Not Marked";
                    conn.Close();

                    // Get leave balance
                    string leaveQuery = @"
                        SELECT SUM(BalanceDays) as TotalBalance
                        FROM LeaveBalance
                        WHERE EmployeeID = @EmpID AND Year = @Year";
                    
                    SqlCommand leaveCmd = new SqlCommand(leaveQuery, conn);
                    leaveCmd.Parameters.AddWithValue("@EmpID", empId);
                    leaveCmd.Parameters.AddWithValue("@Year", currentYear);
                    
                    conn.Open();
                    object leaveResult = leaveCmd.ExecuteScalar();
                    decimal leaveBalance = leaveResult != DBNull.Value ? Convert.ToDecimal(leaveResult) : 0;
                    lblLeaveBalance.Text = leaveBalance.ToString("0");
                    conn.Close();

                    // Get this month's hours
                    string hoursQuery = @"
                        SELECT SUM(TotalHours) as TotalHours
                        FROM Timesheets
                        WHERE EmployeeID = @EmpID 
                        AND YEAR(WeekStartDate) = @Year
                        AND MONTH(WeekStartDate) = @Month";
                    
                    SqlCommand hoursCmd = new SqlCommand(hoursQuery, conn);
                    hoursCmd.Parameters.AddWithValue("@EmpID", empId);
                    hoursCmd.Parameters.AddWithValue("@Year", currentYear);
                    hoursCmd.Parameters.AddWithValue("@Month", currentMonth);
                    
                    conn.Open();
                    object hoursResult = hoursCmd.ExecuteScalar();
                    decimal totalHours = hoursResult != DBNull.Value ? Convert.ToDecimal(hoursResult) : 0;
                    lblMonthHours.Text = totalHours.ToString("0.0");
                    conn.Close();

                    // Get pending approvals (leave + timesheet)
                    string pendingQuery = @"
                        SELECT 
                            (SELECT COUNT(*) FROM LeaveRequests WHERE EmployeeID = @EmpID AND Status = 'Pending') +
                            (SELECT COUNT(*) FROM Timesheets WHERE EmployeeID = @EmpID AND Status = 'Submitted') as PendingCount";
                    
                    SqlCommand pendingCmd = new SqlCommand(pendingQuery, conn);
                    pendingCmd.Parameters.AddWithValue("@EmpID", empId);
                    
                    conn.Open();
                    object pendingResult = pendingCmd.ExecuteScalar();
                    int pendingCount = pendingResult != DBNull.Value ? Convert.ToInt32(pendingResult) : 0;
                    lblPendingApprovals.Text = pendingCount.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading dashboard stats: {ex.Message}");
            }
        }

        private void LoadRecentActivity()
        {
            try
            {
                int empId = GetEmployeeId();

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    // Combine multiple activities
                    string query = @"
                        (SELECT 'Leave Request' as ActivityType, CreatedDate as ActivityDate, CONCAT(Status, ' - ', CONCAT(NumberOfDays, ' days')) as Description, Status
                         FROM LeaveRequests WHERE EmployeeID = @EmpID)
                        UNION ALL
                        (SELECT 'Timesheet' as ActivityType, SubmittedDate as ActivityDate, CONCAT('Week of ', FORMAT(WeekStartDate, 'MMM dd')) as Description, Status
                         FROM Timesheets WHERE EmployeeID = @EmpID AND SubmittedDate IS NOT NULL)
                        UNION ALL
                        (SELECT 'Attendance' as ActivityType, AttendanceDate as ActivityDate, Status as Description, Status
                         FROM Attendance WHERE EmployeeID = @EmpID)
                        ORDER BY ActivityDate DESC
                        OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@EmpID", empId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvRecentActivity.DataSource = dt;
                    gvRecentActivity.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading recent activity: {ex.Message}");
            }
        }

        #region Navigation

        protected void btnHome_Click(object sender, EventArgs e) => Response.Redirect("EmployeeSelfService.aspx");
        protected void btnProfile_Click(object sender, EventArgs e) => Response.Redirect("EmployeeProfile.aspx");
        protected void btnPayslip_Click(object sender, EventArgs e) => Response.Redirect("EmployeePayslips.aspx");
        protected void btnDocuments_Click(object sender, EventArgs e) => Response.Redirect("EmployeeDocuments.aspx");
        protected void btnSettings_Click(object sender, EventArgs e) => Response.Redirect("EmployeeSettings.aspx");

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        #endregion

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"{type}-message";
            lblMessage.Visible = true;
        }
    }
}
