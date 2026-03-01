using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class UserManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadRoles();
                LoadSiteIdFromConfig();
                LoadUsers();
                lblUserMessage.Text = "📋 User list loaded.";
            }
        }

        private void LoadRoles()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT RoleName FROM Roles WHERE IsActive = 1 ORDER BY RoleName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlRole.Items.Clear();
                        while (reader.Read())
                        {
                            string role = reader["RoleName"].ToString();
                            ddlRole.Items.Add(new System.Web.UI.WebControls.ListItem(role, role));
                        }
                    }
                }
            }
        }

        private void LoadSiteIdFromConfig()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT SettingValue FROM ConfigSettings WHERE SettingKey = 'SiteCode'";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        txtSiteId.Text = result.ToString();
                    }
                }
            }
        }


        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reports.aspx");
        }

        protected void btnSyncLog_Click(object sender, EventArgs e)
        {
            Response.Redirect("SyncLog.aspx");
        }

        protected void btnUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserManagement.aspx");
        }

        protected void btnConfig_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConfigTools.aspx");
        }

        protected void btnEnrollment_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeEnrollment.aspx");
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            string nameSurname = txtNameSurname.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string role = ddlRole.SelectedValue;
            string status = ddlStatus.SelectedValue;
            string siteId = txtSiteId.Text.Trim();

            // Validate required fields
            if (string.IsNullOrEmpty(nameSurname) || string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(email) || string.IsNullOrEmpty(siteId))
            {
                lblUserMessage.Text = "⚠️ Name & Surname, Username, Email, and Site ID are required.";
                return;
            }

            bool isActive = status == "Active";

            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
MERGE INTO Users AS target
USING (SELECT @Username AS Username) AS source
ON target.Username = source.Username
WHEN MATCHED THEN
    UPDATE SET NameSurname = @NameSurname, Email = @Email, Role = @Role, 
               IsActive = @IsActive, SiteId = @SiteId
WHEN NOT MATCHED THEN
    INSERT (NameSurname, Username, Email, Role, IsActive, SiteId)
    VALUES (@NameSurname, @Username, @Email, @Role, @IsActive, @SiteId);";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@NameSurname", nameSurname);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@IsActive", isActive);
                    cmd.Parameters.AddWithValue("@SiteId", siteId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblUserMessage.Text = $"✅ User '{username}' ({nameSurname}) saved successfully.";
            ClearUserForm();
            LoadUsers();
        }



        private void ClearUserForm()
        {
            txtUsername.Text = "";
            txtEmail.Text = "";
            ddlRole.ClearSelection();
            ddlStatus.ClearSelection();
        }



        protected void btnClearUser_Click(object sender, EventArgs e)
        {
            ClearUserForm();
        }

        protected void btnExportUsersExcel_Click(object sender, EventArgs e)
        {
            gvUsers.AllowPaging = false;
            LoadUsers(); // Ensure full data is loaded

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=UserExport.xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.Charset = "";

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            gvUsers.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        private void LoadUsers()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT NameSurname, Username, Email, Role, IsActive, SiteId FROM Users ORDER BY NameSurname";

                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dt.AcceptChanges();

                    // Add readable status column
                    if (!dt.Columns.Contains("StatusText"))
                        dt.Columns.Add("StatusText", typeof(string));

                    foreach (DataRow row in dt.Rows)
                    {
                        if (row["IsActive"] != DBNull.Value)
                        {
                            bool isActive = Convert.ToBoolean(row["IsActive"]);
                            row["StatusText"] = isActive ? "Active" : "Inactive";
                        }
                        else
                        {
                            row["StatusText"] = "Unknown";
                        }
                    }

                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();
                }
            }
        }


        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for export
        }

        protected void btnExportUsersPdf_Click(object sender, EventArgs e)
        {
            gvUsers.AllowPaging = false;
            LoadUsers();

            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=UserExport.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            using (MemoryStream ms = new MemoryStream())
            {
                Document doc = new Document(PageSize.A4, 25, 25, 30, 30);
                PdfWriter writer = PdfWriter.GetInstance(doc, ms);
                doc.Open();

                PdfPTable table = new PdfPTable(gvUsers.HeaderRow.Cells.Count);
                table.WidthPercentage = 100;

                foreach (TableCell headerCell in gvUsers.HeaderRow.Cells)
                {
                    PdfPCell cell = new PdfPCell(new Phrase(headerCell.Text));
                    cell.BackgroundColor = new BaseColor(0, 120, 212);
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.Padding = 5;
                    cell.Phrase.Font.Color = BaseColor.WHITE;
                    table.AddCell(cell);
                }

                foreach (GridViewRow row in gvUsers.Rows)
                {
                    foreach (TableCell cell in row.Cells)
                    {
                        PdfPCell pdfCell = new PdfPCell(new Phrase(cell.Text));
                        pdfCell.Padding = 5;
                        table.AddCell(pdfCell);
                    }
                }

                doc.Add(table);
                doc.Close();

                Response.OutputStream.Write(ms.GetBuffer(), 0, ms.GetBuffer().Length);
                Response.OutputStream.Flush();
                Response.End();
            }
        }

        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            LoadUsers();
        }

        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            LoadUsers();
        }

        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string username = gvUsers.DataKeys[e.RowIndex].Value.ToString();
            GridViewRow row = gvUsers.Rows[e.RowIndex];

            string email = ((TextBox)row.Cells[1].Controls[0]).Text.Trim();
            string role = ((TextBox)row.Cells[2].Controls[0]).Text.Trim();
            string status = ((TextBox)row.Cells[3].Controls[0]).Text.Trim();

            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE Users SET Email = @Email, Role = @Role, Status = @Status WHERE Username = @Username";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@Status", status);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvUsers.EditIndex = -1;
            LoadUsers();
            lblUserMessage.Text = $"✅ User '{username}' updated successfully.";
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState.HasFlag(DataControlRowState.Edit))
            {
                // Populate Role dropdown
                DropDownList ddlRole = (DropDownList)e.Row.FindControl("ddlGridRole");
                if (ddlRole != null)
                {
                    string connStr = Properties.Settings.Default.SQLCon;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT RoleName FROM Roles WHERE IsActive = 1 ORDER BY RoleName";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            conn.Open();
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                ddlRole.Items.Clear();
                                while (reader.Read())
                                {
                                    string role = reader["RoleName"].ToString();
                                    ddlRole.Items.Add(new System.Web.UI.WebControls.ListItem(role, role));
                                }
                            }
                        }
                    }

                    string currentRole = DataBinder.Eval(e.Row.DataItem, "Role").ToString();
                    if (ddlRole.Items.FindByValue(currentRole) != null)
                        ddlRole.SelectedValue = currentRole;
                }

                // Set Status dropdown
                DropDownList ddlStatus = (DropDownList)e.Row.FindControl("ddlGridStatus");
                if (ddlStatus != null)
                {
                    string currentStatus = DataBinder.Eval(e.Row.DataItem, "StatusText").ToString();
                    if (ddlStatus.Items.FindByText(currentStatus) != null)
                        ddlStatus.SelectedValue = currentStatus;
                }
            }
        }

    }
}