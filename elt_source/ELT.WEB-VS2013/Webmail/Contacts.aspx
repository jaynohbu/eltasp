<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Contacts.aspx.cs" Inherits="Contacts" 
    EnableViewState="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="SideHolder" runat="Server">
    <div class="ContactsNavArea">
        <dx:ASPxNavBar runat="server" ID="ContactViewBar" AllowExpanding="False" Width="100%" ShowExpandButtons="False" CssClass="ContactViewBar">
            <Groups>
                <dx:NavBarGroup Text="Address Books" Name="AddressBooks">
                    <ContentTemplate>
                        <dx:ASPxRadioButtonList runat="server" ID="AddressBookList" CssClass="AddressBookList">
                            <Items>
                                <dx:ListEditItem Text="Personal" Value="0" Selected="True" />
                                <dx:ListEditItem Text="Collected" Value="1" />
                            </Items>
                            <Border BorderWidth="0" />
                            <ClientSideEvents SelectedIndexChanged="MailDemo.ClientContactAddressBookList_SelectedIndexChanged" />
                        </dx:ASPxRadioButtonList>
                    </ContentTemplate>
                </dx:NavBarGroup>
                <dx:NavBarGroup Text="Sort" Name="Sort">
                    <ContentTemplate>
                        <div class="field">
                            <div class="label">
                                <dx:ASPxLabel ID="SortByLabel" runat="server" Text="Sort by:" AssociatedControlID="SortByCombo" />
                            </div>
                            <div class="editor">
                                <dx:ASPxComboBox ID="SortByCombo" runat="server" Width="120" SelectedIndex="0">
                                    <Items>
                                        <dx:ListEditItem Value="Name" />
                                        <dx:ListEditItem Value="Email" />
                                        <dx:ListEditItem Value="Country" />
                                    </Items>
                                    <ClientSideEvents SelectedIndexChanged="MailDemo.ClientContactSortByCombo_SelectedIndexChanged" />
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="field">
                            <div class="label">
                                <dx:ASPxLabel ID="SortDirectionLabel" runat="server" Text="Direction:" AssociatedControlID="SortDirectionCombo" />
                            </div>
                            <div class="editor">
                                <dx:ASPxComboBox ID="SortDirectionCombo" runat="server" Width="120" SelectedIndex="0">
                                    <Items>
                                        <dx:ListEditItem Text="Ascending" Value="0" />
                                        <dx:ListEditItem Text="Descending" Value="1" />
                                    </Items>
                                    <ClientSideEvents SelectedIndexChanged="MailDemo.ClientContactSortDirectionCombo_SelectedIndexChanged" />
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </ContentTemplate>
                    <HeaderStyle>
                        <BorderTop BorderWidth="1" />
                    </HeaderStyle>
                </dx:NavBarGroup>
            </Groups>
            <GroupHeaderStyle>
                <BorderTop BorderWidth="0" />
                <BorderRight BorderWidth="0" />
            </GroupHeaderStyle>
            <GroupContentStyle>
                <BorderRight BorderWidth="0" />
            </GroupContentStyle>
            <Paddings Padding="0" />
        </dx:ASPxNavBar>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainHolder" runat="Server">
    <dx:ASPxDataView ID="ContactDataView" runat="server" Width="100%" AllowPaging="false" Layout="Flow" ClientInstanceName="ClientContactDataView" 
        OnCustomCallback="ContactDataView_CustomCallback">
        <ItemTemplate>
            <div class="CommandItems">
                <dx:ASPxImage ID="EditContactImage" runat="server" SpriteCssClass="Sprite_EditContact" Cursor="Pointer" OnLoad="EditContactImage_Load">
                    <ClientSideEvents Click="MailDemo.ClientEditContactImage_Click" />
                </dx:ASPxImage>
                <dx:ASPxImage ID="DeleteContactImage" runat="server" SpriteCssClass="Sprite_RemoveSmall" Cursor="Pointer" OnLoad="DeleteContactImage_Load">
                    <ClientSideEvents Click="MailDemo.ClientDeleteContactImage_Click" />
                </dx:ASPxImage>
            </div>
            <dx:ASPxImage ID="ContactPhoto" runat="server" Height="150" CssClass="Photo" ImageUrl='<%# GetContactImageUrl(Container) %>' />
            <div class="Info">
                <div class="item">
                    <b>Name:</b>
                    <div class="body"><%# GetName(Container) %></div>
                </div>
                <div class="item">
                    <b>Email:</b>
                    <div class="body"><%# GetEmail(Container)%></div>
                </div>
                <div class="item" runat="server" visible='<%# HasAddress(Container) %>'>
                    <b>Address:</b>
                    <div class="body"><%# GetAddress(Container)%></div>
                </div>
                <div class="item" runat="server" visible='<%# HasPhone(Container) %>'>
                    <b>Phone:</b>
                    <div class="body"><%# Eval("Phone") %></div>
                </div>
            </div>
        </ItemTemplate>
        <ContentStyle>
            <Border BorderWidth="0" />
        </ContentStyle>
        <ItemStyle Width="420" Height="200" CssClass="ContactCard">
            <Paddings Padding="0" />
        </ItemStyle>
        <Border BorderWidth="0" />
    </dx:ASPxDataView>
    <dx:ASPxCallbackPanel runat="server" ID="ContactFormPanel" ClientInstanceName="ClientContactFormPanel" RenderMode="Div" Width="100%" Height="100%" 
        ClientVisible="false">
        <PanelCollection><dx:PanelContent>
            <table style="width:100%">
                <tr>
                    <td style="width:15%;"></td>
                    <td style="width:70%;">
                        <dx:ASPxFormLayout ID="ContactForm" runat="server" ColCount="3">
                            <Items>
                                <dx:LayoutGroup Caption="MainInfo" GroupBoxDecoration="HeadingLine">
                                    <Items>
                                        <dx:LayoutItem Caption="Name">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="ContactNameEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactNameEditor">
                                                    <ValidationSettings SetFocusOnError="True" ValidateOnLeave="true" Display="Dynamic">
                                                        <RequiredField IsRequired="True" ErrorText="Name is required" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Email">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="ContactEmailEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactEmailEditor">
                                                    <ValidationSettings SetFocusOnError="True" ValidateOnLeave="true" Display="Dynamic">
                                                        <RegularExpression ErrorText="Invalid e-mail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                                        <RequiredField IsRequired="True" ErrorText="E-mail is required" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                    <ParentContainerStyle CssClass="InfoLayoutGroup" />
                                </dx:LayoutGroup>
                                <dx:EmptyLayoutItem RowSpan="2">
                                    <ParentContainerStyle CssClass="EmptyLayoutItem" />
                                </dx:EmptyLayoutItem>
                                <dx:LayoutGroup Caption="Photo" RowSpan="2" GroupBoxDecoration="HeadingLine">
                                    <Items>
                                        <dx:LayoutItem ShowCaption="false">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxImage ID="ContactPhotoImage" runat="server" Width="100%" ClientInstanceName="ClientContactPhotoImage"
                                                    ImageUrl="Content/Photo/User.png" OnCustomJsProperties="ContactPhotoImage_CustomJsProperties">
                                                </dx:ASPxImage>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="false">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxUploadControl ID="ContactPhotoUpload" runat="server" ClientInstanceName="ClientContactPhotoUpload" ShowProgressPanel="True" Size="35"
                                                    NullText="Click here to upload a new photo..." OnFileUploadComplete="ContactPhotoUpload_FileUploadComplete" Width="100%" Height="30">
                                                    <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.jpe,.gif" />
                                                    <ClientSideEvents 
                                                        TextChanged="MailDemo.ClientContactPhotoUpload_TextChanged" 
                                                        FileUploadComplete="MailDemo.ClientContactPhotoUpload_FileUploadComplete" 
                                                    />
                                                    <TextBoxStyle Height="30" />
                                                </dx:ASPxUploadControl>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                    <ParentContainerStyle CssClass="PhotoLayoutGroup" />
                                </dx:LayoutGroup>
                                <dx:LayoutGroup Caption="Additional Info" GroupBoxDecoration="HeadingLine">
                                    <Items>
                                        <dx:LayoutItem Caption="Address">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="ContactAddressEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactAddressEditor" />
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Country">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxComboBox ID="ContactCountryEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactCountryEditor" OnLoad="ContactCountryEditor_Load"
                                                    IncrementalFilteringMode="StartsWith" TextField="Country" ValueField="Country" EnableSynchronization="False"
                                                    DropDownStyle="DropDown">
                                                    <ClientSideEvents SelectedIndexChanged="MailDemo.ClientContactCountryEditor_SelectedIndexChanged" />
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="City">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxComboBox ID="ContactCityEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactCityEditor"
                                                    OnCallback="ContactCityEditor_Callback" TextField="City" ValueField="City" IncrementalFilteringMode="StartsWith" 
                                                    EnableSynchronization="False" DropDownStyle="DropDown">
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Phone">
                                            <LayoutItemNestedControlCollection><dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="ContactPhoneEditor" runat="server" Width="100%" Height="30" ClientInstanceName="ClientContactPhoneEditor">
                                                    <MaskSettings Mask="1 (999) 000-0000" IncludeLiterals="All" />
                                                    <ValidationSettings Display="Dynamic" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer></LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                    <ParentContainerStyle CssClass="InfoLayoutGroup" />
                                </dx:LayoutGroup>
                            </Items>
                            <SettingsItemCaptions Location="Top" />
                        </dx:ASPxFormLayout>
                    </td>
                    <td style="width:15%;"></td>
                </tr>
            </table>
        </dx:PanelContent></PanelCollection>
        <ClientSideEvents Init="MailDemo.ClientContactFormPanel_Init" />
    </dx:ASPxCallbackPanel>
    <dx:ASPxCallback ID="CallbackControl" runat="server" ClientInstanceName="ClientCallbackControl" OnCallback="CallbackControl_Callback">
        <ClientSideEvents CallbackComplete="MailDemo.ClientCallbackControl_CallbackComplete" />
    </dx:ASPxCallback>
    <asp:AccessDataSource ID="CountryDataSource" runat="server" DataFile="~/App_Data/WorldCities.mdb"
        SelectCommand="SELECT * FROM [Countries]"></asp:AccessDataSource>
    <asp:AccessDataSource ID="CitiesDataSource" runat="server" DataFile="~/App_Data/WorldCities.mdb"
        SelectCommand="SELECT c.City FROM [Cities] c, [Countries] cr WHERE (c.CountryId = cr.CountryId) AND (cr.Country = ?) order by c.City">
        <SelectParameters>
            <asp:Parameter Name="?" />
        </SelectParameters>
    </asp:AccessDataSource>
</asp:Content>
