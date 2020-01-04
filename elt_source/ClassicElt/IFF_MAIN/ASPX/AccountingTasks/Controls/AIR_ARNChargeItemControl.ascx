<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AIR_ARNChargeItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_AIR_ARNChargeItemControl" %>
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
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#efe1df"/>
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Description">
            <ItemStyle Width="130px" HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:TextBox ID="txtChDescription" runat="server" Width="130px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#efe1df" />
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                <asp:TextBox ID="txtChAmount" runat="server" Width="50px" onKeyup="checkLimit(this,10000000000,10)" onKeyPress="return checkNum();" CssClass="grid_numberfield" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <FooterTemplate>
                Total Amount<br />
                <asp:TextBox ID="txtChAmtTotal" runat="server" Width="50px" CssClass="grid_numberfield" ForeColor="Black" ReadOnly="True">0.00</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#efe1df" />
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
    <HeaderStyle BackColor="#efe1df" />
</asp:GridView>
<asp:HiddenField ID="hChItemsDefaultAmtArray" runat="server" />
<asp:HiddenField ID="hChItemsItemNoArray" runat="server" />
<asp:HiddenField ID="hChItemsDefaultDscArray" runat="server" /><asp:HiddenField ID="hAmtIds" runat="server" /><asp:HiddenField ID="hDefaultAF" runat="server" /><asp:HiddenField ID="hDefaultOF" runat="server" />
<asp:HiddenField ID="hChItemIDs" runat="server" />
<br />

<script  type="text/javascript" language="javascript">
    function setFocusOnObj(obj)
    {
        alert();
    }
	
	
	function ChargeAmountList(){    
       var arrAmt=document.getElementById("AIR_ARNChargeItemControl1_hAmtIDs").value;
       var ItemNos=document.getElementById("AIR_ARNChargeItemControl1_hChItemIDs").value;
       arrAmt=arrAmt.split("^^");
       ItemNos=ItemNos.split("^^");
       for(i=0;i<arrAmt.length-1;i++){
       if(document.getElementById(ItemNos[i]).selectedIndex!=0)
       {
            var Amt=document.getElementById(arrAmt[i]).value;
            if(Amt==0)
            {
                alert("Please enter a Charge Amount!");
                document.getElementById(arrAmt[i]).focus();
                return false;
            }
         }
       }
        return true;
    }
	
    function ddlChItemsChange(ddl,dsc,amt)
    {
    
        var item_no=ddl.value.split(":");        
        if(item_no[0] ==-1)
         {
            document.getElementById("hCommand").value="DeleteCharge";
         }
    
        else if(item_no[0]==-2){
           window.open( "../../ASP/acct_tasks/edit_ch_items.asp", "PopWin", "status = 1, scrollbars=1, width = 800, resizable = 0" );
        }     
        item_no=item_no[0];        
        var arrDsc=document.getElementById("AIR_ARNChargeItemControl1_hChItemsDefaultDscArray").value;
        var arrNo=document.getElementById("AIR_ARNChargeItemControl1_hChItemsItemNoArray").value;
        var arrAmt=document.getElementById("AIR_ARNChargeItemControl1_hChItemsDefaultAmtArray").value;
      
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
    
    
    function changeAmount(ChAmtTotal,hAmtIDs,hitemID){
      
        var ChID=hitemID.value;
        var amounts=hAmtIDs.value;       
        var Ids=amounts.split("^^");
        var CId=ChID.split("^^");
        var total_amount=0;   
        var amount=0;
        try{     
            for(i=0;i<Ids.length;i++){      
               var itemAmount=document.getElementById(Ids[i]).value;
            if(itemAmount != 0)
               {    
                    if(document.getElementById(CId[i]).selectedIndex == 0)
                    {
                        alert("Please Select Charge Item first!");
                        document.getElementById(Ids[i]).value = "0.00";
                        document.getElementById(CId[i]).focus();
                    }
                    else
                    {
                         document.getElementById(Ids[i]).value=parseFloat(itemAmount).toFixed(2);
                    }
               }    
               amount=document.getElementById(Ids[i]).value.replace(",","");

               if(amount=="")
               {     
                     document.getElementById(Ids[i]).value="0.00";
                     alert("Please enter a Charge Amount!");
                     amount=0;
               }
               amount=parseFloat(amount);    
               total_amount+=amount;        
            } 
        }catch(e){
        
        }
         if(total_amount == "NaN" )
        {
            total_amount="0.00";
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
