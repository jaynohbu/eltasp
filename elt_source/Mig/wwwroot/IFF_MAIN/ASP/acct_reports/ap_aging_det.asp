<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>A/P Aging detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PrintFormat.htm" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/getDates.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5(),aField6(),aField7(),aField8(),aField9(),aLink()
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
vCompany=Request("lstCompany")
if vCompany="" then vCompany=0
'get date
'ToDate=Request("txtToDate")
'if ToDate="" then ToDate=Date
'ToDate=CDate(ToDate)
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
'get posted transactions
if Not Branch=0 then
	if vCompany=0 then
		SQL= "select * from bill where elt_account_number = " & Branch & " and bill_date<" & DM & ToDate+1 & DM & " and bill_amt_due>0  order by bill_date desc,bill_number"
	else
		SQL= "select * from bill where elt_account_number = " & Branch & " and bill_date<" & DM & ToDate+1 & DM & " and bill_amt_due>0 and vendor_number=" & vCompany & " order by bill_date desc,bill_number"
	end if
else
	SQL= "select * from bill where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and bill_date<" & DM & ToDate+1 & DM & " and bill_amt_due>0  order by bill_date desc,bill_number"
end If
'response.write SQL
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
tIndex=0
'rs.MoveLast
Count=rs.RecordCount+10000
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
	cName=rs("vendor_name")
	aField1(tIndex)=rs("vendor_name")
	aField2(tIndex)=rs("bill_type")
	if aField2(tIndex)="G" then
		aField2(tIndex)="GJE"
	else
		aField2(tIndex)="BILL"
	end if
	aField3(tIndex)=rs("bill_date")
	aField4(tIndex)=rs("ref_no")
	aField5(tIndex)=rs("bill_number")
	aField6(tIndex)=rs("bill_due_date")
	vAging=Date-aField6(tIndex)
	'aField7(tIndex)=Date-aField6(tIndex)
	if vAging>0 then aField7(tIndex)=vAging
	aField8(tIndex)=cDbl(rs("bill_amt_due"))
	'if vInvoiceType="P" then aField8(tIndex)=-aField8(tIndex)
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
	
	if aField2(tIndex)="BILL" then
		if Not CurrBranch=FormatNumberPlus(checkblank(elt_account_number,"0"),0) then
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField5(tIndex) & "&Branch=" & CurrBranch & "&BCustomer=" & cName
		else
			aLink(tIndex)="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & aField5(tIndex)
		end if
	elseif aField2(tIndex)="GJE" then
		aLink(tIndex)="../acct_tasks/gj_entry.asp?View=yes&EntryNo=" & aField4(tIndex)
	end if
	'vSubTotal=vSubTotal+cDbl(aField8(tIndex))
	vTotal=vTotal+cDbl(aField8(tIndex))
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
' get all unposted transactions
vUnPost=Request("cUnPost")
if vUnPost="Y" then
	vMark=tIndex
	uCurrent=0
	u1_30=0
	u31_60=0
	u61_90=0
	u91=0
	uTotalCurrent=0
	uTotal1_30=0
	uTotal31_60=0
	uTotal61_90=0
	uTotal91=0
	uTotal=0
	
	if vCompany=0 then
		SQL= "select a.*,b.dba_name from bill_detail a,organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.tran_date<" & DM & ToDate+1 & DM & " and a.bill_number=0 and a.vendor_number=b.org_account_number and a.item_amt>0  order by a.tran_date desc"
	else
		SQL= "select a.*,b.dba_name from bill_detail a,organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.tran_date<" & DM & ToDate+1 & DM & " and a.bill_number=0 and a.vendor_number=b.org_account_number and a.item_amt>0 and a.vendor_number=" & vCompany & " order by a.tran_date desc"
	end if
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	Do While Not rs.EOF and tIndex<Count
		aField1(tIndex)=rs("dba_name")
		aField2(tIndex)="BILL"
		aField3(tIndex)=FormatDateTime(rs("tran_date"),2)
		aField4(tIndex)=rs("invoice_no")
		'aField6(tIndex)=rs("bill_due_date")
		'aField7(tIndex)=Date-aField6(tIndex)
		aField8(tIndex)=cDbl(rs("item_amt"))
		vAging=Date-rs("tran_date")
		if vAging>0 then aField7(tIndex)=vAging
		if vAging<=0 then
			uCurrent=uCurrent+1
			uTotalCurrent=uTotalCurrent+aField8(tIndex)
		elseif vAging>0 and vAging<31 then
			u1_30=u1_30+1
			uTotal1_30=uTotal1_30+aField8(tIndex)
		elseif vAging>30 and vAging<61 then
			u31_60=u31_60+1
			uTotal31_60=uTotal31_60+aField8(tIndex)
		elseif vAging>60 And vAging<91 then
			u61_90=u61_90+1
			uTotal61_90=uTotal61_90+aField8(tIndex)
		elseif vAging>90 then
			u91=u91+1
			uTotal91=uTotal91+aField8(tIndex)
		end if
		aLink(tIndex)="../acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" & aField4(tIndex)
		uTotal=uTotal+cDbl(aField8(tIndex))
		aField8(tIndex)=FormatNumber(aField8(tIndex),2)
		tIndex=tIndex+1
		rs.MoveNext
	Loop
	rs.close
end if
uTotalCurrent=FormatNumber(uTotalCurrent,2)
uTotal1_30=FormatNumber(uTotal1_30,2)
uTotal31_60=FormatNumber(uTotal31_60,2)
uTotal61_90=FormatNumber(uTotal61_90,2)
uTotal91=FormatNumber(uTotal91,2)
uTotal=FormatNumber(uTotal,2)
'vTotal=vPostedBalance+vUnPostedBalance

