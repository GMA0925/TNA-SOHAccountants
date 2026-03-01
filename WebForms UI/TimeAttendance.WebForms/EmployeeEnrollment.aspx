<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeEnrollment.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeEnrollment" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Enrollment</title>
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
            min-width: 100px;
             max-width: 100%;
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
            <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" PostBackUrl="~/Dashboard.aspx" OnClick="btnDashboard_Click">
                <i class="fas fa-home"></i> Dashboard
            </asp:LinkButton>
            <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn" PostBackUrl="~/Reports.aspx" OnClick="btnReports_Click">
                <i class="fas fa-chart-bar"></i> Reports
            </asp:LinkButton>
            <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="nav-btn" PostBackUrl="~/SyncLog.aspx" OnClick="btnSyncLog_Click">
                <i class="fas fa-sync"></i> Sync Log
            </asp:LinkButton>
            <asp:LinkButton ID="btnUsers" runat="server" CssClass="nav-btn" PostBackUrl="~/UserManagement.aspx" OnClick="btnUsers_Click">
                <i class="fas fa-users"></i> User Management
            </asp:LinkButton>
            <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn" PostBackUrl="~/ConfigTools.aspx" OnClick="btnConfig_Click">
                <i class="fas fa-tools"></i> Config Tools
            </asp:LinkButton>
            <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn active" PostBackUrl="~/EmployeeEnrollment.aspx" OnClick="btnEnrollment_Click">
                <i class="fas fa-id-card-alt"></i> Employee Enrollment
            </asp:LinkButton>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="👥 Employee Enrollment" CssClass="page-title" />

            <!-- Enrollment Form -->
            <section class="form-grid">
                <div>
                    <asp:Label ID="lblEmpId" runat="server" Text="Employee ID:" />
                    <asp:TextBox ID="txtEmpId" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblName" runat="server" Text="Full Name:" />
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblEmail" runat="server" Text="Email:" />
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblMobile" runat="server" Text="Mobile:" />
                    <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblRole" runat="server" Text="Role:" />
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblSite" runat="server" Text="Site:" />
                    <asp:DropDownList ID="ddlSite" runat="server" CssClass="form-control" />
                </div>
            </section>

            <!-- Action Buttons -->
            <div style="text-align: right;">
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" Enabled="False" ToolTip="This tool is offline until we complete the public IP model" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-label" ForeColor="Green" />

                    <br />
        <br />
        Filter Employees by Status<br />

                    <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" CssClass="form-control"
            OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" Width="300px">
            <asp:ListItem Text="-- All Employees --" Value="All" />
            <asp:ListItem Text="Active Only" Value="Active" />
            <asp:ListItem Text="Inactive Only" Value="Inactive" />
        </asp:DropDownList>


            <!-- Middleware Sync Button -->
            <div style="margin-top: 30px; text-align: right;">
                <asp:Button ID="btnSyncToMiddleware" runat="server" Text="🔄 Sync to Middleware" CssClass="btn btn-primary" OnClick="btnSyncToMiddleware_Click" Enabled="False" ToolTip="This tool is offline until we complete the public IP model" />
            </div>

            <!-- Employee Grid -->
            <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                OnRowEditing="gvEmployees_RowEditing"
                OnRowUpdating="gvEmployees_RowUpdating"
                OnRowCancelingEdit="gvEmployees_RowCancelingEdit"
                DataKeyNames="EmployeeId,Role,SiteCode,Status">
                <Columns>
                    <asp:BoundField DataField="EmployeeId" HeaderText="Employee ID" ReadOnly="True" />
                    <asp:BoundField DataField="FullName" HeaderText="Name" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:BoundField DataField="Mobile" HeaderText="Mobile" />

                    <asp:TemplateField HeaderText="Role">
                        <ItemTemplate>
                            <%# Eval("Role") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-control" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Site">
                        <ItemTemplate>
                            <%# Eval("SiteCode") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditSite" runat="server" CssClass="form-control" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Eval("Status") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowEditButton="True" />
                </Columns>
            </asp:GridView>


            
        </main>
    </form>
</body>
</html>
