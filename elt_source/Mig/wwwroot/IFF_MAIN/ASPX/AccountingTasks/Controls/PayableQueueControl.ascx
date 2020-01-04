<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PayableQueueControl.ascx.cs" Inherits="ASPX_AccountingTasks_Controls_PayableQueueControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../../CSS/elt_css.css" type="text/css" rel="stylesheet"/>
<script  type="text/vbscript" language="VBScript">

Function makeMsgBox(tit,mess,icon,buts,defs,mode)
   butVal = icon + buts + defs + mode
   makeMsgBox = MsgBox(mess,butVal,tit)
End Function

Function CofirmDFA()
    RET=makeMsgBox("This item is linked to an invoice item","Would you like to change the invoice cost item as well?",48,4,0,4096)
    if RET = 6 THEN CofirmDFA="Y" end if
End Function

</script>
<script language="javascript" type="text/javascript">

function commandChange(command)
{
    document.getElementById("PayableQueueControl1_hCommand").value=command;    
}
    

function ddlCostItemsChange(checkbox,ddl,amt,hCheckClicked)
{
    holdAmount(checkbox,amt,hCheckClicked);
   
    var item_no=ddl.value.split(":");     
    
    if(item_no[0]==-2)
    {
       window.open( "../../ASP/acct_tasks/edit_co_items.asp", "PopWin", "status = 1, scrollbars=1, width = 800, resizable = 0" );
    }
    
    item_no=item_no[0];
    var arrNo=document.getElementById("PayableQueueControl1_hCostItemsItemNoArray").value;     
    var arrAmt=document.getElementById("PayableQueueControl1_hCostItemsDefaultAmtArray").value;
    
    arrNo=arrNo.split("__");
    arrAmt=arrAmt.split("__");

    for(i=0;i<arrNo.length;i++)
    {      
      if (arrNo[i]==item_no)
      {        
            amt.value=arrAmt[i];
            newAmount(checkbox,amt,hCheckClicked);
            return;
      }        
    }
}   


function changeCostAmount(checkbox,amount,hCheckClicked){
     
    var arrCHKIDs=document.getElementById("PayableQueueControl1_hCheckBoxIDs").value;
    var arrAmtIDS=document.getElementById("PayableQueueControl1_hAmtIDs").value;   
    
    var total_altogether=0;
    var total_checked=0;
    var total_from_pages=parseFloat(document.getElementById("PayableQueueControl1_hTotalAmount").value);
    var total=total_from_pages;  
     
    arrCHKIDs=arrCHKIDs.split("^^");
    arrAmtIDS=arrAmtIDS.split("^^");

    for(i=0;i<arrCHKIDs.length-1;i++)
    {    
      cb=document.getElementById(arrCHKIDs[i]);    
      tmp=cb.src.split("_");   
      check=tmp[tmp.length-1];   
      if (check=="x.gif")
      {        
          total_checked+= parseFloat(document.getElementById(arrAmtIDS[i]).value);
      }     
    }    
    total=total-total_checked;    
  
    var tmp=checkbox.src.split("_");   
    check=tmp[tmp.length-1];
    var isDisabled=document.getElementById("hIsDisabled").value;   
    if(check=="o.gif")
    {
        checkbox.src="images/mark_x.gif";   
        hCheckClicked.value='Y';
        
    }else
    {    
        checkbox.src="images/mark_o.gif";   
        hCheckClicked.value='N';
    }
  
    var arrCHKIDs=document.getElementById("PayableQueueControl1_hCheckBoxIDs").value;
    var arrAmtIDS=document.getElementById("PayableQueueControl1_hAmtIDs").value;   
    
    var total_altogether=0;
    var total_checked=0;
    var total_from_pages=parseFloat(document.getElementById("PayableQueueControl1_hTotalAmount").value);
    
    arrCHKIDs=arrCHKIDs.split("^^");
    arrAmtIDS=arrAmtIDS.split("^^");

    for(i=0;i<arrCHKIDs.length-1;i++)
    {    
      cb=document.getElementById(arrCHKIDs[i]);    
      tmp=cb.src.split("_");   
      check=tmp[tmp.length-1];   
      if (check=="x.gif")
      {  
          total_checked+= parseFloat(document.getElementById(arrAmtIDS[i]).value);
      }       
    }
   
    total=total+total_checked;  
    document.getElementById("PayableQueueControl1_hTotalAmount").value=total;
  
    document.getElementById("txtAmount").value=total.toFixed(2);
}

