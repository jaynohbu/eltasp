<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.SearchInvoiceSelection" trace="false" CodeFile="SearchInvoiceSelection.aspx.cs" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls" TagPrefix="iMoon" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>AccountingSelection</title>
		<META http-equiv=Content-Type content="text/html; charset=euc-kr">
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
		<SCRIPT src="../jScripts/WebDateSet1.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/ig_dropCalendar.js" type=text/javascript></SCRIPT>
		<SCRIPT src="../jScripts/ig_editDrop1.js" type=text/javascript></SCRIPT>

      <script src="../../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
<!--  #INCLUDE FILE="../../include/common.htm" -->
<style type="text/css">
<!--
body {
	margin: 0;
	padding: 0;
}
-->
</style>
<link href="../../CSS/elt_css.css" rel="stylesheet" type="text/css">
 <link href="../../CSS/AppStyle.css" rel="stylesheet" type="text/css">
  </HEAD>
	<BODY>
		<form id=form1 method=post runat="server">
			<script language=javascript>
<!--

function isNum(a) {

if(a.value == "") return true;

var number=parseInt(a.value,10);

if( number.toString()=="NaN") {
     alert('Please input a valid I/V No.');
	 return false;
 }
 else 
 {
 	 return true;
 }
}

function CheckDate() {

if( document.form1.ComboBox1.value != "") {
	document.form1.txtNum.value = document.form1.ComboBox1.selectedIndex;
	 return true;
}
if( document.form1.txtInvoiceNum.value != "") return true;
if( document.form1.txtHAWBNum.value != "") return true;
if( document.form1.txtMAWBNum.value != "") return true;
if( document.form1.txtRefNo.value != "") return true;
if( document.form1.txtFileNo.value != "") return true;

var	Wedit1 = igedit_getById('Webdatetimeedit1')
var    a=Wedit1.getValue();
		if(!a)  {
		alert(' Please input the from date!');
		return false;
		}
		
		return true;
		
}
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0

  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_goToURL() { //v3.0
  var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
  for (i=0; i<(args.length-1); i+=2) eval(args[i]+".location='"+args[i+1]+"'");
}
//-->
			</script>
			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="bottom" class="pageheader">Search Invoices</td>
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
                                    <br />
                                        <table width="58%" border="0" cellpadding="0" cellspacing="0" bordercolor="#89A979" class="border1px" id="Table2" style="padding-left:10px">
                                            <tr align="left" valign="middle" bgcolor="#E7F0E2">
                                                <td width="168" height="20" bgcolor="#E7F0E2" class="bodyheader">
                                                <asp:Label ID=Label2 runat="server" designtimedragdrop="43" Width="100%" CssClass="bodyheader">Invoice Date</asp:Label>                                                </td>
                                                <td width="159" align="left"><span class="bodyheader">From</span></td>
                                                <td width="78">&nbsp;</td>
                                                <td width="218"><asp:Label ID=Label1 runat="server" designtimedragdrop="3572" Height="0px" CssClass="bodyheader">To</asp:Label></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td class="bodyheader">
                                                    <uc1:rdselectdatecontrol1 id=RdSelectDateControl11 runat="server"></uc1:rdselectdatecontrol1>                                                </td>
                                                <td colspan="2" align="left"><igtxt:webdatetimeedit id=Webdatetimeedit1 accessKey=e runat="server" ForeColor="black" Width="180px"
											Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                </igtxt:webdatetimeedit></td>
                                                <td><igtxt:webdatetimeedit id=Webdatetimeedit2 accessKey=e runat="server" DESIGNTIMEDRAGDROP="142" ForeColor="black"
											Width="180px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" ">
                                                    <ButtonsAppearance CustomButtonDisplay="OnRight"></ButtonsAppearance>
                                                    <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                </igtxt:webdatetimeedit></td>
                                            </tr>
                                            <tr align="left" valign="middle">
                                                <td height="2" colspan="4" bgcolor="#89A979"></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="18" bgcolor="#f3f3f3">
                                                <asp:Label ID=Label8 runat="server" Width="100%" CssClass="bodyheader" ForeColor="#CC6600">Customer</asp:Label></td>
                                                <td>&nbsp;</td>
												<td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td colspan="3">
                                                    <asp:DropDownList ID="ComboBox1" runat="server"></asp:DropDownList>
																				</td>
												<td><asp:CheckBox ID=CheckBox1 runat="server" Width="100px" Text="A/R Only" CssClass="bodycopy"> </asp:CheckBox></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="f3f3f3">
                                                <td height="18"><asp:Label ID="Label11" runat="server" Width="100%" CssClass="bodyheader">Invoice No.</asp:Label></td>
                                                <td><asp:Label ID="Label7" runat="server" Width="100%" CssClass="bodyheader">Reference No. </asp:Label></td>
                                                <td colspan="2"><asp:Label ID="Label3" runat="server" Width="100%" CssClass="bodyheader">File No.</asp:Label></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="ffffff">
                                                <td><asp:TextBox BorderWidth="1px" CssClass="m_shorttextfield" ID=txtInvoiceNum runat="server" Width="100px"></asp:TextBox></td>
                                                <td><asp:TextBox BorderWidth="1px" CssClass="m_shorttextfield" ID="txtRefNo" runat="server" Width="100px"></asp:TextBox></td>
                                                <td colspan="2"><asp:TextBox BorderWidth="1px" CssClass="m_shorttextfield" ID="txtFileNo" runat="server"
                                            			Width="100px"></asp:TextBox></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="f3f3f3">
                                                <td height="18">
                                                <asp:Label ID=Label9 runat="server" Width="100%" CssClass="bodyheader">Import/Export</asp:Label></td>
                                                <td><asp:Label ID=Label10 runat="server" Width="100%" CssClass="bodyheader"> Air/Ocean</asp:Label></td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="ffffff">
                                                <td>
                                                    <asp:DropDownList ID=DropDownList1 runat="server" Width="100px" CssClass="bodycopy">
                                                        <asp:ListItem Value="All">All</asp:ListItem>
                                                        <asp:ListItem Value="Export">Export</asp:ListItem>
                                                        <asp:ListItem Value="Import">Import</asp:ListItem>
                                                    </asp:DropDownList>                                                </td>
                                                <td><asp:DropDownList ID=DropDownList2 runat="server" designtimedragdrop="1400" Width="100px" 
														CssClass="bodycopy">
                                                    <asp:ListItem Value="All">All</asp:ListItem>
                                                    <asp:ListItem Value="Air">Air</asp:ListItem>
                                                    <asp:ListItem Value="Ocean">Ocean</asp:ListItem>
                                                </asp:DropDownList></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="18">
                                                    <asp:Label ID="Label6" runat="server" Width="100%" CssClass="bodyheader"> MAWB No.</asp:Label>                                                </td>
                                                <td align="left" valign="middle"><asp:Label ID=Label5 runat="server" Width="100%" CssClass="bodyheader">HAWB No.</asp:Label></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr align="left" valign="middle" bgcolor="#ffffff">
                                                <td>
                                                    <asp:TextBox BorderWidth="1px" CssClass="m_shorttextfield" ID="txtMAWBNum" runat="server"
                                            Width="100px"></asp:TextBox>                                                </td>
                                                <td align="left" valign="middle" bgcolor="#ffffff">
                                                    <asp:TextBox BorderWidth="1px" CssClass="m_shorttextfield" ID=txtHAWBNum runat="server" Width="100px"></asp:TextBox>                                                </td>
                                                <td colspan="2"><asp:RadioButtonList ID=RadioButtonList1 runat="server" RepeatDirection="Horizontal" CssClass="bodycopy">
                                                    <asp:ListItem Value="Quick" Selected="True">Quick</asp:ListItem>
                                                    <asp:ListItem Value="Statistic">Statistic</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            </tr>
                                            
                                            
                                            <tr align="left" valign="middle" bgcolor="#f3f3f3">
                                                <td height="22">&nbsp;</td>
                                                <td align="left" valign="middle">                                                                                                    </td>
                                                <td align="right" style="padding-right:20px">&nbsp;</td>
                                                <td align="right" style="padding-right:20px"><asp:ImageButton ID=ImageButton1 runat="server" ImageUrl="../../../images/button_go.gif" OnClick="ImageButton1_Click1"></asp:ImageButton></td>
                                            </tr>
                                        </table>
                                        <br>
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
			<P><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><asp:textbox id=txtNum runat="server" Height="1px" Width="1px"></asp:textbox>
                <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px">
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
                <!-- end --></P>
			</form>
		<SCRIPT type=text/javascript>
		   
		        ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
		  
		</SCRIPT>
		<script>
		    var ComboBoxes = new Array();
		    $(document).ready(function() {
//		        $('.ComboBox').each(function() {
//		            if ($(this).attr('id').indexOf('Container') > 0) {
//		                ComboBoxes=$(this).attr('id').split('_')[0];
//		            }
//		        });
		    }
		);</script>
</BODY>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
