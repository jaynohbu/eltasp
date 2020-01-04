<%@LANGUAGE="VBSCRIPT"%>
<% Response.Buffer=True %>

<html>
<head>
<title>AR Detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/getDates.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Dim cusBalance(320000),vCompany
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
vCompany=Request("lstCompany")
if vCompany="" then vCompany=0
Set rs = Server.CreateObject("ADODB.Recordset")
'FromDate=Request("txtFromDate")
'if FromDAte="" then FromDate=Month(Date) & "/1/" & Year(Date)
'vYear1=Year(FromDate)
'vMonth1=Month(FromDate)
'vDay1=Day(FromDate)
'ToDate=Request("txtToDate")
'if ToDate="" then ToDate=Date
'ToDate=CDate(ToDate)
'vYear2=Year(ToDate)
'vMonth2=Month(ToDate)
'vDay2=Day(ToDate)
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
'get all Accounts Receivable from gl
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Accounts Receivable'"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vARAcct=""
'response.write SQL

Do While Not rs.EOF
	if Not vARAcct="" then vARAcct=vARAcct & ","
	vARAcct=vARAcct & rs("gl_account_number")
	rs.MoveNext
Loop
rs.close
if vARAcct="" then vARAcct=0

'get beginning balance for each customer
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and tran_date <" & DM & FromDate & DM & " Group by elt_account_number,customer_number"
	else
		SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and tran_date <" & DM & FromDate & DM & " and customer_number=" & vCompany & " Group by elt_account_number,customer_number"
	end if
else
	SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vARAcct & ") and tran_date <" & DM & FromDate & DM & " Group by elt_account_number,customer_number"
end If
'response.write SQL
rs.Open SQL, eltConn, adOpenStatic, , adCmdText

'tCIndex=0
'vLastCustomer=0
'if Not rs.EOF then
'	vLastCustomer=cLng(rs("customer_number"))
'end if

Do While Not rs.EOF
	vBranchID=cInt(Mid(rs("elt_account_number"),7,2))
	if vBranchID=0 then vBranchID=""
	vCustomer=cLng(rs("customer_number"))
	Bal=0
	Bal=rs("Balance")
	if vCustomer<100000 then
		cusBalance(vBranchID & vCustomer)=Bal
	end if
	rs.MoveNext
Loop
rs.close
%>

<%

%>

<%
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') order by customer_name,tran_date,tran_seq_num"
	else
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') and customer_number=" & vCompany & " order by customer_name,tran_date,tran_seq_num"
	end if
else
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') order by elt_account_number,customer_name,tran_date,tran_seq_num"
end if
'response.write SQL

'if Not Branch=0 then
'	if vCompany=0 then
'		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') and ( debit_amount <> 0 or credit_amount <> 0 or balance <> 0 ) order by customer_name,tran_date,tran_seq_num"
'	else
'		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') and customer_number=" & vCompany & "  and ( debit_amount <> 0 or credit_amount <> 0 or balance <> 0 ) order by customer_name,tran_date,tran_seq_num"
'	end if
'else
'	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vARAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT')  and ( debit_amount <> 0 or credit_amount <> 0 or balance <> 0 ) order by elt_account_number,customer_name,tran_date,tran_seq_num"
'end if
%>

<%

%>


