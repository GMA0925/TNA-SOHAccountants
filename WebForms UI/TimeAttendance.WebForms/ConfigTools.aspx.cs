using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class ConfigTools : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblConfigMessage.Text = "🛠️ Configuration panel loaded.";
                // Optional:
                LoadConfigSettings(); LoadRoles();
            }
        }

        private void LoadRoles()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT RoleName FROM Roles ORDER BY RoleName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlDefaultRole.Items.Clear();
                        while (reader.Read())
                        {
                            string role = reader["RoleName"].ToString();
                            ddlDefaultRole.Items.Add(new ListItem(role, role));
                        }
                    }
                }
            }
        }


        private void LoadConfigSettings()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT SettingKey, SettingValue FROM ConfigSettings";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string key = reader["SettingKey"].ToString();
                            string value = reader["SettingValue"].ToString();

                            switch (key)
                            {
                                case "SiteCode":
                                    txtSiteCode.Text = value;
                                    break;
                                case "SyncEndpoint":
                                    txtSyncEndpoint.Text = value;
                                    break;
                                case "EnableMiddleware":
                                    ddlMiddlewareToggle.SelectedValue = value.ToLower();
                                    break;
                                case "DefaultRole":
                                    ddlDefaultRole.SelectedValue = value;
                                    break;
                            }
                        }
                    }
                }
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

        protected void btnSaveConfig_Click(object sender, EventArgs e)
        {
            string connStr = Properties.Settings.Default.SQLCon;

            Dictionary<string, string> settings = new Dictionary<string, string>
                {
                    { "SiteCode", txtSiteCode.Text.Trim() },
                    { "SyncEndpoint", txtSyncEndpoint.Text.Trim() },
                    { "EnableMiddleware", ddlMiddlewareToggle.SelectedValue },
                    { "DefaultRole", ddlDefaultRole.SelectedValue }
                };

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                foreach (var kvp in settings)
                {
                    string query = @"
                MERGE INTO ConfigSettings AS target
                USING (SELECT @Key AS SettingKey) AS source
                ON target.SettingKey = source.SettingKey
                WHEN MATCHED THEN
                    UPDATE SET SettingValue = @Value
                WHEN NOT MATCHED THEN
                    INSERT (SettingKey, SettingValue) VALUES (@Key, @Value);";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Key", kvp.Key);
                        cmd.Parameters.AddWithValue("@Value", kvp.Value);
                        cmd.ExecuteNonQuery();
                    }

                    LogAudit("ConfigTools", $"Updated setting '{kvp.Key}' to '{kvp.Value}'");
                }
            }

            lblConfigMessage.Text = "✅ Configuration saved successfully.";
        }

        private void LogAudit(string module, string action)
        {
            string connStr = Properties.Settings.Default.SQLCon;
            string user = Session["Username"]?.ToString() ?? "Unknown";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO AuditLog (Username, Module, Action, Timestamp) VALUES (@User, @Module, @Action, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@User", user);
                    cmd.Parameters.AddWithValue("@Module", module);
                    cmd.Parameters.AddWithValue("@Action", action);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }


        protected void btnClearConfig_Click(object sender, EventArgs e)
        {
            txtSiteCode.Text = "";
            txtSyncEndpoint.Text = "";
            ddlMiddlewareToggle.ClearSelection();
            ddlDefaultRole.ClearSelection();
            lblConfigMessage.Text = "🧹 Configuration fields cleared.";
        }
    }
}