var tempAmt;

function holdAmount(checkbox,amount,hCheckClicked){
      
    var isDisabled=document.getElementById("hIsDisabled").value;    
    if(isDisabled!="true")
    {                  
        tempAmt=parseFloat(amount.value.replace(",",""));        

        var arrCHKIDs=document.getElementById("PayableQueueControl1_hCheckBoxIDs").value;
        var arrAmtIDS=document.getElementById("PayableQueueControl1_hAmtIDs").value;   

        var total_checked=0;       
        var total=parseFloat(document.getElementById("PayableQueueControl1_hTotalAmount").value);

        arrCHKIDs=arrCHKIDs.split("^^");
        arrAmtIDS=arrAmtIDS.split("^^");

        for(i=0;i<arrCHKIDs.length-1;i++)
        {    
            cb=document.getElementById(arrCHKIDs[i]);    
            tmp=cb.src.split("_");   
            check=tmp[tmp.length-1];   
            if (check=="x.gif")
            {        
                total_checked+= parseFloat(document.getElementById(arrAmtIDS[i]).value);
            }     
        }   
         
        total=total-total_checked; 
        tempAmt=total;                  
    }    
}

function replaceAmount(checkbox,amount,hCheckClicked,invoice_no, item_id,item_no)
{   
    //--------------------------------------------------------------------------
    tmp=checkbox.src.split("_");   
    check=tmp[tmp.length-1];
    var isDisabled=document.getElementById("hIsDisabled").value;   
    if(isDisabled!="true")
    { 
        if(parseFloat(amount.value.replace(",",""))!=0)
        {
            checkbox.src="images/mark_x.gif";   
            hCheckClicked.value='Y';
           t=parseFloat(amount.value.replace(",",""));
            amount.value=t.toFixed(2);
        }
        else
        {    
            checkbox.src="images/mark_o.gif";   
            hCheckClicked.value='N';
        }        
    }
    var arrCHKIDs=document.getElementById("PayableQueueControl1_hCheckBoxIDs").value;
    var arrAmtIDS=document.getElementById("PayableQueueControl1_hAmtIDs").value;    
    var total_checked=0;
    var total_from_pages=parseFloat(document.getElementById("PayableQueueControl1_hTotalAmount").value);    
    arrCHKIDs=arrCHKIDs.split("^^");
    arrAmtIDS=arrAmtIDS.split("^^");
    for(i=0;i<arrCHKIDs.length-1;i++)
    {    
      cb=document.getElementById(arrCHKIDs[i]);    
      tmp=cb.src.split("_");   
      check=tmp[tmp.length-1];
      var amt = document.getElementById(arrAmtIDS[i]).value
      if(amt == "NaN")
      {
            document.getElementById(arrAmtIDS[i]).value="0.00";
            checkbox.src="images/mark_o.gif";   
            hCheckClicked.value='N';
      }   
      if (check=="x.gif")
      {   
          total_checked+= parseFloat(document.getElementById(arrAmtIDS[i]).value);         
      }       
    }  
    total=tempAmt+total_checked;    
    document.getElementById("PayableQueueControl1_hTotalAmount").value=total;   
    document.getElementById("txtAmount").value=total.toFixed(2);    
    if(invoice_no!="0")
    {     
      if(CofirmDFA()=="Y")
      {
         changeIVCostItem(invoice_no,item_id,item_no,amount.value) ;
      }
    }  
}

function newAmount(checkbox,amount,hCheckClicked)
{
    tmp=checkbox.src.split("_");   
    check=tmp[tmp.length-1];
    var isDisabled=document.getElementById("hIsDisabled").value;   
    if(isDisabled!="true")
    { 
        if(parseFloat(amount.value.replace(",",""))!=0)
        {
            checkbox.src="images/mark_x.gif";   
            hCheckClicked.value='Y';
            t=parseFloat(amount.value.replace(",",""));
            amount.value=t.toFixed(2);
        }
        else
        {    
            checkbox.src="images/mark_o.gif";   
            hCheckClicked.value='N';
        }
    }     
    var arrCHKIDs=document.getElementById("PayableQueueControl1_hCheckBoxIDs").value;
    var arrAmtIDS=document.getElementById("PayableQueueControl1_hAmtIDs").value; 
    var total_checked=0;   
     
    arrCHKIDs=arrCHKIDs.split("^^");
    arrAmtIDS=arrAmtIDS.split("^^");
    for(i=0;i<arrCHKIDs.length-1;i++)
    {    
      cb=document.getElementById(arrCHKIDs[i]);    
      tmp=cb.src.split("_");   
      check=tmp[tmp.length-1];   
      if (check=="x.gif")
      {      
          total_checked+= parseFloat(document.getElementById(arrAmtIDS[i]).value);         
      }       
    }  
    total=tempAmt+total_checked;
    document.getElementById("PayableQueueControl1_hTotalAmount").value=total;   
    document.getElementById("txtAmount").value=total.toFixed(2);    
   
}

