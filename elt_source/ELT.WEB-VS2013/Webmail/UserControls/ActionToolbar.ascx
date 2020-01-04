<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ActionToolbar.ascx.cs" Inherits="UserControls_ActionToolbar" %>
<table class="ActionToolbar"><tr>
<td class="Strut">
    <div style="float: left">
        <dx:ASPxImage ID="ExpandPaneImage" runat="server" Cursor="pointer" SpriteCssClass="Sprite_ExpandPane" ToolTip="Expand" AlternateText="Expand" ClientInstanceName="ClientExpandPaneImage">
            <ClientSideEvents Click="MailDemo.ClientExpandPaneImage_Click" />
        </dx:ASPxImage>
    </div>
    <div style="float: left">
        <dx:ASPxMenu ID="ActionMenu" runat="server" DataSourceID="ActionMenuDataSource"
            ShowAsToolbar="true" ClientInstanceName="ClientActionMenu" CssClass="ActionMenu" SeparatorWidth="0"
            OnItemDataBound="ActionMenu_ItemDataBound">
            <ClientSideEvents ItemClick="MailDemo.ClientActionMenu_ItemClick" />
            <Border BorderWidth="0" />
            <SubMenuStyle CssClass="SubMenu" />
        </dx:ASPxMenu>
    </div>
    <div style="float:right">
        <dx:ASPxMenu ID="InfoMenu" runat="server" DataSourceID="InfoMenuDataSource" ClientInstanceName="ClientInfoMenu"
            ShowAsToolbar="true" SeparatorWidth="0" CssClass="InfoMenu" OnItemDataBound="InfoMenu_OnItemDataBound">
            <ClientSideEvents ItemClick="MailDemo.ClientInfoMenu_ItemClick" />
            <Border BorderWidth="0" />
            <SubMenuStyle CssClass="SubMenu" />
        </dx:ASPxMenu>
    </div>
    <b class="clear"></b>
</td>
<td id="SearchBoxSpacer" class="Spacer" runat="server"><b></b></td>
<td>
    <dx:ASPxButtonEdit runat="server" ID="SearchBox" Width="220" Height="31" NullText="Type to Search..." CssClass="SearchBox" 
        ClientInstanceName="ClientSearchBox" Font-Size="12px">
        <ClientSideEvents 
            TextChanged="MailDemo.ClientSearchBox_TextChanged" 
            KeyDown="MailDemo.ClientSearchBox_KeyDown"
            KeyPress="MailDemo.ClientSearchBox_KeyPress"
        />
        <Buttons>
            <dx:EditButton>
                <Image>
                    <SpriteProperties CssClass="Sprite_Search"
                        HottrackedCssClass="Sprite_Search_Hover"
                        PressedCssClass="Sprite_Search_Pressed"
                        />
                </Image>
            </dx:EditButton>
        </Buttons>
        <ButtonStyle CssClass="SearchBoxButton" />
        <NullTextStyle Font-Italic="true" />
    </dx:ASPxButtonEdit>
</td>
</tr></table>
<asp:XmlDataSource ID="ActionMenuDataSource" runat="server" DataFile="~/App_Data/Actions.xml" />
<asp:XmlDataSource ID="InfoMenuDataSource" runat="server" DataFile="~/App_Data/InfoLayout.xml" XPath="Items/Item" />
