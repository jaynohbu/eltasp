<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CheckItemControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_CheckItemControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<script language="javascript" type="text/javascript">

function commandChange(command){
    document.getElementById("CheckItemControl1_hCommand").value=command;    
}

function ddlCostItemsChange(ddl,amt)
{
    var item_no=ddl.value.split(":");
     
    if(item_no[0]==-2){
       window.open( "../../ASP/acct_tasks/edit_co_items.asp", "PopWin", "status = 1, scrollbars=1, width = 800, resizable = 0" );
    }
    item_no=item_no[0];
    var arrNo=document.getElementById("CheckItemControl1_hCostItemsItemNoArray").value;     
    var arrAmt=document.getElementById("CheckItemControl1_hCostItemsDefaultAmtArray").value;

    arrNo=arrNo.split("__");
    arrAmt=arrAmt.split("__");

    for(i=0;i<arrNo.length;i++){      
      if (arrNo[i]==item_no){         
       document.getElementById(amt.id).value=arrAmt[i];
      }        
    }
    
     changeTotalAmount();
}   
 
function changeCostAmount(txt_amt,ddl){  
    if(ddl.selectedIndex<=0){
        alert("please select an item first");
        txt_amt.value=0;
        return false;
       } 
   
}

function changeTotalAmount()
{             
    
    txtTotalAmount=document.getElementById("txtAmount");         
    var clears=document.getElementById("CheckItemControl1_hAmtIDs").value.split("^^");
    var itemClear=document.getElementById("CheckItemControl1_hCheckBoxIDs").value.split("^^");

    var totalClear=0;
    for(i=0; i<clears.length-1;i++)
    {   

        tmp=document.getElementById(clears[i]).value.replace(",","");
        tmpitem2=document.getElementById(itemClear[i]).value.replace(",","");

        if(tmp=="" || tmp=="NaN")
        {   
            document.getElementById(clears[i]).value="0.00";
            tmp=0;
        }
        else if( tmp!=0 && tmpitem2=="-1:-1")
        {
                alert("please select an item first");
                 document.getElementById(clears[i]).value="0.00";
        } 
        
        tmp=parseFloat(tmp);
        tmp=Math.round(tmp*100)/100;
        totalClear=totalClear+tmp;
    }
    txtTotalAmount.value=totalClear;             
    Money=getEnglish(totalClear)	            
    document.form1.txtMoneyEnglish.value=Money;
}


</script>


&nbsp;<table style="width: 540px">
    <tr>
        <td colspan="3" style="height: 100%">
<asp:GridView ID="GridViewBillDetailItem" runat="server" AutoGenerateColumns="False" BackColor="White"
    ShowFooter="True" GridLines="Horizontal" Width="500px"  >
    <Columns>
        <asp:TemplateField HeaderText="Date">
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:TextBox ID="txtDate" runat="server" CssClass="shorttextfield" ForeColor="Black" Width="90px"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate">
                </cc1:CalendarExtender>
            </ItemTemplate>
            <ItemStyle HorizontalAlign="Left" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Item Name">
            <ItemTemplate>
                <asp:DropDownList ID="ddlCostItems" runat="server" DataTextField="NameDescription"
                    DataValueField="ItemNo_AccountExpense" Width="180px" CssClass="ComboBox">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                &nbsp;<asp:TextBox ID="txtAmount" runat="server" onKeyup="checkLimit(this,10000000000,10)" onKeyPress="checkNum()" Width="50px" CssClass="grid_numberfield" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" />
            <FooterTemplate>
              
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Reference No.">
            <ItemTemplate>
                <asp:TextBox ID="txtRefNo" runat="server" Width="130px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" HorizontalAlign="Left" />
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <ItemTemplate>
                <asp:ImageButton ID="btnDelete" runat="server" CausesValidation="false" CommandName="Delete" ImageUrl="~/ASP/Images/button_delete.gif"  CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>' OnCommand="btnDelete_Command" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="White" />
</asp:GridView>
        </td>
    </tr>
    <tr>
        <td>
        </td>
        <td>
        </td>
        <td align="right">
            <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/ASP/Images/button_additem.gif"
                OnClick="btnAdd_Click"  /></td>
    </tr>
    <tr>
        <td>
        </td>
        <td>
        </td>
        <td>
            <asp:HiddenField ID="hCommand" runat="server" Value="0" />
            <asp:HiddenField ID="hCostItemsItemNoArray" runat="server" />
            <asp:HiddenField ID="hCostItemsDefaultAmtArray" runat="server" />
            <asp:HiddenField ID="hAmtIDs" runat="server" /><asp:HiddenField ID="hCheckBoxIDs" runat="server" />
        </td>
    </tr>
</table>

