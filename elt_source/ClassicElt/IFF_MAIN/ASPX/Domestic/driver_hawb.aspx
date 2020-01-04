<%@ Page Language="C#" AutoEventWireup="true" CodeFile="driver_hawb.aspx.cs" Inherits="ASPX_Domestic_driver_hawb" %>
<%@ Register TagPrefix="mobile" Namespace="System.Web.UI.MobileControls" Assembly="System.Web.Mobile" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<body>
    <mobile:Form id="Form1" runat="server" BackColor="#ccffff">
        <b>Driver Login</b>
        <br />
        <mobile:Panel ID="Panel1" Runat="server">
            <mobile:Label ID="Label1" Runat="server">Account No.</mobile:Label>
            <mobile:TextBox ID="txtLoginAcct" Runat="server"></mobile:TextBox>
            <mobile:Label ID="Label2" Runat="server">Login ID</mobile:Label>
            <mobile:TextBox ID="txtLoginID" Runat="server"></mobile:TextBox>
            <mobile:Label ID="Label3" Runat="server">Login Password</mobile:Label>
            <mobile:TextBox ID="txtLoginPass" Runat="server"></mobile:TextBox>
            <mobile:Command ID="Command1" Runat="server" OnClick="Command1_Click">Login</mobile:Command>
        </mobile:Panel>
    </mobile:Form>
</body>
</html>
