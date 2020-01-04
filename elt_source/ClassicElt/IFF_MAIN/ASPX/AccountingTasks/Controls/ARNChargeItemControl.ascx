<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ARNChargeItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_ARNChargeItemControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>

<asp:GridView ID="GridViewChargeItem" runat="server" AutoGenerateColumns="False"
    BackColor="White" ShowFooter="True" OnRowDeleting="GridViewChargeItem_RowDeleting" GridLines="Horizontal" >
    <Columns>
        <asp:TemplateField HeaderText="Charge Item">
            <ItemTemplate>
                <asp:DropDownList ID="ddlChItems" runat="server" DataTextField="NameDescription"
                    DataValueField="ItemNo_AccountRevenue" Width="180px" CssClass="ComboBox">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Description">
            <ItemStyle Width="130px" HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:TextBox ID="txtChDescription" runat="server" Width="130px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                <asp:TextBox ID="txtChAmount" runat="server" Width="50px"  CssClass="grid_numberfield" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <FooterTemplate>
                Total Amount<br />
                <asp:TextBox ID="txtChAmtTotal" runat="server" Width="50px" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0.00</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <FooterTemplate>
                <asp:Label ID="lblARLock" runat="server" ForeColor="Red" Visible="False" Width="265px"></asp:Label><br />
                <asp:ImageButton ID="btnAddCharge" runat="server" ImageUrl="~/ASP/Images/button_addcharge_item.gif"
                    OnClick="btnAddCharge_Click" />
            </FooterTemplate>
            <ItemTemplate>
                &nbsp;<asp:ImageButton ID="btnDeleteCharge" runat="server" CausesValidation="False" CommandName="Delete"
                    ImageUrl="~/ASP/Images/button_delete.gif"  />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
</asp:GridView>
<asp:HiddenField ID="hChItemsDefaultAmtArray" runat="server" />
<asp:HiddenField ID="hChItemsItemNoArray" runat="server" />
<asp:HiddenField ID="hChItemsDefaultDscArray" runat="server" /><asp:HiddenField ID="hAmtIds" runat="server" /><asp:HiddenField ID="hDefaultAF" runat="server" /><asp:HiddenField ID="hDefaultOF" runat="server" />
<br />

<script  type="text/javascript" language="javascript">
    function setFocusOnObj(obj)
    {
        alert();
    }
		
    function ddlChItemsChange(ddl,dsc,amt)
    {
    
        var item_no=ddl.value.split(":");        
        if(item_no[0]==-2){
           window.open( "../../ASP/acct_tasks/edit_ch_items.asp", "PopWin", "status = 1, scrollbars=1, width = 800, resizable = 0" );
        }     
        item_no=item_no[0];        
        var arrDsc=document.getElementById("ARNChargeItemControl1_hChItemsDefaultDscArray").value;
        var arrNo=document.getElementById("ARNChargeItemControl1_hChItemsItemNoArray").value;
        var arrAmt=document.getElementById("ARNChargeItemControl1_hChItemsDefaultAmtArray").value;
      
        arrDsc=arrDsc.split("__");
        arrNo=arrNo.split("__");
        arrAmt=arrAmt.split("__");
  
        for(i=0;i<arrNo.length;i++){      
          if (arrNo[i]==item_no){
         
           document.getElementById(dsc.id).value=arrDsc[i];
           document.getElementById(amt.id).value=arrAmt[i];
           
          }        
        }
    }
    
    
    function changeAmount(ChAmtTotal,hAmtIDs){
      
        var amounts=hAmtIDs.value;       
        var Ids=amounts.split("^^");
        var total_amount=0;   
        try{     
            for(i=0;i<Ids.length;i++){      
               total_amount+=parseFloat(document.getElementById(Ids[i]).value.replace(",",""));        
            } 
        }catch(e){
        
        }
        //txtAgentProfit/txtTotalCharge/txtTotal
        ChAmtTotal.value =total_amount;   
        //document.getElementById("txtTotalCharge").value=total_amount;
       // var agent_profit=document.getElementById("txtAgentProfit").value ;
       // var sales_tax=document.getElementById("txtSalesTax").value
       // document.getElementById("txtTotal").value=total_amount-agent_profit-sales_tax;         
    }
    
    
</script>

<asp:HiddenField ID="hIsFCExist" runat="server" />
<asp:HiddenField ID="hFCAmount" runat="server" />
<asp:HiddenField ID="hFCAmountFieldID" runat="server" />
