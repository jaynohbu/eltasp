<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GJEItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_GJEItemControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<asp:GridView ID="GridViewGJEItem" runat="server" AutoGenerateColumns="False"
    ShowFooter="True" GridLines="Horizontal" BorderStyle="None" Width="100%" BorderWidth="0px" CellPadding="0">
    <Columns>
        <asp:TemplateField HeaderText="Account">
            <ItemTemplate>
                <asp:DropDownList ID="ddlGLAccounts" runat="server" Width="250px" CssClass="ComboBox" DataTextField="Gl_account_desc" DataValueField="Gl_account_number">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="aspHeader" HorizontalAlign="Left" BackColor="#E7F0E2" Height="18px" />
            <FooterStyle CssClass="leftPadding" HorizontalAlign="Left" />
            <ItemStyle Height="22px" HorizontalAlign="Left" CssClass="leftPadding" />
            <FooterTemplate>
                <asp:ImageButton ID="btnAddGJE" runat="server" ImageUrl="~/ASP/Images/button_add.gif"
                    OnClick="btnAddGJEItem_Click" />
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Debit">
            <ItemTemplate>
                <asp:TextBox ID="txtDebit" runat="server" CssClass="numberalign" ForeColor="Black" Width="70px">0.00</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Credit">
            <ItemTemplate>
                <asp:TextBox ID="txtCredit" runat="server" CssClass="numberalign" ForeColor="Black" Width="70px">0.00</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Memo">
            <ItemTemplate>
                <asp:TextBox ID="txtMemo" runat="server" Width="200px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" />
            <FooterStyle CssClass="bodyheader" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Name" Visible="False">
            <ItemTemplate>
                <asp:DropDownList ID="ddlName" runat="server" Width="180px" CssClass="ComboBox" CausesValidation="True" DataTextField="Dba_name" DataValueField="Org_account_number">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" />
            <FooterStyle CssClass="bodyheader" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <FooterTemplate>
                &nbsp;
            </FooterTemplate>
            <ItemTemplate>
                
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
    <AlternatingRowStyle BackColor="#F3F3F3" />
</asp:GridView>
<asp:HiddenField ID="hDebits" runat="server" />
<asp:HiddenField ID="hCredits" runat="server" />

