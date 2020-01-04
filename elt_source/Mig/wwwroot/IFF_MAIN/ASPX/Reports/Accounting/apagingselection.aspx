<%--<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>--%>
<%@ Register TagPrefix="igtab" Namespace="Infragistics.WebUI.UltraWebTab" Assembly="Infragistics.WebUI.UltraWebTab, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.APAgingSelection" trace="false" CodeFile="APAgingSelection.aspx.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
		<title>APAgingSelection</title>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
		<meta content="C#" name="CODE_LANGUAGE" />
		<meta content="JavaScript" name="vs_defaultClientScript" />
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
		<script src="../jScripts/ig_dropCalendar.js" type="text/javascript"></script>
		<script src="../jScripts/ig_editDrop1.js" type="text/javascript"></script>
		<script src="../../../ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>
        <script src="../../../ASP/Include/JPED.js" type="text/javascript"></script>
        <script src="../../../ASP/Include/JPTableDOM.js" type="text/javascript"></script>
        <link href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
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
    <!--  #INCLUDE FILE="../../include/common.htm" -->
    </head>
	<body style="margin:0px 0px 0px 0px">
		<form id="form1" method="post" runat="server">
		   <input type="image" style="width:0px; height:0px; position:absolute" onclick="return false;" />
		    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="bottom" class="pageheader">A/P Aging</td>
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
                                <td colspan="6" valign="middle" bgcolor="#f3f3f3"><br />
                                        <table width="40%" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px">
                                            <tr align="left" valign="middle">
                                                <td bgcolor="#E7F0E2" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td bgcolor="#E7F0E2" style="width: 167px;">
                                                    <asp:Label ID=Label7 runat="server" Height="0px" Width="70px" ForeColor="#CC6600" CssClass="bodyheader">Date as of</asp:Label>
                                                </td>
                                                <td bgcolor="#E7F0E2" style="width: 167px;">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td bgcolor="#FFFFFF" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td width="225" bgcolor="#FFFFFF" style="width: 150px;"><igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" Width="100%" ForeColor="black"
												PromptChar=" " EditModeFormat="MM/dd/yyyy" Fields="">
												<ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
												<SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
											</igtxt:webdatetimeedit></td>
                                                <td width="209" bgcolor="#FFFFFF" style="width: 167px;">&nbsp;</td>
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
                                                <td bgcolor="#ffffff" class="bodycopy" style="height: 22px"><asp:DropDownList ID="DropDownList1" runat="server" BackColor="White" CssClass="smallselect"
                                                        Visible="False" Width="260px"></asp:dropdownlist></td>
                                                <td style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="f3f3f3">
                                                <td style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td style="height: 22px">
                                                    <asp:Label ID=Label8 runat="server" Height="0px" Width="70px" CssClass="bodyheader"> Company</asp:Label>
                                                </td>
                                                <td style="height: 22px">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="f3f3f3">
                                                <td bgcolor="#FFFFFF" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td bgcolor="#FFFFFF" style="height: 22px" colspan="2">
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
                                                                    onfocus="initializeJPEDField(this);" /></td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCompanyName','All','lstCompanyNameChange')"
                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        </tr>
                                                    </table>
                                                    <!-- End JPED -->
                                                </td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td style="width: 3px; height: 22px;">&nbsp;</td>
                                                <td align="left" bgcolor="#ffffff" style="height: 22px">
                                                    <asp:CheckBox ID="CheckUnposted" runat="server" Text="Include Unposted transactions" CssClass="bodycopy" /></td>
                                                <td align="center" bgcolor="#ffffff" style="height: 22px"><asp:ImageButton ID=ImageButton2 runat="server" ImageUrl="../../../images/button_go.gif" OnClick="ImageButton2_Click1"></asp:ImageButton></td>
                                            </tr>
                                    </table>
                                <br /></td>
                            </tr>
                            <tr bgcolor="#89A979">
                                <td height="1" colspan="6" align="left" valign="middle"></td>
                            </tr>
                            <tr align="center" bgcolor="#cdcc9d">
                                <td colspan="6" valign="middle" bgcolor="#D5E8CB" style="height: 22px">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
            </table>
			 <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="150px">
                    <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                        ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                        <DayStyle BackColor="White" CssClass="CalDay" />
                        <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                        <OtherMonthDayStyle ForeColor="Silver" />
                        <NextPrevStyle CssClass="NextPrevStyle" />
                        <CalendarStyle CssClass="CalStyle">
                        </CalendarStyle>
                        <TodayDayStyle CssClass="CalToday" />
                        <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                            <BorderDetails StyleBottom="None" />
                        </DayHeaderStyle>
                        <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
                    </Layout>
                </igsch:WebCalendar>
		</form>
		<script type="text/javascript">
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit2");
		</script>
</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
