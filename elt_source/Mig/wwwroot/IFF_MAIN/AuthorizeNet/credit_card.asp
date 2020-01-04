<!-- #include file="../ASP/include/transaction.txt" -->
<!-- #include file="../ASP/include/connection.asp" -->
<!-- #include file="./simlib.asp" -->
<!-- #include file="./simdata.asp" -->
<!-- #include file="../ASP/include/GOOFY_data_manager.inc" -->
<!-- #include file="../ASP/include/GOOFY_Util_fun.inc" -->
<%
    Dim amount,sequence,relayURL,payment_id,dataTable,charge_amount,charge_desc,elt_acct,footerHTML
    Dim hostURL 
    
    payment_id = Request.QueryString("pid")
    relayURL = ""
    footerHTML = ""
    
    Call GetPaymentInfo
    
    relayURL = "http://www.e-logitech.net/IFF_MAIN/AuthorizeNet/credit_card_result.asp"
    footerHTML = "Click <a href='http://www.e-logitech.net/IFF_MAIN/AuthorizeNet/credit_card_result.asp?cancel=Y&pid=" _
        & payment_id & "'>here</a> to cancel this transaction"
    
    Randomize
    sequence = Int(1000 * Rnd)
    
    Call GetCompanyContactInfo
    
    Sub GetCompanyContactInfo
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM agent WHERE elt_account_number=" & elt_acct
        feData.SetDataList(SQL)
        Set dataTable = feData.GetRowTable(0)
    End Sub
    
    Sub GetPaymentInfo
        Dim SQL,rs
        Set rs = Server.CreateObject("ADODB.RecordSet")
        SQL = "SELECT * FROM payment_due WHERE auto_uid=" & payment_id
        rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        
        If Not rs.EOF And Not rs.BOF Then
            charge_amount = rs("pmt_amount").Value
            charge_desc = rs("pmt_desc").value
            elt_acct = rs("elt_account_number").value
        End If
    End Sub
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <base target="_self" />
    <script type="text/jscript">
        function SubmitToAuthorizeNet(){
            var oForm = document.getElementById("form1");
            oForm.submit();
        }
    </script>
</head>
<body onload="javascript:SubmitToAuthorizeNet()" >
    <form id="form1" action="https://secure.authorize.net/gateway/transact.dll" method="post">
        <% 
            ret = InsertFP (loginid, txnkey, charge_amount, sequence) 
        %>
        <input type="hidden" name="x_type" value="AUTH_ONLY" />
        <input type="hidden" name="x_amount" value="<%=charge_amount %>" />
        <input type="hidden" name="x_description" value="<%=charge_desc %>" />
        <input type="hidden" name="x_show_form" value="PAYMENT_FORM" />
        <input type="hidden" name="x_relay_response" value="TRUE" />
        <input type="hidden" name="x_relay_url" value="<%=relayURL %>" />
        <input type="hidden" name="x_recurring_billing" value="TRUE" />
        <input type="hidden" name="x_cust_id" value="<%=elt_acct %>" />
        <input type="hidden" name="x_invoice_num" value="<%=payment_id %>" />
        <!--
        <input type="text" name="x_card_num" />
        <input type="text" name="x_exp_date" />
        <input type="text" name="x_card_code" />
        -->
        <input type="hidden" name="x_email" value='<%=dataTable("owner_email") %>' />
        <input type="hidden" name="x_first_name" value='<%=UCase(dataTable("owner_fname")) %>' />
        <input type="hidden" name="x_last_name" value='<%=UCase(dataTable("owner_lname")) %>' />
        <input type="hidden" name="x_company" value='<%=UCase(dataTable("dba_name")) %>' />
        <input type="hidden" name="x_address" value='<%=UCase(dataTable("owner_mail_address")) %>' />
        <input type="hidden" name="x_city" value='<%=UCase(dataTable("owner_mail_city")) %>' />
        <input type="hidden" name="x_state" value='<%=UCase(dataTable("owner_mail_state")) %>' />
        <input type="hidden" name="x_zip" value='<%=dataTable("owner_mail_zip") %>' />
        <input type="hidden" name="x_country" value='<%=UCase(dataTable("owner_mail_country")) %>' />
        <input type="hidden" name="x_phone" value='<%=dataTable("owner_phone") %>' />
        <input type="hidden" name="x_footer_html_payment_form" value="<%=footerHTML %>" />
        <!--<input type="button" value="Submit" onclick="SubmitToAuthorizeNet()" />-->
    </form>
</body>

</html>
