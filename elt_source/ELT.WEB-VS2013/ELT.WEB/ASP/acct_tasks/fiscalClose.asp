<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
    <title>Fiscal Statment</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%

Server.ScriptTimeout = 240 

DIM rs,SQL,Go
DIM vFiscalYear,vCalcYear,vFiscalFrom,vFiscalTo,glListIndex,GLList(),GLListName(),vfiscalEndMonth,glTypeListIndex
DIM aGlAccount(),aGlAccountName(),aGlTranType(),aGlAccountType(),aGlAccountTypeNormal(),aGlAccountTypeSystem(),aDebitAmount(),aCreditAmount(),aGlAccountBalance(),tIndex,selectedGlAccount,aClosedBy(),alreadyClosed,alreadyClosedAlready,aDebitMemo(),aCreditMemo()
DIM aRemark()
DIM ASSET_Total,EQUITY_Total,LIABILITY_Total,Balance,JobType
DIM TranNo,tNO,Save,Delete,vglMasterType,vglAccountType
DIM Excel
Set rs = Server.CreateObject("ADODB.Recordset")
Go = Request.QueryString("GO")
Save = Request.QueryString("Save")
Delete = Request.QueryString("Delete")
JobType = request("lstJob") 
Excel = Request.QueryString("Excel")

CALL session_uniq

tIndex = 0
vFiscalYear = request("txtFiscalYear") 
vFiscalFrom = request("txtFiscalFrom") 
vFiscalTo = request("txtFiscalTo") 

vglMasterType = Request("lstGlMasterType")
vglAccountType = Request("lstGlAccountType")
selectedGlAccount = Request("lstGlAccount")

if Excel = "Yes" then
	call export_to_excel
end if

CALL check_closed



if Go = "yes" then
	if ( vFiscalYear <> "" and vFiscalFrom <> "" and vFiscalTo <> "" ) then
		if JobType = "0" then
		    call fiscal_closing
		else
		    call load_closed_data
		end if
	end if
end if

if Save = "yes" then
	if CLng(tNo)=CLng(TranNo) then
		Session("CloseTranNo")=Clng(Session("CloseTranNo"))+1
		TranNo = Session("CloseTranNo")
		
		call save_closing_data
		call load_closed_data	
	else
	    call load_closed_data		
	end if
end if

if Delete = "yes" then
	if CLng(tNo)=CLng(TranNo) then
		Session("CloseTranNo")=Clng(Session("CloseTranNo"))+1
		TranNo = Session("CloseTranNo")
		call delete_closing_data
		call load_closed_data	
	else
	    call load_closed_data		
	end if
end if

call get_fiscal_year( vFiscalYear ) 
call get_all_gl_list
if selectedGlAccount = "" then selectedGlAccount = "0"
Set rs=Nothing



%>
<%
Sub delete_closing_data

SQL = "delete all_accounts_journal where elt_account_number=" & elt_account_number & " and tran_date = DATEADD(day, 1,'" & vFiscalTo & "') and isnull(flag_close,'') = 'Y'"

if trim(vglMasterType) <> "0" then
	if  vglMasterType = CONST__MASTER_EQUITY_NAME then
			SQL = SQL & " and gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & CONST__MASTER_EQUITY_NAME & "' or  gl_master_type='" & CONST__MASTER_REVENUE_NAME & "' or  gl_master_type='" & CONST__MASTER_EXPENSE_NAME & "'))	"
	else
		SQL = SQL & " and gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & vglMasterType & "'))	"
	end if
elseif trim(vglAccountType) <> "0" then
	SQL = SQL & " and gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_account_type='" & vglAccountType & "'))	"
elseif trim(selectedGlAccount) <> "0" then
	SQL = SQL & " and gl_account_number= " & selectedGlAccount
end if

eltConn.Execute SQL	
alreadyClosed = false
alreadyClosedAlready  = false
JobType = "0"

End SUb
%>
<%
Sub export_to_excel

DIM NoItem
DIM vGlAccount,vGlAccountName,vGlAccountType,vGlAccountTypeSystem,vGlAccountDebitAmount,vGlAccountCreditAmount,vGlAccountDebitMemo,vGlAccountCreditMemo,vRemark,vTran_Type,vClosedBy
DIM iCnt
NoItem=Request("hNoItem")

iCnt = NoItem

ReDim aGlAccount(iCnt),aGlAccountName(iCnt),aGlAccountType(iCnt),aGlAccountTypeNormal(iCnt),aGlAccountTypeSystem(iCnt),aDebitAmount(iCnt),aCreditAmount(iCnt),aGlAccountBalance(iCnt),aClosedBy(iCnt),aGlTranType(iCnt),aDebitMemo(iCnt),aCreditMemo(iCnt)
ReDim aRemark(iCnt)

tIndex = 0

for i=0 to NoItem - 1
	vGlAccountType=Request("txtType" & i)
	vGlAccountTypeSystem=Request("txtGlAccountTypeSystem" & i)
	vGlAccount=Request("txtGlAccount" & i)
	vGlAccountName=Request("txtGlAccountName" & i)
	vTran_Type=Request("txtTran_Type" & i)
	vGlAccountDebitAmount=Replace(Request("txtDebitAmount" & i),",","")	
	vGlAccountCreditAmount=Replace(Request("txtCreditAmount" & i),",","")	
	vGlAccountDebitMemo=Replace(Request("txtDebitMemo" & i),",","")		
	vGlAccountCreditMemo=Replace(Request("txtCreditMemo" & i),",","")		
	vRemark=Request("Remarks" & i)	
	vClosedBy=Request("ClosedBy" & i )
	aGlAccountType(tIndex)=vGlAccountType
	aGlAccountTypeSystem(tIndex)=vGlAccountTypeSystem
	aGlAccount(tIndex)=vGlAccount
	aGlAccountName(tIndex)=vGlAccountName
	aGlTranType(tIndex)=vTran_Type
	aDebitAmount(tIndex)=cDbl(vGlAccountDebitAmount)
	aCreditAmount(tIndex)=cDbl(vGlAccountCreditAmount)
	aDebitMemo(tIndex)=cDbl(vGlAccountDebitMemo)
	aCreditMemo(tIndex)=cDbl(vGlAccountCreditMemo)
	aRemark(tIndex)=vRemark
	aClosedBy(tIndex)=vClosedBy
	aGlAccountBalance(tIndex) = ( aDebitAmount(tIndex) + aDebitMemo(tIndex) ) - ( aCreditAmount(tIndex) + aCreditMemo(tIndex) )
	tIndex=tIndex+1
next
JobType = "0"

End SUb
%>
<%

Sub save_closing_data

DIM NoItem
DIM vGlAccount,vGlAccountName,vGlAccountType,vGlAccountDebitAmount,vGlAccountCreditAmount,vGlAccountDebitMemo,vGlAccountCreditMemo,vRemark,vTran_Type

NoItem=Request("hNoItem")

call delete_closing_data

for i=0 to NoItem - 1

	vGlAccountType=Request("txtType" & i)
	vGlAccount=Request("txtGlAccount" & i)
	vGlAccountName=Request("txtGlAccountName" & i)
	vTran_Type=Request("txtTran_Type" & i)
	if isnull(vTran_Type) then
		vTran_Type = ""
	end if
	vGlAccountDebitAmount=Replace(Request("txtDebitAmount" & i),",","")	
	vGlAccountCreditAmount=Replace(Request("txtCreditAmount" & i),",","")	
	vGlAccountDebitMemo=Replace(Request("txtDebitMemo" & i),",","")		
	vGlAccountCreditMemo=Replace(Request("txtCreditMemo" & i),",","")		
		
	vRemark=Request("Remarks" & i)	

	SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
		SeqNo = CLng(rs("SeqNo")) + 1
	Else
		SeqNo=1
	End If
	rs.Close

	vGlAccountCreditAmount = vGlAccountCreditAmount * -1
	vGlAccountCreditMemo = vGlAccountCreditMemo * -1			 

	SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	if rs.EOF then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("tran_seq_num")=SeqNo
		rs("gl_account_number")=vGlAccount
		rs("gl_account_name")=vGlAccountName
		rs("tran_type")=vTran_Type
		rs("tran_num")=i
		rs("tran_date")= DATEADD("d", 1,vFiscalTo)
		rs("customer_number")=0
		rs("customer_name")="_Fiscal Closing of "& vFiscalYear
		rs("memo") =vRemark
		rs("debit_amount") =vGlAccountDebitAmount
		rs("credit_amount") =vGlAccountCreditAmount
		rs("previous_balance") =0
		rs("gl_balance") =0
		rs("gl_previous_balance") =0
		rs("adjust_amount") =0
		rs("modifiedby") = login_name
		rs("modifiedDate") =Date()
		rs("debit_memo") =vGlAccountDebitMemo
		rs("credit_memo") =vGlAccountCreditMemo
		rs("flag_close") = "Y"
		rs.Update
	end if
	rs.Close
			
	alreadyClosed = true
	alreadyClosedAlready = False
	
