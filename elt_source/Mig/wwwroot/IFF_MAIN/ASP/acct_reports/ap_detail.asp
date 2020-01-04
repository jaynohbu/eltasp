<%@LANGUAGE="VBSCRIPT"%>
<% Response.Buffer=True %>
<html>
<head>
<title>AP Detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/getDates.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Dim cusBalance(320000)
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
vCompany=Request("lstCompany")
if vCompany="" then vCompany=0
Set rs = Server.CreateObject("ADODB.Recordset")
ByInvoiceDate=Request("ByInvoiceDate")
ByDueDate=Request("ByDueDate")

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
'Dim aARDesc(1000000)
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Accounts Payable'"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vAPAcct=""
Do While Not rs.EOF
	if Not vAPAcct="" then vAPAcct=vAPAcct & ","
	vAPAcct=vAPAcct & rs("gl_account_number")
	'aARDesc(rs("gl_account_number"))=rs("gl_account_desc")
	rs.MoveNext
Loop
rs.close
if vAPAcct="" then vAPAcct=0
'get beginning balance for each customer
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vAPAcct & ") and tran_date <" & DM & FromDate & DM & " Group by elt_account_number,customer_number"
	else
		SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vAPAcct & ") and tran_date <" & DM & FromDate & DM & " and customer_number=" & vCompany & " Group by elt_account_number,customer_number"
	end if
else
	SQL= "select elt_account_number,customer_number,sum(credit_amount+debit_amount) as balance from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vAPAcct & ") and tran_date <" & DM & FromDate & DM & " Group by elt_account_number,customer_number"
end if
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
Do While Not rs.EOF
	vBranchID=cInt(Mid(rs("elt_account_number"),7,2))
	if vBranchID=0 then vBranchID=""
	vCustomer=rs("customer_number")
	Bal=0
	Bal=rs("Balance")
	cusBalance(vBranchID & vCustomer)=Bal
	rs.MoveNext
Loop
rs.close
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vAPAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') order by customer_name,tran_date,tran_seq_num"
	else
		SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vAPAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') and customer_number=" & vCompany & " order by tran_date,tran_seq_num"
	end if
else
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vAPAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') order by elt_account_number,customer_name,tran_date,tran_seq_num"
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
vTotal1=0
vSubTotal=0
vSubBal=0
vTotalPostBalance=0
LastCustomer=""
LastBranch=0
aField1(0)="Posted Transactions"
tIndex=tIndex+1
Do While Not rs.EOF And tIndex<Count
	CurrBranch=cLng(rs("elt_account_number"))
	if Branch=0 And tIndex=1 then
		aField1(tIndex)=CurrBranch
		tIndex=tIndex+1
		LastBranch=CurrBranch
	end if
	cName=rs("customer_name")
	cNumber=rs("customer_number")
	if (Not LastCustomer=rs("customer_name")) or (Branch=0 And Not CurrBranch=LastBranch) then
		if (Not tIndex=1 and Not Branch=0) Or (Not tIndex=1 And Branch=0) then
			aField5(tIndex)="Sub Total"
			aField6(tIndex)=FormatCurrency(vSubTotal)
			aField7(tIndex)=aField7(tIndex-1)
			vTotalPostBalance=vTotalPostBalance+cDbl(vSubBal)
