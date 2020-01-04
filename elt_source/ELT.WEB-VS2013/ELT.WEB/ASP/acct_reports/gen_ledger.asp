<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>General Ledger</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Dim GlBalance(100000),GLAcct(256)
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
'get balance for each gl account right before FromDate
'SQL="SELECT gl_account_number,balance FROM all_accounts_journal WHERE elt_account_number=" & elt_account_number
'SQL=SQL & " and tran_seq_num In (SELECT  Max(tran_seq_num) FROM all_accounts_journal WHERE elt_account_number=" & elt_account_number & " and tran_date<" & DM & "10/1/2001" & DM & " group by gl_account_number)"
'SQl=SQL & " ORDER BY gl_account_number"
if Not Branch=0 then
	SQL= "select gl_account_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where elt_account_number = " & Branch & " and tran_date <" & DM & FromDate & DM & " Group by gl_account_number order by gl_account_number"
else
	SQL= "select gl_account_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and tran_date <" & DM & FromDate & DM & " Group by gl_account_number order by gl_account_number"
end if
'response.write SQL
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
gIndex=0
Do While Not rs.EOF And gIndex<256
	if Not IsNull(rs("gl_account_number")) And Not rs("gl_account_number")="0" then
		GlBalance(rs("gl_account_number"))=cDbl(rs("balance"))
		GlAcct(gIndex)=rs("gl_account_number")
		gIndex=gIndex+1
	end if
	rs.MoveNext
Loop
rs.Close
FromGL=Request("lstFromGL")
if FromGL="" or FromGL="ALL" then FromGL=0
ToGL=Request("lstToGL")
if ToGL="" or ToGL="ALL" then ToGL=0
'get all transactions from all_accounts_journal
if FromGL=0 or ToGL=0 then
	if Not Branch=0 then
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type is null) order by gl_account_number,tran_date,tran_seq_num"
	else
		SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type is null) order by gl_account_number,elt_account_number,tran_date,tran_seq_num"
	end if
else
	if Not Branch=0 then
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type is null) and gl_account_number between " & FromGL & " and " & ToGL & " order by gl_account_number,tran_date,tran_seq_num"
	else
		SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type is null) and gl_account_number between " & FromGL & " and " & ToGL & " order by gl_account_number,elt_account_number,tran_date,tran_seq_num"
	end if
end if
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
tIndex=0
'glIndex=0
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
vSubTotal=0
vSubBalance=0
LastGLName=""
LastGLAccount=0
LastBranch=0
Do While Not rs.EOF And tIndex<Count
	CurrBranch=cLng(rs("elt_account_number"))
	cGlName=rs("gl_account_name")
	If Not IsNull(rs("gl_account_number")) then
		cGlAccount=cLng(rs("gl_account_number"))
	else
		cGlAccount=0
	end if
	if Not LastGlAccount=cGlAccount then
		if Not tIndex=0 then
			aField7(tIndex)="Total " & LastGlName
			aField8(tIndex)=FormatNumber(vSubTotal,2)
			'aField9(tIndex)=FormatCurrency(aField9(tIndex-1))
			aField9(tIndex)=FormatNumber(vSubBal,2)
			tIndex=tIndex+2
		end if
		aField1(tIndex)=cGLName
		LastGlAccount=cGlAccount
		vSubTotal=0
		vSubBal=cDbl(GlBalance(cGlAccount))
		'glIndex=glIndex+1
		aField9(tIndex)=FormatNumber(vSubBal,2)
		tIndex=tIndex+1
	end if
	if Branch=0 And Not CurrBranch=LastBranch then
		aField1(tIndex)=CurrBranch
		aField9(tIndex)=""
		tIndex=tIndex+1
		LastBranch=CurrBranch
	end if
	tranType=rs("tran_type")
	iType=rs("air_ocean")
	if Not tranType="" And Not tranType="INIT" then
		aField2(tIndex)=rs("tran_type")
		aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
		aField4(tIndex)=rs("tran_num")
		aField5(tIndex)=rs("customer_name")
		aField6(tIndex)=Mid(rs("memo"),1,8)
		aField7(tIndex)=rs("split")
		Debit=rs("debit_amount")
		Credit=rs("credit_amount")
		if cDbl(Debit)=0 then
			aField8(tIndex)=Credit
		else
			aField8(tIndex)=Debit
		end if
		'aField9(tIndex)=cDbl(rs("gl_balance"))+GlBalance(cGlAccount)
		vSubTotal=vSubTotal+cDbl(aField8(tIndex))
		vSubBal=vSubBal+cDbl(aField8(tIndex))
		aField9(tIndex)=vSubBal
		'vTotal=vTotal+cDbl(aField6(tIndex))
		'vSubBalance=aField9(tIndex)
		aField8(tIndex)=FormatNumber(aField8(tIndex),2)
		aField9(tIndex)=FormatNumber(aField9(tIndex),2)
		if aField2(tIndex)="PMT" then
			aLink(tIndex)="../acct_tasks/receiv_pay.asp?PaymentNo=" & aField4(tIndex)
		elseif aField2(tIndex)="INV" then
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
		elseif aField2(tIndex)="ARN" then
			aLink(tIndex)="../air_import/arrival_notice.asp?iType=" & iType & "&edit=yes&InvoiceNo=" & aField4(tIndex)
		elseif aField2(tIndex)="BILL" then
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField4(tIndex)
		elseif aField2(tIndex)="CHK" then
			aLink(tIndex)="../acct_tasks/write_chk.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex)
		elseif aField2(tIndex)="BP-CHK" then
			aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex)
		elseif aField2(tIndex)="GJE" then
			aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField4(tIndex)
		end if
		tIndex=tIndex+1
	else
		aField9(tIndex)=vSubBal
	end if
	rs.MoveNext
