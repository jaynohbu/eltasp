<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ARNCostItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_ARNCostItemControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<asp:GridView ID="GridViewCostItem" runat="server" AutoGenerateColumns="False" BackColor="White"
    ShowFooter="True" OnRowDeleting="GridViewCostItem_RowDeleting" GridLines="Horizontal" BorderStyle="None" BorderWidth="0px" Width="100%">
    <Columns>
        <asp:TemplateField HeaderText="Cost Item">
            <ItemTemplate>
                <asp:DropDownList ID="ddlCostItems" runat="server" DataTextField="NameDescription"
                    DataValueField="ItemNo_AccountExpense" Width="190px" CssClass="ComboBox">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Height="18px" Width="22%" />
            <FooterStyle CssClass="bodyheader" Width="22%" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Description">
            <ItemTemplate>
                <asp:TextBox ID="txtCostDescription" runat="server" Width="180px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="22%" />
            <FooterStyle CssClass="bodyheader" Width="22%" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Vendor">
            <ItemTemplate>
                <asp:DropDownList ID="ddlVendor" runat="server" Width="180px" DataTextField="Dba_name" DataValueField="Org_account_number" CssClass="ComboBox" CausesValidation="True">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="22%" />
            <FooterStyle CssClass="bodyheader" Width="22%" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                <asp:TextBox ID="txtCostAmount" runat="server" Width="80px" CssClass="numberalign" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="11%" />
            <FooterStyle CssClass="bodyheader" Height="34px" Width="11%" />
            <FooterTemplate>
                Total Amount
                <br />
                <asp:TextBox ID="txtTotalCostAmt" runat="server" Width="80px" CssClass="readonlyboldright" ReadOnly="True">0.00</asp:TextBox>
            </FooterTemplate>
            <ItemStyle HorizontalAlign="Left" CssClass="numberaligh" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Reference No.">
            <ItemTemplate>
                <asp:TextBox ID="txtRefNo" runat="server" Width="80px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="11%" />
            <FooterStyle CssClass="bodyheader" Width="11%" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <FooterTemplate>
                <asp:ImageButton ID="btnAddCost" runat="server" ImageUrl="~/ASP/Images/button_addcost_item.gif"
                    OnClick="btnAddCostItem_Click" />
            </FooterTemplate>
            <ItemTemplate>
                <asp:ImageButton ID="btnDeleteCost" runat="server" CausesValidation="False" CommandName="Delete"
                    ImageUrl="~/ASP/Images/button_delete.gif" Text="Delete"  />
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" />
            <HeaderStyle HorizontalAlign="Left" BackColor="#E7F0E2" />
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:HyperLink ID="hlAPLock" runat="server">[hlAPLock]</asp:HyperLink>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" />
            <HeaderStyle BackColor="#E7F0E2" />
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
    <AlternatingRowStyle BackColor="#F3F3F3" />
</asp:GridView>
<asp:HiddenField ID="hCostItemsItemNoArray" runat="server" />
<asp:HiddenField ID="hCostItemsDefaultDscArray" runat="server" />
<asp:HiddenField ID="hCostItemsDefaultAmtArray" runat="server" />
<script type="text/javascript" language="javascript">

 function ddlCostItemsChange(ddl,dsc,amt)
    {
        var item_no=ddl.value.split(":");
        if(item_no[0]==-2){
           window.open( "../../ASP/acct_tasks/edit_co_items.asp", "PopWin", "status = 1, scrollbars=1, width = 800, resizable = 0" );
        }
        item_no=item_no[0];
        var arrDsc=document.getElementById("CostItemControl1_hCostItemsDefaultDscArray").value;
        var arrNo=document.getElementById("CostItemControl1_hCostItemsItemNoArray").value;
        var arrAmt=document.getElementById("CostItemControl1_hCostItemsDefaultAmtArray").value;
      
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
    
    function validateVendorList(){    

       var arrAmt=document.getElementById("CostItemControl1_hAmtIDs").value;       
       var vendorDDLs=document.getElementById("CostItemControl1_hVendorIDs").value;  
       
       arrAmt=arrAmt.split("^^");
       vendorDDLs=vendorDDLs.split("^^");        
       for(i=0;i<vendorDDLs.length-1;i++){
       Amt=parseFloat(document.getElementById(arrAmt[i]).value);                 
         if (Amt!=0){
           if(document.getElementById(vendorDDLs[i]).selectedIndex==0){
                 alert("Please select a vendor!");
                 document.getElementById(vendorDDLs[i]).focus();
                 return false;
           }           
         }        
       }
        return true;
    }
    
     function changeCostAmount(CostAmtTotal,hAmtIDs){      
        var amounts=hAmtIDs.value;       
        var Ids=amounts.split("^^");
        var total_amount=0;   
        try{     
            for(i=0;i<Ids.length;i++){    
           // alert( document.getElementById(Ids[i]).src); 
               total_amount+=parseFloat(document.getElementById(Ids[i]).value.replace(",",""));        
            } 
        }catch(e){
        
        }
        //txtAgentProfit/txtTotalCharge/txtTotal
        CostAmtTotal.value =total_amount;               
    }
    
    
</script>

<asp:HiddenField ID="hVendorClass" runat="server" />
<asp:HiddenField ID="hVendorAcct" runat="server" />
<asp:HiddenField ID="hVendorDBA" runat="server" /><asp:HiddenField ID="hAmtIDs" runat="server" />
<asp:HiddenField ID="hVendorIDs" runat="server" />
