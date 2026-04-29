<%@ Page Title="My Payslips" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeePayslips.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeePayslips" %>

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

        .filter-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
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

        .table tbody tr:hover {
            background-color: #f0f0f0;
        }

        .action-link {
            color: #0078D4;
            text-decoration: none;
            cursor: pointer;
            font-weight: bold;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .filter-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="header-bar">
        <span>?? My Payslips</span>
        <div class="logout-section">
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                Logout
            </asp:LinkButton>
        </div>
    </div>

    <nav class="nav-bar">
        <asp:LinkButton ID="btnHome" runat="server" CssClass="nav-btn" OnClick="btnHome_Click">Home</asp:LinkButton>
        <asp:LinkButton ID="btnProfile" runat="server" CssClass="nav-btn" OnClick="btnProfile_Click">My Profile</asp:LinkButton>
        <asp:LinkButton ID="btnPayslip" runat="server" CssClass="nav-btn active" OnClick="btnPayslip_Click">Payslips</asp:LinkButton>
        <asp:LinkButton ID="btnDocuments" runat="server" CssClass="nav-btn" OnClick="btnDocuments_Click">Documents</asp:LinkButton>
        <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-btn" OnClick="btnSettings_Click">Settings</asp:LinkButton>
    </nav>

    <main class="container">
        <h1 class="page-title">?? My Payslips</h1>

        <!-- Filter Section -->
        <section class="form-section">
            <h3>?? Filter Payslips</h3>
            <div class="filter-grid">
                <div class="form-group">
                    <label>Year:</label>
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label>Month:</label>
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- All Months --" Value="" />
                        <asp:ListItem Text="January" Value="1" />
                        <asp:ListItem Text="February" Value="2" />
                        <asp:ListItem Text="March" Value="3" />
                        <asp:ListItem Text="April" Value="4" />
                        <asp:ListItem Text="May" Value="5" />
                        <asp:ListItem Text="June" Value="6" />
                        <asp:ListItem Text="July" Value="7" />
                        <asp:ListItem Text="August" Value="8" />
                        <asp:ListItem Text="September" Value="9" />
                        <asp:ListItem Text="October" Value="10" />
                        <asp:ListItem Text="November" Value="11" />
                        <asp:ListItem Text="December" Value="12" />
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <asp:Button ID="btnSearch" runat="server" Text="?? Search" CssClass="btn" OnClick="btnSearch_Click" />
                </div>
            </div>
        </section>

        <!-- Payslips Grid -->
        <section class="form-section">
            <h3>?? Payslips</h3>
            <asp:GridView ID="gvPayslips" runat="server" AutoGenerateColumns="False" CssClass="table" DataKeyNames="PayslipID" OnRowCommand="gvPayslips_RowCommand">
                <Columns>
                    <asp:BoundField DataField="PayPeriod" HeaderText="Pay Period" />
                    <asp:BoundField DataField="BasicSalary" HeaderText="Basic Salary" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Allowances" HeaderText="Allowances" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="Deductions" HeaderText="Deductions" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="NetSalary" HeaderText="Net Salary" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="PaymentDate" HeaderText="Paid Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDownload" runat="server" CommandName="Download" 
                                CommandArgument='<%# Eval("PayslipID") %>' CssClass="action-link" Text="?? Download" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </section>

    </main>

</asp:Content>