function changeIVCostItem(invoice_no,item_id,item_no,cost_amount)
{
    var url="Ajax/changeIVCostItem.aspx?invoice_no="+invoice_no+"&item_id="+item_id+"&item_no="+item_no+"&cost_amount="+cost_amount;
    var req = new ActiveXObject("Microsoft.XMLHTTP");
    req.open("get",url,false);
    req.send();
    var result =req.responseText;
    return result;
}   
 
</script>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="3" style="height: 100%">
<asp:GridView ID="GridViewBillDetailItem" runat="server" AutoGenerateColumns="False"
    ShowFooter="True" AllowPaging="True" OnPageIndexChanging="GridViewBillDetailItem_PageIndexChanging" GridLines="Horizontal" Width="100%" BorderStyle="None" BorderWidth="0px"  >
    <Columns>
        <asp:TemplateField>
            <HeaderStyle CssClass="bodyheader" />
            <ItemTemplate>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        &nbsp;<asp:Image ID="btnCheck" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" ImageAlign="AbsMiddle" />
                        <asp:HiddenField ID="hCheckClicked" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
                &nbsp; &nbsp;
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Date">
            <HeaderStyle CssClass="bodyheader" />
            <ItemTemplate>
                <asp:TextBox ID="txtDate" runat="server" CssClass="shorttextfield"  ForeColor="Black" Width="70px"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate">
                </cc1:CalendarExtender>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Item Name">
            <ItemTemplate>
                <asp:DropDownList ID="ddlCostItems" runat="server" DataTextField="NameDescription"
                    DataValueField="ItemNo_AccountExpense" Width="280px" CssClass="ComboBox">
                </asp:DropDownList>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" />
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
		<asp:TemplateField HeaderText="Amount">
            <ItemTemplate>
                <asp:TextBox ID="txtAmount" runat="server" Width="70px" onKeyPress="checkNum()" onKeyup="checkLimit(this,10000000000,10)" CssClass="numberalignbold" ForeColor="Black">0.00</asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" />
            <FooterTemplate>  
            </FooterTemplate>
        </asp:TemplateField>
        <asp:HyperLinkField HeaderText="Reference Link" DataNavigateUrlFields="url" DataTextField="ref_link" Target="_blank">
            <HeaderStyle CssClass="bodyheader" />
            <ControlStyle CssClass="bodyheader" />
        </asp:HyperLinkField>
        <asp:TemplateField HeaderText="Reference No.">
            <ItemTemplate>
                <asp:TextBox ID="txtRefNo" runat="server" Width="130px" CssClass="shorttextfield" ForeColor="Black"></asp:TextBox>
            </ItemTemplate>
            <HeaderStyle CssClass="bodyheader" />
            <FooterStyle CssClass="bodyheader" />
        </asp:TemplateField>
        <asp:TemplateField ShowHeader="False">
            <ItemTemplate>
                <asp:ImageButton ID="btnDelete" runat="server" CausesValidation="false" CommandName="Delete" ImageUrl="~/ASP/Images/button_delete.gif"  CommandArgument='<%#DataBinder.Eval(Container,"RowIndex")%>' OnCommand="btnDelete_Command" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <HeaderStyle BackColor="#E7F0E2" Height="20px" HorizontalAlign="Left" VerticalAlign="Middle" />
    <RowStyle BackColor="White" BorderStyle="None" Height="18px" />
    <EditRowStyle BackColor="" />
    <SelectedRowStyle BackColor="" />
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
            <asp:HiddenField ID="hAmtIDs" runat="server" /><asp:HiddenField ID="hddlIDs" runat="server" /><asp:HiddenField ID="hCheckBoxIDs" runat="server" /><asp:HiddenField ID="hTotalAmount" runat="server" />
        </td>
    </tr>
</table>