next

End SUb
%>
<%
Sub session_uniq
	TranNo=Session("CloseTranNo")
	if TranNo="" then
		Session("CloseTranNo")=0
		TranNo=0
	end if
	tNo=Request.QueryString("tNo")
	if tNO="" then
		tNO=0
	else
		tNo=cLng(tNo)
	end if
End Sub
%>
<%
Sub load_closed_data
DIM iCnt
SQL = " SELECT count(a.gl_account_number) as CNT from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = "& elt_account_number & "  and a.gl_account_number=b.gl_account_number and a.tran_date = DATEADD(day, 1,'" & vFiscalTo & "') "

if trim(vglMasterType) <> "0" then
	if  vglMasterType = CONST__MASTER_EQUITY_NAME then
			SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & CONST__MASTER_EQUITY_NAME & "' or  gl_master_type='" & CONST__MASTER_REVENUE_NAME & "' or  gl_master_type='" & CONST__MASTER_EXPENSE_NAME & "'))	"
	else
		SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & vglMasterType & "'))	"
	end if
elseif trim(vglAccountType) <> "0" then
	SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_account_type='" & vglAccountType & "'))	"
elseif trim(selectedGlAccount) <> "0" then
	SQL = SQL & " and a.gl_account_number= " & selectedGlAccount
end if

SQL =SQL & "  and isnull(a.flag_close,'') = 'Y' group by b.gl_master_type, gl_account_type,a.gl_account_number,a.gl_account_name,a.tran_type,a.memo,a.modifiedBy"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

if NOT rs.eof and NOT rs.bof then
	Do until rs.EOF
 		iCnt = iCnt + 1
		rs.Movenext
 	Loop
end if	
rs.Close
if iCnt = 0 then
 exit sub
end if

ReDim aGlAccount(iCnt),aGlAccountName(iCnt),aGlAccountType(iCnt),aGlAccountTypeNormal(iCnt),aGlAccountTypeSystem(iCnt),aDebitAmount(iCnt),aCreditAmount(iCnt),aGlAccountBalance(iCnt),aClosedBy(iCnt),aGlTranType(iCnt),aDebitMemo(iCnt),aCreditMemo(iCnt)
ReDim aRemark(iCnt)

SQL = " SELECT CASE 	WHEN b.gl_master_type = '"&CONST__MASTER_REVENUE_NAME&"' or b.gl_master_type = '"&CONST__MASTER_EXPENSE_NAME&"' THEN                           '"&CONST__MASTER_EQUITY_NAME&"'    ELSE b.gl_master_type  END as Type, CASE    WHEN b.gl_account_type = '"&CONST__BANK&"' or b.gl_account_type = '"&CONST__ACCOUNT_RECEIVABLE&"' THEN '"&CONST__CURRENT_ASSET&"' WHEN b.gl_account_type = '"&CONST__ACCOUNT_PAYABLE&"' THEN      '"&CONST__CURRENT_LIB&"' WHEN b.gl_account_type = '"&CONST__OTHER_REVENUE&"' or b.gl_account_type = '"&CONST__REVENUE&"' THEN '"&CONST__EQUITY_RETAINED_EARNINGS&"' WHEN b.gl_account_type = '"&CONST__EXPENSE&"' or b.gl_account_type = '"&CONST__COST_OF_SALES&"' or b.gl_account_type = '"&CONST__OTHER_EXPENSE&"' THEN '"&CONST__EQUITY_RETAINED_EARNINGS&"' ELSE b.gl_account_type END as gl_account_type, b.gl_account_type as gl_account_type_in_system, a.gl_account_number as gl_account_number, a.tran_type as tran_type, a.gl_account_name as gl_account_name,sum(a.debit_amount) as Debit,sum(a.debit_memo) as debit_memo,sum(a.credit_amount) as Credit,sum(a.credit_memo) as credit_memo,a.memo as memo,a.modifiedBy as closedBy from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = "& elt_account_number & "  and a.gl_account_number=b.gl_account_number and a.tran_date = DATEADD(day, 1,'" & vFiscalTo & "') "

if trim(vglMasterType) <> "0" then
	if  vglMasterType = CONST__MASTER_EQUITY_NAME then
			SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & CONST__MASTER_EQUITY_NAME & "' or  gl_master_type='" & CONST__MASTER_REVENUE_NAME & "' or  gl_master_type='" & CONST__MASTER_EXPENSE_NAME & "'))	"
	else
		SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & vglMasterType & "'))	"
	end if
elseif trim(vglAccountType) <> "0" then
	SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_account_type='" & vglAccountType & "'))	"
elseif trim(selectedGlAccount) <> "0" then
	SQL = SQL & " and a.gl_account_number= " & selectedGlAccount
end if

SQL =SQL & "  and isnull(a.flag_close,'') = 'Y'  group by b.gl_master_type, gl_account_type,a.gl_account_number,a.gl_account_name,a.tran_type,a.memo,a.modifiedBy  order by type,gl_account_type,a.gl_account_number,a.tran_type"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

if NOT rs.eof and NOT rs.bof then
	tIndex=0
	Do until rs.EOF
		aGlAccountType(tIndex)=rs("Type")
		aGlAccountTypeNormal(tIndex)=rs("gl_account_type")
		aGlAccountTypeSystem(tIndex)=rs("gl_account_type_in_system")
		aGlAccount(tIndex)=rs("gl_account_number")
		aGlAccountName(tIndex)=rs("gl_account_name")
		aGlTranType(tIndex)=rs("tran_type")
		aDebitAmount(tIndex)=cDbl(rs("Debit"))
		aCreditAmount(tIndex)=cDbl(rs("Credit"))
		aDebitMemo(tIndex)=cDbl(rs("debit_memo"))
		aCreditMemo(tIndex)=cDbl(rs("credit_memo"))
		aRemark(tIndex)=rs("memo")
		aClosedBy(tIndex)=rs("ClosedBy")
		aGlAccountBalance(tIndex) = aDebitAmount(tIndex) + aDebitMemo(tIndex) + aCreditAmount(tIndex) + aCreditMemo(tIndex)
		 aCreditAmount(tIndex) = aCreditAmount(tIndex) * -1
		 aCreditMemo(tIndex) = aCreditMemo(tIndex) * -1
		tIndex=tIndex+1
		rs.Movenext
	Loop
end if
rs.Close

ASSET_Total = 0
EQUITY_Total = 0
LIABILITY_Total = 0
Balance = 0
End Sub
%>
<%
Sub check_closed
DIM iCnt
alreadyClosedAlready = false
alreadyClosed = false
if isnull(vFiscalTo) or vFiscalTo = "" then
 exit sub
end if 
iCnt = 0
SQL = " SELECT count(a.gl_account_number) as CNT from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = "& elt_account_number & "  and a.gl_account_number=b.gl_account_number and a.tran_date = DATEADD(day, 1,'" & vFiscalTo & "') and isnull(a.flag_close,'') = 'Y'" 
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

