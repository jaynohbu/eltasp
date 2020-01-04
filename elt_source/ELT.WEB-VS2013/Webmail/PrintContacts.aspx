<%@ Page Title="" Language="C#" MasterPageFile="~/Print.master" AutoEventWireup="true" CodeFile="PrintContacts.aspx.cs" Inherits="PrintContacts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ToolbarHolder" Runat="Server">
    <div class="ReportToolbarContainer">
        <dx:ReportToolbar ID="ContactReportToolbar" runat="server" CssClass="ReportToolbar"
            ShowDefaultButtons="False" ReportViewerID="ContactReportViewer" ClientInstanceName="ClientReportToolbar">
            <Items>
                <dx:ReportToolbarButton ItemKind="PrintReport" ToolTip="Print the report" />
                <dx:ReportToolbarButton ItemKind="PrintPage" ToolTip="Print the current page" />
                <dx:ReportToolbarButton ItemKind="FirstPage" ToolTip="First Page" />
                <dx:ReportToolbarButton ItemKind="PreviousPage" ToolTip="Previous Page" />
                <dx:ReportToolbarLabel Text="Page" />
                <dx:ReportToolbarComboBox ItemKind="PageNumber" Width="65" />
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
                <dx:ReportToolbarSeparator />
                <dx:ReportToolbarLabel Text="Address Book:" />
                <dx:ReportToolbarTemplateItem>
                    <Template>
                        <div class="dxtb-comboBoxMenuItem" style="float: right">
                            <dx:ASPxComboBox ID="PrintAddressFilterCombo" runat="server" SelectedIndex="1">
                                <Items>
                                    <dx:ListEditItem Value="All" />
                                    <dx:ListEditItem Value="Personal" />
                                    <dx:ListEditItem Value="Collected" />
                                </Items>
                                <ClientSideEvents SelectedIndexChanged="MailDemo.PrintAddressFilterCombo_SelectedIndexChanged" />
                            </dx:ASPxComboBox>
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
    <dx:ReportViewer ID="ContactReportViewer" runat="server" ReportName="ContactReport" CssClass="Report" ClientInstanceName="ClientContactReportViewer" />
</asp:Content>
