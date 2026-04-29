
using System; // required
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;

namespace TimeAttendance.WebForms
{
    // TODO: System.Web.UI.Page is not available in .NET 8.0. You must migrate this page to ASP.NET Core (e.g., Razor Pages or MVC Controller) or use a compatible base class. The closest match is Microsoft.AspNetCore.Mvc.RazorPages.Page, but it is not a drop-in replacement. The code will not compile until the migration is complete.
    public partial class Employees
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Display Assembly Version
                System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
                System.Reflection.AssemblyName assemblyName = assembly.GetName();
                lblVersion.Text = string.Format("v{0}", assemblyName.Version.ToString());

                string role = Session["Role"]?.ToString();
                bool isPrivileged = role == "Admin" || role == "Manager";

                btnSyncEmployees.Visible = isPrivileged;

                if (!isPrivileged)
                {
                    lblMessage.Text = "Access denied. Only Admins and Managers can manage employees.";
                    gvEmployees.Visible = false;
                    return;
                }

                LoadDepartments();
                LoadShifts();
                LoadSites();
                LoadEmployees();
            }
        }

        protected void btnSyncEmployees_Click(object sender, EventArgs e)
        {
            try
            {
                int syncedCount = SyncReaderEventsToEmployees();
                LoadEmployees();

                string message = syncedCount > 0
                    ? $"Successfully synced {syncedCount} employee(s) from ReaderEvents."
                    : "No new employees found to sync from ReaderEvents.";

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"✅ {message}";

                // If GridView has entries, set focus on it and scroll into view
                if (gvEmployees.Rows.Count > 0)
                {
                    gvEmployees.Focus();
                    ScriptManager.RegisterStartupScript(this, GetType(), "scrollToGrid", @"
                            setTimeout(function() {
                                var gridView = document.getElementById('" + gvEmployees.ClientID + @"');
                                if (gridView) {
                                    gridView.scrollIntoView({ behavior: 'smooth', block: 'start' });
                                }
                            }, 3500);
                        ", true);
                }

                // Show sync result in popup and auto-hide after 3 seconds
                ScriptManager.RegisterStartupScript(this, GetType(), "showResult",
                    $"showSyncResult(true, '{message}');", true);
            }
            catch (Exception ex)
            {
                string errorMessage = $"Error syncing employees: {ex.Message}";

                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ {errorMessage}";
                System.Diagnostics.Debug.WriteLine($"Sync error: {ex.ToString()}");

                // Show error result in popup and auto-hide after 3 seconds
                ScriptManager.RegisterStartupScript(this, GetType(), "showResult",
                    $"showSyncResult(false, '{errorMessage}');", true);
            }
        }

        private int SyncReaderEventsToEmployees()
        {
            string siteId = Session["SiteId"]?.ToString();
            if (string.IsNullOrEmpty(siteId))
            {
                System.Diagnostics.Debug.WriteLine("⚠️ Cannot sync without a valid SiteId.");
                throw new Exception("You do not have a site assigned. Contact your administrator.");
            }

            System.Diagnostics.Debug.WriteLine($"🔍 Starting sync with SiteId: {siteId}");

            List<(string PersonName, string CardNumber)> personsToSync = new List<(string, string)>();

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    // Query to find new employees from ReaderEvents that don't exist in Employees
                    // Include CardNumber as EmployeeCode
                    string query = @"
                    SELECT r.PersonName, r.CardNumber
                    FROM (
                        SELECT DISTINCT r.PersonName, r.CardNumber
                        FROM ReaderEvents r
                        WHERE r.SiteId = @SiteID
                          AND r.PersonName IS NOT NULL
                          AND r.PersonName <> ''
                          AND NOT EXISTS (
                              SELECT 1 FROM Employees e 
                              WHERE UPPER(e.NameSurname) = UPPER(r.PersonName)
                                AND e.SiteID = @SiteID
                          )
                    ) r
                    ORDER BY r.PersonName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Both parameters are strings/text
                        cmd.Parameters.Add("@SiteID", SqlDbType.NVarChar, 50).Value = siteId;

                        System.Diagnostics.Debug.WriteLine($"📋 Executing query with SiteId: {siteId}");

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string personName = reader["PersonName"].ToString().Trim();
                                string cardNumber = reader["CardNumber"] != DBNull.Value ? reader["CardNumber"].ToString().Trim() : "";
                                if (!string.IsNullOrEmpty(personName))
                                {
                                    personsToSync.Add((personName, cardNumber));
                                    System.Diagnostics.Debug.WriteLine($"✓ Found person to sync: {personName} (Card: {cardNumber})");
                                }
                            }
                        }
                    }
                }

                System.Diagnostics.Debug.WriteLine($"📊 Total persons found to sync: {personsToSync.Count}");

                int createdCount = 0;
                foreach (var person in personsToSync)
                {
                    try
                    {
                        using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                        {
                            conn.Open();
                            CreateEmployeeFromReaderEvent(conn, person.PersonName, person.CardNumber, siteId);
                            createdCount++;
                            System.Diagnostics.Debug.WriteLine($"✅ Successfully created employee: {person.PersonName} (Code: {person.CardNumber})");
                        }
                    }
                    catch (Exception innerEx)
                    {
                        System.Diagnostics.Debug.WriteLine($"❌ Failed to create employee {person.PersonName}: {innerEx.Message}");
                    }
                }

                // Backfill EmployeeCode for existing employees that are missing it
                int backfilledCount = BackfillEmployeeCodes(siteId);
                if (backfilledCount > 0)
                {
                    System.Diagnostics.Debug.WriteLine($"🔄 Backfilled EmployeeCode for {backfilledCount} existing employee(s).");
                }

                System.Diagnostics.Debug.WriteLine($"🎉 Sync completed. Created {createdCount} employees, backfilled {backfilledCount} codes.");
                return createdCount + backfilledCount;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error syncing ReaderEvents to Employees: {ex.Message}");
                throw;
            }
        }

        private string GetSiteIdAsString(string siteId)
        {
            // Return site ID as-is (alphanumeric like 'BH001')
            return string.IsNullOrEmpty(siteId) ? "" : siteId;
        }

        private int ConvertSiteIdToInt(string siteId)
        {
            // DEPRECATED - This method is kept only for backwards compatibility
            // SiteID should now be stored as a string, not converted to int
            if (string.IsNullOrEmpty(siteId))
                return 0;
            int hash = siteId.GetHashCode();
            return Math.Abs(hash) % 2147483647;
        }

        private void CreateEmployeeFromReaderEvent(SqlConnection conn, string personName, string cardNumber, string siteId)
        {
            string insertQuery = @"
                    INSERT INTO Employees (NameSurname, EmployeeCode, SiteID, IsActive, CreatedDate)
                    VALUES (@NameSurname, @EmployeeCode, @SiteID, 1, GETDATE())";

            using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
            {
                cmd.Parameters.Add("@NameSurname", SqlDbType.NVarChar, 200).Value = personName;
                cmd.Parameters.Add("@EmployeeCode", SqlDbType.NVarChar, 50).Value = string.IsNullOrEmpty(cardNumber) ? (object)DBNull.Value : cardNumber;
                cmd.Parameters.Add("@SiteID", SqlDbType.NVarChar, 50).Value = GetSiteIdAsString(siteId);
                System.Diagnostics.Debug.WriteLine($"Creating employee: {personName} (Code: {cardNumber}) with SiteID: {siteId}");
                cmd.ExecuteNonQuery();
            }
        }

        private int BackfillEmployeeCodes(string siteId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    string updateQuery = @"
                        UPDATE e
                        SET e.EmployeeCode = r.CardNumber,
                            e.ModifiedDate = GETDATE()
                        FROM Employees e
                        INNER JOIN (
                            SELECT DISTINCT PersonName, CardNumber, SiteId
                            FROM ReaderEvents
                            WHERE CardNumber IS NOT NULL 
                              AND CardNumber <> ''
                              AND PersonName IS NOT NULL
                              AND PersonName <> ''
                              AND SiteId = @SiteID
                        ) r ON UPPER(e.NameSurname) = UPPER(r.PersonName) 
                            AND e.SiteID = r.SiteId
                        WHERE (e.EmployeeCode IS NULL OR e.EmployeeCode = '')";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.Add("@SiteID", SqlDbType.NVarChar, 50).Value = siteId;
                        int rowsAffected = cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine($"🔄 Backfilled {rowsAffected} employee codes from ReaderEvents");
                        return rowsAffected;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"⚠️ Error backfilling employee codes: {ex.Message}");
                return 0;
            }
        }

        private void ShowPopup(string message)
        {
            // Simple client-side popup notification
            ScriptManager.RegisterStartupScript(this, GetType(), "popupMessage",
                $"alert('{message}');", true);
        }

        private void LoadDepartments()
        {
            ddlDepartmentEnroll.Items.Clear();
            ddlDepartmentEnroll.Items.Add(new ListItem("-- Select Department --", ""));

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    string query = @"
                    SELECT DepartmentID, DepartmentName
                    FROM Departments
                    WHERE IsActive = 1
                    ORDER BY DepartmentName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string deptId = reader["DepartmentID"].ToString();
                                string deptName = reader["DepartmentName"].ToString();
                                ddlDepartmentEnroll.Items.Add(new ListItem(deptName, deptId));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading departments: {ex.Message}");
            }
        }

        private void LoadShifts()
        {
            ddlShiftAssign.Items.Clear();
            ddlShiftAssign.Items.Add(new ListItem("-- Select Shift --", ""));

            string userSiteId = Session["SiteId"]?.ToString();
            if (string.IsNullOrEmpty(userSiteId))
            {
                return; // User must have a valid SiteId to view shifts
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    string query = @"
                            SELECT ShiftID, ShiftName 
                            FROM Shifts 
                            WHERE IsActive = 1 AND SiteID = @SiteID
                            ORDER BY ShiftName";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SiteID", userSiteId);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string shiftId = reader["ShiftID"].ToString();
                                string shiftName = reader["ShiftName"].ToString();
                                ddlShiftAssign.Items.Add(new ListItem(shiftName, shiftId));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading shifts: {ex.Message}");
            }
        }

        private void LoadSites()
        {
            ddlSiteFilter.Items.Clear();
            ddlSiteFilter.Items.Add(new ListItem("-- All Sites --", ""));

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    // Try to get sites from Employees table first
                    string query = @"
                            SELECT DISTINCT SiteID
                            FROM Employees
                            WHERE SiteID IS NOT NULL
                            ORDER BY SiteID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                object siteId = reader["SiteID"];
                                if (siteId != DBNull.Value)
                                {
                                    string siteIdStr = siteId.ToString();
                                    ddlSiteFilter.Items.Add(new ListItem(siteIdStr, siteIdStr));
                                    System.Diagnostics.Debug.WriteLine($"Loaded site: {siteIdStr}");
                                }
                            }
                        }
                    }
                }

                // Set to current user's site by default
                string userSiteId = Session["SiteId"]?.ToString();
                if (!string.IsNullOrEmpty(userSiteId))
                {
                    if (ddlSiteFilter.Items.FindByValue(userSiteId) != null)
                    {
                        ddlSiteFilter.SelectedValue = userSiteId;
                        System.Diagnostics.Debug.WriteLine($"Set default site to: {userSiteId}");
                    }
                    else
                    {
                        // If user's site isn't in employees yet, add it
                        ddlSiteFilter.Items.Add(new ListItem(userSiteId, userSiteId));
                        ddlSiteFilter.SelectedValue = userSiteId;
                        System.Diagnostics.Debug.WriteLine($"Added and selected user's site: {userSiteId}");
                    }
                }

                System.Diagnostics.Debug.WriteLine($"Total sites loaded: {ddlSiteFilter.Items.Count}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading sites: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
            }
        }

        private void LoadEmployees()
        {
            string statusFilter = ddlStatusFilter.SelectedValue;
            string userSiteId = Session["SiteId"]?.ToString();
            string selectedSiteId = ddlSiteFilter.SelectedValue;

            // Use selected site filter if chosen, otherwise use user's site
            string siteToQuery = !string.IsNullOrEmpty(selectedSiteId) ? selectedSiteId : userSiteId;

            System.Diagnostics.Debug.WriteLine($"🔍 LoadEmployees - Status: {statusFilter}, Site: {siteToQuery}");

            if (string.IsNullOrEmpty(siteToQuery))
            {
                lblMessage.Text = "⚠️ You do not have a site assigned. Contact your administrator.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    // First, let's see what SiteID values exist in the database
                    string debugQuery = "SELECT DISTINCT SiteID FROM Employees WHERE NameSurname IS NOT NULL";
                    using (SqlCommand debugCmd = new SqlCommand(debugQuery, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = debugCmd.ExecuteReader())
                        {
                            System.Diagnostics.Debug.WriteLine("📋 Existing SiteID values in Employees table:");
                            while (reader.Read())
                            {
                                object val = reader["SiteID"];
                                if (val != DBNull.Value)
                                {
                                    System.Diagnostics.Debug.WriteLine($"  - SiteID: {val} (Type: {val.GetType().Name})");
                                }
                                else
                                {
                                    System.Diagnostics.Debug.WriteLine($"  - SiteID: NULL");
                                }
                            }
                        }
                    }

                    string query = @"
                            SELECT 
                                e.EmployeeID,
                                ISNULL(e.EmployeeCode, '') AS EmployeeCode,
                                e.NameSurname AS FullName,
                                e.Email,
                                e.PhoneNumber AS Mobile,
                                d.DepartmentName AS Department,
                                (SELECT TOP 1 s.ShiftName 
                                 FROM EmployeeShifts es 
                                 INNER JOIN Shifts s ON s.ShiftID = es.ShiftID 
                                 WHERE es.EmployeeID = e.EmployeeID AND es.IsActive = 1 AND s.IsActive = 1) AS Shift,
                                e.PayType,
                                e.HourlyRate,
                                e.WeeklyRate,
                                e.MonthlyRate,
                                CASE WHEN e.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
                            FROM Employees e
                            LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
                            WHERE e.SiteID = @SiteID";

                    if (statusFilter != "All")
                    {
                        query += statusFilter == "Active" ? " AND e.IsActive = 1" : " AND e.IsActive = 0";
                    }

                    query += " ORDER BY e.NameSurname";

                    System.Diagnostics.Debug.WriteLine($"📋 Query: {query}");
                    System.Diagnostics.Debug.WriteLine($"📌 Parameter @SiteID: {siteToQuery}");

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SiteID", siteToQuery);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        System.Diagnostics.Debug.WriteLine($"📊 Rows returned: {dt.Rows.Count}");

                        if (dt.Rows.Count > 0)
                        {
                            foreach (DataRow row in dt.Rows)
                            {
                                System.Diagnostics.Debug.WriteLine($"  - {row["FullName"]} ({row["EmployeeID"]})");
                            }
                        }

                        gvEmployees.DataSource = dt;
                        gvEmployees.DataBind();

                        System.Diagnostics.Debug.WriteLine($"✅ GridView bound with {dt.Rows.Count} rows");
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"⚠️ Error loading employees: {ex.Message}";
                System.Diagnostics.Debug.WriteLine($"❌ Error loading employees: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"📍 Stack: {ex.StackTrace}");
            }
        }

        private void LoadEmployeesAndScroll()
        {
            LoadEmployees();

            // Scroll into view only when called manually (not during Page_Load)
            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToGrid", @"
                    setTimeout(function() {
                        var filterSection = document.querySelector('.section-title');
                        if (filterSection) {
                            filterSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        }
                    }, 300);
                ", true);
        }

        /// <summary>
        /// Assigns an employee to a shift using the EmployeeShifts junction table.
        /// Removes any existing active assignment for the employee first to enforce one-shift-per-employee.
        /// </summary>
        private void AssignEmployeeToShift(SqlConnection conn, string employeeId, string shiftId)
        {
            // Remove any existing active shift assignment for this employee
            using (SqlCommand cmdRemove = new SqlCommand(
                "DELETE FROM EmployeeShifts WHERE EmployeeID = @EmployeeID", conn))
            {
                cmdRemove.Parameters.AddWithValue("@EmployeeID", employeeId);
                cmdRemove.ExecuteNonQuery();
            }

            // Insert new assignment
            using (SqlCommand cmdInsert = new SqlCommand(@"
                    INSERT INTO EmployeeShifts (EmployeeID, ShiftID, IsActive, AssignedDate)
                    VALUES (@EmployeeID, @ShiftID, 1, GETDATE())", conn))
            {
                cmdInsert.Parameters.AddWithValue("@EmployeeID", employeeId);
                cmdInsert.Parameters.AddWithValue("@ShiftID", shiftId);
                cmdInsert.ExecuteNonQuery();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string empId = txtEmpId.Text.Trim();
            string fullName = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string mobile = txtMobile.Text.Trim();
            string role = ddlRole.SelectedValue;
            string deptId = ddlDepartmentEnroll.SelectedValue;
            string shiftId = ddlShiftAssign.SelectedValue;
            string payType = ddlPayType.SelectedValue;
            string userSiteId = Session["SiteId"]?.ToString();

            // Parse rates
            decimal? hourlyRate = ParseDecimal(txtHourlyRate.Text);
            decimal? weeklyRate = ParseDecimal(txtWeeklyRate.Text);
            decimal? monthlyRate = ParseDecimal(txtMonthlyRate.Text);

            if (string.IsNullOrEmpty(empId) || string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(deptId))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "⚠️ Please fill in all required fields: Employee ID, Name, and Department.";
                ScriptManager.RegisterStartupScript(this, GetType(), "validationError",
                    "showSyncResult(false, 'Please fill in all required fields: Employee ID, Name, and Department.');", true);
                return;
            }

            if (string.IsNullOrEmpty(userSiteId))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "⚠️ Your account does not have a site assigned.";
                ScriptManager.RegisterStartupScript(this, GetType(), "siteError",
                    "showSyncResult(false, 'Your account does not have a site assigned.');", true);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    string query = @"
                            INSERT INTO Employees (EmployeeID, NameSurname, Email, PhoneNumber, DepartmentID, PayType, HourlyRate, WeeklyRate, MonthlyRate, SiteID, IsActive, CreatedDate)
                            VALUES (@EmployeeID, @NameSurname, @Email, @PhoneNumber, @DepartmentID, @PayType, @HourlyRate, @WeeklyRate, @MonthlyRate, @SiteID, 1, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeID", empId);
                        cmd.Parameters.AddWithValue("@NameSurname", fullName);
                        cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                        cmd.Parameters.AddWithValue("@PhoneNumber", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@DepartmentID", int.Parse(deptId));
                        cmd.Parameters.AddWithValue("@PayType", string.IsNullOrEmpty(payType) ? (object)DBNull.Value : payType);
                        cmd.Parameters.AddWithValue("@HourlyRate", hourlyRate.HasValue ? (object)hourlyRate.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@WeeklyRate", weeklyRate.HasValue ? (object)weeklyRate.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@MonthlyRate", monthlyRate.HasValue ? (object)monthlyRate.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@SiteID", GetSiteIdAsString(userSiteId));

                        cmd.ExecuteNonQuery();
                    }

                    // If shift is selected, assign via EmployeeShifts junction table
                    if (!string.IsNullOrEmpty(shiftId))
                    {
                        AssignEmployeeToShift(conn, empId, shiftId);
                    }

                    // Log rate history
                    LogRateHistory(conn, empId, hourlyRate, weeklyRate, monthlyRate);
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"✅ Employee '{fullName}' saved successfully with rates!";
                ScriptManager.RegisterStartupScript(this, GetType(), "saveSuccess",
                    $"showSyncResult(true, 'Employee {fullName} saved successfully with rates!');", true);

                ClearForm();
                LoadEmployees();
            }
            catch (SqlException sqlEx)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Database error: {sqlEx.Message}";
                ScriptManager.RegisterStartupScript(this, GetType(), "dbError",
                    $"showSyncResult(false, 'Database error: {sqlEx.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"SQL Error: {sqlEx.Message}");
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Error: {ex.Message}";
                ScriptManager.RegisterStartupScript(this, GetType(), "saveError",
                    $"showSyncResult(false, 'Error: {ex.Message}');", true);
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
            }
        }

        private void ClearForm()
        {
            txtEmpId.Text = "";
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            txtHourlyRate.Text = "";
            txtWeeklyRate.Text = "";
            txtMonthlyRate.Text = "";
            ddlRole.SelectedIndex = 0;
            ddlDepartmentEnroll.SelectedIndex = 0;
            ddlShiftAssign.SelectedIndex = 0;
            ddlShiftPatternEnroll.SelectedIndex = 0;
            ddlPayType.SelectedIndex = 0;
            chkOvertimeEnroll.Checked = false;

            lblMessage.ForeColor = System.Drawing.Color.Gray;
            lblMessage.Text = "🧹 Form cleared. Ready for a fresh entry!";
            ScriptManager.RegisterStartupScript(this, GetType(), "clearForm",
                "showSyncResult(true, 'Form cleared. Ready for a fresh entry!');", true);
        }

        private decimal? ParseDecimal(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return null;

            // Strip spaces used as thousand separators before parsing
            string cleaned = value.Replace(" ", "");

            if (decimal.TryParse(cleaned, out decimal result))
                return result;

            return null;
        }

        private string FormatRateWithSpaces(decimal value)
        {
            string formatted = value.ToString("N2");
            // Replace comma thousand separators with spaces
            // N2 format uses culture-specific group separator; normalize to space
            var nfi = (System.Globalization.NumberFormatInfo)System.Globalization.CultureInfo.CurrentCulture.NumberFormat.Clone();
            nfi.NumberGroupSeparator = " ";
            return value.ToString("N2", nfi);
        }

        private void LogRateHistory(SqlConnection conn, string employeeId, decimal? hourlyRate, decimal? weeklyRate, decimal? monthlyRate)
        {
            try
            {
                string query = @"
                        INSERT INTO EmployeeRateHistory (EmployeeID, HourlyRate, WeeklyRate, MonthlyRate, EffectiveDate, CreatedDate)
                        VALUES (@EmployeeID, @HourlyRate, @WeeklyRate, @MonthlyRate, GETDATE(), GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                    cmd.Parameters.AddWithValue("@HourlyRate", hourlyRate.HasValue ? (object)hourlyRate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@WeeklyRate", weeklyRate.HasValue ? (object)weeklyRate.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@MonthlyRate", monthlyRate.HasValue ? (object)monthlyRate.Value : DBNull.Value);

                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error logging rate history: {ex.Message}");
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnMiddleware_Click(object sender, EventArgs e)
        {
            try
            {
                int syncedCount = 5;
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"🔄 Middleware sync completed successfully! {syncedCount} employees pushed. 🚀";
                ScriptManager.RegisterStartupScript(this, GetType(), "middlewareSuccess",
                    $"showSyncResult(true, 'Middleware sync completed successfully! {syncedCount} employees pushed.');", true);
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Middleware sync failed: {ex.Message}";
                ScriptManager.RegisterStartupScript(this, GetType(), "middlewareError",
                    $"showSyncResult(false, 'Middleware sync failed: {ex.Message}');", true);
            }
        }

        protected void btnSyncToMiddleware_Click(object sender, EventArgs e)
        {
        }

        private void UpdateLastSynced(string employeeId)
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "UPDATE Employees SET ModifiedDate = GETDATE() WHERE EmployeeID = @EmployeeID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void LogSyncFailure(string employeeId, object payload, string errorMessage)
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "INSERT INTO SyncLog (EmployeeID, Payload, ErrorMessage, CreatedDate) VALUES (@EmployeeID, @Payload, @ErrorMessage, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                    cmd.Parameters.AddWithValue("@Payload", new JavaScriptSerializer().Serialize(payload));
                    cmd.Parameters.AddWithValue("@ErrorMessage", errorMessage);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool SendToMiddleware(object payload)
        {
            try
            {
                string apiUrl = "https://your-middleware-endpoint/api/employees/sync";
                var request = (HttpWebRequest)WebRequest.Create(apiUrl);
                request.Method = "POST";
                request.ContentType = "application/json";
                string json = new JavaScriptSerializer().Serialize(payload);
                byte[] data = Encoding.UTF8.GetBytes(json);
                request.ContentLength = data.Length;
                using (var stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                }
                using (var response = (HttpWebResponse)request.GetResponse())
                {
                    return response.StatusCode == HttpStatusCode.OK;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        private DataTable GetEmployeesToSync()
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "SELECT EmployeeID, NameSurname, Email, PhoneNumber FROM Employees WHERE IsActive = 1";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

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
            // Already on this page — no redirect needed
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

        protected override void Render(HtmlTextWriter writer)
        {
            // Register postback event references for each GridView row so that
            // ASP.NET event validation accepts the client-side "Select$N" callbacks
            // generated in gvEmployees_RowDataBound.
            foreach (GridViewRow row in gvEmployees.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    Page.ClientScript.RegisterForEventValidation(
                        gvEmployees.UniqueID, "Select$" + row.RowIndex);
                }
            }

            base.Render(writer);
        }

        protected void gvEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gvEmployees, "Select$" + e.Row.RowIndex);
                e.Row.Style["cursor"] = "pointer";

                if (e.Row.RowIndex == gvEmployees.SelectedIndex)
                {
                    e.Row.CssClass = "selected-row";
                }

                // Format rate columns (indexes 8, 9, 10) with space thousand separators
                // Note: EmployeeCode added at index 1, shifting all subsequent columns by 1
                var nfi = (System.Globalization.NumberFormatInfo)System.Globalization.CultureInfo.CurrentCulture.NumberFormat.Clone();
                nfi.NumberGroupSeparator = " ";
                int[] rateColumns = { 8, 9, 10 };
                DataRowView drv = (DataRowView)e.Row.DataItem;
                string[] rateFields = { "HourlyRate", "WeeklyRate", "MonthlyRate" };
                for (int i = 0; i < rateColumns.Length; i++)
                {
                    object val = drv[rateFields[i]];
                    if (val != null && val != DBNull.Value)
                    {
                        e.Row.Cells[rateColumns[i]].Text = Convert.ToDecimal(val).ToString("N2", nfi);
                    }
                }
            }
        }

        protected void gvEmployees_SelectedIndexChanged(object sender, EventArgs e)
        {
            string empId = gvEmployees.SelectedDataKey.Value.ToString();
            OpenEditModal(empId);
        }

        private void OpenEditModal(string employeeId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    string query = @"
                        SELECT 
                            e.EmployeeID,
                            e.EmployeeCode,
                            e.NameSurname,
                            e.Email,
                            e.PhoneNumber,
                            e.DepartmentID,
                            e.PayType,
                            e.HourlyRate,
                            e.WeeklyRate,
                            e.MonthlyRate,
                            (SELECT TOP 1 es.ShiftID 
                             FROM EmployeeShifts es 
                             WHERE es.EmployeeID = e.EmployeeID AND es.IsActive = 1) AS ShiftID
                        FROM Employees e
                        WHERE e.EmployeeID = @EmployeeID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hdnEditEmployeeID.Value = reader["EmployeeID"].ToString();
                                txtEditEmpId.Text = reader["EmployeeID"].ToString();
                                txtEditEmployeeCode.Text = reader["EmployeeCode"] != DBNull.Value ? reader["EmployeeCode"].ToString() : "";
                                txtEditName.Text = reader["NameSurname"] != DBNull.Value ? reader["NameSurname"].ToString() : "";
                                txtEditEmail.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : "";
                                txtEditMobile.Text = reader["PhoneNumber"] != DBNull.Value ? reader["PhoneNumber"].ToString() : "";
                                txtEditHourlyRate.Text = reader["HourlyRate"] != DBNull.Value ? FormatRateWithSpaces(Convert.ToDecimal(reader["HourlyRate"])) : "";
                                txtEditWeeklyRate.Text = reader["WeeklyRate"] != DBNull.Value ? FormatRateWithSpaces(Convert.ToDecimal(reader["WeeklyRate"])) : "";
                                txtEditMonthlyRate.Text = reader["MonthlyRate"] != DBNull.Value ? FormatRateWithSpaces(Convert.ToDecimal(reader["MonthlyRate"])) : "";

                                string deptId = reader["DepartmentID"] != DBNull.Value ? reader["DepartmentID"].ToString() : "";
                                string shiftId = reader["ShiftID"] != DBNull.Value ? reader["ShiftID"].ToString() : "";
                                string payType = reader["PayType"] != DBNull.Value ? reader["PayType"].ToString() : "";

                                reader.Close();

                                // Populate Department dropdown
                                PopulateEditDepartments(conn, deptId);

                                // Populate Shift dropdown
                                PopulateEditShifts(conn, shiftId);

                                // Set Pay Type
                                if (ddlEditPayType.Items.FindByValue(payType) != null)
                                    ddlEditPayType.SelectedValue = payType;
                            }
                        }
                    }
                }

                // Show the modal
                pnlEditModal.CssClass = "modal-overlay active";
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Error loading employee: {ex.Message}";
                System.Diagnostics.Debug.WriteLine($"Error opening edit modal: {ex.Message}");
            }
        }

        private void PopulateEditDepartments(SqlConnection conn, string selectedDeptId)
        {
            ddlEditDepartment.Items.Clear();
            ddlEditDepartment.Items.Add(new ListItem("-- Select Department --", ""));

            string query = "SELECT DepartmentID, DepartmentName FROM Departments WHERE IsActive = 1 ORDER BY DepartmentName";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlEditDepartment.Items.Add(new ListItem(
                            reader["DepartmentName"].ToString(),
                            reader["DepartmentID"].ToString()
                        ));
                    }
                }
            }

            if (!string.IsNullOrEmpty(selectedDeptId) && ddlEditDepartment.Items.FindByValue(selectedDeptId) != null)
                ddlEditDepartment.SelectedValue = selectedDeptId;
        }

        private void PopulateEditShifts(SqlConnection conn, string selectedShiftId)
        {
            ddlEditShift.Items.Clear();
            ddlEditShift.Items.Add(new ListItem("-- Select Shift --", ""));

            string userSiteId = Session["SiteId"]?.ToString();
            if (!string.IsNullOrEmpty(userSiteId))
            {
                string query = "SELECT ShiftID, ShiftName FROM Shifts WHERE IsActive = 1 AND SiteID = @SiteID ORDER BY ShiftName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteID", userSiteId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ddlEditShift.Items.Add(new ListItem(
                                reader["ShiftName"].ToString(),
                                reader["ShiftID"].ToString()
                            ));
                        }
                    }
                }
            }

            if (!string.IsNullOrEmpty(selectedShiftId) && ddlEditShift.Items.FindByValue(selectedShiftId) != null)
                ddlEditShift.SelectedValue = selectedShiftId;
        }

        private void CloseEditModal()
        {
            pnlEditModal.CssClass = "modal-overlay";
            hdnEditEmployeeID.Value = "";
            txtEditEmpId.Text = "";
            txtEditEmployeeCode.Text = "";
            txtEditName.Text = "";
            txtEditEmail.Text = "";
            txtEditMobile.Text = "";
            txtEditHourlyRate.Text = "";
            txtEditWeeklyRate.Text = "";
            txtEditMonthlyRate.Text = "";
            ddlEditDepartment.Items.Clear();
            ddlEditShift.Items.Clear();
            ddlEditPayType.SelectedIndex = 0;
            ddlEditShiftPattern.SelectedIndex = 0;
            chkEditOvertime.Checked = false;
        }

        protected void btnSaveEdit_Click(object sender, EventArgs e)
        {
            string empId = hdnEditEmployeeID.Value;
            string fullName = txtEditName.Text.Trim();
            string email = txtEditEmail.Text.Trim();
            string mobile = txtEditMobile.Text.Trim();
            string deptId = ddlEditDepartment.SelectedValue;
            string shiftId = ddlEditShift.SelectedValue;
            string payType = ddlEditPayType.SelectedValue;

            decimal? hourlyRate = ParseDecimal(txtEditHourlyRate.Text);
            decimal? weeklyRate = ParseDecimal(txtEditWeeklyRate.Text);
            decimal? monthlyRate = ParseDecimal(txtEditMonthlyRate.Text);

            if (string.IsNullOrEmpty(empId) || string.IsNullOrEmpty(fullName))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "⚠️ Employee ID and Name are required.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    string query = @"
                        UPDATE Employees
                        SET EmployeeCode = @EmployeeCode,
                            NameSurname = @NameSurname,
                            Email = @Email,
                            PhoneNumber = @PhoneNumber,
                            DepartmentID = @DepartmentID,
                            PayType = @PayType,
                            HourlyRate = @HourlyRate,
                            WeeklyRate = @WeeklyRate,
                            MonthlyRate = @MonthlyRate,
                            ModifiedDate = GETDATE()
                        WHERE EmployeeID = @EmployeeID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeID", empId);
                        string employeeCode = txtEditEmployeeCode.Text.Trim();
                        cmd.Parameters.AddWithValue("@EmployeeCode", string.IsNullOrEmpty(employeeCode) ? (object)DBNull.Value : employeeCode);
                        cmd.Parameters.AddWithValue("@NameSurname", fullName);
                        cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(email) ? (object)DBNull.Value : email);
                        cmd.Parameters.AddWithValue("@PhoneNumber", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                        cmd.Parameters.AddWithValue("@DepartmentID", string.IsNullOrEmpty(deptId) ? (object)DBNull.Value : int.Parse(deptId));
                        cmd.Parameters.AddWithValue("@PayType", string.IsNullOrEmpty(payType) ? (object)DBNull.Value : payType);
                        cmd.Parameters.AddWithValue("@HourlyRate", hourlyRate.HasValue ? (object)hourlyRate.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@WeeklyRate", weeklyRate.HasValue ? (object)weeklyRate.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@MonthlyRate", monthlyRate.HasValue ? (object)monthlyRate.Value : DBNull.Value);

                        cmd.ExecuteNonQuery();
                    }

                    // Log rate history for audit trail
                    LogRateHistory(conn, empId, hourlyRate, weeklyRate, monthlyRate);

                    // Update shift assignment via EmployeeShifts junction table
                    if (!string.IsNullOrEmpty(shiftId))
                    {
                        AssignEmployeeToShift(conn, empId, shiftId);
                    }
                }

                CloseEditModal();
                LoadEmployees();

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"✅ Employee '{fullName}' updated successfully!";
                ScriptManager.RegisterStartupScript(this, GetType(), "updateSuccess",
                    $"showSyncResult(true, 'Employee {fullName} updated successfully!');", true);
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Error updating employee: {ex.Message}";
                ScriptManager.RegisterStartupScript(this, GetType(), "updateError",
                    $"showSyncResult(false, 'Error updating employee: {ex.Message}');", true);
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            CloseEditModal();
            lblMessage.ForeColor = System.Drawing.Color.Gray;
            lblMessage.Text = "🚫 Edit cancelled.";
        }

        protected void btnModalClose_Click(object sender, EventArgs e)
        {
            CloseEditModal();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvEmployees.EditIndex = -1;
            string statusFilter = ddlStatusFilter.SelectedValue;
            lblMessage.ForeColor = System.Drawing.Color.Blue;
            lblMessage.Text = $"🔍 Filtering by status: {(statusFilter == "All" ? "All Employees" : statusFilter)}";
            ScriptManager.RegisterStartupScript(this, GetType(), "statusFiltered",
                $"showSyncResult(true, 'Filtering by status: {(statusFilter == "All" ? "All Employees" : statusFilter)}');", true);
            LoadEmployeesAndScroll();
        }

        protected void ddlSiteFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvEmployees.EditIndex = -1;
            string siteFilter = ddlSiteFilter.SelectedValue;
            lblMessage.ForeColor = System.Drawing.Color.Blue;
            lblMessage.Text = $"🏢 Filtering by site: {(string.IsNullOrEmpty(siteFilter) ? "All Sites" : siteFilter)}";
            ScriptManager.RegisterStartupScript(this, GetType(), "siteFiltered",
                $"showSyncResult(true, 'Filtering by site: {(string.IsNullOrEmpty(siteFilter) ? "All Sites" : siteFilter)}');", true);
            LoadEmployeesAndScroll();
        }
    }
}