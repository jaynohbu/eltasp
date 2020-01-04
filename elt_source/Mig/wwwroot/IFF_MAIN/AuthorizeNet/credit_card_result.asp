<!-- #include file="../ASP/include/transaction.txt" -->
<!-- #include file="../ASP/include/connection.asp" -->
<!-- #include file="../ASP/include/GOOFY_data_manager.inc" -->
<!-- #include file="../ASP/include/GOOFY_Util_fun.inc" -->
<% 

Response.Expires = 0

Dim ResponseCode, ResponseReasonText, ResponseReasonCode
Dim ResponseSubcode, AVS, ReceiptLink, TransID, InvoiceNo
Dim Amount, AuthCode, ELTAcct, paymentURL, paymentType, returnURL, resultStr

On Error Resume Next:

If Request.QueryString("cancel") = "Y" Then
    InvoiceNo = Request.QueryString("pid")
	resultStr = "You have canceled to enter payment information."
Elseif Request.QueryString("delete") = "Y" Then
    paymentType = GetSQLResult("SELECT pmt_desc FROM payment_due WHERE auto_uid=" & Request.form("hPID"), Null)
    ELTAcct = GetSQLResult("SELECT elt_account_number FROM payment_due WHERE auto_uid=" & Request.form("hPID"), Null)
    If paymentType = "Premium Subscription" Then
        returnURL = "../OnlineApply/CreateAdmin.aspx"
        Call PremiumSubscriptionCancel
    End If
    Response.Redirect(returnURL)
Else
    Call GetParamValues
    Call AnalyzeResponse
End If

paymentURL = "./credit_card.asp?pid=" + InvoiceNo

Sub AnalyzeResponse
    If ResponseCode = 1 Then
        '// Sucessful
        Call UpdateTransaction(TransID,ELTAcct,"Y")
        Response.Write("<script>alert('This transaction has been approved.');</script>")
        Response.Redirect(returnURL)
    Elseif ResponseCode = 2 Then
        '// Declined
        Call UpdateTransaction(TransID,ELTAcct,"N")
        Response.Write("<script>alert('This transaction has been declined.');</script>")
        '// resultStr = "This transaction has been declined."
        Response.Redirect(paymentURL)
    Else
        '// Error
        Call UpdateTransaction(TransID,ELTAcct,"N")
        Response.Write("<script>alert('There was an error processing this transaction.');</script>")
        '// resultStr = "There was an error processing this transaction."
        Response.Redirect(paymentURL)
    End If

End Sub

Sub UpdateTransaction(TransID,ELTAcct,pStatus)
    Dim SQL,rs
    Set rs = Server.CreateObject("ADODB.RecordSet")
    SQL = "UPDATE payment_due SET " _
		& "trad_id='" & TransID & "'," _
        & "resp_code='" & ResponseCode & "'," _
        & "resp_res_code='" & ResponseReasonCode & "'," _
        & "resp_res_text='" & ResponseReasonText & "'," _
        & "auth_code='" & AuthCode & "'," _
        & "avs_code='" & AVS & "'," _
        & "pmt_status='" & pStatus & "' " _
        & "WHERE auto_uid='" & InvoiceNo & "' AND elt_account_number=" & ELTAcct

    Set rs = eltConn.execute(SQL)
End Sub

Sub GetParamValues
    InvoiceNo = Trim(Request.Form("x_invoice_num"))
    TransID = Trim(Request.Form("x_trans_id"))
    ELTAcct = Trim(Request.Form("x_cust_id"))
    Amount = Trim(Request.Form("x_amount"))
    
    ResponseCode = Trim(Request.Form("x_response_code"))
    ResponseReasonText = Trim(Request.Form("x_response_reason_text"))
    ResponseReasonCode = Trim(Request.Form("x_response_reason_code"))
    AVS = Trim(Request.Form("x_avs_code"))
    AuthCode = Trim(Request.Form("x_auth_code"))
    
    ReceiptLink = "http://www.authorizenet.com"
End Sub

Sub PremiumSubscriptionCancel
    Dim SQL,rs
    SQL = "BEGIN TRANSACTION " _
        & "DELETE FROM payment_due WHERE auto_uid=" & Request.form("hPID") & " " _
        & "UPDATE setup_session SET payment_id=NULL WHERE payment_id=" & Request.form("hPID") & " " _
        & "UPDATE agent SET account_statue='F' WHERE elt_account_number=" & ELTAcct & " " _
        & "COMMIT"
    Response.Write(SQL)
    Set rs = Server.CreateObject("ADODB.RecordSet")
    Set rs = eltConn.execute(SQL)
End Sub

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <script type="text/jscript">
        function GoURL(vURL){
            window.location.href = vURL;
        }
        
        function SaveGoURL(){
            var oForm = document.getElementById("form1");
            oForm.method = "post";
            oForm.action = "credit_card_result.asp?delete=Y"
            oForm.submit();
        }
    </script>
</head>
<body>
    <form id="form1" action="">
    
        <div><%=resultStr %></div><p />
        <input type="hidden" name="hPID" value="<%=InvoiceNo %>" />
        <input type="radio" name="rdPremium" onclick="GoURL('<%=paymentURL %>')" />Select FreightEasy Premium Account<p />
        <input type="radio" name="rdStandard" onclick="SaveGoURL()" />Select FreightEasy Standard Account<p />
		Account Types and Features (content will be added later)
    </form>
</body>
</html>
