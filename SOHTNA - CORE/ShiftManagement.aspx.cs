using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace TimeAttendance.WebForms
{
    // System.Web.UI.Page is not available in .NET 8.0 and there is no direct replacement in ASP.NET Core. You must migrate this code to ASP.NET Core MVC or Razor Pages for compatibility.
    // For now, comment out the inheritance to resolve the compilation error, but the page will not function as expected until a full migration is performed.
    public partial class ShiftManagement
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Validate SiteId is available
            string userSiteId = Session["SiteId"]?.ToString();
            if (string.IsNullOrEmpty(userSiteId))
            {
                System.Diagnostics.Debug.WriteLine($"Session lost for user: {Session["Username"]}. SiteId is null.");
                Session.Clear();
                Session.Abandon();
                Response.Redirect("Login.aspx?msg=SessionLost", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    // Display Assembly Version
                    System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
                    System.Reflection.AssemblyName assemblyName = assembly.GetName();
                    lblVersion.Text = string.Format("v{0}", assemblyName.Version.ToString());

                    BindDepartments();
                    BindDepartmentsForShift();
                    BindShifts();

                    // Set sample default times for shift creation (HH:mm only)
                    txtStartTime.Text = "08:00";
                    txtEndTime.Text = "17:00";
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Page_Load error: {ex.Message}");
                    Response.Redirect("Login.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
        }

        protected void gvDepartments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvDepartments, "Select$" + e.Row.RowIndex);
                e.Row.Style["cursor"] = "pointer";

                if (e.Row.RowIndex == gvDepartments.SelectedIndex)
                {
                    e.Row.CssClass = "selected-row";
                }
            }
        }

        protected void gvDepartments_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvDepartments.SelectedRow;
            if (row != null)
            {
                try
                {
                    string deptId = gvDepartments.SelectedDataKey.Value.ToString();

                    string connStr = Properties.Settings.Default.SQLCon;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT DepartmentName, PayType, Description FROM Departments WHERE DepartmentID = @DepartmentID";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@DepartmentID", deptId);
                            conn.Open();

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    txtDeptName.Text = reader["DepartmentName"].ToString();

                                    string payType = reader["PayType"].ToString();
                                    if (!string.IsNullOrEmpty(payType))
                                    {
                                        ddlDeptPayType.SelectedValue = payType;
                                    }
                                    else
                                    {
                                        ddlDeptPayType.SelectedValue = "";
                                    }

                                    txtDeptDescription.Text = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "";
                                }
                            }
                        }
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                        "showNotification('info', 'Department Selected', 'Department selected for editing.');", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error in gvDepartments_SelectedIndexChanged: {ex.Message}");
                    ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                        "showNotification('error', 'Error', 'Error loading department data.');", true);
                }
            }
        }

        // ============================
        // Data Binding Methods
        // ============================

        private string GetSessionSiteId()
        {
            string userSiteId = Session["SiteId"]?.ToString();

            if (string.IsNullOrWhiteSpace(userSiteId))
            {
                System.Diagnostics.Debug.WriteLine("ERROR: GetSessionSiteId - Session['SiteId'] is null or empty");
                throw new InvalidOperationException("Invalid or missing SiteId. Please log in again.");
            }

            return userSiteId;
        }

        private void BindDepartments()
        {
            try
            {
                string userSiteId = Session["SiteId"]?.ToString();
                if (string.IsNullOrWhiteSpace(userSiteId))
                {
                    System.Diagnostics.Debug.WriteLine("⚠️ BindDepartments: No SiteID in session");
                    gvDepartments.DataSource = null;
                    gvDepartments.DataBind();
                    return;
                }

                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
SELECT 
    DepartmentID, 
    DepartmentName, 
    PayType, 
    Description
FROM Departments 
WHERE SiteID = @SiteID 
ORDER BY DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvDepartments.DataSource = dt;
                        gvDepartments.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ BindDepartments error: {ex.Message}");
                gvDepartments.DataSource = null;
                gvDepartments.DataBind();
            }
        }

        private void BindDepartmentsForShift()
        {
            try
            {
                string userSiteId = Session["SiteId"]?.ToString();
                if (string.IsNullOrWhiteSpace(userSiteId))
                {
                    ddlDepartmentShift.Items.Clear();
                    ddlDepartmentShift.Items.Add(new ListItem("-- Select Department --", ""));
                    return;
                }

                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        SELECT DepartmentID, DepartmentName 
                        FROM Departments 
                        WHERE SiteID = @SiteID 
                        ORDER BY DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);
                        conn.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlDepartmentShift.Items.Clear();
                            ddlDepartmentShift.Items.Add(new ListItem("-- Select Department --", ""));

                            while (reader.Read())
                            {
                                string deptId = reader["DepartmentID"].ToString();
                                string deptName = reader["DepartmentName"].ToString();
                                ddlDepartmentShift.Items.Add(new ListItem(deptName, deptId));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ BindDepartmentsForShift error: {ex.Message}");
                ddlDepartmentShift.Items.Clear();
                ddlDepartmentShift.Items.Add(new ListItem("-- Select Department --", ""));
            }
        }

        private void BindShifts()
        {
            try
            {
                string userSiteId = Session["SiteId"]?.ToString();
                if (string.IsNullOrWhiteSpace(userSiteId))
                {
                    return;
                }

                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
SELECT 
    s.ShiftID, 
    s.ShiftName, 
    d.DepartmentName,
    CONVERT(VARCHAR(5), s.StartTime, 108) AS StartTime, 
    CONVERT(VARCHAR(5), s.EndTime, 108) AS EndTime, 
    CASE WHEN s.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status,
    (SELECT COUNT(*) FROM EmployeeShifts es WHERE es.ShiftID = s.ShiftID AND es.IsActive = 1) AS AssignedCount
FROM Shifts s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
WHERE s.SiteID = @SiteID
ORDER BY s.ShiftName";

                    using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@SiteID", userSiteId);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvShifts.DataSource = dt;
                        gvShifts.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ BindShifts error: {ex.Message}");
            }
        }

        // ============================
        // Department CRUD
        // ============================

        protected void btnAddDept_Click(object sender, EventArgs e)
        {
            string deptName = txtDeptName.Text.Trim();
            string payType = ddlDeptPayType.SelectedValue;
            string description = txtDeptDescription.Text.Trim();

            if (string.IsNullOrEmpty(deptName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Department Name is required.');", true);
                return;
            }

            if (string.IsNullOrEmpty(payType))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Pay Type is required.');", true);
                return;
            }

            try
            {
                string userSiteId = GetSessionSiteId();
                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                    INSERT INTO Departments (DepartmentName, PayType, Description, SiteID, IsActive)
                    VALUES (@DepartmentName, @PayType, @Description, @SiteID, 1)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentName", deptName);
                        cmd.Parameters.AddWithValue("@PayType", payType);
                        cmd.Parameters.AddWithValue("@Description", description);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('success', 'Department Added', 'Department \\'{deptName}\\' added successfully.');", true);
                ClearDeptForm();
                BindDepartments();
                BindDepartmentsForShift();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnAddDept_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnUpdateDept_Click(object sender, EventArgs e)
        {
            if (gvDepartments.SelectedIndex < 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'No Selection', 'Please select a department to update.');", true);
                return;
            }

            string deptId = gvDepartments.SelectedDataKey.Value.ToString();
            string deptName = txtDeptName.Text.Trim();
            string payType = ddlDeptPayType.SelectedValue;
            string description = txtDeptDescription.Text.Trim();

            if (string.IsNullOrEmpty(deptName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Department Name is required.');", true);
                return;
            }

            if (string.IsNullOrEmpty(payType))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Pay Type is required.');", true);
                return;
            }

            try
            {
                string userSiteId = GetSessionSiteId();
                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                    UPDATE Departments
                    SET DepartmentName = @DepartmentName, 
                        PayType = @PayType, 
                        Description = @Description
                    WHERE DepartmentID = @DepartmentID AND SiteID = @SiteID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentID", deptId);
                        cmd.Parameters.AddWithValue("@DepartmentName", deptName);
                        cmd.Parameters.AddWithValue("@PayType", payType);
                        cmd.Parameters.AddWithValue("@Description", description);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                $"showNotification('success', 'Department Updated', 'Department \\'{deptName}\\' updated successfully.');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                "showNotification('warning', 'Not Found', 'Department not found.');", true);
                        }
                    }
                }

                ClearDeptForm();
                BindDepartments();
                BindDepartmentsForShift();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnUpdateDept_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnDeleteDept_Click(object sender, EventArgs e)
        {
            if (gvDepartments.SelectedIndex < 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'No Selection', 'Please select a department to delete.');", true);
                return;
            }

            string deptId = gvDepartments.SelectedDataKey.Value.ToString();

            try
            {
                string userSiteId = GetSessionSiteId();
                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "DELETE FROM Departments WHERE DepartmentID = @DepartmentID AND SiteID = @SiteID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentID", deptId);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                "showNotification('success', 'Deleted', 'Department deleted successfully.');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                "showNotification('warning', 'Not Found', 'Department not found.');", true);
                        }
                    }
                }

                ClearDeptForm();
                BindDepartments();
                BindDepartmentsForShift();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnDeleteDept_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        // ============================
        // Shift CRUD
        // ============================

        protected void btnAddShift_Click(object sender, EventArgs e)
        {
            string shiftName = txtShiftName.Text.Trim();
            string deptId = ddlDepartmentShift.SelectedValue;
            string status = ddlStatus.SelectedValue;

            if (string.IsNullOrEmpty(shiftName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Shift Name is required.');", true);
                return;
            }

            if (string.IsNullOrEmpty(deptId))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Department selection is required.');", true);
                return;
            }

            if (!TimeSpan.TryParse(txtStartTime.Text, out TimeSpan startTime) ||
                !TimeSpan.TryParse(txtEndTime.Text, out TimeSpan endTime))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Start Time and End Time must be valid HH:mm values.');", true);
                return;
            }

            if (startTime >= endTime)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Start Time must be before End Time.');", true);
                return;
            }

            try
            {
                string userSiteId = GetSessionSiteId();
                bool isActive = status == "Active";
                string connStr = Properties.Settings.Default.SQLCon;

                // Convert TimeSpan to DateTime for database storage
                DateTime startDateTime = DateTime.Today.Add(startTime);
                DateTime endDateTime = DateTime.Today.Add(endTime);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                    INSERT INTO Shifts (ShiftName, DepartmentID, StartTime, EndTime, IsActive, SiteID)
                    VALUES (@ShiftName, @DepartmentID, @StartTime, @EndTime, @IsActive, @SiteID)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ShiftName", shiftName);
                        cmd.Parameters.AddWithValue("@DepartmentID", deptId);
                        cmd.Parameters.AddWithValue("@StartTime", startDateTime);
                        cmd.Parameters.AddWithValue("@EndTime", endDateTime);
                        cmd.Parameters.AddWithValue("@IsActive", isActive);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('success', 'Shift Added', 'Shift \\'{shiftName}\\' added successfully.');", true);
                ClearShiftForm();
                BindShifts();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnAddShift_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnUpdateShift_Click(object sender, EventArgs e)
        {
            if (gvShifts.SelectedIndex < 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'No Selection', 'Please select a shift to update.');", true);
                return;
            }

            string shiftId = gvShifts.SelectedDataKey.Value.ToString();
            string shiftName = txtShiftName.Text.Trim();
            string deptId = ddlDepartmentShift.SelectedValue;
            string status = ddlStatus.SelectedValue;

            if (string.IsNullOrEmpty(shiftName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Shift Name is required.');", true);
                return;
            }

            if (!TimeSpan.TryParse(txtStartTime.Text, out TimeSpan startTime) ||
                !TimeSpan.TryParse(txtEndTime.Text, out TimeSpan endTime))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Start Time and End Time must be valid HH:mm values.');", true);
                return;
            }

            if (startTime >= endTime)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'Validation', 'Start Time must be before End Time.');", true);
                return;
            }

            try
            {
                string userSiteId = GetSessionSiteId();
                bool isActive = status == "Active";
                string connStr = Properties.Settings.Default.SQLCon;

                DateTime startDateTime = DateTime.Today.Add(startTime);
                DateTime endDateTime = DateTime.Today.Add(endTime);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                    UPDATE Shifts
                    SET ShiftName = @ShiftName, 
                        DepartmentID = @DepartmentID, 
                        StartTime = @StartTime, 
                        EndTime = @EndTime, 
                        IsActive = @IsActive
                    WHERE ShiftID = @ShiftID AND SiteID = @SiteID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmd.Parameters.AddWithValue("@ShiftName", shiftName);
                        cmd.Parameters.AddWithValue("@DepartmentID", deptId);
                        cmd.Parameters.AddWithValue("@StartTime", startDateTime);
                        cmd.Parameters.AddWithValue("@EndTime", endDateTime);
                        cmd.Parameters.AddWithValue("@IsActive", isActive);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('success', 'Shift Updated', 'Shift \\'{shiftName}\\' updated successfully.');", true);
                ClearShiftForm();
                BindShifts();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnUpdateShift_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnDeleteShift_Click(object sender, EventArgs e)
        {
            if (gvShifts.SelectedIndex < 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'No Selection', 'Please select a shift to delete.');", true);
                return;
            }

            string shiftId = gvShifts.SelectedDataKey.Value.ToString();

            try
            {
                string userSiteId = GetSessionSiteId();
                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Remove all employee assignments for this shift first
                    using (SqlCommand cmdAssign = new SqlCommand(
                        "DELETE FROM EmployeeShifts WHERE ShiftID = @ShiftID", conn))
                    {
                        cmdAssign.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmdAssign.ExecuteNonQuery();
                    }

                    // Delete the shift
                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Shifts WHERE ShiftID = @ShiftID AND SiteID = @SiteID", conn))
                    {
                        cmd.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                "showNotification('success', 'Deleted', 'Shift and its employee assignments deleted successfully.');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                                "showNotification('warning', 'Not Found', 'Shift not found.');", true);
                        }
                    }
                }

                ClearShiftForm();
                pnlAssignEmployees.Visible = false;
                BindShifts();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnDeleteShift_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', '{ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void gvShifts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvShifts, "Select$" + e.Row.RowIndex);
                e.Row.Style["cursor"] = "pointer";

                if (e.Row.RowIndex == gvShifts.SelectedIndex)
                {
                    e.Row.CssClass = "selected-row";
                }
            }
        }

        protected void gvShifts_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvShifts.SelectedIndex < 0 || gvShifts.SelectedDataKey == null)
                return;

            try
            {
                string userSiteId = Session["SiteId"]?.ToString();
                if (string.IsNullOrWhiteSpace(userSiteId))
                    return;

                string shiftId = gvShifts.SelectedDataKey.Value.ToString();
                string connStr = Properties.Settings.Default.SQLCon;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
SELECT 
    s.ShiftID,
    s.ShiftName, 
    s.DepartmentID,
    d.DepartmentName,
    s.StartTime, 
    s.EndTime, 
    CASE WHEN s.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
FROM Shifts s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
WHERE s.ShiftID = @ShiftID AND s.SiteID = @SiteID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtShiftName.Text = reader["ShiftName"].ToString();
                                txtStartTime.Text = ((DateTime)reader["StartTime"]).ToString("HH:mm");
                                txtEndTime.Text = ((DateTime)reader["EndTime"]).ToString("HH:mm");

                                string status = reader["Status"].ToString();
                                ddlStatus.SelectedValue = status;

                                string deptId = reader["DepartmentID"].ToString();

                                if (ddlDepartmentShift.Items.Count == 1)
                                {
                                    BindDepartmentsForShift();
                                }

                                if (ddlDepartmentShift.Items.FindByValue(deptId) != null)
                                {
                                    ddlDepartmentShift.SelectedValue = deptId;
                                }

                                // Show employee assignment panel
                                lblSelectedShiftName.Text = reader["ShiftName"].ToString();
                            }
                        }
                    }
                }

                // Load employee assignment panel
                LoadEmployeeAssignments(shiftId, userSiteId);
                pnlAssignEmployees.Visible = true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in gvShifts_SelectedIndexChanged: {ex.Message}");
                lblMessage.Text = "⚠️ Error loading shift details.";
            }
        }

        // ============================
        // Employee Assignment
        // ============================

        private void LoadEmployeeAssignments(string shiftId, string siteId)
        {
            try
            {
                string connStr = Properties.Settings.Default.SQLCon;
                cblEmployees.Items.Clear();

                // Get all employees for this site
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
SELECT 
    e.EmployeeID, 
    e.NameSurname,
    e.CardNumber,
    CASE WHEN es.EmployeeShiftID IS NOT NULL THEN 1 ELSE 0 END AS IsAssigned
FROM Employees e
LEFT JOIN EmployeeShifts es ON es.EmployeeID = e.EmployeeID 
    AND es.ShiftID = @ShiftID AND es.IsActive = 1
WHERE CAST(e.SiteID AS NVARCHAR(MAX)) = @SiteID
ORDER BY e.NameSurname";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmd.Parameters.AddWithValue("@SiteID", siteId);

                        conn.Open();
                        int assignedCount = 0;

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string empId = reader["EmployeeID"].ToString();
                                string name = reader["NameSurname"].ToString();
                                string card = reader["CardNumber"] != DBNull.Value ? reader["CardNumber"].ToString() : "";
                                bool isAssigned = Convert.ToInt32(reader["IsAssigned"]) == 1;

                                string displayText = string.IsNullOrEmpty(card) ? name : $"{name} ({card})";
                                ListItem item = new ListItem(displayText, empId);
                                item.Selected = isAssigned;
                                cblEmployees.Items.Add(item);

                                if (isAssigned) assignedCount++;
                            }
                        }

                        lblAssignedCount.Text = assignedCount.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in LoadEmployeeAssignments: {ex.Message}");
                lblAssignMessage.ForeColor = System.Drawing.Color.Red;
                lblAssignMessage.Text = "⚠️ Error loading employees.";
            }
        }

        protected void btnSaveAssignments_Click(object sender, EventArgs e)
        {
            if (gvShifts.SelectedIndex < 0 || gvShifts.SelectedDataKey == null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    "showNotification('warning', 'No Selection', 'No shift selected.');", true);
                return;
            }

            string shiftId = gvShifts.SelectedDataKey.Value.ToString();

            try
            {
                string connStr = Properties.Settings.Default.SQLCon;

                // Collect selected employee IDs
                var selectedEmployeeIds = new List<string>();
                foreach (ListItem item in cblEmployees.Items)
                {
                    if (item.Selected)
                        selectedEmployeeIds.Add(item.Value);
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Remove all current active assignments for this shift
                    using (SqlCommand cmdDelete = new SqlCommand(
                        "DELETE FROM EmployeeShifts WHERE ShiftID = @ShiftID", conn))
                    {
                        cmdDelete.Parameters.AddWithValue("@ShiftID", shiftId);
                        cmdDelete.ExecuteNonQuery();
                    }

                    // Insert new assignments
                    foreach (string empId in selectedEmployeeIds)
                    {
                        using (SqlCommand cmdInsert = new SqlCommand(@"
                            INSERT INTO EmployeeShifts (EmployeeID, ShiftID, IsActive, AssignedDate)
                            VALUES (@EmployeeID, @ShiftID, 1, GETDATE())", conn))
                        {
                            cmdInsert.Parameters.AddWithValue("@EmployeeID", empId);
                            cmdInsert.Parameters.AddWithValue("@ShiftID", shiftId);
                            cmdInsert.ExecuteNonQuery();
                        }
                    }
                }

                lblAssignedCount.Text = selectedEmployeeIds.Count.ToString();

                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('success', 'Assignments Saved', '{selectedEmployeeIds.Count} employee(s) assigned to shift successfully.');", true);

                BindShifts();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in btnSaveAssignments_Click: {ex.Message}");
                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage",
                    $"showNotification('error', 'Error', 'Error saving assignments: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        protected void btnCancelAssignment_Click(object sender, EventArgs e)
        {
            pnlAssignEmployees.Visible = false;
            gvShifts.SelectedIndex = -1;
        }

        // ============================
        // Navigation Methods
        // ============================

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reports.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnSyncLog_Click(object sender, EventArgs e)
        {
            Response.Redirect("SyncLog.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserManagement.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnConfig_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConfigTools.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnEmployees_Click(object sender, EventArgs e)
        {
            Response.Redirect("Employees.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnShiftManagement_Click(object sender, EventArgs e)
        {
            Response.Redirect("ShiftManagement.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // ============================
        // Helper Methods
        // ============================

        private void ClearDeptForm()
        {
            txtDeptName.Text = "";
            ddlDeptPayType.SelectedValue = "";
            txtDeptDescription.Text = "";
        }

        private void ClearShiftForm()
        {
            txtShiftName.Text = "";
            ddlDepartmentShift.ClearSelection();
            txtStartTime.Text = "";
            txtEndTime.Text = "";
            ddlStatus.SelectedValue = "Active";
            gvShifts.SelectedIndex = -1;
            pnlAssignEmployees.Visible = false;
        }

    }
}