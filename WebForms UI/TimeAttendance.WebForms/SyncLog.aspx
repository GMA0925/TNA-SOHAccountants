<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SyncLog.aspx.cs" Inherits="TimeAttendance.WebForms.SyncLog" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sync Log</title>
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

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: auto;
        }

        .table th, .table td {
            padding: 10px;
            border: 1px solid #ddd;
            word-break: break-word;
            white-space: normal;
        }

        .table-striped tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .table-striped th {
            background-color: #0078D4;
            color: white;
        }

        .grid-wrapper {
            overflow-x: auto;
            max-width: 100%;
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

        .toast-label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
            color: #0078D4;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        &nbsp;<!-- Header --><header class="header-bar">
            <i class="fas fa-id-card-alt"></i> Time & Attendance Portal
        </header>

        <!-- Navigation -->
        <nav class="nav-bar" style="background-color:#e9ecef; padding:10px; text-align:center;">
            <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" PostBackUrl="~/Dashboard.aspx" OnClick="btnDashboard_Click"> <i class="fas fa-home"></i>Dashboard </asp:LinkButton>
            <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn" PostBackUrl="~/Reports.aspx" OnClick="btnReports_Click"> <i class="fas fa-chart-bar"></i>Reports </asp:LinkButton>
            <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="nav-btn active" PostBackUrl="~/SyncLog.aspx" OnClick="btnSyncLog_Click"> <i class="fas fa-sync"></i>Sync Log </asp:LinkButton>
            <asp:LinkButton ID="btnUsers" runat="server" CssClass="nav-btn" PostBackUrl="~/UserManagement.aspx" OnClick="btnUsers_Click"> <i class="fas fa-users"></i>User Management </asp:LinkButton>
            <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn" PostBackUrl="~/ConfigTools.aspx" OnClick="btnConfig_Click"> <i class="fas fa-tools"></i>Config Tools </asp:LinkButton>
            <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn" PostBackUrl="~/EmployeeEnrollment.aspx" OnClick="btnEnrollment_Click"> <i class="fas fa-id-card-alt"></i>Employee Enrollment </asp:LinkButton>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="🔍 Sync Log Viewer" CssClass="page-title" />

            <!-- Toast Message -->
            <asp:Label ID="lblToast" runat="server" CssClass="toast-label" />

            <!-- Refresh Button -->
            <div style="text-align: right;">
                <asp:Button ID="btnRefreshLog" runat="server" Text="🔄 Refresh Log" CssClass="btn btn-primary" OnClick="btnRefreshLog_Click" />
            </div>
            <!-- Page Size Dropdown -->
            <div style="margin-bottom: 15px;">
                <asp:Label ID="lblPageSize" runat="server" Text="Rows per page:" />
                <asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged" CssClass="form-control" Width="120px">
                    <asp:ListItem Text="10" Value="10" />
                    <asp:ListItem Text="25" Value="25" />
                    <asp:ListItem Text="50" Value="50" />
                    <asp:ListItem Text="100" Value="100" />
                </asp:DropDownList>
            </div>

            <!-- Export Buttons -->
            <div style="margin-bottom: 15px; text-align: right;">
                <asp:Button ID="btnExportExcel" runat="server" Text="📤 Export to Excel" CssClass="btn btn-primary" OnClick="btnExportExcel_Click" />
                <asp:Button ID="btnExportPdf" runat="server" Text="📄 Export to PDF" CssClass="btn btn-secondary" OnClick="btnExportPdf_Click" />
            </div>

            <!-- Sync Log Grid -->

            <!-- Sync Log Grid -->
            <div class="grid-wrapper">
                <asp:GridView ID="gvSyncLog" runat="server" AutoGenerateColumns="true" CssClass="table table-striped table-bordered" Font-Size="Small" OnPageIndexChanging="gvSyncLog_PageIndexChanging" />
            </div>
        </main>
    </form>
</body>
</html>
