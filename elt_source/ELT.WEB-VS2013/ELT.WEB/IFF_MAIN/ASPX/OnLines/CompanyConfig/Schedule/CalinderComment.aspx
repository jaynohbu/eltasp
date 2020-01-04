<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>CustomDays</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
  <!--  #INCLUDE FILE="../../../include/common.htm" -->
</HEAD>
	<body bgColor="#dcdcdc">
		<form id="CustomDaysForm" method="post" runat="server">
			<TABLE id="Table1" cellSpacing="0" cellPadding="1" width="100%" border="0" height="90%">
				<TR>
					<TD>
						<igsch:WebCalendar id="Calendar2" runat="server" DESIGNTIMEDRAGDROP="7" Width="100%">
<ClientSideEvents ValueChanging="dayChange" RenderDay="renderDay">
</ClientSideEvents>

<Layout PrevMonthText="-" FooterFormat="Today: {0:d}" NextMonthText="+" DropDownYearsNumber="10" ChangeMonthToDateClicked="True" ShowTitle="False" GridLineColor="SlateGray" ShowGridLines="Both">

<DayStyle Font-Bold="True" BackColor="WhiteSmoke">
</DayStyle>

<FooterStyle BorderWidth="2px" BorderStyle="Outset">
</FooterStyle>

<SelectedDayStyle BackColor="SteelBlue">
</SelectedDayStyle>

<OtherMonthDayStyle ForeColor="DarkGray">
</OtherMonthDayStyle>

<NextPrevStyle Width="18px" Height="20px" BorderWidth="2px" Font-Size="17pt" Font-Names="Impact" BorderColor="LightCyan" BorderStyle="Solid" BackColor="LightSteelBlue">

<BorderDetails ColorBottom="SlateGray" ColorRight="SlateGray">
</BorderDetails>

</NextPrevStyle>

<CalendarStyle Width="100%" Height="100%" BorderWidth="4px" Font-Size="9pt" Font-Names="Verdana" BorderColor="#505090" BorderStyle="Solid">

<BorderDetails ColorTop="148, 184, 190" ColorLeft="148, 184, 190">
</BorderDetails>

</CalendarStyle>

<DayHeaderStyle Height="15px" BackColor="LightSteelBlue">

<BorderDetails StyleBottom="Solid" ColorBottom="108, 108, 140" WidthBottom="4px">
</BorderDetails>

</DayHeaderStyle>

<TitleStyle BackColor="#C0D0F0">
</TitleStyle>

</Layout>

