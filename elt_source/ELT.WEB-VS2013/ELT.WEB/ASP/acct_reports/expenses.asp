<%@LANGUAGE="VBSCRIPT"%>
<% Response.Buffer=True %>

<html>
<head>
<title>Expenses</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
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
'get all Expense Accts from gl
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Expense'"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vExpenseAcct=""
Do While Not rs.EOF
	if Not vExpenseAcct="" then vExpenseAcct=vExpenseAcct & ","
	vExpenseAcct=vExpenseAcct & rs("gl_account_number")
	'aARDesc(rs("gl_account_number"))=rs("gl_account_desc")
	rs.MoveNext
Loop
rs.close
if vExpenseAcct="" then vExpenseAcct=0
if Not Branch=0 then
	SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vExpenseAcct & ") and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and (tran_type='BILL' or tran_type='CHK') order by customer_name,tran_seq_num"
else
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vExpenseAcct & ") and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and (tran_type='BILL' or tran_type='CHK') order by elt_account_number,customer_name,tran_seq_num"
end if
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
tIndex=0
'rs.MoveLast
Count=rs.RecordCount+1000
ReDim aField1(Count)
ReDim aField2(Count)
ReDim aField3(Count)
ReDim aField4(Count)
ReDim aField5(Count)
ReDim aField6(Count)
ReDim aField7(Count)
ReDim aField8(Count)
ReDim aField9(Count)
ReDim aLink(Count)
vTotal=0
vSubTotal=0
vSubBalance=0
vTotalBalance=0
LastCustomer=""
LastBranch=0
Do While Not rs.EOF ANd tIndex<Count
	CurrBranch=cLng(rs("elt_account_number"))
	if Branch=0 And tIndex=0 then
		aField1(tIndex)=CurrBranch
		tIndex=tIndex+1
		LastBranch=CurrBranch
	end if
	cName=rs("customer_name")
	if (Not LastCustomer=rs("customer_name")) or (Branch=0 And Not CurrBranch=LastBranch) then
		if (Not tIndex=0 and Not Branch=0) Or (Not tIndex=1 And Branch=0) then
			aField7(tIndex)="Sub Total"
			aField8(tIndex)=FormatCurrency(vSubTotal)
			aField9(tIndex)=aField9(tIndex-1)
			vTotalBalance=vTotalBalance+cDbl(vSubBalance)
			tIndex=tIndex+1
		end if
		if Branch=0 And Not CurrBranch=LastBranch then
			aField1(tIndex)=CurrBranch
			tIndex=tIndex+1
			LastBranch=CurrBranch
		end if
		aField1(tIndex)=cName
		LastCustomer=cName
		vSubTotal=0
		tIndex=tIndex+1
	end if
	aField2(tIndex)=rs("tran_type")
	aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
	aField4(tIndex)=rs("tran_num")
	aField5(tIndex)=rs("memo")
	aField6(tIndex)=rs("gl_account_name")
	aField7(tIndex)=rs("split")
	Debit=cDbl(rs("debit_amount"))
	aField8(tIndex)=Debit
	aField9(tIndex)=Debit+aField9(tIndex-1)
	vSubTotal=vSubTotal+cDbl(aField8(tIndex))
	vTotal=vTotal+cDbl(aField8(tIndex))
	vSubBalance=aField9(tIndex)
	aField8(tIndex)=FormatCurrency(aField8(tIndex))
	aField9(tIndex)=FormatCurrency(aField9(tIndex))
	if aField2(tIndex)="BILL" then
		if Not CurrBranch=cLng(elt_account_number) then
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField4(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
		else
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField4(tIndex)
		end if
	else
		if Not CurrBranch=cLng(elt_account_number) then
			aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
		else
			aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex)
		end if
	end if
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close
aField7(tIndex)="Sub Total"
aField8(tIndex)=FormatCurrency(vSubTotal)
if tIndex>0 then
	aField9(tIndex)=aField9(tIndex-1)
else
	aField9(tIndex)="$0.00"