'response.write("<br>vSubBalance!!!!!!=" & vSubBalance)
			tIndex=tIndex+1
		'else
		'	vTotalPostBalance=vTotalPostBalance+cDbl(cusBalance(cNumber))
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
		vTotal1=vTotal1+cDbl(aField6(tIndex))
		vSubBalance=aField7(tIndex)
		aField6(tIndex)=FormatCurrency(aField6(tIndex))
		aField7(tIndex)=FormatCurrency(aField7(tIndex))
		if aField2(tIndex)="BILL" then
			if Not CurrBranch=cLng(elt_account_number) then
				aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField4(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
			else
				aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField4(tIndex)
			end if
		elseif aField2(tIndex)="GJE" then
			aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField4(tIndex)
		else
			if Not CurrBranch=cLng(elt_account_number) then
				aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
			else
				aLink(tIndex)="../acct_tasks/pay_bills.asp?EditCheck=yes&CheckQueueID=" & aField4(tIndex)
			end if
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
vTotalPostBalance=vTotalPostBalance+cDbl(vSubBalance)
tIndex=tIndex+1
aField5(tIndex)="Total Posted Balance"
aField6(tIndex)=FormatCurrency(vTotal1)
aField7(tIndex)=FormatCurrency(vTotalPostBalance)
tIndex=tIndex+1
' get all unposted transactions
vUnPost=Request("cUnPost")
if vUnPost="Y" then
	vTotal2=0
	LastVendor=""
	tIndex=tIndex+1
	aField1(tIndex)="Unposted Transactions"
	tIndex=tIndex+1
	vMark=tIndex
	vUnPostBalance=0
	vTotalUnPostBalance=0

	if vCompany=0 then
	SQL= "select a.*,b.dba_name from bill_detail a,organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and a.bill_number=0 and a.vendor_number=b.org_account_number and a.item_amt>0  order by b.dba_name"
	else
	SQL= "select a.*,b.dba_name from bill_detail a,organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and a.bill_number=0 and b.org_account_number=" & vCompany & " and a.item_amt>0  order by b.dba_name"
	end if

	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	Do While Not rs.EOF and tIndex<Count
		cName=rs("dba_name")
		if Not LastVendor=rs("dba_name") then
			if Not tIndex=vMark then
				aField5(tIndex)="Sub Total"
				aField6(tIndex)=FormatCurrency(vSubTotal)
				aField7(tIndex)=FormatCurrency(vUnPostBalance)
				tIndex=tIndex+1
			end if
			aField1(tIndex)=cName
			LastVendor=cName
			vSubTotal=0
			vUnPostBalance=0
		end if
		aField2(tIndex)="BILL"
		aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
		aField4(tIndex)=rs("invoice_no")
		Amount=cDbl(rs("item_amt"))
		aField6(tIndex)=FormatCurrency(-Amount)
		vUnPostBalance=vUnPostBalance-Amount
		vTotalUnPostBalance=vTotalUnPostBalance-Amount
		aField7(tIndex)=FormatCurrency(vUnPostBalance)
		aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
		vSubTotal=vSubTotal-Amount
		vTotal2=vTotal2-Amount
		tIndex=tIndex+1
		rs.MoveNext
	Loop
	rs.close
	if tIndex>vMark then
		aField5(tIndex)="Sub Total"
		aField6(tIndex)=FormatCurrency(vSubTotal)
		aField7(tIndex)=FormatCurrency(vUnPostBalance)
		tIndex=tIndex+1
		aField5(tIndex)="Total Unposted Balance"
		aField6(tIndex)=FormatCurrency(vTotal2)
		aField7(tIndex)=FormatCurrency(vTotalUnPostBalance)
	else
		aField5(tIndex)="Total Unposted Balance"
		aField6(tIndex)=FormatCurrency(0)
		aField7(tIndex)=FormatCurrency(0)
	end if
end if
vTotalBalance=vTotalPostBalance+vTotalUnPostBalance
vTotal=vTotal1+vTotal2
'get company info
Dim aCompany(1024),aCompanyAcct(1024)
aCompany(0)="All"
aCompanyAcct(0)=0
cIndex=1
SQL= "select dba_name,org_account_number from organization where elt_account_number=" & Branch & " and is_vendor='Y' order by dba_name"
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
    <td height="20" align="left" valign="bottom" class="pageheader">AP Detail</td>
  </tr>
</table>

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td height="1" align="right" valign="middle" class="pageheader">
        <!--  #INCLUDE FILE="../include/calendar1.htm" -->
      </td>
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
                    PAYABLE </td>
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
             <tr>
			      <td height="24" align="center" valign="bottom"> 
                    <input type=checkbox value="Y" name="cUnPost" <% if vUnPost="Y" then response.write("checked") %> onClick="UnPostClick()">
                    <b>Include Unposted transactions</b></td>
			</tr>
			<tr>
			      <td height="24" align="center" valign="bottom">
				    <input type=radio value="Y" name="ByInvoiceDate" <% if ByInvoiceDate="Y" then response.write("checked") %> onClick="ByWhatDate1()">
                    <strong> By Invoice Date</strong> &nbsp;&nbsp;&nbsp;&nbsp; 
					<input type=radio value="Y" name="ByDueDate" <% if ByDueDate="Y" then response.write("checked") %> onClick="ByWhatDate2()">
                    <strong> By Due Date</strong></td>
			</tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="80%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle"> 
                  <td width="24%" height="20" bgcolor="D5E8CB"><strong>Company 
                    Name </strong></td>
                  <td width="10%" bgcolor="D5E8CB"><strong>Type</strong></td>
                  <td width="8%" bgcolor="D5E8CB"><strong>Date</strong></td>
                  <td width="8%" bgcolor="D5E8CB"><strong>Num</strong></td>
                  <td width="22%" bgcolor="D5E8CB"><strong>Account</strong></td>
                  <td width="14%" bgcolor="D5E8CB"><strong>Amount</strong></td>
                  <td width="14%" bgcolor="D5E8CB"><strong>Balance</strong></td>
                </tr>
<% for i=0 to tIndex %>
                <tr align="left" valign="middle"> 
                  <td bgcolor="#F3f3f3"><strong><%= aField1(i) %></strong></td>
<% if not aField4(i)="" then %>
                  <td bgcolor="#F3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td bgcolor="#F3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td bgcolor="#F3f3f3"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="right" bgcolor="#F3f3f3"> 
                    <%  if aField5(i)="Sub Total" then response.write("<b>") %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %><a>
                    <%  if aField5(i)="Sub Total" then response.write("</b>") %>
                    </a></a></td>
                  <td align="right" bgcolor="#F3f3f3"> 
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" bgcolor="#F3f3f3"> 
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                </tr>
<% else %>
                <tr align="left" valign="middle"> 
                  <td bgcolor="#F3f3f3"><%= aField2(i) %></td>
                  <td bgcolor="#F3f3f3"><%= aField3(i) %></td>
                  <td bgcolor="#F3f3f3"><%= aField4(i) %></td>
                  <td bgcolor="#F3f3f3">&nbsp;</td>
                  <td align="right" bgcolor="#F3f3f3"><b><%= aField5(i) %></b></td>
                  <td align="right" bgcolor="#F3f3f3"><strong>
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <%= aField6(i) %></strong></td>
                  <td align="right" bgcolor="#F3f3f3"><strong>
                    <% if aField5(i)="Sub Total" then %>
                    <% end if %>
                    <%= aField7(i) %></strong></td>
                </tr>				
<% end if %>
<% next %>
				<tr>
				  <td height="20" colspan="10" align="left" valign="middle" bgcolor="f3f3f3"></td>
				</tr>
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

Sub ByWhatDate1()
if document.form1.ByInvoiceDate.checked = true then
	document.form1.ByDueDate.checked = false
	document.form1.action="../acct_reports/ap_detail.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	form1.submit()
end if

End Sub

Sub ByWhatDate2()
if document.form1.ByDueDate.checked = true then
	document.form1.ByInvoiceDate.checked = false
	document.form1.action="../acct_reports/ap_detail.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	form1.submit()
end if

End Sub

Sub ViewClick(BillNo)
	document.form1.action="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & BillNo & "&WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
End Sub
Sub UnPostClick()
	document.form1.action="ap_detail.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
End Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ap_detail.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="ap_detail.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="ap_detailPrint.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="popUpWindow"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
