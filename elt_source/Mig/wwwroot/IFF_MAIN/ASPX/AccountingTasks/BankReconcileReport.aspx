<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BankReconcileReport.aspx.cs" Inherits="ASPX_AccountingTasks_BankReconcileReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Reconcile Report</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><style type="text/css">
	<!--
	body {
		margin: 0;
	}
	h2 {
		font: bold 12px/normal Verdana, Arial, Helvetica, sans-serif;
		width: 95%;
		margin:auto;
		
	}
	-->
	</style>
    <link href="/iff_main/ASPX/CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <link href="/iff_main/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
		<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td width="51%" align="left" valign="middle" class="pageheader"> Reconcile Report</td>
			<td width="49%" align="right" valign="baseline"></td>
		</tr>
		</table>
		<div></div>
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="31%">        </td>
				<td width="34%"></td>
			</tr>
			<tr>
				<td class="bodyheader" style="height: 19px">Bank Account</td>
				<td class="bodyheader" style="height: 19px">Statement Ending Date </td>
			</tr>
			<tr>
				<td style="height: 22px">
					<asp:DropDownList ID="ddlBankAcct" runat="server" Width="240px" 
						OnSelectedIndexChanged="ddlBankAcct_SelectedIndexChanged" AutoPostBack="True">					</asp:DropDownList>				</td>
				<td style="height: 22px">
					<asp:DropDownList ID="ddlSTED" runat="server" Width="240px" AutoPostBack="True" 
						DataTextField="statement_ending_date">					</asp:DropDownList>				</td>
			</tr>
            <tr>
                <td style="height: 22px">
                </td>
                <td style="height: 22px">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="/iff_main/Images/button_go.gif"
                        OnClick="ImageButton1_Click" /></td>
            </tr>
		</table>
		<br />
		<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
			    <td style="height: 12px">Statement Ending Date 
                    <asp:TextBox ID="txtSTEndDate" runat="server" BorderStyle="None"></asp:TextBox></td>
		    </tr>
			<tr>
			    <td>Reconcile Date 
                    <asp:TextBox ID="txtReconDate" runat="server" BorderStyle="None"></asp:TextBox></td>
		    </tr>
		</table>
        <br />
        <table width="95%" height="34" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="14%">
                    &nbsp;&nbsp;
                    <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="/iff_main/Images/button_pdf.gif"
                        OnClick="ImageButton2_Click" /></td>
            </tr>
        </table>
        <br />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
            <tr>
                <td style="text-align: center" colspan="2"> Summary &nbsp;</td>
            </tr>
            <tr>
                <td>Opening Balance </td>
                <td>&nbsp;<asp:TextBox ID="txtOpeningBalance" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Cleared Transactions </td>
                <td>&nbsp;<asp:TextBox ID="txtClearedTransactions" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="height: 12px">Ending Balance of Statement </td>
                <td style="height: 12px">&nbsp;<asp:TextBox ID="txtEndingBalance" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Uncleared Transactions as of Statement date </td>
                <td>&nbsp;<asp:TextBox ID="txtUnclearedTransactionsAsOfSTED" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Register Balnace as of Statement Date </td>
                <td>&nbsp;<asp:TextBox ID="txtRegisterBalanceAsOfSTD" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Uncleared Transactions after Statement Date </td>
                <td>&nbsp;<asp:TextBox ID="txtUnclearedTransactionsAfterST" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Register Balance as of Reconcile Date </td>
                <td>&nbsp;<asp:TextBox ID="txtRegisterBalanceAsOfReconDT" runat="server" BorderStyle="None"></asp:TextBox></td>
            </tr>
        </table>
        <br />
		<h2>Cleared Transactions</h2>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="5" rowspan="8">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="tran_date" HeaderText="Date" />
                            <asp:BoundField DataField="tran_type" HeaderText="Type" />
                            <asp:BoundField DataField="tran_num" HeaderText="No." />
                            <asp:BoundField DataField="customer_name" HeaderText="Customer" />
                            <asp:BoundField DataField="amount" HeaderText="Amount" />
                        </Columns>
                    </asp:GridView>
                    &nbsp; &nbsp; &nbsp;&nbsp;</td>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
            <tr>
            </tr>
        </table>
    </form>
</body>
</html>
