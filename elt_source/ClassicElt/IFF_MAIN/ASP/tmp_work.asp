<!--  #INCLUDE FILE="./include/transaction.txt" -->
<!--  #INCLUDE FILE="./include/connection.asp" -->
<html>
<head>
<title>Search Invoices</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
</head>

<%

Set rs = Server.CreateObject("ADODB.Recordset")
Set rs2 = Server.CreateObject("ADODB.Recordset")

SQL= "select * from Invoice "
rs.Open SQL, eltConn, adOpenStatic, , adCmdText

Do While Not rs.EOF

SQL2= "select * from Invoice_tmp where elt_account_number = " & rs("elt_account_number") & " and invoice_no = " & rs("invoice_no")
	rs2.Open SQL2, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if rs2.EOF then
		response.write  rs("Invoice_No") & "(inserted)"
		response.write  "<br>"
		rs2.AddNew		
		rs2("elt_account_number") = rs("elt_account_number")                  
		rs2("Invoice_No")=          rs("Invoice_No")
		rs2("invoice_type")=        rs("invoice_type")
		rs2("import_export")=       rs("import_export")
		rs2("air_ocean")=           rs("air_ocean")
		rs2("invoice_Date")=        rs("invoice_Date")
		rs2("ref_no")=              rs("ref_no")
		rs2("Customer_Info")=       rs("Customer_Info")
		rs2("Total_Pieces")=        rs("Total_Pieces")
		rs2("Total_Gross_Weight")=  rs("Total_Gross_Weight")
		rs2("Total_Charge_Weight")= rs("Total_Charge_Weight")
		rs2("Description")=         rs("Description")
		rs2("Origin_Dest")=         rs("Origin_Dest")
		rs2("Origin")=              rs("Origin")
		rs2("Dest")=                rs("Dest")
		rs2("Customer_Number")=     rs("Customer_Number")
		rs2("Customer_Name")=       rs("Customer_Name")
		rs2("shipper")=             rs("shipper")
		rs2("consignee")=           rs("consignee")
		rs2("Entry_No")=            rs("Entry_No")
		rs2("Entry_Date")=          rs("Entry_Date")
		rs2("Carrier")=             rs("Carrier")
		rs2("Arrival_Dept")=        rs("Arrival_Dept")
		rs2("MAWB_NUM")=            rs("MAWB_NUM")
		rs2("HAWB_NUM")=            rs("HAWB_NUM")
		rs2("SubTotal")=            rs("SubTotal")
		rs2("Sale_Tax")=            rs("Sale_Tax")
		rs2("Agent_Profit")=        rs("Agent_Profit")
		rs2("accounts_receivable")= rs("accounts_receivable")
		rs2("amount_charged")=      rs("amount_charged")
		rs2("amount_paid")=      	rs("amount_paid")
		rs2("balance")=             rs("balance")
		rs2("total_cost")=          rs("total_cost")
		rs2("remarks")=             rs("remarks")
		rs2("pay_status")=          rs("pay_status")
		rs2("term_curr")=           rs("term_curr")
		rs2("term30")=           	rs("term30")
		rs2("term60")=           	rs("term60")
		rs2("term90")=           	rs("term90")
		rs2("received_amt")=        rs("received_amt")
		rs2("pmt_method")=          rs("pmt_method")
		rs2("existing_credits")=    rs("existing_credits")
		rs2("deposit_to")=          rs("term90")
		rs2("lock_ar")=             rs("lock_ar")
		rs2("lock_ap")=             rs("lock_ap")
		rs2("in_memo")=             rs("in_memo")
		rs2.Update
	else
		if not isnull(rs("import_export")) then
			response.write  rs("Invoice_No") & "               (updated)"
			response.write  "<br>"
			rs2("elt_account_number") = rs("elt_account_number")                  
			rs2("Invoice_No")=          rs("Invoice_No")
			rs2("invoice_type")=        rs("invoice_type")
			rs2("import_export")=       rs("import_export")
			rs2("air_ocean")=           rs("air_ocean")
			rs2("invoice_Date")=        rs("invoice_Date")
			rs2("ref_no")=              rs("ref_no")
			rs2("Customer_Info")=       rs("Customer_Info")
			rs2("Total_Pieces")=        rs("Total_Pieces")
			rs2("Total_Gross_Weight")=  rs("Total_Gross_Weight")
			rs2("Total_Charge_Weight")= rs("Total_Charge_Weight")
			rs2("Description")=         rs("Description")
			rs2("Origin_Dest")=         rs("Origin_Dest")
			rs2("Origin")=              rs("Origin")
			rs2("Dest")=                rs("Dest")
			rs2("Customer_Number")=     rs("Customer_Number")
			rs2("Customer_Name")=       rs("Customer_Name")
			rs2("shipper")=             rs("shipper")
			rs2("consignee")=           rs("consignee")
			rs2("Entry_No")=            rs("Entry_No")
			rs2("Entry_Date")=          rs("Entry_Date")
			rs2("Carrier")=             rs("Carrier")
			rs2("Arrival_Dept")=        rs("Arrival_Dept")
			rs2("MAWB_NUM")=            rs("MAWB_NUM")
			rs2("HAWB_NUM")=            rs("HAWB_NUM")
			rs2("SubTotal")=            rs("SubTotal")
			rs2("Sale_Tax")=            rs("Sale_Tax")
			rs2("Agent_Profit")=        rs("Agent_Profit")
			rs2("accounts_receivable")= rs("accounts_receivable")
			rs2("amount_charged")=      rs("amount_charged")
			rs2("amount_paid")=      	rs("amount_paid")
			rs2("balance")=             rs("balance")
			rs2("total_cost")=          rs("total_cost")
			rs2("remarks")=             rs("remarks")
			rs2("pay_status")=          rs("pay_status")
			rs2("term_curr")=           rs("term_curr")
			rs2("term30")=           	rs("term30")
			rs2("term60")=           	rs("term60")
			rs2("term90")=           	rs("term90")
			rs2("received_amt")=        rs("received_amt")
			rs2("pmt_method")=          rs("pmt_method")
			rs2("existing_credits")=    rs("existing_credits")
			rs2("deposit_to")=          rs("term90")
			rs2("lock_ar")=             rs("lock_ar")
			rs2("lock_ap")=             rs("lock_ap")
			rs2("in_memo")=             rs("in_memo")
			rs2.Update
		end if
	end if
	rs2.Close
	rs.MoveNext
Loop

Set rs=Nothing
Set rs2=Nothing
%>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->