if NOT rs.eof and NOT rs.bof then
	iCnt = rs("CNT")
end if	
rs.close

if iCnt > 0 then
	alreadyClosed = true
	alreadyClosedAlready = true
end if
End Sub
%>
<%
Sub fiscal_closing

DIM iCnt
iCnt = 0

SQL = " SELECT count(a.gl_account_number) as CNT from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = "& elt_account_number & "  and a.gl_account_number=b.gl_account_number and ( a.tran_date >= '" & vFiscalFrom & "' AND a.tran_date < DATEADD(day, 1,'" & vFiscalTo & "')) "

if trim(vglMasterType) <> "0" then
	if  vglMasterType = CONST__MASTER_EQUITY_NAME then
			SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & CONST__MASTER_EQUITY_NAME & "' or  gl_master_type='" & CONST__MASTER_REVENUE_NAME & "' or  gl_master_type='" & CONST__MASTER_EXPENSE_NAME & "'))	"
	else
		SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & vglMasterType & "'))	"
	end if
elseif trim(vglAccountType) <> "0" then
	SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_account_type='" & vglAccountType & "'))	"
elseif trim(selectedGlAccount) <> "0" then
	SQL = SQL & " and a.gl_account_number= " & selectedGlAccount
end if

SQL =SQL & " and isnull(a.tran_type,'') <> 'INIT' group by b.gl_master_type, b.gl_account_type,a.gl_account_number,a.gl_account_name, a.tran_type "

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
if NOT rs.eof and NOT rs.bof then
	Do until rs.EOF
 		iCnt = iCnt + 1
		rs.Movenext
 	Loop
end if	
rs.Close
if iCnt = 0 then
 exit sub
end if
 iCnt = iCnt + 1
 
ReDim aGlAccount(iCnt),aGlAccountName(iCnt),aGlAccountType(iCnt),aGlAccountTypeNormal(iCnt),aGlAccountTypeSystem(iCnt),aDebitAmount(iCnt),aCreditAmount(iCnt),aGlAccountBalance(iCnt),aClosedBy(iCnt),aGlTranType(iCnt),aDebitMemo(iCnt),aCreditMemo(iCnt)
ReDim aRemark(iCnt)

SQL = " SELECT CASE 	WHEN b.gl_master_type = '"&CONST__MASTER_REVENUE_NAME&"' or b.gl_master_type = '"&CONST__MASTER_EXPENSE_NAME&"' THEN                           '"&CONST__MASTER_EQUITY_NAME&"'    ELSE b.gl_master_type  END as Type, CASE    WHEN b.gl_account_type = '"&CONST__BANK&"' or b.gl_account_type = '"&CONST__ACCOUNT_RECEIVABLE&"' THEN '"&CONST__CURRENT_ASSET&"' WHEN b.gl_account_type = '"&CONST__ACCOUNT_PAYABLE&"' THEN      '"&CONST__CURRENT_LIB&"' WHEN b.gl_account_type = '"&CONST__OTHER_REVENUE&"' or b.gl_account_type = '"&CONST__REVENUE&"' THEN '"&CONST__EQUITY_RETAINED_EARNINGS&"' WHEN b.gl_account_type = '"&CONST__EXPENSE&"' or b.gl_account_type = '"&CONST__COST_OF_SALES&"' or b.gl_account_type = '"&CONST__OTHER_EXPENSE&"' THEN '"&CONST__EQUITY_RETAINED_EARNINGS&"' ELSE b.gl_account_type END as gl_account_type, b.gl_account_type as gl_account_type_in_system, a.gl_account_number as gl_account_number, a.gl_account_name as gl_account_name,isnull(a.tran_type,'') as tran_type, sum(a.debit_amount+ISNULL(a.debit_memo,0)) as Debit,sum(a.credit_amount+ISNULL(a.credit_memo,0)) as Credit from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = "& elt_account_number & "  and a.gl_account_number=b.gl_account_number and ( a.tran_date >= '" & vFiscalFrom & "' AND a.tran_date < DATEADD(day, 1,'" & vFiscalTo & "')) "

if trim(vglMasterType) <> "0" then
	if  vglMasterType = CONST__MASTER_EQUITY_NAME then
		SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & CONST__MASTER_EQUITY_NAME & "' or  gl_master_type='" & CONST__MASTER_REVENUE_NAME & "' or  gl_master_type='" & CONST__MASTER_EXPENSE_NAME & "'))	"
	else
		SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_master_type='" & vglMasterType & "'))	"
	end if
elseif trim(vglAccountType) <> "0" then
	SQL = SQL & " and a.gl_account_number in " & "(select gl_account_number from gl WHERE elt_account_number = " & elt_account_number & " and ( gl_account_type='" & vglAccountType & "'))	"
elseif trim(selectedGlAccount) <> "0" then
	SQL = SQL & " and a.gl_account_number= " & selectedGlAccount
end if

SQL =SQL & "  and isnull(a.tran_type,'') <> 'INIT' group by b.gl_master_type, b.gl_account_type,a.gl_account_number,a.gl_account_name, a.tran_type order by type,gl_account_type,a.gl_account_number,a.tran_type"
'response.write SQL
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
if NOT rs.eof and NOT rs.bof then
	tIndex=0
	Do until rs.EOF
		aGlAccountType(tIndex)=rs("Type")
		aGlAccountTypeNormal(tIndex)=rs("gl_account_type")
		aGlAccountTypeSystem(tIndex)=rs("gl_account_type_in_system")
		aGlAccount(tIndex)=rs("gl_account_number")
		aGlAccountName(tIndex)=rs("gl_account_name")
		aGlTranType(tIndex)=rs("tran_type")
		aDebitAmount(tIndex)=cDbl(rs("Debit"))
		aCreditAmount(tIndex)=cDbl(rs("Credit"))
		aClosedBy(tIndex)=""
		aGlAccountBalance(tIndex) = aDebitAmount(tIndex) + aCreditAmount(tIndex) 
	    aCreditAmount(tIndex) = aCreditAmount(tIndex) * -1
		tIndex=tIndex+1
		rs.Movenext
	Loop
end if
rs.Close

ASSET_Total = 0
EQUITY_Total = 0
LIABILITY_Total = 0
Balance = 0

End Sub
%>
<%
Sub get_all_gl_list
DIM iCnt	
	SQL= "select count(*) as cnt from gl where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	if NOT rs.eof then
		iCnt = rs("cnt")
		rs.close
	else
		rs.close
		exit sub
	end if	
	
	ReDim GLList(iCnt),GLListName(iCnt)
	
	SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " order by gl_account_number"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	if NOT rs.eof and NOT rs.bof then
		glListIndex=0
		Do until rs.EOF
			GLList(glListIndex)=rs("gl_account_number")
			if GLList(glListIndex)="" then GLList(glrIndex)=0
			GLListName(glListIndex)=rs("gl_account_desc")
			glListIndex=glListIndex+1
			rs.Movenext
		Loop
	end if
	rs.Close
	
End Sub
%>
<%
Sub get_fiscal_year( vFiscalYear )
dim tmpYear,tmpMonth

SQL= "select fiscalEndMonth from user_profile where elt_account_number = " & elt_account_number
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
vFiscalFrom = DateAdd("m",-11,vFiscalTo)
If (month(vFiscalFrom)<10) Then
    vFiscalFrom = "0"&cStr(month(vFiscalFrom)) & "/01/" & cStr(year(vFiscalFrom))
Else
    vFiscalFrom = cStr(month(vFiscalFrom)) & "/01/" & cStr(year(vFiscalFrom))
End If


End sub
%>
<body link="336699" vlink="336699">
    <% 
