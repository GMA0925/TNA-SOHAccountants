<%@ Page Title="My Documents" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeDocuments.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeDocuments" %>

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

        .document-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .document-info {
            flex: 1;
        }

        .document-name {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .document-meta {
            font-size: 12px;
            color: #999;
        }

        .document-actions {
            text-align: right;
        }

        .action-link {
            color: #0078D4;
            text-decoration: none;
            cursor: pointer;
            font-weight: bold;
            margin-left: 15px;
        }

        .action-link:hover {
            text-decoration: underline;
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

        @media (max-width: 768px) {
            .document-card {
                flex-direction: column;
                align-items: flex-start;
            }

            .document-actions {
                text-align: left;
                margin-top: 10px;
            }

            .action-link {
                margin-left: 0;
                margin-right: 15px;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? My Documents</span>
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
        <asp:LinkButton ID="btnDocuments" runat="server" CssClass="nav-btn active" OnClick="btnDocuments_Click">Documents</asp:LinkButton>
        <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-btn" OnClick="btnSettings_Click">Settings</asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">?? My Documents</h1>

        <!-- Important Documents -->
        <section class="form-section">
            <h3>?? Important Documents</h3>
            <asp:PlaceHolder ID="phImportantDocs" runat="server" />
        </section>

        <!-- HR Documents -->
        <section class="form-section">
            <h3>?? HR Documents</h3>
            <asp:PlaceHolder ID="phHRDocs" runat="server" />
        </section>

        <!-- Benefits & Insurance -->
        <section class="form-section">
            <h3>?? Benefits & Insurance</h3>
            <asp:PlaceHolder ID="phBenefitsDocs" runat="server" />
        </section>

        <!-- Training & Development -->
        <section class="form-section">
            <h3>?? Training & Development</h3>
            <asp:PlaceHolder ID="phTrainingDocs" runat="server" />
        </section>

    </main>

</asp:Content>
