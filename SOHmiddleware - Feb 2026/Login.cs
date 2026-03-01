using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SQLite;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SOHmiddleware
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        // Add a property to hold the logged-in role
        public static class Session
        {
            public static string CurrentUserRole { get; set; }
            public static string CurrentUsername { get; set; }
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string role = AuthenticateUser(username, password);
            if (!string.IsNullOrEmpty(role))
            {
                // Store role in session
                Session.CurrentUserRole = role;
                Session.CurrentUsername = username;

                // Hide login form
                this.Hide();

                // Launch Form1
                Form1 mainForm = new Form1();
                mainForm.FormClosed += (s, args) => this.Close();
                mainForm.Show();
            }
            else
            {
                lblStatus.Text = "Invalid credentials.";
                lblStatus.ForeColor = Color.Red;
            }
        }

        // Return role instead of just true/false
        private string AuthenticateUser(string username, string password)
        {
            string localConnStr = $"Data Source={Application.StartupPath}\\SQLdb\\localbuffer.db;Version=3;";
            using (var conn = new SQLiteConnection(localConnStr))
            {
                conn.Open();
                var cmd = new SQLiteCommand(@"
            SELECT Role 
            FROM Users 
            WHERE Username = @Username AND Password = @Password AND IsActive = 1
            LIMIT 1;", conn);

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password); // ⚠️ Later: hash this

                var roleObj = cmd.ExecuteScalar();
                return roleObj?.ToString(); // returns null if no match
            }
        }



        private void Login_Load(object sender, EventArgs e)
        {
            this.AcceptButton = btnLogin;

        }
    }
}
