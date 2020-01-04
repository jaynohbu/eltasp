<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Feeds.aspx.cs" Inherits="Feeds" 
    EnableViewState="false" EnableSessionState="ReadOnly" %>
<asp:Content ID="Content1" ContentPlaceHolderID="SideHolder" Runat="Server">
    <dx:ASPxNavBar runat="server" ID="FeedNavBar" Width="100%" AllowSelectItem="true" 
        EnableAnimation="true" CssClass="FeedNavBar">
        <Groups>
            <dx:NavBarGroup Text="DevExpress">
                <Items>
                    <dx:NavBarItem Text="Blogs" Selected="true" />
                    <dx:NavBarItem Text="News" />
                    <dx:NavBarItem Text="Videos" />
                    <dx:NavBarItem Text="Webinars" />                    
                </Items>
            </dx:NavBarGroup>
            <dx:NavBarGroup Text="Misc">
                <Items>
                    <dx:NavBarItem Text="BBC News" />
                    <dx:NavBarItem Text="Engadget" />
                    <dx:NavBarItem Text="Stack Overflow" />
                </Items>
            </dx:NavBarGroup>
        </Groups>
        <ClientSideEvents ItemClick="MailDemo.ClientFeedNavBar_ItemClick" />
        <GroupHeaderStyle>
            <BorderLeft BorderWidth="0" />
            <BorderRight BorderWidth="0" />
        </GroupHeaderStyle>
        <GroupContentStyle>
            <BorderLeft BorderWidth="0" />
            <BorderRight BorderWidth="0" />
            <BorderBottom BorderWidth="0" />
        </GroupContentStyle>
        <Paddings Padding="0" />
        <Border BorderWidth="0" />
    </dx:ASPxNavBar>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainHolder" Runat="Server">
    <dx:ASPxGridView runat="server" ID="FeedGrid" ClientInstanceName="ClientFeedGrid" Width="100%" KeyFieldName="ID" EnableRowsCache="false"
        OnCustomCallback="FeedGrid_CustomCallback" 
        OnCustomColumnDisplayText="FeedGrid_CustomColumnDisplayText"
        Border-BorderWidth="0">
        <Columns>
            <dx:GridViewDataColumn FieldName="Title" />
            <dx:GridViewDataColumn FieldName="From" Width="200" />
            <dx:GridViewDataDateColumn FieldName="Date" Width="150" SortIndex="0" SortOrder="Descending">
                <PropertiesDateEdit DisplayFormatString="g" />
            </dx:GridViewDataDateColumn>
        </Columns>
        <Settings VerticalScrollBarMode="Auto" GridLines="Horizontal" ShowFooter="true" />
        <SettingsBehavior EnableRowHotTrack="True" />
        <SettingsPager Mode="ShowAllRecords" />
        <ClientSideEvents 
            RowClick="MailDemo.ClientFeedGrid_RowClick" />
        <Styles>
            <Row Cursor="pointer" />
        </Styles>
        <Templates>
            <FooterRow>
                Content is taken from the public <a href="<%= CurrentFeed.Links[0].Uri %>" target="_blank"><%= CurrentFeed.Title.Text %></a> feed
            </FooterRow>
        </Templates>
    </dx:ASPxGridView>
    
    <dx:ASPxCallbackPanel ID="FeedItemPreviewPanel" runat="server" RenderMode="Div" Height="100%" CssClass="FeedItemPreviewPanel" ClientInstanceName="ClientFeedItemPreviewPanel" ClientVisible="false"
        OnCallback="FeedItemPreviewPanel_Callback" />
</asp:Content>
