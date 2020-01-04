<%@LANGUAGE="VBSCRIPT"%>

<html>
<head>
<title>Check Register</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PrintFormat.htm" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/getDates.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Dim GlBalance(100000),GLAcct(256)
Set rs = Server.CreateObject("ADODB.Recordset")
vBank=Request("lstBank")
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
'get gl info
SQL= "select * from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Bank'"
rs.Open SQL, eltConn, , , adCmdText
Dim aBank(64)
Dim aBankDesc(64)
bIndex=0
Do While Not rs.EOF
	aBank(bIndex)=rs("gl_account_number")
	aBankDesc(bIndex)=rs("gl_account_desc")
	bIndex=bIndex+1
	rs.MoveNext
Loop
rs.Close
' get org name
	SQL= "select dba_name from agent where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vOrgName=rs("dba_name")
	end if
	rs.close
'get balance for each the selected bank acct right before FromDate
if Not vBank="" then
	SQL= "select sum(credit_amount+debit_amount) as balance from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and tran_date <" & DM & FromDate & DM & " and gl_account_number=" & vBank
'response.write SQL	
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vStartBal=cDbl(rs("balance"))
	end if
	rs.Close
end if
'get all transactions for the selected bank acct
if vBank="" then vBank=aBank(0)
if Not vBank="" then
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & ") and gl_account_number=" & vBank & " order by tran_date,tran_seq_num"
'response.write SQL	
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	tIndex=1
'glIndex=0
	Count=rs.RecordCount+1000
	ReDim aField1(Count)
	ReDim aField0(Count)
	ReDim aField2(Count)
	ReDim aField3(Count)
	ReDim aField4(Count)
	ReDim aField5(Count)
	ReDim aField6(Count)
	ReDim aField7(Count)
	ReDim aLink(Count)
	aField6(0)=vStartBal
	Do While Not rs.EOF And tIndex<Count
		aField1(tIndex)=FormatDateTime(rs("tran_date"),2)
		aField0(tIndex)=rs("check_no")
		aField2(tIndex)=rs("customer_name")
		aField3(tIndex)=rs("tran_type")
		vAMT=cDbl(rs("credit_amount"))
		if vAMT>0 then
			aField5(tIndex)=vAMT
		else
			aField4(tIndex)=-vAMT
		end if
		aField6(tIndex)=aField6(tIndex-1)+vAMT
		aField7(tIndex)=rs("tran_num")
		if aField3(tIndex)="PMT" then
			aLink(tIndex)="../acct_tasks/receiv_pay.asp?PaymentNo=" & aField7(tIndex)
		elseif aField3(tIndex)="INV" then
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField7(tIndex)
		elseif aField3(tIndex)="ARN" then
			aLink(tIndex)="../air_import/arrival_notice.asp?iType=" & iType & "&edit=yes&InvoiceNo=" & aField7(tIndex)
		elseif aField3(tIndex)="BILL" then
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField7(tIndex)
		elseif aField3(tIndex)="CHK" then
			aLink(tIndex)="../acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" & aField7(tIndex)
		elseif aField3(tIndex)="BP-CHK" then
			aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField7(tIndex)
		elseif aField3(tIndex)="GJE" then
			aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField7(tIndex)
		end if
		tIndex=tIndex+1
		rs.MoveNext
	Loop
	rs.Close
end if


Set rs=Nothing

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">Check REGISTER</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
<!--  #INCLUDE FILE="../include/calendar1.htm" -->
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
                  <td height="29" align="center" valign="middle" class="bodyheader">CHECK 
                    REGISTER </td>
          </tr>
          <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong><%= FromDate %></strong> through <strong><%= ToDate %></strong></td>
          </tr>
                <% if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% end if %>
          <tr> 
                  <td align="center" valign="middle"><strong>Bank Account No &nbsp;</strong> 
                    <select name="lstBank" size="1" class="smallselect" style="WIDTH: 200px;">
                      <% for i=0 to bIndex-1 %>
                      <option value="<%= aBank(i) %>" <% if cLng(vBank)=cLng(aBank(i)) then response.write("selected") %>><%= aBankDesc(i) %></option>
                      <% next %>
                    </select>
                  </td>
            </tr>
            <tr>
                  <td height="27" align="center" valign="bottom"><img src="../images/button_go.gif" width="31" height="18" onClick="GoClick()"></td>
            </tr>
			<tr>
                  <td height="24">&nbsp;</td>
            </tr>
              </table>

              <table width="70%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="13%" height="20"><strong>Posting Date</strong></td>
                  <td width="10%"><strong>Check No</strong></td>
                  <td width="18%"><strong>Description</strong></td>
                  <td width="14%"><strong>Transaction Type</strong></td>
                  <td width="15%"><strong>Debit(-)</strong></td>
                  <td width="15%"><strong>Credit(+)</strong></td>
                  <td width="15%"><strong>Balance</strong></td>
                </tr>
<% for i=1 to tIndex-1 %>                
				<tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td height="20"><%= aField1(i) %></td>
                  <td><%= aField0(i) %></td>
                  <td><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><span style="{text-decoration:none}"><%= aField2(i) %></span></a></td>
                  <td><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="right" bgcolor="f3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"> 
                    <% if Not aField4(i)="" then response.write(FormatNumber(aField4(i),2)) %>
                    </a></td>
                  <td align="right" bgcolor="f3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"> 
                    <% if Not aField5(i)="" then response.write(FormatNumber(aField5(i),2)) %>
                    </a></td>
                  <td align="right" valign="middle" bgcolor="f3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= formatNumber(aField6(i),2) %></a></td>
                </tr>
<% next %>
              </table>

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
Sub GoClick()
	FromDate=document.form1.txtFromDate.Value
	if Not IsDate(FromDate) then
		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
		exit Sub
	end if
	ToDate=document.form1.txtToDate.Value
	if Not IsDate(ToDate) then
		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
		exit Sub
	end if
	document.form1.action="check_register.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub key()
if Window.event.Keycode=13 then
	FromDate=document.form1.txtFromDate.Value
	if Not IsDate(FromDate) then
		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
		exit Sub
	end if
	ToDate=document.form1.txtToDate.Value
	if Not IsDate(ToDate) then
		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
		exit Sub
	end if
	document.form1.action="check_register.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="check_registerPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
