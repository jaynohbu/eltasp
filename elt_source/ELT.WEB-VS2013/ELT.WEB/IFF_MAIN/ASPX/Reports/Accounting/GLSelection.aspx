<%--<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>--%>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.GLSelection" Trace="false"
    CodeFile="GLSelection.aspx.cs" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Account Report</title>
    <meta http-equiv="Content-Type" content="text/html; charset=ks_c_5601-1987" />
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>
    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>
    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>
    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
            function isNum(a) {

                if(a.value == "") return true;

                var number=parseInt(a.value,10);

                if( number.toString()=="NaN") {
                    alert('Please input a valid I/V No.');
                    return false;
                }
                else {
                    return true;
                }
            }
            
            function setToGl(){
                var s = document.form1.DlGLFrom.value;
                if (s != "") {
                    document.form1.DlGLTo.value = document.form1.DlGLFrom.value;
                }
            }
            
            

            function lstCompanyNameChange(orgNum,orgName){
                var hiddenObj = document.getElementById("hCompanyAcct");
                var txtObj = document.getElementById("lstCompanyName");
                var divObj = document.getElementById("lstCompanyNameDiv")
        
                hiddenObj.value = orgNum;
                txtObj.value = orgName;
                divObj.style.position = "absolute";
                divObj.style.visibility = "hidden";
            }
            
    </script>
     <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" method="post" runat="server">
        <input type="image" style="width: 0px; height: 0px; position:absolute" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    <asp:Label ID="lblReportTitle" runat="server" DESIGNTIMEDRAGDROP="285" CssClass="pageheader">Sales</asp:Label></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979"
            class="border1px" id="Table2" style="height: 64px">
            <tr>
                <td style="height: 10px" valign="top" bgcolor="D5E8CB">
                </td>
            </tr>
            <tr align="left" valign="middle">
                <td height="1" colspan="" bgcolor="#89A979">
                </td>
            </tr>
            <tr>
                <td align="center" valign="top" bgcolor="#f3f3f3">
                    <br>
                    <table border="0" cellspacing="0" cellpadding="0" style="width: 62%; height: 14px">
                        <tr>
                            <td height="28" align="right" style="width: 1008px">
                                <span class="bodyheader">&nbsp;<img src="/ASP/Images/required.gif" align="absbottom">Required
                                    field</span></td>
                        </tr>
                    </table>
                    <table width="62%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979"
                        bgcolor="#FFFFFF" class="border1px" id="Table1" style="padding-left: 10px">
                        <tr bgcolor="#E7F0E2">
                            <td height="20" align="left" bgcolor="#E7F0E2">
                                <asp:Label ID="Label2" runat="server" designtimedragdrop="43" CssClass="bodyheader">Period</asp:Label></td>
                            <td colspan="2" align="left" class="bodyheader">
                                <asp:Label ID="Label3" runat="server"><img src="/ASP/Images/required.gif" align="absbottom">From</asp:Label></td>
                            <td align="left">
                                <asp:Label ID="Label1" runat="server" designtimedragdrop="3572" CssClass="bodyheader">To</asp:Label></td>
                        </tr>
                        <tr>
                            <td height="22" align="left" valign="middle">
                                     <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />

                            </td>
                            <td colspan="2" align="left">
                               <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="Webdatetimeedit1" ErrorMessage="From is required."></asp:RequiredFieldValidator>

                            </td>
                            <td align="left">
                               <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="Webdatetimeedit2" ErrorMessage="To is required."></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="2" colspan="4" bgcolor="#89A979">
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#f3f3f3">
                                <asp:Label ID="lblBranch" runat="server" Visible="False" CssClass="bodyheader">Branch</asp:Label></td>
                            <td width="141" bgcolor="#f3f3f3">
                                <span style="width: 155px">
                                    <asp:Label ID="txtWidth" runat="server"></asp:Label></span></td>
                            <td colspan="2" bgcolor="#f3f3f3">
                                <asp:Label ID="Label8" runat="server" CssClass="bodyheader">Company</asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">
                                <asp:DropDownList ID="DlBranch" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Height="20px" Visible="False" Width="260px">
                                </asp:DropDownList></td>
                            <td colspan="2">
                                <asp:Panel ID="panelCompany" runat="server">
                                <!-- Start JPED -->
                                <asp:HiddenField runat="Server" ID="hCompanyAcct" Value="" />
                                <div id="lstCompanyNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <asp:TextBox runat="server" autocomplete="off" ID="lstCompanyName" name="lstCompanyName"
                                                value="" class="shorttextfield" Style="width: 250px; border-top: 1px solid #7F9DB9;
                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                color: #000000" onKeyUp="organizationFill(this,'All','lstCompanyNameChange',null, event)"
                                                onfocus="initializeJPEDField(this,event);" /></td>
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCompanyName','All','lstCompanyNameChange')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                    </tr>
                                </table>
                                <!-- End JPED -->
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="left">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" bgcolor="#f3f3f3">
                                <asp:Label ID="lblGL" runat="server" Visible="False" CssClass="bodyheader">GL No. (from)</asp:Label>
                            </td>
                            <td colspan="2" bgcolor="#f3f3f3">
                                <asp:Label ID="lblGLTo" runat="server" designtimedragdrop="3572" Visible="False"
                                    CssClass="bodyheader">To</asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:DropDownList ID="DlGLFrom" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Height="20px" Visible="False" Width="200px">
                                </asp:DropDownList></td>
                            <td colspan="2">
                                <asp:DropDownList ID="DlGLTo" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Height="20px" Visible="False" Width="200px">
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" bgcolor="#f3f3f3">
                                <asp:Label ID="lblBank" runat="server" Visible="False" CssClass="bodyheader">Bank Account No. </asp:Label>
                            </td>
                            <td width="51" bgcolor="#f3f3f3">
                            </td>
                            <td bgcolor="#f3f3f3">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">
                                <asp:DropDownList ID="DlBank" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Visible="False" Width="200px">
                                </asp:DropDownList></td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" bgcolor="#f3f3f3">
                                <asp:Label ID="lblTrn" runat="server" designtimedragdrop="3572" Visible="False" CssClass="bodyheader">Transaction Type</asp:Label>
                            </td>
                            <td bgcolor="#f3f3f3">
                            </td>
                            <td bgcolor="#f3f3f3">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">
                                <asp:DropDownList ID="DlTrType" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Height="20px" Visible="False" Width="200px">
                                </asp:DropDownList></td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" bgcolor="#f3f3f3">
                                <asp:Label ID="lblPmtMethod" runat="server" designtimedragdrop="3572" Visible="False">Payment Method</asp:Label>
                            </td>
                            <td bgcolor="#f3f3f3">
                            </td>
                            <td bgcolor="#f3f3f3">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left">
                                <asp:DropDownList ID="DlPmtMethod" runat="server" CssClass="smallselect" Font-Names="Verdana"
                                    Height="20px" Visible="False" Width="200px">
                                    <asp:ListItem Value="BP-CHK">Check</asp:ListItem>
                                    <asp:ListItem>Cash</asp:ListItem>
                                    <asp:ListItem>Credit Card</asp:ListItem>
                                    <asp:ListItem>Bank to Bank</asp:ListItem>
                                    <asp:ListItem Selected="True">All</asp:ListItem>
                                </asp:DropDownList></td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" valign="top">
                                <asp:CheckBox ID="CheckUnposted" runat="server" Text="Include Unposted transactions"
                                    Visible="False" /></td>
                            <td colspan="2" align="left">
                                <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal"
                                    Visible="False">
                                    <asp:ListItem Value="Quick" Selected="True">Quick</asp:ListItem>
                                    <asp:ListItem Value="Statistic">Statistic</asp:ListItem>
                                </asp:RadioButtonList></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" valign="top">
                                &nbsp;</td>
                            <td colspan="2" align="center" valign="middle" style="height: 22px">
                                <asp:ImageButton ID="btnGo" runat="server" ImageUrl="../../../images/button_go.gif"
                                    OnClick="btnGo_Click"></asp:ImageButton></td>
                        </tr>
                    </table>
                    <br>
                    <br>
                </td>
            </tr>
            <tr align="left" valign="middle">
                <td height="1" colspan="" bgcolor="#89A979">
                </td>
            </tr>
            <tr>
                <td height="24" bgcolor="#D5E8CB">
                    <asp:TextBox ID="txtCode" runat="server" style="display:none" Width="1px"></asp:TextBox></td>
            </tr>
        </table>
       
    </form>    
      <br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
