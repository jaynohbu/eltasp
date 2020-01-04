<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ARControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_ARControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript">


function SavePrevious(clear,clear_hidden){   
    if(parseFloat(clear.vlaue)!=0){               
        clear_hidden.value= clear.vlaue;  
    }else{
        clear_hidden.value=0;
    }         
}

</script>
<table width="100%">
    <tr>
        <td>
<asp:GridView ID="GridViewARItem" runat="server" AutoGenerateColumns="False" BackColor="White"
    ShowFooter="True"  Width="100%" GridLines="Horizontal" BorderStyle="None" BorderWidth="0px" >
    <Columns>
        <asp:TemplateField HeaderText="Include">
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="10%" />
            <ItemTemplate>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        &nbsp;&nbsp;&nbsp;
                        <asp:Image ID="btnCheck" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" />
            <FooterStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Due Date">
            <HeaderStyle CssClass="bodyheader" BackColor="#E7F0E2" Width="18%" />
            <ItemTemplate>
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="shorttextfield" ForeColor="Black" ReadOnly="True"></asp:TextBox>&nbsp;
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:HyperLinkField HeaderText="Invoice Number" DataNavigateUrlFields="url" DataTextField="invoice_no">
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="18%" />
            <ItemStyle BorderStyle="None" HorizontalAlign="Left" />
        </asp:HyperLinkField>
        <asp:TemplateField HeaderText="Original Amount">
            <ItemTemplate>
               
                <asp:TextBox ID="txtOrigAmt" runat="server" Width="100px" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="18%" />
            <FooterStyle CssClass="bodyheader" />
            <FooterTemplate>
              
            </FooterTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount Due">
            <FooterTemplate>
                <asp:TextBox ID="txtAmtDueTotal" runat="server" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="18%" />
            <ItemTemplate>
                <asp:TextBox ID="txtAmtDue" runat="server" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0</asp:TextBox>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
            <FooterStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Payment ">
            <FooterTemplate>
                <asp:TextBox ID="txtPaymentTotal" runat="server" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="18%" />
            <ItemTemplate>
                <asp:TextBox ID="txtPayment" runat="server" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0</asp:TextBox>&nbsp;
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
            <FooterStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:HiddenField ID="hPrevious" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
    <AlternatingRowStyle BackColor="#F3F3F3" />
</asp:GridView>
        </td>
    </tr>
</table>
            <asp:HiddenField ID="hCommand" runat="server" Value="0" /><asp:HiddenField ID="hCheckBoxIDs" runat="server" Value="0" />
<asp:HiddenField ID="hDTnPT" runat="server" Value="0" />
<asp:HiddenField ID="hAmountDueIDs" runat="server" Value="0" />
<asp:HiddenField ID="hAmountPaymentIDs" runat="server" Value="0" />

