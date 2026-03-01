using System;
using System.Data.SqlClient;
using System.Web.Security;

namespace TimeAttendance.WebForms
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT Role, SiteId, NameSurname 
            FROM Users 
            WHERE Username = @Username AND PasswordHash = @PasswordHash", conn);

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@PasswordHash", password); // 🔐 Hash in production

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string role = reader["Role"].ToString().Trim();
                        string siteId = reader["SiteId"].ToString();
                        string NameSurname = reader["NameSurname"].ToString();

                        Session["Username"] = username;
                        Session["Role"] = role;
                        Session["SiteId"] = siteId;
                        Session["NameSurname"] = NameSurname;

                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password.";
                    }
                }
            }
        }


    }
}
