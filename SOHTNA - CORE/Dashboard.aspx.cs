using System;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Newtonsoft.Json;

namespace TimeAttendance.WebForms
{
    public partial class Dashboard
    {
        // protected Panel pnlChart; // System.Web.UI.WebControls.Panel is not available. You may need to migrate this to a supported UI framework.
        public string SiteId = "";

        private string ToChartJson(List<string> labels, List<int> values)
        {
            return JsonConvert.SerializeObject(new { labels = labels, values = values });
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                // Display Assembly Version
                System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
                System.Reflection.AssemblyName assemblyName = assembly.GetName();
                lblVersion.Text = string.Format("v{0}", assemblyName.Version.ToString());

                LoadReaderPendingChart();
                LoadSyncStatusChart();
                LoadHourlyActivityChart();
                LoadTopUsersChart();
                string username = Session.GetString("NameSurname");
                string role = Session["Role"]?.ToString()?.Trim();
                pnlAdmin.Visible = role == "Admin";
                pnlUser.Visible = role == "User";
                lblWelcome.Text = "Welcome, " + username+" - Role: "+role;

                if (role != null && role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                {
                    pnlAdmin.Visible = true;

                    // SQL Connection Check
                    // SQL Connection Check
                    try
                    {
                        using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                        {
                            conn.Open();
                            lblSqlStatus.Text = "Connected";

                            // Last Sync Timestamp (latest event)
                            using (SqlCommand cmd = new SqlCommand("SELECT MAX(Timestamp) FROM ReaderEvents", conn))
                            {
                                object result = cmd.ExecuteScalar();
                                lblLastSync.Text = result != DBNull.Value ? Convert.ToDateTime(result).ToString("yyyy-MM-dd HH:mm:ss") : "No Data";
                            }

                            // Active Users (distinct PersonName in last 24h)
                            using (SqlCommand cmd = new SqlCommand(@"
            SELECT COUNT(DISTINCT PersonName)
            FROM ReaderEvents
            WHERE Timestamp >= DATEADD(DAY, -1, GETDATE())", conn))
                            {
                                lblActiveUsers.Text = cmd.ExecuteScalar().ToString();
                            }

                            // Pending Transactions (IsEmulated = 1)
                            using (SqlCommand cmd = new SqlCommand(@"
            SELECT COUNT(*)
            FROM ReaderEvents
            WHERE IsEmulated = 1", conn))
                            {
                                lblPendingTx.Text = cmd.ExecuteScalar().ToString();
                            }

                            // Cloud Buffer Health (example: count of unsynced payloads)
                            using (SqlCommand cmd = new SqlCommand(@"
            SELECT COUNT(*)
            FROM ReaderEvents
            WHERE PayloadRaw IS NOT NULL AND IsEmulated = 1", conn))
                            {
                                int bufferCount = Convert.ToInt32(cmd.ExecuteScalar());
                                lblCloudBuffer.Text = bufferCount < 10 ? "Healthy" : "Backlogged";
                            }

                            // Config Status (example: check if any ReaderId is null)
                            using (SqlCommand cmd = new SqlCommand(@"
            SELECT COUNT(*)
            FROM ReaderEvents
            WHERE ReaderId IS NULL", conn))
                            {
                                int configIssues = Convert.ToInt32(cmd.ExecuteScalar());
                                lblConfigStatus.Text = configIssues == 0 ? "Valid" : "Issues Found";
                            }
                        }
                    }
                    catch
                    {
                        lblSqlStatus.Text = "Connection Failed";
                        lblLastSync.Text = "-";
                        lblActiveUsers.Text = "-";
                        lblPendingTx.Text = "-";
                        lblCloudBuffer.Text = "-";
                        lblConfigStatus.Text = "-";
                    }
                }
            }
        }

        private void LoadTopUsersChart()
        {
            string connStr = Properties.Settings.Default.SQLCon;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT TOP 10 PersonName, COUNT(*) AS Events
            FROM ReaderEvents
            WHERE PersonName IS NOT NULL AND PersonName <> ''
            GROUP BY PersonName
            ORDER BY Events DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                var labels = new List<string>();
                var values = new List<int>();
                foreach (DataRow row in dt.Rows)
                {
                    labels.Add(row["PersonName"].ToString());
                    values.Add(Convert.ToInt32(row["Events"]));
                }
                hfTopUsersData.Value = ToChartJson(labels, values);
            }
        }


        private void LoadHourlyActivityChart()
        {
            string connStr = Properties.Settings.Default.SQLCon;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT DATEPART(HOUR, Timestamp) AS Hour, COUNT(*) AS Events
            FROM ReaderEvents
            WHERE Timestamp >= DATEADD(DAY, -1, GETDATE())
            GROUP BY DATEPART(HOUR, Timestamp)
            ORDER BY Hour";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                var labels = new List<string>();
                var values = new List<int>();
                foreach (DataRow row in dt.Rows)
                {
                    labels.Add(row["Hour"].ToString());
                    values.Add(Convert.ToInt32(row["Events"]));
                }
                hfHourlyData.Value = ToChartJson(labels, values);
            }
        }


        private void LoadSyncStatusChart()
        {
            string connStr = Properties.Settings.Default.SQLCon;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT EventType, COUNT(*) AS Count
            FROM ReaderEvents
            GROUP BY EventType";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dtRaw = new DataTable();
                da.Fill(dtRaw);

                var labels = new List<string>();
                var values = new List<int>();
                foreach (DataRow row in dtRaw.Rows)
                {
                    labels.Add(row["EventType"].ToString());
                    values.Add(Convert.ToInt32(row["Count"]));
                }
                hfSyncStatusData.Value = ToChartJson(labels, values);
            }
        }




        private void LoadReaderPendingChart()
        {
            string connStr = Properties.Settings.Default.SQLCon;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT DeviceIP, COUNT(*) AS TX 
            FROM ReaderEvents
            GROUP BY DeviceIP
            ORDER BY DeviceIP";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                var labels = new List<string>();
                var values = new List<int>();
                foreach (DataRow row in dt.Rows)
                {
                    labels.Add(row["DeviceIP"].ToString());
                    values.Add(Convert.ToInt32(row["TX"]));
                }
                hfPendingTxData.Value = ToChartJson(labels, values);
            }
        }



        private void LoadUserChart()
        {
            string connStr = Properties.Settings.Default.SQLCon;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT UserName, COUNT(*) AS ClockEvents
            FROM ClockLog
            WHERE EventDate >= DATEADD(DAY, -7, GETDATE())
            GROUP BY UserName
            ORDER BY UserName";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                var labels = new List<string>();
                var values = new List<int>();
                foreach (DataRow row in dt.Rows)
                {
                    labels.Add(row["UserName"].ToString());
                    values.Add(Convert.ToInt32(row["ClockEvents"]));
                }
                hfPendingTxData.Value = ToChartJson(labels, values);
            }
        }

        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Dashboard.aspx");
        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Reports.aspx");
        }

        protected void btnSyncLog_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/SyncLog.aspx");
        }

        protected void btnUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/UserManagement.aspx");
        }

        protected void btnConfig_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ConfigTools.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

        protected void btnEmployees_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Employees.aspx");
        }

        protected void btnShiftManagement_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ShiftManagement.aspx");
        }
    }
}