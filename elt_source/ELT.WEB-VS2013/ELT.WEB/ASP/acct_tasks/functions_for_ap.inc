<% 
    sub check_number_update( BankAcctNo, vNextCheckNo )

        DIM rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    '// next check no
	    SQL= "select * from gl where elt_account_number = " & elt_account_number _
	        & " and gl_account_number = " & BankAcctNo
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if Not rs.EOF then
		    if Not vNextCheckNo="" then
			    rs("control_no")=vNextCheckNo
			    rs.Update
		    end if
	    end if
	    rs.Close
	    if Not EditCheck="yes" then
		    vCheck=vNextCheckNo
	    end If
    end sub

    function get_fiscal_year_of_first_date( vFiscalTo )

        DIM vFiscalFrom
        vFiscalFrom = DateAdd("m",-11,vFiscalTo)
        vFiscalFrom = cStr(month(vFiscalFrom)) & "/01/" & cStr(year(vFiscalFrom))

        get_fiscal_year_of_first_date = vFiscalFrom
    End function

    function get_fiscal_year_of_last_date( vFiscalYear )

        Dim tmpYear,tmpMonth,vCalcYear,vFiscalFrom,vFiscalTo,vfiscalEndMonth,rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
    	
        SQL= "select * from user_profile where elt_account_number = " & elt_account_number
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        
        If Not rs.EOF Then
	        vfiscalEndMonth=rs("fiscalEndMonth")
        end if
        rs.close

        if isnull(vFiscalEndMonth) or trim(vFiscalEndMonth) = "" then
	        vFiscalEndMonth = "12"
        end if

        tmpMonth = month(date)

        if vFiscalYear = "" or isnull( vFiscalYear ) then
	        if ( cInt(tmpMonth) = cInt(vfiscalEndMonth) ) then
		        if 	cInt(vfiscalEndMonth) = 12 then
 		          vFiscalYear = year(date)
		          vCalcYear = cInt(vFiscalYear)  
	  	        else
		          vCalcYear = year(date)	
 		          vFiscalYear = year(date) - 1
		        end if		
	        else
		        if 	cInt(vfiscalEndMonth) = 12 then
		          if cInt(tmpMonth	< 4) then
			          vFiscalYear = year(date) - 1
			          vCalcYear = cInt(vFiscalYear)
		          else
			          vFiscalYear = year(date)
			          vCalcYear = cInt(vFiscalYear)
		          end if			    
	  	        else
 		          vFiscalYear = year(date) -1 
		          vCalcYear =   year(date)
		        end if		
	        end if
        else
	        vCalcYear = cInt(vFiscalYear)  
        end if

        vFiscalTo = vfiscalEndMonth & "/" & "01" & "/" & cStr(vCalcYear)
        vFiscalTo = DateAdd("m",1,vFiscalTo)
        vFiscalTo = DateAdd("d",-1,vFiscalTo)

        get_fiscal_year_of_last_date = vFiscalTo

    End function

    function check_find_void ( cType, qID )
    
	    DIM rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "select top 1 chk_void from all_accounts_journal where elt_account_number = " _
            & elt_account_number & " and tran_num = '"& qID & "'" _	
	        & " and tran_type = '"& cType & "' and isnull(chk_void,'') = 'Y'"
	    
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

	    if Not rs.EOF then
		    check_find_void = true
	    else
		    check_find_void = false	
	    end if
        rs.close()
        
	    DIM tmp_v
	    tmp_v = request("chk_isVoid")
	    if isnull(tmp_v) then
		    exit function
	    end if

	    if tmp_v = "Y" then
		    EditCheck = "yes"
		    check_find_void  = true
	    end if
	    
    end function

    function check_find_complete ( cType, qID )
    
	    DIM rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "select top 1 chk_complete from all_accounts_journal where elt_account_number = " _
            & elt_account_number & " and tran_num = '"& qID & "'" _	
	        & " and tran_type = '"& cType & "' and isnull(chk_complete,'') = 'Y'"

        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

	    if Not rs.EOF then
		    check_find_complete = true
	    else
		    check_find_complete = false	
	    end if
        rs.close()
        
	    DIM tmp_c
	    tmp_c = request("chk_isCom")
	    if isnull(tmp_c) then
		    exit function
	    end if
	    if tmp_c = "Y" then
		    EditCheck = "yes"
		    check_find_complete  = true
	    end if

    end function

    Sub reset_payment_for_void ( NoItem )
    	
        DIM tmpVoid
	    tmpVoid = request("chk_isVoid")
	    if not isnull(tmpVoid) then 
		    if tmpVoid = "Y" then
			    CALL delete_gl_balance
			    vAmount= 0
			    for i=0 to NoItem-1			
				    BillAmtPaid(i)	= 0				
			    next	
		    end if
	    end if	
    	
    end Sub

    Sub reset_bill ( NoItem )
    
        DIM tmpVoid
	    tmpVoid = request("chk_isVoid")
	    if not isnull(tmpVoid) then 
		    if tmpVoid = "Y" then
			    CALL delete_gl_balance
			    call reset_bill_gl( NoItem )
		    end if
	    end if	
    end Sub

    Sub reset_bill_gl( NoItem )
    
        DIM SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    for i=0 to NoItem-1
		    BillNo(i)=Request("hBillNo" & i)
		    if BillNo(i)="" then BillNo(i)=-1
		    BillAmtPaid(i)=cDbl(Request("txtBillAmtPaid" & i))
		    if Not BillNo(i)=-1 then
			    SQL= "select * from bill where elt_account_number=" & elt_account_number _
			        & " and bill_number=" & BillNo(i)
			    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			    if Not rs.EOF then
				    rs("bill_amt_paid")=cDbl(rs("bill_amt_paid"))-BillAmtPaid(i)
				    rs("bill_amt_due")=cDbl(rs("bill_amt_due"))+BillAmtPaid(i)
				    rs("lock")="N"
				    rs("print_id")=null
				    rs("bill_status")="A"
				    rs.Update
			    end if
			    rs.Close
		    end if
	    next
    end Sub


    '// deduct AP amount by paid amount (0 if AP amount never existed)
    '// add Bank balance by paid amount (0 if Bank balance is never existed)
    Sub delete_gl_balance

        DIM apBalance
		SQL= "select * from gl where elt_account_number = " & elt_account_number _
		    & " and gl_account_number=" & vAP

		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If not rs.EOF then
		    If Not IsNull(rs("gl_account_balance")) then
			    apBalance=CDbl(rs("gl_account_balance"))-vLastAmount
		    Else
			    apBalance=0		
		    End If
            rs("gl_account_balance")=apBalance
            rs.Update
		End If
		rs.Close
		
        vBank = BankAcctNo		

        DIM bankBalance
		SQL= "select * from gl where elt_account_number = " & elt_account_number _
		    & " and gl_account_number=" & vBank

		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If not rs.EOF then
			If Not IsNull(rs("gl_account_balance")) then
				bankBalance=cDbl(rs("gl_account_balance"))+vLastAmount
			Else
				bankBalance=0
			End if			
			rs("gl_account_balance")=bankBalance
			rs.Update
		End If
		rs.Close		
    END Sub
%>


<%
    BankAcctNo = cLng(BankAcctNo)
    for i = 0 to bankIndex
	    if BankAcctNo=BankAcct(i) then
		    vAcctBalance=Cdbl(dpBal(i))
		    exit for
	    end if	
    next
%>