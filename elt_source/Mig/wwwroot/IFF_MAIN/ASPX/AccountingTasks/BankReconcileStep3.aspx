<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BankReconcileStep3.aspx.cs" Inherits="ASPX_AccountingTasks_BankReconcileStep3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
        <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
<link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
    <tr>
        <td width="51%" align="left" valign="middle" class="pageheader"> Reconcile </td>
        <td width="49%" align="right" valign="baseline"></td>
    </tr>
</table>
<div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        
        <tr>
            <td width="84%" height="24"><em class="bodyheader style5">Account: BANK OF AMERICA &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Statement Ending Date: 08/31/2007 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Reconcile Date: 09/05/2007</em></td>
        </tr>
    </table>
</div>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td><table width="90%" border="0" align="left" cellpadding="0" cellspacing="0" bordercolor="#89a979" class="border1px" style="padding-right:10px">
            
            <tr bgcolor="#FFFFFF" class="bodyheader">
                <td height="24" colspan="4" valign="bottom" style="padding-left:10PX">&nbsp;</td>
            </tr>
            <tr bgcolor="#f3f3f3">
                <td align="right" colspan="3" style="height: 20px; text-align: left;">
                    Opening Balance &nbsp;</td>
                <td width="37%" style="height: 20px; text-align: right">&nbsp;<asp:TextBox ID="txtOpeningBalance" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            <tr>
                <td align="right" colspan="3" style="height: 20px; text-align: left">
                    Cleared Transactions 
                </td>
                <td align="right" style="height: 20px">
                    <asp:TextBox ID="txtClearedTransactions" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            <tr bgcolor="#F3F3F3">
                <td align="right" colspan="3" style="height: 18px; text-align: left">
                    Ending Balance of Statement&nbsp;<span></span></td>
                <td align="right" style="height: 18px; text-align: right;">
                    <asp:TextBox ID="txtEndingBalanceOfStatement" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            <tr bgcolor="#f3f3f3">
                <td id="txtUnclearedTransactions" align="right" colspan="3" style="height: 16px;
                    text-align: left">
                    Uncleared Transactions</td>
                <td align="right" style="text-align: right; height: 16px;">
                    <asp:TextBox ID="txtUnclearedTransactions" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            <tr bgcolor="#f3f3f3">
                <td align="right" colspan="3" style="height: 18px; text-align: left">
                    Register Balance as of Statement Date</td>
                <td align="right" style="height: 18px; text-align: right">
                    <asp:TextBox ID="txtRegisterBalanceAsOfStatement" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            <tr bgcolor="#f3f3f3">
                <td align="right" colspan="3" style="height: 18px; text-align: left">
                    Register Balance as of Reconcile Date
                </td>
                <td align="right" style="height: 18px">
                    <asp:TextBox ID="txtRegisterBalanceAsOfReconcileDate" runat="server" BorderStyle="None" CssClass="numberfield">0.00</asp:TextBox></td>
            </tr>
            
            
            <tr align="left" bgcolor="#89a979">
                <td colspan="4" style="height: 1px"></td>
            </tr>
            <tr>
                <td align="right" valign="middle" colspan="2"></td>
                <td align="right" style="padding-right: 10px"></td>
                <td align="left"></td>
            </tr>
        </table></td>
    </tr>
    <tr>
        <td height="4">&nbsp;</td>
    </tr>
    
    <tr>
        <td height="48" valign="middle">
            &nbsp;
                <input type="button" name="" value="View Report " style="width:90px; height:22px" />
        </td>
    </tr>
</table>
    </form>
</body>
</html>
