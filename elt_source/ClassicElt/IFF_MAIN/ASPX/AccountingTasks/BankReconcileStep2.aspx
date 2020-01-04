<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BankReconcileStep2.aspx.cs" Inherits="ASPX_AccountingTasks_BankReconcileStep2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<title>Bank Reconcile</title>
<script language="javascript" type="text/javascript">


function parseDecimal(d, zeros, trunc) {
	d=d.replace(/[^\d\.]/g,"");
	while (d.indexOf(".") != d.lastIndexOf("."))
		d=d.replace(/\./,"");
	if (typeof zeros == 'undefined' || zeros == "") {
		return parseFloat(d);
		}
	else {
		var mult = Math.pow(10,zeros);
		if (typeof trunc == 'undefined' || (trunc) == false)
			return parseFloat(Math.round(d*mult)/mult);
		else
			return parseFloat(Math.floor(d*mult)/mult);
		}
	}

function checkReceivement(checkbox,amount,hCheckClicked)
{
    var total=parseFloat(document.getElementById("txtTotalReceivement").value); 
    var tmp=checkbox.src.split("_");
    check=tmp[tmp.length-1];
    if(check=="o.gif"){
        total+=parseFloat(amount.value.replace(",",""));  
         checkbox.src="images/mark_x.gif";   
         hCheckClicked.value='Y';     
    }else{
        total-=parseFloat(amount.value.replace(",",""));
         checkbox.src="images/mark_o.gif"; 
         hCheckClicked.value='N';   
    }
   
    document.getElementById("txtTotalReceivement").value=total.toFixed(2);    
    tmp=parseFloat(document.getElementById("txtTotalReceivement").value)+parseFloat(document.getElementById("txtTotalPayment").value)
     difference=parseFloat(document.getElementById("txtOnStatement").value)-tmp;
    document.getElementById("txtTotalCleared").value=tmp.toFixed(2); 
    document.getElementById("txtDifference").value=difference.toFixed(2);
}

