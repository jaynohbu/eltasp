<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>Sales</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
Set rs = Server.CreateObject("ADODB.Recordset")
FromDate=Request("txtFromDate")
if FromDate="" then FromDate=Month(Date) & "/1/" & Year(Date)
vYear1=Year(FromDate)
vMonth1=Month(FromDate)
vDay1=Day(FromDate)
ToDate=Request("txtToDate")
if ToDate="" then ToDate=Date
ToDate=CDate(ToDate)
vYear2=Year(ToDate)
vMonth2=Month(ToDate)
vDay2=Day(ToDate)
' get org name
if Not Branch=0 then
	SQL= "select dba_name from agent where elt_account_number = " & Branch
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vOrgName=rs("dba_name")
	end if
	rs.close
end if
'get all Revenue Accts from gl
'Dim aARDesc(1000000)
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Revenue'"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vRevenueAcct=""
Do While Not rs.EOF
	if Not vRevenueAcct="" then vRevenueAcct=vRevenueAcct & ","
	vRevenueAcct=vRevenueAcct & rs("gl_account_number")
	'aARDesc(rs("gl_account_number"))=rs("gl_account_desc")
	rs.MoveNext
Loop
rs.close
if vRevenueAcct="" then vRevenueAcct=0
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
if Not Branch=0 then
	SQL= "select * from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vRevenueAcct & ") and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and tran_type in ('INV','CM') order by customer_name,tran_date"
else
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vRevenueAcct & ") and tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " and tran_type in ('INV','CM') order by elt_account_number,customer_name,tran_date"
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
Do While Not rs.EOF And tIndex<Count
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
		'aField7(tIndex)=rs("previous_balance")
		tIndex=tIndex+1
	end if
	aField2(tIndex)=rs("tran_type")
	aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
	aField4(tIndex)=rs("tran_num")
	aField5(tIndex)=Mid(rs("memo"),1,15)
	aField6(tIndex)=rs("gl_account_name")
	aField7(tIndex)=rs("split")
	Credit=-cDbl(rs("credit_amount"))
	aField8(tIndex)=Credit
	'aField9(tIndex)=Credit+aField9(tIndex-1)
	vSubTotal=vSubTotal+cDbl(aField8(tIndex))
	aField9(tIndex)=vSubTotal
	vTotal=vTotal+cDbl(aField8(tIndex))
	vSubBalance=aField9(tIndex)
	aField8(tIndex)=FormatCurrency(aField8(tIndex))
	aField9(tIndex)=FormatCurrency(aField9(tIndex))
	if aField2(tIndex)="CM" then
		aLink(tIndex)="../acct_tasks/receive_pay.asp?PaymentNo=" & aField4(tIndex)
	else
		if Not CurrBranch=cLng(elt_account_number) then
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex) & "&Branch=" & CurrBranch
		else
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
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
<body link="336699" vlink="336699" alink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">Sales</td>
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
                  <td height="29" align="center" valign="middle" class="bodyheader">SALES 
                    REPORT </td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong><%= FromDate %></strong> &nbsp;&nbsp; 
                    through &nbsp;&nbsp;&nbsp;<strong><%= ToDate %></strong></td>
                </tr>
                <% 'if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% 'end if %>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="90%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="20%" height="20"><strong>Comapny Name</strong></td>
                  <td width="6%"><strong>Type</strong></td>
                  <td width="8%"><strong>Date</strong></td>
                  <td width="6%"><strong>Num</strong></td>
                  <td width="11%"><strong>Memo</strong></td>
                  <td width="18%"><strong>Account</strong></td>
                  <td width="13%"><strong>Split</strong></td>
                  <td width="9%" align="left"><strong>Amount</strong></td>
                  <td width="9%" align="left"><strong>Balance</strong></td>
                </tr>
                <% for i=0 to tIndex %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left"><b><%= aField1(i) %></b></td>
                  <% if not aField4(i)="" then %>
                  <td align="left"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="left" valign="middle"> 
                    <%  if aField7(i)="Sub Total" then response.write("<b>") %><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));">
                    <%= aField7(i) %><a>
                    <%  if aField7(i)="Sub Total" then response.write("</b>") %></td>
                  <td align="right"> <% if aField7(i)="Sub Total" then %> <hr width="80%" size="1" color="#000000"> <% end if %> <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                  <td align="right"> <% if aField7(i)="Sub Total" then %> <hr width="80%" size="1" color="#000000"> <% end if %> <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField9(i) %></a> </td>
                </tr>
                <% else %>
                <tr bgcolor="f3f3f3"> 
                  <td align="left" valign="top"><%= aField2(i) %></td>
                  <td align="left" valign="top"><%= aField3(i) %></td>
                  <td align="left" valign="top"><%= aField4(i) %></td>
                  <td align="left" valign="top"><%= aField5(i) %></td>
                  <td align="left" valign="top"><%= aField6(i) %></td>
                  <td >&nbsp; </td>
                  <td align="right" valign="middle"> 
                    <%  if aField7(i)="Sub Total" then response.write("<b>") %> <%= aField7(i) %> <%  if aField7(i)="Sub Total" then response.write("</b>") %> </td>
                  <td align="right" valign="top"> <strong><% if aField7(i)="Sub Total" then %>
                    <% end if %> <%= aField8(i) %> </strong></td>
                  <td align="right" valign="top"> <strong><% if aField7(i)="Sub Total" then %>
                    <% end if %> <%= aField9(i) %></strong></td>
                </tr>
                <% end if %>
                <% next %>
                <tr> 
                  <td colspan="10" height="20" bgcolor="f3f3f3"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="10" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr valign="middle" bgcolor="D5E8CB" class="bodyheader"> 
                  <td colspan="7" height="20" align="right"><strong>TOTAL</strong></td>
                  <td align="right"><%= FormatCurrency(vTotal) %> </td>
                  <td align="right"><%= FormatCurrency(vTotalBalance) %></td>
                </tr>
                <tr> 
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
	document.form1.action="salesPrint.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="popUpWindow"
	form1.submit()
End Sub

Sub key()
if Window.event.Keycode=13 then
	document.form1.action="sales.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="sales.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
