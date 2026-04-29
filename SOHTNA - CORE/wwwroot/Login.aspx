<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TimeAttendance.WebForms.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Secure Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .login-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-box {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .logo {
            margin-bottom: 20px;
        }

        .logo img {
            max-width: 120px;
        }

        .brand-name {
            font-size: 24px;
            font-weight: bold;
            color: #0078D4;
            margin-bottom: 30px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .btn-login {
            background-color: #0078D4;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-login:hover {
            background-color: #005fa3;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
        }

        .forgot-link {
            display: block;
            margin-top: 10px;
            font-size: 13px;
            color: #0078D4;
            text-decoration: none;
        }

        .forgot-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-box">
                <div class="logo">
                    <img src="images/logo.png" alt="Logo" />
                </div>
                <div class="brand-name">Time &amp; Attendance Portal</div>

                <asp:Label ID="lblMessage" runat="server" CssClass="error-message" />
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" style="text-align:center;" placeholder="Username" />
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" style="text-align:center;" placeholder="Password" />
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
                <a href="ForgotPassword.aspx" class="forgot-link">
        <i class="fas fa-key"></i> Forgot your password?
    </a>
            </div>
        </div>
    </form>
</body>
</html>
