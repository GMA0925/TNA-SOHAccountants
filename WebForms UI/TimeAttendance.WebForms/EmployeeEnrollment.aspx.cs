using Newtonsoft.Json;
using Org.BouncyCastle.Asn1.Cmp;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class EmployeeEnrollment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = Session["Role"]?.ToString();
                bool isPrivileged = role == "Admin" || role == "Manager";

                btnEnrollment.Visible = isPrivileged;
                btnSyncToMiddleware.Visible = isPrivileged;

                if (!isPrivileged)
                {
                    //pnlForm.Visible = false;
                    lblMessage.Text = "Access denied. Only Admins and Managers can manage employees.";
                    return;
                }

                LoadSites();
                LoadEmployees();
            }
        }

        private void LoadEmployees()
        {
            string statusFilter = ddlStatusFilter.SelectedValue;
            string query = "SELECT EmployeeId, FullName, Email, Mobile, Role, SiteCode, Status FROM Employees";

            if (statusFilter != "All")
            {
                query += " WHERE Status = @Status";
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (statusFilter != "All")
                {
                    cmd.Parameters.AddWithValue("@Status", statusFilter);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvEmployees.DataSource = dt;
                gvEmployees.DataBind();

                // Scroll into view
                ScriptManager.RegisterStartupScript(this, GetType(), "focusGrid", $@"
            setTimeout(function() {{
                var grid = document.getElementById('{gvEmployees.ClientID}');
                if (grid) {{
                    grid.scrollIntoView({{ behavior: 'smooth', block: 'center' }});
                }}
            }}, 300);
        ", true);
            }
        }



        private void LoadSites()
        {
            ddlSite.Items.Clear();
            ddlSite.Items.Add(new ListItem("-- Select Site --", ""));

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "SELECT SiteId, SiteName, SiteCode FROM Sites ORDER BY SiteName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        string siteId = reader["SiteId"].ToString();
                        string siteName = reader["SiteName"].ToString();
                        string siteCode = reader["SiteCode"].ToString();

                        // Display: "Cape Town | CT002 | SID001" — Value: SiteId
                        ddlSite.Items.Add(new ListItem($"{siteName} | {siteCode} | {siteId}", siteId));
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string empId = txtEmpId.Text.Trim();
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string mobile = txtMobile.Text.Trim();
            string role = ddlRole.SelectedValue;
            string siteCode = ddlSite.SelectedValue;

            if (string.IsNullOrEmpty(empId) || string.IsNullOrEmpty(name) || string.IsNullOrEmpty(siteCode))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "⚠️ Please fill in all required fields: Employee ID, Name, and Site.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = @"
            INSERT INTO Employees (EmployeeId, FullName, Email, Mobile, Role, SiteCode)
            VALUES (@EmployeeId, @FullName, @Email, @Mobile, @Role, @SiteCode)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", empId);
                    cmd.Parameters.AddWithValue("@FullName", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", mobile);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@SiteCode", siteCode);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = $"✅ Employee '{name}' saved successfully! 🎉";

            ClearForm();
            LoadEmployees();
        }

        private void ClearForm()
        {
            txtEmpId.Text = "";
            txtName.Text = "";
            txtEmail.Text = "";
            txtMobile.Text = "";
            ddlRole.SelectedIndex = 0;
            ddlSite.SelectedIndex = 0;

            lblMessage.ForeColor = System.Drawing.Color.Gray;
            lblMessage.Text = "🧹 Form cleared. Ready for a fresh entry!";
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnMiddleware_Click(object sender, EventArgs e)
        {
            // TODO: Replace with actual sync logic
            // Example: Push all employees to middleware API

            try
            {
                // Simulate sync
                int syncedCount = 5; // Replace with actual count

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = $"🔄 Middleware sync completed successfully! {syncedCount} employees pushed. 🚀";
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = $"❌ Middleware sync failed: {ex.Message}";
            }
        }

        protected void btnSyncToMiddleware_Click(object sender, EventArgs e)
        {
            btnSyncToMiddleware.Enabled = false;

            // Show spinner or update button text
            ScriptManager.RegisterStartupScript(this, GetType(), "showSpinner", $@"
        document.getElementById('{btnSyncToMiddleware.ClientID}').innerText = 'Syncing...';
    ", true);

            DataTable dt = GetEmployeesToSync();
            int successCount = 0;
            int failCount = 0;

            foreach (DataRow row in dt.Rows)
            {
                var payload = new
                {
                    EmployeeId = row["EmployeeId"].ToString(),
                    FullName = row["FullName"].ToString(),
                    Email = row["Email"].ToString(),
                    Mobile = row["Mobile"].ToString(),
                    Role = row["Role"].ToString(),
                    SiteCode = row["SiteCode"].ToString()
                };

                bool synced = SendToMiddleware(payload);

                if (synced)
                {
                    UpdateLastSynced(row["EmployeeId"].ToString());
                    successCount++;
                }
                else
                {
                    LogSyncFailure(row["EmployeeId"].ToString(), payload, "Middleware sync failed.");
                    failCount++;
                }
            }

            btnSyncToMiddleware.Enabled = true;

            // Reset button text
            ScriptManager.RegisterStartupScript(this, GetType(), "resetSpinner", $@"
        document.getElementById('{btnSyncToMiddleware.ClientID}').innerText = '🔄 Sync to Middleware';
    ", true);

            lblMessage.ForeColor = System.Drawing.Color.DarkGreen;
            lblMessage.Text = $"✅ Sync complete: {successCount} succeeded, {failCount} failed.";
        }


        private void UpdateLastSynced(string employeeId)
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "UPDATE Employees SET LastSynced = GETDATE() WHERE EmployeeId = @EmployeeId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void LogSyncFailure(string employeeId, object payload, string errorMessage)
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "INSERT INTO SyncLog (EmployeeId, Payload, ErrorMessage) VALUES (@EmployeeId, @Payload, @ErrorMessage)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
                    cmd.Parameters.AddWithValue("@Payload", JsonConvert.SerializeObject(payload));
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
                using (HttpClient client = new HttpClient())
                {
                    string apiUrl = "https://your-middleware-endpoint/api/employees/sync";
                    var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");

                    HttpResponseMessage response = client.PostAsync(apiUrl, content).Result;
                    return response.IsSuccessStatusCode;
                }
            }
            catch (Exception ex)
            {
                // Log error
                return false;
            }
        }


        private DataTable GetEmployeesToSync()
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "SELECT EmployeeId, FullName, Email, Mobile, Role, SiteCode FROM Employees WHERE Status = 'Active'";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }


        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reports.aspx");
        }

        protected void btnSyncLog_Click(object sender, EventArgs e)
        {
            Response.Redirect("SyncLog.aspx");
        }

        protected void btnUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserManagement.aspx");
        }

        protected void btnConfig_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConfigTools.aspx");
        }

        protected void btnEnrollment_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeEnrollment.aspx");
        }

        protected void gvEmployees_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvEmployees.EditIndex = e.NewEditIndex;
            LoadEmployees();

            GridViewRow row = gvEmployees.Rows[e.NewEditIndex];

            // Get current values from DataKeys
            string currentRole = gvEmployees.DataKeys[e.NewEditIndex]["Role"].ToString();
            string currentSiteCode = gvEmployees.DataKeys[e.NewEditIndex]["SiteCode"].ToString();
            string currentStatus = gvEmployees.DataKeys[e.NewEditIndex]["Status"].ToString();

            // Populate Role dropdown
            DropDownList ddlRole = (DropDownList)row.FindControl("ddlEditRole");
            if (ddlRole != null)
            {
                ddlRole.DataSource = new List<string> { "Admin", "Manager", "User" };
                ddlRole.DataBind();
                ddlRole.SelectedValue = currentRole;
            }

            // Populate Site dropdown
            DropDownList ddlSite = (DropDownList)row.FindControl("ddlEditSite");
            if (ddlSite != null)
            {
                ddlSite.DataSource = GetSites(); // Ensure this returns a DataTable with SiteCode
                ddlSite.DataTextField = "SiteCode";
                ddlSite.DataValueField = "SiteCode";
                ddlSite.DataBind();
                ddlSite.SelectedValue = currentSiteCode;
            }

            // Populate Status dropdown
            DropDownList ddlStatus = (DropDownList)row.FindControl("ddlEditStatus");
            if (ddlStatus != null)
            {
                ddlStatus.SelectedValue = currentStatus;
            }

            // Inject JavaScript to scroll and focus on Role dropdown
            ScriptManager.RegisterStartupScript(this, GetType(), "focusRow", $@"
        setTimeout(function() {{
            var ddl = document.getElementById('{ddlRole.ClientID}');
            if (ddl) {{
                ddl.scrollIntoView({{ behavior: 'smooth', block: 'center' }});
                ddl.focus();
            }}
        }}, 300);
    ", true);

            lblMessage.ForeColor = System.Drawing.Color.Blue;
            lblMessage.Text = "✏️ Editing employee record...";
        }




        protected void gvEmployees_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvEmployees.Rows[e.RowIndex];

            string empId = gvEmployees.DataKeys[e.RowIndex].Value.ToString();
            string fullName = ((TextBox)row.Cells[1].Controls[0]).Text.Trim();
            string email = ((TextBox)row.Cells[2].Controls[0]).Text.Trim();
            string mobile = ((TextBox)row.Cells[3].Controls[0]).Text.Trim();

            DropDownList ddlRole = (DropDownList)row.FindControl("ddlEditRole");
            string role = ddlRole?.SelectedValue;

            DropDownList ddlSite = (DropDownList)row.FindControl("ddlEditSite");
            string siteCode = ddlSite?.SelectedValue;

            DropDownList ddlStatus = (DropDownList)row.FindControl("ddlEditStatus");
            string status = ddlStatus?.SelectedValue;

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = @"
        UPDATE Employees
        SET FullName = @FullName,
            Email = @Email,
            Mobile = @Mobile,
            Role = @Role,
            SiteCode = @SiteCode,
            Status = @Status
        WHERE EmployeeId = @EmployeeId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", empId);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", mobile);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@SiteCode", siteCode);
                    cmd.Parameters.AddWithValue("@Status", status);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvEmployees.EditIndex = -1;
            LoadEmployees(); // Refresh the grid
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = $"✅ Employee '{fullName}' updated successfully!";
        }



        protected void gvEmployees_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvEmployees.EditIndex = -1;
            LoadEmployees();
            lblMessage.ForeColor = System.Drawing.Color.Gray;
            lblMessage.Text = "🚫 Edit cancelled.";
        }

        private DataTable GetSites()
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "SELECT SiteCode FROM Sites ORDER BY SiteCode";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvEmployees.EditIndex = -1; // cancel any edit mode
            LoadEmployees();
            ScriptManager.RegisterStartupScript(this, GetType(), "focusGrid", $@"
                setTimeout(function() {{
                    var grid = document.getElementById('{gvEmployees.ClientID}');
                    if (grid) {{
                        grid.scrollIntoView({{ behavior: 'smooth', block: 'center' }});
                    }}
                }}, 300);
            ", true);

        }
    }
}