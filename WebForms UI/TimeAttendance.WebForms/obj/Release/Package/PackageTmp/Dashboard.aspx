<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TimeAttendance.WebForms.Dashboard" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

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

        .logout-link {
            position: absolute;
            right: 20px;
            top: 20px;
            color: white;
            text-decoration: underline;
            font-size: 14px;
        }

        .logout-link:hover {
            text-decoration: none;
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

        asp\:Chart {
            width: 100% !important;
            height: auto !important;
            display: block;
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
            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-link">Logout</asp:LinkButton>
        </div>

        <div class="container">
            <asp:Label ID="lblWelcome" runat="server" Font-Bold="true" Font-Size="Large" />

            <div class="nav-buttons">
                <asp:LinkButton ID="btnDashboard" runat="server" CssClass="nav-btn" OnClick="btnDashboard_Click">
                    <i class="fas fa-chart-line"></i> Dashboard
                </asp:LinkButton>
                <asp:LinkButton ID="btnReports" runat="server" CssClass="nav-btn" OnClick="btnReports_Click">
                    <i class="fas fa-file-alt"></i> Reports
                </asp:LinkButton>
                <asp:LinkButton ID="btnSyncLog" runat="server" CssClass="nav-btn" OnClick="btnSyncLog_Click">
                    <i class="fas fa-sync"></i> Sync Log
                </asp:LinkButton>
                <asp:LinkButton ID="btnUsers" runat="server" CssClass="nav-btn" OnClick="btnUsers_Click">
                    <i class="fas fa-users"></i> User Management
                </asp:LinkButton>
                <asp:LinkButton ID="btnConfig" runat="server" CssClass="nav-btn" OnClick="btnConfig_Click">
                    <i class="fas fa-tools"></i> Config Tools
                </asp:LinkButton>
                <asp:LinkButton ID="btnEnrollment" runat="server" CssClass="nav-btn" OnClick="btnEnrollment_Click" Visible="true">
                    <i class="fas fa-id-card-alt"></i> Employee View
                </asp:LinkButton>
            </div>

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

                <div class="chart-scroll">
                    <div class="chart-grid">
                        <asp:Panel ID="ReaderEvents" runat="server" CssClass="panel chart-panel">
                            <h3>Transactions by Reader IP</h3>
                            <asp:Chart ID="chartPendingTx" runat="server" Width="450px">
                                <ChartAreas><asp:ChartArea Name="MainArea" /></ChartAreas>
                                <Legends><asp:Legend Name="Legend1" /></Legends>
                            </asp:Chart>
                        </asp:Panel>

                        <asp:Panel ID="ChartSyncStatus" runat="server" CssClass="panel chart-panel">
                            <h3>T&amp;A Activity Overview</h3>
                            <asp:Chart ID="chart1" runat="server" Width="450px">
                                <ChartAreas><asp:ChartArea Name="MainArea" /></ChartAreas>
                                <Legends><asp:Legend Name="Legend1" /></Legends>
                            </asp:Chart>
                        </asp:Panel>

                        <asp:Panel ID="ChartHourlyActivity" runat="server" CssClass="panel chart-panel">
                            <h3>Hourly Activity (Last 24h)</h3>
                            <asp:Chart ID="chart2" runat="server" Width="450px">
                                <ChartAreas><asp:ChartArea Name="MainArea" /></ChartAreas>
                                <Legends><asp:Legend Name="Legend1" /></Legends>
                            </asp:Chart>
                        </asp:Panel>

                        <asp:Panel ID="ChartTopUsers" runat="server" CssClass="panel chart-panel">
                            <h3>Top Active Users</h3>
                            <asp:Chart ID="chart3" runat="server" Width="450px">
                                <ChartAreas><asp:ChartArea Name="MainArea" /></ChartAreas>
                                <Legends><asp:Legend Name="Legend1" /></Legends>
                            </asp:Chart>
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
</