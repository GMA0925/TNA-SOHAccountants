using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadSites();
                txtFromDate.Text = DateTime.Today.AddDays(-30).ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd");
            }
        }

        private void LoadSites()
        {
            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                string query = "SELECT SiteName, SiteCode FROM Sites WHERE IsActive = 1 ORDER BY SiteName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlSites.Items.Clear();
                    ddlSites.Items.Add(new System.Web.UI.WebControls.ListItem("Select a site", ""));

                    while (reader.Read())
                    {
                        string siteName = reader["SiteName"].ToString();
                        string siteCode = reader["SiteCode"].ToString();
                        string displayText = $"{siteName} | {siteCode}";

                        ddlSites.Items.Add(new System.Web.UI.WebControls.ListItem(displayText, displayText));
                    }
                }
            }
        }

        private string ExtractSiteCode(string selectedText)
        {
            if (string.IsNullOrEmpty(selectedText)) return null;

            string[] parts = selectedText.Split('|');
            return parts.Length == 2 ? parts[1].Trim() : null;
        }



        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            string reportType = ddlReportType.SelectedValue?.Trim();
            DateTime fromDate, toDate;

            // Validate start date
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter a valid start date.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            // If user entered an end date, parse it; otherwise default to end of today
            if (!DateTime.TryParse(txtToDate.Text, out toDate))
            {
                // End of today at 23:59:59
                toDate = DateTime.Today.AddDays(1).AddSeconds(-1);
            }
            else
            {
                // If the chosen end date is today, force it to 23:59:59
                if (toDate.Date == DateTime.Today)
                {
                    toDate = DateTime.Today.AddDays(1).AddSeconds(-1);
                }
            }

            // Force end date to 23:59:59 of that day
            toDate = toDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59);

            // Dispatch to appropriate report generator
            switch (reportType)
            {
                case "Site":
                    GenerateSiteReport(fromDate, toDate);
                    break;
                case "Person":
                    GeneratePersonReport(fromDate, toDate);
                    break;
                case "Shift":
                    GenerateShiftReport(fromDate, toDate);
                    break;
                case "Reader":
                    GenerateReaderReport(fromDate, toDate);
                    break;
                case "Emulated":
                    GenerateEmulatedReport(fromDate, toDate);
                    break;
                case "SyncFail":
                    GenerateSyncFailureReport(fromDate, toDate);
                    break;
                case "Hourly":
                    GenerateHourlyActivityReport(fromDate, toDate);
                    break;
                case "TopUsers":
                    GenerateTopUsersReport(fromDate, toDate);
                    break;
                case "Missing":
                    GenerateMissingScansReport(fromDate, toDate);
                    break;
                case "Rollup":
                    GenerateRollupReport(fromDate, toDate);
                    break;
                default:
                    lblMessage.Text = "Please select a valid report type.";
                    break;
            }
        }



        private void GenerateRollupReport(DateTime fromDate, DateTime toDate)
        {
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
        SELECT 
            CAST(r.SiteId AS NVARCHAR(MAX)) AS SiteId,
            s.SiteName,
            COUNT(*) AS TotalScans,
            MIN(r.Timestamp) AS FirstScan,
            MAX(r.Timestamp) AS LastScan,
            CASE 
                WHEN MIN(r.Timestamp) = MAX(r.Timestamp) THEN 'N/A'
                ELSE 
                    CAST(DATEDIFF(HOUR, MIN(r.Timestamp), MAX(r.Timestamp)) AS VARCHAR(2)) + 'h ' +
                    CAST(DATEDIFF(MINUTE, MIN(r.Timestamp), MAX(r.Timestamp)) % 60 AS VARCHAR(2)) + 'm ' +
                    CAST(DATEDIFF(SECOND, MIN(r.Timestamp), MAX(r.Timestamp)) % 60 AS VARCHAR(2)) + 's'
            END AS TimeSpent
        FROM ReaderEvents r
        INNER JOIN Sites s ON CAST(r.SiteId AS NVARCHAR(MAX)) = CAST(s.SiteId AS NVARCHAR(MAX))
        WHERE r.Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND r.PersonName = @PersonName";
                }

                query += @"
        GROUP BY CAST(r.SiteId AS NVARCHAR(MAX)), s.SiteName
        ORDER BY TotalScans DESC;";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Rollup report generated: {dt.Rows.Count} site(s) summarized between {dateRange}."
                        : $"No scan activity found across sites between {dateRange}.";
                }
            }
        }





        private void GenerateMissingScansReport(DateTime fromDate, DateTime toDate)
        {
            string inputName = txtPerson.Text?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            // Restrict non-admins to their own name
            string personName = (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) ||
                                 string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                                 ? inputName
                                 : currentUser;

            if (string.IsNullOrEmpty(personName))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter a valid person name.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
            WITH ExpectedDates AS (
                SELECT CAST(@From AS DATE) + number AS ScanDate
                FROM master..spt_values
                WHERE type = 'P' AND number <= DATEDIFF(DAY, @From, @To)
            )
            SELECT e.ScanDate
            FROM ExpectedDates e
            LEFT JOIN ReaderEvents r
              ON CAST(r.Timestamp AS DATE) = e.ScanDate
              AND r.PersonName = @PersonName
            WHERE r.PersonName IS NULL
            ORDER BY e.ScanDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PersonName", personName);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Missing scan report generated: {dt.Rows.Count} events with no scans for '{personName}' between {dateRange}."
                        : $"No missing scans found for '{personName}' between {dateRange}.";
                }
            }
        }



        private void GenerateTopUsersReport(DateTime fromDate, DateTime toDate)
        {
            string siteId = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(siteId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
        SELECT 
            PersonName,
            COUNT(*) AS ScanCount,
            MIN(Timestamp) AS FirstScan,
            MAX(Timestamp) AS LastScan,
            CASE 
                WHEN MIN(Timestamp) = MAX(Timestamp) THEN 'N/A'
                ELSE 
                    CAST(DATEDIFF(HOUR, MIN(Timestamp), MAX(Timestamp)) AS VARCHAR(2)) + 'h ' +
                    CAST(DATEDIFF(MINUTE, MIN(Timestamp), MAX(Timestamp)) % 60 AS VARCHAR(2)) + 'm ' +
                    CAST(DATEDIFF(SECOND, MIN(Timestamp), MAX(Timestamp)) % 60 AS VARCHAR(2)) + 's'
            END AS TimeSpent
        FROM ReaderEvents
        WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
          AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND PersonName = @PersonName";
                }

                query += @"
        GROUP BY PersonName
        ORDER BY ScanCount DESC;";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", siteId);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Top users report generated: {dt.Rows.Count} user(s) ranked by scan count for site '{siteId}' between {dateRange}."
                        : $"No scan activity found for site '{siteId}' between {dateRange}.";
                }
            }
        }




        private void GenerateHourlyActivityReport(DateTime fromDate, DateTime toDate)
        {
            string siteId = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(siteId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
            SELECT DATEPART(HOUR, Timestamp) AS HourOfDay,
                   COUNT(*) AS ScanCount
            FROM ReaderEvents
            WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
              AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND PersonName = @PersonName";
                }

                query += @"
            GROUP BY DATEPART(HOUR, Timestamp)
            ORDER BY HourOfDay";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", siteId);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Hourly activity report generated: {dt.Rows.Count} hourly buckets found for site '{siteId}' between {dateRange}."
                        : $"No scan activity found for site '{siteId}' between {dateRange}.";
                }
            }
        }



        private void GenerateSyncFailureReport(DateTime fromDate, DateTime toDate)
        {
            string siteId = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(siteId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
            SELECT ReaderId, PersonName, Timestamp, SyncStatus, ErrorMessage
            FROM ReaderEvents
            WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
              AND SyncStatus = 'Failed'
              AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND PersonName = @PersonName";
                }

                query += " ORDER BY Timestamp DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", siteId);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Sync failure report generated: {dt.Rows.Count} failed records found for site '{siteId}' between {dateRange}."
                        : $"No sync failures found for site '{siteId}' between {dateRange}.";
                }
            }
        }



        private void GenerateEmulatedReport(DateTime fromDate, DateTime toDate)
        {
            string siteId = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(siteId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
            SELECT ReaderId, PersonName, Timestamp, IsEmulated
            FROM ReaderEvents
            WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
              AND IsEmulated = 1
              AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND PersonName = @PersonName";
                }

                query += " ORDER BY Timestamp DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", siteId);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Emulated report generated: {dt.Rows.Count} emulated scans found for site '{siteId}' between {dateRange}."
                        : $"No emulated scans found for site '{siteId}' between {dateRange}.";
                }
            }
        }



        private void GenerateReaderReport(DateTime fromDate, DateTime toDate)
        {
            string readerId = txtReader.Text.Trim();
            //string [] itemReaderReport=ddlSites.Items.ToString().Split('-');
            string SiteCode = Session["SiteId"].ToString();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(readerId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter a Reader ID.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            if (string.IsNullOrEmpty(readerId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a valid site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            // Normalize toDate to end of day (23:59:59)
            toDate = toDate.Date.AddDays(1).AddSeconds(-1);

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string query = @"
SELECT ReaderId, PersonName, Timestamp, IsEmulated, DeviceIP 
FROM ReaderEvents
WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
  AND ReaderId = @ReaderId
  AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    query += " AND PersonName = @PersonName";
                }

                query += " ORDER BY Timestamp DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", SiteCode);
                    cmd.Parameters.AddWithValue("@ReaderId", readerId);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd HH:mm:ss} to {toDate:yyyy-MM-dd HH:mm:ss}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Reader report generated: {dt.Rows.Count} records found for Reader ID '{readerId}' at site '{SiteCode}' between {dateRange}."
                        : $"No records found for Reader ID '{readerId}' at site '{SiteCode}' between {dateRange}.";
                }
            }
        }




        private void GenerateShiftReport(DateTime fromDate, DateTime toDate)
        {
            string shiftCode = txtShift.Text?.Trim();
            string siteId = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(shiftCode))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter a shift code.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            if (string.IsNullOrEmpty(siteId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a valid site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
            {
                conn.Open();

                string summaryQuery = @"
        SELECT 
            CONVERT(DATE, Timestamp) AS WorkDate,
            PersonName,
            MIN(Timestamp) AS ClockIn,
            MAX(Timestamp) AS ClockOut,
            ShiftCode,
            CASE 
                WHEN MIN(Timestamp) = MAX(Timestamp) THEN 'Still Inside'
                ELSE 'Clocked Out'
            END AS Status,
            CASE 
                WHEN MIN(Timestamp) = MAX(Timestamp) THEN 'N/A'
                ELSE 
                    CAST(DATEDIFF(HOUR, MIN(Timestamp), MAX(Timestamp)) AS VARCHAR(2)) + 'h ' +
                    CAST(DATEDIFF(MINUTE, MIN(Timestamp), MAX(Timestamp)) % 60 AS VARCHAR(2)) + 'm'
            END AS TimeSpent
        FROM ReaderEvents
        WHERE CAST(SiteId AS NVARCHAR(MAX)) = @SiteId
          AND ShiftCode = @ShiftCode
          AND Timestamp BETWEEN @From AND @To";

                // Restrict non-admins to their own data
                if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                    !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                {
                    summaryQuery += " AND PersonName = @PersonName";
                }

                summaryQuery += " GROUP BY CONVERT(DATE, Timestamp), PersonName, ShiftCode ORDER BY WorkDate DESC;";

                using (SqlCommand cmd = new SqlCommand(summaryQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@SiteId", siteId);
                    cmd.Parameters.AddWithValue("@ShiftCode", shiftCode);
                    cmd.Parameters.AddWithValue("@From", fromDate);
                    cmd.Parameters.AddWithValue("@To", toDate);

                    if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                        !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", currentUser ?? string.Empty);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgvReport.DataSource = dt;
                    dgvReport.DataBind();

                    string dateRange = $"{fromDate:yyyy-MM-dd} to {toDate:yyyy-MM-dd}";
                    lblMessage.Text = dt.Rows.Count > 0
                        ? $"Shift report generated: {dt.Rows.Count} record(s) found for shift '{shiftCode}' at site '{siteId}' between {dateRange}."
                        : $"No records found for shift '{shiftCode}' at site '{siteId}' between {dateRange}.";
                }
            }
        }




        private void GeneratePersonReport(DateTime fromDate, DateTime toDate)
        {
            string inputName = txtPerson.Text?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            // Restrict non-admins to their own name
            string personName = (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) ||
                                 string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase))
                                 ? inputName
                                 : currentUser;

            if (string.IsNullOrEmpty(personName))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter a valid person name.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            // Normalize toDate to end of day (23:59:59)
            toDate = toDate.Date.AddDays(1).AddSeconds(-1);

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    string summaryQuery = @"
SELECT 
    CONVERT(DATE, Timestamp) AS WorkDate,
    PersonName,
    MIN(Timestamp) AS ClockIn,
    MAX(Timestamp) AS ClockOut,
    CASE 
        WHEN MIN(Timestamp) = MAX(Timestamp) THEN 'Still Inside'
        ELSE 'Clocked Out'
    END AS Status,
    CASE 
        WHEN MIN(Timestamp) = MAX(Timestamp) THEN 'N/A'
        ELSE 
            CAST(DATEDIFF(HOUR, MIN(Timestamp), MAX(Timestamp)) AS VARCHAR(2)) + 'h ' +
            CAST(DATEDIFF(MINUTE, MIN(Timestamp), MAX(Timestamp)) % 60 AS VARCHAR(2)) + 'm ' +
            CAST(DATEDIFF(SECOND, MIN(Timestamp), MAX(Timestamp)) % 60 AS VARCHAR(2)) + 's'
    END AS TimeSpent
FROM ReaderEvents
WHERE PersonName LIKE @PersonName
  AND Timestamp BETWEEN @From AND @To 
GROUP BY CONVERT(DATE, Timestamp), PersonName
ORDER BY WorkDate DESC;";

                    using (SqlCommand cmd = new SqlCommand(summaryQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@PersonName", "%" + personName + "%");
                        cmd.Parameters.AddWithValue("@From", fromDate);
                        cmd.Parameters.AddWithValue("@To", toDate);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Fallback to raw scan history if no summary rows
                        if (dt.Rows.Count == 0)
                        {
                            string fallbackQuery = @"
SELECT 
    ReaderId,
    PersonName,
    Timestamp,
    EventType,
    CardNumber,
    SiteId
FROM ReaderEvents
WHERE PersonName LIKE @PersonName
  AND Timestamp BETWEEN @From AND @To
ORDER BY Timestamp DESC;";

                            cmd.CommandText = fallbackQuery;
                            dt.Clear();
                            da.Fill(dt);

                            lblMessage.Text = dt.Rows.Count > 0
                                ? $"No summary found — showing raw scan history: {dt.Rows.Count} records for '{personName}'."
                                : $"No records found for '{personName}' in the selected date range.";
                        }
                        else
                        {
                            lblMessage.Text = $"Report generated: {dt.Rows.Count} activities found for '{personName}'.";
                        }

                        dgvReport.DataSource = dt;
                        dgvReport.DataBind();
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                lblMessage.Text = "SQL error occurred while generating the report.";
                System.Diagnostics.Debug.WriteLine("SQL error: " + sqlEx.ToString());
            }
            catch (Exception ex)
            {
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                lblMessage.Text = "Unexpected error occurred while generating the report.";
                System.Diagnostics.Debug.WriteLine("General error: " + ex.ToString());
            }
        }







        private void GenerateSiteReport(DateTime fromDate, DateTime toDate)
        {
            dgvReport.DataSource = null; 
            dgvReport.DataBind();
            string selectedValue = ddlSites.SelectedValue?.Trim();
            string currentUser = Session["UserName"]?.ToString();
            string role = Session["Role"]?.ToString();

            if (string.IsNullOrEmpty(selectedValue) || !selectedValue.Contains("|"))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a valid site.');", true);
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            string[] parts = selectedValue.Split('|');
            string siteId = parts.Length > 1 ? parts[1].Trim() : null;

            if (string.IsNullOrEmpty(siteId))
            {
                lblMessage.Text = "Site ID could not be extracted.";
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(Properties.Settings.Default.SQLCon))
                {
                    conn.Open();

                    var sb = new StringBuilder();
                    sb.AppendLine("SELECT ReaderId, PersonName, Timestamp, EventType, CardNumber, SiteId");
                    sb.AppendLine("FROM ReaderEvents");
                    sb.AppendLine("WHERE SiteId = @SiteId");
                    sb.AppendLine("  AND Timestamp BETWEEN @From AND @To");


                    bool restrictToPerson = !string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) &&
                                            !string.Equals(role, "Manager", StringComparison.OrdinalIgnoreCase);

                    if (restrictToPerson)
                    {
                        sb.AppendLine("  AND PersonName = @PersonName");
                    }

                    // Single, final ORDER BY only
                    sb.AppendLine("ORDER BY PersonName, Timestamp ASC;");

                    using (SqlCommand cmd = new SqlCommand(sb.ToString(), conn))
                    {
                        cmd.Parameters.Add("@SiteId", SqlDbType.NVarChar).Value = siteId;
                        cmd.Parameters.Add("@From", SqlDbType.DateTime).Value = fromDate;
                        cmd.Parameters.Add("@To", SqlDbType.DateTime).Value = toDate; 

                        if (restrictToPerson)
                        {
                            cmd.Parameters.Add("@PersonName", SqlDbType.NVarChar, 200).Value = currentUser ?? string.Empty;
                        }

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable raw = new DataTable();
                        da.Fill(raw);

                        // Build summary table
                        DataTable summary = new DataTable();
                        summary.Columns.Add("PersonName", typeof(string));
                        summary.Columns.Add("WorkDate", typeof(DateTime));
                        summary.Columns.Add("ClockIn", typeof(DateTime));
                        summary.Columns.Add("ClockOut", typeof(DateTime));
                        summary.Columns.Add("TimeSpent", typeof(string));

                        var grouped = raw.AsEnumerable()
                            .GroupBy(row => new
                            {
                                Person = row.Field<string>("PersonName"),
                                Date = row.Field<DateTime>("Timestamp").Date
                            });

                        foreach (var group in grouped)
                        {
                            var firstEvent = group.OrderBy(r => r.Field<DateTime>("Timestamp")).FirstOrDefault();
                            var lastEvent = group.OrderByDescending(r => r.Field<DateTime>("Timestamp")).FirstOrDefault();

                            string timeSpent = "NOT Signed Out";
                            if (firstEvent != null && lastEvent != null && firstEvent != lastEvent)
                            {
                                TimeSpan duration = lastEvent.Field<DateTime>("Timestamp") - firstEvent.Field<DateTime>("Timestamp");
                                timeSpent = $"{(int)duration.TotalHours:D2}h {duration.Minutes:D2}m";
                            }

                            summary.Rows.Add(
                                group.Key.Person,
                                group.Key.Date,
                                firstEvent?["Timestamp"],
                                lastEvent?["Timestamp"],
                                timeSpent
                            );
                        }

                        dgvReport.DataSource = summary;
                        dgvReport.DataBind();

                        lblMessage.Text = summary.Rows.Count > 0
                            ? $"Site report generated: {summary.Rows.Count} events of activity found for site '{siteId}'."
                            : $"No records found for site '{siteId}' in the selected date range.";
                    }
                }
            }
            catch (Exception ex)
            {
                dgvReport.DataSource = null;
                dgvReport.DataBind();
                lblMessage.Text = "An error occurred while generating the site report.";
                System.Diagnostics.Debug.WriteLine("Error in GenerateSiteReport: " + ex.ToString());
            }
        }


        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            if (dgvReport.Rows.Count == 0)
            {
                lblMessage.Text = "No data to export.";
                return;
            }

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=ReportExport.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            using (StringWriter sw = new StringWriter())
            using (HtmlTextWriter hw = new HtmlTextWriter(sw))
            {
                // Optional: disable paging if it's enabled
                if (dgvReport.AllowPaging)
                {
                    dgvReport.AllowPaging = false;
                    dgvReport.DataBind();
                }

                dgvReport.RenderControl(hw);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }


        // Required override for exporting controls
        public override void VerifyRenderingInServerForm(Control control)
        {
            // Confirms that an HtmlForm control is rendered for the specified ASP.NET server control
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            // Parse date inputs safely
            DateTime fromDate, toDate;
            if (!DateTime.TryParse(txtFromDate.Text, out fromDate) || !DateTime.TryParse(txtToDate.Text, out toDate))
            {
                lblMessage.Text = "Invalid date range.";
                return;
            }

            // Re-generate report to ensure GridView is populated
            GenerateRollupReport(fromDate, toDate);

            if (dgvReport.Rows.Count == 0)
            {
                lblMessage.Text = "No data to export.";
                return;
            }

            // Rebind to ensure columns are available
            dgvReport.AllowPaging = false;
            dgvReport.DataBind();

            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=ReportExport.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            using (Document pdfDoc = new Document(PageSize.A4, 40f, 40f, 60f, 40f))
            {
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                pdfDoc.Open();

                // Header
                Paragraph header = new Paragraph("Time & Attendance Report", FontFactory.GetFont("Arial", 16, Font.BOLD, BaseColor.BLUE));
                header.Alignment = Element.ALIGN_CENTER;
                header.SpacingAfter = 20f;
                pdfDoc.Add(header);

                // Metadata
                string siteName = ddlSites.SelectedItem != null ? ddlSites.SelectedItem.Text : "All Sites";
                Paragraph meta = new Paragraph($"Site: {siteName} | From: {fromDate:yyyy-MM-dd} To: {toDate:yyyy-MM-dd}", FontFactory.GetFont("Arial", 10, Font.ITALIC));
                meta.Alignment = Element.ALIGN_RIGHT;
                meta.SpacingAfter = 10f;
                pdfDoc.Add(meta);

                // Ensure columns exist
                int columnCount = dgvReport.HeaderRow?.Cells.Count ?? 0;
                if (columnCount == 0)
                {
                    pdfDoc.Add(new Paragraph("No columns available in report."));
                    pdfDoc.Close();
                    Response.End();
                    return;
                }

                PdfPTable table = new PdfPTable(columnCount);
                table.WidthPercentage = 100;

                // Headers
                foreach (TableCell headerCell in dgvReport.HeaderRow.Cells)
                {
                    PdfPCell cell = new PdfPCell(new Phrase(headerCell.Text, FontFactory.GetFont("Arial", 12, Font.BOLD)));
                    cell.BackgroundColor = new BaseColor(230, 230, 230);
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.Padding = 5;
                    table.AddCell(cell);
                }

                // Rows
                foreach (GridViewRow row in dgvReport.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        PdfPCell pdfCell = new PdfPCell(new Phrase(cell.Text, FontFactory.GetFont("Arial", 11)));
                        pdfCell.HorizontalAlignment = Element.ALIGN_LEFT;
                        pdfCell.Padding = 5;
                        table.AddCell(pdfCell);
                    }
                }

                pdfDoc.Add(table);

                // Footer
                Paragraph footer = new Paragraph($"Generated on {DateTime.Now:yyyy-MM-dd HH:mm}", FontFactory.GetFont("Arial", 9, Font.ITALIC));
                footer.Alignment = Element.ALIGN_RIGHT;
                footer.SpacingBefore = 20f;
                pdfDoc.Add(footer);

                pdfDoc.Close();
                Response.End();
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

        protected void ddlReportType_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selected = ddlReportType.SelectedValue;

            // Show/hide filters based on report type
            pnlPerson.Visible = selected == "Person" || selected == "Missing";
            pnlShift.Visible = selected == "Shift";
            pnlReader.Visible = selected == "Reader";
            //pnlSite.Visible = selected != "Rollup"; // Rollup is corporate-wide
        }

        protected void ddlSites_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnEnrollment_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeEnrollment.aspx");
        }
    }
}