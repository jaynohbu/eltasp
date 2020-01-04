<%@ Page Language="C#" AutoEventWireup="true" CodeFile="driver_hawb_list.aspx.cs"
    Inherits="ASPX_Domestic_driver_hawb_list" %>

<%@ Register TagPrefix="mobile" Namespace="System.Web.UI.MobileControls" Assembly="System.Web.Mobile" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
    <mobile:Form ID="Form1" Runat="server" BackColor="#ccffff">
        <b>Driver's HAWB List</b><br /><br />
        <mobile:List ID="HAWBList" Runat="server" OnItemCommand="HAWBList_ItemCommand">
        </mobile:List>
    </mobile:Form>
</body>
</html>
