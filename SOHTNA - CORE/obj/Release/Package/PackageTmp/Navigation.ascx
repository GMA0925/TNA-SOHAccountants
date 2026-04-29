<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Navigation.ascx.cs" Inherits="TimeAttendance.WebForms.Navigation" %>

<%-- System-wide modal + toast assets --%>
<link href="<%=ResolveUrl("~/Content/sohtna-modal.css")%>?v=2" rel="stylesheet" type="text/css" />

<style>
    .unified-nav-bar {
        background-color: #e9ecef;
        padding: 12px;
        text-align: center;
        border-bottom: 3px solid #0078D4;
        flex-wrap: wrap;
        display: flex;
        gap: 5px;
        justify-content: center;
    }

    .unified-nav-btn {
        margin: 5px;
        padding: 8px 16px;
        font-size: 14px;
        background-color: #0078D4;
        color: white;
        border: none;
        border-radius: 4px;
        text-decoration: none;
        display: inline-block;
        cursor: pointer;
        transition: all 0.3s;
        white-space: nowrap;
    }

    .unified-nav-btn:hover {
        background-color: #005a9e;
        color: white;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }

    .unified-nav-btn.active {
        background-color: #005a9e;
        font-weight: bold;
        border: 2px solid white;
    }

    .nav-divider {
        display: inline-block;
        width: 2px;
        height: 20px;
        background-color: #0078D4;
        margin: 0 5px;
        opacity: 0.5;
    }

    /* User Info Display */
    .user-info-section {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-left: auto;
        padding-right: 20px;
        font-size: 14px;
        color: #333;
    }

    .user-info-item {
        display: flex;
        align-items: center;
        gap: 5px;
        padding: 5px 10px;
        background-color: rgba(255, 255, 255, 0.7);
        border-radius: 4px;
        white-space: nowrap;
    }

    .user-info-label {
        font-weight: 600;
        color: #555;
    }

    .user-info-value {
        color: #0078D4;
        font-weight: bold;
        min-width: 60px;
    }

    /* Admin buttons (darker shade) */
    .nav-admin {
        background-color: #1e5a96;
    }

    .nav-admin:hover {
        background-color: #003d6b;
    }

    /* Employee features (green shade) */
    .nav-employee {
        background-color: #28a745;
    }

    .nav-employee:hover {
        background-color: #218838;
    }

    /* Compliance (purple shade) */
    .nav-compliance {
        background-color: #6f42c1;
    }

    .nav-compliance:hover {
        background-color: #5a32a3;
    }

    @media (max-width: 1024px) {
        .unified-nav-bar {
            gap: 3px;
        }

        .unified-nav-btn {
            padding: 6px 12px;
            font-size: 13px;
            margin: 3px;
        }

        .nav-divider {
            display: none;
        }

        .user-info-section {
            margin-left: 10px;
            padding-right: 10px;
            gap: 10px;
        }

        .user-info-item {
            padding: 4px 8px;
            font-size: 12px;
        }
    }

    @media (max-width: 768px) {
        .unified-nav-bar {
            flex-wrap: wrap;
            gap: 4px;
            padding: 8px;
        }

        .unified-nav-btn {
            padding: 5px 10px;
            font-size: 11px;
            margin: 2px;
            flex: 0 1 auto;
            white-space: nowrap;
        }

        .unified-nav-btn i {
            margin-right: 4px;
        }

        .user-info-section {
            flex-direction: row;
            flex-wrap: wrap;
            margin-left: 0;
            padding-right: 0;
            padding: 6px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 4px;
            gap: 6px;
            width: 100%;
            justify-content: center;
        }

        .user-info-item {
            padding: 3px 6px;
            font-size: 11px;
        }
    }
</style>

