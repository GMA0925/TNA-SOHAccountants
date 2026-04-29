<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClockAdmin.aspx.cs" Inherits="TimeAttendance.WebForms.ClockAdmin" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Clock Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; }
        .header { background-color: #0078D4; color: white; padding: 20px; text-align: center; position: relative; }
        .container { padding: 15px; max-width: 1200px; margin: auto; }
        .panel { background-color: #ffffff; border-radius: 6px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); padding: 20px; margin-bottom: 20px; }
        .panel h3 { margin-top: 0; color: #333; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
        .btn { background-color: #0078D4; color: white; border: none; padding: 8px 16px; font-size: 14px; border-radius: 4px; cursor: pointer; }
        .btn:hover { background-color: #005a9e; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .grid-view th, .grid-view td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .grid-view th { background-color: #f8f9fa; }
        .alert { padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfActivePanel" runat="server" Value="" />
        <div class="header">
            <h2>Time &amp; Attendance - Clock Administration</h2>
        </div>

        <div class="container">
            <uc:Navigation runat="server" ID="navControl" />

            <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

            <div id="panelFind" class="panel">
                <h3><i class="fas fa-search"></i> Find Employee Clocks</h3>
                <div class="form-group" style="display:flex; gap:10px; align-items:flex-end;">
                    <div style="flex:1;">
                        <label>Site ID:</label>
                        <asp:DropDownList ID="ddlSiteID" runat="server" CssClass="form-control" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlSiteID_SelectedIndexChanged" />
                    </div>
                    <div style="flex:1;">
                        <label>Employee:</label>
                        <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlEmployee_SelectedIndexChanged">
                            <asp:ListItem Text="-- Select Site First --" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div>
                        <asp:Button ID="btnSearch" runat="server" Text="Refresh" CssClass="btn" OnClick="btnSearch_Click" />
                    </div>
                </div>

                <asp:GridView ID="gvIncomplete" runat="server" CssClass="grid-view" AutoGenerateColumns="False" OnRowCommand="gvIncomplete_RowCommand" DataKeyNames="Id">
                    <Columns>
                        <asp:BoundField DataField="Id"            HeaderText="Id"          Visible="false" />
                        <asp:BoundField DataField="EmployeeID"    HeaderText="Empl ID" />
                        <asp:BoundField DataField="Name"          HeaderText="Name" />
                        <asp:BoundField DataField="SiteID"        HeaderText="Site" />
                        <asp:BoundField DataField="WorkDate"      HeaderText="Work Date"    DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="ClockInTime"   HeaderText="Clocked In"   DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:BoundField DataField="MinutesInside" HeaderText="Mins Inside" />
                        <asp:TemplateField HeaderText="Clock Out Time">
                            <ItemTemplate>
                                <asp:TextBox ID="txtClockOut" runat="server" CssClass="form-control" TextMode="DateTimeLocal"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnComplete" runat="server" Text="Save Clock Out" CssClass="btn" CommandName="CompleteEntry" CommandArgument='<%# Container.DataItemIndex %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="padding:10px; color:#666;">No &quot;Still Inside&quot; entries found for this employee in the last 30 days.</p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <div id="panelManual" class="panel">
                <h3><i class="fas fa-clock"></i> Manual Scan Entry</h3>
                <p style="color:#555; margin-bottom:12px; font-size:13px;">
                    Select a site and employee, enter a <strong>Check In</strong> time, a <strong>Check Out</strong> time, or both, then click
                    <strong>Save Manual Scan</strong>. At least one time must be provided.
                </p>
                <div style="display:flex; gap:15px; flex-wrap:wrap;">
                    <div class="form-group" style="flex:1; min-width:200px;">
                        <label>Site:</label>
                        <asp:DropDownList ID="ddlManualSite" runat="server" CssClass="form-control" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlManualSite_SelectedIndexChanged" />
                    </div>
                    <div class="form-group" style="flex:1; min-width:200px;">
                        <label>Employee:</label>
                        <asp:DropDownList ID="ddlManualEmployee" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Select Site First --" Value=""></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="flex:1; min-width:200px;">
                        <label>Check In Time:</label>
                        <asp:TextBox ID="txtCheckInTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal"></asp:TextBox>
                    </div>
                    <div class="form-group" style="flex:1; min-width:200px;">
                        <label>Check Out Time:</label>
                        <asp:TextBox ID="txtCheckOutTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal"></asp:TextBox>
                    </div>
                    <div class="form-group" style="flex:1; min-width:200px;">
                        <label>Reason (optional):</label>
                        <asp:TextBox ID="txtReason" runat="server" CssClass="form-control" placeholder="e.g. forgot to scan"></asp:TextBox>
                    </div>
                </div>
                <asp:Button ID="btnManualEntry" runat="server" Text="Save Manual Scan" CssClass="btn" OnClick="btnManualEntry_Click" />
            </div>
            
            <div class="panel">
                <h3><i class="fas fa-info-circle"></i> How It Works</h3>
                <p>The <strong>Still Inside</strong> grid shows employees who have a <code>checkIn</code> event on a given date with no matching <code>checkOut</code> on the same date.</p>
                <ul style="color:#555; margin:0; padding-left:20px;">
                    <li>Click <strong>Save Clock Out</strong> on a grid row to insert the missing <code>checkOut</code> at the time you specify.</li>
                    <li>Use <strong>Manual Scan Entry</strong> above to insert a <code>checkIn</code>, a <code>checkOut</code>, or both at once for the selected employee.</li>
                    <li>If both times are provided, the check-out must be after the check-in.</li>
                </ul>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function setActivePanel(panelId) {
            var hf = document.getElementById('<%= hfActivePanel.ClientID %>');
            if (hf) hf.value = panelId;
        }

        function scrollToPanel(panelId) {
            if (!panelId) return;
            var el = document.getElementById(panelId);
            if (el) {
                el.scrollIntoView({ behavior: 'smooth', block: 'start' });
                el.style.outline = '2px solid #0078D4';
                setTimeout(function () { el.style.outline = ''; }, 1500);
            }
        }

        (function () {
            var hf = document.getElementById('<%= hfActivePanel.ClientID %>');
            if (hf && hf.value) {
                scrollToPanel(hf.value);
            }
        })();

        // ?? Manual Scan Entry: progressive focus ????????????????????????????
        // When the page loads (or returns from a postback), set focus to the
        // first incomplete control in the panel so the admin can tab straight
        // through without reaching for the mouse.
        (function () {
            var site     = document.getElementById('<%= ddlManualSite.ClientID %>');
            var employee = document.getElementById('<%= ddlManualEmployee.ClientID %>');
            var checkIn  = document.getElementById('<%= txtCheckInTime.ClientID %>');
            var checkOut = document.getElementById('<%= txtCheckOutTime.ClientID %>');
            var reason   = document.getElementById('<%= txtReason.ClientID %>');

            if (!site) return;

            // After site changes to a real value, move focus to employee
            site.addEventListener('change', function () {
                if (site.value && employee) {
                    setTimeout(function () { employee.focus(); }, 50);
                }
            });

            // After employee changes to a real value, move focus to Check In time
            employee.addEventListener('change', function () {
                if (employee.value && checkIn) {
                    setTimeout(function () { checkIn.focus(); }, 50);
                }
            });

            // After Check In time is filled, Tab naturally moves to Check Out.
            // After Check Out time is filled, Tab naturally moves to Reason.
            // Nothing extra needed — browser tab order handles it from here.

            // Set initial focus: first control that still needs input.
            function focusFirst() {
                if (!site.value)             { site.focus();     return; }
                if (!employee.value)         { employee.focus(); return; }
                if (!checkIn.value)          { checkIn.focus();  return; }
                if (!checkOut.value)         { checkOut.focus(); return; }
                reason.focus();
            }

            // Only auto-focus when the manual panel is the active one
            var hf = document.getElementById('<%= hfActivePanel.ClientID %>');
            if (hf && hf.value === 'panelManual') {
                setTimeout(focusFirst, 300); // slight delay so scroll finishes first
            }
        })();
    </script>
    </body>
    </html>
