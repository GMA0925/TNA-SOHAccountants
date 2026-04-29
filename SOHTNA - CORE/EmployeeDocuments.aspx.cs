using System;
using System.Collections.Generic;

namespace TimeAttendance.WebForms
{
    // System.Web.UI.Page is not available in .NET 8.0. Consider migrating to ASP.NET Core Razor Pages or MVC Controller.
    // Placeholder for compilation, but business logic will need to be migrated to a supported framework.
    public partial class EmployeeDocuments
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
                LoadDocuments();
            }
        }

        private void LoadDocuments()
        {
            // Load sample important documents
            LoadDocumentCategory(phImportantDocs, new List<DocumentItem>
            {
                new DocumentItem { Name = "Employee Handbook", Description = "Company policies and procedures", UploadDate = "2024-01-15", FileSize = "2.4 MB" },
                new DocumentItem { Name = "Code of Conduct", Description = "Professional conduct guidelines", UploadDate = "2024-01-15", FileSize = "1.8 MB" },
                new DocumentItem { Name = "Data Protection Policy", Description = "GDPR and data privacy policy", UploadDate = "2024-02-01", FileSize = "1.2 MB" }
            });

            // Load HR documents
            LoadDocumentCategory(phHRDocs, new List<DocumentItem>
            {
                new DocumentItem { Name = "Employment Contract", Description = "Your signed employment contract", UploadDate = "2023-06-01", FileSize = "0.8 MB" },
                new DocumentItem { Name = "Job Description", Description = "Role and responsibilities", UploadDate = "2023-06-01", FileSize = "0.5 MB" },
                new DocumentItem { Name = "Offer Letter", Description = "Original offer letter", UploadDate = "2023-05-15", FileSize = "0.4 MB" }
            });

            // Load benefits documents
            LoadDocumentCategory(phBenefitsDocs, new List<DocumentItem>
            {
                new DocumentItem { Name = "Health Insurance Plan", Description = "Medical and dental coverage details", UploadDate = "2024-01-01", FileSize = "1.5 MB" },
                new DocumentItem { Name = "Retirement Plan", Description = "401(k) and pension information", UploadDate = "2024-01-01", FileSize = "1.2 MB" },
                new DocumentItem { Name = "Benefits Summary", Description = "Annual benefits overview", UploadDate = "2024-01-01", FileSize = "0.9 MB" }
            });

            // Load training documents
            LoadDocumentCategory(phTrainingDocs, new List<DocumentItem>
            {
                new DocumentItem { Name = "Safety Training Certificate", Description = "Completed safety training", UploadDate = "2023-12-15", FileSize = "0.3 MB" },
                new DocumentItem { Name = "Compliance Training", Description = "Annual compliance requirements", UploadDate = "2024-03-01", FileSize = "2.1 MB" },
                new DocumentItem { Name = "System Training Manual", Description = "Company system user guide", UploadDate = "2024-01-20", FileSize = "3.5 MB" }
            });
        }

        private void LoadDocumentCategory(PlaceHolder placeholder, List<DocumentItem> documents)
        {
            foreach (var doc in documents)
            {
                HtmlGenericControl div = new HtmlGenericControl("div");
                div.Attributes["class"] = "document-card";

                HtmlGenericControl infoDiv = new HtmlGenericControl("div");
                infoDiv.Attributes["class"] = "document-info";

                HtmlGenericControl nameLabel = new HtmlGenericControl("div");
                nameLabel.Attributes["class"] = "document-name";
                nameLabel.InnerText = doc.Name;

                HtmlGenericControl metaLabel = new HtmlGenericControl("div");
                metaLabel.Attributes["class"] = "document-meta";
                metaLabel.InnerText = $"Uploaded: {doc.UploadDate} | Size: {doc.FileSize}";

                infoDiv.Controls.Add(nameLabel);
                infoDiv.Controls.Add(metaLabel);

                HtmlGenericControl actionsDiv = new HtmlGenericControl("div");
                actionsDiv.Attributes["class"] = "document-actions";

                HtmlAnchor downloadLink = new HtmlAnchor();
                downloadLink.Attributes["class"] = "action-link";
                downloadLink.Attributes["href"] = "#";
                downloadLink.InnerText = "?? Download";

                HtmlAnchor viewLink = new HtmlAnchor();
                viewLink.Attributes["class"] = "action-link";
                viewLink.Attributes["href"] = "#";
                viewLink.InnerText = "??? View";

                actionsDiv.Controls.Add(downloadLink);
                actionsDiv.Controls.Add(viewLink);

                div.Controls.Add(infoDiv);
                div.Controls.Add(actionsDiv);

                placeholder.Controls.Add(div);
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

    public class DocumentItem
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string UploadDate { get; set; }
        public string FileSize { get; set; }
    }
}
