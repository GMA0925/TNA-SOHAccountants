<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="TimeAttendance.WebForms.UserManagement" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Management</title>
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
            max-width: 900px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 22px;
            color: #0078D4;
            margin-bottom: 20px;
            display: block;
            text-align: center;
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

        .btn-secondary {
            background-color: #6c757d;
            color: white;
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

        /* Focus effect for edited rows */
        .table-striped tr.edit-row {
            background-color: #ffffcc !important;
            box-shadow: 0 0 10px rgba(255, 204, 0, 0.5);
            transition: background-color 0.3s ease;
        }

        .table-striped tr.edit-row:hover {
            background-color: #ffff99 !important;
        }

        /* Password toggle styles */
        .password-container {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .password-container input {
            width: 100%;
            flex: 0;
        }

        .password-toggle {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 20px;
            padding: 5px 8px;
            color: #666;
            transition: color 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: auto;
            align-self: flex-start;
        }

        .password-toggle:hover {
            color: #0078D4;
        }

        .password-toggle:focus {
            outline: none;
            color: #0078D4;
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

        .status-label {
            display: block;
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
            background-color: #e8f4f8;
            font-weight: bold;
            color: #0078D4;
        }

        /* ===== EDIT/NEW POPUP MODAL ===== */
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
            max-width: 700px;
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

        /* ===== PASSWORD TOGGLE ===== */
        .password-container {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .password-container input {
            width: 100%;
        }

        .password-toggle {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 20px;
            padding: 5px 8px;
            color: #666;
            transition: color 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: auto;
            align-self: flex-start;
        }

        .password-toggle:hover {
            color: #0078D4;
        }

        /* ===== FILTER BAR ===== */
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

        .section-title {
            font-size: 18px;
            color: #0078D4;
            margin-top: 30px;
            margin-bottom: 15px;
            font-weight: bold;
            border-bottom: 2px solid #0078D4;
            padding-bottom: 10px;
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
    <script type="text/javascript">
        function togglePasswordVisibility(event, button) {
            event.preventDefault();
            var container = button.parentElement;
            var passwordInput = container.querySelector('input[type="password"], input[type="text"]');
            if (passwordInput) {
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    button.textContent = '🙈';
                    button.title = 'Hide Password';
                } else {
                    passwordInput.type = 'password';
                    button.textContent = '👁️';
                    button.title = 'Show Password';
                }
                passwordInput.focus();
            }
        }
    </script>
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
            <asp:Label ID="lblTitle" runat="server" Text="👤 User Management" CssClass="page-title" />

            <!-- Top Action Bar -->
            <div style="text-align: center; margin-bottom: 20px;">
                <asp:Button ID="btnNewUser" runat="server" Text="➕ New User" CssClass="btn btn-primary" OnClick="btnNewUser_Click" />
            </div>

            <!-- Status Message -->
            <asp:Label ID="lblUserMessage" runat="server" CssClass="status-label" />

            <!-- Export Buttons -->
            <div style="margin-top: 15px; text-align: right;">
                <asp:Button ID="btnExportUsersExcel" runat="server" Text="📤 Export to Excel" CssClass="btn btn-success" OnClick="btnExportUsersExcel_Click" />
                <asp:Button ID="btnExportUsersPdf" runat="server" Text="📄 Export to PDF" CssClass="btn btn-danger" OnClick="btnExportUsersPdf_Click" />
            </div>

            <!-- Filter & User Grid -->
            <div class="section-title">👥 User List</div>
            <div class="filter-bar">
                <i class="fas fa-search"></i>
                <input type="text" id="txtFilterUsers" placeholder="Filter users..." onkeyup="filterGrid(this, 'gvUsers', 'userFilterCount')" />
                <span id="userFilterCount" class="filter-count"></span>
            </div>
            <div style="overflow-x: auto;">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-striped"
                    DataKeyNames="Username"
                    OnSelectedIndexChanged="gvUsers_SelectedIndexChanged"
                    OnRowDataBound="gvUsers_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="NameSurname" HeaderText="Name &amp; Surname" />
                        <asp:BoundField DataField="Username" HeaderText="Username" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Role" HeaderText="Role" />
                        <asp:BoundField DataField="StatusText" HeaderText="Status" />
                        <asp:BoundField DataField="SiteId" HeaderText="Site ID" />
                    </Columns>
                </asp:GridView>
            </div>
        </main>

        <!-- New/Edit User Popup Modal -->
        <asp:Panel ID="pnlUserModal" runat="server" CssClass="modal-overlay">
            <div class="modal-content">
                <div class="modal-header">
                    <h3><asp:Label ID="lblModalTitle" runat="server" Text="➕ New User" /></h3>
                    <asp:Button ID="btnModalClose" runat="server" Text="✕" CssClass="modal-close" OnClick="btnModalClose_Click" CausesValidation="false" />
                </div>
                <asp:HiddenField ID="hdnEditUsername" runat="server" />
                <div class="modal-form-grid">
                    <div class="form-group">
                        <label>Name &amp; Surname:</label>
                        <asp:TextBox ID="txtNameSurname" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Username:</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                    </div>
                    <div class="form-group">
                        <label>Role:</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Status:</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Active" Value="Active" />
                            <asp:ListItem Text="Inactive" Value="Inactive" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Site ID:</label>
                        <asp:TextBox ID="txtSiteId" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <label>Password:</label>
                        <div class="password-container">
                            <asp:TextBox ID="txtModalPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Leave blank to keep current" />
                            <button type="button" class="password-toggle" onclick="togglePasswordVisibility(event, this)" title="Show/Hide Password">👁️</button>
                        </div>
                    </div>
                </div>
                <div class="modal-buttons">
                    <asp:Button ID="btnSaveUser" runat="server" Text="💾 Save User" CssClass="btn btn-success" OnClick="btnSaveUser_Click" />
                    <asp:Button ID="btnCancelModal" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnModalClose_Click" CausesValidation="false" />
                </div>

                <!-- Navigation Access (shown only when editing) -->
                <asp:Panel ID="pnlNavAccess" runat="server" Visible="false">
                    <div style="margin-top:25px; padding-top:20px; border-top:2px solid #0078D4;">
                        <h4 style="color:#0078D4; margin:0 0 10px 0;"><i class="fas fa-key"></i> Navigation Access</h4>
                        <p style="color:#666; font-size:12px; margin-bottom:10px;">
                            Override role-based navigation. User-level settings take priority over role defaults.
                        </p>
                        <div style="margin-bottom:10px; display:flex; gap:8px; flex-wrap:wrap;">
                            <asp:Button ID="btnGrantAllUserNav" runat="server" Text="✅ Grant All" CssClass="btn btn-primary" OnClick="btnGrantAllUserNav_Click" style="padding:6px 14px; font-size:12px;" />
                            <asp:Button ID="btnRevokeAllUserNav" runat="server" Text="🚫 Revoke All" CssClass="btn btn-danger" OnClick="btnRevokeAllUserNav_Click" style="padding:6px 14px; font-size:12px;"
                                OnClientClick="return confirm('This will remove access to ALL navigation buttons for this user. Continue?');" />
                            <asp:Button ID="btnClearUserOverrides" runat="server" Text="🔄 Clear Overrides" CssClass="btn btn-secondary" OnClick="btnClearUserOverrides_Click" style="padding:6px 14px; font-size:12px;"
                                OnClientClick="return confirm('This will remove all user-level overrides. The user will revert to their role-based permissions. Continue?');" />
                        </div>
                        <asp:GridView ID="gvUserNavPermissions" runat="server" AutoGenerateColumns="False"
                            CellPadding="6" GridLines="Horizontal" style="width:100%; border:1px solid #ddd; border-radius:4px;"
                            HeaderStyle-BackColor="#0078D4" HeaderStyle-ForeColor="White" HeaderStyle-Font-Bold="true"
                            AlternatingRowStyle-BackColor="#f9f9f9" RowStyle-VerticalAlign="Middle" Font-Size="13px">
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hfUserNavFeatureKey" runat="server" Value='<%# Eval("FeatureKey") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="FeatureLabel" HeaderText="Navigation Button" ReadOnly="True" />
                                <asp:BoundField DataField="FeatureKey" HeaderText="Feature Key" ReadOnly="True" />
                                <asp:TemplateField HeaderText="Role Default" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkRoleDefault" runat="server" Checked='<%# Convert.ToBoolean(Eval("RoleAllowed")) %>' Enabled="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User Access" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkUserNavAllowed" runat="server" Checked='<%# Convert.ToBoolean(Eval("IsAllowed")) %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div style="padding:15px; text-align:center; color:#999; font-size:12px;">
                                    <i class="fas fa-info-circle"></i> No navigation permissions found. Ensure permissions have been initialized in Config Tools.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <div style="margin-top:10px;">
                            <asp:Button ID="btnSaveUserNav" runat="server" Text="💾 Save Navigation" CssClass="btn btn-primary" OnClick="btnSaveUserNav_Click" style="padding:8px 16px; font-size:13px;" />
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </asp:Panel>

        <script type="text/javascript">
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
                    cells.forEach(function (cell) { text += cell.textContent.toLowerCase() + ' '; });
                    if (filter === '' || text.indexOf(filter) > -1) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });
                var countSpan = document.getElementById(countSpanId);
                if (countSpan) {
                    countSpan.textContent = filter === '' ? '' : 'Showing ' + visibleCount + ' of ' + totalCount;
                }
            }
        </script>
    </form>
</body>


</html>
