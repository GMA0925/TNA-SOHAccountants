<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyClockEvents.aspx.cs" Inherits="TimeAttendance.WebForms.MyClockEvents" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Clock Events</title>
    <style>
        .container {
            width: 600px;
            margin: auto;
            padding-top: 50px;
            font-family: Arial;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>My Clock Events</h2>
            <asp:GridView ID="gvClockEvents" runat="server" AutoGenerateColumns="true" />
        </div>
    </form>
</body>
</html>
