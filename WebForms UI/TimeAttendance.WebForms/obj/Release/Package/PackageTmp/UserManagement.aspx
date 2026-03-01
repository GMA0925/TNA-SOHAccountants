<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="TimeAttendance.WebForms.UserManagement" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .header-bar {
            background-color: #0078D4;
            color: white;
            padding: 15px;
            font-size: 20px;
            font-weight: bold;
            text-align: center;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 22px;
            color: #0078D4;
            margin-bottom: 20px;
            display: block;
            text-align: center;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background-color: #0078D4;
            color: white;
        }

        .btn-primary:hover {
            background-color: #005a9e;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .table th, .table td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .table-striped tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .table-striped th {
            background-color: #0078D4;
            color: white;
        }

        .nav-btn {
            margin: 0 10px;
            padding: 8px 16px;
            font-size: 14px;
            background-color: #0078D4;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }

        .nav-btn:hover {
            background-color: #005a9e;
            color: white;
            text-decoration: none;
        }

        .nav-btn.active {
            background-color: #005a9e;
            font-weight: bold;
        }

        .status-label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
            color: #0078D4;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header-bar">
            <i class="fas fa-id-card-alt"></i> Time & Attendance Portal
        </header>

        <!-- Navigation -->
        <nav class="nav-bar" style="background-color:#e9ecef; padding:10px; text-align:center;">
            <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" PostBackUrl="~/Dashboard.aspx"> <i class="fas fa-home"></i>Dashboard </asp:LinkButton>
            <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn" PostBackUrl="~/Reports.aspx"> <i class="fas fa-chart-bar"></i>Reports </asp:LinkButton>
            <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="nav-btn" PostBackUrl="~/SyncLog.aspx"> <i class="fas fa-sync"></i>Sync Log </asp:LinkButton>
            <asp:LinkButton ID="btnUsers" runat="server" CssClass="nav-btn active" PostBackUrl="~/UserManagement.aspx"> <i class="fas fa-users"></i>User Management </asp:LinkButton>
            <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn" PostBackUrl="~/ConfigTools.aspx"> <i class="fas fa-tools"></i>Config Tools </asp:LinkButton>
            <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn" PostBackUrl="~/EmployeeEnrollment.aspx"> <i class="fas fa-id-card-alt"></i>Employee Enrollment </asp:LinkButton>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="👤 User Management" CssClass="page-title" />

            <!-- Form Fields -->
            <section class="form-grid">
                <div>
                    <asp:Label ID="lblNameSurname" runat="server" Text="Name & Surname:" />
                    <asp:TextBox ID="txtNameSurname" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblUsername" runat="server" Text="Username:" />
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblEmail" runat="server" Text="Email:" />
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblRole" runat="server" Text="Role:" />
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblStatus" runat="server" Text="Status:" />
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Active" Value="Active" />
                        <asp:ListItem Text="Inactive" Value="Inactive" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Label ID="lblSiteId" runat="server" Text="Site ID:" />
                    <asp:TextBox ID="txtSiteId" runat="server" CssClass="form-control" />
                </div>
            </section>

            <!-- Action Buttons -->
            <div style="text-align: right;">
                <asp:Button ID="btnSaveUser" runat="server" Text="💾 Save User" CssClass="btn btn-primary" OnClick="btnSaveUser_Click" />
                <asp:Button ID="btnClearUser" runat="server" Text="🧹 Clear" CssClass="btn btn-secondary" OnClick="btnClearUser_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblUserMessage" runat="server" CssClass="status-label" />

            <!-- Export Buttons -->
            <div style="margin-top: 15px; text-align: right;">
                <asp:Button ID="btnExportUsersExcel" runat="server" Text="📤 Export to Excel" CssClass="btn btn-primary" OnClick="btnExportUsersExcel_Click" />
                <asp:Button ID="btnExportUsersPdf" runat="server" Text="📄 Export to PDF" CssClass="btn btn-secondary" OnClick="btnExportUsersPdf_Click" />
            </div>

            <!-- User Grid -->
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                DataKeyNames="Username"
                OnRowEditing="gvUsers_RowEditing"
                OnRowUpdating="gvUsers_RowUpdating"
                OnRowCancelingEdit="gvUsers_RowCancelingEdit"
                OnRowDataBound="gvUsers_RowDataBound">

                <Columns>
                    <asp:BoundField DataField="Username" HeaderText="Username" ReadOnly="true" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />

                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <%# Eval("Role") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlGridRole" runat="server" CssClass="form-control" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Eval("StatusText") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlGridStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Site ID">
                        <ItemTemplate>
                            <%# Eval("SiteId") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtGridSiteId" runat="server" CssClass="form-control" Text='<%# Eval("SiteId") %>' ReadOnly="true" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Name & Surname">
                        <ItemTemplate>
                            <%# Eval("NameSurname") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtGridNameSurname" runat="server" CssClass="form-control" Text='<%# Eval("NameSurname") %>' />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowEditButton="true" />
                </Columns>
            </asp:GridView>
        </main>
    </form>
</body>


</html>