'get company info
Dim aCompany(1024),aCompanyAcct(1024)
aCompany(0)="All"
aCompanyAcct(0)=0
cIndex=1
SQL= "select dba_name,org_account_number from organization where elt_account_number=" & Branch & " and is_vendor='Y' order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
Do While Not rs.EOF
	aCompany(cIndex)=rs("dba_name")
	aCompanyAcct(cIndex)=FormatNumberPlus(checkblank(rs("org_account_number"),"0"),0)
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
    <td height="20" align="left" valign="bottom" class="pageheader">A/P Report</td>
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
			      <td align="center" valign="middle"> 
                    <input type=checkbox value="Y" name="cUnPost" <% if vUnPost="Y" then response.write("checked") %> onClick="UnPostClick()">
                    <b>Include Unposted transactions</b></td>
			</tr>
			<tr>
			      <td height="20"></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">A/P 
                    AGING DETAIL REPORT</td>
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
                      <option value="<%= aCompanyAcct(i) %>" <% if FormatNumberPlus(checkblank(vCompany,"0"),0)=aCompanyAcct(i) then response.write("selected") %>><%= aCompany(i) %></option>
                      <% next %>
                    </select></td>
                </tr>
				<tr>
				  <td height="27" align="center" valign="bottom"><img src="../images/button_refresh.gif" onClick="BranchChange()"></td>
				</tr>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="77%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="24%" height="20"><strong>Company Name</strong></td>
                  <td width="13%" align="left"><strong>Type</strong></td>
                  <td width="13%" align="left"><strong>Invoice Date</strong></td>
                  <td width="13%" align="left"><strong>Reference No</strong></td>
                  <td width="13%" align="left"><strong>Due Date</strong></td>
                  <td width="9%" align="right"><strong>Aging</strong></td>
                  <td width="15%" align="right"><strong>Open Balance</strong></td>
                </tr>
          <tr>
                  <td colspan="8"><strong>POSTED TRANSACTIONS</strong></td>
		  </tr>

                <tr valign="top" bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>Current</strong></td>
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
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total Current</strong></td>
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
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=tCurrent to tCurrent+t1_30-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 1-30</strong></td>
				  <td align="right" valign="middle" ><strong><%= sTotal1_30 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="8" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>31-60</strong></td>
                </tr>
<% for i=tCurrent+t1_30 to tCurrent+t1_30+t31_60-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 31-60</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal31_60 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="7" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>61-90</strong></td>
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
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 61-90</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal61_90 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="7" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>&gt;90</strong></td>
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
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 90</strong></td>
                  <td align="right" valign="middle" ><strong><%= sTotal91 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="7" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td colspan="7" height="20" align="left" valign="top">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="7" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="7" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr valign="middle" bgcolor="D5E8CB" class="bodyheader"> 
                  <td height="20" colspan="6" align="right">TOTAL BALANCE</td>
                  <td align="right"><b><%= vTotal %></b></td>
                </tr>
<% if vUnPost="Y" then %>     
				<tr> 
                  <td height="2" colspan="8" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="D5E8CB"> 
                  <td colspan="8"><strong>UNPOSTED TRANSACTIONS</strong></td>
                </tr>
                <tr valign="top" bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>Current</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=vMark to vMark+uCurrent-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total Current</strong></td>
                  <td align="right" valign="middle" ><strong><%= uTotalCurrent %></strong></td>
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
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=vMark+uCurrent to vMark+uCurrent+u1_30-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 1-30</strong></td>
                  <td align="right" valign="middle" ><strong><%= uTotal1_30 %></strong></td>
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
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=vMark+uCurrent+u1_30 to vMark+uCurrent+u1_30+u31_60-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 31-60</strong></td>
                  <td align="right" valign="middle" ><strong><%= uTotal31_60 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="7" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>61-90</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=vMark+uCurrent+u1_30+u31_60 to vMark+uCurrent+u1_30+u31_60+u61_90-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total 61-90</strong></td>
                  <td align="right" valign="middle" ><strong><%= uTotal61_90 %></strong></td>
                </tr>
                <tr> 
                  <td colspan="7" height="1" bgcolor="89A979"></td>
                </tr>
                <tr bgcolor="ecf7f8"> 
                  <td align="left" valign="middle"><strong>>90</strong></td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                  <td align="right" valign="middle" >&nbsp;</td>
                </tr>
<% for i=vMark+uCurrent+u1_30+u31_60+u61_90 to vMark+uCurrent+u1_30+u31_60+u61_90+u91-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField2(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField3(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField4(i) %></a></td>
                  <td align="left" valign="middle"><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField6(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField7(i) %></a></td>
                  <td align="right" valign="middle" ><a href="javascript:void(viewPop2('PopWin','<%= aLink(i) %>' + '&WindowName=PopWin'));"><%= aField8(i) %></a></td>
                </tr>
<% next %>
                <tr valign="top" bgcolor="#F3f3f3"> 
                  <td colspan="6" align="right" valign="middle"><strong>Total >90</strong></td>
                  <td align="right" valign="middle" ><strong><%= uTotal91 %></strong></td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td colspan="7" height="20" align="left" valign="top">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="7" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="7" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr valign="middle" bgcolor="D5E8CB" class="bodyheader"> 
                  <td height="20" colspan="6" align="right" bgcolor="D5E8CB">TOTAL BALANCE</td>
                  <td align="right"><b><%= uTotal %></b></td>
                </tr>
<% end if %>
              </table>
              <br>

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
Sub ViewClick(BillNo)
	document.form1.action="../acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" & BillNo & "&WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub UnPostClick()
	document.form1.action="ap_aging_det.asp" & "?WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ap_aging_det.asp" & "?WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="ap_aging_det.asp" & "?WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="ap_aging_detPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
