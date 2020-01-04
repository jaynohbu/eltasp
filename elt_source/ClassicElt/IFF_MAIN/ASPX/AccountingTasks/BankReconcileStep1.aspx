<%@ Page Language="C#" ContentType="text/html" AutoEventWireup="true" CodeFile="BankReconcileStep1.aspx.cs" Inherits="ASPX_AccountingTasks_BankReconcileStep1" ResponseEncoding="iso-8859-1" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<title>Bank Reconcile</title>
<script type="text/javascript" src="../jScripts/ig_dropCalendar.js"></script>
<script src="../jScripts/stanley_J_function.js" type=text/javascript></script> 
<link href="../CSS/accountingStyle.css" rel="stylesheet" type="text/css" />
</head>
	<body>
		<form id="form1" runat="server">
		        <input type="image" style="width:0px; height:0px" onclick="return false;" />
			<!-- Header -->
			<div class="pageName">
				<h1>Bank Reconcile</h1>
				<p class="pageInfo">Enter the following from your statement, and then click Next.</p>
			</div>
			<div style="width:45%; min-width:430px">
				<div class="print">
					<a href="BankReconcileReport.aspx"><img src="/iff_main/ASP/Images/icon_printer.gif" />Reconcile Report</a>
				</div>
			</div>
			<!-- statement details -->
			<fieldset style="width:45%; min-width:430px">
			<!-- fieldset wrap -->
			<div class="wrapper">			
				<label for="ddlBankAcct" class="normalLabel"><img src="/iff_main/Images/requiredBar.gif" align="absbottom">Select Account</label>
					<asp:DropDownList ID="ddlBankAcct" runat="server" CssClass="smallselect" AutoPostBack="True" 
						OnSelectedIndexChanged="ddlBankAcct_SelectedIndexChanged" CellSpacing="1">
					</asp:DropDownList>
				<br /><br />
				<label for="txtOpeningBalance" class="normalLabel">Beginning Balance</label>
					<asp:TextBox ID="txtOpeningBalance" runat="server" onKeyPress="checkNum()" CssClass="nofield" ForeColor="Black">0.00</asp:TextBox>				
				<div style="width:45%; float:left">
					<label for="txtEndingBalance" class="normalLabel"><img src="/iff_main/Images/requiredBar.gif" align="absbottom">Statement Ending Balance</label>
						<asp:TextBox ID="txtEndingBalance" runat="server" onKeyPress="checkNum()" ForeColor="Black" CssClass="nofieldRequired">0.00</asp:TextBox>
				</div>
				<div style="float:left; width:50%">
					<label for="dStEnding" class="normalLabel">Statement Ending Date</label>
						<igtxt:WebDateTimeEdit ID="dStEnding" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
							Fields="" ForeColor="Black" PromptChar="" Width="178px" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1" UseBrowserDefaults="False" CssClass="dateText">
								<ButtonsAppearance CustomButtonDisplay="OnRight" CustomButtonDefaultTriangleImages="Arrow" CustomButtonDisabledImageUrl="[ig_edit_01b.gif]" CustomButtonImageUrl="[ig_edit_0b.gif]">
									<ButtonStyle BackColor="#C5D5FC" BorderColor="#ABC1F4" BorderStyle="Solid" BorderWidth="1px"
										Width="13px">
									</ButtonStyle>
									<ButtonDisabledStyle BackColor="#F1F1ED" BorderColor="#E4E4E4">
									</ButtonDisabledStyle>
									<ButtonHoverStyle BackColor="#DCEDFD">
									</ButtonHoverStyle>
									<ButtonPressedStyle BackColor="#83A6F4">
									</ButtonPressedStyle>
								</ButtonsAppearance>
								<SpinButtons Display="OnLeft" SpinOnReadOnly="True" DefaultTriangleImages="ArrowSmall" 
									LowerButtonDisabledImageUrl="[ig_edit_21b.gif]" LowerButtonImageUrl="[ig_edit_2b.gif]" 
										UpperButtonDisabledImageUrl="[ig_edit_11b.gif]" UpperButtonImageUrl="[ig_edit_1b.gif]" Width="15px" />
						</igtxt:WebDateTimeEdit>
				</div>
				<hr />
				<div style="float:left; width:45%">
					<label class="normalLabel">Bank Charge</label>
						<asp:TextBox ID="txtServiceCharge" runat="server" onKeyPress="checkNum()" ForeColor="Black" CssClass="nofield">0.00</asp:TextBox>
				</div>
				<div style="float:left; width:50%">		
					<label class="normalLabel">Date</label>
						<igtxt:WebDateTimeEdit ID="dServiceCharge" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
							Fields="" ForeColor="Black" PromptChar=" " Width="178px" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1" UseBrowserDefaults="False" CssClass="dateText">
								<ButtonsAppearance CustomButtonDisplay="OnRight" CustomButtonDefaultTriangleImages="Arrow" CustomButtonDisabledImageUrl="[ig_edit_01b.gif]" CustomButtonImageUrl="[ig_edit_0b.gif]">
									<ButtonStyle BackColor="#C5D5FC" BorderColor="#ABC1F4" BorderStyle="Solid" BorderWidth="1px"
										Width="13px">
									</ButtonStyle>
									<ButtonDisabledStyle BackColor="#F1F1ED" BorderColor="#E4E4E4">
									</ButtonDisabledStyle>
									<ButtonHoverStyle BackColor="#DCEDFD">
									</ButtonHoverStyle>
									<ButtonPressedStyle BackColor="#83A6F4">
									</ButtonPressedStyle>
								</ButtonsAppearance>
								<SpinButtons Display="OnLeft" SpinOnReadOnly="True" DefaultTriangleImages="ArrowSmall" 
									LowerButtonDisabledImageUrl="[ig_edit_21b.gif]" LowerButtonImageUrl="[ig_edit_2b.gif]" 
										UpperButtonDisabledImageUrl="[ig_edit_11b.gif]" UpperButtonImageUrl="[ig_edit_1b.gif]" Width="15px" />
						</igtxt:WebDateTimeEdit>
				</div>
				<div class="clear"></div>
				<div style="float:left; width:45%">
					<label class="normalLabel">Interest Earned</label>
						<asp:TextBox ID="txtInterestEarned" runat="server" onKeyPress="checkNum()" ForeColor="Black" CssClass="nofield">0.00</asp:TextBox>
				</div>
				<div style="float:left; width:50%">
					<label class="normalLabel">Date</label>
						<igtxt:WebDateTimeEdit ID="dInterestEarned" runat="server" AccessKey="e" EditModeFormat="MM/dd/yyyy"
							Fields="" ForeColor="Black" PromptChar=" " Width="178px" BorderColor="#7F9DB9" BorderStyle="Solid" BorderWidth="1px" CellSpacing="1" UseBrowserDefaults="False" CssClass="dateText">
								<ButtonsAppearance CustomButtonDisplay="OnRight" CustomButtonDefaultTriangleImages="Arrow" CustomButtonDisabledImageUrl="[ig_edit_01b.gif]" CustomButtonImageUrl="[ig_edit_0b.gif]">
									<ButtonStyle BackColor="#C5D5FC" BorderColor="#ABC1F4" BorderStyle="Solid" BorderWidth="1px"
										Width="13px">
									</ButtonStyle>
									<ButtonDisabledStyle BackColor="#F1F1ED" BorderColor="#E4E4E4">
									</ButtonDisabledStyle>
									<ButtonHoverStyle BackColor="#DCEDFD">
									</ButtonHoverStyle>
									<ButtonPressedStyle BackColor="#83A6F4">
									</ButtonPressedStyle>
								</ButtonsAppearance>
								<SpinButtons Display="OnLeft" SpinOnReadOnly="True" DefaultTriangleImages="ArrowSmall" LowerButtonDisabledImageUrl="[ig_edit_21b.gif]" LowerButtonImageUrl="[ig_edit_2b.gif]" UpperButtonDisabledImageUrl="[ig_edit_11b.gif]" UpperButtonImageUrl="[ig_edit_1b.gif]" Width="15px" />
						</igtxt:WebDateTimeEdit>
				</div>
				<div class="clear"></div>
			</div>	
			</fieldset>
			<!-- bottom button -->
			<div style="width:45%; margin:0; padding:0; min-width:430px">
			    <div id="buttonArea" style="text-align:right; float: right">
				    <ul>
					    <li><a href="javascript:function(){return false};"><span><asp:Button ID="btnOK" runat="server" OnClick="btnOK_Click" Text="Next &gt;" 
							    BorderStyle="None" BackColor="Transparent" CssClass="btnText" /></span></a>
					    </li>
					    <li><a href="javascript:function(){return false};"><span><asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" 
							    Text="Cancel" BorderColor="Gray" BorderStyle="None" BackColor="Transparent" CssClass="btnText" /></span></a>
					    </li>
				    </ul>					
			    </div>
			</div>
			<!-- for calendar layout -->		 
			<igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px">
				<Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
					ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
					<DayStyle BackColor="White" CssClass="CalDay" />
					<SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
					<OtherMonthDayStyle ForeColor="Silver" />
					<NextPrevStyle CssClass="NextPrevStyle" />
					<CalendarStyle CssClass="CalStyle">                    </CalendarStyle>
					<TodayDayStyle CssClass="CalToday" />
					<DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
						<BorderDetails StyleBottom="None" />
					</DayHeaderStyle>
					<TitleStyle CssClass="TitleStyle" Font-Bold="True" />
				</Layout>
			</igsch:WebCalendar><br />
			<asp:HiddenField ID="hGUID" runat="server" />
		</form>
		<script type="text/javascript" language="javascript">
			ig_initDropCalendar("CustomDropDownCalendar dStEnding dServiceCharge dInterestEarned");
		</script>
	</body>
</html>