<AutoPostBack ValueChanged="True">
</AutoPostBack>
						</igsch:WebCalendar></TD>
					<TD width="1">
					</TD>
				</TR>
			</TABLE>
			<P><FONT face="±¼¸²">
						<TABLE id="Table2" cellSpacing="0" cellPadding="6" border="0" style="WIDTH: 1272px; HEIGHT: 321px">
  <TR>
    <TD align=center colSpan=3><asp:Button id="AddDay" runat="server" Text="Add/Remove Custom Day" Width="211px"></asp:Button></TD></TR>
  <TR>
    <TD align=center colSpan=3></TD></TR>
  <TR>
    <TD colSpan="3"><asp:Label id="Label2" runat="server" DESIGNTIMEDRAGDROP="9" Width="81px" Font-Size="9pt" Font-Names="Verdana">Date:</asp:Label></TD></TR>
  <TR>
    <TD><asp:DropDownList id="YearField" runat="server" Width="68px">
										<asp:ListItem Value="2000">2000</asp:ListItem>
										<asp:ListItem Value="2001">2001</asp:ListItem>
										<asp:ListItem Value="2002">2002</asp:ListItem>
										<asp:ListItem Value="2003">2003</asp:ListItem>
										<asp:ListItem Value="2004">2004</asp:ListItem>
										<asp:ListItem Value="2005">2005</asp:ListItem>
										<asp:ListItem Value="2006">2006</asp:ListItem>
										<asp:ListItem Value="2007">2007</asp:ListItem>
									</asp:DropDownList></TD>
    <TD><asp:DropDownList id="MonthField" runat="server" Width="84px">
										<asp:ListItem Value="January">January</asp:ListItem>
										<asp:ListItem Value="February">February</asp:ListItem>
										<asp:ListItem Value="March">March</asp:ListItem>
										<asp:ListItem Value="April">April</asp:ListItem>
										<asp:ListItem Value="May">May</asp:ListItem>
										<asp:ListItem Value="June">June</asp:ListItem>
										<asp:ListItem Value="July">July</asp:ListItem>
										<asp:ListItem Value="August">August</asp:ListItem>
										<asp:ListItem Value="September">September</asp:ListItem>
										<asp:ListItem Value="October">October</asp:ListItem>
										<asp:ListItem Value="November">November</asp:ListItem>
										<asp:ListItem Value="December">December</asp:ListItem>
									</asp:DropDownList></TD>
    <TD><asp:DropDownList id="DayField" runat="server" Width="50px">
										<asp:ListItem Value="1">1</asp:ListItem>
										<asp:ListItem Value="2" Selected="True">2</asp:ListItem>
										<asp:ListItem Value="3">3</asp:ListItem>
										<asp:ListItem Value="4">4</asp:ListItem>
										<asp:ListItem Value="5">5</asp:ListItem>
										<asp:ListItem Value="6">6</asp:ListItem>
										<asp:ListItem Value="7">7</asp:ListItem>
										<asp:ListItem Value="8">8</asp:ListItem>
										<asp:ListItem Value="9">9</asp:ListItem>
										<asp:ListItem Value="10">10</asp:ListItem>
										<asp:ListItem Value="11">11</asp:ListItem>
										<asp:ListItem Value="12">12</asp:ListItem>
										<asp:ListItem Value="13">13</asp:ListItem>
										<asp:ListItem Value="14">14</asp:ListItem>
										<asp:ListItem Value="15">15</asp:ListItem>
										<asp:ListItem Value="16">16</asp:ListItem>
										<asp:ListItem Value="17">17</asp:ListItem>
										<asp:ListItem Value="18">18</asp:ListItem>
										<asp:ListItem Value="19">19</asp:ListItem>
										<asp:ListItem Value="20">20</asp:ListItem>
										<asp:ListItem Value="21">21</asp:ListItem>
										<asp:ListItem Value="22">22</asp:ListItem>
										<asp:ListItem Value="23">23</asp:ListItem>
										<asp:ListItem Value="24">24</asp:ListItem>
										<asp:ListItem Value="25">25</asp:ListItem>
										<asp:ListItem Value="26">26</asp:ListItem>
										<asp:ListItem Value="27">27</asp:ListItem>
										<asp:ListItem Value="28">28</asp:ListItem>
										<asp:ListItem Value="29">29</asp:ListItem>
										<asp:ListItem Value="30">30</asp:ListItem>
										<asp:ListItem Value="31">31</asp:ListItem>
									</asp:DropDownList></TD></TR>
  <TR>
    <TD colSpan="3">
      <TABLE id="Table3" cellSpacing="0" cellPadding="0" border="0">
        <TR>
          <TD><asp:Label id="Label1" runat="server" Width="81px" Font-Size="9pt" Font-Names="Verdana">BackColor:</asp:Label></TD>
          <TD><asp:Label id="Label3" runat="server" Width="81px" Font-Size="9pt" Font-Names="Verdana">Image:</asp:Label></TD></TR>
        <TR>
          <TD><asp:DropDownList id="ColorField" runat="server" Width="105px">
													<asp:ListItem Value="None">None</asp:ListItem>
													<asp:ListItem Value="#C0C0FF">Light Blue-Purple</asp:ListItem>
													<asp:ListItem Value="#F0C0E0">Puce</asp:ListItem>
													<asp:ListItem Value="#A0D0A0">Off - Green</asp:ListItem>
													<asp:ListItem Value="Blue">Blue</asp:ListItem>
													<asp:ListItem Value="Red">Red</asp:ListItem>
													<asp:ListItem Value="Gray">Gray</asp:ListItem>
													<asp:ListItem Value="Green">Green</asp:ListItem>
												</asp:DropDownList></TD>
          <TD><asp:DropDownList id="ImageField" runat="server" Width="100px">
													<asp:ListItem Value="None">None</asp:ListItem>
													<asp:ListItem Value="bell.gif">bell.gif</asp:ListItem>
													<asp:ListItem Value="cal.gif">cal.gif</asp:ListItem>
													<asp:ListItem Value="chevy.gif">chevy.gif</asp:ListItem>
													<asp:ListItem Value="dollarsign.gif">dollarsign.gif</asp:ListItem>
													<asp:ListItem Value="reoccur.gif">reoccur.gif</asp:ListItem>
													<asp:ListItem Value="img2.gif">img2.gif</asp:ListItem>
													<asp:ListItem Value="soccer.gif">soccer.gif</asp:ListItem>
												</asp:DropDownList></TD></TR></TABLE></TD></TR>
  <TR>
    <TD style="HEIGHT: 31px" colSpan="3"><asp:CheckBox id="NoBell" runat="server" Text='Do not allow to select "Bell"' Width="252px" Font-Size="9pt" Font-Names="Verdana"></asp:CheckBox></TD></TR>
  <TR>
    <TD colSpan="3"><asp:Label id="ShowSelected" runat="server" Width="206px" Font-Size="9pt" Font-Names="Verdana" Height="92px"></asp:Label></TD></TR>
						</TABLE></FONT></P>
		</form>
	</body>
<!--  #INCLUDE FILE="../../../include/StatusFooter.htm" -->
</HTML>
