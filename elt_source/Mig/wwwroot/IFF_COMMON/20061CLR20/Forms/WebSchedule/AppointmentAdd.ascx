 <%@ Register TagPrefix="cmb" NameSpace="Forms" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics2.WebUI.WebDateChooser.v6.1, Version=6.1.20061.28, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Control Language="c#" Inherits="Forms.AppointmentAddUC" CodeFile="AppointmentAdd.ascx.cs" %>
<TABLE class="BackgroundTab" id="AddAppointmentTable" style="WIDTH: 100%; BORDER-COLLAPSE: collapse; HEIGHT: 100%" cellSpacing="0" cellPadding="0">
	<TR>
		<TD style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; HEIGHT: 69px">
			<TABLE style="" cellSpacing="0" cols="2" cellPadding="0" width="100%">
				<TR width="100%">
					<TD vAlign="top" noWrap ><label class="Fonts" id="SubjectLabel"  for="tbSubject">Subject:&nbsp;</label></td>
					<td style="width:100%">
						<INPUT tabindex="1" class="Fonts" id="tbSubject" style="WIDTH: 100%" type="text">
					</TD>
				</TR>
				<TR width="100%">
					<TD vAlign="top" noWrap ><label class="Fonts" id="LocationLabel"  for="tbLocation">Location:</label>
					</td>
					<td align=left style="width:100%;">
						<INPUT tabindex="2" class="Fonts" id="tbLocation" style="WIDTH: 100%" type="text">
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR width="100%">
		<TD style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px">
			<TABLE style="OVERFLOW: hidden" cellSpacing="0" cellPadding="0" width="100%">
				<TR style="height:22px; width:100%;">
					<TD style="WIDTH: 55px" noWrap>
						<DIV class="Fonts" id="StartTimeLabel" noWrap>Start Time:</DIV>
					</TD>
					<TD style="WIDTH: 110px"><span style="WIDTH: 110px"><igsch:webdatechooser TabIndex="3" id="wdcStartTime" style="DISPLAY: inline" width="100%" runat="server">
								<EditStyle CssClass="Fonts">
									<Padding Bottom="0px" Top="0px" Right="0px"></Padding>
									<Margin Bottom="0px" Top="0px" Right="0px"></Margin>
								</EditStyle>
								<ClientSideEvents ValueChanged="wdcStartTime_ValueChanged"></ClientSideEvents>
								<CalendarLayout MaxDate="" ShowYearDropDown="False" ShowMonthDropDown="False" ShowFooter="False">
									<CalendarStyle Width="100%" Height="100%" CssClass="Fonts"></CalendarStyle>
									<TitleStyle BackColor="#C3DAF9"></TitleStyle>
								</CalendarLayout>
								<DropButton ImageUrl2="./images/clearpixel.gif" ImageUrl1="./images/clearpixel.gif">
									<Style>

<Padding Bottom="0px" Left="0px" Top="0px" Right="0px">
</Padding>

