<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestDotMatrix.aspx.cs" Inherits="ASPX_Misc_TestDotMatrix" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Printer Name: 
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox><br />
        Emulation Mode:
        <asp:DropDownList ID="DropDownList1" runat="server">
            <asp:ListItem Text="Epson-ESC P" Value="Epson-ESC P"></asp:ListItem>
            <asp:ListItem Text="HP-PCL3" Value="HP-PCL3"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />
        
    </form>
</body>
</html>
