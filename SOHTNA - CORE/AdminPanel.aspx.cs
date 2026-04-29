using System;
using System.Data;
using System.Data.SqlClient;

namespace TimeAttendance.WebForms
{
    public partial class AdminPanel : System.Web.UI.Page
    {
        private string _connStr = Properties.Settings.Default.SQLCon;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSystemStatistics();
                LoadHolidays();
            }
        }

        private void LoadSystemStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT 
                            (SELECT COUNT(*) FROM Users WHERE IsActive = 1) as TotalUsers,
                            (SELECT COUNT(*) FROM Employees WHERE IsActive = 1) as ActiveEmployees,
                            (SELECT COUNT(*) FROM Departments WHERE IsActive = 1) as Departments";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalUsers.Text = reader["TotalUsers"].ToString();
                            lblActiveEmployees.Text = reader["ActiveEmployees"].ToString();
                            lblDepartments.Text = reader["Departments"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading system statistics: {ex.Message}");
            }
        }

        private void LoadHolidays()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT HolidayID, HolidayName, HolidayDate, HolidayType
                        FROM HolidayCalendar
                        WHERE Year = YEAR(GETDATE()) AND IsActive = 1
                        ORDER BY HolidayDate";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvHolidays.DataSource = dt;
                    gvHolidays.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading holidays: {ex.Message}");
            }
        }

        protected void btnAddHoliday_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtHolidayName.Text) || string.IsNullOrEmpty(txtHolidayDate.Text))
                {
                    return;
                }

                DateTime holidayDate = DateTime.Parse(txtHolidayDate.Text);

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        INSERT INTO HolidayCalendar (HolidayName, HolidayDate, Year, HolidayType, IsActive)
                        VALUES (@HolidayName, @HolidayDate, @Year, @HolidayType, 1)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@HolidayName", txtHolidayName.Text);
                    cmd.Parameters.AddWithValue("@HolidayDate", holidayDate);
                    cmd.Parameters.AddWithValue("@Year", holidayDate.Year);
                    cmd.Parameters.AddWithValue("@HolidayType", ddlHolidayType.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtHolidayName.Text = "";
                txtHolidayDate.Text = "";
                LoadHolidays();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error adding holiday: {ex.Message}");
            }
        }

        protected void gvHolidays_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Delete")
                {
                    int holidayId = Convert.ToInt32(e.CommandArgument);
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        string query = "DELETE FROM HolidayCalendar WHERE HolidayID = @HolidayID";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@HolidayID", holidayId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    LoadHolidays();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting holiday: {ex.Message}");
            }
        }

        protected void btnRunMaintenance_Click(object sender, EventArgs e)
        {
            try
            {
                // TODO: Implement maintenance tasks
                // - Clean up old logs
                // - Optimize database
                // - Clear temporary files
                // - Refresh caches
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error running maintenance: {ex.Message}");
            }
        }

        #region Navigation

        protected void btnDashboard_Click(object sender, EventArgs e) => Response.Redirect("Dashboard.aspx");
        protected void btnAdminPanel_Click(object sender, EventArgs e) => Response.Redirect("AdminPanel.aspx");

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        #endregion
    }
}
