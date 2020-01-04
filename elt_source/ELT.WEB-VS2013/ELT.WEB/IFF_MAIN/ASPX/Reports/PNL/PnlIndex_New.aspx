<%--<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>--%>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.PNL.PnlIndex" trace="false" CodeFile="PnlIndex_New.aspx.cs" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>PNL Report Selection</title>
		<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">
		<meta content=C# name=CODE_LANGUAGE>	
		<script type="text/javascript" language="javascript" src="../../jScripts/JPED_NET.js"></script>	
		        <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
		<SCRIPT src="/IFF_MAIN/ASPX/jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
		<SCRIPT src="/IFF_MAIN/ASPX/jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
		<SCRIPT src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>
		<LINK href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type=text/css rel=stylesheet>
<!--  #INCLUDE FILE="../../include/common.htm" -->
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></HEAD>
	<BODY >
		<form id=form1 method=post runat="server">
		<input type="image" style="width:0px; height:0px" onclick="return false;" />
			<script language="javascript" >
<!--

function lstCustomerNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hCustomerAcct");          
            var txtObj = document.getElementById("lstCustomerName");
            var divObj = document.getElementById("lstCustomerNameDiv")    
            hiddenObj.value = orgNum;           
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";           
            //form1.submit();            
        }



function CheckDate() {

if( document.form1.cmbCustomer.value != "") {
	document.form1.txtCustomerNum.value = document.form1.cmbCustomer.selectedIndex;
}

if( document.form1.txtRefNum1.value != "") return true;
if( document.form1.txtRefNum2.value != "") return true;
if( document.form1.txtMAWB.value != "") return true;

var	Wedit1 = igedit_getById('Webdatetimeedit1')
var    a=Wedit1.getValue();
		if(!a)  {
		alert(' Please input the period!');
		return false;
		}
return true;
}
//-->
            </script>
			<%     string windowName = Request.QueryString["WindowName"];
          if (Request.UrlReferrer != null && windowName != "PopWin" && windowName != "popupfavorite")
          { 
Server.Execute("/ASP/tabs/acct_reports_subs_aspx.htm");
}%>
			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="bottom" class="pageheader">Profit &amp; Loss Report </td>
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
                                    <table border="0" cellspacing="0" cellpadding="0" style="width: 78%; height: 29px">
                                    <tr>
                                        <td height="28" align="right" >
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                                    <table width="60" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px">
                                            <tr align="left" valign="middle">
                                                <td bgcolor="#E7F0E2" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td height="20" bgcolor="#E7F0E2" class="bodyheader">
                                                <asp:Label ID=Label2 runat="server" designtimedragdrop="43" CssClass="bodyheader">Selection Period</asp:Label></td>
                                                <td bgcolor="#E7F0E2"><span class="bodyheader"><img src="/ASP/Images/required.gif" align="absbottom">From</span></td>
                                                <td bgcolor="#E7F0E2"><span class="bodyheader">To</span></td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td bgcolor="#FFFFFF" style="height: 22px; width: 3px;">&nbsp;</td>
                                                <td valign="middle" bgcolor="#FFFFFF" class="bodyheader">
												<span style="width:110px">
												<uc1:rdselectdatecontrol1 id=RdSelectDateControl11 runat="server"></uc1:rdselectdatecontrol1></span>												</td>
                                                <td bgcolor="#FFFFFF"><igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="Black" Width="167px"
											Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                </igtxt:webdatetimeedit></td>
                                                <td bgcolor="#FFFFFF"><igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" DESIGNTIMEDRAGDROP="142" ForeColor="Black"
											Width="167px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                </igtxt:webdatetimeedit></td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td height="1" colspan="4" bgcolor="#89A979"></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td bgcolor="#f3f3f3" class="bodycopy" style="width: 3px; height: 22px">&nbsp;</td>
                                                <td bgcolor="#f3f3f3" style="width: 62px; height: 22px;"><span style="width: 100px;">
                                                    <asp:Label ID="Label13" runat="server" Width="100%" CssClass="bodyheader">MAWB or Master B/L No.</asp:Label>
                                                </span></td>
                                                <td bgcolor="#f3f3f3" style="height: 22px; width: 341px;"><span style="width: 62px; height: 22px"><span style="width: 100px;">
                                                    <asp:Label ID="Label14" runat="server" Width="100%" CssClass="bodyheader">File No.</asp:Label>
                                                </span></span></td>
                                                <td bgcolor="#f3f3f3" style="height: 22px"></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td class="bodycopy" style="width: 3px; height: 22px">&nbsp;</td>
                                                <td style="width: 62px; height: 22px;"><span style="width: 341px"><span style="height: 3px">
                                                    <asp:TextBox ID="txtMAWB" runat="server" BorderWidth="1px" Width="158px" CssClass="m_shorttextfield"></asp:TextBox>
                                                </span></span></td>
                                                <td style="height: 22px; width: 341px;"><span style="height: 3px">
                                                    <asp:TextBox ID="txtRefNum2" runat="server" BorderWidth="1px"
                                            Width="120px" CssClass="m_shorttextfield"></asp:TextBox>
                                                </span></td>
                                                <td style="height: 22px"><span style="width: 62px; height: 22px;"><span style="height: 22px; width: 341px;"></span></span></td>
                                            </tr>
                                            
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22"><span style="width: 100px;">
                                                    <asp:Label ID=Label8 runat="server" Width="100%" CssClass="bodyheader">Customer/Agent</asp:Label>
                                                </span></td>
                                                <td height="22" align="left" valign="middle" style="width: 341px"><span style="width: 100px">
                                                    <asp:Label ID=Label9 runat="server" Width="100%" CssClass="bodyheader">Import/Export</asp:Label>
                                                </span></td>
                                                <td align="left"><span style="width: 100px">
                                                    <asp:Label ID=Label10 runat="server" Width="100%" CssClass="bodyheader"> Air/Ocean</asp:Label>
                                                </span></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td bgcolor="#FFFFFF" style="width: 3px; height: 22px;">&nbsp;</td>
                                                <td bgcolor="#FFFFFF" style="height: 22px"> <!-- Start JPED -->
                                                        <input type="hidden" id="hCustomerAcct" runat="server" name="hCustomerAcct" value="0" />
                                                        <div id="lstCustomerNameDiv">                                                        </div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" value=""
                                                                        class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this,event);" runat="server" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                                        
                                                                        <td></td>
                                                            </tr>
                                                        </table>
                                                        
                                                        <!-- End JPED -->  
                                                </td>
                                                <td align="left" valign="middle" bgcolor="#FFFFFF" style="width: 341px; height: 22px;"><asp:DropDownList ID=DropDownList1 runat="server" Width="110px" CssClass="bodycopy">
                                                    <asp:ListItem Value="All">All</asp:ListItem>
                                                    <asp:ListItem Value="Export">Export</asp:ListItem>
                                                    <asp:ListItem Value="Import">Import</asp:ListItem>
                                                </asp:DropDownList></td>
                                                <td align="left" bgcolor="#FFFFFF" style="height: 22px"><span style="width: 341px">
                                                    <asp:DropDownList ID=DropDownList2 runat="server" designtimedragdrop="1400" Width="110px" CssClass="bodycopy">
                                                        <asp:ListItem Value="All">All</asp:ListItem>
                                                        <asp:ListItem Value="Air">Air</asp:ListItem>
                                                        <asp:ListItem Value="Ocean">Ocean</asp:ListItem>
                                                    </asp:DropDownList>
                                                </span></td>
                                            </tr>
                                            
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22"><span style="width: 100px">
                                                    <asp:Label ID="Label5" runat="server" Width="100%" CssClass="bodyheader">Route </asp:Label>
                                                </span></td>
                                                <td height="22" align="left" valign="middle" style="width: 341px"><span style="width: 100px">&nbsp;</span></td>
                                                <td align="right">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22"><table border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td><asp:Label ID="Label7" runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodycopy">From</asp:Label>                                                        </td>
                                                        <td><asp:Label ID="Label6" runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodycopy">To</asp:Label>                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 130px">
                                                            <asp:DropDownList ID="ddlPortOfLoading" runat="server" CssClass="smallselect" DataTextField="Port_desc"
                                                                DataValueField="Port_code" Width="200px">
                                                            </asp:DropDownList></td>
                                                        <td style="width: 130px">
                                                            <asp:DropDownList ID="ddlPortOfDischarge" runat="server" CssClass="smallselect" DataTextField="Port_desc"
                                                                DataValueField="Port_code" Width="200px">
                                                            </asp:DropDownList></td>
                                                    </tr>
                                                </table></td>
                                                <td height="22" align="left" valign="middle" bgcolor="#ffffff" style="width: 341px"><table border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td style="height: 13px"><span style="width: 159px">&nbsp;</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                    </tr>
                                                </table></td>
                                                <td align="right" bgcolor="#ffffff">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22"><span style="width: 100px">&nbsp;</span></td>
                                                <td height="22" align="left" valign="middle" bgcolor="#ffffff" style="width: 341px"><table border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><span style="WIDTH: 159px">&nbsp;</span></td>
    </tr>
    <tr>
        <td style="height: 18px"></td>