<%
'response.write SQL
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
Do While Not rs.EOF and tIndex<Count
	CurrBranch=cLng(rs("elt_account_number"))
	if Branch=0 And tIndex=0 then
		aField1(tIndex)=CurrBranch
		tIndex=tIndex+1
		LastBranch=CurrBranch
	end if
	cName=rs("customer_name")
	cNumber=cLng(rs("customer_number"))
	if cNumber>10000 then cNumber=0
	if (Not LastCustomer=rs("customer_name")) or (Branch=0 And Not CurrBranch=LastBranch) then
		if (Not tIndex=0 and Not Branch=0) Or (Not tIndex=1 And Branch=0) then
			aField5(tIndex)="Sub Total"
			aField6(tIndex)=FormatCurrency(vSubTotal)
			aField7(tIndex)=aField7(tIndex-1)
			vTotalBalance=vTotalBalance+cDbl(vSubBal)
			tIndex=tIndex+2
		end if
		if Branch=0 And Not CurrBranch=LastBranch then
			aField1(tIndex)=CurrBranch
			tIndex=tIndex+1
			LastBranch=CurrBranch
		end if
		aField1(tIndex)=cName
		LastCustomer=cName
		vSubTotal=0
		bID=cInt(Mid(CurrBranch,7,2))
		if bID=0 then bID=""
		vSubBal=cDbl(cusBalance(bID & cNumber))
		aField7(tIndex)=vSubBal
		if aField7(tIndex)="" then aField7(tIndex)=0
		tIndex=tIndex+1
	end if
	vTranType=rs("tran_type")
	iType=rs("air_ocean")
	if not vTranType="INIT" then
		aField2(tIndex)=vTranType
		aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
		aField4(tIndex)=rs("tran_num")
		aField5(tIndex)=rs("gl_account_name")
		Debit=rs("debit_amount")
		Credit=rs("credit_amount")
		if cDbl(Debit)=0 then
			aField6(tIndex)=Credit
		else
			aField6(tIndex)=Debit
		end if
		vSubTotal=vSubTotal+cDbl(aField6(tIndex))
		vSubBal=vSubBal+cDbl(aField6(tIndex))
		aField7(tIndex)=vSubBal
		vTotal=vTotal+cDbl(aField6(tIndex))
		aField6(tIndex)=FormatCurrency(aField6(tIndex))
		aField7(tIndex)=FormatCurrency(aField7(tIndex))
		if aField2(tIndex)="PMT" then
			aField8(tIndex)=rs("memo")
		else
			aField8(tIndex)=aField4(tIndex)
		end if
		if aField2(tIndex)="PMT" then
			if Not CurrBranch=cLng(elt_account_number) then
				aLink(tIndex)="../acct_tasks/receiv_pay.asp?PaymentNo=" & aField4(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
			else
				aLink(tIndex)="../acct_tasks/receiv_pay.asp?PaymentNo=" & aField4(tIndex)
			end if
		elseif aField2(tIndex)="GJE" then
			aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField4(tIndex)
		elseif aField2(tIndex)="INV" then
			if Not CurrBranch=cLng(elt_account_number) then
				aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex) & "&Branch=" & CurrBranch
			else
				aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
			end if
		elseif aField2(tIndex)="ARN" then
			aLink(tIndex)="../air_import/arrival_notice.asp?iType=" & iType & "&edit=yes&InvoiceNo=" & aField4(tIndex)
		end if
		tIndex=tIndex+1
	end if
	rs.MoveNext
Loop
rs.Close
aField5(tIndex)="Sub Total"
aField6(tIndex)=FormatCurrency(vSubTotal)
if tIndex>0 then
	aField7(tIndex)=aField7(tIndex-1)
else
	aField7(tIndex)="$0.00"
end if
vTotalBalance=vTotalBalance+cDbl(vSubBal)

'get company info
Dim aCompany(1024),aCompanyAcct(1024)
aCompany(0)="All"
aCompanyAcct(0)=0
cIndex=1
SQL= "select dba_name,org_account_number from organization where elt_account_number=" & Branch & " and (is_shipper='Y' or is_consignee='Y' or is_agent='Y') order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
Do While Not rs.EOF
	aCompany(cIndex)=rs("dba_name")
	aCompanyAcct(cIndex)=Clng(rs("org_account_number"))
	rs.MoveNext
	cIndex=cIndex+1
Loop
rs.Close
Set rs=Nothing

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
      <td height="20" align="left" valign="bottom" class="pageheader">Ar Detail</td>
  </tr>
</table>

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
<!--  #INCLUDE FILE="../include/calendar1.htm" --> 
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
			      <td><div align="right"><img src="../images/button_print_medium.gif" name="bPrint" width="52" height="18" onClick="PrintReport()" ></div></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">ACCOUNTS 
                    RECEIVABLE DETAIL REPORT</td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"> 
                    <%= FromDate %> through <%= ToDate %> 
                  </td>
                </tr>
                <% 'if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% 'end if %>
                <tr>
				<tr>
				  <td align="center" valign="middle"><strong>Company</strong> &nbsp; 
                    <select name=lstCompany size=1 class="smallselect" style="width:180">
