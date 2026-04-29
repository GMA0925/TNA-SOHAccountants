using System;
using System.Data;
using System.Data.SqlClient;

namespace TimeAttendance.WebForms
{
    // System.Web.UI.Page is not available in .NET 8.0. You must migrate this code to use ASP.NET Core PageModel, Controller, or Razor Pages. The code below is commented out as a placeholder.
    // public partial class DataAccessLog : System.Web.UI.Page
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
                LoadUsers();
                LoadStatistics();
                LoadAccessLogs();
            }
        }

        private void LoadUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT DISTINCT u.UserID, e.NameSurname 
                        FROM Users u
                        JOIN Employees e ON u.EmployeeID = e.EmployeeID
                        ORDER BY e.NameSurname";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlUser.Items.Clear();
                    ddlUser.Items.Add(new ListItem("-- All Users --", ""));
                    foreach (DataRow row in dt.Rows)
                    {
                        ddlUser.Items.Add(new ListItem(row["NameSurname"].ToString(), row["UserID"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading users: {ex.Message}");
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT 
                            COUNT(*) as TotalAccess,
                            SUM(CASE WHEN AccessType = 'Export' THEN 1 ELSE 0 END) as Exports,
                            SUM(CASE WHEN DataType IN ('Payroll', 'Employee') THEN 1 ELSE 0 END) as SensitiveAccess,
                            SUM(CASE WHEN IsAuthorized = 0 THEN 1 ELSE 0 END) as Unauthorized
                        FROM DataAccessLog";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalAccess.Text = reader["TotalAccess"] != DBNull.Value ? reader["TotalAccess"].ToString() : "0";
                            lblExports.Text = reader["Exports"] != DBNull.Value ? reader["Exports"].ToString() : "0";
                            lblSensitiveAccess.Text = reader["SensitiveAccess"] != DBNull.Value ? reader["SensitiveAccess"].ToString() : "0";
                            lblUnauthorized.Text = reader["Unauthorized"] != DBNull.Value ? reader["Unauthorized"].ToString() : "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
            }
        }

        private void LoadAccessLogs()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT TOP 1000 dal.AccessLogID, dal.AccessDate, e.NameSurname as UserName, dal.DataType, 
                               dal.AccessType, dal.Purpose, dal.IsAuthorized
                        FROM DataAccessLog dal
                        JOIN Employees e ON dal.UserID = e.EmployeeID";

                    if (!string.IsNullOrEmpty(ddlUser.SelectedValue))
                    {
                        query += " WHERE dal.UserID = @UserID";
                    }

                    if (!string.IsNullOrEmpty(ddlDataType.SelectedValue))
                    {
                        query += (string.IsNullOrEmpty(ddlUser.SelectedValue) ? " WHERE " : " AND ") + "dal.DataType = @DataType";
                    }

                    if (!string.IsNullOrEmpty(ddlAccessType.SelectedValue))
                    {
                        query += (query.Contains("WHERE") ? " AND " : " WHERE ") + "dal.AccessType = @AccessType";
                    }

                    query += " ORDER BY dal.AccessDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    if (!string.IsNullOrEmpty(ddlUser.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@UserID", ddlUser.SelectedValue);
                    }

                    if (!string.IsNullOrEmpty(ddlDataType.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@DataType", ddlDataType.SelectedValue);
                    }

                    if (!string.IsNullOrEmpty(ddlAccessType.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@AccessType", ddlAccessType.SelectedValue);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAccessLog.DataSource = dt;
                    gvAccessLog.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading access logs: {ex.Message}");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadAccessLogs();
        }

        #region Navigation

        protected void btnAuditTrail_Click(object sender, EventArgs e) => Response.Redirect("AuditTrail.aspx");
        protected void btnComplianceStatus_Click(object sender, EventArgs e) => Response.Redirect("ComplianceStatus.aspx");
        protected void btnDataAccess_Click(object sender, EventArgs e) => Response.Redirect("DataAccessLog.aspx");
        protected void btnViolations_Click(object sender, EventArgs e) => Response.Redirect("ComplianceViolations.aspx");
        protected void btnReports_Click(object sender, EventArgs e) => Response.Redirect("ComplianceReports.aspx");

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        #endregion
    }
}