<Margin Bottom="0px" Left="0px" Top="0px" Right="0px">
</Margin>

									</Style>
								</DropButton>
							</igsch:webdatechooser></span></TD>
					<td width="15">
						<div style="WIDTH: 15px"><BUTTON style="WIDTH: 15px; HEIGHT: 20px" onclick="DropDown_Cal1()" type="button"><IMG src="./Images/downarrow.gif"></BUTTON>
						</div>
					</td>
					<TD id="startTime" style="WIDTH: 100px"><cmb:combobox TabIndex="4" id="ddStartTime" runat="server"></cmb:combobox></TD>
					<TD style="WIDTH: 15px"><input id="cbAllDayEvent" onclick="cbAllDayEvent_Clicked()" type="checkbox" tabindex="5">
					</TD>
					<td style="WIDTH: 100%" noWrap>
						<div class="Fonts" id="AllDayEventLabel" style="DISPLAY: inline">All day event</div>
					</td>
				</TR>
				<TR style="height:20px; width:100%;">
					<TD style="WIDTH: 55px" noWrap>
						<DIV class="Fonts" id="EndTimeLabel" noWrap>End Time:</DIV>
					</TD>
					<TD style="WIDTH: 110px" noWrap><span style="WIDTH: 110px"><igsch:webdatechooser TabIndex="6" id="wdcEndTime" style="DISPLAY: inline" width="100%" runat="server">
								<EditStyle CssClass="Fonts">
									<Padding Bottom="0px" Top="0px" Right="0px"></Padding>
									<Margin Bottom="0px" Top="0px" Right="0px"></Margin>
								</EditStyle>
								<ClientSideEvents ValueChanged="wdcEndTime_ValueChanged"></ClientSideEvents>
								<CalendarLayout MaxDate="" ShowYearDropDown="False" ShowMonthDropDown="False" ShowFooter="False">
									<CalendarStyle Width="100%" Height="100%" CssClass="Fonts"></CalendarStyle>
									<TitleStyle BackColor="#C3DAF9"></TitleStyle>
								</CalendarLayout>
								<DropButton ImageUrl2="./images/clearpixel.gif" ImageUrl1="./images/clearpixel.gif">
									<Style>

<Padding Bottom="0px" Left="0px" Top="0px" Right="0px">
</Padding>

<Margin Bottom="0px" Left="0px" Top="0px" Right="0px">
</Margin>

									</Style>
								</DropButton>
							</igsch:webdatechooser></span></TD>
					<td width="15">
						<div style="WIDTH: 15px"><BUTTON style="WIDTH: 15px; HEIGHT: 20px" onclick="DropDown_Cal2()" type="button"><IMG src="./Images/downarrow.gif"></BUTTON>
						</div>
					</td>
					<TD id="endTime" style="WIDTH: 100px" noWrap><cmb:combobox id="ddEndTime" runat="server" TabIndex="7"></cmb:combobox></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; HEIGHT: 47px">
			<TABLE id="Table2" style="PADDING-RIGHT: 5px; FONT-SIZE: 100%; WIDTH: 100%; POSITION: relative">
				<TR id="rem_busy" style="PADDING-RIGHT: 5px; WIDTH: 100%; POSITION: relative">
					<TD noWrap><INPUT tabindex="8" id="cbReminder" onclick="cbReminder_Clicked()" type="checkbox" name="Checkbox1"><span class="Fonts" id="ReminderLabel">Reminder</span></TD>
					<TD><SELECT class="Fonts" id="ddReminder" tabindex="9">
							<OPTION selected>0 minutes</OPTION>
							<OPTION>5 minutes</OPTION>
							<OPTION>10 minutes</OPTION>
							<OPTION>15 minutes</OPTION>
							<OPTION>30 minutes</OPTION>
							<OPTION>1 hour</OPTION>
							<OPTION>2 hours</OPTION>
							<OPTION>4 hours</OPTION>
							<OPTION>8 hours</OPTION>
							<OPTION>0.5 days</OPTION>
							<OPTION>1 day</OPTION>
							<OPTION>2 days</OPTION>
						</SELECT>
					</TD>
					<TD noWrap><asp:label id="ShowTimeAsLabel" runat="server" CssClass="Fonts">Show time as:</asp:label>&nbsp;
					</TD>
					<TD width="100%"><SELECT tabindex="10" class="Fonts" id="ddShowTimeAs" name="Select1">
							<OPTION selected>Free</OPTION>
							<OPTION>Tentative</OPTION>
							<OPTION>Out of Office</OPTION>
							<OPTION>Busy</OPTION>
						</SELECT>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR id="TAB1" vAlign="top" height="100%">
		<TD style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px">
			<DIV id="prnMsgBody" style="DISPLAY: none"></DIV>
			<TEXTAREA tabindex="11" class="Fonts" id="txtMsgBody" style="WIDTH: 100%; HEIGHT: 100%" name="txtMsgBody" rows="22" cols="96" onchange="this.dirty='1'" dirty="0"></TEXTAREA>
		</TD>
	</TR>
</TABLE>
