using System;
using System.Data;
using System.Data.SqlClient;

namespace TimeAttendance.WebForms
{
    // TODO: System.Web.UI.Page is not available in .NET 8.0. Consider migrating to ASP.NET Core PageModel or Controller, or use a compatible framework.
    public partial class AuditTrail
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
                LoadEmployees();
                LoadStatistics();
                LoadAuditLogs();
            }
        }

        private void LoadEmployees()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = "SELECT EmployeeID, NameSurname FROM Employees WHERE IsActive = 1 ORDER BY NameSurname";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlEmployee.Items.Clear();
                    ddlEmployee.Items.Add(new ListItem("-- All Employees --", ""));
                    foreach (DataRow row in dt.Rows)
                    {
                        ddlEmployee.Items.Add(new ListItem(row["NameSurname"].ToString(), row["EmployeeID"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading employees: {ex.Message}");
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
                            COUNT(*) as TotalLogs,
                            SUM(CASE WHEN CAST(AuditDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) as TodayActivities,
                            SUM(CASE WHEN Success = 0 THEN 1 ELSE 0 END) as FailedOps,
                            SUM(CASE WHEN ActionType = 'Export' THEN 1 ELSE 0 END) as DataExports
                        FROM AuditLog";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblTotalLogs.Text = reader["TotalLogs"] != DBNull.Value ? reader["TotalLogs"].ToString() : "0";
                            lblTodayActivities.Text = reader["TodayActivities"] != DBNull.Value ? reader["TodayActivities"].ToString() : "0";
                            lblFailedOps.Text = reader["FailedOps"] != DBNull.Value ? reader["FailedOps"].ToString() : "0";
                            lblDataExports.Text = reader["DataExports"] != DBNull.Value ? reader["DataExports"].ToString() : "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
            }
        }

        private void LoadAuditLogs()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    string query = @"
                        SELECT TOP 1000 AuditLogID, AuditDate, Username, ActionType, EntityType, Description, IPAddress, Success
                        FROM AuditLog";

                    if (!string.IsNullOrEmpty(ddlEmployee.SelectedValue))
                    {
                        query += " WHERE EmployeeID = @EmployeeID";
                    }

                    if (!string.IsNullOrEmpty(ddlActionType.SelectedValue))
                    {
                        query += (string.IsNullOrEmpty(ddlEmployee.SelectedValue) ? " WHERE " : " AND ") + "ActionType = @ActionType";
                    }

                    if (!string.IsNullOrEmpty(ddlEntityType.SelectedValue))
                    {
                        query += (query.Contains("WHERE") ? " AND " : " WHERE ") + "EntityType = @EntityType";
                    }

                    query += " ORDER BY AuditDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    if (!string.IsNullOrEmpty(ddlEmployee.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeID", ddlEmployee.SelectedValue);
                    }

                    if (!string.IsNullOrEmpty(ddlActionType.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@ActionType", ddlActionType.SelectedValue);
                    }

                    if (!string.IsNullOrEmpty(ddlEntityType.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@EntityType", ddlEntityType.SelectedValue);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAuditLogs.DataSource = dt;
                    gvAuditLogs.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading audit logs: {ex.Message}");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadAuditLogs();
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
