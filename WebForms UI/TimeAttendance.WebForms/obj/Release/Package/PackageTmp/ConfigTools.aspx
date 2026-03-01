<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigTools.aspx.cs" Inherits="TimeAttendance.WebForms.ConfigTools" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Config Tools</title>
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
            <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn active" PostBackUrl="~/ConfigTools.aspx" OnClick="btnConfig_Click">
                <i class="fas fa-tools"></i> Config Tools
            </asp:LinkButton>
            <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn" PostBackUrl="~/EmployeeEnrollment.aspx" OnClick="btnEnrollment_Click">
                <i class="fas fa-id-card-alt"></i> Employee Enrollment
            </asp:LinkButton>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="🛠️ Configuration Tools" CssClass="page-title" />

            <!-- Config Form -->
            <section class="form-grid">
                <div>
                    <asp:Label ID="lblSiteCode" runat="server" Text="Default Site Code:" />
                    <asp:TextBox ID="txtSiteCode" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblSyncEndpoint" runat="server" Text="Sync Endpoint URL:" />
                    <asp:TextBox ID="txtSyncEndpoint" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblMiddlewareToggle" runat="server" Text="Enable Middleware Sync:" />
                    <asp:DropDownList ID="ddlMiddlewareToggle" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Enabled" Value="true" />
                        <asp:ListItem Text="Disabled" Value="false" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Label ID="lblDefaultRole" runat="server" Text="Default Role:" />
                    <asp:DropDownList ID="ddlDefaultRole" runat="server" CssClass="form-control" />
                </div>
            </section>

            <!-- Action Buttons -->
            <div style="text-align: right;">
                <asp:Button ID="btnSaveConfig" runat="server" Text="💾 Save Config" CssClass="btn btn-primary" OnClick="btnSaveConfig_Click" />
                <asp:Button ID="btnClearConfig" runat="server" Text="🧹 Clear" CssClass="btn btn-secondary" OnClick="btnClearConfig_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblConfigMessage" runat="server" CssClass="status-label" />
        </main>
    </form>
</body>
</html>
