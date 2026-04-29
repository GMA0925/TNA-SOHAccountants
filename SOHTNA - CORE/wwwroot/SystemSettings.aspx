<%@ Page Title="System Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SystemSettings.aspx.cs" Inherits="TimeAttendance.WebForms.SystemSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        .ss-page-title {
            font-size: 22px;
            color: #0078D4;
            margin: 20px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #0078D4;
        }

        .ss-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin-bottom: 20px;
            border-bottom: 2px solid #dee2e6;
        }

        .ss-tab-btn {
            padding: 9px 18px;
            background-color: #f0f0f0;
            border: 1px solid #dee2e6;
            border-bottom: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            color: #555;
            border-radius: 4px 4px 0 0;
            transition: background-color 0.2s, color 0.2s;
            margin-bottom: -2px;
        }

        .ss-tab-btn:hover {
            background-color: #e0e0e0;
            color: #0078D4;
        }

        .ss-tab-btn.active {
            background-color: #ffffff;
            border-bottom: 2px solid #ffffff;
            color: #0078D4;
            font-weight: 700;
            border-top: 3px solid #0078D4;
        }

        .ss-tab-content {
            display: none;
        }

        .ss-tab-content.active {
            display: block;
        }

        .ss-panel {
            background-color: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            border-left: 5px solid #0078D4;
        }

        .ss-panel h3 {
            margin-top: 0;
            color: #0078D4;
            font-size: 16px;
        }

        .ss-panel h4 {
            color: #333;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        .ss-form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .ss-form-group {
            display: flex;
            flex-direction: column;
        }

        .ss-form-group label {
            margin-bottom: 5px;
            color: #444;
            font-weight: 500;
            font-size: 13px;
        }

        .form-control {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }

        .form-control:focus {
            border-color: #0078D4;
            outline: none;
            box-shadow: 0 0 0 2px rgba(0,120,212,0.15);
        }

        .ss-checkbox-group {
            display: flex;
            align-items: center;
            margin: 8px 0;
            gap: 8px;
        }

        .ss-checkbox-group label {
            margin-bottom: 0;
            color: #444;
            font-size: 13px;
            font-weight: 500;
        }

        .ss-btn-row {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 22px;
            font-size: 13px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            cursor: pointer;
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

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #28a745;
            font-size: 14px;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
            font-size: 14px;
        }

        .ss-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 13px;
        }

        .ss-table thead {
            background-color: #0078D4;
            color: white;
        }

        .ss-table th,
        .ss-table td {
            padding: 10px 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        .ss-table tbody tr:nth-child(even) {
            background-color: #f4f6f9;
        }

        .ss-table tbody tr:hover {
            background-color: #e8f0fe;
        }

        .status-badge {
            display: inline-block;
            padding: 3px 8px;
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

        .ss-notif-box {
            margin-top: 16px;
            padding: 15px;
            background-color: #f4f6f9;
            border-radius: 4px;
            border-left: 4px solid #17a2b8;
        }

        .ss-notif-box h4 {
            color: #0078D4;
            margin-top: 0;
        }

        .ss-site-badge {
            display: inline-block;
            background-color: #e8f0fe;
            color: #0078D4;
            border: 1px solid #0078D4;
            border-radius: 4px;
            padding: 2px 10px;
            font-size: 13px;
            font-weight: 600;
            vertical-align: middle;
            margin-left: 10px;
        }

        /* ── Setup guide banner ────────────────────────────────────── */
        .ss-setup-guide {
            background: #fff8e1;
            border: 1px solid #ffc107;
            border-left: 5px solid #ffc107;
            border-radius: 6px;
            padding: 14px 16px;
            margin-bottom: 18px;
        }
        .ss-setup-guide-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
            color: #5a4000;
        }
        .ss-guide-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #888;
            line-height: 1;
        }
        .ss-guide-close:hover { color: #333; }
        .ss-setup-steps {
            margin: 0;
            padding-left: 0;
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .ss-step {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: #444;
            padding: 6px 10px;
            border-radius: 4px;
            background: #fffde7;
            transition: background 0.2s;
        }
        .ss-step.ss-step-done {
            background: #e8f5e9;
            color: #2e7d32;
            text-decoration: line-through;
            opacity: 0.7;
        }
        .ss-step-num {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: #ffc107;
            color: #fff;
            font-size: 11px;
            font-weight: bold;
            flex-shrink: 0;
        }
        .ss-step.ss-step-done .ss-step-num {
            background: #4caf50;
        }
        /* ── Clearable input highlight ────────────────────────────── */
        .ss-clearable.ss-is-default {
            color: #999;
            font-style: italic;
        }
    </style>

    <asp:HiddenField ID="hfActiveTab"        runat="server" Value="general" />
    <asp:HiddenField ID="hfClientTimezone"   runat="server" Value="" />
    <asp:HiddenField ID="hfClientCurrency"   runat="server" Value="" />
    <asp:HiddenField ID="hfClientDateFormat" runat="server" Value="" />

    <h2 class="ss-page-title">
        <i class="fas fa-cog"></i> System Settings &amp; Configuration
        <span class="ss-site-badge">
            <i class="fas fa-map-marker-alt"></i> Site:&nbsp;<asp:Label ID="lblSiteContext" runat="server" Text="" />
        </span>
    </h2>

    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- Tab Navigation -->
    <div class="ss-tabs">
        <button type="button" class="ss-tab-btn" data-tab="general" onclick="switchTab('general', this)">
            <i class="fas fa-building"></i> General
        </button>
        <button type="button" class="ss-tab-btn" data-tab="attendance" onclick="switchTab('attendance', this)">
            <i class="fas fa-user-clock"></i> Attendance
        </button>
        <button type="button" class="ss-tab-btn" data-tab="leave" onclick="switchTab('leave', this)">
            <i class="fas fa-calendar-alt"></i> Leave
        </button>
        <button type="button" class="ss-tab-btn" data-tab="email" onclick="switchTab('email', this)">
            <i class="fas fa-envelope"></i> Email
        </button>
        <button type="button" class="ss-tab-btn" data-tab="security" onclick="switchTab('security', this)">
            <i class="fas fa-shield-alt"></i> Security
        </button>
        <button type="button" class="ss-tab-btn" data-tab="notifications" onclick="switchTab('notifications', this)">
            <i class="fas fa-bell"></i> Notifications
        </button>
        <button type="button" class="ss-tab-btn" data-tab="features" onclick="switchTab('features', this)">
            <i class="fas fa-toggle-on"></i> Features
        </button>
    </div>

    <!-- General Settings Tab -->
    <div id="general" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-building"></i> General Company Settings</h3>

            <%-- Setup guidance banner: shown when fields still contain default values --%>
            <div id="ss-setup-guide" class="ss-setup-guide" style="display:none;">
                <div class="ss-setup-guide-header">
                    <span><i class="fas fa-info-circle"></i> <strong>Initial Setup</strong> &mdash; Complete the steps below to configure your site.</span>
                    <button type="button" onclick="ssDismissGuide()" class="ss-guide-close" title="Dismiss">&times;</button>
                </div>
                <ol class="ss-setup-steps">
                    <li id="gs-step1" class="ss-step"><span class="ss-step-num">1</span> Enter your <strong>Company Name</strong> &mdash; this appears on reports and exports.</li>
                    <li id="gs-step2" class="ss-step"><span class="ss-step-num">2</span> Enter your <strong>Company Email</strong> &mdash; used as the system reply-to address.</li>
                    <li id="gs-step3" class="ss-step"><span class="ss-step-num">3</span> Enter your <strong>Company Phone</strong> number.</li>
                    <li id="gs-step4" class="ss-step"><span class="ss-step-num">4</span> Select your <strong>Time Zone</strong> &mdash; auto-detected from your browser.</li>
                    <li id="gs-step5" class="ss-step"><span class="ss-step-num">5</span> Select your <strong>Currency</strong> &mdash; auto-detected from your browser locale.</li>
                    <li id="gs-step6" class="ss-step"><span class="ss-step-num">6</span> Choose your preferred <strong>Date Format</strong>.</li>
                    <li id="gs-step7" class="ss-step"><span class="ss-step-num">7</span> Click <strong>Save General Settings</strong> when done.</li>
                </ol>
            </div>

            <div class="ss-form-grid">
                <div class="ss-form-group">
                    <label>Company Name:</label>
                    <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control ss-clearable"
                        data-default="Your Company Name"
                        placeholder="e.g. Acme Corporation" />
                </div>
                <div class="ss-form-group">
                    <label>Company Email:</label>
                    <asp:TextBox ID="txtCompanyEmail" runat="server" CssClass="form-control ss-clearable" TextMode="Email"
                        data-default="hr@company.com"
                        placeholder="e.g. hr@yourcompany.com" />
                </div>
                <div class="ss-form-group">
                    <label>Company Phone:</label>
                    <asp:TextBox ID="txtCompanyPhone" runat="server" CssClass="form-control ss-clearable"
                        data-default="+1-800-000-0000"
                        placeholder="e.g. +27 11 123 4567" /></div>
                <div class="ss-form-group">
                    <label>Time Zone:</label>
                    <asp:DropDownList ID="ddlTimeZone" runat="server" CssClass="form-control">
                        <asp:ListItem Text="EST - Eastern Standard"   Value="EST" />
                        <asp:ListItem Text="CST - Central Standard"   Value="CST" />
                        <asp:ListItem Text="MST - Mountain Standard"  Value="MST" />
                        <asp:ListItem Text="PST - Pacific Standard"   Value="PST" />
                        <asp:ListItem Text="GMT - Greenwich Mean Time" Value="GMT" />
                        <asp:ListItem Text="CET - Central European"   Value="CET" />
                        <asp:ListItem Text="SAST - South Africa Standard" Value="SAST" />
                        <asp:ListItem Text="IST - Indian Standard"    Value="IST" />
                        <asp:ListItem Text="GST - Gulf Standard"      Value="GST" />
                        <asp:ListItem Text="AEST - Australian Eastern" Value="AEST" />
                    </asp:DropDownList>
                </div>
                <div class="ss-form-group">
                    <label>Currency:</label>
                    <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="form-control">
                        <asp:ListItem Text="USD - US Dollar"       Value="USD" />
                        <asp:ListItem Text="EUR - Euro"            Value="EUR" />
                        <asp:ListItem Text="GBP - British Pound"   Value="GBP" />
                        <asp:ListItem Text="ZAR - South African Rand" Value="ZAR" />
                        <asp:ListItem Text="INR - Indian Rupee"    Value="INR" />
                        <asp:ListItem Text="AUD - Australian Dollar" Value="AUD" />
                        <asp:ListItem Text="AED - UAE Dirham"      Value="AED" />
                        <asp:ListItem Text="SAR - Saudi Riyal"     Value="SAR" />
                        <asp:ListItem Text="CNY - Chinese Yuan"    Value="CNY" />
                        <asp:ListItem Text="JPY - Japanese Yen"    Value="JPY" />
                    </asp:DropDownList>
                </div>
                <div class="ss-form-group">
                    <label>Date Format:</label>
                    <asp:DropDownList ID="ddlDateFormat" runat="server" CssClass="form-control">
                        <asp:ListItem Text="yyyy-MM-dd" Value="yyyy-MM-dd" />
                        <asp:ListItem Text="MM/dd/yyyy" Value="MM/dd/yyyy" />
                        <asp:ListItem Text="dd/MM/yyyy" Value="dd/MM/yyyy" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkMaintenanceMode" runat="server" />
                <label>Enable Maintenance Mode</label>
            </div>
            <div class="ss-btn-row">
                <asp:Button ID="btnSaveGeneral" runat="server" Text="Save General Settings" CssClass="btn btn-primary" OnClick="btnSaveGeneral_Click" />
            </div>
        </div>
    </div>

    <!-- Attendance Settings Tab -->
    <div id="attendance" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-user-clock"></i> Attendance Settings</h3>
            <div class="ss-form-grid">
                <div class="ss-form-group">
                    <label>Late Arrival Threshold (minutes):</label>
                    <asp:TextBox ID="txtLateArrivalThreshold" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Early Departure Threshold (minutes):</label>
                    <asp:TextBox ID="txtEarlyDepartureThreshold" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Grace Period (minutes):</label>
                    <asp:TextBox ID="txtGracePeriod" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Minimum Attendance (%):</label>
                    <asp:TextBox ID="txtMinAttendance" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkAutoCheckOut" runat="server" />
                <label>Allow Auto Check-Out</label>
            </div>
            <div class="ss-btn-row">
                <asp:Button ID="btnSaveAttendance" runat="server" Text="Save Attendance Settings" CssClass="btn btn-primary" OnClick="btnSaveAttendance_Click" />
            </div>
        </div>
    </div>

    <!-- Leave Settings Tab -->
    <div id="leave" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-calendar-alt"></i> Leave Type Settings</h3>
            <asp:GridView ID="gvLeaveTypes" runat="server" AutoGenerateColumns="False" CssClass="ss-table" DataKeyNames="LeaveTypeID">
                <Columns>
                    <asp:BoundField DataField="LeaveTypeName" HeaderText="Leave Type" />
                    <asp:BoundField DataField="AllocationPerYear" HeaderText="Days / Year" />
                    <asp:TemplateField HeaderText="Encashable">
                        <ItemTemplate>
                            <span class='status-badge <%# ((object)Eval("EncashableLeaves") != DBNull.Value && (bool)Eval("EncashableLeaves")) ? "status-active" : "status-inactive" %>'>
                                <%# ((object)Eval("EncashableLeaves") != DBNull.Value && (bool)Eval("EncashableLeaves")) ? "Yes" : "No" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Email Settings Tab -->
    <div id="email" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-envelope"></i> Email Configuration</h3>
            <div class="ss-form-grid">
                <div class="ss-form-group">
                    <label>SMTP Server:</label>
                    <asp:TextBox ID="txtSMTPServer" runat="server" CssClass="form-control" />
                </div>
                <div class="ss-form-group">
                    <label>SMTP Port:</label>
                    <asp:TextBox ID="txtSMTPPort" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>From Email:</label>
                    <asp:TextBox ID="txtFromEmail" runat="server" CssClass="form-control" TextMode="Email" />
                </div>
                <div class="ss-form-group">
                    <label>From Display Name:</label>
                    <asp:TextBox ID="txtFromDisplayName" runat="server" CssClass="form-control" />
                </div>
                <div class="ss-form-group">
                    <label>Username:</label>
                    <asp:TextBox ID="txtEmailUsername" runat="server" CssClass="form-control" />
                </div>
                <div class="ss-form-group">
                    <label>Password:</label>
                    <asp:TextBox ID="txtEmailPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkEnableSSL" runat="server" Checked="true" />
                <label>Enable SSL</label>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkEnableTLS" runat="server" Checked="true" />
                <label>Enable TLS</label>
            </div>
            <div class="ss-btn-row">
                <asp:Button ID="btnSaveEmail" runat="server" Text="Save Email Settings" CssClass="btn btn-primary" OnClick="btnSaveEmail_Click" />
                <asp:Button ID="btnTestEmail" runat="server" Text="Send Test Email" CssClass="btn btn-secondary" OnClick="btnTestEmail_Click" />
            </div>
        </div>
    </div>

    <!-- Security Settings Tab -->
    <div id="security" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-shield-alt"></i> Security Configuration</h3>
            <div class="ss-form-grid">
                <div class="ss-form-group">
                    <label>Password Minimum Length:</label>
                    <asp:TextBox ID="txtPasswordMinLength" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Password Expiry Days:</label>
                    <asp:TextBox ID="txtPasswordExpiryDays" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Max Login Attempts:</label>
                    <asp:TextBox ID="txtMaxLoginAttempts" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Lockout Duration (minutes):</label>
                    <asp:TextBox ID="txtLockoutDuration" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
                <div class="ss-form-group">
                    <label>Session Timeout (minutes):</label>
                    <asp:TextBox ID="txtSessionTimeout" runat="server" CssClass="form-control" TextMode="Number" />
                </div>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkPasswordRequireUppercase" runat="server" Checked="true" />
                <label>Require Uppercase</label>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkPasswordRequireLowercase" runat="server" Checked="true" />
                <label>Require Lowercase</label>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkPasswordRequireNumbers" runat="server" Checked="true" />
                <label>Require Numbers</label>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkPasswordRequireSpecialCharacters" runat="server" Checked="true" />
                <label>Require Special Characters</label>
            </div>
            <div class="ss-checkbox-group">
                <asp:CheckBox ID="chkEnableTwoFactor" runat="server" />
                <label>Enable Two-Factor Authentication</label>
            </div>
            <div class="ss-btn-row">
                <asp:Button ID="btnSaveSecurity" runat="server" Text="Save Security Settings" CssClass="btn btn-primary" OnClick="btnSaveSecurity_Click" />
            </div>
        </div>
    </div>

    <!-- Notifications & Reminders Tab -->
    <div id="notifications" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-bell"></i> Notification Configuration</h3>
            <div class="ss-form-grid">
                <div class="ss-checkbox-group">
                    <asp:CheckBox ID="chkEmailNotif" runat="server" Checked="true" />
                    <label><i class="fas fa-envelope"></i> Enable Email Notifications</label>
                </div>
                <div class="ss-checkbox-group">
                    <asp:CheckBox ID="chkSMSNotif" runat="server" />
                    <label><i class="fas fa-sms"></i> Enable SMS Notifications</label>
                </div>
                <div class="ss-checkbox-group">
                    <asp:CheckBox ID="chkInAppNotif" runat="server" Checked="true" />
                    <label><i class="fas fa-desktop"></i> Enable In-App Notifications</label>
                </div>
                <div class="ss-checkbox-group">
                    <asp:CheckBox ID="chkPushNotif" runat="server" />
                    <label><i class="fas fa-mobile-alt"></i> Enable Push Notifications</label>
                </div>
            </div>

            <div class="ss-notif-box">
                <h4><i class="fas fa-sliders-h"></i> Delivery Settings</h4>
                <div class="ss-form-grid">
                    <div class="ss-form-group">
                        <label>Email Retry Attempts:</label>
                        <asp:TextBox ID="txtNotifEmailRetries" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="ss-form-group">
                        <label>Retry Interval (minutes):</label>
                        <asp:TextBox ID="txtNotifRetryInterval" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="ss-form-group">
                        <label>Queue Processing (seconds):</label>
                        <asp:TextBox ID="txtNotifQueueInterval" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                    <div class="ss-form-group">
                        <label>Retention Period (days):</label>
                        <asp:TextBox ID="txtNotifRetention" runat="server" CssClass="form-control" TextMode="Number" />
                    </div>
                </div>
                <div class="ss-checkbox-group" style="margin-top: 10px;">
                    <asp:CheckBox ID="chkNotifDeduplication" runat="server" Checked="true" />
                    <label>Enable Deduplication</label>
                </div>
            </div>

            <h4><i class="fas fa-clock"></i> Reminder Configuration</h4>
            <asp:GridView ID="gvNotifReminders" runat="server" AutoGenerateColumns="False" CssClass="ss-table" DataKeyNames="ReminderSettingID" OnRowCommand="gvNotifReminders_RowCommand">
                <Columns>
                    <asp:BoundField DataField="ReminderType" HeaderText="Reminder Type" />
                    <asp:BoundField DataField="DaysBeforeReminder" HeaderText="Days Before" />
                    <asp:BoundField DataField="ReminderFrequency" HeaderText="Frequency" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='status-badge <%# ((bool)Eval("IsEnabled")) ? "status-active" : "status-inactive" %>'>
                                <%# ((bool)Eval("IsEnabled")) ? "Enabled" : "Disabled" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <div class="ss-btn-row">
                <asp:Button ID="btnSaveNotifications" runat="server" Text="Save Notification Settings" CssClass="btn btn-primary" OnClick="btnSaveNotifications_Click" />
            </div>
        </div>

        <div class="ss-panel" style="border-left-color: #17a2b8;">
            <h3><i class="fas fa-file-alt"></i> Notification Templates</h3>
            <asp:GridView ID="gvNotifTemplates" runat="server" AutoGenerateColumns="True" CssClass="ss-table">
            </asp:GridView>
        </div>
    </div>

    <!-- Features Tab -->
    <div id="features" class="ss-tab-content">
        <div class="ss-panel">
            <h3><i class="fas fa-toggle-on"></i> Feature Toggles</h3>
            <asp:GridView ID="gvFeatures" runat="server" AutoGenerateColumns="False" CssClass="ss-table" DataKeyNames="FeatureID" OnRowCommand="gvFeatures_RowCommand">
                <Columns>
                    <asp:BoundField DataField="FeatureName" HeaderText="Feature" />
                    <asp:BoundField DataField="FeatureDescription" HeaderText="Description" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='status-badge <%# ((bool)Eval("IsEnabled")) ? "status-active" : "status-inactive" %>'>
                                <%# ((bool)Eval("IsEnabled")) ? "Enabled" : "Disabled" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkToggle" runat="server" CommandName="Toggle" CommandArgument='<%# Eval("FeatureID") %>'
                                Text='<%# ((bool)Eval("IsEnabled")) ? "Disable" : "Enable" %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <script>
        // ── Click-to-clear for inputs with data-default ───────────────────────────
        // On focus: if the value matches the default placeholder, clear it.
        // On blur:  if left empty, restore the default so the field isn't blank.
        // A grey italic style (ss-is-default) visually marks unfilled fields.
        (function () {
            function initClearable(input) {
                var def = input.getAttribute('data-default');
                if (!def) return;

                // Mark as default if the current value matches
                function checkDefault() {
                    if (input.value === def || input.value === '') {
                        input.classList.add('ss-is-default');
                        if (input.value === '') input.value = def;
                    } else {
                        input.classList.remove('ss-is-default');
                    }
                }

                input.addEventListener('focus', function () {
                    if (input.value === def) {
                        input.value = '';
                        input.classList.remove('ss-is-default');
                    }
                });

                input.addEventListener('blur', function () {
                    checkDefault();
                    updateSetupGuide();
                });

                input.addEventListener('input', function () {
                    updateSetupGuide();
                });

                checkDefault();
            }

            // Initialise all clearable inputs on the page
            window.addEventListener('DOMContentLoaded', function () {
                var inputs = document.querySelectorAll('.ss-clearable');
                for (var i = 0; i < inputs.length; i++) initClearable(inputs[i]);
                updateSetupGuide();
            });
        })();

        // ── Setup guide show / step-completion logic ─────────────────────────
        function ssDismissGuide() {
            var el = document.getElementById('ss-setup-guide');
            if (el) el.style.display = 'none';
            // Remember dismissal in sessionStorage so it doesn't reappear this session
            try { sessionStorage.setItem('ss_guide_dismissed', '1'); } catch (e) {}
        }

        function updateSetupGuide() {
            try { if (sessionStorage.getItem('ss_guide_dismissed') === '1') return; } catch (e) {}

            var guide = document.getElementById('ss-setup-guide');
            if (!guide) return;

            var defaults = ['Your Company Name', 'hr@company.com', '+1-800-000-0000'];
            var ids      = ['<%= txtCompanyName.ClientID %>', '<%= txtCompanyEmail.ClientID %>', '<%= txtCompanyPhone.ClientID %>'];
            var steps    = ['gs-step1', 'gs-step2', 'gs-step3'];
            var anyIncomplete = false;

            for (var i = 0; i < ids.length; i++) {
                var el  = document.getElementById(ids[i]);
                var stp = document.getElementById(steps[i]);
                if (!el || !stp) continue;
                var isDone = el.value && el.value !== defaults[i];
                stp.className = 'ss-step' + (isDone ? ' ss-step-done' : '');
                if (!isDone) anyIncomplete = true;
            }

            // Steps 4-7 (dropdowns + save) are always shown as pending until saved
            var wasSaved = '<%= Request.IsAuthenticated && !string.IsNullOrEmpty(txtCompanyName.Text) && txtCompanyName.Text != "Your Company Name" ? "1" : "0" %>';
            ['gs-step4','gs-step5','gs-step6'].forEach(function(id) {
                var s = document.getElementById(id);
                if (s) s.className = 'ss-step' + (wasSaved === '1' ? ' ss-step-done' : '');
            });

            guide.style.display = anyIncomplete ? 'block' : 'none';
        }
    </script>

    <script>
        // and writes the values into hidden fields so the server can use them
        // as defaults when no saved DB value exists yet.
        (function () {
            var tzHf  = document.getElementById('<%= hfClientTimezone.ClientID %>');
            var curHf = document.getElementById('<%= hfClientCurrency.ClientID %>');
            var dfHf  = document.getElementById('<%= hfClientDateFormat.ClientID %>');

            if (!tzHf || tzHf.value) return; // already detected on a previous postback

            try {
                // ── Timezone ────────────────────────────────────────────────
                var ianaZone = Intl.DateTimeFormat().resolvedOptions().timeZone || '';
                // Map common IANA zones to the app's timezone codes
                var tzMap = {
                    'America/New_York'    : 'EST',
                    'America/Detroit'     : 'EST',
                    'America/Indiana/Indianapolis': 'EST',
                    'America/Chicago'     : 'CST',
                    'America/Winnipeg'    : 'CST',
                    'America/Denver'      : 'MST',
                    'America/Phoenix'     : 'MST',
                    'America/Los_Angeles' : 'PST',
                    'America/Vancouver'   : 'PST',
                    'Asia/Kolkata'        : 'IST',
                    'Asia/Calcutta'       : 'IST',
                    'Africa/Johannesburg' : 'SAST',
                    'Africa/Harare'       : 'SAST',
                    'Europe/London'       : 'GMT',
                    'Europe/Dublin'       : 'GMT',
                    'Europe/Paris'        : 'CET',
                    'Europe/Berlin'       : 'CET',
                    'Europe/Amsterdam'    : 'CET',
                    'Australia/Sydney'    : 'AEST',
                    'Australia/Melbourne' : 'AEST',
                    'Asia/Dubai'          : 'GST',
                    'Asia/Riyadh'         : 'AST'
                };
                tzHf.value = tzMap[ianaZone] || ianaZone;

                // ── Currency ────────────────────────────────────────────────
                // Derive the likely currency from the browser locale
                var locale = navigator.language || navigator.userLanguage || 'en-US';
                var region  = locale.split('-')[1] || '';
                var currMap = {
                    'US': 'USD', 'CA': 'USD',
                    'ZA': 'ZAR',
                    'GB': 'GBP', 'AU': 'AUD', 'NZ': 'AUD',
                    'IN': 'INR',
                    'DE': 'EUR', 'FR': 'EUR', 'IT': 'EUR', 'ES': 'EUR',
                    'NL': 'EUR', 'BE': 'EUR', 'AT': 'EUR', 'PT': 'EUR',
                    'AE': 'AED', 'SA': 'SAR',
                    'CN': 'CNY', 'JP': 'JPY'
                };
                curHf.value = currMap[region.toUpperCase()] || '';

                // ── Date format ──────────────────────────────────────────────
                // Detect order of day/month/year from Intl.DateTimeFormat
                var parts = new Intl.DateTimeFormat(locale, { year: 'numeric', month: '2-digit', day: '2-digit' })
                                    .formatToParts(new Date(2025, 0, 31)); // 31 Jan 2025
                var order = parts.filter(function(p) {
                    return p.type === 'year' || p.type === 'month' || p.type === 'day';
                }).map(function(p) { return p.type[0]; }).join('');
                // order will be e.g. 'mdy', 'dmy', 'ymd'
                var dfMap = { 'mdy': 'MM/dd/yyyy', 'dmy': 'dd/MM/yyyy', 'ymd': 'yyyy-MM-dd' };
                dfHf.value = dfMap[order] || 'yyyy-MM-dd';

            } catch (e) { /* Intl not supported — leave blank, server defaults will apply */ }
        })();
    </script>

    <script>
        function switchTab(tabName, btn) {
            // Store active tab
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (hf) hf.value = tabName;

            // Hide all tab content
            var contents = document.getElementsByClassName('ss-tab-content');
            for (var i = 0; i < contents.length; i++) {
                contents[i].classList.remove('active');
            }

            // Deactivate all tab buttons
            var buttons = document.getElementsByClassName('ss-tab-btn');
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].classList.remove('active');
            }

            // Show selected tab and mark button active
            var target = document.getElementById(tabName);
            if (target) target.classList.add('active');
            if (btn) btn.classList.add('active');
        }

        // Restore active tab on postback
        (function () {
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');
            var activeTab = hf ? hf.value : 'general';
            if (!activeTab) activeTab = 'general';

            var btn = document.querySelector('.ss-tab-btn[data-tab="' + activeTab + '"]');
            switchTab(activeTab, btn);
        })();
    </script>

</asp:Content>