DIM  tmpGlAccountType,tmpColor,ii
DIM  DebitAmount_Sub_Total, CreditAmount_Sub_Total, DebitMemo_Sub_Total,CreditMemo_Sub_Total
tmpGlAccountType = ""		  
    %>
    <% if Excel <> "Yes" then %>
    <script type="text/javascript" language="javascript">
        //added by stanley on 11/8/2007
        function checkyear() {
            var year = document.getElementById("FiscalYear").value;
            if (year < 1800 || year == "") {
                var d = new Date()
                alert("Please enter correct year");
                document.getElementById("FiscalYear").value = d.getYear();
                document.getElementById("FiscalFrom").value = "1/01/" + d.getYear();
                document.getElementById("FiscalTo").value = "12/31/" + d.getYear();
            }

        }
    
    </script>
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td align="left" valign="middle" class="pageheader">
                Account Summary
            </td>
        </tr>
    </table>
    <form name="form1" method="post">
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#89A979">
        <tr>
            <td>
                <input type="hidden" name="hNoItem" value="<%= tIndex %>">
                <input type="hidden" name="glAccount">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="89A979"
                    class="border1px">
                    <tr bgcolor="D5E8CB">
                        <td height="8" colspan="3" align="left" valign="top" bgcolor="D5E8CB" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="3" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="22" colspan="3" align="center" bgcolor="f3f3f3" class="bodyheader">
                            <br>
                            <br>
                            <table width="68%" border="0" cellpadding="0" cellspacing="0" bordercolor="#89A979"
                                bgcolor="#FFFFFF" class="border1px" style="padding-left: 10px">
                                <tr>
                                    <td height="20" align="left" valign="middle" bgcolor="#D5E8CB" class="highlight">
                                        Fiscal Year
                                    </td>
                                    <td colspan="3" align="left" valign="middle" bgcolor="#D5E8CB" class="bodyheader">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="middle" bgcolor="#D5E8CB" class="bodyheader">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input name="txtFiscalYear" class="inputBox" id="FiscalYear" value="<%= vFiscalYear%>"
                                            size="15" style="background-color: #ffffc0"
                                            maxlength="4"  onchange="ChangePeriod()" onfouse="ChangePeriod()"
                                            onblur="checkyear()">
                                    </td>
                                    <td colspan="4">
                                        <input name="txtFiscalFrom" class="display" id="FiscalFrom" value="<%= vFiscalFrom%>"
                                            size="10" maxlength="10" readonly="true" />
                                        &nbsp;&mdash;&nbsp;
                                        <input name="txtFiscalTo" class="display" id="FiscalTo" value="<%= vFiscalTo%>" size="11"
                                            readonly="true" />
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="89A979">
                                    <td height="2" class="bodyheader" colspan="5">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" bgcolor="#f3f3f3" colspan="2">
                                        <span class="bodyheader">GL Master Type</span>
                                    </td>
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        <span class="bodyheader">GL Account Type</span>
                                    </td>
                                    <td bgcolor="#f3f3f3" class="bodyheader">
                                        GL Account No.
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" colspan="2">
                                        <select name="lstGlMasterType" size="1" class="smallselect lstGlMasterType" style="width: 90px" onchange="changeOtherOptions1(this)">
                                            <option value="0">All</option>
                                            <option <% if vglMasterType=CONST__MASTER_ASSET_NAME then response.write("Selected") %>>
                                                <%=CONST__MASTER_ASSET_NAME%>
                                            </option>
                                            <option <% if vglMasterType=CONST__MASTER_LIABILITY_NAME then response.write("Selected") %>>
                                                <%=CONST__MASTER_LIABILITY_NAME%>
                                            </option>
                                            <option <% if vglMasterType=CONST__MASTER_EQUITY_NAME then response.write("Selected") %>>
                                                <%=CONST__MASTER_EQUITY_NAME%>
                                            </option>
                                        </select>
                                    </td>
                                    <td colspan="2">
                                        <select name="lstGlAccountType" size="1" class="smallselect lstGlAccountType" style="width: 140px"
                                            onchange="changeOtherOptions2(this)">
                                            <option value="0">All</option>
                                            <option <% if vglAccountType=CONST__CURRENT_ASSET then response.write("Selected") %>>
                                                <%=CONST__CURRENT_ASSET%>
                                            </option>
                                            <option <% if vglAccountType=CONST__ACCOUNT_RECEIVABLE then response.write("Selected") %>>
                                                <%=CONST__ACCOUNT_RECEIVABLE%>
                                            </option>
                                            <option <% if vglAccountType=CONST__FIXED_ASSET then response.write("Selected") %>>
                                                <%=CONST__FIXED_ASSET%>
                                            </option>
                                            <option <% if vglAccountType=CONST__OTHER_ASSET then response.write("Selected") %>>
                                                <%=CONST__OTHER_ASSET%>
                                            </option>
                                            <option <% if vglAccountType=CONST__BANK then response.write("Selected") %>>
                                                <%=CONST__BANK%>
                                            </option>
                                            <option <% if vglAccountType=CONST__CURRENT_LIB then response.write("Selected") %>>
                                                <%=CONST__CURRENT_LIB%>
                                            </option>
                                            <option <% if vglAccountType=CONST__ACCOUNT_PAYABLE then response.write("Selected") %>>
                                                <%=CONST__ACCOUNT_PAYABLE%>
                                            </option>
                                            <option <% if vglAccountType=CONST__LONG_TERM_LIB then response.write("Selected") %>>
                                                <%=CONST__LONG_TERM_LIB%>
                                            </option>
                                            <option <% if vglAccountType=CONST__EQUITY then response.write("Selected") %>>
                                                <%=CONST__EQUITY%>
                                            </option>
                                            <option <% if vglAccountType=CONST__REVENUE then response.write("Selected") %>>
                                                <%=CONST__REVENUE%>
                                            </option>
                                            <option <% if vglAccountType=CONST__COST_OF_SALES then response.write("Selected") %>>
                                                <%=CONST__COST_OF_SALES%>
                                            </option>
                                            <option <% if vglAccountType=CONST__EXPENSE then response.write("Selected") %>>
                                                <%=CONST__EXPENSE%>
                                            </option>
                                            <option <% if vglAccountType=CONST__OTHER_REVENUE then response.write("Selected") %>>
                                                <%=CONST__OTHER_REVENUE%>
                                            </option>
                                            <option <% if vglAccountType=CONST__OTHER_EXPENSE then response.write("Selected") %>>
                                                <%=CONST__OTHER_EXPENSE%>
                                            </option>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="lstGlAccount" size="1" class="smallselect" id="lstGlAccount lstGlAccount" style="width: 280px"
                                            onchange="changeOtherOptions3(this)">
                                            <option value="0">All</option>
                                            <% for k=0 to glListIndex-1 %>
                                            <option value="<%= GLList(k) %>" <% if cLng(GLList(k)) = cLng(selectedGlAccount) then response.Write("selected")%>>
                                                <%= GLList(k) & " --- " & GLListName(k) %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" colspan="4" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        <select name="lstJob" size="1" class="smallselect lstJob" id="lstJob" style="width: 180px">
                                            <option value="0" <%if JobType = "0" then response.Write("selected")%>>Balance Check
                                                Before Closing</option>
                                            <option value="1" <%if JobType = "1" then response.Write("selected")%>>Display Closed
                                                Data</option>
                                        </select>
                                        <img src="../images/button_view_summary.gif" alt="Click to view summary" width="104"
                                            height="18" align="absmiddle" style="cursor: hand; margin-left: 16px" onclick="GoClick()">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px">
                                    </td>
                                </tr>
                            </table>
                            <% if alreadyClosed then %>
                            <table width="68%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td height="20" align="right" valign="bottom">
                                        <span class="bodycopy"><span class="style1">
                                            <% 
					if alreadyClosedAlready then
					response.write("Fiscal Year " & vFiscalYear & " has been closed already.")
					else
					response.write("Fiscal Year " & vFiscalYear & " has been closed.")
					end if	
                                            %>
                                        </span></span>
                                    </td>
                                </tr>
                            </table>
                            <% end if %>
                            <br>
                            <br>
                        </td>
                    </tr>
                    <tr bgcolor="#FFFFFF">
                        <td height="20" colspan="3" align="left" bgcolor="#f3f3f3" style="padding-left: 10px">
                            <% if tIndex > 0 then %>
                            <img src="../images/button_fiscal_closing.gif" width="124" height="18" name="bSave"
                                onclick="SaveClick(<%= TranNo %>)" <% if UserRight<5 or Not Branch="" then response.write("disabled") %>
                                style="cursor: hand"><% end if %>
                            <% if tIndex > 0 and jobType > 0 then %>
                            <img src="../images/button_undo_year.gif" width="150" height="18" name="bDelete"
                                onclick="DeleteClick(<%= TranNo %>)" <% if UserRight<5 or Not Branch="" then response.write("disabled") %>
                                style="cursor: hand; margin-left: 24px">
                            <% end if %>
                            <% if tIndex > 0 then %>
                            <img src="../images/button_exel_low.gif" width="53" height="18" name="bExcel" onclick="Excel()"
                                style="cursor: hand; margin-left: 24px">
                            <% end if %>
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td width="60%" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr bgcolor="#FFFFFF">
                        <td height="20" colspan="3" align="left" bgcolor="#D5E8CB">
                            <% if  tIndex > 0 then %>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                <tr align="left" valign="middle" bgcolor="#e9cd94" class="bodyheader">
                                    <td height="24" align="center" bgcolor="#E7F0E2">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        GL Acct. No.
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Description
                                    </td>
                                    <td bgcolor="#E7F0E2">
                                        Tran. Type
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Debit
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Credit
                                    </td>
                                    <td bgcolor="#E7F0E2">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Balance
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Remarks
                                    </td>
                                    <td align="left" bgcolor="#E7F0E2">
                                        Last Modified
                                    </td>
                                </tr>
                                <!--// -->
                                <input type="hidden" id="DebitAmount">
                                <input type="hidden" id="CreditAmount">
                                <input type="hidden" id="DebitMemo">
                                <input type="hidden" id="CreditMemo">
                                <input type="hidden" id="Balance">
                                <input type="hidden" id="Type">
                                <!--// -->
                                <% for i=0 to tIndex-1 %>
                                <% 
				ii = i mod 2
				if ii = 1 then
					tmpColor = "#FFFFFF"
				else
					tmpColor = "#FFFFFF"
				end if
                                %>
                                <% 
					if aGlAccountType(i) <> tmpGlAccountType then 
						tmpGlAccountType = aGlAccountType(i)	
						DebitAmount_Sub_Total = 0
						CreditAmount_Sub_Total = 0
						DebitMemo_Sub_Total = 0
						CreditMemo_Sub_Total = 0
                                %>
                                <tr>
                                    <td colspan="12" height="1" bgcolor="#89A979">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#f7ecd6" class="bodycopy">
                                    <td height="18" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="#f3f3f3">
                                        <span class="style4">
                                            <% 
						response.write "<b>" & aGlAccountType(i) & "<b>"
						
                                            %>
                                        </span>
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <% end if %>
                                <%
				DebitAmount_Sub_Total = aDebitAmount(i) +  DebitAmount_Sub_Total
				CreditAmount_Sub_Total = aCreditAmount(i) +  CreditAmount_Sub_Total
				DebitMemo_Sub_Total = aDebitMemo(i) +  DebitMemo_Sub_Total
				CreditMemo_Sub_Total = aCreditMemo(i) +  CreditMemo_Sub_Total			
                                %>
                                <tr align="left" valign="middle" bgcolor="<%=tmpColor%>" class="bodycopy">
                                    <td width="17" height="18">
                                        <input type="hidden" name="txtType<%= i %>" id="Type" class="Type" value="<%= aGlAccountType(i) %>"
                                            size="14">
                                    </td>
                                    <td width="126" align="left">
                                        <input name="txtGlAccountTypeSystem<%= i %>" class="shorttextfield GlAccountTypeSystem" id="GlAccountTypeSystem"
                                            value="<%= aGlAccountTypeSystem(i)%>" size="20" style="border-style: none" readonly="true">
                                    </td>
                                    <td width="97" align="left">
                                        <input name="txtGlAccount<%= i %>" class="shorttextfield GlAccount" id="GlAccount" value="<%= aGlAccount(i)%>"
                                            size="10" style="border-style: none" readonly="true">
                                    </td>
                                    <td width="201" align="left">
                                        <input name="txtGlAccountName<%= i %>" class="shorttextfield GlAccountName" id="GlAccountName"
                                            value="<%= aGlAccountName(i)%>" size="30" style="border-style: none" readonly="true">
                                    </td>
                                    <td width="111" align="left">
                                        <input name="txtTran_Type<%= i %>" class="shorttextfield GlTran_Type" id="GlTran_Type" value="<%= aGlTranType(i)%>"
                                            size="11" style="border-style: none" readonly="true">
                                    </td>
                                    <td width="81" align="left">
                                        <input name="txtDebitAmount<%= i %>" class="numberfield DebitAmount" id="DebitAmount" value="<%= FormatNumber(aDebitAmount(i),2,,0) %>"
                                            size="12" style="border-style: none; font-weight: bold; background: #f3f3f3"
                                            readonly="true">
                                    </td>
                                    <td width="17" align="left">
                                        <input type="hidden" name="txtDebitMemo<%= i %>" class="shorttextfield DebitMemo" id="DebitMemo"
                                            value="<%= FormatNumber(aDebitMemo(i),2,,0) %>" size="10" style="behavior: url(../include/igNumChkRight.htc);
                                            font-weight: bold" onblur="AdjustChange(<%= i %>,false,event)" onkeydown="AdjustChange(<%= i %>,true,event)">
                                    </td>
                                    <td width="71" align="left">
                                        <input name="txtCreditAmount<%= i %>" class="numberfield CreditAmount" id="CreditAmount" value="<%= FormatNumber(aCreditAmount(i),2,,0) %>"
                                            size="12" style="border-style: none; font-weight: bold; background: #f3f3f3"
                                            readonly="true">
                                    </td>
                                    <td width="17" align="left">
                                        <input type="hidden" name="txtCreditMemo<%= i %>" class="shorttextfield CreditMemo" id="CreditMemo"
                                            value="<%= FormatNumber(aCreditMemo(i),2,,0) %>" size="10" style="behavior: url(../include/igNumChkRight.htc);
                                            font-weight: bold" onblur="AdjustChange(<%= i %>,false,event)" onkeydown="AdjustChange(<%= i %>,true,event)">
                                    </td>
                                    <td width="98" align="left">
                                        <input name="txtBalance<%= i %>" class="numberfield Balance" id="Balance" value="<%= FormatNumber(aGlAccountBalance(i),2,,0) %>"
                                            size="12" style="border-style: none; font-weight: bold" readonly="true">
                                    </td>
                                    <td width="130" align="left">
                                        <input name="Remarks<%= i %>" class="shorttextfield Remarks" id="Remarks" value="<%= aRemark(i) %>"
                                            size="20">
                                    </td>
                                    <td width="128" align="left">
                                        <input name="ClosedBy<%= i %>" class="shorttextfield ClosedBy" id="ClosedBy" value="<%= aClosedBy(i) %>"
                                            size="14" style="border-style: none; font-weight: bold; text-align: center" readonly="true">
                                    </td>
                                </tr>
                                <% 
					if aGlAccountType(i+1) <> tmpGlAccountType then 
                                %>
                                <tr>
                                    <td height="1" colspan="12" bgcolor="#89A979">
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                    <td height="20" bgcolor="#F0F0F0">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#F0F0F0">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#F0F0F0">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#F0F0F0" align="left">
                                        &nbsp;
                                    </td>
                                    <td width="111" align="left" bgcolor="#F0F0F0">
                                        <span class="style4">
                                            <% 
						response.write "<b>" & "Sub Total" & "<b>"
						Balance_Sub_Total = ( DebitAmount_Sub_Total + DebitMemo_Sub_Total ) - ( CreditAmount_Sub_Total + CreditMemo_Sub_Total )
                                            %>
                                        </span>
                                    </td>
                                    <td width="81" align="left" bgcolor="#F0F0F0">
                                        <input name="txtDebitAmount_Sub_Total_<%=aGlAccountType(i)%>" class="numberfield txtDebitAmount_Sub_Total_<%=aGlAccountType(i)%>"
                                            id="DebitAmount_Sub_Total" value="<%= FormatNumber(DebitAmount_Sub_Total,2,,0) %>"
                                            size="12" readonly="true" style="border-style: none; font-weight: bold; background: #f3f3f3">
                                    </td>
                                    <td width="17" align="left" bgcolor="#F0F0F0">
                                        <input type="hidden" name="txtDebitMemo_Sub_Total_<%=aGlAccountType(i)%>" class="numberfield txtDebitMemo_Sub_Total_<%=aGlAccountType(i)%>"
                                            id="DebitMemo_Sub_Total" value="<%= FormatNumber(DebitMemo_Sub_Total,2,,0) %>"
                                            size="10" readonly="true" style="border-style: none; font-weight: bold; background: #f3f3f3">
                                    </td>
                                    <td bgcolor="#F0F0F0" width="71" align="left">
                                        <input name="txtCreditAmount_Sub_Total_<%=aGlAccountType(i)%>" class="numberfield txtCreditAmount_Sub_Total_<%=aGlAccountType(i)%>"
                                            id="CreditAmount_Sub_Total" value="<%= FormatNumber(CreditAmount_Sub_Total,2,,0) %>"
                                            size="12" readonly="true" style="border-style: none; font-weight: bold; background: #f3f3f3">
                                    </td>
                                    <td width="17" align="left" bgcolor="#F0F0F0">
                                        <input type="hidden" name="txtCreditMemo_Sub_Total_<%=aGlAccountType(i)%>" class="numberfield txtCreditMemo_Sub_Total_<%=aGlAccountType(i)%>"
                                            id="CreditMemo_Sub_Total" value="<%= FormatNumber(CreditMemo_Sub_Total,2,,0) %>"
                                            size="10" readonly="true" style="border-style: none; font-weight: bold; background: #f3f3f3">
                                    </td>
                                    <td width="98" align="left" bgcolor="#F0F0F0">
                                        <input name="txtBalance_Sub_Total_<%=aGlAccountType(i)%>" class="numberfield txtBalance_Sub_Total_<%=aGlAccountType(i)%>" 
                                            id="Balance_Sub_Total"
                                            value="<%= FormatNumber(Balance_Sub_Total,2,,0) %>" size="12" readonly="true"
                                            style="border-style: none; font-weight: bold; background: #f3f3f3">
                                    </td>
                                    <td width="130" align="left" bgcolor="#F0F0F0">
                                        &nbsp;
                                    </td>
                                    <td align="left" bgcolor="#F0F0F0">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="89A979">
                                    <td colspan="12" height="1" class="bodyheader">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="12" height="1" bgcolor="#ffffff">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="12" height="1" bgcolor="#89A979">
                                    </td>
                                </tr>
                                <% if selectedGlAccount = "0" and vglMasterType = "0" and vglAccountType = "0" then	%>
                                <%		  
					  if aGlAccountType(i) = CONST__MASTER_ASSET_NAME then
						  ASSET_Total = Balance_Sub_Total
					  elseif aGlAccountType(i) = CONST__MASTER_EQUITY_NAME then 	  
						  EQUITY_Total = Balance_Sub_Total
					  elseif aGlAccountType(i) = CONST__MASTER_LIABILITY_NAME then 	  
						  LIABILITY_Total = Balance_Sub_Total
					  end if		  			  
                                %>
                                <% end if %>
                                <% end if %>
                                <% next %>
                                <%
				Balance = ASSET_Total + EQUITY_Total + LIABILITY_Total
                                %>
                                <% if selectedGlAccount = "0" and vglMasterType = "0" and vglAccountType = "0" then	%>
                                <tr>
                                    <td>
                                    </td>
                                    <td height="24">
                                    </td>
                                    <td>
                                    </td>
                                    <td height="10" colspan="6" bgcolor="#D5E8CB" align="right">
                                        &nbsp;<b>Total Balance =
                                            <input name="txtASSET_Total" class="numberfield ASSET_Total" id="ASSET_Total" value="<%= FormatNumber(ASSET_Total,2,,0) %>"
                                                size="12" readonly="true" style="border-style: none; font-weight: bold">
                                            +
                                            <input name="txtEQUITY_Total" class="numberfield EQUITY_Total" id="EQUITY_Total" value="<%= FormatNumber(EQUITY_Total,2,,0) %>"
                                                size="12" readonly="true" style="border-style: none; font-weight: bold">
                                            +
                                            <input name="txtLIABILITY_Total" class="numberfield LIABILITY_Total" id="LIABILITY_Total" value="<%= FormatNumber(LIABILITY_Total,2,,0) %>"
                                                size="12" readonly="true" style="border-style: none; font-weight: bold">
                                            = </b>
                                    </td>
                                    <td>
                                        <b>
                                            <input name="txtBalance" class="numberfield Balance" id="Balance" value="<%= FormatNumber(Balance,2,,0) %>"
                                                size="12" readonly="true" style="border-style: none; font-weight: bold">
                                        </b>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr align="left" valign="middle" bgcolor="89A979">
                                    <td colspan="12" height="1" class="bodyheader">
                                    </td>
                                </tr>
                                <% end if %>
                            </table>
                            <% end if %>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br>
    </form>
    <% else %>
    <br>
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="center" valign="middle">
                <span class="style1">Account Summary</span>
            </td>
        </tr>
    </table>
    <form name="form2" method="post">
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#89A979">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="89A979"
                    class="border1px">
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="2" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td width="16%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                            Fiscal Year :
                        </td>
                        <td width="44%" align="left">
                            <%= vFiscalYear%>
                        </td>
                        <td width="16%">
                            &nbsp;
                        </td>
                        <td width="4%">
                            &nbsp;
                        </td>
                        <td width="4%">
                            &nbsp;
                        </td>
                        <td width="4%">
                            &nbsp;
                        </td>
                        <td width="4%">
                            &nbsp;
                        </td>
                        <td width="4%">
                            &nbsp;
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="22" bgcolor="f3f3f3" class="bodyheader" align="right">
                            Period :
                        </td>
                        <td align="left">
                            <%= vFiscalFrom%>
                            ~<%= vFiscalTo%>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <% if vglMasterType <> "0" then %>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="22" bgcolor="f3f3f3" class="bodyheader" align="right">
                            Gl Master Type :
                        </td>
                        <td align="left">
                            <%=vglMasterType%>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <% end if %>
                    <% if vglAccountType <> "0" then %>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="22" bgcolor="f3f3f3" class="bodyheader" align="right">
                            Gl Account Type :
                        </td>
                        <td align="left">
                            <%=vglAccountType%>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <% end if %>
                    <% if selectedGlAccount <> "0" then %>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="22" bgcolor="f3f3f3" class="bodyheader" align="right">
                            Gl Account No. :
                        </td>
                        <td align="left">
                            <%=selectedGlAccount%>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <% end if %>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="2" height="1" class="bodyheader">
                        </td>
                    </tr>
                </table>
                <% if  tIndex > 0 then %>
                <table width="100%" border="1" cellpadding="2" cellspacing="0" bordercolor="89A979"
                    class="border1px">
                    <tr align="left" valign="middle" bgcolor="#e9cd94" class="bodyheader">
                        <td height="20" align="center" bgcolor="#e9cd94">
                            &nbsp;
                        </td>
                        <td height="20" align="left">
                            GL Acct. No.
                        </td>
                        <td height="20" align="center">
                            Description
                        </td>
                        <td align="center">
                            Tran. Type
                        </td>
                        <td height="20" align="center">
                            Debit
                        </td>
                        <td height="20" align="center">
                            Credit
                        </td>
                        <td height="20" align="center">
                            Balance
                        </td>
                        <td height="20" align="center">
                            Remarks
                        </td>
                        <td height="20" align="center">
                            Last Modified
                        </td>
                    </tr>
                    <% for i=0 to tIndex-1 %>
                    <% 
		  	ii = i mod 2
		  	if ii = 1 then
				tmpColor = "#FFFFFF"
			else
				tmpColor = "#F3F3F3"
			end if
                    %>
                    <% 
				if aGlAccountType(i) <> tmpGlAccountType then 
					tmpGlAccountType = aGlAccountType(i)	
					DebitAmount_Sub_Total = 0
					CreditAmount_Sub_Total = 0
					DebitMemo_Sub_Total = 0
					CreditMemo_Sub_Total = 0
                    %>
                    <tr>
                        <td colspan="9" height="2" bgcolor="#b5985e">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="#f7ecd6" class="bodycopy">
                        <td height="22">
                            <% 
			  		response.write "<b>" & aGlAccountType(i) & "<b>"
					
                            %>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <% end if %>
                    <%
			DebitAmount_Sub_Total = aDebitAmount(i) +  DebitAmount_Sub_Total
			CreditAmount_Sub_Total = aCreditAmount(i) +  CreditAmount_Sub_Total
			DebitMemo_Sub_Total = aDebitMemo(i) +  DebitMemo_Sub_Total
			CreditMemo_Sub_Total = aCreditMemo(i) +  CreditMemo_Sub_Total			
                    %>
                    <tr align="left" valign="middle" bgcolor="<%=tmpColor%>" class="bodycopy">
                        <td width="70" height="18">
                            <%= aGlAccountTypeSystem(i)%>
                        </td>
                        <td width="63">
                            <%= aGlAccount(i)%>
                        </td>
                        <td width="250">
                            <%= aGlAccountName(i)%>
                        </td>
                        <td width="54" align="right">
                            <%= aGlTranType(i)%>
                        </td>
                        <td width="151" align="right">
                            <%= FormatNumber(aDebitAmount(i),2,,0) %>
                        </td>
                        <td width="146" align="right">
                            <%= FormatNumber(aCreditAmount(i),2,,0) %>
                        </td>
                        <td width="150" align="right">
                            <%= FormatNumber(aGlAccountBalance(i),2,,0) %>
                        </td>
                        <td width="112" align="right">
                            <%= aRemark(i) %>
                        </td>
                        <td width="121" align="left">
                            <%= aClosedBy(i) %>
                        </td>
                    </tr>
                    <% 
				if aGlAccountType(i+1) <> tmpGlAccountType then 
                    %>
                    <tr>
                        <td height="1" colspan="9" bgcolor="#f7ecd6">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                        <td height="24" bgcolor="#F0F0F0">
                            &nbsp;
                        </td>
                        <td bgcolor="#F0F0F0">
                            &nbsp;
                        </td>
                        <td bgcolor="#F0F0F0" align="right">
                            <% 
			  		response.write "<b>" & "Sub Total" & "<b>"
					Balance_Sub_Total = ( DebitAmount_Sub_Total + DebitMemo_Sub_Total ) - ( CreditAmount_Sub_Total + CreditMemo_Sub_Total )
                            %>
                        </td>
                        <td width="54" align="right" bgcolor="#F0F0F0">
                            &nbsp;
                        </td>
                        <td width="151" align="right" bgcolor="#F0F0F0">
                            <%= FormatNumber(DebitAmount_Sub_Total,2,,0) %>
                        </td>
                        <td bgcolor="#F0F0F0" width="146" align="right">
                            <%= FormatNumber(CreditAmount_Sub_Total,2,,0) %>
                        </td>
                        <td width="150" align="right" bgcolor="#F0F0F0">
                            <%= FormatNumber(Balance_Sub_Total,2,,0) %>
                        </td>
                        <td width="112" align="right" bgcolor="#F0F0F0">
                            &nbsp;
                        </td>
                        <td bgcolor="#F0F0F0">
                            &nbsp;
                        </td>
                    </tr>
                    <% if selectedGlAccount = "0" and vglMasterType = "0" and vglAccountType = "0" then	%>
                    <%		  
				  if aGlAccountType(i) = CONST__MASTER_ASSET_NAME then
					  ASSET_Total = Balance_Sub_Total
				  elseif aGlAccountType(i) = CONST__MASTER_EQUITY_NAME then 	  
					  EQUITY_Total = Balance_Sub_Total
				  elseif aGlAccountType(i) = CONST__MASTER_LIABILITY_NAME then 	  
					  LIABILITY_Total = Balance_Sub_Total
				  end if		  			  
                    %>
                    <% end if %>
                    <% end if %>
                    <% next %>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="7" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <%
		  	Balance = ASSET_Total + EQUITY_Total + LIABILITY_Total
                    %>
                    <% if selectedGlAccount = "0" and vglMasterType = "0" and vglAccountType = "0" then	%>
                    <tr>
                        <td height="20" colspan="9" bgcolor="#ffffff" align="center">
                            &nbsp;<b>Total Balance =
                                <%= FormatNumber(ASSET_Total,2,,0) %>
                                +<%= FormatNumber(EQUITY_Total,2,,0) %>
                                +
                                <%= FormatNumber(LIABILITY_Total,2,,0) %>
                                =
                                <%= FormatNumber(Balance,2,,0) %>
                            </b>
                        </td>
                        <% end if %>
                </table>
                <% end if %>
            </td>
        </tr>
    </table>
    <br>
    </form>
    <% End if %>