Loop
rs.Close
aField7(tIndex)="Total " & LastGlName
aField8(tIndex)=FormatNumber(vSubTotal,2)
if tIndex>0 then
	aField9(tIndex)=FormatNumber(vSubBal,2)
end if


Set rs=Nothing

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">General Ledger</td>
  </tr>
</table>

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
<!--  #INCLUDE FILE="../include/calendar.htm" -->
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
                  <td height="29" align="center" valign="middle" class="bodyheader">GENERAL 
                    LEDGER </td>
          </tr>
          <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong><%= FromDate %></strong> through <strong><%= ToDate %></strong></td>
          </tr>
                <% if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% end if %>
          <tr> 
                  <td height="27" align="center" valign="middle"><strong>From&nbsp;</strong> 
                    <select name="lstFromGL" size="1" class="smallselect" style="WIDTH: 100px">
                      <option >ALL</option>
                      <% for i=0 to gIndex-1 %>
                      <option <% if cLng(GLAcct(i))=cLng(FromGL) then response.write("selected") %>><%= GlAcct(i) %></option>
                      <% next %>
                    </select> <strong>&nbsp;&nbsp; To&nbsp; </strong> <select name="lstToGL" size="1" class="smallselect" style="WIDTH: 100px">
                      <option >ALL</option>
                      <% for i=0 to gIndex-1 %>
                      <option <% if cLng(GLAcct(i))=cLng(ToGL) then response.write("selected") %>><%= GlAcct(i) %></option>
                      <% next %>
                    </select></td>
            </tr>
            <tr>
                  <td height="24">&nbsp;</td>
            </tr>
              </table>

              <table width="90%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="13%" height="20"><strong>Account Name</strong></td>
                  <td width="5%" height="20"><strong>Type</strong></td>
                  <td width="7%" height="20"><strong>Date</strong></td>
                  <td width="7%" height="20"><strong>Num</strong></td>
                  <td width="24%" height="20" bgcolor="D5E8CB"><strong>Company 
                    Name</strong></td>
                  <td width="10%" height="20"><strong>Memo</strong></td>
                  <td width="14%" height="20"><strong>Split</strong></td>
                  <td width="10%" height="20"><strong>Amount</strong></td>
                  <td width="10%" height="20"><strong>Balance</strong></td>
                </tr>
<% for i=0 to tIndex %>                
				<tr bgcolor="#f3f3f3"> 
                  <% if not aField4(i)="" then %> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><span style="{text-decoration:none}"><%= aField2(i) %></span></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="<%  if Mid(aField7(i),1,5)="TOTAL" then response.write("right") else response.write("left") %>" valign="middle"> 
                    <%  if Mid(aField7(i),1,5)="TOTAL" then response.write("<b>") %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));">
                    <%  if Not Mid(aField7(i),1,5)="TOTAL" then response.write("<font size=1>") %>
                    <%= aField7(i) %>
                    <%  if Not Mid(aField7(i),1,5)="TOTAL" then response.write("</font>") %>
                    <a>
                    <%  if Mid(aField7(i),1,5)="TOTAL" then response.write("</b>") %>
                    </a></a></td>
                  <td align="right" valign="middle"> 
                    <% if Mid(aField7(i),1,5)="TOTAL" then %>
                    <hr width="80%" size="1" color="#000000"> 
                    <% end if %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                  <td align="right" valign="middle"> 
                    <% if Mid(aField7(i),1,5)="TOTAL" then %>
                    <hr size="1" width="80%" color="#000000"> 
                    <% end if %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField9(i) %></a></td>
                </tr>
<% else %>
                <tr bgcolor="f3f3f3"> 
                  <td height="20" align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><%= aField1(i) %></td>
                  <td align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><%= aField2(i) %></td>
                  <td align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><%= aField3(i) %></td>
                  <td align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><%= aField4(i) %></td>
                  <td align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="<%  if Mid(aField7(i),1,5)="Total" then response.write("right") else response.write("left") %>" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>> 
                    <%  if Mid(aField7(i),1,5)="TOTAL" then response.write("bodyheader") %>
                    <%= aField7(i) %>
                    <%  if Mid(aField7(i),1,5)="TOTAL" then response.write("bodyheader") %>
                  </td>
                  <td align="right" valign="middle" class=<%  if aField1(i)="" then response.write("bodyheader") else response.write("bodyheader") %>> 
                    <% if Mid(aField7(i),1,5)="TOTAL" then %>
                    <hr width="80%" size="1" color="#000000"> 
                    <% end if %>
                    <%= aField8(i) %></td>
                  <td align="right" valign="middle" class=<%  if aField1(i)="" then response.write("data") else response.write("foot") %>> 
                    <% if Mid(aField7(i),1,5)="TOTAL" then %>
                    <hr size="1" width="80%" color="#000000"> 
                    <% end if %>
                    <strong><%= aField9(i) %></strong></td>
                </tr>
<% end if %>


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
Sub BranchChange()
	document.form1.action="gen_ledger.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="gen_ledger.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="gen_ledgerPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