end if
vTotalBalance=vTotalBalance+cDbl(vSubBalance)
Set rs=Nothing

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
      <td height="20" align="left" valign="bottom" class="pageheader">Expenses</td>
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

			<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
			<td align="right"><img src="../images/button_print_medium.gif" name="bPrint" width="52" height="18" onClick="PrintReport()" ></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">EXPENSES 
                    REPORT </td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"> 
                    <strong><%= FromDate %></strong>&nbsp; through &nbsp;<strong><%= ToDate %></strong> 
                  </td>
                </tr>
                <% 'if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% 'end if %>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="90%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle"> 
                  <td width="24%" height="20" bgcolor="D5E8CB"><strong>Company Name </strong></td>
                  <td width="7%" bgcolor="D5E8CB"><strong>Type</strong></td>
                  <td width="9%" bgcolor="D5E8CB"><strong>Date</strong></td>
                  <td width="5%" bgcolor="D5E8CB"><strong>Num</strong></td>
                  <td width="18%" bgcolor="D5E8CB"><strong>Memo</strong></td>
                  <td width="9%" bgcolor="D5E8CB"><strong>Account</strong></td>
                  <td width="10%" bgcolor="D5E8CB"><strong>Split</strong></td>
                  <td width="9%" bgcolor="D5E8CB"><strong>Amount</strong></td>
                  <td width="9%" bgcolor="D5E8CB"><strong>Balance</strong></td>
                </tr>
<% for i=0 to tIndex %>
                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy"> 
                  <td><b><%= aField1(i) %></b></td>
<% if not aField4(i)="" then %>                  
				  <td><a href="<%= aLink(i) %>"><%= aField2(i) %></a></td>
                  <td><a href="<%= aLink(i) %>"><%= aField3(i) %></a></td>
                  <td><a href="<%= aLink(i) %>"><%= aField4(i) %></a></td>
                  <td><a href="<%= aLink(i) %>"><%= aField5(i) %></a></td>
                  <td><a href="<%= aLink(i) %>"><%= aField6(i) %></a></td>
                  <td align="<%  if aField7(i)="Sub Total" then response.write("right") else response.write("left") %>">
                    <%  if aField7(i)="Sub Total" then response.write("<b>") %>
                    <a href="<%= aLink(i) %>"><%= aField7(i) %><a>
                    <%  if aField7(i)="Sub Total" then response.write("</b>") %>
                    </a></a></td>
                  <td align="right"> 
                    <% if aField7(i)="Sub Total" then %>
                    <hr width="80%" size="1" color="#000000"> 
                    <% end if %>
                    <a href="<%= aLink(i) %>"><%= aField8(i) %></a></td>
                  <td align="right"> 
                    <% if aField7(i)="Sub Total" then %>
                    <hr size="1" width="80%" color="#000000"> 
                    <% end if %>
                    <a href="<%= aLink(i) %>"><%= aField9(i) %></a></td>
                </tr>
<% else %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td><%= aField2(i) %></td>
                  <td><%= aField3(i) %></td>
                  <td><%= aField4(i) %></td>
                  <td><%= aField5(i) %></td>
                  <td><%= aField6(i) %></td>
                  <td>
                   
                  </td>
                  <td align="<%  if aField7(i)="Sub Total" then response.write("right") else response.write("left") %>"> 
                    <%  if aField7(i)="Sub Total" then response.write("<b>") %>
                    <%= aField7(i) %>
                    <%  if aField7(i)="Sub Total" then response.write("</b>") %>
                  </td>
                  <td align="right"><strong>
                    <% if aField7(i)="Sub Total" then %>
                     
                    <% end if %>
                    <%= aField8(i) %></strong></td>
                  <td align="right"><strong> 
                    <% if aField7(i)="Sub Total" then %>
                    
                    <% end if %>
                    <%= aField9(i) %></strong></td>
                </tr>
<% end if %>
<% next %>
                <tr bgcolor="f3f3f3"> 
                  <td height="20" colspan="10" align="left" valign="middle"></td>
				</tr>
				<tr>
			   <tr>
				  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
				</tr>
				<tr>
				  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
				</tr> 
				<tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20" colspan="7" align="right"><strong>TOTAL</strong></td>
                  <td align="right"><strong><%= FormatCurrency(vTotal) %></strong></td>
                  <td align="right"><strong><%= FormatCurrency(vTotalBalance) %></strong></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#FFFFFF"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
<script language="VBScript">
<!--

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="expensesPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

Sub key()
if Window.event.Keycode=13 then
	document.form1.action="expenses.asp" & "?WindowName=" & window.name
	document.form1.target="_self"

	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="expenses.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"

	form1.submit()
end Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
