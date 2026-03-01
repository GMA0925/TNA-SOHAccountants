using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Panel pnlChart;
        public string SiteId = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadReaderPendingChart();
                LoadSyncStatusChart();
                LoadHourlyActivityChart();
                LoadTopUsersChart();
                string username = Session["NameSurname"].ToString();
                string role = Session["Role"]?.ToString()?.Trim();
                pnlAdmin.Visible = role == "Admin";
                pnlUser.Visible = role == "User";
                btnSyncLog.Visible = role == "Admin";
                btnConfig.Visible = role == "Admin";
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

                chart3.Series.Clear();
                Series series = new Series("TopUsers");
                series.ChartType = SeriesChartType.Bar;
                series.XValueMember = "PersonName";
                series.YValueMembers = "Events";
                chart3.Series.Add(series);

                chart3.DataSource = dt;
                chart3.DataBind();
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

                chart2.Series.Clear();
                Series series = new Series("HourlyEvents");
                series.ChartType = SeriesChartType.Line;
                series.XValueMember = "Hour";
                series.YValueMembers = "Events";
                chart2.Series.Add(series);

                chart2.DataSource = dt;
                chart2.DataBind();
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

                // Transform EventType values to descriptive labels
                DataTable dt = new DataTable();
                dt.Columns.Add("Status", typeof(string));
                dt.Columns.Add("Count", typeof(int));

                foreach (DataRow row in dtRaw.Rows)
                {
                    string eventType = row["EventType"].ToString();
                    int count = Convert.ToInt32(row["Count"]);
                    dt.Rows.Add(eventType, count);
                }

                chart1.Series.Clear();
                Series series = new Series("EventType");
                series.ChartType = SeriesChartType.Pie;
                series.XValueMember = "Status";
                series.YValueMembers = "Count";

                // Show labels with counts
                series.IsValueShownAsLabel = true;
                series.Label = "#VALX (#VALY)";
                // Example: "AccessGranted (42)"

                chart1.Series.Add(series);

                chart1.DataSource = dt;
                chart1.DataBind();
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

                chartPendingTx.Series.Clear();
                Series series = new Series("TX");
                series.ChartType = SeriesChartType.Column;
                series.XValueMember = "DeviceIP";
                series.YValueMembers = "TX";
                chartPendingTx.Series.Add(series);

                chartPendingTx.DataSource = dt;
                chartPendingTx.DataBind();
            }
        }



        private void LoadUserChart()
        {
            string connStr = Properties.Settings.Default.SQLCon; // your preferred connection string
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

                chartPendingTx.Series.Clear();
                Series series = new Series("ClockEvents");
                series.ChartType = SeriesChartType.Column;
                series.XValueMember = "UserName";
                series.YValueMembers = "ClockEvents";
                chartPendingTx.Series.Add(series);

                chartPendingTx.DataSource = dt;
                chartPendingTx.DataBind();
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

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void btnEnrollment_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeEnrollment.aspx");
        }
    }
}