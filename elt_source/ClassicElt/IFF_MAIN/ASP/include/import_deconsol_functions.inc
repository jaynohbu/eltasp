<%
function get_ap_bill( ItemNo, Cost, vMAWB )
    DIM rs,SQL	
    Set rs=Server.CreateObject("ADODB.Recordset")
    SQL = "select bill_number from bill_detail where elt_account_number = "&elt_account_number&" and mb_no=N'" & vMAWB &"'"&_
            " and item_no=N'"&ItemNo&"'"&_
            " and ( item_amt=" & Cost & " or item_amt="& -1*CDbl(Cost) &") and bill_number <> 0"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
    if not rs.eof then
        get_ap_bill = rs(0).value
    else
        get_ap_bill = ""			
    end if
    set rs = nothing
end function


Sub save_cost_item_and_bill_detail_type(vAirOcean,vImportExport)
   		Dim rs,item_id
	    Set rs=Server.CreateObject("ADODB.Recordset")	
		SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number _
		    & " and mb_no=N'" & vMAWB & "'" & " AND iType='" & vAirOcean & "'"
		eltConn.Execute SQL
		OrigTotalCost=0
		item_id = 1
		for i=1 to NoCostItem
			if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
				SQL= "select * from mb_cost_item where elt_account_number = " & elt_account_number _
				    & " and mb_no=N'" & vMAWB & "' and item_id=" & item_id & " AND iType=N'" & vAirOcean & "'"
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("mb_no")=vMAWB
				rs("item_id")=item_id
				rs("item_no")=aCostItemNo(i-1)
				rs("item_desc")=aCostDesc(i-1)
				rs("ref_no")=aRefNo(i-1)
				rs("cost_amount")=aRealCost(i-1)
				if aLock_ap(i-1) <> "Y" then
					aLock_ap(i-1) = "N"
				end if
				rs("lock_ap")=aLock_ap(i-1)
				rs("Vendor_no")=vAgentOrgAcct
				rs("iType")=vAirOcean
				rs.Update
				rs.Close
				item_id = item_id + 1
			end if
		next
		
		SQL= "delete from bill_detail where elt_account_number = " & elt_account_number _
		    & " and mb_no=N'" & vMAWB & "'" & " AND iType=N'" & vAirOcean & "'"
		eltConn.Execute SQL
		item_id = 1
		for i=1 to NoCostItem
			if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
				SQL= "select * from bill_Detail where elt_account_number=" & elt_account_number _
				    & " and mb_no=N'" & vMAWB & "' and item_id=" & item_id & " AND iType=N'" & vAirOcean & "'"
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("mb_no")=vMAWB
				rs("item_id")=item_id
				if isnull(aLock_bill(i-1)) or aLock_bill(i-1) = "" then
					rs("bill_number")="0"
				else
					rs("bill_number")=aLock_bill(i-1)				
				end if
				rs("item_name")=aCostDesc(i-1)
				rs("item_no")=aCostItemNo(i-1)
				rs("ref")=aRefNo(i-1)
				rs("item_amt")=aRealCost(i-1)
				rs("item_amt_origin")=aRealCost(i-1)
				rs("item_expense_acct")=aExpense(i-1)				
				rs("tran_date")=vProcessDT
				rs("vendor_number")=vAgentOrgAcct
				rs("iType")=vAirOcean
				rs("import_export")=vImportExport
				rs("agent_debit_no")=vAgentDebitNo						
				rs.Update
				rs.Close
				item_id = item_id + 1				
			end if
		next

		Set rs=Nothing 
end Sub
%>

<%
Sub save_cost_item_and_bill_detail
   		Dim rs,item_id
	    Set rs=Server.CreateObject("ADODB.Recordset")	
		SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"'"
		eltConn.Execute SQL
		OrigTotalCost=0
		item_id = 1
		for i=1 to NoCostItem
			if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
				SQL= "select * from mb_cost_item where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB & "' and item_id=" & item_id
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("mb_no")=vMAWB
				rs("item_id")=item_id
				rs("item_no")=aCostItemNo(i-1)
				rs("item_desc")=aCostDesc(i-1)
				rs("ref_no")=aRefNo(i-1)
				rs("cost_amount")=aRealCost(i-1)
				if aLock_ap(i-1) <> "Y" then
					aLock_ap(i-1) = "N"
				end if
				rs("lock_ap")=aLock_ap(i-1)
				rs("Vendor_no")=vAgentOrgAcct
				rs("iType")="A"
				rs.Update
				rs.Close
				item_id = item_id + 1
			end if
		next
		
		SQL= "delete from bill_detail where elt_account_number = " & elt_account_number & " and mb_no=N'" & vMAWB &"'"
		eltConn.Execute SQL
		item_id = 1
		for i=1 to NoCostItem
			if Not aCostItemNo(i-1)="" And aRealCost(i-1)<>0 then
				SQL= "select * from bill_Detail where elt_account_number=" & elt_account_number & " and mb_no=N'" & vMAWB & "' and item_id=" & item_id
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("mb_no")=vMAWB
				rs("item_id")=item_id
				if isnull(aLock_bill(i-1)) or aLock_bill(i-1) = "" then
					rs("bill_number")="0"
				else
					rs("bill_number")=aLock_bill(i-1)				
				end if
				rs("item_name")=aCostDesc(i-1)
				rs("item_no")=aCostItemNo(i-1)
				rs("ref")=aRefNo(i-1)
				rs("item_amt")=aRealCost(i-1)
				rs("item_amt_origin")=aRealCost(i-1)
				rs("item_expense_acct")=aExpense(i-1)				
				rs("tran_date")=vProcessDT
				rs("ref")=aRefNo(i-1)
				rs("vendor_number")=vAgentOrgAcct
				rs("iType")="A"
				rs("agent_debit_no")=vAgentDebitNo						
				rs.Update
				rs.Close
				item_id = item_id + 1				
			end if
		next

		Set rs=Nothing 
end Sub
%>