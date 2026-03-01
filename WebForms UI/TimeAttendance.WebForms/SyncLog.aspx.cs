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
    public partial class SyncLog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadSyncLog();
                ShowToast("📋 Loaded recent sync activity.");
            }
        }

        private void LoadSyncLog()
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 100 * FROM SyncLog ORDER BY Timestamp DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvSyncLog.DataSource = dt;
                    gvSyncLog.DataBind();
                }
            }
        }

        private void ShowToast(string message)
        {
            lblToast.Text = message;
        }

        public static void LogSyncEvent(string employeeId, string action, string status, string message)
        {
            string connStr = Properties.Settings.Default.SQLCon;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    INSERT INTO SyncLog (EmployeeId, Action, Status, Message)
                    VALUES (@EmployeeId, @Action, @Status, @Message)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EmployeeId", employeeId ?? "N/A");
                    cmd.Parameters.AddWithValue("@Action", action);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Message", message);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnRefreshLog_Click(object sender, EventArgs e)
        {
            LoadSyncLog();
            ShowToast("🔄 Sync log refreshed.");
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

        protected void gvSyncLog_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSyncLog.PageIndex = e.NewPageIndex;
            LoadSyncLog();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvSyncLog.PageSize = int.Parse(ddlPageSize.SelectedValue);
            LoadSyncLog();
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=SyncLogExport.xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.Charset = "";

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            gvSyncLog.AllowPaging = false;
            LoadSyncLog();

            gvSyncLog.RenderControl(hw);
            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for export
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            gvSyncLog.AllowPaging = false;
            LoadSyncLog(); // Ensure full data is loaded

            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=SyncLogExport.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);

            using (MemoryStream ms = new MemoryStream())
            {
                Document doc = new Document(PageSize.A4, 25, 25, 30, 30);
                PdfWriter writer = PdfWriter.GetInstance(doc, ms);
                doc.Open();

                PdfPTable table = new PdfPTable(gvSyncLog.HeaderRow.Cells.Count);
                table.WidthPercentage = 100;

                // Add header
                foreach (TableCell headerCell in gvSyncLog.HeaderRow.Cells)
                {
                    PdfPCell cell = new PdfPCell(new Phrase(headerCell.Text));
                    cell.BackgroundColor = new BaseColor(0, 120, 212); // #0078D4
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.Padding = 5;
                    cell.Phrase.Font.Color = BaseColor.WHITE;
                    table.AddCell(cell);
                }

                // Add rows
                foreach (GridViewRow row in gvSyncLog.Rows)
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
    }
}