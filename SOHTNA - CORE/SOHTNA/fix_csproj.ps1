$root = "C:\Dev Projects\SOH Solutions\Web UI END March 2026\SOHTNA"

# ?? EmployeeProfile.aspx ????????????????????????????????????????????????
$aspx = @'
<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeProfile.aspx.cs" Inherits="TimeAttendance.WebForms.EmployeeProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        .ep-page-title { font-size:22px; color:#0078D4; margin:20px 0 18px 0; padding-bottom:10px; border-bottom:2px solid #0078D4; }
        .ep-layout { display:flex; gap:20px; align-items:flex-start; flex-wrap:wrap; }
        .ep-sidebar { flex:0 0 240px; min-width:200px; }
        .ep-main { flex:1 1 0; min-width:0; }
        .ep-avatar-card { background:#fff; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,.10); padding:24px 16px 20px; text-align:center; border-top:4px solid #0078D4; margin-bottom:16px; }
        .ep-avatar { width:90px; height:90px; border-radius:50%; background:linear-gradient(135deg,#0078D4 0%,#00b4d8 100%); color:#fff; font-size:36px; font-weight:700; display:flex; align-items:center; justify-content:center; margin:0 auto 14px; user-select:none; }
        .ep-user-name { font-size:17px; font-weight:700; color:#1a1a2e; margin-bottom:4px; }
        .ep-user-role { font-size:12px; font-weight:600; display:inline-block; padding:3px 10px; border-radius:12px; background:#e8f0fe; color:#0078D4; margin-bottom:8px; }
        .ep-user-site { font-size:12px; color:#666; }
        .ep-user-site i { color:#0078D4; }
        .ep-stats-strip { display:flex; gap:12px; margin-bottom:18px; flex-wrap:wrap; }
        .ep-stat-box { flex:1 1 120px; background:#fff; border-radius:6px; box-shadow:0 2px 6px rgba(0,0,0,.08); padding:14px 16px; text-align:center; border-top:3px solid #0078D4; }
        .ep-stat-box.green  { border-top-color:#28a745; }
        .ep-stat-box.orange { border-top-color:#fd7e14; }
        .ep-stat-box.teal   { border-top-color:#17a2b8; }
        .ep-stat-val { font-size:24px; font-weight:700; color:#1a1a2e; line-height:1.1; }
        .ep-stat-lbl { font-size:11px; color:#888; margin-top:4px; }
        .ep-panel { background:#fff; border-radius:6px; box-shadow:0 2px 6px rgba(0,0,0,.08); padding:20px 22px; margin-bottom:18px; border-left:5px solid #0078D4; }
        .ep-panel.green  { border-left-color:#28a745; }
        .ep-panel.orange { border-left-color:#fd7e14; }
        .ep-panel.teal   { border-left-color:#17a2b8; }
        .ep-panel h3 { margin:0 0 16px 0; font-size:15px; color:#0078D4; }
        .ep-panel.green  h3 { color:#28a745; }
        .ep-panel.orange h3 { color:#fd7e14; }
        .ep-panel.teal   h3 { color:#17a2b8; }
        .ep-form-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:14px 20px; }
        .ep-form-group { display:flex; flex-direction:column; }
        .ep-form-group label { font-size:12px; font-weight:600; color:#555; margin-bottom:5px; text-transform:uppercase; letter-spacing:.4px; }
        .ep-form-group label i { margin-right:5px; color:#0078D4; }
        .ep-input { padding:8px 10px; border:1px solid #d0d7de; border-radius:4px; font-size:14px; background:#f6f8fa; color:#1a1a2e; width:100%; box-sizing:border-box; transition:border-color .15s; }
        .ep-input:focus { border-color:#0078D4; outline:none; background:#fff; box-shadow:0 0 0 2px rgba(0,120,212,.12); }
        .ep-input[readonly], .ep-input:disabled { background:#eef1f5; color:#666; cursor:default; }
        .ep-field-val { padding:8px 10px; background:#eef1f5; border:1px solid #d0d7de; border-radius:4px; font-size:14px; color:#333; min-height:36px; }
        .ep-badge { display:inline-block; padding:3px 9px; border-radius:10px; font-size:12px; font-weight:600; }
        .ep-badge-active   { background:#d4edda; color:#155724; }
        .ep-badge-inactive { background:#f8d7da; color:#721c24; }
        .ep-btn-row { margin-top:18px; display:flex; gap:10px; flex-wrap:wrap; }
        .ep-btn { padding:9px 20px; font-size:13px; font-weight:600; border-radius:4px; border:none; cursor:pointer; transition:background-color .2s; }
        .ep-btn-primary   { background:#0078D4; color:#fff; }
        .ep-btn-primary:hover { background:#005a9e; }
        .ep-btn-secondary { background:#6c757d; color:#fff; }
        .ep-btn-secondary:hover { background:#5a6268; }
        .ep-btn-danger    { background:#dc3545; color:#fff; }
        .ep-btn-danger:hover { background:#b02a37; }
        .ep-alert { padding:11px 15px; border-radius:4px; font-size:13px; margin-bottom:14px; display:flex; align-items:center; gap:8px; }
        .ep-alert-success { background:#d4edda; color:#155724; border-left:4px solid #28a745; }
        .ep-alert-error   { background:#f8d7da; color:#721c24; border-left:4px solid #dc3545; }
        .ep-alert-info    { background:#d1ecf1; color:#0c5460; border-left:4px solid #17a2b8; }
        .ep-table { width:100%; border-collapse:collapse; font-size:13px; margin-top:6px; }
        .ep-table thead { background:#0078D4; color:#fff; }
        .ep-table th, .ep-table td { padding:9px 11px; text-align:left; border:1px solid #dde3ea; }
        .ep-table tbody tr:nth-child(even) { background:#f4f6f9; }
        .ep-table tbody tr:hover           { background:#e8f0fe; }
        .ep-pwd-strength { height:4px; border-radius:2px; margin-top:5px; transition:width .3s,background-color .3s; width:0; }
        @media (max-width:700px) { .ep-layout { flex-direction:column; } .ep-sidebar { flex:1 1 auto; width:100%; } }
    </style>

    <asp:HiddenField ID="hfEmployeeID" runat="server" Value="" />
    <h2 class="ep-page-title"><i class="fas fa-user-circle"></i> My Profile</h2>
    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <div class="ep-layout">
        <div class="ep-sidebar">
            <div class="ep-avatar-card">
                <div class="ep-avatar"><asp:Label ID="lblInitials" runat="server" Text="??" /></div>
                <div class="ep-user-name"><asp:Label ID="lblFullName" runat="server" Text="" /></div>
                <div><span class="ep-user-role"><asp:Label ID="lblRoleBadge" runat="server" Text="" /></span></div>
                <div class="ep-user-site" style="margin-top:8px;"><i class="fas fa-map-marker-alt"></i> Site: <strong><asp:Label ID="lblSiteBadge" runat="server" Text="" /></strong></div>
                <div style="margin-top:8px;font-size:12px;color:#888;"><i class="fas fa-id-badge"></i> User: <asp:Label ID="lblUsernameSidebar" runat="server" Text="" /></div>
            </div>
            <asp:Panel ID="pnlEmployeeLink" runat="server" Visible="false">
                <div class="ep-panel teal" style="padding:14px 16px;">
                    <h3 style="font-size:13px;"><i class="fas fa-id-card"></i> Employee Record</h3>
                    <div style="font-size:12px;color:#444;line-height:1.8;">
                        <div><strong>ID:</strong> <asp:Label ID="lblEmpCode" runat="server" Text="-" /></div>
                        <div><strong>Dept:</strong> <asp:Label ID="lblEmpDept" runat="server" Text="-" /></div>
                        <div><strong>Shift:</strong> <asp:Label ID="lblEmpShift" runat="server" Text="-" /></div>
                        <div><strong>Pay Type:</strong> <asp:Label ID="lblEmpPayType" runat="server" Text="-" /></div>
                        <div style="margin-top:6px;"><asp:Label ID="lblEmpStatus" runat="server" Text="" /></div>
                    </div>
                </div>
            </asp:Panel>
        </div>

        <div class="ep-main">
            <div class="ep-stats-strip">
                <div class="ep-stat-box green">
                    <div class="ep-stat-val"><asp:Label ID="lblStatDaysThisMonth" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-calendar-check"></i> Days Present (Month)</div>
                </div>
                <div class="ep-stat-box orange">
                    <div class="ep-stat-val"><asp:Label ID="lblStatLate" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-clock"></i> Late Arrivals (Month)</div>
                </div>
                <div class="ep-stat-box teal">
                    <div class="ep-stat-val"><asp:Label ID="lblStatHours" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-hourglass-half"></i> Hours Logged (Month)</div>
                </div>
                <div class="ep-stat-box">
                    <div class="ep-stat-val"><asp:Label ID="lblStatTotal" runat="server" Text="0" /></div>
                    <div class="ep-stat-lbl"><i class="fas fa-history"></i> Total Events</div>
                </div>
            </div>

            <div class="ep-panel">
                <h3><i class="fas fa-user-edit"></i> Account Details</h3>
                <div class="ep-form-grid">
                    <div class="ep-form-group"><label><i class="fas fa-signature"></i> Full Name</label><asp:TextBox ID="txtFullName" runat="server" CssClass="ep-input" placeholder="Full name" /></div>
                    <div class="ep-form-group"><label><i class="fas fa-envelope"></i> Email Address</label><asp:TextBox ID="txtEmail" runat="server" CssClass="ep-input" TextMode="Email" placeholder="email@example.com" /></div>
                    <div class="ep-form-group"><label><i class="fas fa-user"></i> Username</label><asp:TextBox ID="txtUsername" runat="server" CssClass="ep-input" ReadOnly="true" /></div>
                    <div class="ep-form-group"><label><i class="fas fa-shield-alt"></i> Role</label><div class="ep-field-val"><asp:Label ID="lblRoleDisplay" runat="server" Text="" /></div></div>
                    <div class="ep-form-group"><label><i class="fas fa-building"></i> Site</label><div class="ep-field-val"><asp:Label ID="lblSiteDisplay" runat="server" Text="" /></div></div>
                    <div class="ep-form-group"><label><i class="fas fa-phone"></i> Phone</label><asp:TextBox ID="txtPhone" runat="server" CssClass="ep-input" placeholder="+1 555 000 0000" /></div>
                </div>
                <div class="ep-btn-row">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="ep-btn ep-btn-primary" OnClick="btnSaveProfile_Click" />
                    <asp:Button ID="btnCancelEdit" runat="server" Text="Reset" CssClass="ep-btn ep-btn-secondary" OnClick="btnCancelEdit_Click" />
                </div>
            </div>

            <div class="ep-panel orange">
                <h3><i class="fas fa-key"></i> Change Password</h3>
                <div class="ep-form-grid">
                    <div class="ep-form-group"><label><i class="fas fa-lock"></i> Current Password</label><asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="Current password" /></div>
                    <div class="ep-form-group"><label><i class="fas fa-lock"></i> New Password</label><asp:TextBox ID="txtNewPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="New password" onkeyup="epPwdStrength(this.value)" /><div id="ep-pwd-bar" class="ep-pwd-strength"></div><div id="ep-pwd-hint" style="font-size:11px;color:#888;margin-top:3px;"></div></div>
                    <div class="ep-form-group"><label><i class="fas fa-lock"></i> Confirm New Password</label><asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="ep-input" TextMode="Password" placeholder="Confirm new password" /></div>
                </div>
                <div class="ep-btn-row"><asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="ep-btn ep-btn-danger" OnClick="btnChangePassword_Click" /></div>
            </div>

            <asp:Panel ID="pnlEmployeeInfo" runat="server" Visible="false">
                <div class="ep-panel green">
                    <h3><i class="fas fa-id-card-alt"></i> Employee Information</h3>
                    <div class="ep-form-grid">
                        <div class="ep-form-group"><label><i class="fas fa-hashtag"></i> Employee Code</label><div class="ep-field-val"><asp:Label ID="lblInfoCode" runat="server" Text="-" /></div></div>
                        <div class="ep-form-group"><label><i class="fas fa-sitemap"></i> Department</label><div class="ep-field-val"><asp:Label ID="lblInfoDept" runat="server" Text="-" /></div></div>
                        <div class="ep-form-group"><label><i class="fas fa-calendar-week"></i> Shift</label><div class="ep-field-val"><asp:Label ID="lblInfoShift" runat="server" Text="-" /></div></div>
                        <div class="ep-form-group"><label><i class="fas fa-money-bill-wave"></i> Pay Type</label><div class="ep-field-val"><asp:Label ID="lblInfoPayType" runat="server" Text="-" /></div></div>
                        <div class="ep-form-group"><label><i class="fas fa-phone-alt"></i> Mobile</label><div class="ep-field-val"><asp:Label ID="lblInfoMobile" runat="server" Text="-" /></div></div>
                        <div class="ep-form-group"><label><i class="fas fa-calendar-plus"></i> Joined</label><div class="ep-field-val"><asp:Label ID="lblInfoJoined" runat="server" Text="-" /></div></div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlAttendance" runat="server" Visible="false">
                <div class="ep-panel teal">
                    <h3><i class="fas fa-clock"></i> Recent Attendance (Last 30 Days)</h3>
                    <asp:GridView ID="gvAttendance" runat="server" AutoGenerateColumns="False" CssClass="ep-table" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="EventDate"  HeaderText="Date"      DataFormatString="{0:yyyy-MM-dd}" />
                            <asp:BoundField DataField="EventTime"  HeaderText="Time"      DataFormatString="{0:HH\:mm}" />
                            <asp:BoundField DataField="Direction"  HeaderText="Direction" />
                            <asp:BoundField DataField="ReaderName" HeaderText="Reader" />
                        </Columns>
                    </asp:GridView>
                    <div style="margin-top:10px;font-size:12px;color:#888;">Showing up to 50 most recent events.</div>
                </div>
            </asp:Panel>
        </div>
    </div>

    <script>
        function epPwdStrength(val) {
            var bar=document.getElementById('ep-pwd-bar'), hint=document.getElementById('ep-pwd-hint');
            if (!bar||!hint) return;
            var s=0;
            if (val.length>=8) s++;
            if (/[A-Z]/.test(val)) s++;
            if (/[0-9]/.test(val)) s++;
            if (/[^A-Za-z0-9]/.test(val)) s++;
            var l=['','Weak','Fair','Good','Strong'], c=['','#dc3545','#fd7e14','#ffc107','#28a745'], w=['0%','25%','50%','75%','100%'];
            bar.style.width=w[s]||'0%'; bar.style.backgroundColor=c[s]||'transparent'; hint.textContent=s>0?l[s]:'';
        }
    </script>
</asp:Content>
'@
[System.IO.File]::WriteAllText("$root\EmployeeProfile.aspx", $aspx, [System.Text.Encoding]::UTF8)

# ?? EmployeeProfile.aspx.cs ?????????????????????????????????????????????
$cs = @'
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TimeAttendance.WebForms
{
    public partial class EmployeeProfile : Page
    {
        private string ConnStr            { get { return Properties.Settings.Default.SQLCon; } }
        private string SessionUsername    { get { return Session["Username"]    != null ? Session["Username"].ToString()    : ""; } }
        private string SessionRole        { get { return Session["Role"]        != null ? Session["Role"].ToString()        : ""; } }
        private string SessionSiteId      { get { return Session["SiteId"]      != null ? Session["SiteId"].ToString()      : ""; } }
        private string SessionNameSurname { get { return Session["NameSurname"] != null ? Session["NameSurname"].ToString() : ""; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null) { Response.Redirect("~/Login.aspx"); return; }
            if (!IsPostBack) { PopulateSidebar(); LoadAccountDetails(); LoadEmployeeRecord(); LoadAttendanceStats(); LoadRecentAttendance(); }
        }

        private void PopulateSidebar()
        {
            string name = SessionNameSurname;
            lblFullName.Text        = System.Web.HttpUtility.HtmlEncode(name);
            lblRoleBadge.Text       = System.Web.HttpUtility.HtmlEncode(SessionRole);
            lblSiteBadge.Text       = System.Web.HttpUtility.HtmlEncode(SessionSiteId);
            lblUsernameSidebar.Text = System.Web.HttpUtility.HtmlEncode(SessionUsername);
            lblInitials.Text        = GetInitials(name);
        }

        private static string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "?";
            string[] parts = name.Trim().Split(new char[]{' '}, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1) return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpper();
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }

        private void LoadAccountDetails()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT NameSurname,Username,Email,Role,SiteId FROM Users WHERE Username=@Username", conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", SessionUsername);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                txtFullName.Text    = SafeStr(r, "NameSurname");
                                txtEmail.Text       = SafeStr(r, "Email");
                                txtUsername.Text    = SafeStr(r, "Username");
                                lblRoleDisplay.Text = SafeStr(r, "Role");
                                lblSiteDisplay.Text = SafeStr(r, "SiteId");
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { ShowMessage("error", "Could not load account details: " + ex.Message); }
        }

        private void LoadEmployeeRecord()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = @"SELECT e.EmployeeID, ISNULL(e.EmployeeCode,'') AS EmployeeCode,
                        ISNULL(e.Email,'') AS Email, ISNULL(e.PhoneNumber,'') AS PhoneNumber,
                        ISNULL(d.DepartmentName,'') AS DepartmentName,
                        ISNULL((SELECT TOP 1 s.ShiftName FROM EmployeeShifts es JOIN Shifts s ON s.ShiftID=es.ShiftID WHERE es.EmployeeID=e.EmployeeID AND es.IsActive=1 AND s.IsActive=1),'-') AS ShiftName,
                        ISNULL(e.PayType,'') AS PayType, e.IsActive, e.CreatedDate
                        FROM Employees e LEFT JOIN Departments d ON d.DepartmentID=e.DepartmentID
                        WHERE UPPER(e.NameSurname)=UPPER(@Name) AND e.SiteID=@SiteId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Name",   SessionNameSurname);
                        cmd.Parameters.AddWithValue("@SiteId", SessionSiteId);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                hfEmployeeID.Value = SafeStr(r, "EmployeeID");
                                string code    = SafeStr(r, "EmployeeCode");
                                string dept    = SafeStr(r, "DepartmentName");
                                string shift   = SafeStr(r, "ShiftName");
                                string payType = SafeStr(r, "PayType");
                                string mobile  = SafeStr(r, "PhoneNumber");
                                bool isActive  = r["IsActive"] != DBNull.Value && Convert.ToBoolean(r["IsActive"]);
                                string joined  = r["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(r["CreatedDate"]).ToString("yyyy-MM-dd") : "-";

                                lblEmpCode.Text    = string.IsNullOrEmpty(code)    ? "-" : code;
                                lblEmpDept.Text    = string.IsNullOrEmpty(dept)    ? "-" : dept;
                                lblEmpShift.Text   = string.IsNullOrEmpty(shift)   ? "-" : shift;
                                lblEmpPayType.Text = string.IsNullOrEmpty(payType) ? "-" : payType;
                                lblEmpStatus.Text  = isActive
                                    ? "<span class=\"ep-badge ep-badge-active\">Active</span>"
                                    : "<span class=\"ep-badge ep-badge-inactive\">Inactive</span>";
                                lblInfoCode.Text    = string.IsNullOrEmpty(code)    ? "-" : code;
                                lblInfoDept.Text    = string.IsNullOrEmpty(dept)    ? "-" : dept;
                                lblInfoShift.Text   = string.IsNullOrEmpty(shift)   ? "-" : shift;
                                lblInfoPayType.Text = string.IsNullOrEmpty(payType) ? "-" : payType;
                                lblInfoMobile.Text  = string.IsNullOrEmpty(mobile)  ? "-" : mobile;
                                lblInfoJoined.Text  = joined;
                                if (string.IsNullOrWhiteSpace(txtPhone.Text)) txtPhone.Text = mobile;
                                pnlEmployeeLink.Visible = true;
                                pnlEmployeeInfo.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("LoadEmployeeRecord: " + ex.Message); }
        }

        private void LoadAttendanceStats()
        {
            if (string.IsNullOrWhiteSpace(SessionNameSurname)) return;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(DISTINCT CAST(Timestamp AS DATE)) FROM ReaderEvents WHERE UPPER(PersonName)=UPPER(@Name) AND SiteId=@SiteId AND YEAR(Timestamp)=YEAR(GETDATE()) AND MONTH(Timestamp)=MONTH(GETDATE())", conn))
                    { cmd.Parameters.AddWithValue("@Name", SessionNameSurname); cmd.Parameters.AddWithValue("@SiteId", SessionSiteId); lblStatDaysThisMonth.Text = cmd.ExecuteScalar().ToString(); }
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM ReaderEvents WHERE UPPER(PersonName)=UPPER(@Name) AND SiteId=@SiteId", conn))
                    { cmd.Parameters.AddWithValue("@Name", SessionNameSurname); cmd.Parameters.AddWithValue("@SiteId", SessionSiteId); lblStatTotal.Text = cmd.ExecuteScalar().ToString(); }
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM ReaderEvents WHERE UPPER(PersonName)=UPPER(@Name) AND SiteId=@SiteId AND YEAR(Timestamp)=YEAR(GETDATE()) AND MONTH(Timestamp)=MONTH(GETDATE())", conn))
                    { cmd.Parameters.AddWithValue("@Name", SessionNameSurname); cmd.Parameters.AddWithValue("@SiteId", SessionSiteId); int evts = Convert.ToInt32(cmd.ExecuteScalar()); lblStatHours.Text = (evts / 2 * 8).ToString(); }
                    lblStatLate.Text = "-";
                }
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("LoadAttendanceStats: " + ex.Message); }
        }

        private void LoadRecentAttendance()
        {
            if (string.IsNullOrWhiteSpace(SessionNameSurname)) return;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = @"SELECT TOP 50 CAST(Timestamp AS DATE) AS EventDate, CAST(Timestamp AS TIME(0)) AS EventTime,
                        CASE WHEN Direction=0 THEN 'IN' WHEN Direction=1 THEN 'OUT' ELSE ISNULL(CAST(Direction AS VARCHAR),'-') END AS Direction,
                        ISNULL(ReaderId,'-') AS ReaderName
                        FROM ReaderEvents WHERE UPPER(PersonName)=UPPER(@Name) AND SiteId=@SiteId
                        AND Timestamp>=DATEADD(DAY,-30,GETDATE()) ORDER BY Timestamp DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Name",   SessionNameSurname);
                        cmd.Parameters.AddWithValue("@SiteId", SessionSiteId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        if (dt.Rows.Count > 0) { gvAttendance.DataSource = dt; gvAttendance.DataBind(); pnlAttendance.Visible = true; }
                    }
                }
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("LoadRecentAttendance: " + ex.Message); }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string newName  = txtFullName.Text.Trim();
            string newEmail = txtEmail.Text.Trim();
            string newPhone = txtPhone.Text.Trim();
            if (string.IsNullOrWhiteSpace(newName)) { ShowMessage("error", "Full name cannot be empty."); return; }
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE Users SET NameSurname=@Name,Email=@Email WHERE Username=@Username", conn))
                    { cmd.Parameters.AddWithValue("@Name", newName); cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(newEmail)?(object)DBNull.Value:newEmail); cmd.Parameters.AddWithValue("@Username", SessionUsername); conn.Open(); cmd.ExecuteNonQuery(); }
                    if (!string.IsNullOrEmpty(hfEmployeeID.Value))
                    {
                        using (SqlCommand cmd = new SqlCommand("UPDATE Employees SET Email=@Email,PhoneNumber=@Phone,ModifiedDate=GETDATE() WHERE EmployeeID=@EmpID", conn))
                        { cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(newEmail)?(object)DBNull.Value:newEmail); cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(newPhone)?(object)DBNull.Value:newPhone); cmd.Parameters.AddWithValue("@EmpID", hfEmployeeID.Value); cmd.ExecuteNonQuery(); }
                    }
                }
                Session["NameSurname"] = newName;
                PopulateSidebar();
                ShowMessage("success", "Profile updated successfully.");
            }
            catch (Exception ex) { ShowMessage("error", "Could not save profile: " + ex.Message); }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e) { LoadAccountDetails(); ShowMessage("info", "Changes discarded."); }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string current = txtCurrentPassword.Text;
            string newPwd  = txtNewPassword.Text;
            string confirm = txtConfirmPassword.Text;
            if (string.IsNullOrWhiteSpace(current)||string.IsNullOrWhiteSpace(newPwd)) { ShowMessage("error", "Please fill in all password fields."); return; }
            if (newPwd != confirm) { ShowMessage("error", "New password and confirmation do not match."); return; }
            if (newPwd.Length < 6) { ShowMessage("error", "New password must be at least 6 characters."); return; }
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Users WHERE Username=@Username AND PasswordHash=@OldPwd", conn))
                    { cmd.Parameters.AddWithValue("@Username", SessionUsername); cmd.Parameters.AddWithValue("@OldPwd", current); conn.Open(); if ((int)cmd.ExecuteScalar()==0) { ShowMessage("error", "Current password is incorrect."); return; } }
                    using (SqlCommand cmd = new SqlCommand("UPDATE Users SET PasswordHash=@NewPwd WHERE Username=@Username", conn))
                    { cmd.Parameters.AddWithValue("@NewPwd", newPwd); cmd.Parameters.AddWithValue("@Username", SessionUsername); cmd.ExecuteNonQuery(); }
                }
                txtCurrentPassword.Text = txtNewPassword.Text = txtConfirmPassword.Text = "";
                ShowMessage("success", "Password changed successfully.");
            }
            catch (Exception ex) { ShowMessage("error", "Could not change password: " + ex.Message); }
        }

        private static string SafeStr(SqlDataReader r, string col)
        { try { return r[col]==DBNull.Value ? "" : r[col].ToString(); } catch { return ""; } }

        private void ShowMessage(string type, string text)
        {
            string css  = type=="success" ? "ep-alert ep-alert-success" : type=="error" ? "ep-alert ep-alert-error" : "ep-alert ep-alert-info";
            string icon = type=="success" ? "fas fa-check-circle"       : type=="error" ? "fas fa-exclamation-circle" : "fas fa-info-circle";
            lblMessage.Text    = string.Format("<div class=\"{0}\"><i class=\"{1}\"></i> {2}</div>", css, icon, System.Web.HttpUtility.HtmlEncode(text));
            lblMessage.Visible = true;
        }
    }
}
'@
[System.IO.File]::WriteAllText("$root\EmployeeProfile.aspx.cs", $cs, [System.Text.Encoding]::UTF8)

# ?? EmployeeProfile.aspx.designer.cs ????????????????????????????????????
$designer = @'
namespace TimeAttendance.WebForms
{
    public partial class EmployeeProfile
    {
        protected global::System.Web.UI.WebControls.HiddenField hfEmployeeID;
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.Label lblInitials;
        protected global::System.Web.UI.WebControls.Label lblFullName;
        protected global::System.Web.UI.WebControls.Label lblRoleBadge;
        protected global::System.Web.UI.WebControls.Label lblSiteBadge;
        protected global::System.Web.UI.WebControls.Label lblUsernameSidebar;
        protected global::System.Web.UI.WebControls.Panel pnlEmployeeLink;
        protected global::System.Web.UI.WebControls.Label lblEmpCode;
        protected global::System.Web.UI.WebControls.Label lblEmpDept;
        protected global::System.Web.UI.WebControls.Label lblEmpShift;
        protected global::System.Web.UI.WebControls.Label lblEmpPayType;
        protected global::System.Web.UI.WebControls.Label lblEmpStatus;
        protected global::System.Web.UI.WebControls.Label lblStatDaysThisMonth;
        protected global::System.Web.UI.WebControls.Label lblStatLate;
        protected global::System.Web.UI.WebControls.Label lblStatHours;
        protected global::System.Web.UI.WebControls.Label lblStatTotal;
        protected global::System.Web.UI.WebControls.TextBox txtFullName;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.TextBox txtUsername;
        protected global::System.Web.UI.WebControls.Label   lblRoleDisplay;
        protected global::System.Web.UI.WebControls.Label   lblSiteDisplay;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.Button  btnSaveProfile;
        protected global::System.Web.UI.WebControls.Button  btnCancelEdit;
        protected global::System.Web.UI.WebControls.TextBox txtCurrentPassword;
        protected global::System.Web.UI.WebControls.TextBox txtNewPassword;
        protected global::System.Web.UI.WebControls.TextBox txtConfirmPassword;
        protected global::System.Web.UI.WebControls.Button  btnChangePassword;
        protected global::System.Web.UI.WebControls.Panel   pnlEmployeeInfo;
        protected global::System.Web.UI.WebControls.Label   lblInfoCode;
        protected global::System.Web.UI.WebControls.Label   lblInfoDept;
        protected global::System.Web.UI.WebControls.Label   lblInfoShift;
        protected global::System.Web.UI.WebControls.Label   lblInfoPayType;
        protected global::System.Web.UI.WebControls.Label   lblInfoMobile;
        protected global::System.Web.UI.WebControls.Label   lblInfoJoined;
        protected global::System.Web.UI.WebControls.Panel   pnlAttendance;
        protected global::System.Web.UI.WebControls.GridView gvAttendance;
    }
}
'@
[System.IO.File]::WriteAllText("$root\EmployeeProfile.aspx.designer.cs", $designer, [System.Text.Encoding]::UTF8)

Write-Host "All three EmployeeProfile files written to project root."

