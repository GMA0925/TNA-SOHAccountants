<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TimeAttendance.WebForms.Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reports Dashboard</title>
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

        .filter-panel {
            margin-bottom: 30px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            <i class="fas fa-chart-line"></i> Time & Attendance Portal
        </header>

        <!-- Navigation -->
        <nav class="nav-bar" style="background-color:#e9ecef; padding:10px; text-align:center;">
            <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" PostBackUrl="~/Dashboard.aspx" OnClick="btnDashboard_Click">
                <i class="fas fa-home"></i> Dashboard
            </asp:LinkButton>

            <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn active" PostBackUrl="~/Reports.aspx" OnClick="btnReports_Click">
                <i class="fas fa-chart-bar"></i> Reports
            </asp:LinkButton>

            <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="nav-btn" PostBackUrl="~/SyncLog.aspx" OnClick="btnSyncLog_Click">
                <i class="fas fa-sync"></i> Sync Log
            </asp:LinkButton>

            <asp:LinkButton ID="btnUsers" runat="server" CssClass="nav-btn" OnClick="btnUsers_Click">
                <i class="fas fa-users"></i> User Management
            </asp:LinkButton>

            <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn" PostBackUrl="~/ConfigTools.aspx" OnClick="btnConfig_Click">
                <i class="fas fa-tools"></i> Config Tools
            </asp:LinkButton>

            <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn" PostBackUrl="~/Admin/EmployeeEnrollment.aspx" OnClick="btnEnrollment_Click" Visible="true">
                <i class="fas fa-id-card-alt"></i> Employee Enrollment
            </asp:LinkButton>
        </nav>


        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="📊 Reports Dashboard" CssClass="page-title" />

            <!-- Filter Section -->
            <section class="filter-panel">
                <div>
                    <asp:Label ID="lblSite" runat="server" Text="Site:" />
                    <asp:DropDownList ID="ddlSites" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddlSites_SelectedIndexChanged" />
                </div>
                <div>
                    <asp:Label ID="lblReportType" runat="server" Text="Report Type:" />
                    <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
                        <asp:ListItem Text="Per Site" Value="Site" />
                        <asp:ListItem Text="Per Person" Value="Person" />
                        <asp:ListItem Text="Per Shift" Value="Shift" />
                        <asp:ListItem Text="Per Reader" Value="Reader" />
                        <asp:ListItem Text="Emulated Events" Value="Emulated" />
                        <asp:ListItem Text="Sync Failures" Value="SyncFail" />
                        <asp:ListItem Text="Hourly Activity" Value="Hourly" />
                        <asp:ListItem Text="Top Users" Value="TopUsers" />
                        <asp:ListItem Text="Missing Scans" Value="Missing" />
                        <asp:ListItem Text="Multi-Site Rollup" Value="Rollup" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Label ID="lblFrom" runat="server" Text="From Date:" />
                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div>
                    <asp:Label ID="lblTo" runat="server" Text="To Date:" />
                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>

                <!-- Conditional Filters -->
                <asp:Panel ID="pnlPerson" runat="server" CssClass="form-group" Visible="false">
                    <asp:Label ID="lblPerson" runat="server" Text="Person Name:" />
                    <asp:TextBox ID="txtPerson" runat="server" CssClass="form-control" />
                </asp:Panel>

                <asp:Panel ID="pnlShift" runat="server" CssClass="form-group" Visible="false">
                    <asp:Label ID="lblShift" runat="server" Text="Shift Code:" />
                    <asp:TextBox ID="txtShift" runat="server" CssClass="form-control" />
                </asp:Panel>

                <asp:Panel ID="pnlReader" runat="server" CssClass="form-group" Visible="false">
                    <asp:Label ID="lblReader" runat="server" Text="Reader ID:" />
                    <asp:TextBox ID="txtReader" runat="server" CssClass="form-control" />
                </asp:Panel>
            </section>

            <!-- Action Buttons -->
            <div style="margin-top: 10px; text-align: right;">
                <asp:Button ID="btnGenerate" runat="server" Text="Generate Report" CssClass="btn btn-primary" OnClick="btnGenerate_Click" />
                <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" CssClass="btn btn-success" OnClick="btnExportExcel_Click" />
                <asp:Button ID="btnExportPdf" runat="server" Text="Export to PDF" CssClass="btn btn-danger" OnClick="btnExportPdf_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-label" ForeColor="Red" />

            <!-- Report Grid -->
            <asp:GridView ID="dgvReport" runat="server" CssClass="table table-striped" AutoGenerateColumns="true" Font-Size="Small" />
        </main>
    </form>
</body>

</html>