<nav class="unified-nav-bar">
    <!-- Core Navigation -->
    <asp:LinkButton ID="btnDashboard" runat="server" CssClass="unified-nav-btn" OnClick="btnDashboard_Click">
        <i class="fas fa-chart-line"></i> Dashboard
    </asp:LinkButton>

    <div class="nav-divider"></div>

    <!-- Admin Section -->
    <asp:LinkButton ID="btnUsers" runat="server" CssClass="unified-nav-btn nav-admin" OnClick="btnUsers_Click">
        <i class="fas fa-users-cog"></i> Users
    </asp:LinkButton>

    <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="unified-nav-btn nav-admin" OnClick="btnSyncLog_Click">
        <i class="fas fa-sync"></i> Sync Log
    </asp:LinkButton>

    <asp:LinkButton ID="btnClockAdmin" runat="server" CssClass="unified-nav-btn nav-admin" OnClick="btnClockAdmin_Click">
        <i class="fas fa-clock"></i> Clock Admin
    </asp:LinkButton>

    <div class="nav-divider"></div>

    <!-- Employee/HR Section -->
    <asp:LinkButton ID="btnEmployees" runat="server" CssClass="unified-nav-btn nav-employee" OnClick="btnEmployees_Click">
        <i class="fas fa-id-card-alt"></i> Employees
    </asp:LinkButton>

    <asp:LinkButton ID="btnShiftManagement" runat="server" CssClass="unified-nav-btn nav-employee" OnClick="btnShiftManagement_Click">
        <i class="fas fa-calendar-alt"></i> Shifts
    </asp:LinkButton>

    <div class="nav-divider"></div>

    <!-- Reports & Analytics -->
    <asp:LinkButton ID="btnReports" runat="server" CssClass="unified-nav-btn" OnClick="btnReports_Click">
        <i class="fas fa-file-alt"></i> Reports
    </asp:LinkButton>



    <asp:LinkButton ID="btnSettings" runat="server" CssClass="unified-nav-btn nav-admin" OnClick="btnSettings_Click"
        ToolTip="System Settings">
        <i class="fas fa-cog"></i> Settings
    </asp:LinkButton>

    <div class="nav-divider"></div>

    <!-- Notification Settings -->


    <!-- Profile -->
    <asp:LinkButton ID="btnProfile" runat="server" CssClass="unified-nav-btn nav-employee" OnClick="btnProfile_Click"
        ToolTip="My Profile - View and Edit Your Information">
        <i class="fas fa-user"></i> Profile
    </asp:LinkButton>

    <!-- User Info Display -->
    <div class="nav-divider"></div>
    
    <div class="user-info-section">
        <div class="user-info-item">
            <span class="user-info-label">👤 Role:</span>
            <asp:Label ID="lblUserRole" runat="server" CssClass="user-info-value"></asp:Label>
        </div>
        <span class="nav-divider"></span>
        <div class="user-info-item">
            <span class="user-info-label">🏢 Site:</span>
            <asp:Label ID="lblUserSiteId" runat="server" CssClass="user-info-value"></asp:Label>
        </div>
    </div>
</nav>

<%-- ═══════════════════════════════════════════════════════════════
     SOHTNA — System-wide Modal Shell
     Open with: SOHTNA.modal.open({ title:'...', body:'...' })
     ═══════════════════════════════════════════════════════════════ --%>
<div id="sohtna-modal-overlay" class="sohtna-modal-overlay" style="display:none;">
    <div id="sohtna-modal-win" class="sohtna-modal" role="dialog" aria-modal="true">
        <div class="sohtna-modal-header">
            <h3 class="sohtna-modal-title"></h3>
            <button type="button" class="sohtna-modal-close" aria-label="Close">&times;</button>
        </div>
        <div class="sohtna-modal-body"></div>
    </div>
</div>

<%-- ═══════════════════════════════════════════════════════════════
     SOHTNA — Toast Notification Container
     Fire with: SOHTNA.toast.success('Saved!') etc.
     ═══════════════════════════════════════════════════════════════ --%>
<div id="sohtna-toast-container" aria-live="polite" aria-atomic="false"></div>

<%-- ═══════════════════════════════════════════════════════════════
     SOHTNA — Confirm Dialog
     Fire with: SOHTNA.confirm.show({ type, title, message, onYes, onNo })
     ═══════════════════════════════════════════════════════════════ --%>
<div id="sohtna-confirm-overlay" class="sohtna-confirm-overlay" style="display:none;">
    <div class="sohtna-confirm">
        <div id="sohtna-confirm-header" class="sohtna-confirm-header">
            <i id="sohtna-confirm-icon" class="fas fa-question-circle"></i>
            <h4 id="sohtna-confirm-title">Confirm</h4>
        </div>
        <div class="sohtna-confirm-body">
            <p id="sohtna-confirm-msg"></p>
        </div>
        <div class="sohtna-confirm-footer">
            <button type="button" id="sohtna-confirm-yes" class="sohtna-btn sohtna-btn-primary">Yes</button>
            <button type="button" id="sohtna-confirm-no" class="sohtna-btn sohtna-btn-secondary">No</button>
        </div>
    </div>
</div>

<script src="<%=ResolveUrl("~/Scripts/sohtna-modal.js")%>?v=2" type="text/javascript"></script>