</body>
<script type="text/javascript">
function Excel(){
	document.form1.action="fiscalClose.asp?Excel=Yes"+"&tNo=<%=TranNo%>&WindowName=" + window.name;
	document.form1.method="POST";
	document.form1.target="_self";
	form1.submit();
}


function changeOtherOptions1(obj){
  if ( obj.selectedIndex > 0 ) {
      document.form1.lstGlAccount.selectedIndex = 0;
      document.form1.lstGlAccountType.selectedIndex = 0;
  }
}

function changeOtherOptions2(obj){
    if (obj.selectedIndex > 0) {
        document.form1.lstGlAccount.selectedIndex = 0;
        document.form1.lstGlMasterType.selectedIndex = 0;
  }
}

function changeOtherOptions3(obj){
    if (obj.selectedIndex > 0) {
        document.form1.lstGlAccountType.selectedIndex = 0;
        document.form1.lstGlMasterType.selectedIndex = 0;
    }
}
function GoClick() {
    document.form1.action = "fiscalClose.asp?GO=yes" + "&WindowName=" + window.name;
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}

function SaveClick(TranNo){

    if ("<%=vFiscalYear%>" != document.form1.txtFiscalYear.value ){
	    var msg = "The target Fiscal Year was chahged into " + document.form1.txtFiscalYear.value + " from " + "<%=vFiscalYear%>" + ". \r\nPlease click Yes to continue.";
	    if (!confirm(msg))
		    return false;
    }
    else
    {
	    if ("<%=alreadyClosed%>" ){
		    var msg = "This fiscal Year (<%=vFiscalYear%>) has been closed already. \r\nPlease click Yes to continue.";
		    if (!confirm(msg))
		        return false;
	    }
    }
    document.form1.action = "fiscalClose.asp?Save=yes" + "&tNo=<%=TranNo%>&WindowName=" + window.name;
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}

