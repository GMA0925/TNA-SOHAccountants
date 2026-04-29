<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeSettings.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeSettings" %>

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
            max-width: 900px;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
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

        .form-control:focus {
            border-color: #0078D4;
            outline: none;
        }

        .btn {
            padding: 12px 24px;
            font-size: 14px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-primary {
            background-color: #0078D4;
            color: white;
        }

        .btn-primary:hover {
            background-color: #005a9e;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .checkbox-group input {
            margin-right: 10px;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #28a745;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? Settings</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                Logout
            </asp:LinkButton>
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnHome" runat="server" CssClass="nav-btn" OnClick="btnHome_Click">Home</asp:LinkButton>
        <asp:LinkButton ID="btnProfile" runat="server" CssClass="nav-btn" OnClick="btnProfile_Click">My Profile</asp:LinkButton>
        <asp:LinkButton ID="btnPayslip" runat="server" CssClass="nav-btn" OnClick="btnPayslip_Click">Payslips</asp:LinkButton>
        <asp:LinkButton ID="btnDocuments" runat="server" CssClass="nav-btn" OnClick="btnDocuments_Click">Documents</asp:LinkButton>
        <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-btn active" OnClick="btnSettings_Click">Settings</asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">?? Settings</h1>

        <asp:Label ID="lblMessage" runat="server" Visible="false" />

        <!-- Change Password -->
        <section class="form-section">
            <h3>?? Change Password</h3>
            <div class="form-grid">
                <div class="form-group">
                    <label>Current Password:</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                </div>
                <div class="form-group">
                    <label>New Password:</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>
                <div class="form-group">
                    <label>Confirm Password:</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>
            </div>
            <asp:Button ID="btnChangePassword" runat="server" Text="?? Change Password" CssClass="btn btn-primary" OnClick="btnChangePassword_Click" />
        </section>

        <!-- Notification Settings -->
        <section class="form-section">
            <h3>?? Notification Settings</h3>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkEmailNotifications" runat="server" Text="Receive email notifications" Checked="true" />
            </div>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkAttendanceAlerts" runat="server" Text="Send attendance alerts" Checked="true" />
            </div>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkPayslipNotification" runat="server" Text="Notify when payslip is ready" Checked="true" />
            </div>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkLeaveNotification" runat="server" Text="Notify about leave approvals" Checked="true" />
            </div>
            <asp:Button ID="btnSaveNotifications" runat="server" Text="?? Save Preferences" CssClass="btn btn-primary" OnClick="btnSaveNotifications_Click" />
        </section>

        <!-- Account Settings -->
        <section class="form-section">
            <h3>?? Account Settings</h3>
            <div class="form-grid" style="grid-template-columns: 1fr;">
                <div class="checkbox-group">
                    <asp:CheckBox ID="chkTwoFactor" runat="server" Text="Enable two-factor authentication" />
                </div>
            </div>
            <asp:Button ID="btnEnableTwoFactor" runat="server" Text="?? Enable 2FA" CssClass="btn btn-primary" OnClick="btnEnableTwoFactor_Click" />
        </section>

        <!-- Privacy Settings -->
        <section class="form-section">
            <h3>?? Privacy Settings</h3>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkProfileVisibility" runat="server" Text="Allow managers to view my profile" Checked="true" />
            </div>
            <div class="checkbox-group">
                <asp:CheckBox ID="chkDirectoryListing" runat="server" Text="Include me in employee directory" Checked="true" />
            </div>
            <asp:Button ID="btnSavePrivacy" runat="server" Text="?? Save Privacy Settings" CssClass="btn btn-primary" OnClick="btnSavePrivacy_Click" />
        </section>

        <!-- Account Actions -->
        <section class="form-section">
            <h3>? Account Actions</h3>
            <p>
                <asp:Button ID="btnDownloadData" runat="server" Text="?? Download My Data" CssClass="btn btn-primary" OnClick="btnDownloadData_Click" />
            </p>
        </section>

    </main>

</asp:Content>
