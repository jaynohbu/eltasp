<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Customer Overpaid</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style10 {
	        color: #cc6600;
	        font-weight: bold;
        }
        .style6 {
            color: #cc0000; 
            font-size: 11px; 
        }
        
        .style5 {
            font-size: 11px; 
        }
        
    </style>

    <script type="text/javascript" language="javascript">
        function account_selected()
        {
            if(document.getElementById("lst_liability_accts").value == ""){
                document.getElementById("spn_lst_liability_accts").innerHTML = "* Please, select a liability account.";
            }
            else{
                window.returnValue = document.getElementById("lst_liability_accts").value;
                window.close();
            }
        }
        
        function select_canceled()
        {
            window.close();
        }
        
        function load_parent_values()
        {
            var args = window.dialogArguments;
            document.getElementById("spn_receiving_from").innerHTML = args[0]
            document.getElementById("spn_total_receiving_amount").innerHTML = parseFloat(args[1]).toFixed(2);
            document.getElementById("spn_total_due_amount").innerHTML = parseFloat(args[2]).toFixed(2);
            document.getElementById("spn_total_credit_amount").innerHTML = parseFloat(args[3]).toFixed(2);
        }
    </script>

</head>
<!-- #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!-- #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<%
    Dim liability_accts, i
    Set liability_accts = get_liability_accts
    
    Function get_liability_accts()
        Dim SQL,keyArray,dataObj
        Set dataObj = new DataManager
        SQL = "SELECT * FROM gl WHERE gl_master_type='" & CONST__MASTER_LIABILITY_NAME _
            & "' AND elt_account_number=" & elt_account_number & " AND gl_account_type!='" _
            & CONST__ACCOUNT_PAYABLE & "'"
        dataObj.SetDataList(SQL)
        keyArray = dataObj.GetKeyArray()
        Set get_liability_accts = dataObj.GetDataList()
    End Function
%>
<body onload="load_parent_values();">
    <form name="form1">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td style="height: 32px" align="left" valign="middle" class="pageheader">
                    Customer Overpaid
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" class="border1px"
            style="border-color: #89A979">
            <tr style="background-color: #D5E8CB; height: 12px">
                <td>
                </td>
            </tr>
            <tr style="background-color: #89A979; height: 1px">
                <td>
                </td>
            </tr>
            <tr style="padding: 4px">
                <td>
                    <div class="style5">
                        <span>You are receiving payment from a customer, <span id="spn_receiving_from"></span>
                            <br />
                            <br />
                            Total amount due: <span id="spn_total_due_amount"></span>
                            <br />
                            Receiving amount: <span id="spn_total_receiving_amount"></span>
                            <br />
                            Unapplied amount: <span id="spn_total_credit_amount"></span></span>
                    </div>
                    <br />
                    <div style="height: 16px">
                        <span class="style10">Select Liability Account</span></div>
                    <select id="lst_liability_accts" runat="server" class="bodycopy">
                        <option value=""></option>
                        <% For i=0 To liability_accts.count-1%>
                        <option value='<%=liability_accts(i)("gl_account_number") %>'>
                            <%=liability_accts(i)("gl_account_desc") %>
                        </option>
                        <% Next %>
                    </select>
                    &nbsp; <span id="spn_lst_liability_accts" class="style6"></span>
                </td>
            </tr>
            <tr style="background-color: #89A979; height: 1px">
                <td>
                </td>
            </tr>
            <tr style="background-color: #D5E8CB; text-align: center; margin: 2px 2px 2px 2px; height:25px">
                <td>
                    <a href="javascript:;" onclick="account_selected();"><span>Continue</span></a>
                    &nbsp;&nbsp;&nbsp;
                    <a href="javascript:;" onclick="select_canceled();"><span>Cancel</span></a>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
