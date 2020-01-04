<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
<%    
    '// Copied from header.asp /////////////////////////////////////////////////////
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'// Definitions /////////////////////////////////////////////////////////////////
	Dim vMode,vErrorCode,vTranDate,vInvoiceNo,vItemRef,vVendorNo,vItemNo,vItemId
	
	'// Initialize //////////////////////////////////////////////////////////////////
	vErrorCode = 0
	vTranDate = ""
	vInvoiceNo = ""
	vItemRef = ""
	vVendorNo = ""
	vItemNo = ""
	vItemId = ""
	
	'// Request Handling ////////////////////////////////////////////////////////////
	vMode = Request.QueryString("mode")
	vTranDate = Request.QueryString("tranDate")
	vInvoiceNo = Request.QueryString("invoiceNo")
	vItemRef = Request.QueryString("itemRef")
	vVendorNo = Request.QueryString("vendorNo")
	vItemNo = Request.QueryString("itemNo")
	vItemId = Request.QueryString("itemId")
                    
	
	'// Main ////////////////////////////////////////////////////////////////////////
	eltConn.BeginTrans
	On Error Resume Next:
	
	If vMode = "DeleteBillItem" Then
	    Call delete_bill_detail(vTranDate,vItemId,vInvoiceNo,vItemNo,vItemRef,vVendorNo)
	End If
	
    If err.number Then
        eltConn.RollbackTrans
        vErrorCode = 1
    Else
        eltConn.CommitTrans
        vErrorCode = 0
    End If
    
	'// Response ////////////////////////////////////////////////////////////////////
	If vErrorCode > 0 Then
	    Response.Write("Unexpected error has occurred. Item could not be deleted")
	Else
	    '// Response.Write("Item has been deleted successfully")
	End If
	Response.End()
	
	'// Subs ////////////////////////////////////////////////////////////////////////
    Sub delete_bill_detail(vTranDate, vItemID, vInvoiceNo, vItemNo, vRefNo, vVendorNo)
        Dim vSQL
        vSQL= "delete from bill_detail where elt_account_number=" & elt_account_number _ 
            & " and bill_number=0 and vendor_number=" & vVendorNo & " and tran_date='" _ 
	        & vTranDate & "' and item_id=" & vItemID & " and invoice_no=" & vInvoiceNo _
	        & " and item_no=" & vItemNo & " and ref=N'" & vRefNo & "'"
        eltConn.Execute vSQL
    End Sub

%>