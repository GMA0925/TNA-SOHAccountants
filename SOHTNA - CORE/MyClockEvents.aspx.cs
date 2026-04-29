using System;
using System.Data.SqlClient;
using System.Data;

namespace TimeAttendance.WebForms
{
    public partial class MyClockEvents : System.Web.UI.Page
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
                LoadClockEvents();
            }
        }

        private void LoadClockEvents()
        {
            try
            {
                string username = Session["Username"]?.ToString();
                string siteId = Session["SiteId"]?.ToString();

                if (string.IsNullOrEmpty(username))
                {
                    return;
                }

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT 
                            re.EventID,
                            re.PersonName,
                            re.Timestamp,
                            re.VerifyMode,
                            re.IsEmulated,
                            re.SiteId
                        FROM ReaderEvents re
                        INNER JOIN Employees e ON re.PersonName = e.NameSurname
                        WHERE e.SiteID = @SiteID
                        ORDER BY re.Timestamp DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SiteID", siteId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (gvClockEvents != null)
                    {
                        gvClockEvents.DataSource = dt;
                        gvClockEvents.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading clock events: {ex.Message}");
            }
        }
    }
}
