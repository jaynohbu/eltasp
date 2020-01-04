<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>Income Statement</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aRevenue(128),aRevenueName(128),aExpense(128),aExpenseName(128)
Dim aGLDesc(1000000),aCostGoods(128),aCostGoodsName(128)
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
Set rs = Server.CreateObject("ADODB.Recordset")
FromDate=Request("txtFromDate")
if FromDAte="" then FromDate=Month(Date) & "/1/" & Year(Date)
vYear1=Year(FromDate)
vMonth1=Month(FromDate)
vDay1=Day(FromDate)
ToDate=Request("txtToDate")
if ToDate="" then ToDate=Date
ToDate=CDate(ToDate)
vYear2=Year(ToDate)
vMonth2=Month(ToDate)
vDay2=Day(ToDate)
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
' get org name
if Not Branch=0 then
	SQL= "select dba_name from agent where elt_account_number = " & Branch
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vOrgName=rs("dba_name")
	end if
	rs.close
end if
'get all Revenue and Expense Accounts from gl
SQL= "select gl_account_number,gl_account_type from gl where elt_account_number = " & elt_account_number & " and gl_account_type='"&CONST__REVENUE&"' or gl_account_type='"&CONST__COST_OF_SALES&"' or gl_account_type='"&CONST__EXPENSE&"' order by gl_account_number"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vAcct=""
Do While Not rs.EOF
	aGLDesc(rs("gl_account_number"))=rs("gl_account_type")
	if Not vAcct="" then vAcct=vAcct & ","
	vAcct=vAcct & rs("gl_account_number")
	rs.MoveNext
Loop
if vAcct="" then vAcct=0
rs.close

if Not Branch=0 then
	SQL= "select gl_account_number,gl_account_name,sum(debit_amount+credit_amount) as amount from all_accounts_journal where elt_account_number = " & Branch & " and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and gl_account_number in (" & vAcct & ") and tran_type is not null group by gl_account_number,gl_account_name"
else
	SQL= "select gl_account_number,gl_account_name,sum(debit_amount+credit_amount) as amount from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and gl_account_number in (" & vAcct & ") and tran_type is not null group by gl_account_number,gl_account_name"
end if
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
rIndex=0
rSubTotal=0
eIndex=0
eSubTotal=0
cIndex=0
cSubTotal=0
Do While Not rs.EOF
	glType=aGLDesc(rs("gl_account_number"))
	if glType="Revenue" then
		Amount=-cDbl(rs("amount"))
		aRevenue(rIndex)=Amount
		rSubTotal=rSubTotal+Amount
		aRevenueName(rIndex)=rs("gl_account_name")
		rIndex=rIndex+1
	elseif glType="Cost of Goods Sold" then
		Amount=cDbl(rs("Amount"))
		aCostGoods(cIndex)=Amount
		cSubTotal=cSubTotal+Amount
		aCostGoodsName(cIndex)=rs("gl_account_name")
		cIndex=cIndex+1
	elseif glType="Expense" then
		Amount=cDbl(rs("Amount"))
		aExpense(eIndex)=Amount
		eSubTotal=eSubTotal+Amount
		aExpenseName(eIndex)=rs("gl_account_name")
		eIndex=eIndex+1
	end if
	rs.MoveNext
Loop
rs.Close
GrossProfit=rSubTotal-cSubTotal

