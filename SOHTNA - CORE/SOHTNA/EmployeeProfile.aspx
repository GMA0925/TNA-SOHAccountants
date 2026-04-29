<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeProfile.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        /* ?? Page title ??????????????????????????????????????????????? */
        .ep-page-title {
            font-size: 22px;
            color: #0078D4;
            margin: 20px 0 18px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #0078D4;
        }

        /* ?? Two-column layout ???????????????????????????????????????? */
        .ep-layout {
            display: flex;
            gap: 20px;
            align-items: flex-start;
            flex-wrap: wrap;
        }

        .ep-sidebar {
            flex: 0 0 260px;
            min-width: 220px;
        }

        .ep-main {
            flex: 1 1 0;
            min-width: 0;
        }

        /* ?? Avatar card ?????????????????????????????????????????????? */
        .ep-avatar-card {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.10);
            padding: 24px 16px 20px 16px;
            text-align: center;
            border-top: 4px solid #0078D4;
            margin-bottom: 16px;
        }

        .ep-avatar {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0078D4 0%, #00b4d8 100%);
            color: white;
            font-size: 36px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 14px auto;
            letter-spacing: 1px;
            user-select: none;
        }

        .ep-user-name {
            font-size: 17px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 4px;
        }

        .ep-user-role {
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            background: #e8f0fe;
            color: #0078D4;
            margin-bottom: 8px;
        }

        .ep-user-site {
            font-size: 12px;
            color: #666;
        }

        .ep-user-site i {
            color: #0078D4;
        }

        /* ?? Quick-stats strip ???????????????????????????????????????? */
        .ep-stats-strip {
            display: flex;
            gap: 12px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .ep-stat-box {
            flex: 1 1 120px;
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            padding: 14px 16px;
            text-align: center;
            border-top: 3px solid #0078D4;
        }

        .ep-stat-box.green  { border-top-color: #28a745; }
        .ep-stat-box.orange { border-top-color: #fd7e14; }
        .ep-stat-box.teal   { border-top-color: #17a2b8; }
        .ep-stat-box.purple { border-top-color: #6f42c1; }

        .ep-stat-val {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a2e;
            line-height: 1.1;
        }

        .ep-stat-lbl {
            font-size: 11px;
            color: #888;
            margin-top: 4px;
        }

        /* ?? Tabs ????????????????????????????????????????????????????? */
        .ep-tabs {
            display: flex;
            gap: 0;
            border-bottom: 2px solid #dee2e6;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .ep-tab {
            padding: 10px 18px;
            font-size: 13px;
            font-weight: 600;
            color: #555;
            cursor: pointer;
            border: none;
            background: transparent;
            border-bottom: 3px solid transparent;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .ep-tab:hover {
            color: #0078D4;
            background: #f0f6ff;
        }

        .ep-tab.active {
            color: #0078D4;
            border-bottom-color: #0078D4;
        }

        .ep-tab-content {
            display: none;
        }

        .ep-tab-content.active {
            display: block;
        }

        /* ?? Panel ???????????????????????????????????????????????????? */
        .ep-panel {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            padding: 20px 22px;
            margin-bottom: 18px;
            border-left: 5px solid #0078D4;
        }

        .ep-panel.green  { border-left-color: #28a745; }
        .ep-panel.orange { border-left-color: #fd7e14; }
        .ep-panel.teal   { border-left-color: #17a2b8; }
        .ep-panel.purple { border-left-color: #6f42c1; }

        .ep-panel h3 {
            margin: 0 0 16px 0;
            font-size: 15px;
            color: #0078D4;
        }

        .ep-panel.green  h3 { color: #28a745; }
        .ep-panel.orange h3 { color: #fd7e14; }
        .ep-panel.teal   h3 { color: #17a2b8; }
        .ep-panel.purple h3 { color: #6f42c1; }

        /* ?? Form grid ???????????????????????????????????????????????? */
        .ep-form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 14px 20px;
        }

        .ep-form-group {
            display: flex;
            flex-direction: column;
        }

        .ep-form-group label {
            font-size: 12px;
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .ep-form-group label i {
            margin-right: 5px;
            color: #0078D4;
        }

        .ep-input {
            padding: 8px 10px;
            border: 1px solid #d0d7de;
            border-radius: 4px;
            font-size: 14px;
            background: #f6f8fa;
            color: #1a1a2e;
            width: 100%;
            box-sizing: border-box;
            transition: border-color 0.15s;
        }

        .ep-input:focus {
            border-color: #0078D4;
            outline: none;
            background: #fff;
            box-shadow: 0 0 0 2px rgba(0,120,212,0.12);
        }

        .ep-input[readonly],
        .ep-input:disabled {
            background: #eef1f5;
            color: #666;
            cursor: default;
        }

        /* ?? Read-only value display ?????????????????????????????????? */
        .ep-field-val {
            padding: 8px 10px;
            background: #eef1f5;
            border: 1px solid #d0d7de;
            border-radius: 4px;
            font-size: 14px;
            color: #333;
            min-height: 36px;
        }

        /* ?? Badges ??????????????????????????????????????????????????? */
        .ep-badge {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
        }

        .ep-badge-active   { background: #d4edda; color: #155724; }
        .ep-badge-inactive { background: #f8d7da; color: #721c24; }
        .ep-badge-role     { background: #e8f0fe; color: #0078D4; }
        .ep-badge-shift    { background: #fff3cd; color: #856404; }
        .ep-badge-dept     { background: #e2e3f3; color: #3f3f8f; }

        /* ?? Button row ??????????????????????????????????????????????? */
        .ep-btn-row {
            margin-top: 18px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .ep-btn {
            padding: 9px 20px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .ep-btn-primary   { background: #0078D4; color: #fff; }
        .ep-btn-primary:hover { background: #005a9e; }

        .ep-btn-secondary { background: #6c757d; color: #fff; }
        .ep-btn-secondary:hover { background: #5a6268; }

        .ep-btn-danger    { background: #dc3545; color: #fff; }
        .ep-btn-danger:hover { background: #b02a37; }

        .ep-btn-success   { background: #28a745; color: #fff; }
        .ep-btn-success:hover { background: #1e7e34; }

        /* ?? Alert ???????????????????????????????????????????????????? */
        .ep-alert {
            padding: 11px 15px;
            border-radius: 4px;
            font-size: 13px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .ep-alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .ep-alert-error   { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }
        .ep-alert-info    { background: #d1ecf1; color: #0c5460; border-left: 4px solid #17a2b8; }

        /* ?? Table ???????????????????????????????????????????????????? */
        .ep-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-top: 6px;
        }

        .ep-table thead {
            background: #0078D4;
            color: white;
        }

        .ep-table th,
        .ep-table td {
            padding: 9px 11px;
            text-align: left;
            border: 1px solid #dde3ea;
        }

        .ep-table tbody tr:nth-child(even) { background: #f4f6f9; }
        .ep-table tbody tr:hover           { background: #e8f0fe; }

        .ep-table.green-header thead  { background: #28a745; }
        .ep-table.teal-header thead   { background: #17a2b8; }
        .ep-table.purple-header thead { background: #6f42c1; }

        /* ?? Duration badge ??????????????????????????????????????????? */
        .ep-duration {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 600;
            background: #e8f0fe;
            color: #0078D4;
        }

        .ep-direction-in  { color: #28a745; font-weight: 600; }
        .ep-direction-out { color: #dc3545; font-weight: 600; }

        /* ?? Filter bar ??????????????????????????????????????????????? */
        .ep-filter-bar {
            display: flex;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-bottom: 16px;
            padding: 12px 16px;
            background: #f8f9fa;
            border-radius: 6px;
            border: 1px solid #e9ecef;
        }

        .ep-filter-bar .ep-form-group {
            flex: 0 0 auto;
            min-width: 140px;
        }

        .ep-filter-bar .ep-form-group label {
            font-size: 11px;
            margin-bottom: 3px;
        }

        /* ?? Quick date-range select ?????????????????????????????????? */
        .ep-quick-range {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .ep-quick-range-btn {
            padding: 5px 12px;
            font-size: 12px;
            font-weight: 600;
            border: 1px solid #d0d7de;
            border-radius: 14px;
            background: #fff;
            color: #555;
            cursor: pointer;
            transition: all 0.2s;
        }

        .ep-quick-range-btn:hover {
            background: #e8f0fe;
            border-color: #0078D4;
            color: #0078D4;
        }

        .ep-quick-range-btn.active {
            background: #0078D4;
            border-color: #0078D4;
            color: #fff;
        }

        /* ?? Financial summary cards ?????????????????????????????????? */
        .ep-fin-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 14px;
            margin-bottom: 18px;
        }

        .ep-fin-card {
            background: #fff;
            border-radius: 8px;
            padding: 18px 16px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            border-top: 3px solid #6f42c1;
        }

        .ep-fin-card .ep-fin-val {
            font-size: 26px;
            font-weight: 700;
            color: #1a1a2e;
        }

        .ep-fin-card .ep-fin-lbl {
            font-size: 11px;
            color: #888;
            margin-top: 4px;
        }

        .ep-fin-card.blue  { border-top-color: #0078D4; }
        .ep-fin-card.green { border-top-color: #28a745; }
        .ep-fin-card.orange { border-top-color: #fd7e14; }

        /* ?? Monthly breakdown row ???????????????????????????????????? */
        .ep-month-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }

        .ep-month-bar:last-child { border-bottom: none; }

        .ep-month-name {
            width: 90px;
            font-size: 13px;
            font-weight: 600;
            color: #333;
        }

        .ep-month-progress {
            flex: 1;
            height: 20px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
        }

        .ep-month-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.4s;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 8px;
            font-size: 10px;
            color: #fff;
            font-weight: 600;
        }

        .ep-month-fill.blue   { background: linear-gradient(90deg, #0078D4, #00b4d8); }
        .ep-month-fill.green  { background: linear-gradient(90deg, #28a745, #5cb85c); }
        .ep-month-fill.purple { background: linear-gradient(90deg, #6f42c1, #a855f7); }

        .ep-month-hours {
            width: 70px;
            text-align: right;
            font-size: 13px;
            font-weight: 600;
            color: #0078D4;
        }

        /* ?? Password strength bar ???????????????????????????????????? */
        .ep-pwd-strength {
            height: 4px;
            border-radius: 2px;
            margin-top: 5px;
            transition: width 0.3s, background-color 0.3s;
            width: 0;
        }

        /* ?? No data message ?????????????????????????????????????????? */
        .ep-no-data {
            text-align: center;
            padding: 30px 20px;
            color: #888;
            font-size: 14px;
        }

        .ep-no-data i {
            font-size: 36px;
            color: #ccc;
            display: block;
            margin-bottom: 10px;
        }

        /* ?? Responsive ??????????????????????????????????????????????? */
        @media (max-width: 700px) {
            .ep-layout   { flex-direction: column; }
            .ep-sidebar  { flex: 1 1 auto; width: 100%; }
            .ep-tabs     { flex-direction: column; }
        }
    </style>

    <asp:HiddenField ID="hfEmployeeID" runat="server" Value="" />

    <h2 class="ep-page-title">
        <i class="fas fa-user-circle"></i> My Profile
    </h2>

    <!-- Alert message -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <div class="ep-layout">

        <!-- ?????????????????????????????????????????????????????????? -->
        <!-- ?? SIDEBAR ???????????????????????????????????????????????? -->
        <!-- ?????????????????????????????????????????????????????????? -->
        <div class="ep-sidebar">
            <div class="ep-avatar-card">
                <div class="ep-avatar">
                    <asp:Label ID="lblInitials" runat="server" Text="??" />
                </div>
                <div class="ep-user-name">
                    <asp:Label ID="lblFullName" runat="server" Text="" />
                </div>
                <div>
                    <span class="ep-badge ep-badge-role">
                        <asp:Label ID="lblRoleBadge" runat="server" Text="" />
                    </span>
                </div>
                <div class="ep-user-site" style="margin-top:8px;">
                    <i class="fas fa-map-marker-alt"></i>
                    Site: <strong><asp:Label ID="lblSiteBadge" runat="server" Text="" /></strong>
                </div>
                <div style="margin-top:8px; font-size:12px; color:#888;">
                    <i class="fas fa-id-badge"></i>
                    User: <asp:Label ID="lblUsernameSidebar" runat="server" Text="" />
                </div>
            </div>

            <!-- Employee link card (shown only when matched) -->
            <asp:Panel ID="pnlEmployeeLink" runat="server" Visible="false">
                <div class="ep-panel teal" style="padding:14px 16px;">
                    <h3 style="font-size:13px;"><i class="fas fa-id-card"></i> Employee Record</h3>
                    <div style="font-size:12px; color:#444; line-height:1.8;">
                        <div><strong>ID:</strong> <asp:Label ID="lblEmpCode" runat="server" Text="-" /></div>
                        <div><strong>Dept:</strong> <asp:Label ID="lblEmpDept" runat="server" Text="-" /></div>
                        <div><strong>Shift:</strong> <asp:Label ID="lblEmpShift" runat="server" Text="-" /></div>
                        <div><strong>Pay Type:</strong> <asp:Label ID="lblEmpPayType" runat="server" Text="-" /></div>
                        <div style="margin-top:6px;">
                            <asp:Literal ID="lblEmpStatus" runat="server" />
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Quick tools -->
            <div class="ep-panel" style="padding:14px 16px;">
                <h3 style="font-size:13px;"><i class="fas fa-tools"></i> Quick Tools</h3>
                <div style="display:flex; flex-direction:column; gap:8px;">
                    <asp:Button ID="btnExportMyEvents" runat="server" Text="Export My Events (CSV)"
                        CssClass="ep-btn ep-btn-success" style="width:100%; font-size:12px; padding:7px 10px;"
                        OnClick="btnExportMyEvents_Click" />
                    <asp:Button ID="btnRefreshData" runat="server" Text="Refresh Data"
                        CssClass="ep-btn ep-btn-secondary" style="width:100%; font-size:12px; padding:7px 10px;"
                        OnClick="btnRefreshData_Click" />
                </div>
            </div>
        </div>

        <!-- ?????????????????????????????????????????????????????????? -->
        <!-- ?? MAIN CONTENT ??????????????????????????????????????????? -->
        <!-- ?????????????????????????????????????????????????????????? -->
        <div class="ep-main">

            <!-- Stats strip -->
            <div class="ep-stats-strip">
                <div class="ep-stat-box green">
                    <div class="ep-stat-val"><asp:Label ID="lblStatDaysThisMonth" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-calendar-check"></i> Days Present (Month)</div>
                </div>
                <div class="ep-stat-box teal">
                    <div class="ep-stat-val"><asp:Label ID="lblStatHours" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-hourglass-half"></i> Hours Logged (Month)</div>
                </div>
                <div class="ep-stat-box orange">
                    <div class="ep-stat-val"><asp:Label ID="lblStatLate" runat="server" Text="&#8212;" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-clock"></i> Late Arrivals (Month)</div>
                </div>
                <div class="ep-stat-box">
                    <div class="ep-stat-val"><asp:Label ID="lblStatTotal" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-history"></i> Total Events</div>
                </div>
                <div class="ep-stat-box purple">
                    <div class="ep-stat-val"><asp:Label ID="lblStatAvgHours" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-chart-line"></i> Avg Hours/Day</div>
                </div>
            </div>

            <!-- ?? TAB NAVIGATION ????????????????????????????????????? -->
            <div class="ep-tabs">
                <button type="button" class="ep-tab active" onclick="epSwitchTab('overview', this)">
                    <i class="fas fa-user"></i> Overview
                </button>
                <button type="button" class="ep-tab" onclick="epSwitchTab('clockevents', this)">
                    <i class="fas fa-clock"></i> Clock Events
                </button>
                <button type="button" class="ep-tab" onclick="epSwitchTab('financials', this)">
                    <i class="fas fa-coins"></i> Financials
                </button>
                <button type="button" class="ep-tab" onclick="epSwitchTab('settings', this)">
                    <i class="fas fa-cog"></i> Settings
                </button>
            </div>

            <!-- ?????????????????????????????????????????????????????? -->
            <!-- ?? TAB 1: OVERVIEW ?????????????????????????????????? -->
            <!-- ?????????????????????????????????????????????????????? -->
            <div id="tab-overview" class="ep-tab-content active">

                <!-- Employee info panel (read-only) -->
                <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                    <div class="ep-panel green">
                        <h3><i class="fas fa-id-card-alt"></i> Employee Information</h3>
                        <div class="ep-form-grid">
                            <div class="ep-form-group">
                                <label><i class="fas fa-hashtag"></i> Employee Code</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoCode" runat="server" Text="-" /></div>
                            </div>
                            <div class="ep-form-group">
                                <label><i class="fas fa-sitemap"></i> Department</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoDept" runat="server" Text="-" /></div>
                            </div>
                            <div class="ep-form-group">
                                <label><i class="fas fa-calendar-week"></i> Shift</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoShift" runat="server" Text="-" /></div>
                            </div>
                            <div class="ep-form-group">
                                <label><i class="fas fa-money-bill-wave"></i> Pay Type</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoPayType" runat="server" Text="-" /></div>
                            </div>
                            <div class="ep-form-group">
                                <label><i class="fas fa-phone-alt"></i> Mobile</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoMobile" runat="server" Text="-" /></div>
                            </div>
                            <div class="ep-form-group">
                                <label><i class="fas fa-calendar-plus"></i> Joined</label>
                                <div class="ep-field-val"><asp:Label ID="lblInfoJoined" runat="server" Text="-" /></div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Recent attendance (last 10 events quick view) -->
                <asp:Panel ID="pnlRecentEvents" runat="server" Visible="false">
                    <div class="ep-panel teal">
                        <h3><i class="fas fa-history"></i> Recent Clock Events (Last 10)</h3>
                        <asp:GridView ID="gvRecentEvents" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="ep-table teal-header"
                            GridLines="None"
                            EmptyDataText="No recent events found.">
                            <Columns>
                                <asp:BoundField DataField="EventDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="EventTime" HeaderText="Time" />
                                <asp:TemplateField HeaderText="Direction">
                                    <ItemTemplate>
                                        <span class='<%# Eval("Direction").ToString() == "IN" ? "ep-direction-in" : "ep-direction-out" %>'>
                                            <i class='<%# Eval("Direction").ToString() == "IN" ? "fas fa-sign-in-alt" : "fas fa-sign-out-alt" %>'></i>
                                            <%# Eval("Direction") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ReaderName" HeaderText="Reader" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>

            <!-- ?????????????????????????????????????????????????????? -->
            <!-- ?? TAB 2: CLOCK EVENTS ?????????????????????????????? -->
            <!-- ?????????????????????????????????????????????????????? -->
            <div id="tab-clockevents" class="ep-tab-content">

                <div class="ep-panel">
                    <h3><i class="fas fa-filter"></i> Filter Clock Events</h3>
                    <div class="ep-quick-range">
                        <button type="button" class="ep-quick-range-btn" onclick="epQuickRange('today', this)"><i class="fas fa-calendar-day"></i> Today</button>
                        <button type="button" class="ep-quick-range-btn" onclick="epQuickRange('yesterday', this)"><i class="fas fa-calendar-minus"></i> Yesterday</button>
                        <button type="button" class="ep-quick-range-btn" onclick="epQuickRange('last3', this)"><i class="fas fa-calendar-week"></i> Last 3 Days</button>
                        <button type="button" class="ep-quick-range-btn" onclick="epQuickRange('lastweek', this)"><i class="fas fa-calendar-alt"></i> Last Week</button>
                        <button type="button" class="ep-quick-range-btn active" onclick="epQuickRange('lastmonth', this)"><i class="fas fa-calendar"></i> Last Month</button>
                    </div>
                    <div class="ep-filter-bar">
                        <div class="ep-form-group">
                            <label><i class="fas fa-calendar"></i> From Date</label>
                            <asp:TextBox ID="txtFilterFrom" runat="server" CssClass="ep-input" TextMode="Date" />
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-calendar"></i> To Date</label>
                            <asp:TextBox ID="txtFilterTo" runat="server" CssClass="ep-input" TextMode="Date" />
                        </div>
                        <div class="ep-form-group">
                            <label>&nbsp;</label>
                            <asp:Button ID="btnFilterEvents" runat="server" Text="Apply Filter"
                                CssClass="ep-btn ep-btn-primary" OnClick="btnFilterEvents_Click" />
                        </div>
                    </div>
                </div>

                <!-- Paired clock events with duration -->
                <asp:Panel ID="pnlClockEvents" runat="server" Visible="false">
                    <div class="ep-panel teal">
                        <h3><i class="fas fa-exchange-alt"></i> Clock Events with Duration
                            <span style="font-size:12px; font-weight:400; color:#888; margin-left:10px;">
                                (<asp:Label ID="lblEventCount" runat="server" Text="0" /> records)
                            </span>
                        </h3>
                        <asp:GridView ID="gvClockEvents" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="ep-table teal-header"
                            GridLines="None"
                            AllowPaging="True"
                            PageSize="20"
                            OnPageIndexChanging="gvClockEvents_PageIndexChanging"
                            EmptyDataText="No clock events found for the selected period.">
                            <Columns>
                                <asp:BoundField DataField="EventDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:TemplateField HeaderText="Clock In">
                                    <ItemTemplate>
                                        <span class="ep-direction-in">
                                            <%# Eval("ClockIn") != DBNull.Value ? Eval("ClockIn") : "-" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Clock Out">
                                    <ItemTemplate>
                                        <span class="ep-direction-out">
                                            <%# Eval("ClockOut") != DBNull.Value ? Eval("ClockOut") : "-" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Duration">
                                    <ItemTemplate>
                                        <span class="ep-duration">
                                            <%# Eval("Duration") != DBNull.Value ? Eval("Duration") : "-" %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ReaderName" HeaderText="Reader" />
                            </Columns>
                            <PagerStyle CssClass="ep-btn-row" HorizontalAlign="Center" />
                        </asp:GridView>
                    </div>
                </asp:Panel>

                <!-- All raw events -->
                <asp:Panel ID="pnlAllEvents" runat="server" Visible="false">
                    <div class="ep-panel">
                        <h3><i class="fas fa-list"></i> All Raw Events</h3>
                        <asp:GridView ID="gvAllEvents" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="ep-table"
                            GridLines="None"
                            AllowPaging="True"
                            PageSize="25"
                            OnPageIndexChanging="gvAllEvents_PageIndexChanging"
                            EmptyDataText="No events found for the selected period.">
                            <Columns>
                                <asp:BoundField DataField="EventDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="EventTime" HeaderText="Time" />
                                <asp:TemplateField HeaderText="Direction">
                                    <ItemTemplate>
                                        <span class='<%# Eval("Direction").ToString() == "IN" ? "ep-direction-in" : "ep-direction-out" %>'>
                                            <i class='<%# Eval("Direction").ToString() == "IN" ? "fas fa-sign-in-alt" : "fas fa-sign-out-alt" %>'></i>
                                            <%# Eval("Direction") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ReaderName" HeaderText="Reader" />
                            </Columns>
                            <PagerStyle CssClass="ep-btn-row" HorizontalAlign="Center" />
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>

            <!-- ?????????????????????????????????????????????????????? -->
            <!-- ?? TAB 3: FINANCIALS ???????????????????????????????? -->
            <!-- ?????????????????????????????????????????????????????? -->
            <div id="tab-financials" class="ep-tab-content">

                <!-- Financial summary cards -->
                <div class="ep-fin-cards">
                    <div class="ep-fin-card blue">
                        <div class="ep-fin-val"><asp:Label ID="lblFinTotalHours" runat="server" Text="0" /></div>
                        <div class="ep-fin-lbl"><i class="fas fa-clock"></i> Total Hours (This Month)</div>
                    </div>
                    <div class="ep-fin-card green">
                        <div class="ep-fin-val"><asp:Label ID="lblFinDaysWorked" runat="server" Text="0" /></div>
                        <div class="ep-fin-lbl"><i class="fas fa-calendar-check"></i> Days Worked (This Month)</div>
                    </div>
                    <div class="ep-fin-card orange">
                        <div class="ep-fin-val"><asp:Label ID="lblFinOvertimeHours" runat="server" Text="0" /></div>
                        <div class="ep-fin-lbl"><i class="fas fa-business-time"></i> Overtime Hours</div>
                    </div>
                    <div class="ep-fin-card">
                        <div class="ep-fin-val"><asp:Label ID="lblFinAvgDaily" runat="server" Text="0" /></div>
                        <div class="ep-fin-lbl"><i class="fas fa-chart-bar"></i> Avg Hours/Day</div>
                    </div>
                </div>

                <!-- Monthly hours breakdown -->
                <div class="ep-panel purple">
                    <h3><i class="fas fa-chart-bar"></i> Monthly Hours Breakdown (Last 6 Months)</h3>
                    <asp:Panel ID="pnlMonthlyBreakdown" runat="server">
                        <asp:Literal ID="litMonthlyBars" runat="server" />
                    </asp:Panel>
                    <asp:Panel ID="pnlNoFinancialData" runat="server" Visible="false">
                        <div class="ep-no-data">
                            <i class="fas fa-chart-pie"></i>
                            No financial data available yet.
                        </div>
                    </asp:Panel>
                </div>

                <!-- Daily hours this month -->
                <asp:Panel ID="pnlDailyHours" runat="server" Visible="false">
                    <div class="ep-panel green">
                        <h3><i class="fas fa-table"></i> Daily Hours &mdash; <asp:Label ID="lblFinMonth" runat="server" Text="" /></h3>
                        <asp:GridView ID="gvDailyHours" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="ep-table green-header"
                            GridLines="None"
                            EmptyDataText="No data for this month.">
                            <Columns>
                                <asp:BoundField DataField="WorkDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                                <asp:BoundField DataField="DayName" HeaderText="Day" />
                                <asp:TemplateField HeaderText="Clock In">
                                    <ItemTemplate>
                                        <span class="ep-direction-in"><%# Eval("FirstIn") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Clock Out">
                                    <ItemTemplate>
                                        <span class="ep-direction-out"><%# Eval("LastOut") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Hours">
                                    <ItemTemplate>
                                        <span class="ep-duration"><%# Eval("TotalHours") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Overtime">
                                    <ItemTemplate>
                                        <span style='color:<%# Convert.ToDecimal(Eval("OvertimeHours")) > 0 ? "#fd7e14" : "#888" %>; font-weight:600;'>
                                            <%# Eval("OvertimeHours") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>

            <!-- ?????????????????????????????????????????????????????? -->
            <!-- ?? TAB 4: SETTINGS ?????????????????????????????????? -->
            <!-- ?????????????????????????????????????????????????????? -->
            <div id="tab-settings" class="ep-tab-content">

                <!-- Account details panel -->
                <div class="ep-panel">
                    <h3><i class="fas fa-user-edit"></i> Account Details</h3>
                    <div class="ep-form-grid">
                        <div class="ep-form-group">
                            <label><i class="fas fa-signature"></i> Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="ep-input" placeholder="Full name" />
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-envelope"></i> Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="ep-input" TextMode="Email" placeholder="email@example.com" />
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-user"></i> Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="ep-input" ReadOnly="true" />
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-shield-alt"></i> Role</label>
                            <div class="ep-field-val">
                                <asp:Label ID="lblRoleDisplay" runat="server" Text="" />
                            </div>
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-building"></i> Site</label>
                            <div class="ep-field-val">
                                <asp:Label ID="lblSiteDisplay" runat="server" Text="" />
                            </div>
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-phone"></i> Phone</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="ep-input" placeholder="+1 555 000 0000" />
                        </div>
                    </div>
                    <div class="ep-btn-row">
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="ep-btn ep-btn-primary" OnClick="btnSaveProfile_Click" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Reset" CssClass="ep-btn ep-btn-secondary" OnClick="btnCancelEdit_Click" />
                    </div>
                </div>

                <!-- Change password panel -->
                <div class="ep-panel orange">
                    <h3><i class="fas fa-key"></i> Change Password</h3>
                    <div class="ep-form-grid">
                        <div class="ep-form-group">
                            <label><i class="fas fa-lock"></i> Current Password</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="Current password" />
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-lock"></i> New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="New password" onkeyup="epPwdStrength(this.value)" />
                            <div id="ep-pwd-bar" class="ep-pwd-strength"></div>
                            <div id="ep-pwd-hint" style="font-size:11px; color:#888; margin-top:3px;"></div>
                        </div>
                        <div class="ep-form-group">
                            <label><i class="fas fa-lock"></i> Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="Confirm new password" />
                        </div>
                    </div>
                    <div class="ep-btn-row">
                        <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="ep-btn ep-btn-danger" OnClick="btnChangePassword_Click" />
                    </div>
                </div>
            </div>

        </div><!-- /ep-main -->
    </div><!-- /ep-layout -->

    <script>
        // Tab switching
        function epSwitchTab(tabName, btn) {
            var contents = document.querySelectorAll('.ep-tab-content');
            for (var i = 0; i < contents.length; i++) {
                contents[i].classList.remove('active');
            }
            var tabs = document.querySelectorAll('.ep-tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            var target = document.getElementById('tab-' + tabName);
            if (target) target.classList.add('active');
            if (btn) btn.classList.add('active');
        }

        // Restore tab after postback (called from server-registered script)
        function epRestoreTab(tabName) {
            var tabMap = { 'overview': 0, 'clockevents': 1, 'financials': 2, 'settings': 3 };
            var idx = tabMap[tabName];
            var tabs = document.querySelectorAll('.ep-tab');
            var btn = (idx !== undefined && tabs.length > idx) ? tabs[idx] : null;
            epSwitchTab(tabName, btn);
        }

        // Quick date-range selector
        function epQuickRange(range, btn) {
            var today = new Date();
            var from = new Date();
            var to = new Date();

            switch (range) {
                case 'today':
                    from = today;
                    to = today;
                    break;
                case 'yesterday':
                    from.setDate(today.getDate() - 1);
                    to.setDate(today.getDate() - 1);
                    break;
                case 'last3':
                    from.setDate(today.getDate() - 2);
                    to = today;
                    break;
                case 'lastweek':
                    from.setDate(today.getDate() - 6);
                    to = today;
                    break;
                case 'lastmonth':
                    from.setDate(today.getDate() - 30);
                    to = today;
                    break;
            }

            var fmtDate = function (d) {
                var y = d.getFullYear();
                var m = ('0' + (d.getMonth() + 1)).slice(-2);
                var dd = ('0' + d.getDate()).slice(-2);
                return y + '-' + m + '-' + dd;
            };

            document.getElementById('<%= txtFilterFrom.ClientID %>').value = fmtDate(from);
            document.getElementById('<%= txtFilterTo.ClientID %>').value = fmtDate(to);

            // Update active state
            var btns = document.querySelectorAll('.ep-quick-range-btn');
            for (var i = 0; i < btns.length; i++) {
                btns[i].classList.remove('active');
            }
            if (btn) btn.classList.add('active');

            // Auto-click the Apply Filter button
            document.getElementById('<%= btnFilterEvents.ClientID %>').click();
        }

        // Password strength indicator
        function epPwdStrength(val) {
            var bar  = document.getElementById('ep-pwd-bar');
            var hint = document.getElementById('ep-pwd-hint');
            if (!bar || !hint) return;

            var score = 0;
            if (val.length >= 8)  score++;
            if (/[A-Z]/.test(val)) score++;
            if (/[0-9]/.test(val)) score++;
            if (/[^A-Za-z0-9]/.test(val)) score++;

            var labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
            var colors = ['', '#dc3545', '#fd7e14', '#ffc107', '#28a745'];
            var widths = ['0%', '25%', '50%', '75%', '100%'];

            bar.style.width           = widths[score] || '0%';
            bar.style.backgroundColor = colors[score] || 'transparent';
            hint.textContent          = score > 0 ? labels[score] : '';
        }
    </script>
</asp:Content>
