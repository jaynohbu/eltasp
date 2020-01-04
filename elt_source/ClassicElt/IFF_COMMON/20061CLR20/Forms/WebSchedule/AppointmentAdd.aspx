<%@ Register TagPrefix="uc1" TagName="AppointmentAdd" Src="AppointmentAdd.ascx" %>
<%@ Page language="c#" Inherits="Forms.AppointmentAdd" CodeFile="AppointmentAdd.aspx.cs" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics2.WebUI.UltraWebToolbar.v6.1, Version=6.1.20061.28, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtab" Namespace="Infragistics.WebUI.UltraWebTab" Assembly="Infragistics2.WebUI.UltraWebTab.v6.1, Version=6.1.20061.28, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Appointment</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="./Styles/AppointmentDialog.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body language="javascript" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" bottomMargin="0" class="FormBackground" leftMargin="0" topMargin="0" rightMargin="0" onunload="return window_onunload()" XMLNS:igtab="http://schemas.infragistics.com/ASPNET/WebControls/UltraWebTab">
		<form id="Form1" method="post" runat="server">
			<table style="Z-INDEX: 101; LEFT: 0px; WIDTH: 100%; TOP: 0px; HEIGHT: 100%">
				<tr>
					<td height="28" style="HEIGHT: 28px">
						<igtbar:ultrawebtoolbar id="UltraWebToolbar2" runat="server" ItemWidthDefault=" " ImageDirectory=" " Width="100%">
							<HoverStyle Cursor="Hand" BackgroundImage="./Images/hover-bg.bmp" BackColor="#FFD695" TextAlign="Left">
								<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" ColorRight="ActiveCaption" WidthRight="1px" StyleRight="Solid" WidthBottom="1px"></BorderDetails>
							</HoverStyle>
							<ClientSideEvents Click="OKClicked"></ClientSideEvents>
							<SelectedStyle BackgroundImage="./Images/selected-bg.bmp" BackColor="#FF9D03" TextAlign="Left">
								<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" ColorRight="ActiveCaption" WidthRight="1px" StyleRight="Solid" WidthBottom="1px"></BorderDetails>
							</SelectedStyle>
							<Items>
								<igtbar:TBarButton Key="Save" ToolTip="Save and Close" Text="&lt;NOBR&gt;&lt;img margin:0;' igimg='1' src= './Images/save.gif' align ='AbsMiddle' &gt;&amp;nbsp; Save and Close &amp;nbsp;&lt;/NOBR&gt;" Image="">
									<HoverStyle Cursor="Hand"></HoverStyle>
									<DefaultStyle Width="100px" Cursor="Hand"></DefaultStyle>
								</igtbar:TBarButton>
								<igtbar:TBarButton Key="Print" ToolTip="Print" Image="./Images/print.gif">
									<HoverStyle Cursor="Hand"></HoverStyle>
									<DefaultStyle Width="20px"></DefaultStyle>
								</igtbar:TBarButton>
								<igtbar:TBarButton Key="Delete" ToolTip="Delete" Image="./Images/delete.gif">
									<HoverStyle Cursor="Hand"></HoverStyle>
									<DefaultStyle Width="20px"></DefaultStyle>
								</igtbar:TBarButton>
								<igtbar:TBarButton Key="Invite" ToolTip="Invite Attendees" Text="Invite Attendees" Visible="False" Image="./Images/mtgreq.gif">
									<HoverStyle Cursor="Hand"></HoverStyle>
									<DefaultStyle Width="110px"></DefaultStyle>
								</igtbar:TBarButton>
								<igtbar:TBButtonGroup>
									<Buttons>
										<igtbar:TBarButton ToggleButton="True" Key="High" ToolTip="Importance: High" Image="./Images/high.gif">
											<HoverStyle>
												<BorderDetails StyleRight="None"></BorderDetails>
											</HoverStyle>
											<SelectedStyle>
												<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" StyleRight="None" WidthBottom="1px"></BorderDetails>
											</SelectedStyle>
											<DefaultStyle Width="20px">
												<BorderDetails StyleRight="None"></BorderDetails>
											</DefaultStyle>
										</igtbar:TBarButton>
										<igtbar:TBarButton ToggleButton="True" Key="Low" ToolTip="Importance: Low" Image="./Images/low.gif">
											<HoverStyle Cursor="Hand"></HoverStyle>
											<SelectedStyle>
												<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" ColorRight="ActiveCaption" WidthRight="1px" StyleRight="Solid" WidthBottom="1px"></BorderDetails>
											</SelectedStyle>
											<DefaultStyle Width="20px">
												<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" ColorRight="ActiveCaption" StyleRight="Solid"></BorderDetails>
											</DefaultStyle>
										</igtbar:TBarButton>
									</Buttons>
								</igtbar:TBButtonGroup>
								<igtbar:TBarButton Key="Help" ToolTip="Help" Text="Help" Visible="False" Image="./Images/help.gif">
									<HoverStyle>
										<BorderDetails StyleRight="None"></BorderDetails>
									</HoverStyle>
									<SelectedStyle Cursor="Hand">
										<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" StyleRight="None" WidthBottom="1px"></BorderDetails>
									</SelectedStyle>
									<DefaultStyle Width="60px">
										<BorderDetails StyleRight="None"></BorderDetails>
									</DefaultStyle>
								</igtbar:TBarButton>
								<igtbar:TBarButton Enabled="False" Text="&amp;nbsp">
									<DefaultStyle Width="100%">
										<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" StyleRight="None"></BorderDetails>
									</DefaultStyle>
								</igtbar:TBarButton>
							</Items>
							<DefaultStyle Cursor="Hand" Font-Size="XX-Small" Font-Names="Tahoma" BorderStyle="None" BackgroundImage="./Images/default-bg.bmp" Height="24px" TextAlign="Left" CssClass="Fonts">
								<BorderDetails StyleBottom="Solid" ColorBottom="ActiveCaption" ColorRight="ActiveCaption" WidthRight="1px" StyleRight="Solid" WidthBottom="1px"></BorderDetails>
							</DefaultStyle>
						</igtbar:ultrawebtoolbar></td>
				</tr>
				<tr height="100%">
					<td><igtab:ultrawebtab id="UltraWebTab1" runat="server" width="100%" Height="100%" DummyTargetUrl=" ">
							<BorderDetails ColorTop="White" WidthTop="1px" StyleTop="Solid"></BorderDetails>
							<DefaultTabStyle Width="100px" Height="25px" BorderColor="White" CssClass="Fonts">
								<BorderDetails ColorTop="White" WidthTop="1px" ColorRight="154, 190, 238" WidthRight="1px" StyleTop="Solid" StyleRight="Solid"></BorderDetails>
							</DefaultTabStyle>
							<Tabs>
								<igtab:Tab Key="Appointment" Text="Appointment">
									
									<ContentPane UserControlUrl="AppointmentAdd.ascx"></ContentPane>
									<SelectedStyle Font-Bold="True"></SelectedStyle>
								</igtab:Tab>
							</Tabs>
						</igtab:ultrawebtab><A class="tbButton" id="delete" title="Delete" href="#" name="cbButton"></A></td>
				</tr>
			</table>
			<iframe id="printFrame" style="VISIBILITY: hidden" src="print.htm"></iframe>
		</form>
		<script language="javascript" src="./Scripts/ig_addAppointmentDialog.js"></script>
	</body>
</HTML>
