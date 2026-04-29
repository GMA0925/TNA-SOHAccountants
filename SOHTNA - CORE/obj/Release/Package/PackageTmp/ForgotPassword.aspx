<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TimeAttendance.WebForms.ForgotPassword" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 400px;
            margin: 60px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #0078D4;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .btn {
            background-color: #0078D4;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        .btn:hover {
            background-color: #005a9e;
        }

        .status-label {
            display: block;
            margin-top: 10px;
            font-size: 13px;
            color: red;
            text-align: center;
        }

        .section-divider {
            margin: 30px 0 10px;
            text-align: center;
            font-size: 14px;
            color: #666;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2><i class="fas fa-key"></i> Forgot Password</h2>

            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Enter your email" />
            </div>

            <asp:Button ID="btnReset" runat="server" Text="Send Reset Link" CssClass="btn" OnClick="btnReset_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="status-label" />

            <div class="section-divider">or reset directly below</div>

            <div class="form-group">
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="New password" />
            </div>

            <asp:Button ID="btnUpdate" runat="server" Text="Update Password" CssClass="btn" OnClick="btnUpdate_Click" />
            <asp:Label ID="lblStatus" runat="server" CssClass="status-label" />
            <asp:Button ID="btnBack" runat="server" Text="← Back to Login" CssClass="btn btn-secondary" OnClick="btnBack_Click" />
        </div>
    </form>
</body>
</html>
