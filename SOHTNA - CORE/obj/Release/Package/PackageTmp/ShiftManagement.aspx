<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShiftManagement.aspx.cs" Inherits="TimeAttendance.WebForms.ShiftManagement" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shift Management - Time & Attendance</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="Content/snackbar.css" rel="stylesheet" />
    <style>
        /* ===== GLOBAL STYLES ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            color: #333;
            line-height: 1.6;
        }

        /* ===== HEADER BAR ===== */
        .header {
            background-color: #0078D4;
            color: white;
            padding: 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            font-size: 28px;
            font-weight: 600;
            margin: 0;
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
            font-size: 13px;
            cursor: pointer;
            display: block;
            margin-bottom: 5px;
            transition: all 0.3s;
        }

        .logout-link:hover {
            text-decoration: underline;
            opacity: 0.9;
        }

        .version-label {
            color: white;
            font-size: 11px;
            opacity: 0.8;
            margin-top: 3px;
        }

        /* ===== MAIN CONTAINER ===== */
        .main-container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 15px;
        }

        /* ===== PAGE HEADER ===== */
        .page-header {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            border-left: 5px solid #0078D4;
        }

        .page-header h2 {
            color: #0078D4;
            font-size: 28px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* ===== FORM SECTION ===== */
        .form-section {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            border-left: 5px solid #0078D4;
        }

        .form-section h3 {
            color: #0078D4;
            font-size: 18px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ===== FORM GRID ===== */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .form-control {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
            width: 100%;
            background-color: white;
            color: #333;
        }

        .form-control:focus {
            outline: none;
            border-color: #0078D4;
            box-shadow: 0 0 0 3px rgba(0, 120, 212, 0.1);
        }

        /* Fix for ASP.NET DropDownList styling */
        select.form-control {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            padding-right: 30px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 12px;
            cursor: pointer;
        }

        select.form-control:focus {
            outline: none;
            border-color: #0078D4;
            box-shadow: 0 0 0 3px rgba(0, 120, 212, 0.1);
        }

        /* Ensure dropdown items display properly */
        select.form-control option {
            padding: 10px;
            background-color: white;
            color: #333;
        }

        select.form-control option:checked {
            background-color: #0078D4;
            color: white;
        }

        /* ===== BUTTONS ===== */
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: #0078D4;
            color: white;
        }

        .btn-primary:hover {
            background-color: #005a9e;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 120, 212, 0.3);
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

        /* ===== GRID/TABLE ===== */
        .grid-section {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        }

        .grid-section h3 {
            color: #0078D4;
            font-size: 18px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table thead {
            background-color: #0078D4;
            color: white;
        }

        .table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }

        .table tbody tr:hover {
            background-color: #f9f9f9;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        /* ===== EMPLOYEE ASSIGNMENT ===== */
        .employee-list-container {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            background-color: #fafafa;
        }

        .employee-list-container label {
            display: block;
            padding: 6px 8px;
            cursor: pointer;
            border-radius: 3px;
            transition: background-color 0.2s;
            font-weight: normal;
            font-size: 14px;
        }

        .employee-list-container label:hover {
            background-color: #e8f0fe;
        }

        .employee-list-container input[type="checkbox"] {
            margin-right: 8px;
        }

        .assign-info {
            color: #666;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .assigned-count {
            font-weight: bold;
            color: #0078D4;
        }

        /* ===== MESSAGES ===== */
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .alert-success {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }

        .alert-error {
            background-color: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }

        .alert-warning {
            background-color: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }

        .status-label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #0078D4;
        }

        /* ===== CLICKABLE ROWS ===== */
        .table tbody tr {
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .table tbody tr:hover {
            background-color: #e8f0fe !important;
        }

        .table tbody tr.selected-row {
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

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 20px;
            }

            .main-container {
                margin: 15px auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .page-header {
                padding: 15px;
            }

            .page-header h2 {
                font-size: 20px;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 15px;
            }

            .page-header h2 {
                font-size: 18px;
            }

            .logout-section {
                right: 10px;
                top: 10px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <h1><i class="fas fa-calendar-alt"></i> Time & Attendance - Shift Management</h1>
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
        <div class="main-container">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-calendar-check"></i> Manage Shifts & Departments</h2>
            </div>

            <!-- Department Management Section -->
            <section class="form-section">
                <h3><i class="fas fa-building"></i> Create / Edit Departments</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="txtDeptName">Department Name:</label>
                        <asp:TextBox ID="txtDeptName" runat="server" CssClass="form-control" placeholder="Enter department name" />
                    </div>
                    <div class="form-group">
                        <label for="ddlDeptPayType">Pay Type:</label>
                        <asp:DropDownList ID="ddlDeptPayType" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Pay Type --" Value="" />
                            <asp:ListItem Text="Monthly" Value="Monthly" />
                            <asp:ListItem Text="Hourly" Value="Hourly" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label for="txtDeptDescription">Description:</label>
                        <asp:TextBox ID="txtDeptDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Enter department description" />
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnAddDept" runat="server" Text="➕ Add Department" CssClass="btn btn-primary" OnClick="btnAddDept_Click" />
                    <asp:Button ID="btnUpdateDept" runat="server" Text="✏️ Update Department" CssClass="btn btn-primary" OnClick="btnUpdateDept_Click" />
                    <asp:Button ID="btnDeleteDept" runat="server" Text="🗑️ Delete Department" CssClass="btn btn-danger" OnClick="btnDeleteDept_Click" />
                </div>
                <asp:Label ID="lblDeptMessage" runat="server" CssClass="status-label" />
            </section>

            <!-- Department Grid -->
            <section class="grid-section">
                <h3><i class="fas fa-th-list"></i> Existing Departments</h3>
                <div class="filter-bar">
                    <i class="fas fa-search"></i>
                    <input type="text" id="txtFilterDept" placeholder="Filter departments..." onkeyup="filterGrid(this, 'gvDepartments', 'deptFilterCount')" />
                    <span id="deptFilterCount" class="filter-count"></span>
                </div>
                <asp:GridView ID="gvDepartments" runat="server" AutoGenerateColumns="False" CssClass="table" DataKeyNames="DepartmentID" OnSelectedIndexChanged="gvDepartments_SelectedIndexChanged" OnRowDataBound="gvDepartments_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="DepartmentName" HeaderText="Department Name" />
                        <asp:BoundField DataField="PayType" HeaderText="Pay Type" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                    </Columns>
                </asp:GridView>
            </section>

            <!-- Shift Management Section -->
            <section class="form-section">
                <h3><i class="fas fa-clock"></i> Create / Edit Shift Schedule</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="txtShiftName">Shift Name:</label>
                        <asp:TextBox ID="txtShiftName" runat="server" CssClass="form-control" placeholder="e.g. Morning Shift, Night Shift" />
                    </div>
                    <div class="form-group">
                        <label for="ddlDepartmentShift">Department:</label>
                        <asp:DropDownList ID="ddlDepartmentShift" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select Department --" Value="" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label for="txtStartTime">Start Time:</label>
                        <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="e.g. 08:00" />
                    </div>
                    <div class="form-group">
                        <label for="txtEndTime">End Time:</label>
                        <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="e.g. 17:00" />
                    </div>
                    <div class="form-group">
                        <label for="ddlStatus">Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Active" Value="Active" />
                            <asp:ListItem Text="Inactive" Value="Inactive" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="button-group">
                    <asp:Button ID="btnAddShift" runat="server" Text="➕ Add Shift" CssClass="btn btn-primary" OnClick="btnAddShift_Click" />
                    <asp:Button ID="btnUpdateShift" runat="server" Text="✏️ Update Shift" CssClass="btn btn-primary" OnClick="btnUpdateShift_Click" />
                    <asp:Button ID="btnDeleteShift" runat="server" Text="🗑️ Delete Shift" CssClass="btn btn-danger" OnClick="btnDeleteShift_Click" />
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="status-label" />
            </section>

            <!-- Shift Grid -->
            <section class="grid-section">
                <h3><i class="fas fa-th-list"></i> Existing Shifts</h3>
                <p style="color: #666; font-size: 13px; margin-bottom: 15px;">
                    <i class="fas fa-info-circle"></i> Click a shift row below to edit it and assign employees.
                </p>
                <div class="filter-bar">
                    <i class="fas fa-search"></i>
                    <input type="text" id="txtFilterShift" placeholder="Filter shifts..." onkeyup="filterGrid(this, 'gvShifts', 'shiftFilterCount')" />
                    <span id="shiftFilterCount" class="filter-count"></span>
                </div>
                <asp:GridView ID="gvShifts" runat="server" AutoGenerateColumns="False" CssClass="table" DataKeyNames="ShiftID" OnSelectedIndexChanged="gvShifts_SelectedIndexChanged" OnRowDataBound="gvShifts_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="ShiftName" HeaderText="Shift Name" />
                        <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                        <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                        <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:BoundField DataField="AssignedCount" HeaderText="Employees" />
                    </Columns>
                </asp:GridView>
            </section>

            <!-- Employee Assignment Section -->
            <asp:Panel ID="pnlAssignEmployees" runat="server" Visible="false">
                <section class="form-section" style="border-left-color: #28a745;">
                    <h3><i class="fas fa-user-plus"></i> Assign Employees to Shift:
                        <asp:Label ID="lblSelectedShiftName" runat="server" style="color: #28a745;" />
                    </h3>
                    <p class="assign-info">
                        <i class="fas fa-info-circle"></i> Check the employees to assign to this shift. Uncheck to remove.
                        Currently assigned: <asp:Label ID="lblAssignedCount" runat="server" CssClass="assigned-count" Text="0" />
                    </p>
                    <div class="employee-list-container">
                        <asp:CheckBoxList ID="cblEmployees" runat="server" RepeatLayout="Flow" />
                    </div>
                    <div class="button-group">
                        <asp:Button ID="btnSaveAssignments" runat="server" Text="💾 Save Assignments" CssClass="btn btn-success" OnClick="btnSaveAssignments_Click" />
                        <asp:Button ID="btnCancelAssignment" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelAssignment_Click" />
                    </div>
                    <asp:Label ID="lblAssignMessage" runat="server" CssClass="status-label" />
                </section>
            </asp:Panel>
        </div>

        <script src="Scripts/snackbar.js"></script>

        <script type="text/javascript">
            // Client-side grid filtering
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