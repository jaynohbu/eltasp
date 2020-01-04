<%--<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>--%>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.PNL.PnlIndex" Trace="false"
    CodeFile="PnlIndex.aspx.cs" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>PNL Report Selection</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta content="C#" name="CODE_LANGUAGE">
    <script src="/IFF_MAIN/ASPX/jScripts/WebDateSet1.js" type="text/javascript"></script>
    <script src="/IFF_MAIN/ASPX/jScripts/ig_dropCalendar.js" type="text/javascript"></script>
    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>
    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet">
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
    <!--  #INCLUDE FILE="../../include/common.htm" -->
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}


    .style1
    {
        width: 403px;
    }
    .style2
    {
        height: 22px;
        width: 403px;
    }


-->
</style>
    <script type="text/javascript">



    </script>
</head>
<body onload="dlOrderChange();">
    <form id="form1" method="post" runat="server">
    <script language="javascript">
<!--

        function dlOrderChange() {
            var i = document.form1.dlOrder.value;
            if (i == 'invoice_date') {
                document.getElementById('lblSumLevel').style.visibility = "visible";
                document.getElementById('lblSumBy').style.visibility = "visible";
                document.getElementById('dlSumBy').style.visibility = "visible";
            }
            else {
                document.getElementById('lblSumLevel').style.visibility = "hidden";
                document.getElementById('lblSumBy').style.visibility = "hidden";
                document.getElementById('dlSumBy').style.visibility = "hidden";
            }
        }

        function CheckDate() {


        }