</tr>
</table></td>
                                                <td align="right" bgcolor="#ffffff">&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="22" style="width: 3px">&nbsp;</td>
                                                <td height="22"><span style="width: 100px">&nbsp;</span></td>
                                                <td height="22" align="left" valign="middle" style="width: 341px"></td>
                                                <td align="right"><span style="width: 120px">
                                                    <asp:ImageButton ID=btnGo runat="server" ImageUrl="../../../images/button_go.gif" OnClick="btnGo_Click" ></asp:ImageButton>
                                                <img src="/ASP/Images/spacer.gif" width="18" height="12">                                                </span></td>
                                            </tr>
                                    </table>
                                <br /></td>
                            </tr>
                            <tr bgcolor="#89A979">
                                <td height="1" colspan="6" align="left" valign="middle"></td>
                            </tr>
                            <tr align="center" bgcolor="#cdcc9d">
                                <td height="20" colspan="6" valign="middle" bgcolor="#D5E8CB">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
            </table>
			
			<P><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><asp:textbox id=txtCustomerNum runat="server" Height="1px" Width="1px"></asp:textbox>&nbsp;
                <!-- end --></P>
			<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="167px">
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
        </igsch:WebCalendar></form>
		<SCRIPT type=text/javascript>
			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
		</SCRIPT>
	</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
