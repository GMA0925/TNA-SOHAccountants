using System;
using System.Data.SqlClient;
using System.Data;

namespace TimeAttendance.WebForms
{
    public partial class MyClockEvents : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
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
            string username = User.Identity.Name;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT Timestamp, Status FROM ClockEvents WHERE Username = @Username ORDER BY Timestamp DESC", conn);
                cmd.Parameters.AddWithValue("@Username", username);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvClockEvents.DataSource = dt;
                gvClockEvents.DataBind();
            }
        }
    }
}
