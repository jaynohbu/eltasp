<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExportShipout.aspx.cs" Inherits="ASPX_WMS_ExportShipout" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Transfer to Air/Ocean Export</title>
    <meta http-equiv="Content-Type" content="text/html; UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/jscript">
        function TransferData()
        {
            var oForm = document.getElementById("form1");
            oForm.action = "/IFF_MAIN/ASP/air_export/new_edit_hawb.asp";
            oForm.target = 
            oForm.method = "post";
            // oForm.submit();
            
            window.opener.doSubmit()

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <center>
            <table width="95%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" class="pageheader">
                        Data Transfer to Air/Ocean Export
                    </td>
                    <td align="right">
                    </td>
                </tr>
            </table>
            <table cellpadding="4" cellspacing="0" border="0" class="bodyheader" style="text-align: left;
                border: solid 1px #9e816e" width="95%">
                <tr style="background-color: #f4e9e0">
                    <td>
                        Ship Out No.</td>
                    <td>
                        <asp:TextBox ID="txtSONum" runat="server" CssClass="d_shorttextfield" ReadOnly="true" /></td>
                </tr>
                <tr>
                    <td>
                        Shipper</td>
                    <td>
                        <asp:TextBox ID="txtShipper" runat="server" CssClass="d_shorttextfield" Width="150px" ReadOnly="true" /></td>
                </tr>
                <tr style="background-color: #f4e9e0">
                    <td>
                        Consignee</td>
                    <td>
                        <asp:TextBox ID="txtConsignee" runat="server" CssClass="d_shorttextfield" Width="150px" ReadOnly="true" /></td>
                </tr>
                <tr>
                    <td>
                        Item Desc</td>
                    <td>
                        <asp:TextBox ID="txtItemDesc" runat="server" TextMode="MultiLine" Rows="8" CssClass="shorttextfield"
                            Width="250px" /></td>
                </tr>
                <tr style="background-color: #f4e9e0">
                    <td>
                        Handling Infomation</td>
                    <td>
                        <asp:TextBox ID="txtHandling" runat="server" TextMode="MultiLine" Rows="2" CssClass="shorttextfield"
                            Width="300px" /></td>
                </tr>
                <tr>
                    <td>
                        Item Quantity</td>
                    <td>
                        <asp:TextBox ID="txtItemQty" runat="server" CssClass="shorttextfield" Width="50px" />
                        <asp:DropDownList ID="lstItemQtyUnit" runat="server" CssClass="smallselect" align="absbottom">
                            <asp:ListItem Text="PCS" Value="PCS" />
                            <asp:ListItem Text="BOX" Value="BOX" />
                            <asp:ListItem Text="PLT" Value="PLT" />
                            <asp:ListItem Text="CTN" Value="CTN" />
                            <asp:ListItem Text="SET" Value="SET" />
                            <asp:ListItem Text="CRT" Value="CRT" />
                            <asp:ListItem Text="SKD" Value="SKD" />
                            <asp:ListItem Text="UNIT" Value="UNIT" />
                            <asp:ListItem Text="PKGS" Value="PKGS" />
                            <asp:ListItem Text="CNTR" Value="CNTR" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr style="background-color: #f4e9e0">
                    <td>
                        Item Weight</td>
                    <td>
                        <asp:TextBox ID="txtItemWeight" runat="server" CssClass="shorttextfield" Width="60px" />
                        <asp:DropDownList ID="lstItemWeightScale" runat="server" CssClass="smallselect" align="absbottom">
                            <asp:ListItem Text="KG" Value="K" />
                            <asp:ListItem Text="LB" Value="L" />
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <br />
            <table width="95%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="width:35%"></td>
                    <td style="width:15%">
                        <a href="javascript:;" onclick="TransferData()"><img src="/IFF_MAIN/ASP/Images/button_next_bold.gif" alt="" style="border:none 0px" /></a>
                    </td>
                    <td style="width:15%">
                        <a href="javascript:window.close();"><img src="/IFF_MAIN/ASP/Images/button_closebooking.gif" alt="" style="border:none 0px" /></a>
                    </td>
                    <td style="width:35%"></td>
                </tr>
            </table>
        </center>
    </form>
</body>
</html>
