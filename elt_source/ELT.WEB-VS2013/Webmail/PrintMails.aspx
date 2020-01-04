<%@ Page Title="" Language="C#" MasterPageFile="~/Print.master" AutoEventWireup="true" CodeFile="PrintMails.aspx.cs" Inherits="PrintMails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ToolbarHolder" Runat="Server">
    <div class="ReportToolbarContainer">
        <dx:ReportToolbar ID="MailReportToolbar" runat="server" CssClass="ReportToolbar"
            ShowDefaultButtons="False" ReportViewerID="MailReportViewer" ClientInstanceName="ClientReportToolbar">
            <Items>
                <dx:ReportToolbarButton ItemKind="PrintReport" ToolTip="Print the report" />
                <dx:ReportToolbarButton ItemKind="PrintPage" ToolTip="Print the current page" />
                <dx:ReportToolbarButton ItemKind="FirstPage" ToolTip="First Page" />
                <dx:ReportToolbarButton ItemKind="PreviousPage" ToolTip="Previous Page" />
                <dx:ReportToolbarLabel Text="Page" />
                <dx:ReportToolbarComboBox ItemKind="PageNumber" Width="65px" />
                <dx:ReportToolbarLabel Text="of" />
                <dx:ReportToolbarTextBox IsReadOnly="True" ItemKind="PageCount" Width="30" />
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
    <dx:ReportViewer ID="MailReportViewer" runat="server" ReportName="MailReport" CssClass="Report" />
</asp:Content>
