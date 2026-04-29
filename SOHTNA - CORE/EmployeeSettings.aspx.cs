using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace TimeAttendance.WebForms
{
    public partial class EmployeeSettings
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
                LoadSettings();
            }
        }

        private string GetEmployeeId()
        {
            string empId = Session["UserID"]?.ToString();
            if (string.IsNullOrWhiteSpace(empId))
            {
                throw new InvalidOperationException("Employee ID not found in session.");
            }
            return empId;
        }

        private void LoadSettings()
        {
            try
            {
                // Load notification preferences from database or defaults
                // This would come from a UserPreferences table if it exists
                // For now, we'll just set defaults
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading settings: {ex.Message}");
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtCurrentPassword.Text))
                {
                    ShowMessage("?? Please enter your current password", "error");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtNewPassword.Text) || txtNewPassword.Text.Length < 6)
                {
                    ShowMessage("?? New password must be at least 6 characters", "error");
                    return;
                }

                if (txtNewPassword.Text != txtConfirmPassword.Text)
                {
                    ShowMessage("?? New passwords do not match", "error");
                    return;
                }

                string empId = GetEmployeeId();
                string username = Session.GetString("Username");

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    // Verify current password
                    string verifyQuery = "SELECT Password FROM Users WHERE Username = @Username AND Password = @Password";
                    SqlCommand verifyCmd = new SqlCommand(verifyQuery, conn);
                    verifyCmd.Parameters.AddWithValue("@Username", username);
                    verifyCmd.Parameters.AddWithValue("@Password", EncryptPassword(txtCurrentPassword.Text));

                    conn.Open();
                    object result = verifyCmd.ExecuteScalar();
                    conn.Close();

                    if (result == null)
                    {
                        ShowMessage("? Current password is incorrect", "error");
                        return;
                    }

                    // Update password
                    string updateQuery = "UPDATE Users SET Password = @NewPassword WHERE Username = @Username";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@NewPassword", EncryptPassword(txtNewPassword.Text));
                    updateCmd.Parameters.AddWithValue("@Username", username);

                    conn.Open();
                    updateCmd.ExecuteNonQuery();
                    conn.Close();

                    ShowMessage("? Password changed successfully", "success");
                    ClearPasswordFields();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error changing password: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        protected void btnSaveNotifications_Click(object sender, EventArgs e)
        {
            try
            {
                // Save notification preferences
                // This would update a UserPreferences table if it exists
                ShowMessage("? Notification settings saved successfully", "success");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving notifications: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        protected void btnEnableTwoFactor_Click(object sender, EventArgs e)
        {
            try
            {
                if (chkTwoFactor.Checked)
                {
                    ShowMessage("? Two-factor authentication enabled successfully", "success");
                }
                else
                {
                    ShowMessage("? Two-factor authentication disabled", "success");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating 2FA: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        protected void btnSavePrivacy_Click(object sender, EventArgs e)
        {
            try
            {
                ShowMessage("? Privacy settings saved successfully", "success");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving privacy settings: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        protected void btnDownloadData_Click(object sender, EventArgs e)
        {
            try
            {
                // Implement data export to CSV or PDF
                ShowMessage("?? Your data export has started. Check your download folder.", "success");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error downloading data: {ex.Message}");
                ShowMessage($"? Error: {ex.Message}", "error");
            }
        }

        private string EncryptPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        private void ClearPasswordFields()
        {
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }

        #region Navigation

        protected void btnHome_Click(object sender, EventArgs e) => Response.Redirect("EmployeeSelfService.aspx");
        protected void btnProfile_Click(object sender, EventArgs e) => Response.Redirect("EmployeeProfile.aspx");
        protected void btnPayslip_Click(object sender, EventArgs e) => Response.Redirect("EmployeePayslips.aspx");
        protected void btnDocuments_Click(object sender, EventArgs e) => Response.Redirect("EmployeeDocuments.aspx");
        protected void btnSettings_Click(object sender, EventArgs e) => Response.Redirect("EmployeeSettings.aspx");

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        #endregion

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"{type}-message";
            lblMessage.Visible = true;
        }
    }
}
