<!-- #include file="../Include/transaction.txt" -->
<!-- #include file="../Include/connection.asp" -->
<!-- #include file="../Include/GOOFY_data_manager.inc" -->
<!-- #include file="../Include/GOOFY_Util_fun.inc" -->
<% 

Response.Expires = 0

Dim ResponseCode, ResponseReasonText, ResponseReasonCode
Dim ResponseSubcode, AVS, ReceiptLink, TransID, InvoiceNo
Dim Amount, AuthCode, RequestID, paymentURL, paymentType, returnURL, resultStr

'On Error Resume Next:
Call GetParamValues
Call AnalyzeResponse

Sub AnalyzeResponse
    If ResponseCode = 1 Then
        '// Sucessful
        Call UpdateTransaction(TransID,"Y")
        Response.Write("<script>alert('This transaction has been approved.'); window.location.href='" & returnURL & "';</script>")
    Elseif ResponseCode = 2 Then
        '// Declined
        Call UpdateTransaction(TransID,"N")
        Response.Write("<script>alert('This transaction has been declined.'); window.location.href='" & paymentURL & "';</script>")
    Else
        '// Error
        Call UpdateTransaction(TransID,"N")
        Response.Write("<script>alert('There was an error processing this transaction.'); window.location.href='" & paymentURL & "';</script>")
    End If
End Sub

Sub GetParamValues
    InvoiceNo = Trim(Request.Form("x_invoice_num"))
    TransID = Trim(Request.Form("x_trans_id"))
    RequestID = Trim(Request.Form("x_cust_id"))
    Amount = Trim(Request.Form("x_amount"))
    
    ResponseCode = Trim(Request.Form("x_response_code"))
    ResponseReasonText = Trim(Request.Form("x_response_reason_text"))
    ResponseReasonCode = Trim(Request.Form("x_response_reason_code"))
    AVS = Trim(Request.Form("x_avs_code"))
    AuthCode = Trim(Request.Form("x_auth_code"))
    
    TransID = "test003"
    InvoiceNo = 9
    ResponseCode = 1
    
    paymentURL = "./credit_card.asp?pid=" & InvoiceNo
    
    Dim dataTable
    Set dataTable = GetAccountRequestTable(InvoiceNo)
    
    returnURL = "./NewAccountCreate.aspx?rid=" & dataTable("auto_uid") & "&tid=" & TransID
End Sub

Function GetAccountRequestTable(pid)
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM account_request WHERE payment_id=" & pid
        feData.SetDataList(SQL)
        
        Set GetAccountRequestTable = feData.GetRowTable(0)
End Function 
    
Sub UpdateTransaction(TransID,pStatus)

    Dim SQL,dataObj,dataTable,i
    Set dataObj = new DataManager
    Set dataTable = Server.CreateObject("System.Collections.HashTable")
    
    dataTable.Add "tran_id", TransID
    dataTable.Add "resp_code", ResponseCode
    dataTable.Add "resp_res_code", ResponseReasonCode
    dataTable.Add "resp_res_text", ResponseReasonText
    dataTable.Add "auth_code", AuthCode
    dataTable.Add "avs_code", AVS
    dataTable.Add "pmt_status", pStatus
    
    dataObj.SetColumnKeys("payment_due")
    SQL = "SELECT * FROM payment_due WHERE auto_uid=" & InvoiceNo
    
    If IsDataExist(SQL) Then
        Call dataObj.UpdateDBRow(SQL,dataTable)
    End If
    
End Sub


%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <script type="text/jscript">
    </script>
</head>
<body>
    <form id="form1" action="">
    </form>
</body>
</html>
