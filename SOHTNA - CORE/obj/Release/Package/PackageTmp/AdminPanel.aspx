<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="TimeAttendance.WebForms.AdminPanel" %>

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

        .admin-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .admin-card {
            background: white;
            border: 2px solid #0078D4;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s;
        }

        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .admin-card-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }

        .admin-card-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .admin-card-description {
            font-size: 13px;
            color: #666;
            margin-bottom: 15px;
        }

        .btn {
            padding: 12px 24px;
            font-size: 14px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            background-color: #0078D4;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background-color: #005a9e;
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

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
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

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 13px;
        }

        .table thead {
            background-color: #0078D4;
            color: white;
        }

        .table th, .table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: bold;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
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
            .admin-grid {
                grid-template-columns: 1fr;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="header-bar">
        <span>????? Admin Panel</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                Logout
            </asp:LinkButton>
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" OnClick="btnDashboard_Click">
            ?? Dashboard
        </asp:LinkButton>
        <asp:LinkButton ID="btnAdminPanel" runat="server" CssClass="nav-btn active" OnClick="btnAdminPanel_Click">
            ????? Admin Panel
        </asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">????? Administration Panel</h1>

        <!-- System Statistics -->
        <section class="form-section">
            <h3>?? System Statistics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Users</div>
                    <div class="stat-value"><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Active Employees</div>
                    <div class="stat-value"><asp:Label ID="lblActiveEmployees" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Departments</div>
                    <div class="stat-value"><asp:Label ID="lblDepartments" runat="server" Text="0" /></div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">System Uptime</div>
                    <div class="stat-value"><asp:Label ID="lblUptime" runat="server" Text="99.9%" /></div>
                </div>
            </div>
        </section>

        <!-- Admin Tools -->
        <h2 style="color: #0078D4; margin-top: 30px;">?? Admin Tools</h2>
        <div class="admin-grid">
            <div class="admin-card">
                <div class="admin-card-icon">??</div>
                <div class="admin-card-title">System Settings</div>
                <div class="admin-card-description">Configure general system settings, email, security, and features</div>
                <asp:HyperLink ID="hlkSettings" runat="server" CssClass="btn" NavigateUrl="~/SystemSettings.aspx">
                    Access Settings
                </asp:HyperLink>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon">??</div>
                <div class="admin-card-title">User Management</div>
                <div class="admin-card-description">Create, edit, and manage system users and roles</div>
                <asp:HyperLink ID="hlkUserManagement" runat="server" CssClass="btn" NavigateUrl="~/UserManagement.aspx">
                    Manage Users
                </asp:HyperLink>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon">??</div>
                <div class="admin-card-title">Audit Trail</div>
                <div class="admin-card-description">View all system activities and audit logs</div>
                <asp:HyperLink ID="hlkAuditTrail" runat="server" CssClass="btn" NavigateUrl="~/AuditTrail.aspx">
                    View Logs
                </asp:HyperLink>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon">?</div>
                <div class="admin-card-title">Compliance</div>
                <div class="admin-card-description">Monitor compliance status and violations</div>
                <asp:HyperLink ID="hlkCompliance" runat="server" CssClass="btn" NavigateUrl="~/ComplianceStatus.aspx">
                    View Compliance
                </asp:HyperLink>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon">??</div>
                <div class="admin-card-title">Data Security</div>
                <div class="admin-card-description">Monitor data access and unauthorized attempts</div>
                <asp:HyperLink ID="hlkDataAccess" runat="server" CssClass="btn" NavigateUrl="~/DataAccessLog.aspx">
                    View Access Logs
                </asp:HyperLink>
            </div>

            <div class="admin-card">
                <div class="admin-card-icon">??</div>
                <div class="admin-card-title">Reports</div>
                <div class="admin-card-description">Generate system and compliance reports</div>
                <asp:HyperLink ID="hlkReports" runat="server" CssClass="btn" NavigateUrl="~/ComplianceReports.aspx">
                    Generate Reports
                </asp:HyperLink>
            </div>
        </div>

        <!-- Holiday Calendar Management -->
        <section class="form-section">
            <h3>?? Holiday Calendar</h3>
            <div class="form-grid">
                <div class="form-group">
                    <label>Holiday Name:</label>
                    <asp:TextBox ID="txtHolidayName" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Holiday Date:</label>
                    <asp:TextBox ID="txtHolidayDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="form-group">
                    <label>Holiday Type:</label>
                    <asp:DropDownList ID="ddlHolidayType" runat="server" CssClass="form-control">
                        <asp:ListItem Text="National" Value="National" />
                        <asp:ListItem Text="Regional" Value="Regional" />
                        <asp:ListItem Text="Corporate" Value="Corporate" />
                        <asp:ListItem Text="Optional" Value="Optional" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnAddHoliday" runat="server" Text="? Add Holiday" CssClass="btn" OnClick="btnAddHoliday_Click" />
                </div>
            </div>
            <asp:GridView ID="gvHolidays" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="gvHolidays_RowCommand">
                <Columns>
                    <asp:BoundField DataField="HolidayName" HeaderText="Holiday Name" />
                    <asp:BoundField DataField="HolidayDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="HolidayType" HeaderText="Type" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("HolidayID") %>'
                                Text="??? Delete" OnClientClick="return confirm('Are you sure?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </section>

        <!-- System Health -->
        <section class="form-section">
            <h3>?? System Health</h3>
            <div class="form-grid">
                <div class="form-group">
                    <label>Database Connection:</label>
                    <span class="status-badge status-active">? Connected</span>
                </div>
                <div class="form-group">
                    <label>Email Service:</label>
                    <span class="status-badge status-active">? Active</span>
                </div>
                <div class="form-group">
                    <label>Backup Status:</label>
                    <span class="status-badge status-active">? Last: Today 02:00 AM</span>
                </div>
                <div class="form-group">
                    <label>Disk Space:</label>
                    <span class="status-badge status-active">? 85% Available</span>
                </div>
            </div>
            <asp:Button ID="btnRunMaintenance" runat="server" Text="?? Run Maintenance" CssClass="btn" OnClick="btnRunMaintenance_Click" />
        </section>

    </main>

</asp:Content>
