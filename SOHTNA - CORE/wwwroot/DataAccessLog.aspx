<%@ Page Title="Data Access Log" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DataAccessLog.aspx.cs" Inherits="TimeAttendance.WebForms.DataAccessLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
        }

        .header-bar {
            background-color: #0078D4;
            color: white;
            padding: 15px;
            font-size: 20px;
            font-weight: bold;
            text-align: center;
            position: relative;
        }

        .logout-section {
            position: absolute;
            right: 20px;
            top: 15px;
        }

        .logout-link {
            color: white;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        .nav-bar {
            background-color: #e9ecef;
            padding: 10px;
            text-align: center;
        }

        .nav-btn {
            margin: 0 10px;
            padding: 8px 16px;
            font-size: 14px;
            background-color: #0078D4;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .nav-btn:hover {
            background-color: #005a9e;
        }

        .nav-btn.active {
            background-color: #005a9e;
            font-weight: bold;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 24px;
            color: #0078D4;
            margin-bottom: 20px;
            border-bottom: 2px solid #0078D4;
            padding-bottom: 10px;
        }

        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 6px;
            border-left: 4px solid #0078D4;
        }

        .form-section h3 {
            margin-top: 0;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-control {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            background-color: #0078D4;
            color: white;
        }

        .btn:hover {
            background-color: #005a9e;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 12px;
        }

        .table thead {
            background-color: #0078D4;
            color: white;
        }

        .table th, .table td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .access-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: bold;
        }

        .access-view {
            background-color: #d1e7dd;
            color: #0a3622;
        }

        .access-export {
            background-color: #fff3cd;
            color: #664d03;
        }

        .access-print {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .access-download {
            background-color: #cfe2ff;
            color: #084298;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: linear-gradient(135deg, #0078D4 0%, #005a9e 100%);
            color: white;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
        }

        .stat-label {
            font-size: 12px;
            opacity: 0.9;
        }

        .stat-value {
            font-size: 28px;
            font-weight: bold;
            margin: 5px 0;
        }

        @media (max-width: 768px) {
            .filter-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? Data Access Log</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                Logout
            </asp:LinkButton>
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnAuditTrail" runat="server" CssClass="nav-btn" OnClick="btnAuditTrail_Click">
            ?? Audit Trail
        </asp:LinkButton>
        <asp:LinkButton ID="btnComplianceStatus" runat="server" CssClass="nav-btn" OnClick="btnComplianceStatus_Click">
            ? Compliance Status
        </asp:LinkButton>
        <asp:LinkButton ID="btnDataAccess" runat="server" CssClass="nav-btn active" OnClick="btnDataAccess_Click">
            ?? Data Access
        </asp:LinkButton>
        <asp:LinkButton ID="btnViolations" runat="server" CssClass="nav-btn" OnClick="btnViolations_Click">
            ?? Violations
        </asp:LinkButton>
        <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn" OnClick="btnReports_Click">
            ?? Reports
        </asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">?? Data Access Log</h1>

        <!-- Statistics -->
        <section class="form-section">
            <h3>?? Access Statistics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Accesses</div>
                    <div class="stat-value"><asp:Label ID="lblTotalAccess" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Exports</div>
                    <div class="stat-value"><asp:Label ID="lblExports" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Sensitive Data Views</div>
                    <div class="stat-value"><asp:Label ID="lblSensitiveAccess" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Unauthorized Attempts</div>
                    <div class="stat-value"><asp:Label ID="lblUnauthorized" runat="server" Text="0" /></div>
                </div>
            </div>
        </section>

        <!-- Filter Section -->
        <section class="form-section">
            <h3>?? Filter Access Logs</h3>
            <div class="filter-grid">
                <div class="form-group">
                    <label>User:</label>
                    <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Data Type:</label>
                    <asp:DropDownList ID="ddlDataType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All --" Value="" />
                        <asp:ListItem Text="Employee" Value="Employee" />
                        <asp:ListItem Text="Payroll" Value="Payroll" />
                        <asp:ListItem Text="Leave Balance" Value="LeaveBalance" />
                        <asp:ListItem Text="Attendance" Value="Attendance" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Access Type:</label>
                    <asp:DropDownList ID="ddlAccessType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All --" Value="" />
                        <asp:ListItem Text="View" Value="View" />
                        <asp:ListItem Text="Export" Value="Export" />
                        <asp:ListItem Text="Print" Value="Print" />
                        <asp:ListItem Text="Download" Value="Download" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Date Range:</label>
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnSearch" runat="server" Text="?? Search" CssClass="btn" OnClick="btnSearch_Click" />
                </div>
            </div>
        </section>

        <!-- Data Access Grid -->
        <section class="form-section">
            <h3>?? Data Access Records</h3>
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvAccessLog" runat="server" AutoGenerateColumns="False" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="AccessDate" HeaderText="Date/Time" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                        <asp:BoundField DataField="UserName" HeaderText="User" />
                        <asp:BoundField DataField="DataType" HeaderText="Data Type" />
                        <asp:TemplateField HeaderText="Access Type">
                            <ItemTemplate>
                                <span class="access-badge access-<%# Eval("AccessType").ToString().ToLower() %>">
                                    <%# Eval("AccessType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Purpose" HeaderText="Purpose" />
                        <asp:TemplateField HeaderText="Authorized">
                            <ItemTemplate>
                                <%# ((bool)Eval("IsAuthorized")) ? "? Yes" : "? No" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </section>

    </main>

</asp:Content>
