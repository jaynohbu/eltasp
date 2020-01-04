<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ChargeItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_ChargeItemControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
 <SCRIPT src="../../jScripts/stanley_J_function.js" type=text/javascript></SCRIPT> 
<asp:GridView ID="GridViewChargeItem" runat="server" AutoGenerateColumns="False"
    BackColor="White" ShowFooter="True" OnRowDeleting="GridViewChargeItem_RowDeleting" GridLines="Horizontal" Width="100%" BorderStyle="None" BorderWidth="0px" >
    <Columns>
        <asp:TemplateField HeaderText="Charge Item">
            <ItemTemplate>
                <asp:DropDownList ID="ddlChItems" runat="server" DataTextField="NameDescription"
                    DataValueField="ItemNo_AccountRevenue" Width="260px" CssClass="ComboBox">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" BorderStyle="None" Height="18px" Width="30%" />
            <FooterStyle CssClass="bodyheader" HorizontalAlign="Left" Height="18px" />
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Description">
            <ItemTemplate>
                <asp:TextBox ID="txtChDescription" runat="server" Width="240px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="30%" />
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                <asp:TextBox ID="txtChAmount" runat="server" Width="80px" onKeyup="checkLimit(this,10000000000,10)" onKeyPress="checkNum()" CssClass="numberalign" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <FooterTemplate>
                Total Amount<br />
                <asp:TextBox ID="txtChAmtTotal" runat="server" Width="80px" CssClass="readonlyboldright" ForeColor="" ReadOnly="True">0.00</asp:TextBox>
            </FooterTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" BackColor="#E7F0E2" Width="13%" />
            <FooterStyle CssClass="bodyheader" Height="34px" VerticalAlign="Bottom" />
        </asp:TemplateField>
        <asp:BoundField DataField="waybill_type" HeaderText="Type" Visible="False">
            <ItemStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <HeaderStyle BackColor="#E7F0E2" CssClass="bodyheader" HorizontalAlign="Left" />
        </asp:BoundField>
        <asp:TemplateField HeaderText="Link to Reference ">
            <ControlStyle CssClass="bodyheader" />
            <ItemStyle Width="130px" />
            <HeaderStyle BackColor="#E7F0E2" CssClass="bodyheader" HorizontalAlign="Left" Width="13%" />
            <ItemTemplate>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("url") %>' Target="_blank"
                    Text='<%# Eval("waybill_type") %>'></asp:HyperLink>
            </ItemTemplate>
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <FooterTemplate>
                <asp:Label ID="lblARLock" runat="server" ForeColor="Red" Visible="False" Width="265px"></asp:Label><br />
                <asp:ImageButton ID="btnAddCharge" runat="server" ImageUrl="~/ASP/Images/button_addcharge_item.gif"
                    OnClick="btnAddCharge_Click" />
            </FooterTemplate>
            <ItemTemplate>
                <asp:ImageButton ID="btnDeleteCharge" runat="server" CausesValidation="False" CommandName="Delete"
                    ImageUrl="~/ASP/Images/button_delete.gif" Text="Delete" />
            </ItemTemplate>
            <HeaderStyle BackColor="#E7F0E2" Width="14%" />
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
    <AlternatingRowStyle BackColor="#F3F3F3" />
</asp:GridView>
<asp:HiddenField ID="hChItemsDefaultAmtArray" runat="server" />
<asp:HiddenField ID="hChItemsItemNoArray" runat="server" />
<asp:HiddenField ID="hChItemsDefaultDscArray" runat="server" />
<asp:HiddenField ID="hAmtIds" runat="server" />
<asp:HiddenField ID="hChItemIDs" runat="server" />
<br />
<br />
&nbsp;<br />

<script  type="text/javascript" language="javascript">
		
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
            var arrDsc=document.getElementById("ChargeItemControl1_hChItemsDefaultDscArray").value;
            var arrNo=document.getElementById("ChargeItemControl1_hChItemsItemNoArray").value;
            var arrAmt=document.getElementById("ChargeItemControl1_hChItemsDefaultAmtArray").value;
          
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
  

    
    function ChargeAmountList(){    

       var arrAmt=document.getElementById("ChargeItemControl1_hAmtIDs").value;
       var ItemNos=document.getElementById("ChargeItemControl1_hChItemIDs").value;
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
    
    function changeAmount(ChAmtTotal,hAmtIDs,hitemID){
        
        var ChID=hitemID.value;
       
        var amounts=hAmtIDs.value;
        var amt="";
        var Ids=amounts.split("^^");
        var CId=ChID.split("^^");
        var total_amount=0;   
        try{     
            for(i=0;i<Ids.length;i++){
             
               checkblank(Ids[i],"0.00");
               if(document.getElementById(Ids[i]).value != 0)
               {    
                    
                    if(document.getElementById(CId[i]).selectedIndex == 0)
                    {
                        alert("Please Select Charge Item first!");
                        document.getElementById(Ids[i]).value = "0.00";
                        document.getElementById(CId[i]).focus();
                    }
               }    
               total_amount+=parseFloat(document.getElementById(Ids[i]).value.replace(",",""));        
            } 
        }catch(e){
        }

        //txtAgentProfit/txtTotalCharge/txtTotal
        ChAmtTotal.value =total_amount;   
       // document.getElementById("txtTotalCharge").value=total_amount;
        var agent_profit=document.getElementById("txtAgentProfit").value ;
        var sales_tax=document.getElementById("txtSalesTax").value
        document.getElementById("txtTotal").value=total_amount-agent_profit-sales_tax;         
    }
    
    
</script>