function DeleteClick(TranNo){
	var msg = "Do you want to delete the closing data of fiscal year <%=vFiscalYear%>? \r\nPlease click Yes to delete.";
	if (!confirm(msg))
		return false;

    document.form1.action = "fiscalClose.asp?Delete=yes" + "&tNo=<%=TranNo%>&WindowName=" + window.name;
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}


function AdjustChange(ItemNo,chk,event){
    if (chk ==trye && event.Keycode != 13 )
        return false;

	var tmpDebitMemo = $("input.DebitMemo").get(ItemNo).value;
	var tmpCreditMemo = $("input.CreditMemo").get(ItemNo).value; 

	if (tmpDebitMemo.trim() == "" ) 
		tmpDebitMemo = 0;
	if (tmpCreditMemo.trim() == "" ) 
		tmpCreditMemo = 0;
    var num = (parseFloat($("input.DebitAmount").get(ItemNo).value) + parseFloat(tmpDebitMemo))  - ( parseFloat($("input.CreditAmount").get(ItemNo).value) + parseFloat(tmpCreditMemo)); 
	$("input.Balance").get(ItemNo).value= parseFloat(num).toFixed(2);
    $("input.DebitMemo").get(ItemNo).value = parseFloat(tmpDebitMemo).toFixed(2);
	$("input.CreditMemo").get(ItemNo).value = parseFloat(tmpCreditMemo).toFixed(2);

	
//    var tmpType,GlAccountType,DebitAmount_Sub_Total,DebitMemo_Sub_Total,CreditAmount_Sub_Total,
//    CreditMemo_Sub_Total,Balance_Sub_Total,
//    ASSET_Total,LIABILITY_Total,EQUITY_Total,NoItem,Balance;

    var NoItem=parseInt(document.form1.hNoItem.value);

    var ASSET_Total = 0;
    var LIABILITY_Total = 0;
    var EQUITY_Total = 0;

    var DebitAmount_Sub_Total = 0;
    var CreditAmount_Sub_Total = 0;
    var DebitMemo_Sub_Total = 0;
    var CreditMemo_Sub_Total = 0;
    var Balance_Sub_Total = 0;

	for (var i=0 ; i< NoItem; i++){
		var GlAccountType = $("input.Type").get(i).value;
		if (GlAccountType!= tmpType ) 
			tmpType = GlAccountType;

		DebitAmount_Sub_Total = parseFloat($("input.ebitAmount").get(i).value) +  DebitAmount_Sub_Total;
		DebitMemo_Sub_Total = parseFloat($("input.DebitMemo").get(i).value) + DebitMemo_Sub_Total;
		CreditAmount_Sub_Total = parseFloat($("input.CreditAmount").get(i).value) +  CreditAmount_Sub_Total;
		CreditMemo_Sub_Total = parseFloat($("input.CreditMemo").get(i).value) + CreditMemo_Sub_Total;
		Balance_Sub_Total = ( DebitAmount_Sub_Total + DebitMemo_Sub_Total ) - ( CreditAmount_Sub_Total + CreditMemo_Sub_Total );

		if($("input.Type").item(i+1).value != tmpType ){ 
			$("input.txtDebitAmount_Sub_Total_" + tmpType).value = parseFloat(DebitAmount_Sub_Total).toFixed(2);	//FormatNumber(DebitAmount_Sub_Total,2,,0)
			$("input.txtDebitMemo_Sub_Total_" + tmpType).value = parseFloat(DebitMemo_Sub_Total).toFixed(2);	//FormatNumber(DebitMemo_Sub_Total,2,,0)
			$("input.txtCreditAmount_Sub_Total_" + tmpType).value = parseFloat(CreditAmount_Sub_Total).toFixed(2);	//FormatNumber(CreditAmount_Sub_Total,2,,0)
			$("input.txtCreditMemo_Sub_Total_" + tmpType).value = parseFloat(CreditMemo_Sub_Total).toFixed(2);	//FormatNumber(CreditMemo_Sub_Total,2,,0)
			$("input.txtBalance_Sub_Total_"+ tmpType).value = parseFloat(Balance_Sub_Total).toFixed(2);	//FormatNumber(Balance_Sub_Total,2,,0)
			
			if (GlAccountType == "<%=CONST__MASTER_ASSET_NAME%>" )
				ASSET_Total = Balance_Sub_Total + ASSET_Total;
			else if (GlAccountType == "<%=CONST__MASTER_LIABILITY_NAME%>" )
				LIABILITY_Total = Balance_Sub_Total + LIABILITY_Total;
			else if( GlAccountType == "<%=CONST__MASTER_EQUITY_NAME%>" )
				EQUITY_Total = Balance_Sub_Total + EQUITY_Total;

			DebitAmount_Sub_Total = 0;
			DebitMemo_Sub_Total = 0;
			CreditAmount_Sub_Total = 0;
			CreditMemo_Sub_Total = 0;
			Balance_Sub_Total = 0;
		}
	}
	var Balance = parseFloat(ASSET_Total + EQUITY_Total + LIABILITY_Total).toFixed(2);	// FormatNumber(cDbl(),2,,0)
	if (Balance.toString() == "0.00")
	    Balance = parseInt(0);
	document.form1.txtASSET_Total.value = parseFloat(ASSET_Total).toFixed(2); //FormatNumber(ASSET_Total,2,,0)
	document.form1.txtLIABILITY_Total.value = parseFloat(LIABILITY_Total).toFixed(2); //FormatNumber(LIABILITY_Total,2,,0)
	document.form1.txtEQUITY_Total.value = parseFloat(EQUITY_Total).toFixed(2); //FormatNumber(EQUITY_Total,2,,0)		
	document.form1.txtBalance.value = parseFloat(Balance).toFixed(2); //FormatNumber(Balance,2,,0)		
}

