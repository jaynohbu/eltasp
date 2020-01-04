<%@LANGUAGE="VBSCRIPT"%>

<html>
<head>
<title>A/R Aging Summary</title>
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
		SQL= "select * from invoice where elt_account_number = " & Branch & " and invoice_date<" & DM & ToDate+1 & DM & " and invoice_type='I' and balance>0 and pay_status='A' order by customer_name,invoice_date+term_curr desc"
	else
		SQL= "select * from invoice where elt_account_number = " & Branch & " and invoice_date<" & DM & ToDate+1 & DM & " and invoice_type='I' and balance>0 and pay_status='A' and customer_number=" & vCompany & " order by invoice_date+term_curr desc"
	end if
else
	SQL= "select * from invoice where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and invoice_date<" & DM & ToDate+1 & DM & " and invoice_type='I' and balance>0 and pay_status='A' order by customer_name,invoice_date+term_curr desc"
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
sTotal=0
vTotalCurrent=0
vTotal1_30=0
vTotal31_60=0
vTotal61_90=0
vTotal91=0
vTotal=0
if Not rs.EOF then
	vLastName=rs("customer_name")
end if
tIndex=1
Do While Not rs.EOF And tIndex<Count
	cName=rs("customer_name")
	if Not cName=vLastName then
		aField1(tIndex-1)=vLastName
		aField2(tIndex-1)=FormatNumber(sTotalCurrent,2)
		aField3(tIndex-1)=FormatNumber(sTotal1_30,2)
		aField4(tIndex-1)=FormatNumber(sTotal31_60,2)
		aField5(tIndex-1)=FormatNumber(sTotal61_90,2)
		aField6(tIndex-1)=FormatNumber(sTotal91,2)
		aField7(tIndex-1)=FormatNumber(sTotal,2)
		vLastName=cName
		tIndex=tIndex+1
		sTotalCurrent=0
		sTotal1_30=0
		sTotal31_60=0
		sTotal61_90=0
		sTotal91=0
		sTotal=0
	end if
	vInvoiceType=rs("invoice_type")
	vTerm=rs("term_curr")
	vInvoiceDate=rs("invoice_date")
	vBalance=cDbl(rs("balance"))
	vAging=Date-(vInvoiceDate+vTerm)
	if vAging<=0 then
		sTotalCurrent=sTotalCurrent+vBalance
		sTotal=sTotal+vBalance
		vTotalCurrent=vTotalCurrent+vBalance
	elseif vAging>0 and vAging<31 then
		sTotal1_30=sTotal1_30+vBalance
		sTotal=sTotal+vBalance
		vTotal1_30=vTotal1_30+vBalance
	elseif vAging>30 and vAging<61 then
		sTotal31_60=sTotal31_60+vBalance
		sTotal=sTotal+vBalance
		vTotal31_60=vTotal31_60+vBalance
	elseif vAging>60 And vAging<91 then
		sTotal61_90=sTotal61_90+vBalance
		sTotal=sTotal+vBalance
		vTotal61_90=vTotal61_90+vBalance
	elseif vAging>90 then
		sTotal91=sTotal91+vBalance
		sTotal=sTotal+vBalance
		vTotal91=vTotal91+vBalance
	end if
	rs.MoveNext
Loop
aField1(tIndex-1)=cName
aField2(tIndex-1)=FormatNumber(sTotalCurrent,2)
aField3(tIndex-1)=FormatNumber(sTotal1_30,2)
aField4(tIndex-1)=FormatNumber(sTotal31_60,2)
aField5(tIndex-1)=FormatNumber(sTotal61_90,2)
aField6(tIndex-1)=FormatNumber(sTotal91,2)
aField7(tIndex-1)=FormatNumber(sTotal,2)
rs.Close
vTotal=vTotalCurrent+vTotal1_30+vTotal31_60+vTotal61_90+vTotal91
vTotalCurrent=FormatNumber(vTotalCurrent,2)
vTotal1_30=FormatNumber(vTotal1_30,2)
vTotal31_60=FormatNumber(vTotal31_60,2)
vTotal61_90=FormatNumber(vTotal61_90,2)
vTotal91=FormatNumber(vTotal91,2)
vTotal=FormatNumber(vTotal,2)
'get company info
Dim aCompany(10000),aCompanyAcct(10000)
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
rs.close
Set rs=Nothing

%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">A/R Aging 
      Summary </td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
      <!--  #INCLUDE FILE="../include/calendar2.htm" -->
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
                  <td height="29" align="center" valign="middle" class="bodyheader">A/R 
                    AGING SUMMARY</td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong>As 
                    of <%= FormatDateTime(ToDate,1) %></strong></td>
                </tr>
                <% if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% end if %>
                <tr> 
                  <td align="center" valign="middle"><strong>Company</strong> &nbsp; 
                    <select name=lstCompany size=1 class="smallselect" style="width:180">
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

			  <table width="74%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="26%" height="20"><strong>Comapny Name</strong></td>
                  <td width="9%" align="right"><strong>Current</strong></td>
                  <td width="13%" align="right"><strong>1-30</strong></td>
                  <td width="13%" align="right"><strong>31-60</strong></td>
                  <td width="13%" align="right"><strong>61-90</strong></td>
                  <td width="13%" align="right"><strong>&gt;90</strong></td>
                  <td width="13%" align="right"><strong>Total</strong></td>
                </tr>
<% for i=0 to tIndex-1 %>				
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="right" valign="middle"><%= aField2(i) %></td>
                  <td align="right" valign="middle"><%= aField3(i) %></td>
                  <td align="right" valign="middle"><%= aField4(i) %></td>
                  <td align="right" valign="middle"><%= aField5(i) %></td>
                  <td align="right" valign="middle"><%= aField6(i) %></td>
                  <td align="right" valign="middle" ><%= aField7(i) %></td>
                </tr>
<% next %>
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
                  <td height="20" align="right"><strong>TOTAL</strong></td>
                  <td align="right"><b><%= vTotalCurrent %></b></td>
                  <td align="right"><b><%= vTotal1_30 %></b></td>
                  <td align="right"><b><%= vTotal31_60 %></b></td>
                  <td align="right"><b><%= vTotal61_90 %></b></td>
                  <td align="right"><b><%= vTotal91 %></b></td>
                  <td align="right"><b><%= vTotal %></b></td>
                </tr>
                <tr> 
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
</table>  </form>
<br>

</body>
<script language="VBScript">
<!--

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="ar_aging_summPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ar_aging_summ.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="ar_aging_summ.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
