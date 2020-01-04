
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.ARAgingSelection" trace="false" CodeFile="ARAgingSelection.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
		<title>ARAgingSelection</title>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
		<meta content="C#" name="CODE_LANGUAGE" />
		<meta content="JavaScript" name="vs_defaultClientScript" />
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
		<script src="/IFF_MAIN/ASPX/jScripts/ig_dropCalendar.js" type="text/javascript"></script>
		<script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>
		<script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
        <script src="/ASP/Include/JPED.js" type="text/javascript"></script>
        <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>
        <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet" />
		<script type="text/javascript">
            
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
        <style type="text/css">

            body {
	            margin-left: 0px;
	            margin-right: 0px;
	            margin-bottom: 0px;
            }

        </style>
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
	<body style="margin:0px 0px 0px 0px">
		<form id=form1 method=post runat="server">
		<input type="image" style="width:0px; height:0px; position:absolute" onclick="return false;" />
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td valign="bottom" class="pageheader">A/R Aging</td>
    </tr>
</table>
		    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" valign="middle"><table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px">
                            <tr bgcolor="#e8d9e6">
                                <td height="8" colspan="6" align="left" valign="middle" bgcolor="#D5E8CB"></td>
                            </tr>
                            <tr>
                                <td height="1" colspan="6" align="left" valign="middle" bgcolor="#89A979"></td>
                            </tr>
                            <tr align="center" bgcolor="e8d9e6">
                                <td colspan="6" valign="middle" bgcolor="#f3f3f3"><br>
                                        <table width="40%" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px">
                                            <tr align="left" valign="middle">
                                                <td width="39" bgcolor="#E7F0E2" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td bgcolor="#E7F0E2" style="height: 22px">
                                                <asp:Label ID=Label7 runat="server" Width="70px" ForeColor="#CC6600" CssClass="bodyheader">Date as of</asp:Label>
                                                </td>
                                                <td bgcolor="#E7F0E2" style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                <td style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td width="323" style="height: 22px"><span style="width: 167px">
                                                <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                                   
                                                </span></td>
                                                <td width="91" style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td height="2" colspan="3" bgcolor="#89A979"></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td bgcolor="#f3f3f3" class="bodycopy" style="width: 3px; height: 22px">&nbsp;</td>
                                                <td bgcolor="#f3f3f3" style="height: 22px">
                                                    <asp:Label ID=lblBranch runat="server" Height="0px" Width="70px" Visible="False" CssClass="bodyheader"> Branch</asp:Label>
                                                </td>
                                                <td bgcolor="#f3f3f3" style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td class="bodycopy" style="width: 3px; height: 22px">&nbsp;</td>
                                                <td style="height: 22px"><asp:DropDownList ID=DropDownList1 runat="server" Width="260px" Visible="False" BackColor="White" Font-Names="Verdana" Height="20px" CssClass="smallselect"></asp:DropDownList></td>
                                                <td style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="f3f3f3">
                                                <td style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td style="height: 22px">
                                                    <asp:Label ID=Label8 runat="server" Height="0px" Width="70px" CssClass="bodyheader"> Company</asp:Label>
                                                </td>
                                                <td style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22" align="left" bgcolor="#ffffff" colspan="2">
                                                    <!-- Start JPED -->
                                                    <asp:HiddenField runat="Server" ID="hCompanyAcct" Value="" />
                                                    <div id="lstCompanyNameDiv">
                                                    </div>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox runat="server" autocomplete="off" ID="lstCompanyName" name="lstCompanyName"
                                                                    value="" class="shorttextfield" Style="width: 350px; border-top: 1px solid #7F9DB9;
                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                                    color: #000000" onKeyUp="organizationFill(this,'All','lstCompanyNameChange')"
                                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCompanyName','All','lstCompanyNameChange')"
                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        </tr>
                                                    </table>
                                                    <!-- End JPED --></td>
                                            </tr>
                                            <tr align="left" bgcolor="#ffffff" valign="middle">
                                                <td height="22" style="width: 3px">
                                                </td>
                                                <td align="left" bgcolor="#ffffff" height="22">
                                                </td>
                                                <td align="center" bgcolor="#ffffff">
                                                    <asp:ImageButton ID=goBtn runat="server" designtimedragdrop="798" ImageUrl="../../../images/button_go.gif" OnClick="goBtn_Click1"></asp:ImageButton></td>
                                            </tr>
                                    </table>
                                <br /></td>
                            </tr>
                            <tr bgcolor="#89A979">
                                <td height="1" colspan="6" align="left" valign="middle"></td>
                            </tr>
                            <tr align="center" bgcolor="#cdcc9d">
                                <td height="22" colspan="6" valign="middle" bgcolor="#D5E8CB">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
            </table>
		    <asp:Button ID=btnValidate runat="server" Visible="False" Text="for Validation" OnClick="btnValidate_Click"></asp:Button>
		    <asp:LinkButton ID=LinkButton1 runat="server" Visible="False">LinkButton</asp:LinkButton>
			 </form>
		
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
