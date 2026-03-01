using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["token"] == null)
            {
                lblStatus.Text = "Invalid or missing token.";
                btnUpdate.Enabled = false;
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserId FROM Users WHERE Email = @Email", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                object userIdObj = cmd.ExecuteScalar();

                if (userIdObj != null)
                {
                    int userId = Convert.ToInt32(userIdObj);
                    string token = Guid.NewGuid().ToString();

                    SqlCommand insertCmd = new SqlCommand(@"
                INSERT INTO PasswordResets (UserId, Token, Expiry)
                VALUES (@UserId, @Token, DATEADD(HOUR, 1, GETDATE()))", conn);

                    insertCmd.Parameters.AddWithValue("@UserId", userId);
                    insertCmd.Parameters.AddWithValue("@Token", token);
                    insertCmd.ExecuteNonQuery();

                    string resetLink = $"https://yourdomain.com/ResetPassword.aspx?token={token}";
                    SendResetEmail(email, resetLink);

                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "Reset link sent to your email.";
                }
                else
                {
                    lblMessage.Text = "Email not found.";
                }
            }
        }

        private void SendResetEmail(string toEmail, string resetLink)
        {
            MailMessage mail = new MailMessage("noreply@yourdomain.com", toEmail);
            mail.Subject = "Password Reset";
            mail.Body = $"Click the link to reset your password:\n{resetLink}";
            SmtpClient client = new SmtpClient("smtp.yourdomain.com");
            client.Send(mail);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];
            string newPassword = txtNewPassword.Text.Trim();
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT UserId FROM PasswordResets 
            WHERE Token = @Token AND Expiry > GETDATE()", conn);

                cmd.Parameters.AddWithValue("@Token", token);
                conn.Open();
                object userIdObj = cmd.ExecuteScalar();

                if (userIdObj != null)
                {
                    int userId = Convert.ToInt32(userIdObj);

                    SqlCommand updateCmd = new SqlCommand(@"
                UPDATE Users SET PasswordHash = @PasswordHash WHERE UserId = @UserId", conn);

                    updateCmd.Parameters.AddWithValue("@PasswordHash", newPassword); // 🔐 Hash in production
                    updateCmd.Parameters.AddWithValue("@UserId", userId);
                    updateCmd.ExecuteNonQuery();

                    SqlCommand deleteCmd = new SqlCommand("DELETE FROM PasswordResets WHERE Token = @Token", conn);
                    deleteCmd.Parameters.AddWithValue("@Token", token);
                    deleteCmd.ExecuteNonQuery();

                    lblStatus.ForeColor = System.Drawing.Color.Green;
                    lblStatus.Text = "Password updated successfully.";
                }
                else
                {
                    lblStatus.Text = "Invalid or expired token.";
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}