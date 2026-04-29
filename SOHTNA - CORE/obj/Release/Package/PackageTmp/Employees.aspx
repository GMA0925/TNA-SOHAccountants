<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Employees.aspx.cs" Inherits="TimeAttendance.WebForms.Employees" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employees</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="Content/snackbar.css" rel="stylesheet" />
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
        }

        .page-title {
            font-size: 22px;
            color: #0078D4;
            margin-bottom: 5px;
            display: block;
            text-align: center;
        }

        .sync-bar {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            min-width: 100px;
            max-width: 100%;
            box-sizing: border-box;
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

        .btn-primary:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            overflow-x: auto;
        }

        .table th, .table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
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

        .section-title {
            font-size: 18px;
            color: #0078D4;
            margin-top: 30px;
            margin-bottom: 15px;
            font-weight: bold;
            border-bottom: 2px solid #0078D4;
            padding-bottom: 10px;
        }

        .status-label {
            display: block;
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
            background-color: #e8f4f8;
        }

        /* ===== EDIT POPUP MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-content {
            background-color: #fff;
            border-radius: 8px;
            padding: 30px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #0078D4;
        }

        .modal-header h3 {
            color: #0078D4;
            font-size: 20px;
            margin: 0;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.2s;
        }

        .modal-close:hover {
            background-color: #f0f0f0;
            color: #333;
        }

        .modal-form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .modal-form-grid .form-group {
            display: flex;
            flex-direction: column;
        }

        .modal-form-grid .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        /* ===== CLICKABLE ROWS ===== */
        .table-striped tbody tr {
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .table-striped tbody tr:hover {
            background-color: #e8f0fe !important;
        }

        .table-striped tbody tr.selected-row {
            background-color: #d0e4f7 !important;
            border-left: 3px solid #0078D4;
        }

        /* ===== FILTER INPUT ===== */
        .filter-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        .filter-bar input {
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            flex: 1;
            max-width: 400px;
            transition: all 0.3s;
        }

        .filter-bar input:focus {
            outline: none;
            border-color: #0078D4;
            box-shadow: 0 0 0 3px rgba(0, 120, 212, 0.1);
        }

        .filter-bar i {
            color: #999;
            font-size: 14px;
        }

        .filter-count {
            color: #666;
            font-size: 13px;
            margin-left: auto;
        }

        @media (max-width: 768px) {
            .modal-form-grid {
                grid-template-columns: 1fr;
            }

            .modal-content {
                width: 95%;
                padding: 20px;
            }
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header-bar">
            <span><i class="fas fa-id-card-alt"></i> Time & Attendance Portal</span>
            <div class="logout-section">
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </asp:LinkButton>
                <asp:Label ID="lblVersion" runat="server" CssClass="version-label" />
            </div>
        </header>

        <!-- Unified Navigation -->
        <uc:Navigation runat="server" ID="navControl" />

        <!-- Main Content -->
        <main class="container">
            <asp:Label ID="lblTitle" runat="server" Text="👥 Employees" CssClass="page-title" />

            <!-- Sync Employees Button -->
            <div class="sync-bar">
                <asp:Button ID="btnSyncEmployees" runat="server" Text="🔄 Sync Employees" CssClass="btn btn-primary" OnClick="btnSyncEmployees_Click" OnClientClick="return onSyncClick();" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblMessage" runat="server" CssClass="status-label" ForeColor="Green" />

            <!-- Hidden fields for form controls that code-behind references -->
            <asp:TextBox ID="txtEmpId" runat="server" Visible="false" />
            <asp:TextBox ID="txtName" runat="server" Visible="false" />
            <asp:TextBox ID="txtEmail" runat="server" Visible="false" />
            <asp:TextBox ID="txtMobile" runat="server" Visible="false" />
            <asp:DropDownList ID="ddlRole" runat="server" Visible="false">
                <asp:ListItem Text="-- Select Role --" Value="" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlDepartmentEnroll" runat="server" Visible="false" />
            <asp:DropDownList ID="ddlShiftAssign" runat="server" Visible="false" />
            <asp:DropDownList ID="ddlShiftPatternEnroll" runat="server" Visible="false">
                <asp:ListItem Text="-- Select Pattern --" Value="" />
            </asp:DropDownList>
            <asp:CheckBox ID="chkOvertimeEnroll" runat="server" Visible="false" />
            <asp:DropDownList ID="ddlPayType" runat="server" Visible="false">
                <asp:ListItem Text="-- Select Pay Type --" Value="" />
            </asp:DropDownList>
            <asp:TextBox ID="txtHourlyRate" runat="server" Visible="false" />
            <asp:TextBox ID="txtWeeklyRate" runat="server" Visible="false" />
            <asp:TextBox ID="txtMonthlyRate" runat="server" Visible="false" />
            <asp:Button ID="btnSave" runat="server" Visible="false" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Visible="false" OnClick="btnClear_Click" />
            <asp:Button ID="btnMiddleware" runat="server" Visible="false" OnClick="btnMiddleware_Click" />

            <!-- Filter Section -->
            <div class="section-title">👥 Employee List</div>
            <div style="margin-bottom: 15px; display: flex; gap: 20px;">
                <div>
                    <asp:Label ID="lblFilter" runat="server" Text="Filter by Status:" />
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" CssClass="form-control"
                        OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged" Width="300px">
                        <asp:ListItem Text="-- All Employees --" Value="All" />
                        <asp:ListItem Text="Active Only" Value="Active" />
                        <asp:ListItem Text="Inactive Only" Value="Inactive" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Label ID="lblSiteFilter" runat="server" Text="Filter by Site:" />
                    <asp:DropDownList ID="ddlSiteFilter" runat="server" AutoPostBack="true" CssClass="form-control"
                        OnSelectedIndexChanged="ddlSiteFilter_SelectedIndexChanged" Width="300px" />
                </div>
            </div>

            <!-- Employee Grid -->
            <div class="filter-bar">
                <i class="fas fa-search"></i>
                <input type="text" id="txtFilterEmployees" placeholder="Filter employees..." onkeyup="filterGrid(this, 'gvEmployees', 'empFilterCount')" />
                <span id="empFilterCount" class="filter-count"></span>
            </div>
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                    OnSelectedIndexChanged="gvEmployees_SelectedIndexChanged"
                    OnRowDataBound="gvEmployees_RowDataBound"
                    DataKeyNames="EmployeeID">
                    <Columns>
                        <asp:BoundField DataField="EmployeeID" HeaderText="Employee ID" />
                        <asp:BoundField DataField="EmployeeCode" HeaderText="Employee Code" />
                        <asp:BoundField DataField="FullName" HeaderText="Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
                        <asp:BoundField DataField="Department" HeaderText="Department" />
                        <asp:BoundField DataField="Shift" HeaderText="Shift" />
                        <asp:BoundField DataField="PayType" HeaderText="Pay Type" />
                        <asp:BoundField DataField="HourlyRate" HeaderText="Hourly Rate" DataFormatString="{0:N2}" HtmlEncode="false" />
                        <asp:BoundField DataField="WeeklyRate" HeaderText="Weekly Rate" DataFormatString="{0:N2}" HtmlEncode="false" />
                        <asp:BoundField DataField="MonthlyRate" HeaderText="Monthly Rate" DataFormatString="{0:N2}" HtmlEncode="false" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                    </Columns>
                </asp:GridView>
            </div>
        </main>

        <!-- Edit Employee Popup Modal -->
        <asp:Panel ID="pnlEditModal" runat="server" CssClass="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>✏️ Edit Employee</h3>
                    <asp:Button ID="btnModalClose" runat="server" Text="✕" CssClass="modal-close" OnClick="btnModalClose_Click" CausesValidation="false" />
                </div>
                <asp:HiddenField ID="hdnEditEmployeeID" runat="server" />
                <div class="modal-form-grid">
                    <div class="form-group">
                        <label>Employee ID:</label>
                        <asp:TextBox ID="txtEditEmpId" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f0f0f0" />
                    </div>
                    <div class="form-group">
                        <label>Employee Code:</label>
                        <asp:TextBox ID="txtEditEmployeeCode" runat="server" CssClass="form-control" placeholder="e.g. EMP001" />
                    </div>
                    <div class="form-group">
                        <label>Full Name:</label>
                        <asp:TextBox ID="txtEditName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="txtEditEmail" runat="server" CssClass="form-control" TextMode="Email" />
                    </div>
                    <div class="form-group">
                        <label>Mobile:</label>
                        <asp:TextBox ID="txtEditMobile" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Department:</label>
                        <asp:DropDownList ID="ddlEditDepartment" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Assigned Shift:</label>
                        <asp:DropDownList ID="ddlEditShift" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Pay Type:</label>
                        <asp:DropDownList ID="ddlEditPayType" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Pay Type --" Value="" />
                            <asp:ListItem Text="Hourly" Value="Hourly" />
                            <asp:ListItem Text="Weekly" Value="Weekly" />
                            <asp:ListItem Text="Monthly" Value="Monthly" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Shift Pattern:</label>
                        <asp:DropDownList ID="ddlEditShiftPattern" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Pattern --" Value="" />
                            <asp:ListItem Text="Monday to Friday" Value="M-F" />
                            <asp:ListItem Text="Random" Value="Random" />
                            <asp:ListItem Text="Sporadic" Value="Sporadic" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Hourly Rate:</label>
                        <asp:TextBox ID="txtEditHourlyRate" runat="server" CssClass="form-control rate-input" />
                    </div>
                    <div class="form-group">
                        <label>Weekly Rate:</label>
                        <asp:TextBox ID="txtEditWeeklyRate" runat="server" CssClass="form-control rate-input" />
                    </div>
                    <div class="form-group">
                        <label>Monthly Rate:</label>
                        <asp:TextBox ID="txtEditMonthlyRate" runat="server" CssClass="form-control rate-input" />
                    </div>
                    <div class="form-group">
                        <label>Overtime Eligible:</label>
                        <asp:CheckBox ID="chkEditOvertime" runat="server" />
                    </div>
                </div>
                <div class="modal-buttons">
                    <asp:Button ID="btnSaveEdit" runat="server" Text="💾 Save Changes" CssClass="btn btn-success" OnClick="btnSaveEdit_Click" />
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <script src="Scripts/snackbar.js"></script>

        <script type="text/javascript">
            function onSyncClick() {
                showLoadingPopup('Synchronizing Employees', 'Please wait while we sync the latest employee data...');
                return true;
            }

            function formatRateInput(input) {
                var cursorPos = input.selectionStart;
                var oldVal = input.value;
                var raw = oldVal.replace(/\s/g, '');
                if (raw === '' || raw === '-') return;
                var parts = raw.split('.');
                var intPart = parts[0].replace(/[^\d-]/g, '');
                var decPart = parts.length > 1 ? '.' + parts[1].replace(/[^\d]/g, '') : '';
                var formatted = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ' ') + decPart;
                if (formatted !== oldVal) {
                    var spaceDiff = formatted.length - oldVal.length;
                    input.value = formatted;
                    input.setSelectionRange(cursorPos + spaceDiff, cursorPos + spaceDiff);
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var rateInputs = document.querySelectorAll('.rate-input');
                rateInputs.forEach(function (el) {
                    el.addEventListener('input', function () { formatRateInput(this); });
                });
            });

            function filterGrid(input, gridId, countSpanId) {
                var filter = input.value.toLowerCase();
                var grid = document.querySelectorAll('table[id$="' + gridId + '"]')[0];
                if (!grid) return;

                var rows = grid.querySelectorAll('tbody tr');
                var visibleCount = 0;
                var totalCount = rows.length;

                rows.forEach(function (row) {
                    var cells = row.querySelectorAll('td');
                    var text = '';
                    cells.forEach(function (cell) {
                        text += cell.textContent.toLowerCase() + ' ';
                    });

                    if (filter === '' || text.indexOf(filter) > -1) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                var countSpan = document.getElementById(countSpanId);
                if (countSpan) {
                    if (filter === '') {
                        countSpan.textContent = '';
                    } else {
                        countSpan.textContent = 'Showing ' + visibleCount + ' of ' + totalCount;
                    }
                }
            }
        </script>
    </form>
</body>
</html>

