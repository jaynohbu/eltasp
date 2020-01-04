<%@ Page  Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" 
    EnableViewState="False" %>
<asp:Content ID="Content1" ContentPlaceHolderID="SideHolder" Runat="Server" EnableViewState="true" >
    <dx:ASPxTreeView runat="server" ID="MailTree" ClientInstanceName="ClientMailTree" AllowSelectNode="True" CssClass="MailTree"
        OnCustomJSProperties="MailTree_CustomJSProperties">
        <Nodes>
            <dx:TreeViewNode Text="Inbox"   Name="Inbox" Expanded="True" Image-SpriteProperties-CssClass="Sprite_Inbox" >
                <Nodes>
                    <dx:TreeViewNode Text="Notice" Name="Notice"  />
                    <dx:TreeViewNode Text="Announcements" Name="Announcements" />
                    <dx:TreeViewNode Text="Pre Alert" Name="PreAlert" />
                    <dx:TreeViewNode Text="Etc." Name="Etc"  />
                </Nodes>
            </dx:TreeViewNode>
            <dx:TreeViewNode Text="Sent Items" Name="Sent Items" Image-SpriteProperties-CssClass="Sprite_SentItems" />
            <dx:TreeViewNode Text="Drafts" Name="Drafts" Image-SpriteProperties-CssClass="Sprite_Drafts" />
        </Nodes>
        <ClientSideEvents Init="MailDemo.ClientMailTree_Init" NodeClick="MailDemo.ClientMailTree_NodeClick" />
    </dx:ASPxTreeView>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainHolder" Runat="Server">
    <dx:ASPxGridView runat="server" ID="MailGrid"
        ClientInstanceName="ClientMailGrid" Width="100%" KeyFieldName="ID" EnableRowsCache="false" 
        OnCustomCallback="MailGrid_CustomCallback"
        OnCustomDataCallback="MailGrid_CustomDataCallback"
        OnCustomColumnDisplayText="MailGrid_CustomColumnDisplayText" 
        OnCustomGroupDisplayText="MailGrid_CustomGroupDisplayText"
        OnCustomJSProperties="MailGrid_CustomJSProperties"
        Border-BorderWidth="0">
        <Columns>
            <dx:GridViewCommandColumn ShowSelectCheckbox="true" Width="50" VisibleIndex="0" />
            <dx:GridViewDataColumn FieldName="HasAttachment" Width="50" VisibleIndex="1">
                <Settings AllowGroup="False" />
                <HeaderCaptionTemplate>
                    <dx:ASPxImage ID="I" runat="server" SpriteCssClass='<%# Utils.IsDarkTheme ? "Sprite_Attachment_Light" : "Sprite_Attachment" %>' />
                </HeaderCaptionTemplate>
                <DataItemTemplate>                                                    
                    <dx:ASPxImage ID="I" runat="server" SpriteCssClass="Sprite_Attachment"
                        Visible='<%# Eval("HasAttachment") %>' />
                    <%-- in IE7, empty cells don't have borders --%>
                    <%# Utils.IsIE7 && !(bool)Eval("HasAttachment") ? "&nbsp;" : "" %>
                </DataItemTemplate>
                <HeaderStyle HorizontalAlign="Center" SortingImageSpacing="5" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataTextColumn FieldName="From" Width="15%" VisibleIndex="2">
                <Settings FilterMode="DisplayText" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="To" Width="15%" Visible="false" VisibleIndex="2">
                <Settings FilterMode="DisplayText" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataColumn FieldName="Subject" VisibleIndex="3" />
            <dx:GridViewDataDateColumn FieldName="Date" Width="15%" GroupIndex="0" SortOrder="Descending" VisibleIndex="4">
                <PropertiesDateEdit DisplayFormatString="g" />
            </dx:GridViewDataDateColumn>
        </Columns>
        <Settings ShowGroupPanel="True" VerticalScrollBarMode="Auto" VerticalScrollableHeight="0" ShowGroupedColumns="True" GridLines="Vertical" />
        <SettingsBehavior AutoExpandAllGroups="true" EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
        <SettingsPager Mode="ShowAllRecords" />
        <Styles>
            <Row Cursor="pointer" />
        </Styles>
        <ClientSideEvents 
            Init="MailDemo.ClientMailGrid_Init"
            RowClick="MailDemo.ClientMailGrid_RowClick"
            EndCallback="MailDemo.ClientMailGrid_EndCallback"
            SelectionChanged="MailDemo.ClientMailGrid_SelectionChanged"
        />
    </dx:ASPxGridView>
    <dx:ASPxCallbackPanel ID="MailPreviewPanel" runat="server" RenderMode="Div" Height="100%" CssClass="MailPreviewPanel" ClientInstanceName="ClientMailPreviewPanel" ClientVisible="false"
        OnCallback="MailPreviewPanel_Callback" />
    <dx:ASPxCallbackPanel ID="MailFormPanel" runat="server" RenderMode="Div" Height="100%" ClientVisible="false" ClientInstanceName="ClientMailFormPanel">
        <PanelCollection>
            <dx:PanelContent>
                <div id="MailForm">
                    <table class="LayoutTable">
                        <tr>
                            <td class="Label">
                                <dx:ASPxLabel ID="ToLabel" runat="server" Text="To:" AssociatedControlID="ToEditor" />
                            </td>
                            <td class="Editor">
                                <table class="LayoutTable">
                                    <tr><td class="Editor">
                                        <dx:ASPxTextBox ID="ToEditor" runat="server" Width="100%" Height="31" ClientInstanceName="ClientToEditor">
                                            <ValidationSettings SetFocusOnError="True" ValidateOnLeave="true" Display="Dynamic">
                                                <RegularExpression ErrorText="Invalid e-mail"
                                                    ValidationExpression="^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(,\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*,?\s*$" />
                                                <RequiredField IsRequired="True" ErrorText="E-mail is required" />
                                            </ValidationSettings>
                                            <Paddings PaddingTop="2" PaddingLeft="8" PaddingRight="8" />
                                        </dx:ASPxTextBox>
                                    </td><td>
                                        <dx:ASPxButton ID="AddressBookButton" runat="server" Text="Address Book" Height="31" AutoPostBack="false" UseSubmitBehavior="false" CausesValidation="false"/>
                                    </td></tr>
                                </table>
                            </td>
                        </tr>
                        <tr><td class="Separator" colspan="2"></td></tr>
                        <tr>
                            <td class="Label">
                               <dx:ASPxLabel ID="SubjectLabel" runat="server" Text="Subject:" AssociatedControlID="SubjectEditor" />
                            </td>
                            <td class="Editor">
                                <dx:ASPxTextBox ID="SubjectEditor" runat="server" Width="100%" Height="31" ClientInstanceName="ClientSubjectEditor">
                                    <Paddings PaddingTop="2" PaddingLeft="8" PaddingRight="8" />
                                </dx:ASPxTextBox>
                            </td>
                        </tr>
                    </table>
                </div>
                <dx:ASPxHtmlEditor ID="MailEditor" runat="server" ClientInstanceName="ClientMailEditor" Width="100%">
                    <Settings AllowHtmlView="False" AllowPreview="False" AllowContextMenu="True" />
                    <SettingsHtmlEditing EnterMode="BR" AllowScripts="false" AllowIFrames="false" />
                    <SettingsImageUpload UploadImageFolder="" />
                    <SettingsImageSelector Enabled="true">
                        <CommonSettings RootFolder="~/Content/Photo/" />
                    </SettingsImageSelector>
                    <ClientSideEvents Init="MailDemo.ClientMailEditor_Init" />
                    <BorderLeft BorderWidth="0" />
                    <BorderRight BorderWidth="0" />
                    <BorderBottom BorderWidth="0" />
                </dx:ASPxHtmlEditor>
                <dx:ASPxPopupControl runat="server" ID="AddressBookPopup" ClientInstanceName="ClientAddressBookPopup" 
                    Width="300" Height="500" AllowDragging="True" HeaderText="Address Book" ShowFooter="True"
                    Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                    PopupAnimationType="Fade" PopupElementID="AddressBookButton">
                    <ContentCollection>
                        <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                            <dx:ASPxListBox ID="AddressesList" runat="server" Width="300" Height="500" ImageUrlField="ImageUrl" 
                                SelectionMode="CheckColumn" ClientInstanceName="ClientAddressesList">
                                <ItemImage Width="50" Height="50" />
                                <Border BorderWidth="0" />
                            </dx:ASPxListBox>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                    <ContentStyle>
                        <Paddings Padding="0" />
                    </ContentStyle>
                    <ClientSideEvents PopUp="MailDemo.ClientAddressBookPopup_PopUp" />
                    <FooterTemplate>
                        <dx:ASPxButton CssClass="AddressBookPopupButton" runat="server" ID="AddressBookPopupCancelButton" AutoPostBack="False" Text="Cancel" CausesValidation="false" UseSubmitBehavior="false">
                            <ClientSideEvents Click="MailDemo.ClientAddressBookPopupCancelButton_Click" />
                        </dx:ASPxButton>
                        <dx:ASPxButton CssClass="AddressBookPopupButton" runat="server" ID="AddressBookPopupOkButton" AutoPostBack="False" Text="Ok" CausesValidation="false" UseSubmitBehavior="false">
                            <ClientSideEvents Click="MailDemo.ClientAddressBookPopupOkButton_Click" />
                        </dx:ASPxButton>
                        <div class="clear"></div>
                    </FooterTemplate>
                </dx:ASPxPopupControl>
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents Init="MailDemo.ClientMailFormPanel_Init" />
    </dx:ASPxCallbackPanel>
</asp:Content>
