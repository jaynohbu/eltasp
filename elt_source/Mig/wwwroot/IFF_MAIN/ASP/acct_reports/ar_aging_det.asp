<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>A/R Aging detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
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
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
vCompany=Request("lstCompany")
if vCompany="" then vCompany=0

myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
Set rs = Server.CreateObject("ADODB.Recordset")
' get org name
if Not Branch=0 then
	SQL= "select dba_name from agent where elt_account_number = " & Branch
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vOrgName=rs("dba_name")
	end if
	rs.close
end if
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select * from invoice where elt_account_number = " & Branch & " and invoice_date<" & DM & ToDate+1 & DM & " and balance>0 and pay_status='A' order by invoice_date+term_curr desc,invoice_no"
	else
		SQL= "select * from invoice where elt_account_number = " & Branch & " and invoice_date<" & DM & ToDate+1 & DM & " and balance>0 and pay_status='A' and customer_number=" & vCompany & " order by invoice_date+term_curr desc,invoice_no"
	end if
else
	SQL= "select * from invoice where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and invoice_date<" & DM & ToDate+1 & DM & " and balance>0 and pay_status='A' order by invoice_date+term_curr desc,invoice_no"
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
tIndex=0
tCurrent=0
t1_30=0
t31_60=0
t61_90=0
t91=0
sTotalCurrent=0
sTotal1_30=0
sTotal31_60=0
sTotal61_90=0
sTotal91=0
vTotal=0
Do While Not rs.EOF And tIndex<Count
	aField1(tIndex)=rs("customer_name")
	vInvoiceType=rs("invoice_type")
	if vInvoiceType="I" then
		aField2(tIndex)="INVOICE"
	elseif vInvoiceType="G" then
		aField2(tIndex)="GJE"
	else
		aField2(tIndex)="PAYMENT"
	end if
	aField3(tIndex)=rs("invoice_date")
	aField4(tIndex)=rs("invoice_no")
	aField5(tIndex)=rs("ref_no")
	vTerm=rs("term_curr")
	vEI=rs("import_export")
	iType=rs("air_ocean")
	if not vInvoiceType="P" then
		aField6(tIndex)=aField3(tIndex)+vTerm
	end if
	vAging=Date-aField6(tIndex)
	if vAging>0 And not vInvoiceType="P" then aField7(tIndex)=vAging
		aField8(tIndex)=cDbl(rs("balance"))
	if vInvoiceType="P" then aField8(tIndex)=-aField8(tIndex)
	if vAging<=0 then
		tCurrent=tCurrent+1
		sTotalCurrent=sTotalCurrent+aField8(tIndex)
	elseif vAging>0 and vAging<31 then
		t1_30=t1_30+1
		sTotal1_30=sTotal1_30+aField8(tIndex)
	elseif vAging>30 and vAging<61 then
		t31_60=t31_60+1
		sTotal31_60=sTotal31_60+aField8(tIndex)
	elseif vAging>60 And vAging<91 then
		t61_90=t61_90+1
		sTotal61_90=sTotal61_90+aField8(tIndex)
	elseif vAging>90 then
		t91=t91+1
		sTotal91=sTotal91+aField8(tIndex)
	end if

	if vInvoiceType="P" then
		if Not CurrBranch=cLng(elt_account_number) then
			aLink(tIndex)="receiv_pay.asp?PaymentNo=" & aField4(tIndex) & "&Branch=" & CurrBranch
		else
			aLink(tIndex)="receiv_pay.asp?PaymentNo=" & aField4(tIndex)
		end if
	elseif vInvoiceType="G" then
		aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField5(tIndex)
	elseif vEI="I" then
		aLink(tIndex)="../air_import/arrival_notice.asp?iType=" & iType & "&edit=yes&InvoiceNo=" & aField4(tIndex)
	else
		if Not CurrBranch=cLng(elt_account_number) then
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex) & "&Branch=" & CurrBranch
		else
			aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
		end if
	end if
	vTotal=vTotal+aField8(tIndex)
	aField8(tIndex)=FormatNumber(aField8(tIndex),2)
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close
sTotalCurrent=FormatNumber(sTotalCurrent,2)
sTotal1_30=FormatNumber(sTotal1_30,2)
sTotal31_60=FormatNumber(sTotal31_60,2)
sTotal61_90=FormatNumber(sTotal61_90,2)
sTotal91=FormatNumber(sTotal91,2)
vTotal=FormatNumber(vTotal,2)
'get company info
Dim aCompany(10000),aCompanyAcct(10000)
aCompany(0)="All"
aCompanyAcct(0)=0
cIndex=1
'SQL= "select dba_name,org_account_number from organization where elt_account_number=" & Branch & " and (is_shipper='Y' or is_consignee='Y' or is_agent='Y') order by dba_name"
SQL= "select dba_name,org_account_number from organization where elt_account_number=" & Branch & " order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
Do While Not rs.EOF
	aCompany(cIndex)=rs("dba_name")
	aCompanyAcct(cIndex)=Clng(rs("org_account_number"))
	rs.MoveNext
	cIndex=cIndex+1
