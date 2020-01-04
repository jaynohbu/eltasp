<%@ Page Title="" Language="C#" MasterPageFile="~/Print.master" AutoEventWireup="true" CodeFile="PrintSchedule.aspx.cs" Inherits="PrintSchedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ToolbarHolder" Runat="Server">
    <div class="ReportToolbarContainer">
        <dx:ReportToolbar ID="ScheduleReportToolbar" runat="server"  ClientInstanceName="ClientReportToolbar" CssClass="ReportToolbar"
            ShowDefaultButtons="False" ReportViewerID="ScheduleReportViewer">
            <Items>
                <dx:ReportToolbarButton ItemKind="PrintReport" ToolTip="Print the report" />
                <dx:ReportToolbarButton ItemKind="PrintPage" ToolTip="Print the current page" />
                <dx:ReportToolbarButton ItemKind="FirstPage" ToolTip="First Page" />
                <dx:ReportToolbarButton ItemKind="PreviousPage" ToolTip="Previous Page" />
                <dx:ReportToolbarLabel Text="Page" />
                <dx:ReportToolbarComboBox ItemKind="PageNumber" Width="65px" />
                <dx:ReportToolbarLabel Text="of" />
                <dx:ReportToolbarTextBox IsReadOnly="True" ItemKind="PageCount" />
                <dx:ReportToolbarButton ItemKind="NextPage" ToolTip="Next Page" />
                <dx:ReportToolbarButton ItemKind="LastPage" ToolTip="Last Page" />
                <dx:ReportToolbarButton ItemKind="SaveToDisk" ToolTip="Export a report and save it to the disk" />
                <dx:ReportToolbarButton ItemKind="SaveToWindow" ToolTip="Export a report and show it in a new window" />
                <dx:ReportToolbarComboBox ItemKind="SaveFormat" Width="70px">
                    <Elements>
                        <dx:ListElement Text="Pdf" Value="pdf" />
                        <dx:ListElement Text="Mht" Value="mht" />
                        <dx:ListElement Text="Image" Value="png" />
                    </Elements>
                </dx:ReportToolbarComboBox>
                <dx:ReportToolbarSeparator />
                <dx:ReportToolbarLabel Text="Start:" />
                <dx:ReportToolbarTemplateItem>
                    <Template>
                        <div class="dxtb-comboBoxMenuItem">
                            <dx:ASPxDateEdit ID="StartDateEdit" runat="server" ClientInstanceName="ClientPrintStartDateEdit" UseMaskBehavior="true" OnLoad="StartDateEdit_Load">
                                <ClientSideEvents DateChanged="MailDemo.PrintStartDateEdit_DateChanged" />
                            </dx:ASPxDateEdit>
                        </div>
                    </Template>
                </dx:ReportToolbarTemplateItem>
                <dx:ReportToolbarLabel Text="End:" />
                <dx:ReportToolbarTemplateItem>
                    <Template>
                        <div class="dxtb-comboBoxMenuItem">
                            <dx:ASPxDateEdit ID="EndDateEdit" runat="server" ClientInstanceName="ClientPrintEndDateEdit" UseMaskBehavior="true" OnLoad="EndDateEdit_Load">
                                <ClientSideEvents DateChanged="MailDemo.PrintEndDateEdit_DateChanged" />
                            </dx:ASPxDateEdit>
                        </div>
                    </Template>
                </dx:ReportToolbarTemplateItem>
            </Items>
            <Styles>
                <LabelStyle>
                    <Margins MarginLeft="3" MarginRight="3" />
                </LabelStyle>
            </Styles>
        </dx:ReportToolbar>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ReportHolder" Runat="Server">
    <dx:ReportViewer ID="ScheduleReportViewer" runat="server" ReportName="ContactReport" CssClass="Report" ClientInstanceName="ClientScheduleReportViewer" />
    <dx:ASPxScheduler runat="server" ID="Scheduler" Visible="false"
        AppointmentDataSourceID="AppointmentDataSource" 
        ResourceDataSourceID="ResourceDataSource">
        <Storage EnableReminders="False">
            <Appointments>
                <Mappings AppointmentId="ID" Type="Type" Start="StartDate" End="EndDate" AllDay="AllDay" 
                    Subject="Subject" Location="Location" Description="Description" Status="Status" Label="Label"
                    ResourceId="ResourceID" RecurrenceInfo="RecurrenceInfo" />
            </Appointments>
            <Resources>
                <Mappings ResourceId="ID" Caption="Name" />
            </Resources>
        </Storage>
        <OptionsBehavior ShowViewNavigator="false" ShowViewSelector="false" ShowViewVisibleInterval="false" />
    </dx:ASPxScheduler>
    <dx:ASPxSchedulerStoragePrintAdapter ID="PrintAdapter" runat="server" SchedulerControlID="Scheduler" />
    <asp:ObjectDataSource runat="server" ID="AppointmentDataSource" 
        DataObjectTypeName="SchedulerAppointmentObject" TypeName="SchedulerData"
        SelectMethod="GetAppointments" InsertMethod="Insert" UpdateMethod="Update" DeleteMethod="Delete" />
    <asp:ObjectDataSource runat="server" ID="ResourceDataSource" 
        DataObjectTypeName="SchedulerResourceObject" TypeName="SchedulerData" 
        SelectMethod="GetResources" />
</asp:Content>