function ChangePeriod(){
   // var vFiscalTo,vFiscalFrom,vFiscalYear,vCalcYear,vfiscalEndMonth,tmpMonth;
    var vFiscalYear = document.form1.txtFiscalYear.value;
    var vfiscalEndMonth = parseInt("<%=vfiscalEndMonth%>");
    if (vFiscalYear.length != 4 )
	    return false;
    
    var d = new Date();
    var tmpMonth = d.getMonth(); 
    var vCalcYear=0;
    if ( parseInt(tmpMonth) == parseInt(vfiscalEndMonth) ) {
	    if 	(parseInt(vfiscalEndMonth) == 12 )
	      vCalcYear = parseInt(vFiscalYear);
	    else
	      vCalcYear = parseInt(vFiscalYear) + 1;
    }
    else
    {
        if (parseInt(vfiscalEndMonth) == 12)
            vCalcYear = parseInt(vFiscalYear);
        else
            vCalcYear = parseInt(vFiscalYear) + 1;
    }

    var vFiscalTo = new Date("<%=vfiscalEndMonth%>" + "/" + "01" + "/" + vCalcYear.toString());
    //var vFiscalTo = new Date(str_vFiscalTo);
    vFiscalTo.setMonth(vFiscalTo.getMonth() + 1);//  DateAdd("m", 1, vFiscalTo)//CurrentDate.setMonth(CurrentDate.getMonth()+X);
    vFiscalTo.setDate(vFiscalTo.getDate() - 1);// DateAdd("d", -1, vFiscalTo)
    var vFiscalFrom = new Date(vFiscalTo);
    vFiscalFrom.setMonth(vFiscalTo.getMonth() - 11); // DateAdd("m", -11, vFiscalTo)
    if ((vFiscalFrom.getMonth()+1) < 10)
        vFiscalFrom = "0" + (vFiscalFrom.getMonth() + 1).toString() + "/01/" + vFiscalFrom.getFullYear().toString();
    else
        vFiscalFrom = (vFiscalFrom.getMonth() + 1).toString() + "/01/" + vFiscalFrom.getFullYear().toString();

    document.form1.txtFiscalFrom.value = vFiscalFrom;
    var vFiscalToMonth = vFiscalTo.getMonth()+1;
    if (vFiscalToMonth < 10) {
        vFiscalToMonth = "0" + vFiscalTo.getMonth().ToString();
    }
    var vFiscalToDay = vFiscalTo.getDate();
    if (vFiscalToDay < 10) {
        vFiscalToDay = "0" + vFiscalTo.getDate().ToString();
    } 
    document.form1.txtFiscalTo.value
        = vFiscalToMonth + "/"
        + vFiscalTo.getDate() + "/"
        + vFiscalTo.getFullYear();
    //vFiscalTo.to("mm/dd/yyyy");
}
</script>
<script language="vbscript">
<!---

--->

</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
<%
if Excel = "Yes" then
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition","attachment;filename=Account_Summary.xls"
end if
%>
