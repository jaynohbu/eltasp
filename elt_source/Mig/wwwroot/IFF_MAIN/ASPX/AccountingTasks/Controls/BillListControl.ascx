<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillListControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_BillListControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript">



function ChangeItemAmt(cbox,clear,clear_hidden,clearTotal){ 

  checkbox=document.getElementById(cbox); 
   var tmp=checkbox.src.split('_');
   check=tmp[tmp.length-1];
  
  if(check=='x.gif'){           
           clearTotal.value=ParseFloat(clearTotal.value)-ParseFloat(clear_hidden.value.replace(",",""));
          document.getElementById('txtAcctBalance').value=parseFloat(document.getElementById('txtAcctBalance').value.replace(",",""))-ParseFloat(clear_hidden.value.replace(",",""));         
          clearTotal.value=ParseFloat(clearTotal.value.replace(",",""))+ParseFloat(clear.value.replace(",",""));
          document.getElementById('txtAcctBalance').value=parseFloat(document.getElementById('txtAcctBalance').value.replace(",",""))+parseFloat(clear.value.replace(",",""));                   
  }else{
           alert("Please select the item first");
   }                
}

    
function SavePrevious(clear,clear_hidden){   
    if(parseFloat(clear.vlaue)!=0){               
        clear_hidden.value= clear.vlaue.replace(",","");  
    }else{
        clear_hidden.value=0;
    }         
}

</script>
&nbsp;<table cellpadding="0" cellspacing="0" style="width: 100%">
    <tr>
        <td>
<asp:GridView ID="GridViewBillItem" runat="server" AutoGenerateColumns="False" BackColor="White"
    ShowFooter="True"  Width="100%" GridLines="Horizontal" BorderStyle="None" BorderWidth="0px" >
    <Columns>
        <asp:TemplateField HeaderText="Include">
            <HeaderStyle CssClass="bodyheader" />
            <ItemTemplate>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        &nbsp;&nbsp;&nbsp;<asp:Image ID="btnCheck" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />
                        <asp:HiddenField ID="hIsChecked" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Due Date">
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="shorttextfield" ForeColor="Black" ReadOnly="True" Width="90px"></asp:TextBox>&nbsp;
            </ItemTemplate>
        </asp:TemplateField>
        <asp:HyperLinkField HeaderText="Bill Number" DataNavigateUrlFields="url" DataTextField="bill_number" Target="_blank">
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemStyle BorderStyle="None" HorizontalAlign="Left" />
        </asp:HyperLinkField>
        
        
        <asp:TemplateField HeaderText="Billed Amount">
            <ItemTemplate>
               
                <asp:TextBox ID="txtBillAmount" runat="server" Width="50px" CssClass="readonlyboldright" ForeColor="Black" ReadOnly="True">0.0</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle HorizontalAlign="Left" />
            <FooterTemplate>
              
            </FooterTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
        </asp:TemplateField>
        
        
        <asp:TemplateField HeaderText="Amount Due">
            <FooterTemplate>
                <asp:TextBox ID="txtAmtDueTotal" onKeyPress="checkNum()" runat="server" CssClass="readonlyboldright" ForeColor="Black" Width="50px">0.0</asp:TextBox>
            </FooterTemplate>
             <FooterStyle HorizontalAlign="Left" />
             
            <HeaderStyle HorizontalAlign="Left" CssClass="bodyheader" />
            
            <ItemTemplate>
                <asp:TextBox ID="txtAmountDue" onKeyPress="checkNum()" runat="server" CssClass="readonlyboldright" ForeColor="Black" ReadOnly="True" Width="50px">0.0</asp:TextBox>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
           
        </asp:TemplateField>
        
        
        <asp:TemplateField HeaderText="Amount to clear">
            <FooterTemplate>
                <asp:TextBox ID="txtAmtClearTotal" runat="server" onKeyPress="checkNum()" CssClass="readonlyboldright" ForeColor="Black" Width="50px">0.0</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:TextBox ID="txtAmountClear" runat="server" onKeyPress="checkNum()" CssClass="numberfield" ForeColor="Black" Width="50px">0.0</asp:TextBox>&nbsp;
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" BorderStyle="None" />
            <FooterStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Memo">
            <ItemTemplate>
                <asp:TextBox ID="txtMemo" runat="server" Width="120px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
                <asp:HiddenField ID="hPrevious" runat="server" />
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle HorizontalAlign="Left" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
</asp:GridView>
        </td>
    </tr>
</table>
            <asp:HiddenField ID="hCommand" runat="server" Value="0" />
<asp:HiddenField ID="hTotalDue" runat="server" Value="0" />
<asp:HiddenField ID="hTotalClear" runat="server" Value="0" />
<asp:HiddenField ID="hDueIDs" runat="server" Value="0" />
<asp:HiddenField ID="hClearIDs" runat="server" Value="0" />

