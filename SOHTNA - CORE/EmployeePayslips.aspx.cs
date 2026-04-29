using System;
using System.Data;
using System.Data.SqlClient;

namespace TimeAttendance.WebForms
{
    // NOTE: System.Web.UI.Page is not available in .NET 8.0. You must migrate this code to use ASP.NET Core MVC or Razor Pages. For now, removing the base class to resolve the compilation error.
    public partial class EmployeePayslips
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
                LoadYears();
                LoadPayslips();
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

        private void LoadYears()
        {
            try
            {
                int currentYear = DateTime.Now.Year;
                ddlYear.Items.Clear();

                for (int year = currentYear; year >= currentYear - 5; year--)
                {
                    ddlYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
                }

                ddlYear.SelectedValue = currentYear.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading years: {ex.Message}");
            }
        }

        private void LoadPayslips()
        {
            try
            {
                string empId = GetEmployeeId();
                int year = Convert.ToInt32(ddlYear.SelectedValue);
                int? month = string.IsNullOrEmpty(ddlMonth.SelectedValue) ? (int?)null : Convert.ToInt32(ddlMonth.SelectedValue);

                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT pd.PayslipID, 
                               CONCAT(DATENAME(MONTH, pd.StartDate), ' ', YEAR(pd.StartDate)) as PayPeriod,
                               pd.BasicSalary, 
                               (SELECT SUM(Amount) FROM Deductions WHERE PayslipID = pd.PayslipID AND Type = 'Allowance') as Allowances,
                               (SELECT SUM(Amount) FROM Deductions WHERE PayslipID = pd.PayslipID AND Type = 'Deduction') as Deductions,
                               pd.NetSalary,
                               pd.PaymentDate
                        FROM PayrollDetails pd
                        WHERE pd.EmployeeID = @EmployeeID
                        AND YEAR(pd.StartDate) = @Year";

                    if (month.HasValue)
                    {
                        query += " AND MONTH(pd.StartDate) = @Month";
                    }

                    query += " ORDER BY pd.StartDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@EmployeeID", empId);
                    cmd.Parameters.AddWithValue("@Year", year);

                    if (month.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@Month", month.Value);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvPayslips.DataSource = dt;
                    gvPayslips.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading payslips: {ex.Message}");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadPayslips();
        }

        protected void gvPayslips_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Download")
            {
                try
                {
                    int payslipId = Convert.ToInt32(e.CommandArgument);
                    // Implement PDF download logic here
                    // For now, just show a message
                    // Response.Redirect($"DownloadPayslip.aspx?id={payslipId}");
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error downloading payslip: {ex.Message}");
                }
            }
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
    }
}