function checkPayment(checkbox,amount,hCheckClicked)
{
    var total=parseFloat(document.getElementById("txtTotalPayment").value); 
    var tmp=checkbox.src.split("_");
    check=tmp[tmp.length-1];

    if(check=="o.gif"){
        total+=parseFloat(amount.value.replace(",",""));  
         checkbox.src="images/mark_x.gif";   
         hCheckClicked.value='Y';     
    }else{
        total-=parseFloat(amount.value.replace(",",""));
         checkbox.src="images/mark_o.gif"; 
         hCheckClicked.value='N';   
    }
  
   document.getElementById("txtTotalPayment").value=total.toFixed(2);
 
   tmp=parseFloat(document.getElementById("txtTotalReceivement").value)+parseFloat(document.getElementById("txtTotalPayment").value)
   difference=parseFloat(document.getElementById("txtOnStatement").value)-tmp;
   document.getElementById("txtTotalCleared").value=tmp.toFixed(2); 
   document.getElementById("txtDifference").value=difference.toFixed(2);
}
</script>
<link href="/iff_main/ASPX/CSS/accountingStyle.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><style type="text/css">
<!--
.style1 {
	font-weight: normal;
}
-->
</style></head>
<body>
    <form id="form1" runat="server">
		<!-- Header -->
		<div class="pageName">
			<h1>Bank Reconcile: <span class="style1"><asp:Label ID="lblBank" runat="server"></asp:Label></span></h1>
			<p class="pageInfo">Click the checkbox for each transaction that matches on your bank statement. As all transactions are cleared, the difference at the bottom should equal zero, then click Reconcile.</p>
		</div>
		<div style="width:78%; min-width: 710px; padding:0 12px">
			<div style="width:78%; float:left">
				<h3>
					<span style="padding-right:54px">Statement Ending Date: <asp:Label ID="lblSTEndingDate" runat="server"></asp:Label></span>
					Reconcile Date: <asp:Label ID="lblReconcileDate" runat="server"></asp:Label>
				</h3>
			</div>
			<div style="width:21%" class="print">
				<a  href="javascript:function(){return false};"><img src="/iff_main/ASP/Images/icon_printer.gif" />Reconcile Report</a>
			</div>
		</div>
		<fieldset style="width:78%; min-width: 710px">
			<div id="Table1">
				<h2>Receive Payments and Other Credits</h2>					
					<asp:RadioButtonList ID="rdSelectOrClearReceivement" runat="server" OnSelectedIndexChanged="rdSelectOrClearReceivement_SelectedIndexChanged" RepeatDirection="Horizontal" AutoPostBack="True" CssClass="radiobtnType">
							<asp:ListItem>Select All</asp:ListItem>
							<asp:ListItem>Clear All</asp:ListItem>
					</asp:RadioButtonList>
					<asp:GridView ID="GridViewReceivement" runat="server" AllowPaging="True" AutoGenerateColumns="False" Width="100%" OnPageIndexChanging="GridViewReceivement_PageIndexChanging" BackColor="#F9F9E4" BorderColor="#89A9CE" BorderStyle="Solid" BorderWidth="1px" CellPadding="0">
						<HeaderStyle BackColor="White" />        
						<Columns>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:Image ID="check" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />            
								<asp:HiddenField ID="hCheck" runat="server" />
								<asp:HiddenField ID="hAmount" runat="server" />
							</ItemTemplate>
							<ItemStyle CssClass="tableData" HorizontalAlign="Center" />
							<HeaderStyle CssClass="tableHead" />
						</asp:TemplateField>
						<asp:BoundField DataField="tran_date" HeaderText="Date" >
							<ItemStyle CssClass="tableData" />
							<HeaderStyle CssClass="tableHead" HorizontalAlign="Left" />
						</asp:BoundField>
						<asp:BoundField DataField="tran_type" HeaderText="Type" >
							<ItemStyle CssClass="tableData" />
							<HeaderStyle CssClass="tableHead" HorizontalAlign="Left" />
						</asp:BoundField>
						<asp:HyperLinkField DataTextField="tran_num" HeaderText="Ref No." >
							<ItemStyle CssClass="tableData" />
							<HeaderStyle CssClass="tableHead" HorizontalAlign="Left" />
						</asp:HyperLinkField>
						<asp:BoundField DataField="customer_name" HeaderText="Customer">
							<ItemStyle Width="200px" CssClass="tableData" />        
							<HeaderStyle CssClass="tableHead" HorizontalAlign="Left" />
						</asp:BoundField>
						<asp:BoundField DataField="debit_amount" HeaderText="Amount">
							<ItemStyle HorizontalAlign="Right" CssClass="tableDataNo" />        
							<HeaderStyle CssClass="tableHeadNo" HorizontalAlign="Left" />
						</asp:BoundField>
						</Columns>
						<AlternatingRowStyle BackColor="#F0F4F8" />
					</asp:GridView>
					<label style="clear:none; display:inline; font-size:71%">Cleared:</label><asp:TextBox ID="txtTotalReceivement" runat="server" CssClass="inputNoborder">0.00</asp:TextBox>
			</div>
		<hr />	
			<h2>Bill Pays and Other Payments</h2> 
				<asp:RadioButtonList ID="rdSelectOrClearPayment" runat="server" OnSelectedIndexChanged="rdSelectOrClearPayment_SelectedIndexChanged"
					RepeatDirection="Horizontal" AutoPostBack="True" CssClass="radiobtnType">
						<asp:ListItem>Select All</asp:ListItem>
						<asp:ListItem>Clear All</asp:ListItem>
                </asp:RadioButtonList>            
                        <asp:GridView ID="GridViewPayment" runat="server" AllowPaging="True" AutoGenerateColumns="False" Width="100%" OnPageIndexChanging="GridViewPayment_PageIndexChanging" BackColor="#F9F9E4" BorderColor="#89A9CE" BorderStyle="Solid" BorderWidth="1px" CellPadding="4">
                            <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
									<asp:Image ID="check" runat="server" ImageUrl="~/ASPX/AccountingTasks/images/mark_o.gif" />                
									<asp:HiddenField ID="hCheck" runat="server" />
									<asp:HiddenField ID="hAmount" runat="server" />
                                </ItemTemplate>
                                <ItemStyle CssClass="tableData" />
                                <HeaderStyle CssClass="tableHead" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="tran_date" HeaderText="Date" >
                                <ItemStyle CssClass="tableData" />
                                <HeaderStyle CssClass="tableHead" />
                            </asp:BoundField>
                            <asp:BoundField DataField="tran_type" HeaderText="Type" >
                                <ItemStyle CssClass="tableData" />
                                <HeaderStyle CssClass="tableHead" />
                            </asp:BoundField>
                            <asp:HyperLinkField DataTextField="tran_num" HeaderText="Ref No." >
                                <ItemStyle CssClass="tableData" />
                                <HeaderStyle CssClass="tableHead" />
                            </asp:HyperLinkField>
                            <asp:BoundField DataField="customer_name" HeaderText="Customer">
                                <ItemStyle Width="200px" CssClass="tableData" />            
                                <HeaderStyle CssClass="tableHead" />
                            </asp:BoundField>
                            <asp:BoundField DataField="credit_amount" HeaderText="Amount">
                                <ItemStyle HorizontalAlign="Right" CssClass="tableDataNo" />            
                                <HeaderStyle CssClass="tableHeadNo" />
                            </asp:BoundField>
                            </Columns>
                            <HeaderStyle BackColor="#FFFFCC" />            
                            <AlternatingRowStyle BackColor="#F0F4F8" />
                    </asp:GridView>
					<label style="clear:none; display:inline; font-size:71%">Cleared:</label>
						<asp:TextBox ID="txtTotalPayment" runat="server" BorderStyle="None" CssClass="inputNoborder">0.00</asp:TextBox>
			<hr />
			<div>
				<label style="clear:none; display:inline; font-size:71%">On Statement:</label>
					<asp:TextBox ID="txtOnStatement" runat="server" BorderStyle="None" Font-Bold="False" CssClass="inputNoborder">0.00</asp:TextBox>
				<label style="clear:none; display:inline; font-size:71%">Total Cleared:</label>
					<asp:TextBox ID="txtTotalCleared" runat="server" BorderStyle="None" Font-Bold="False" CssClass="inputNoborder">0.00</asp:TextBox>
					<label style="clear:none; display:inline; font-size:71%; color: #CC3300">Difference:</label>
                <asp:TextBox ID="txtDifference" runat="server" BorderStyle="None" CssClass="inputNoborder"
                    Font-Bold="False" Width="82px">0.00</asp:TextBox></div>
		</fieldset>
				
		<!-- bottom button -->
		<div id="buttonArea" style="width:74%; min-width:710px">
			<ul>
				<li><a href="javascript:function(){return false};"><span><asp:Button ID="btnBack" runat="server" Text="Back" OnClick="btnBack_Click" BorderStyle="None" 
						BackColor="Transparent" CssClass="btnText" /></span></a></li>
				<li><a href="javascript:function(){return false};"><span>
					<asp:Button ID="btnReconcile" runat="server" Text="Reconcile" OnClick="btnReconcile_Click" BorderStyle="None" 
						BackColor="Transparent" CssClass="btnText" /></span></a>
				</li>
				<li><a href="javascript:function(){return false};"><span>
					<asp:Button ID="btnReconcileLater" runat="server" Text="Reconcile Later" OnClick="btnReconcileLater_Click" BorderStyle="None" 
						BackColor="Transparent" CssClass="btnText" /></span></a>
				</li>
				<li><a href="javascript:function(){return false};"><span>
					<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" BorderStyle="None" BackColor="Transparent" 
						CssClass="btnText" /></span></a>
				</li>
			</ul>
		</div>
    </form>
</body>
</html>
