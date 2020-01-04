<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Domestic_search.aspx.cs"
    Inherits="ASPX_DOMESTIC_DOMESTIC_SEARCH" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Domestic Search</title>
    <style type="text/css">
    <!--
	    body {
		    margin-left: 0px;
		    margin-top: 0px;
		    margin-right: 0px;
		    margin-bottom: 0px;
	    }
	    .style2 {color: #cc6600}
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
	    .style15 {
		    color: #C6603E
	    }
	    
	    .FromCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
        
        .ToCalendar{
            position:absolute; 
            top:0px; 
            left:20px;
            background-color:#ffffff;
            z-index:2;
        }
    -->
    </style>
    <script type="text/javascript" src="/ASP/include/simpletab.js"></script>
    <script type="text/javascript" src="/IFF_MAIN/ASPX/jScripts/WebDateSet1.js"></script>
    <script type="text/javascript" src="/IFF_MAIN/ASPX/jScripts/ig_dropCalendar.js"></script>
    <script type="text/javascript" src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js"></script>
    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="/ASP/include/JPED.js"></script>
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css">
    <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
    <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"
        type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
    <script type="text/javascript">
        window.onload = function () {
            loadValues();
        }
       
    </script>
</head>
<body link="336699" vlink="336699" topmargin="0" onload="self.focus(); ">
    <form runat="server" id="form1">
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                DOMESTIC SEARCH
            </td>
            <td width="50%" align="right" valign="middle">
                &nbsp;
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr bgcolor="#edd3cf">
                        <td align="center" valign="middle" bgcolor="#eec983" class="bodyheader" style="height: 8px">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="9" bgcolor="#997132" style="height: 1px">
                        </td>
                    </tr>
                    <tr align="center">
                        <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 34px 34px 24px">
                            <table border="0" cellpadding="0" cellspacing="0" bordercolor="#997132" bgcolor="#FFFFFF"
                                class="border1px" style="padding-left: 10px; width: 57%;" id="TABLE1" language="javascript">
                                <tr class="bodyheader">
                                    <td align="left" bgcolor="#f3d9a8" style="height: 18px; width: 208px;">
                                        <span class="style15">List Results By</span>
                                    </td>
                                    <td align="left" bgcolor="#f3d9a8" style="height: 18px; width: 184px;">
                                        Period
                                    </td>
                                    <td align="left" bgcolor="#f3d9a8" style="height: 18px; width: 573px;">
                                        <table>
                                            <tr class="bodyheader">
                                                <td width="10%" align="left" valign="middle" bgcolor="#f3d9a8" style="height: 20px">
                                                    Start Date
                                                </td>
                                                <td align="left" valign="middle" bgcolor="#f3d9a8" style="height: 20px; width: 11%;">
                                                    End Date
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="height: 15px; width: 208px;">
                                        <asp:DropDownList CssClass="bodycopy" Width="182px" runat="server" ID="lstSearchType"
                                            AutoPostBack="true" OnSelectedIndexChanged="Page_change">
                                            <asp:ListItem Value="HAWB" Text="House Bill No."></asp:ListItem>
                                            <asp:ListItem Value="MAWB" Text="Master AWB No."></asp:ListItem>
                                            <asp:ListItem Value="MGWB" Text="Master Ground Bill No."></asp:ListItem>
                                            <asp:ListItem Value="MAGWB" Text="Master Airway & Ground Bill No."></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td align="left" style="height: 18px; width: 184px;">
                                        <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />
                                    </td>
                                    <td align="left" style="width: 573px">
                                        <table>
                                            <tr class="bodyheader">
                                                <td align="left" valign="top" style="width: 100px; height: 15px;">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td style="height: 18px">
                                                                <asp:TextBox ID="Webdatetimeedit1" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td align="left" valign="top" style="height: 15px">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="Webdatetimeedit2" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top" class="bodycopy">
                                    </td>
                                </tr>
                                <tr class="bodyheader">
                                    <td height="18" align="left" bgcolor="#f3f3f3" style="width: 208px">
                                        <span class="style15">
                                            <asp:Label ID="label7" runat="server" /></span>
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" style="width: 573px">
                                        File no.
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="left" style="height: 18px">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                    <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                                    <div id="lstSearchNumDiv">
                                                    </div>
                                                    <!--<input type="text"-->
                                                    <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                        Style="width: 120px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                        onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox>
                                                </td>
                                                <td style="width: 16px">
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtlast" runat="server" CssClass="m_shorttextfield" Width="35px"></asp:TextBox>
                                                    <span class="bodyheader style2">Last 4.Digits</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" valign="middle" style="height: 18px; width: 573px;">
                                        <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr class="bodyheader">
                                    <td height="18" align="left" bgcolor="#f3f3f3" style="width: 208px">
                                        Airport of Departure
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" style="width: 573px">
                                        Airport of Destination
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="left" style="height: 18px">
                                        <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect">
                                            <asp:ListItem Text="Select One" Value="" />
                                        </asp:DropDownList>
                                    </td>
                                    <td align="left" style="width: 573px; height: 18px;">
                                        <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect">
                                            <asp:ListItem Text="Select One" Value="" />
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr class="bodyheader">
                                    <td height="18" colspan="2" align="left" bgcolor="#f3f3f3">
                                        Shipper
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#f3f3f3" style="padding-left: 10px; width: 573px;">
                                        Consignee
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" colspan="2" align="left" bgcolor="#FFFFFF">
                                        <!-- Start JPED -->
                                        <asp:HiddenField runat="Server" ID="hShipperAcct" Value="" />
                                        <div id="lstShipperNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td>
                                                    <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" name="lstShipperName"
                                                        value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                        color: #000000" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td>
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- End JPED -->
                                    </td>
                                    <td colspan="2" align="left">
                                        <asp:HiddenField runat="Server" ID="hConsigneeAcct" Value="" />
                                        <div id="lstConsigneeNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="height: 18px">
                                                    <asp:TextBox runat="server" autocomplete="off" ID="lstConsigneeName" name="lstConsigneeName"
                                                        CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                        color: #000000" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td style="height: 18px">
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td style="height: 18px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                        Shipper's Reference No.
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 476px">
                                        <span class="style15">
                                            <asp:Label ID="label2" runat="server" /></span>
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 573px">
                                        <span class="style15">
                                            <asp:Label ID="label3" runat="server" /></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 208px;">
                                        <asp:TextBox ID="TxtShip_REF" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    </td>
                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 159px;">
                                        <asp:DropDownList runat="server" ID="DropServLevel" CssClass="bodycopy" Width="127px"
                                            onchange="ServiceLevelChange()">
                                            <asp:ListItem Text="Select One"></asp:ListItem>
                                            <asp:ListItem Value="Same Day" Text="Same Day"></asp:ListItem>
                                            <asp:ListItem Value="Next Day" Text="Next Day"></asp:ListItem>
                                            <asp:ListItem Value="2nd Day" Text="2nd Day"></asp:ListItem>
                                            <asp:ListItem Value="3-5 Day" Text="3-5 Day"></asp:ListItem>
                                            <asp:ListItem Value="Other" Text="Other"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:DropDownList runat="server" ID="DropServLevel2" CssClass="bodycopy" Width="127px"
                                            onchange="ServiceLevelChange2()">
                                            <asp:ListItem Text="Select One"></asp:ListItem>
                                            <asp:ListItem Value="OTC (over the counter)" Text="OTC (over the counter)"></asp:ListItem>
                                            <asp:ListItem Value="NFO (next flight out)" Text="NFO (next flight out)"></asp:ListItem>
                                            <asp:ListItem Value="2nd Day" Text="2nd Day"></asp:ListItem>
                                            <asp:ListItem Value="Other" Text="Other"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 573px">
                                        <asp:TextBox ID="TxtOtherServLevel" runat="server" CssClass="m_shorttextfield" Width="120px"
                                            ClientIDMode="Static"></asp:TextBox>
                                        <asp:TextBox ID="TxtServLevel" runat="server" CssClass="m_shorttextfield" Width="120px"
                                            ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                        Carrier
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        &nbsp;
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 573px">
                                        Third Party Billing
                                    </td>
                                </tr>
                                <tr>
                                    <!-- style="padding-right:12px" -->
                                    <td colspan="2" align="left" style="height: 5px; width: 210px;">
                                        <asp:HiddenField runat="Server" ID="hCarrierAcct" Value="" />
                                        <div id="lstCarrierNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="height: 18px">
                                                    <asp:TextBox runat="server" autocomplete="off" ID="lstCarrierName" name="lstCarrierName"
                                                        CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                        color: #000000" onKeyUp="organizationFill(this, 'Carrier','lstCarrierNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td style="height: 18px">
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" id="img1" onclick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td style="height: 18px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td colspan="2" align="left" style="height: 5px; width: 210px;">
                                        <asp:HiddenField runat="Server" ID="hNotifyAcct" Value="" />
                                        <div id="lstNotifyNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="height: 18px">
                                                    <asp:TextBox runat="server" autocomplete="off" ID="lstNotifyName" name="lstNotifyName"
                                                        CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                        color: #000000" onKeyUp="organizationFill(this,'Notify','lstNotifyNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td style="height: 18px">
                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" id="img2" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange')"
                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                                <td style="height: 18px">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr bgcolor="#f3f3f3">
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                        Sales Rep.
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        No. of Pieces
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 573px;">
                                        C.O.D.
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 220px;">
                                        <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="SaleDroplist">
                                            <asp:ListItem Text="Select One" Value="" />
                                        </asp:DropDownList>
                                    </td>
                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 129px;">
                                        <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="120px"
                                            Style="behavior: url(/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox>
                                    </td>
                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 573px;">
                                        <table width="100%" height="12">
                                            <tr>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckYes" Text="Yes" TextAlign="Right" runat="server" onClick="Yes_checked()" />
                                                </td>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckNo" Text="No" TextAlign="Right" runat="server" onClick="No_checked()" />
                                                </td>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckAC" Text="ALL" Checked="TRUE" TextAlign="Right" runat="server"
                                                        onClick="AC_checked()" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr bgcolor="#f3f3f3">
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        &nbsp;
                                    </td>
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 573px">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="1" bgcolor="#997132" style="height: 1px; width: 208px;">
                                    </td>
                                    <td colspan="1" bgcolor="#997132" style="height: 1px; width: 184px;">
                                    </td>
                                    <td colspan="1" bgcolor="#997132" style="height: 1px; width: 573px;">
                                    </td>
                                </tr>
                                <tr bgcolor="#f3f3f3">
                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                        <asp:Label ID="label0" runat="server" />
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        <asp:Label ID="label1" runat="server" />
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 573px">
                                        <asp:Label ID="label5" runat="server" />
                                    </td>
                                </tr>
                                <tr bgcolor="#ffffff">
                                    <td align="left" valign="top" bgcolor="#ffffff" class="bodyheader" style="width: 208px;
                                        height: 18px;">
                                        <asp:TextBox ID="Txt1stHawb" runat="server" CssClass="shorttextfield" ForeColor="#000000"
                                            Width="150px" />
                                        <table width="100%" height="12">
                                            <tr>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckClosed" Text="Closed" TextAlign="Right" runat="server" onClick="Closed_checked()" />
                                                </td>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckUsed" Text="Used" TextAlign="Right" runat="server" onClick="Used_checked()" />
                                                </td>
                                                <td height="12" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                    <asp:CheckBox ID="CheckAM" Text="ALL" Checked="TRUE" TextAlign="Right" runat="server"
                                                        onClick="AM_checked()" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#ffffff" class="bodyheader" style="height: 18px;
                                        width: 129px;">
                                        <asp:TextBox ID="AESNO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#ffffff" class="bodycopy" style="width: 573px;
                                        height: 18px;">
                                        <asp:HiddenField runat="Server" ID="hAgentAcct" Value="" />
                                        <div id="lstAgentNameDiv">
                                        </div>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="height: 18px">
                                                    <asp:TextBox runat="server" autocomplete="off" ID="lstAgentName" name="lstAgentName"
                                                        CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                        border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                        color: #000000" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange')"
                                                        onfocus="initializeJPEDField(this,event);" />
                                                </td>
                                                <td style="height: 18px">
                                                    <asp:Image runat="server" ID="imagb" src="/ig_common/Images/combobox_drop.gif" onclick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange');"
                                                        Style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                        border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#f3f3f3" style="width: 208px" align="left">
                                        <asp:HiddenField ID="hELTNO" runat="server" Value="" />
                                    </td>
                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 184px">
                                        <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                        <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                    </td>
                                    <td height="24" align="right" valign="middle" bgcolor="#f3f3f3" style="padding-right: 15px;
                                        width: 573px;">
                                        <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                            OnClick="btnGo_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="left" bgcolor="#f3f3f3">
                <div style="width: 100%">
                    <asp:GridView ID="GridViewHouse" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridViewHouse_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="2" cellspacing="1" style="width: 100%">
                                                    <tr>
                                                        <td height="1" colspan="12" bgcolor="#997132">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="20" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                            <span class="style15">HOUSE BILL DOMESTIC SEARCH</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" colspan="12" bgcolor="#997132">
                                                        </td>
                                                    </tr>
                                                    <tr bgcolor="#f3d9a8" class="bodyheader">
                                                        <td height="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132;
                                                            padding-left: 10PX" width="10%">
                                                            House AWB No.
                                                            <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="house_Click"
                                                                ID="Mast_Sort1" />
                                                        </td>
                                                        <td height="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132"
                                                            width="10%">
                                                            Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton10" OnClick="master_Click" />
                                                        </td>
                                                        <td width="8%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            ETD
                                                            <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton13"
                                                                OnClick="ETD_Click" />
                                                        </td>
                                                        <td width="8%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            File No.
                                                            <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton11"
                                                                OnClick="File_Click" />
                                                        </td>
                                                        <td width="10%" align="left" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Daparture Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton16" OnClick="Dep_Click" />
                                                        </td>
                                                        <td width="10%" align="left" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Destination Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton17" OnClick="Dest_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton14"
                                                                OnClick="shipper_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton15"
                                                                OnClick="Consignee_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Third Party Billing<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton12" OnClick="ThirdP2_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Agent
                                                            <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton5"
                                                                OnClick="Agent_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <!-- list item -->
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                        <tr>
                                            <td height="20" style="padding-left: 10px" width="10%" class="searchList">
                                                <a href="javascript:;" onclick="EditClickHAWB('<%# Eval("hawb_num")%>')">
                                                    <%# Eval("hawb_num") %></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClick('<%# Eval("MasterNo") %>', '<%# Eval("status") %>','<%# Eval("master_type")%>')">
                                                    <%# Eval("MasterNo") %></a>
                                                <%# GetStatus(Eval("status"),"K")%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="8%">
                                                <%# GetShortDate(Eval("CreatedDate"))%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="8%">
                                                <a href="javascript:;" onclick="EditClickFILE('<%# Eval("file#") %>', '<%# Eval("master_type") %>')">
                                                    <%# Eval("file#")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <%# Eval("Departure_Airport")%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <%# Eval("Dest_Airport") %>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("shipper_account_number") %>')">
                                                    <%# Eval("Shipper_name")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("consignee_acct_num") %>')">
                                                    <%# Eval("consignee_name")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("Notify_no") %>')">
                                                    <%# GetThidParty(Eval("Notify_no"))%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("agent_no") %>')">
                                                    <%# Eval("agent_name")%></a>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div>
                    <asp:GridView ID="GridViewMaster" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridViewMaster_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="2" cellspacing="1" style="width: 100%">
                                                    <tr>
                                                        <td height="1" colspan="12" bgcolor="#997132">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="20" style="padding-left: 10px" bgcolor="#f3d9a8" height="24">
                                                            <span class="style15">Master BILL DOMESTIC SEARCH</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" colspan="12" bgcolor="#997132">
                                                        </td>
                                                    </tr>
                                                    <tr bgcolor="#f3d9a8" class="bodyheader">
                                                        <td height="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132;
                                                            padding-left: 10PX" width="10%">
                                                            Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="Mast_Sort1" OnClick="master_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            ETD
                                                            <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton4"
                                                                OnClick="ETD_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            File No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton1"
                                                                OnClick="File_Click" />
                                                        </td>
                                                        <td width="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Daparture Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton8" OnClick="Dep_Click" />
                                                        </td>
                                                        <td width="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Destination Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton9" OnClick="Dest_Click" />
                                                        </td>
                                                        <td width="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton6"
                                                                OnClick="shipper_Click" />
                                                        </td>
                                                        <td width="12%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton7"
                                                                OnClick="Consignee_Click" />
                                                        </td>
                                                        <td width="10%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            Third Party Billing<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                ID="ImageButton18" OnClick="ThirdP_Click" />
                                                        </td>
                                                        <td width="8%" style="border-bottom: 1px solid #997132; border-right: 1px solid #997132">
                                                            MAWB Status
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <!-- list item -->
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                        <tr>
                                            <td height="20" style="padding-left: 10px" width="10%">
                                                <a href="javascript:;" onclick="EditClick('<%# Eval("MasterNo") %>', '<%# Eval("status") %>','<%# Eval("master_type")%>')">
                                                    <%# Eval("MasterNo") %></a>
                                                <%# GetStatus(Eval("status"),"K")%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <%# GetShortDate(Eval("CreatedDate"))%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickFILE('<%# Eval("file#") %>', '<%# Eval("master_type") %>')">
                                                    <%# Eval("file#")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="12%">
                                                <%# Eval("Departure_Airport")%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="12%">
                                                <%# Eval("Dest_Airport")%>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="12%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("shipper_account_number") %>')">
                                                    <%# Eval("shipper_name")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="12%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("consignee_acct_num") %>')">
                                                    <%# Eval("consignee_name")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="10%">
                                                <a href="javascript:;" onclick="EditClickName('<%# Eval("Notify_no") %>')">
                                                    <%# Eval("Third_name")%></a>
                                            </td>
                                            <td height="20" style="padding-left: 3px" width="8%">
                                                <%# GetStatus(Eval("status"),Eval("used"))%>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </td>
        </tr>
        <tr bgcolor="#F2DEBF">
            <td height="22" align="left" valign="middle" bgcolor="#eec983" class="bodycopy">
                &nbsp;
            </td>
        </tr>
    </table>
    <p>
        <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False">
        </asp:Button><asp:LinkButton ID="LinkButton3" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
            ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox><!-- end --></p>
    </form>
</body>
<script type="text/javascript">

    function lstShipperNameChange(orgNum, orgName) {
        var hiddenObj = document.getElementById("hShipperAcct");
        var txtObj = document.getElementById("lstShipperName");
        var divObj = document.getElementById("lstShipperNameDiv");

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
    }
    function lstAgentNameChange(ANum, AName) {
        var AhiddenObj = document.getElementById("hAgentAcct");
        var AtxtObj = document.getElementById("lstAgentName");
        var AdivObj = document.getElementById("lstAgentNameDiv");

        AhiddenObj.value = ANum;
        AtxtObj.value = AName;
        AdivObj.style.position = "absolute";
        AdivObj.style.visibility = "hidden";
    }

    function lstCarrierNameChange(orgNum, orgName) {
        var c_hiddenObj = document.getElementById("hCarrierAcct");
        var c_txtObj = document.getElementById("lstCarrierName");
        var c_divObj = document.getElementById("lstCarrierNameDiv");

        c_hiddenObj.value = orgNum;
        c_txtObj.value = orgName;
        c_divObj.style.position = "absolute";
        c_divObj.style.visibility = "hidden";
    }


    function lstConsigneeNameChange(orgNum, orgName) {
        var hiddenObj = document.getElementById("hConsigneeAcct");
        var txtObj = document.getElementById("lstConsigneeName");
        var divObj = document.getElementById("lstConsigneeNameDiv");

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
        divObj.style.position = "absolute";
        divObj.style.visibility = "hidden";
        divObj.innerHTML = "";
    }


    function lstNotifyNameChange(CONum, COName) {
        var NhiddenObj = document.getElementById("hNotifyAcct");
        var NtxtObj = document.getElementById("lstNotifyName");
        var NdivObj = document.getElementById("lstNotifyNameDiv");

        NhiddenObj.value = CONum;
        NtxtObj.value = COName;
        NdivObj.style.position = "absolute";
        NdivObj.style.visibility = "hidden";
        NdivObj.innerHTML = "";
    }
    function loadValues() {
        if (document.getElementById("lstSearchType").value == "HAWB") {
            ServiceLevelChange();
        }
        if (document.getElementById("lstSearchType").value == "MAWB") {
            ServiceLevelChange2();
        }
        if (document.getElementById("PeriodDropDownList").value == "ALLTIME") {
            datetextboxchange1();
        }

    }
    function searchNumFill(obj, changeFunction, vHeight) {
        var qStr = obj.value;
        var keyCode = window.event.keyCode;
        var url;

        if (qStr != "" && keyCode != 229 && keyCode != 27) {
            if (document.getElementById("lstSearchType").value == "MAWB") {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DAB&qStr=" + qStr;
            }
            else if (document.getElementById("lstSearchType").value == "MGWB") {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DGB&qStr=" + qStr;
            }
            else {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DUB&qStr=" + qStr;
            }
            FillOutJPED(obj, url, changeFunction, vHeight);
        }
    }

    function searchNumFillAll(objName, changeFunction, vHeight) {
        var obj = document.getElementById(objName);
        if (document.getElementById("lstSearchType").value == "MAWB") {
            url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DAB";
        }
        else if (document.getElementById("lstSearchType").value == "MGWB") {
            url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DGB";
        }
        else {
            url = "/ASP/ajaxFunctions/ajax_get_Domestic_mawb_list.asp?mode=DUB";
        }
        FillOutJPED(obj, url, changeFunction, vHeight);
    }

    function lstSearchNumChange(argV, argL) {
        var divObj = document.getElementById("lstSearchNumDiv");
        var hiddenObj = document.getElementById("hSearchNum");
        var txtObj = document.getElementById("lstSearchNum");

        hiddenObj.value = argV;
        txtObj.value = argL;
        divObj.style.visibility = "hidden";
        divObj.style.position = "absolute";
        divObj.innerHTML = "";
    }
    function datetextboxchange1() {
        document.getElementById("Webdatetimeedit1").style.background = "#CCCCCC";
        document.getElementById("Webdatetimeedit2").style.background = "#CCCCCC";
    }
    function datetextboxchange2() {
        document.getElementById("Webdatetimeedit1").style.background = "#FFFFFF";
        document.getElementById("Webdatetimeedit2").style.background = "#FFFFFF";
    }

    function ServiceLevelChange() {
        if (document.getElementById("DropServLevel").value == "Other") {
            document.getElementById("TxtotherServLevel").readOnly = false;

            document.getElementById("TxtotherServLevel").style.background = "#FFFFFF";
        }
        else {
            document.getElementById("TxtotherServLevel").readOnly = true
            document.getElementById("TxtotherServLevel").style.background = "#CCCCCC";
            document.getElementById("TxtotherServLevel").value = "";
        }

    }

    function ServiceLevelChange2() {
        if (document.getElementById("DropServLevel2").value == "Other") {
            document.getElementById("TxtServLevel").readonly = false;
            document.getElementById("TxtServLevel").readOnly = false
            document.getElementById("TxtServLevel").style.background = "#FFFFFF";
        }
        else {
            document.getElementById("TxtServLevel").readOnly = true
            document.getElementById("TxtServLevel").style.background = "#CCCCCC";
            document.getElementById("TxtServLevel").value = "";
        }

    }
    function EditClick(MAWB, status, BILL) {

        if (status != "C") {
            url = "/ASP/Domestic/new_edit_mawb.asp?Edit=yes&mawb=" + MAWB + "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
        else {
            if (BILL == "DG") {
                alert("Master Ground Bill No.# " + MAWB + " is Closed!");
            }
            else {
                alert("Master AWB No.# " + MAWB + " is Closed!");
            }
        }
    }
    function EditClickName(org_No) {
        var eltno = document.getElementById("hELTNO").value;
        if (org_No == eltno) {
            url = "/ASP/site_admin/co_config.asp?WindowName=popUpWindow";
        }
        else {
            url = "/ASP/master_data/client_profile.asp?Action=filter&n=" + org_No + "&WindowName=popUpWindow";
        }
        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
    }

    function EditClickFILE(FILE, type) {
        if (type == "DG") {
            url = "/ASP/Domestic/new_booking_ground.asp?mode=edit&FileNo=" + FILE + "&WindowName=popUpWindow";
        }
        else {
            url = "/ASP/Domestic/booking.asp?Edit=yes&FILENO=" + FILE + "&WindowName=popUpWindow";
        }
        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
    }
    function EditClickHAWB(HAWB) {
        url = "/ASP/Domestic/new_edit_hawb.asp?mode=search&hawb=" + HAWB + "&WindowName=popUpWindow";
        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
    }

    function Yes_checked() {
        if (document.getElementById("CheckYes").checked == false) {
            document.getElementById("CheckAC").checked = true;
        }
        else {
            document.getElementById("CheckNo").checked = false;
            document.getElementById("CheckAC").checked = false;
        }
    }
    function No_checked() {
        if (document.getElementById("CheckNo").checked == false) {
            document.getElementById("CheckAC").checked = true;
        }
        else {
            document.getElementById("CheckYes").checked = false;
            document.getElementById("CheckAC").checked = false;
        }
    }
    function AC_checked() {
        if (document.getElementById("CheckAC").checked == false) {
            document.getElementById("CheckAC").checked = true;
        }
        else {
            document.getElementById("CheckYes").checked = false;
            document.getElementById("CheckNo").checked = false;
        }
    }

    function Closed_checked() {
        if (document.getElementById("CheckClosed").checked == false) {
            document.getElementById("CheckAM").checked = true;
        }
        else {
            document.getElementById("CheckUsed").checked = false;
            document.getElementById("CheckAM").checked = false;
        }
    }

    function Used_checked() {
        if (document.getElementById("CheckUsed").checked == false) {
            document.getElementById("CheckAM").checked = true;
        }
        else {
            document.getElementById("CheckClosed").checked = false;
            document.getElementById("CheckAM").checked = false;
        }
    }

    function AM_checked() {
        if (document.getElementById("CheckAM").checked == false) {
            document.getElementById("CheckAM").checked = true;
        }
        else {
            document.getElementById("CheckClosed").checked = false;
            document.getElementById("CheckUsed").checked = false;
        }
    }

    function ViewClickH(hawbno) {
        url = "/ASP/Domestic/view_print.asp?sType=house&hawb=" + hawbno + "&WindowName=popUpWindow";
        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=0,resizable=1,width=900,height=600');
    }
    function ViewClickM(mawbno) {
        url = "/ASP/Domestic/view_print.asp?sType=master&hawb=" + mawbno + "&WindowName=popUpWindow";
        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=0,resizable=1,width=900,height=600');
    }
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
