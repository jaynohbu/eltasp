<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SBItemSelect.aspx.cs" Inherits="ASPX_Misc_SBItemSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Schedule B</title>
    <base target="_self" />
    <link href="../../ASP/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function SelectNClose(){
            var sbArray = new Array();
            
            sbArray[0] = document.getElementById("hSBCode").value;
            sbArray[1] = document.getElementById("hUnit1").value;
            sbArray[2] = document.getElementById("hUnit2").value;
            sbArray[3] = document.getElementById("hDesc").value;
            sbArray[4] = document.getElementById("hExportCode").value;
            sbArray[5] = document.getElementById("hLicenseType").value;
            sbArray[6] = document.getElementById("hECCN").value;
            
            window.returnValue = sbArray;
            window.close();
        }
    </script>
</head>
<body style="margin-top: 10px; background-color:#eeeeee">
    <form id="form1" runat="server">
        <asp:Label ID="txtError" runat="server" Visible="false" />
        <asp:HiddenField ID="hOrgID" runat="server" />
        <asp:HiddenField ID="hSBCode" runat="server" />
        <asp:HiddenField ID="hUnit1" runat="server" />
        <asp:HiddenField ID="hUnit2" runat="server" />
        <asp:HiddenField ID="hDesc" runat="server" />
        <asp:HiddenField ID="hExportCode" runat="server" />
        <asp:HiddenField ID="hLicenseType" runat="server" />
        <asp:HiddenField ID="hECCN" runat="server" />
        <center>
        <div class="bodyheader">
            <p>Select schedule B item from below list.</p>
            
            <asp:ListBox ID="ListBox1" runat="server" CssClass="bodycopy" style="width:300px;height:200px;" 
                AutoPostBack="true" OnSelectedIndexChanged="ListBox1_SelectedIndexChanged" >
            </asp:ListBox>
            <br />
            <input type="image" src="../../ASP/Images/button_done.gif" onclick="SelectNClose();" />
        </div>
        </center>
    </form>
</body>
</html>