'get all Expense Accounts from gl
'SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_master_type='EXPENSE' order by gl_account_number"
'rs.Open SQL, eltConn, adOpenStatic, , adCmdText
'vExpenseAcct=""
'Do While Not rs.EOF
'	if Not vExpenseAcct="" then vExpenseAcct=vExpenseAcct & ","
'	vExpenseAcct=vExpenseAcct & rs("gl_account_number")
'	rs.MoveNext
'Loop
'rs.close
'if vExpenseAcct="" then vExpenseAcct=0
'SQL= "select gl_account_name,sum(debit_amount) as debit,sum(credit_amount) as credit from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_date between '" & FromDate & "' and '" & ToDate+1 & "' and gl_account_number in (" & vExpenseAcct & ") group by gl_account_name"
'rs.Open SQL, eltConn, adOpenStatic, , adCmdText
'eIndex=0
'eSubTotal=0
'Do While Not rs.EOF
'	Debit=cDbl(rs("debit"))
'	aExpense(eIndex)=Debit
'	eSubTotal=eSubTotal+Debit
'	aExpenseName(eIndex)=rs("gl_account_name")
'	eIndex=eIndex+1
'	rs.MoveNext
'Loop
'rs.Close
Set rs=Nothing
NetIncome=FormatCurrency(GrossProfit-eSubTotal)
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">income statement</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
<!--  #INCLUDE FILE="../include/calendar.htm" --> 
 <tr> 
    <td height="1" align="right" valign="middle" class="pageheader"> </td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#89A979">
  <tr> 
    <td> 


        <table width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr bgcolor="D5E8CB"> 
            <td height="8" align="left" valign="top" class="bodycopy"></td>
          </tr>
          <tr bgcolor="D5E8CB"> 
            <td height="20" colspan="9" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader"><br>

			<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
			<td align="right"><img src="../images/button_print_medium.gif" name="bPrint" width="52" height="18" onClick="PrintReport()" ></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">INCOME 
                    STATEMENT </td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"> 
                    <%= FromDate %> &nbsp;-&nbsp; <%= ToDate %> 
                  </td>
                </tr>
                <% 'if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% 'end if %>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="35%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="70%" height="20" bgcolor="D5E8CB"><strong>ORDINARY 
                    INCOME/EXPENSE </strong></td>
                  <td width="30%">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong>Income</strong></td>
                  <td>&nbsp;</td>
                </tr>
                <% for i=0 to rIndex-1 %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td><%= aRevenueName(i) %></td>
                  <td align="right"><%= FormatCurrency(aRevenue(i)) %></td>
                </tr>
                <% next %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Income</strong></td>
                  <td align="right"><strong><%= FormatCurrency(rSubTotal) %></strong></td>
                </tr>
				<tr>
				  <td height="1" colspan="2" bgcolor="#89A979"></td>
				</tr>
                <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong><%=CONST__COST_OF_SALES%></strong></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <% for i=0 to cIndex-1 %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td><%= aCostGoodsName(i) %></td>
                  <td align="right"><%= FormatCurrency(aCostGoods(i)) %></td>
                </tr>
                <% next %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Cost of Goods Sold</strong></td>
                  <td align="right"><strong><%= FormatCurrency(cSubTotal) %></strong></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20" bgcolor="D5E8CB"><strong>GROSS PROFIT</strong></td>
                  <td height="20" align="right"><strong><%= FormatCurrency(GrossProfit) %></strong></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong>Expense</strong></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <% for i=0 to eIndex-1 %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td><%= aExpenseName(i) %></td>
                  <td align="right"><%= FormatCurrency(aExpense(i)) %></td>
                </tr>
                <% next %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Expense</strong></td>
                  <td align="right"><strong><%= FormatCurrency(eSubTotal) %></strong></td>
                </tr>
                <tr>
				  <td height="1" colspan="2" bgcolor="#89A979"></td>
				</tr> 
				<tr>
				  <td height="1" colspan="2" bgcolor="#89A979"></td>
				</tr>                 
				<tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20" bgcolor="D5E8CB"><strong>NET ORDINARY INCOME</strong></td>
                  <td align="right"><strong><%= NetIncome %></strong></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20" bgcolor="D5E8CB"><strong>NET INCOME</strong></td>
                  <td align="right"><strong><%= NetIncome %></strong></td>
                </tr>
              </table>
              <br>
              <br>
</td>
          </tr>

		  <tr>
		    <td height="22" bgcolor="D5E8CB"></td>
		  </tr>
        </table>
           </td>
  </tr>
</table>
</form>
<br>

</body>
<script language="vbscript">
<!---
Sub BranchChange()
	document.form1.action="income_state.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="income_state.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="income_statePrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

--->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