//-->
    </script>
    <input type="image" style="width: 0px; height: 0px; position: absolute" onclick="return false;" />
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td valign="bottom" class="pageheader">
                Profit &amp; Loss Report
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td align="left" valign="middle">
                <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979"
                    class="border1px">
                    <tr bgcolor="#e8d9e6">
                        <td height="8" colspan="6" align="left" valign="middle" bgcolor="#D5E8CB">
                        </td>
                    </tr>
                    <tr>
                        <td height="1" colspan="6" align="left" valign="middle" bgcolor="#89A979">
                        </td>
                    </tr>
                    <tr align="center" bgcolor="e8d9e6">
                        <td colspan="6" valign="middle" bgcolor="#f3f3f3">
                            <br />
                            <table border="0" cellspacing="0" cellpadding="0" style="width: 73%; height: 23px">
                                <tr>
                                    <td align="right" style="height: 28px">
                                        <span class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">Required field</span>
                                    </td>
                                </tr>
                            </table>
                            <table width="60" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979"
                                class="border1px">
                                <tr align="left" valign="middle">
                                    <td bgcolor="#E7F0E2" style="height: 22px; width: 3px;">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="#E7F0E2" class="bodyheader">
                                        <asp:Label ID="Label2" runat="server" designtimedragdrop="43" CssClass="bodyheader">Selection Period</asp:Label>
                                    </td>
                                    <td bgcolor="#E7F0E2" class="style1">
                                        <span class="bodyheader">
                                            <img src="/ASP/Images/required.gif" align="absbottom">From</span>
                                    </td>
                                    <td bgcolor="#E7F0E2">
                                        <span class="bodyheader">To</span>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle">
                                    <td bgcolor="#FFFFFF" style="height: 22px; width: 3px;">
                                        &nbsp;
                                    </td>
                                    <td valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                        <span style="width: 110px">
                                            <asp:DropDownList CssClass="bodycopy" runat="server" ID="ddlPeriod" />
                                        </span>
                                    </td>
                                    <td bgcolor="#FFFFFF" class="style1">
                                        <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Webdatetimeedit1"
                                            ErrorMessage="From is required."></asp:RequiredFieldValidator>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Webdatetimeedit2"
                                            ErrorMessage="To is required."></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle">
                                    <td height="1" colspan="4" bgcolor="#89A979">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff">
                                    <td bgcolor="#f3f3f3" class="bodycopy" style="width: 3px; height: 22px">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3" style="width: 62px; height: 22px;">
                                        <span style="width: 100px;">
                                            <asp:Label ID="Label13" runat="server" Width="100%" CssClass="bodyheader">MAWB or Master B/L No.</asp:Label>
                                        </span>
                                    </td>
                                    <td bgcolor="#f3f3f3" class="style2">
                                        <span style="width: 62px; height: 22px"><span style="width: 100px;">
                                            <asp:Label ID="Label14" runat="server" Width="100%" CssClass="bodyheader">File No.</asp:Label>
                                        </span></span>
                                    </td>
                                    <td bgcolor="#f3f3f3" style="height: 22px">
                                        <span style="width: 62px; height: 22px;"><span style="width: 100px;">
                                            <asp:Label ID="Label3" runat="server" Width="100%" Height="0px" CssClass="bodyheader">Reference No.</asp:Label>
                                        </span></span>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff">
                                    <td class="bodycopy" style="width: 3px; height: 22px">
                                        &nbsp;
                                    </td>
                                    <td style="width: 62px; height: 22px;">
                                        <span style="width: 341px"><span style="height: 3px">
                                            <asp:TextBox ID="txtMAWB" runat="server" BorderWidth="1px" Width="158px" CssClass="m_shorttextfield"></asp:TextBox>
                                        </span></span>
                                    </td>
                                    <td class="style2">
                                        <span style="height: 3px">
                                            <asp:TextBox ID="txtRefNum2" runat="server" BorderWidth="1px" Width="120px" CssClass="m_shorttextfield"></asp:TextBox>
                                        </span>
                                    </td>
                                    <td style="height: 22px">
                                        <span style="width: 62px; height: 22px;"><span style="height: 22px; width: 341px;"><span
                                            style="height: 3px">
                                            <asp:TextBox ID="txtRefNum1" runat="server" Width="120px" BorderWidth="1px" CssClass="m_shorttextfield"></asp:TextBox>
                                        </span></span></span>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        <span style="width: 100px;">
                                            <asp:Label ID="Label8" runat="server" Width="100%" CssClass="bodyheader">Customer/Agent</asp:Label>
                                        </span>
                                    </td>
                                    <td height="22" align="left" valign="middle" class="style1">
                                        <span style="width: 100px">
                                            <asp:Label ID="Label9" runat="server" Width="100%" CssClass="bodyheader">Import/Export</asp:Label>
                                        </span>
                                    </td>
                                    <td align="left">
                                        <span style="width: 100px">
                                            <asp:Label ID="Label10" runat="server" Width="100%" CssClass="bodyheader"> Air/Ocean</asp:Label>
                                        </span>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                    <td height="22" bgcolor="#FFFFFF" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22" bgcolor="#FFFFFF">
                                        <iMoon:ComboBox ID="cmbCustomer" CssClass="bodycopy" runat="server" Rows="20" Width="200px">
                                            <asp:ListItem>Unbound</asp:ListItem>
                                        </iMoon:ComboBox>
                                    </td>
                                    <td height="22" align="left" valign="middle" bgcolor="#FFFFFF" class="style1">
                                        <asp:DropDownList ID="DropDownList1" runat="server" Width="110px" CssClass="bodycopy">
                                            <asp:ListItem Value="All">All</asp:ListItem>
                                            <asp:ListItem Value="Export">Export</asp:ListItem>
                                            <asp:ListItem Value="Import">Import</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td align="left" bgcolor="#FFFFFF">
                                        <span style="width: 341px">
                                            <asp:DropDownList ID="DropDownList2" runat="server" designtimedragdrop="1400" Width="110px"
                                                CssClass="bodycopy">
                                                <asp:ListItem Value="All">All</asp:ListItem>
                                                <asp:ListItem Value="Air">Air</asp:ListItem>
                                                <asp:ListItem Value="Ocean">Ocean</asp:ListItem>
                                            </asp:DropDownList>
                                        </span>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        <span style="width: 100px">
                                            <asp:Label ID="Label5" runat="server" Width="100%" CssClass="bodyheader">Route </asp:Label>
                                        </span>
                                    </td>
                                    <td height="22" align="left" valign="middle" class="style1">
                                        <span style="width: 100px">
                                            <asp:Label ID="Label11" runat="server" Width="100%" CssClass="bodyheader">Sort  Option</asp:Label>
                                        </span>
                                    </td>
                                    <td align="right">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label7" runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodycopy">From</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label6" runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodycopy">To</asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 130px">
                                                    <asp:TextBox ID="txtOrigin" runat="server" Width="100px" CssClass="m_shorttextfield"></asp:TextBox>
                                                </td>
                                                <td style="width: 130px">
                                                    <asp:TextBox ID="txtDest" runat="server" Width="100px" CssClass="m_shorttextfield"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td height="22" align="left" valign="middle" bgcolor="#ffffff" class="style1">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td style="height: 13px">
                                                    <span style="width: 159px">
                                                        <asp:Label ID="Label12" runat="server" designtimedragdrop="3572" Width="100px" CssClass="bodycopy">Order by</asp:Label>
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:DropDownList ID="dlOrder" runat="server" designtimedragdrop="1400" Width="110px"
                                                        CssClass="bodycopy">
                                                        <asp:ListItem Value="invoice_date">Date</asp:ListItem>
                                                        <asp:ListItem Value="ref_no">Ref.No.</asp:ListItem>
                                                        <asp:ListItem Value="ref_no_our">File No.</asp:ListItem>
                                                        <asp:ListItem Value="mawb">MAWB/MBOL</asp:ListItem>
                                                        <asp:ListItem Value="customer_name">Customer/Agent</asp:ListItem>
                                                        <asp:ListItem Value="import_export">Import/Export</asp:ListItem>
                                                        <asp:ListItem Value="air_ocean">Air/Ocean</asp:ListItem>
                                                        <asp:ListItem Value="route">Route</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" bgcolor="#ffffff">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        &nbsp;
                                    </td>
                                    <td height="22" align="left" valign="middle" bgcolor="#f3f3f3" class="style1">
                                        &nbsp;
                                    </td>
                                    <td align="right">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        <span style="width: 100px">
                                            <asp:Label ID="lblSumLevel" runat="server" Width="100%" CssClass="bodyheader">Summary Level</asp:Label>
                                        </span>
                                    </td>
                                    <td height="22" align="left" valign="middle" bgcolor="#ffffff" class="style1">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <span style="width: 159px">
                                                        <asp:Label ID="lblSumBy" runat="server" designtimedragdrop="3572" Width="100px" CssClass="bodycopy"
                                                            Height="0px">Sum by</asp:Label>
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 18px">
                                                    <asp:DropDownList ID="dlSumBy" runat="server" designtimedragdrop="1400" Width="110px"
                                                        CssClass="bodycopy">
                                                        <asp:ListItem Value="Month">Month</asp:ListItem>
                                                        <asp:ListItem Value="Week">Week</asp:ListItem>
                                                        <asp:ListItem Value="Day">Day</asp:ListItem>
                                                        <asp:ListItem Value="Quater">Quater</asp:ListItem>
                                                        <asp:ListItem Value="Year">Year</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" bgcolor="#ffffff">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                    <td height="22" style="width: 3px">
                                        &nbsp;
                                    </td>
                                    <td height="22">
                                        <span style="width: 100px">
                                            <asp:Label ID="Label15" runat="server" Width="100%" CssClass="bodyheader">Result Style</asp:Label>
                                        </span>
                                    </td>
                                    <td height="22" align="left" valign="middle" class="style1">
                                        <asp:DropDownList ID="dlResultType" runat="server" designtimedragdrop="1400" Width="110px"
                                            CssClass="bodycopy">
                                            <asp:ListItem Value="s">Summary Only</asp:ListItem>
                                            <asp:ListItem Value="d">Detail Only</asp:ListItem>
                                            <asp:ListItem Value="a">Summary &amp; Detail</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td align="right">
                                        <span style="width: 120px">
                                            <asp:ImageButton ID="btnGo" runat="server" ImageUrl="../../../images/button_go.gif"
                                                OnClick="btnGo_Click"></asp:ImageButton>
                                            <img src="/ASP/Images/spacer.gif" width="18" height="12">
                                        </span>
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </td>
                    </tr>
                    <tr bgcolor="#89A979">
                        <td height="1" colspan="6" align="left" valign="middle">
                        </td>
                    </tr>
                    <tr align="center" bgcolor="#cdcc9d">
                        <td height="20" colspan="6" valign="middle" bgcolor="#D5E8CB">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <p>
        <asp:TextBox ID="txtCustomerNum" style="display:none" runat="server" Height="1px" Width="1px"></asp:TextBox>
        <!-- end -->
    </p>
    </form>
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
