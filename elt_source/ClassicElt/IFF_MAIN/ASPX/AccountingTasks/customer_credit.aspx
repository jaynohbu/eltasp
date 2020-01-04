<%@ Page Language="C#" AutoEventWireup="true" CodeFile="customer_credit.aspx.cs" Inherits="ASPX_AccountingTasks_customer_credit" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >


<head runat="server">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<script type="text/javascript" src="../jScripts/JPED_NET.js"></script>
	<script type="text/javascript" src="../jScripts/MAWB_DROPDOWN.js"></script>
	<script type="text/javascript" src="../jScripts/WindowsManip.js"></script>
	<script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script> 
	<script type="text/javascript" language="JavaScript" src="../../ASP/ajaxFunctions/ajax.js"></script>
	<!--  #INCLUDE FILE="../include/common.htm" -->
    <title>Customer Credit Information</title>
    <script  type="text/javascript" language="JavaScript">
	function lstCustomerNameChange(orgNum,orgName)
	{ 
		//var infoObj = document.getElementById("txtCustomerInfo");
		var txtObj = document.getElementById("lstCustomerName");
		var divObj = document.getElementById("lstCustomerNameDiv")
	
		//infoObj.value = getOrganizationInfo(orgNum);
		document.getElementById("hCustomerAcct").value=orgNum;
		txtObj.value = orgName;
		divObj.style.position = "absolute";
		divObj.style.visibility = "hidden";
		form1.submit();
	}
	</script>
	<style type="text/css">
	<!--
	body {
		margin-left: 0px;
		margin-top: 0px;
		margin-right: 0px;
		margin-bottom: 0px;
	}
	-->
	</style>
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
<!--
.style1 {color: #cc6600}
-->
    </style>
</head>
<body style="text-align: right">
    <form id="form1" runat="server">  
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="56%" height="32" align="left" valign="middle" class="pageheader">
                Credit/refund to customer </td>
			<td width="44%" align="right" valign="baseline"><span class="labelSearch"></span>
                <asp:ScriptManager ID="ScriptManager1" runat="server">
                </asp:ScriptManager>
                &nbsp;<!-- Search -->
			</td>
		</tr>
	</table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px">
        <tr>
            <td height="10" align="center" valign="middle" bgcolor="#d5e8cb"></td>
        </tr>
        <tr>
            <td align="center" bgcolor="#f3f3f3" style="padding:24px 0 24px 0; border-top: 1px solid #89a979">
				<table width="65%" border="0" cellpadding="0" cellspacing="0" bordercolor="#89a979" bgcolor="#FFFFFF" 
					class="border1px" style="padding-left: 10px">
					<tr bgcolor="#E7F0E2">
						<td width="88" height="18" align="left" bgcolor="#E7F0E2" class="bodyheader">
                            Customer</td>
						<td width="172" align="left" class="bodyheader">&nbsp;</td>
						<td width="118" align="left" class="bodyheader">&nbsp;</td>
						<td width="182" align="left" class="bodyheader">Date</td>
						<td width="147" align="left" class="bodyheader">&nbsp;</td>
                    </tr>
					<tr>
						<td colspan="3" align="left" >                <!-- Start JPED -->
                                            <div  id="lstCustomerNameDiv" align=left  ></div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td align="left"><asp:TextBox type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName" 
                                                                        class="shorttextfield" style="width: 260px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; height: 12px;"  onKeyUp="organizationFill(this,'Customer','lstCustomerNameChange')"
                                                                        onfocus="initializeJPEDField(this);" runat="server" ForeColor="Black" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange')"
                                                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                                <td>
                                                                    <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                        onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                                        
                                                                        <td><br /></td>
                                                            </tr>
                                          </table>
                                                        
                                                        <!-- End JPED -->  </td>
						<td colspan="2" style="text-align: left">
                            <igtxt:WebDateTimeEdit ID="dDate" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
                                Fields="" ForeColor="Black" PromptChar=" " Width="180px">
                                <ButtonsAppearance CustomButtonDisplay="OnRight">
                                </ButtonsAppearance>
                                <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                            </igtxt:WebDateTimeEdit>
                        </td>
					</tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="2" colspan="5" align="left" bgcolor="#89a979" class="bodyheader style1"></td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td height="24" colspan="5" align="left">
                        <span class="bodyheader">
                            <asp:RadioButtonList ID="rCreditRefund" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">Credit</asp:ListItem>
                                <asp:ListItem>Refund</asp:ListItem>
                            </asp:RadioButtonList></span></td>
                    </tr>
                    
                    <tr bgcolor="#f3f3f3">
                        <td height="18" align="left" class="bodyheader style1"><span style="width: 269px; height: 17px; text-align: left"><span class="bodyheader">Current Credit Amt </span></span></td>
                        <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                        <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                        <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                        <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td colspan="4" align="left" class="bodycopy">
                            <asp:TextBox ID="txtCurrentCredit" runat="server" CssClass="readonlyright" ReadOnly="True" Width="80px">0.00</asp:TextBox>&nbsp;
                        </td>
                        <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                    </tr>
                    
                    <tr bgcolor="#f3f3f3">
                        <td height="18" align="left" ><span class="bodyheader">Description</span></td>
                        <td>&nbsp;</td>
                        <td align="left" class="bodyheader">Invoice No. </td>
                        <td align="left" class="bodyheader" style="text-align: left">Reference No. </td>
                        <td align="left" valign="middle" style="padding-right:25px"><span class="bodyheader"><span class="bodyheader style1">Amount</span></span></td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td colspan="2" align="left" ><span class="bodyheader">
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="shorttextfield" Width="220px" ForeColor="Black"></asp:TextBox>
                        </span></td>
						<td style="text-align: left">
                            <asp:TextBox ID="txtInvoiceNo" runat="server" CssClass="shorttextfield"></asp:TextBox></td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtRefNo" runat="server" CssClass="shorttextfield"></asp:TextBox></td>
                        <td align="left" valign="middle" style="padding-right:25px; text-align: left;"><span class="bodyheader">
                            <asp:TextBox ID="txtNewCredit" runat="server" CssClass="numberalignbold" Width="80px">0.00</asp:TextBox>
                        </span></td>
                    </tr>
                    <tr bgcolor="#f3f3f3">
                        <td height="22" colspan="5" align="center" ><asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/Images/button_go.gif" OnClick="btnAdd_Click" /></td>
                    </tr>
            	</table>			
			</td>
        </tr> 
        <tr>
            <td height="22" align="center" valign="middle" bgcolor="#d5e8cb" style="border-top: 1px solid #89a979">
                <asp:HiddenField ID="hCustomerAcct" runat="server" />
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="55%" align="right" valign="bottom" style="height: 7px"><div id="print"> 
         
                <a href="javascript:;" onclick="" style="cursor: pointer"></a>&nbsp;</div></td>
        </tr>
    </table>
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
    </form>    
       
    <script type="text/javascript" language="javascript">
	ig_initDropCalendar("CustomDropDownCalendar dDate");
</script>          
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
