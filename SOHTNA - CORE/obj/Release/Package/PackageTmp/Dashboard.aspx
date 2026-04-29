<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TimeAttendance.WebForms.Dashboard" %>
<%@ Register Src="~/Navigation.ascx" TagPrefix="uc" TagName="Navigation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #0078D4;
            color: white;
            padding: 20px;
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
            padding: 15px;
            max-width: 1200px;
            margin: auto;
        }

        .panel {
            background-color: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .panel h3 {
            margin-top: 0;
            color: #333;
        }

        .admin-panel {
            border-left: 5px solid #0078D4;
        }

        .user-panel {
            border-left: 5px solid #28a745;
        }

        .nav-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .nav-btn {
            background-color: #0078D4;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            flex: 1 1 auto;
            text-align: center;
        }

        .nav-btn:hover {
            background-color: #005a9e;
        }

        .chart-scroll {
            overflow-x: auto;
            padding-bottom: 10px;
        }

        .chart-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-between;
        }

        .chart-panel {
            flex: 1 1 45%;
            min-width: 320px;
            max-width: 100%;
        }

        canvas {
            width: 100% !important;
            max-height: 350px;
        }

        @media (max-width: 768px) {
            .chart-grid {
                flex-direction: column;
            }

            .chart-panel {
                flex: 1 1 100%;
                margin-bottom: 20px;
            }

            .header {
                font-size: 18px;
                padding: 15px;
            }

            .logout-link {
                font-size: 12px;
                top: 10px;
                right: 10px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            &nbsp;<span>Time & Attendance Dashboard</span>
            <div class="logout-section">
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </asp:LinkButton>
                <asp:Label ID="lblVersion" runat="server" CssClass="version-label" />
            </div>
        </div>

        <div class="container">
            <asp:Label ID="lblWelcome" runat="server" Font-Bold="true" Font-Size="Large" />

            <!-- Unified Navigation -->
            <uc:Navigation runat="server" ID="navControl" />

            <asp:Panel ID="pnlAdmin" runat="server" CssClass="panel admin-panel" Visible="false">
                <h3>Admin Panel</h3>
                <table style="width:100%; border-collapse:collapse;">
                    <tr><td><strong>SQL Connection:</strong></td><td><asp:Label ID="lblSqlStatus" runat="server" /></td></tr>
                    <tr><td><strong>Last Sync:</strong></td><td><asp:Label ID="lblLastSync" runat="server" /></td></tr>
                    <tr><td><strong>Active Users:</strong></td><td><asp:Label ID="lblActiveUsers" runat="server" /></td></tr>
                    <tr><td><strong>Pending Transactions:</strong></td><td><asp:Label ID="lblPendingTx" runat="server" /></td></tr>
                    <tr><td><strong>Cloud Buffer:</strong></td><td><asp:Label ID="lblCloudBuffer" runat="server" /></td></tr>
                    <tr><td><strong>Config Health:</strong></td><td><asp:Label ID="lblConfigStatus" runat="server" /></td></tr>
                </table>

                <asp:HiddenField ID="hfPendingTxData" runat="server" />
                <asp:HiddenField ID="hfSyncStatusData" runat="server" />
                <asp:HiddenField ID="hfHourlyData" runat="server" />
                <asp:HiddenField ID="hfTopUsersData" runat="server" />

                <div class="chart-scroll">
                    <div class="chart-grid">
                        <asp:Panel ID="ReaderEvents" runat="server" CssClass="panel chart-panel">
                            <h3>Transactions by Reader IP</h3>
                            <canvas id="canvasPendingTx"></canvas>
                        </asp:Panel>

                        <asp:Panel ID="ChartSyncStatus" runat="server" CssClass="panel chart-panel">
                            <h3>T&amp;A Activity Overview</h3>
                            <canvas id="canvasSyncStatus"></canvas>
                        </asp:Panel>

                        <asp:Panel ID="ChartHourlyActivity" runat="server" CssClass="panel chart-panel">
                            <h3>Hourly Activity (Last 24h)</h3>
                            <canvas id="canvasHourly"></canvas>
                        </asp:Panel>

                        <asp:Panel ID="ChartTopUsers" runat="server" CssClass="panel chart-panel">
                            <h3>Top Active Users</h3>
                            <canvas id="canvasTopUsers"></canvas>
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlUser" runat="server" CssClass="panel user-panel" Visible="false">
                <h3>User Panel</h3>
                <p>View your clock events, update profile, and submit requests.</p>
            </asp:Panel>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            Chart.register(ChartDataLabels);
            var colors = ['#0078D4','#28a745','#ffc107','#dc3545','#6f42c1','#17a2b8','#fd7e14','#20c997','#e83e8c','#6610f2'];
            var dlBar = { color:'#333', anchor:'end', align:'end', font:{weight:'bold',size:12}, formatter:function(v){return v>0?v:'';} };
            var dlPie = { color:'#fff', font:{weight:'bold',size:13}, formatter:function(v,ctx){var total=ctx.chart.data.datasets[0].data.reduce(function(a,b){return a+b;},0);return total>0?Math.round(v/total*100)+'%':'';} };
            var dlLine = { color:'#0078D4', anchor:'end', align:'top', font:{weight:'bold',size:11}, formatter:function(v){return v>0?v:'';} };
            function tryParse(id) { try { var el = document.getElementById(id); return el && el.value ? JSON.parse(el.value) : null; } catch(e) { return null; } }

            var ptx = tryParse('<%= hfPendingTxData.ClientID %>');
            if (ptx) { new Chart(document.getElementById('canvasPendingTx'), { type:'bar', data:{ labels:ptx.labels, datasets:[{label:'Transactions',data:ptx.values,backgroundColor:colors}] }, options:{responsive:true, plugins:{datalabels:dlBar}} }); }

            var ss = tryParse('<%= hfSyncStatusData.ClientID %>');
            if (ss) { new Chart(document.getElementById('canvasSyncStatus'), { type:'pie', data:{ labels:ss.labels, datasets:[{data:ss.values,backgroundColor:colors}] }, options:{responsive:true, plugins:{datalabels:dlPie}} }); }

            var hr = tryParse('<%= hfHourlyData.ClientID %>');
            if (hr) { new Chart(document.getElementById('canvasHourly'), { type:'line', data:{ labels:hr.labels, datasets:[{label:'Events',data:hr.values,borderColor:'#0078D4',fill:false}] }, options:{responsive:true, plugins:{datalabels:dlLine}} }); }

            var tu = tryParse('<%= hfTopUsersData.ClientID %>');
            if (tu) { new Chart(document.getElementById('canvasTopUsers'), { type:'bar', data:{ labels:tu.labels, datasets:[{label:'Events',data:tu.values,backgroundColor:colors}] }, options:{responsive:true,indexAxis:'y', plugins:{datalabels:dlBar}} }); }
        });
    </script>
</