Loop
rs.close
Set rs=Nothing

%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">

	<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">A/R Report</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="1" align="right" valign="middle" class="pageheader">
      <!--  #INCLUDE FILE="../include/calendar2.htm" -->
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
			      <td align="right">&nbsp;</td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">A/R 
                    AGING DETAIL</td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong>As 
                    of <%= FormatDateTime(ToDate,1) %></strong></td>
                </tr>
<% if UserRight=9 then %>
<!--  #INCLUDE FILE="../include/branch.asp" -->
<% end if %>
                <tr> 
                  <td align="center" valign="middle"><strong>Company</strong> 
                    &nbsp; <select name=lstCompany size=1 class="smallselect" style="width:180">
                      <% for i=0 to cIndex-1 %>
                      <option value="<%= aCompanyAcct(i) %>" <% if cLng(vCompany)=aCompanyAcct(i) then response.write("selected") %>><%= aCompany(i) %></option>
                      <% next %>
                    </select></td>
                </tr>
				<tr>
				  <td height="27" align="center" valign="bottom"><img src="../images/button_refresh.gif" onClick="BranchChange()" ></td>
				</tr>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="77%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="24%" height="20"><strong>Company Name</strong></td>
                  <td width="11%" align="left"><strong>Type</strong></td>
                  <td width="11%" align="left"><strong>Invoice Date</strong></td>
                  <td width="11%" align="left"><strong>Invoice No</strong></td>
                  <td width="12%" align="left"><strong>Reference No</strong></td>
                  <td width="11%" align="left"><strong>Due Date</strong></td>
                  <td width="6%" align="right"><strong>Aging</strong></td>
                  <td width="14%" align="right"><strong>Open Balance</strong></td>
                </tr>             
				<tr valign="top" bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>Current</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=0 to tCurrent-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>				
                <tr valign="top" bgcolor="f3f3f3"> 
   
				  <td colspan="7" align="right" valign="middle"><strong>Total 
                    Current</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotalCurrent %></strong></td>
                </tr>
                <tr>
				  <td colspan="8" height="1" bgcolor="89A979"></td>
				</tr> 
				  
                <tr bgcolor="ecf7f8">
                  <td align="left" valign="middle"><strong>1-30</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=tCurrent to tCurrent+t1_30-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="f3f3f3"> 
				  <td colspan="7" align="right" valign="middle"><strong>Total 
                    1-30</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal1_30 %></strong></td>
                </tr> 
                <tr>
				  <td colspan="8" height="1" bgcolor="89A979"></td>
				</tr>   
                <tr bgcolor="ecf7f8">
<td align="left" valign="middle"><strong>31-60</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=tCurrent+t1_30 to tCurrent+t1_30+t31_60-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle">
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" >
				  <a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>				 
				<tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="7" align="right" valign="middle"><strong>Total 
                    31-60</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal31_60 %></strong></td>
                </tr>
                <tr>
				  <td colspan="8" height="1" bgcolor="89A979"></td>
				</tr> 
				  
                <tr bgcolor="ecf7f8">
                  <td align="left" valign="middle"><strong>61-90</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
				  </tr>
<% for i=tCurrent+t1_30+t31_60 to tCurrent+t1_30+t31_60+t61_90-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="7" align="right" valign="middle"><strong>Total 
                    61-90</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal61_90 %></strong></td>
                </tr>
                <tr>
				  <td colspan="8" height="1" bgcolor="89A979"></td>
				</tr> 
				  
                <tr bgcolor="ecf7f8">
                  <td align="left" valign="middle"><strong>&gt;90</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
 <% for i=tCurrent+t1_30+t31_60+t61_90 to tCurrent+t1_30+t31_60+t61_90+t91-1 %>               
				<tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField5(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>				
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="7" align="right" valign="middle"><strong>Total&gt;90</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal91 %></strong></td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td colspan="8" height="20" align="left" valign="top">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="8" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="8" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr valign="middle" bgcolor="D5E8CB" class="bodyheader"> 
                  <td height="20" colspan="7" align="right">TOTAL BALANCE</td>
                  <td align="right"><b><%= vTotal %></b></td>
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
</table>      </form>
<br>

</body>
<script language="VBScript">
<!--
Sub ViewClick(InvoiceType,InvoiceNo)
if InvoiceType="INVOICE" then
	document.form1.action="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo & "&WindowName=" & window.name
else
	document.form1.action="../acct_tasks/receive_pay.asp?PaymentNo=" & InvoiceNo & "&WindowName=" & window.name
end if
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()

End Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ar_aging_det.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="ar_aging_det.asp" & "?WindowName=" & window.name
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
	document.form1.action="ar_aging_detPrint.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="popUpWindow"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
