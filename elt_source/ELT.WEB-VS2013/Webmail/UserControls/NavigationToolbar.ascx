<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NavigationToolbar.ascx.cs" Inherits="UserControls_NavigationToolbar" %>
<table class="NavigationToolbar"><tr><td style="width: 100%">
    <dx:ASPxMenu ID="NavigationMenu" runat="server" CssClass="NavigationMenu"
        OnInit="NavigationMenu_Init" ShowAsToolbar="true" AppearAfter="5000">
        <ItemStyle Font-Size="28px" />
        <SubMenuStyle CssClass="SubMenu" />
        <SubMenuItemStyle Font-Size="15px" />
        <Border BorderWidth="0" />
    </dx:ASPxMenu>
</td><td>
    <dx:ASPxImage ID="CollapsePaneImage" runat="server" Cursor="pointer" SpriteCssClass="Sprite_CollapsePane" ToolTip="Collapse" AlternateText="Collapse" ClientInstanceName="ClientCollapsePaneImage">
        <ClientSideEvents Click="MailDemo.ClientCollapsePaneImage_Click" />
    </dx:ASPxImage>
</td></tr></table>
