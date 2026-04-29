<%@ Page Title="Audit Trail" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuditTrail.aspx.cs" Inherits="TimeAttendance.WebForms.AuditTrail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
            position: relative;
        }

        .logout-section {
            position: absolute;
            right: 20px;
            top: 15px;
            color: white;
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
            max-width: 1400px;
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
            color: #333;
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

        .table tbody tr:hover {
            background-color: #f0f0f0;
        }

        .action-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: bold;
        }

        .action-create {
            background-color: #d4edda;
            color: #155724;
        }

        .action-update {
            background-color: #cfe2ff;
            color: #084298;
        }

        .action-delete {
            background-color: #f8d7da;
            color: #842029;
        }

        .action-login {
            background-color: #d1e7dd;
            color: #0a3622;
        }

        .action-export {
            background-color: #fff3cd;
            color: #664d03;
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

            .container {
                margin: 20px;
                padding: 15px;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? Audit Trail</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                Logout
            </asp:LinkButton>
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnAuditTrail" runat="server" CssClass="nav-btn active" OnClick="btnAuditTrail_Click">
            ?? Audit Trail
        </asp:LinkButton>
        <asp:LinkButton ID="btnComplianceStatus" runat="server" CssClass="nav-btn" OnClick="btnComplianceStatus_Click">
            ? Compliance Status
        </asp:LinkButton>
        <asp:LinkButton ID="btnDataAccess" runat="server" CssClass="nav-btn" OnClick="btnDataAccess_Click">
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
        <h1 class="page-title">?? Audit Trail</h1>

        <!-- Statistics -->
        <section class="form-section">
            <h3>?? Statistics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Logs</div>
                    <div class="stat-value"><asp:Label ID="lblTotalLogs" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Today's Activities</div>
                    <div class="stat-value"><asp:Label ID="lblTodayActivities" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Failed Operations</div>
                    <div class="stat-value"><asp:Label ID="lblFailedOps" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Data Exports</div>
                    <div class="stat-value"><asp:Label ID="lblDataExports" runat="server" Text="0" /></div>
                </div>
            </div>
        </section>

        <!-- Filter Section -->
        <section class="form-section">
            <h3>?? Filter Audit Logs</h3>
            <div class="filter-grid">
                <div class="form-group">
                    <label>Employee:</label>
                    <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Action Type:</label>
                    <asp:DropDownList ID="ddlActionType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All --" Value="" />
                        <asp:ListItem Text="Create" Value="Create" />
                        <asp:ListItem Text="Read" Value="Read" />
                        <asp:ListItem Text="Update" Value="Update" />
                        <asp:ListItem Text="Delete" Value="Delete" />
                        <asp:ListItem Text="Login" Value="Login" />
                        <asp:ListItem Text="Logout" Value="Logout" />
                        <asp:ListItem Text="Export" Value="Export" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Entity Type:</label>
                    <asp:DropDownList ID="ddlEntityType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All --" Value="" />
                        <asp:ListItem Text="Employee" Value="Employee" />
                        <asp:ListItem Text="Leave" Value="Leave" />
                        <asp:ListItem Text="Timesheet" Value="Timesheet" />
                        <asp:ListItem Text="Payroll" Value="Payroll" />
                        <asp:ListItem Text="User" Value="User" />
                        <asp:ListItem Text="Report" Value="Report" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>From Date:</label>
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="DateTime" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>To Date:</label>
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="DateTime" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnSearch" runat="server" Text="?? Search" CssClass="btn" OnClick="btnSearch_Click" />
                </div>
            </div>
        </section>

        <!-- Audit Log Grid -->
        <section class="form-section">
            <h3>?? Audit Logs</h3>
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvAuditLogs" runat="server" AutoGenerateColumns="False" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="AuditDate" HeaderText="Date/Time" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                        <asp:BoundField DataField="Username" HeaderText="User" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <span class="action-badge action-<%# Eval("ActionType").ToString().ToLower() %>">
                                    <%# Eval("ActionType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="EntityType" HeaderText="Entity Type" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="IPAddress" HeaderText="IP Address" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# ((bool)Eval("Success")) ? "? Success" : "? Failed" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </section>

    </main>

</asp:Content>
