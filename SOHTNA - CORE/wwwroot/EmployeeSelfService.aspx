<%@ Page Title="Employee Self-Service Portal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeSelfService.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeSelfService" %>

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
            text-align: right;
        }

        .logout-link {
            color: white;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        .version-label {
            color: white;
            font-size: 11px;
            opacity: 0.9;
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
            text-decoration: none;
            display: inline-block;
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
            font-size: 28px;
            color: #0078D4;
            margin-bottom: 30px;
            text-align: center;
            font-weight: bold;
        }

        .welcome-section {
            background: linear-gradient(135deg, #0078D4 0%, #005a9e 100%);
            color: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 120, 212, 0.2);
        }

        .welcome-text {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .welcome-subtext {
            font-size: 14px;
            opacity: 0.9;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: #f9f9f9;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .dashboard-card:hover {
            border-color: #0078D4;
            box-shadow: 0 4px 12px rgba(0, 120, 212, 0.2);
            transform: translateY(-5px);
        }

        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        .card-description {
            font-size: 13px;
            color: #666;
            margin-bottom: 15px;
        }

        .card-link {
            display: inline-block;
            padding: 10px 20px;
            background-color: #0078D4;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .card-link:hover {
            background-color: #005a9e;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #0078D4 0%, #005a9e 100%);
            color: white;
            padding: 20px;
            border-radius: 6px;
            text-align: center;
        }

        .stat-label {
            font-size: 12px;
            opacity: 0.9;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: bold;
        }

        .section-title {
            font-size: 20px;
            color: #0078D4;
            margin-top: 30px;
            margin-bottom: 20px;
            border-bottom: 2px solid #0078D4;
            padding-bottom: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .info-card {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 6px;
            border-left: 4px solid #0078D4;
        }

        .info-label {
            font-size: 11px;
            color: #999;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: bold;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #28a745;
        }

        .btn {
            padding: 12px 24px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            border: none;
            font-weight: bold;
            margin-right: 10px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
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

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .quick-stats {
                grid-template-columns: 1fr;
            }

            .container {
                margin: 20px;
                padding: 15px;
            }

            .page-title {
                font-size: 20px;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? Employee Self-Service Portal</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                <i class="fas fa-sign-out-alt"></i> Logout
            </asp:LinkButton>
            <asp:Label ID="lblVersion" runat="server" CssClass="version-label" />
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnHome" runat="server" CssClass="nav-btn active" OnClick="btnHome_Click">
            <i class="fas fa-home"></i> Home
        </asp:LinkButton>
        <asp:LinkButton ID="btnProfile" runat="server" CssClass="nav-btn" OnClick="btnProfile_Click">
            <i class="fas fa-user"></i> My Profile
        </asp:LinkButton>
        <asp:LinkButton ID="btnPayslip" runat="server" CssClass="nav-btn" OnClick="btnPayslip_Click">
            <i class="fas fa-file-pdf"></i> Payslips
        </asp:LinkButton>
        <asp:LinkButton ID="btnDocuments" runat="server" CssClass="nav-btn" OnClick="btnDocuments_Click">
            <i class="fas fa-folder"></i> Documents
        </asp:LinkButton>
        <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-btn" OnClick="btnSettings_Click">
            <i class="fas fa-cog"></i> Settings
        </asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">?? Employee Self-Service Portal</h1>

        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-text">Welcome, <asp:Label ID="lblEmployeeName" runat="server" Text="Employee" /></div>
            <div class="welcome-subtext">
                Employee ID: <asp:Label ID="lblEmployeeID" runat="server" Text="0000" /> | 
                Department: <asp:Label ID="lblDepartment" runat="server" Text="N/A" />
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="quick-stats">
            <div class="stat-card">
                <div class="stat-label">Today's Status</div>
                <div class="stat-value"><asp:Label ID="lblTodayStatus" runat="server" Text="Present" /></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Leave Balance</div>
                <div class="stat-value"><asp:Label ID="lblLeaveBalance" runat="server" Text="0" /> days</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">This Month Hours</div>
                <div class="stat-value"><asp:Label ID="lblMonthHours" runat="server" Text="0" /> hrs</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Approvals</div>
                <div class="stat-value"><asp:Label ID="lblPendingApprovals" runat="server" Text="0" /></div>
            </div>
        </div>

        <!-- Main Options -->
        <h2 class="section-title">?? Quick Actions</h2>
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">My Profile</div>
                <div class="card-description">View and update personal information</div>
                <asp:LinkButton ID="lnkProfile" runat="server" CssClass="card-link" OnClick="btnProfile_Click">
                    View Profile ?
                </asp:LinkButton>
            </div>

            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">Payslips</div>
                <div class="card-description">Download your payslips and salary details</div>
                <asp:LinkButton ID="lnkPayslip" runat="server" CssClass="card-link" OnClick="btnPayslip_Click">
                    View Payslips ?
                </asp:LinkButton>
            </div>

            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">Documents</div>
                <div class="card-description">Access important employee documents</div>
                <asp:LinkButton ID="lnkDocuments" runat="server" CssClass="card-link" OnClick="btnDocuments_Click">
                    View Documents ?
                </asp:LinkButton>
            </div>

            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">Change Password</div>
                <div class="card-description">Update your login password</div>
                <asp:LinkButton ID="lnkPassword" runat="server" CssClass="card-link" OnClick="btnSettings_Click">
                    Change Password ?
                </asp:LinkButton>
            </div>

            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">Contact Info</div>
                <div class="card-description">Update your phone and email</div>
                <asp:LinkButton ID="lnkContact" runat="server" CssClass="card-link" OnClick="btnProfile_Click">
                    Update Contact ?
                </asp:LinkButton>
            </div>

            <div class="dashboard-card">
                <div class="card-icon">??</div>
                <div class="card-title">Benefits</div>
                <div class="card-description">View your benefits information</div>
                <asp:LinkButton ID="lnkBenefits" runat="server" CssClass="card-link" OnClick="btnDocuments_Click">
                    View Benefits ?
                </asp:LinkButton>
            </div>
        </div>

        <!-- Employee Information Summary -->
        <h2 class="section-title">?? Employee Information</h2>
        <div class="info-grid">
            <div class="info-card">
                <div class="info-label">Employee ID</div>
                <div class="info-value"><asp:Label ID="lblEmpID" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Full Name</div>
                <div class="info-value"><asp:Label ID="lblFullName" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Department</div>
                <div class="info-value"><asp:Label ID="lblDeptName" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Position</div>
                <div class="info-value"><asp:Label ID="lblPosition" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Email</div>
                <div class="info-value"><asp:Label ID="lblEmail" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Phone</div>
                <div class="info-value"><asp:Label ID="lblPhone" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Start Date</div>
                <div class="info-value"><asp:Label ID="lblStartDate" runat="server" Text="N/A" /></div>
            </div>
            <div class="info-card">
                <div class="info-label">Manager</div>
                <div class="info-value"><asp:Label ID="lblManager" runat="server" Text="N/A" /></div>
            </div>
        </div>

        <!-- Recent Activity -->
        <h2 class="section-title">?? Recent Activity</h2>
        <asp:GridView ID="gvRecentActivity" runat="server" AutoGenerateColumns="False" CssClass="table" Style="width: 100%; margin-top: 15px;">
            <HeaderStyle BackColor="#0078D4" ForeColor="white" />
            <RowStyle BackColor="#f9f9f9" />
            <AlternatingRowStyle BackColor="white" />
            <Columns>
                <asp:BoundField DataField="ActivityType" HeaderText="Activity" />
                <asp:BoundField DataField="ActivityDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>

    </main>

</asp:Content>