<% for i=0 to cIndex-1 %>
		<option value="<%= aCompanyAcct(i) %>" <% if cLng(vCompany)=aCompanyAcct(i) then response.write("selected") %>><%= aCompany(i) %></option>
<% next %>
		</select>
				</td>
				</tr>
				<tr>
			      <td height="27" align="center" valign="bottom"><img src="../images/button_refresh.gif" width="64" height="18" onClick="BranchChange()"> 
                  </td>
			</tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="70%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle"> 
                  <td width="31%" height="20" bgcolor="D5E8CB"><strong>Company 
                    Name </strong></td>
                  <td width="6%" bgcolor="D5E8CB"><strong>Type</strong></td>
                  <td width="13%" bgcolor="D5E8CB"><strong>Date</strong></td>
                  <td width="6%" bgcolor="D5E8CB"><strong>Num</strong></td>
                  <td width="22%" bgcolor="D5E8CB"><strong>Account</strong></td>
                  <td width="11%" bgcolor="D5E8CB"><strong>Amount</strong></td>
                  <td width="11%" bgcolor="D5E8CB"><strong>Balance</strong></td>
                </tr>
<% for i=0 to tIndex %>
<% 'if Not aField6 (i) = 0 or Not aField7 (i) = 0 then %>
                <tr align="left" valign="middle" bgcolor="F3F3F3"> 
                  <td><font size="<% if Mid(aField1(i),1,1)="8" then response.write("4") else response.write("1") %>"><b><%= aField1(i) %></b></font><font size="2">&nbsp;</font></td>
<% if not aField4(i)="" then %>
                  <td><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></font></a></td>
                  <td><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></font></a></td>
                  <td><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></font></a></td>
                  <td>
                    <%  if aField5(i)="Sub Total" then response.write("<b>") %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><font size="1"><%= aField5(i)%></font>
					<%  if aField5(i)="Sub Total" then response.write("</b>") %></a></td>
                  <td align="right"> 
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><font size="1"><%= aField6(i) %></font></a> 
                  </td>
                  <td align="right"> 
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><font size="1"><%= aField7(i) %></font></a> 
                  </td>
                </tr>
<% else %>
                <tr align="left" valign="middle"> 
                  <td bgcolor="#F3f3f3"><%= aField2(i) %></td>
                  <td bgcolor="#F3f3f3"><%= aField3(i) %></td>
                  <td bgcolor="#F3f3f3"><%= aField4(i) %></td>
                  <td bgcolor="#F3f3f3">&nbsp; </td>
                  <td align="right" bgcolor="#F3f3f3"> 
                    <%  if aField5(i)="Sub Total" then response.write("<b>") %>
                    <%= aField5(i) %> 
                    <%  if aField5(i)="Sub Total" then response.write("</b>") %>
                  </td>
                  <td align="right" bgcolor="#F3f3f3"><strong>
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <%= aField6(i) %> </strong></td>
                  <td align="right" bgcolor="#F3f3f3"><strong>
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <% if Not aField7(i)="" then response.write(FormatNumber(aField7(i),2)) %></strong>
                  </td>
                </tr>				
<% end if %>
<%' end if %>

<% next %>
				<tr>
				  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
				</tr>
				<tr>
				  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
				</tr>
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20" colspan="5" align="right" bgcolor="D5E8CB"><strong>TOTAL</strong></td>
                  <td align="right"><strong><%= FormatCurrency(vTotal) %></strong></td>
                  <td align="right"><strong><%= FormatCurrency(vTotalBalance) %></strong></td>
                </tr>
                <tr align="left" valign="middle"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td align="right">&nbsp;</td>
                  <td align="right">&nbsp;</td>
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
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ar_detail.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="ar_detail.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="ar_detailPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
