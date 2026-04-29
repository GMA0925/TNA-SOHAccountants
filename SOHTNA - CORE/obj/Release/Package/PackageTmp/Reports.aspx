<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TimeAttendance.WebForms.Reports" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

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
            display: block;
            margin-bottom: 5px;
        }

            .logout-link:hover {
                text-decoration: underline;
            }

        .version-label {
            color: white;
            font-size: 11px;
            opacity: 0.9;
            margin-top: 3px;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow-x: auto;
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

        .btn-success {
            background-color: #6c757d;
            color: white;
        }

            .btn-success:hover {
                background-color: #5a6268;
            }

        .btn-danger {
            background-color: #6c757d;
            color: white;
        }

            .btn-danger:hover {
                background-color: #5a6268;
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

        .status-label {
            display: block;
            margin-top: 10px;
        }
    </style>
</head>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {
    var isPostBack = '<%= IsPostBack.ToString().ToLower() %>';

    if (isPostBack === 'false') {
        var today = new Date();
        var yyyy = today.getFullYear();
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var dd = String(today.getDate()).padStart(2, '0');
        var formatted = yyyy + '-' + mm + '-' + dd;

        document.getElementById("<%= txtFromDate.ClientID %>").value = formatted;
        document.getElementById("<%= txtToDate.ClientID %>").value = formatted;

        document.getElementById("<%= ddlQuickRange.ClientID %>").value = "Today";
    }

    // Capture client local time before every postback
    var form = document.getElementById('form1');
    if (form) {
        form.addEventListener('submit', function () {
            var now = new Date();
            var pad = function (n) { return String(n).padStart(2, '0'); };
            var localIso = now.getFullYear() + '-' + pad(now.getMonth() + 1) + '-' + pad(now.getDate()) + 'T' +
                           pad(now.getHours()) + ':' + pad(now.getMinutes()) + ':' + pad(now.getSeconds());
            document.getElementById('<%= hfClientNow.ClientID %>').value = localIso;
        });
    }
});
</script>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfClientNow" runat="server" />
        <!-- Header -->
        <header class="header-bar">
            <span><i class="fas fa-chart-line"></i>Time &amp; Attendance Portal</span>
            <div class="logout-section">
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </asp:LinkButton>
                <asp:Label ID="lblVersion" runat="server" CssClass="version-label" />
            </div>
        </header>

        <!-- Navigation -->
        <uc:Navigation runat="server" ID="navControl" />

        <!-- Main Content -->
        <main class="container">
            <span class="page-title">&#128202; Reports Dashboard</span>

            <!-- Filters -->
            <section class="filter-panel">
                <div>
                    <asp:Label ID="lblSite" runat="server" Text="Site:" Font-Bold="true" />
                    <asp:DropDownList ID="ddlSites" runat="server" CssClass="form-control" />
                </div>
                <div>
                    <asp:Label ID="lblReportType" runat="server" Text="Report Type:" Font-Bold="true" />
                    <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control">
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
                    <asp:Label ID="lblFrom" runat="server" Text="From Date:" Font-Bold="true" />
                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div>
                    <asp:Label ID="lblTo" runat="server" Text="To Date:" Font-Bold="true" />
                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div>
                    <asp:Label ID="lblQuickRange" runat="server" Text="Quick Range:" Font-Bold="true" />
                    <asp:DropDownList ID="ddlQuickRange" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlQuickRange_SelectedIndexChanged">
                        <asp:ListItem Text="Today" Value="Today" />
                        <asp:ListItem Text="Yesterday" Value="Yesterday" />
                        <asp:ListItem Text="Last 3 Days" Value="Last3" />
                        <asp:ListItem Text="Last Week" Value="LastWeek" />
                        <asp:ListItem Text="This Month" Value="ThisMonth" />
                        <asp:ListItem Text="Last Month" Value="LastMonth" />
                        <asp:ListItem Text="Last 3 Months" Value="Last3Months" />
                        <asp:ListItem Text="Last 6 Months" Value="Last6Months" />
                    </asp:DropDownList>
                </div>
            </section>

            <!-- Action Buttons -->
            <div style="margin-top: 10px; text-align: right;">
                <asp:CheckBox ID="chkIncludeFinancials" runat="server" Text=" Include Financials" Checked="false" Style="font-weight: bold; margin-right: 15px; vertical-align: middle;" />
                <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" CssClass="btn btn-primary" OnClick="btnGenerateReport_Click" Style="font-weight: bold" />
                <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" CssClass="btn btn-success" OnClick="btnExportExcel_Click" Style="font-weight: bold" />
                <asp:Button ID="btnExportPDF" runat="server" Text="Export to PDF" CssClass="btn btn-danger" OnClick="btnExportPDF_Click" Style="font-weight: bold" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-label" />

            <!-- Report Grid -->
            <asp:GridView ID="gvReports" runat="server" CssClass="table table-striped" AutoGenerateColumns="False"
                AllowPaging="True" PageSize="50" Font-Size="Small"
                OnPageIndexChanging="gvReports_PageIndexChanging"
                OnRowDataBound="gvReports_RowDataBound">
            </asp:GridView>
        </main>
    </form>
</body>
</html>

