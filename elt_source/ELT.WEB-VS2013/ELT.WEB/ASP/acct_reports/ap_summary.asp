<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>A/P Summary</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PrintFormat.htm" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/getDates.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2()
Branch=Request("lstBranch")
if Branch="" then Branch=elt_account_number
Set rs = Server.CreateObject("ADODB.Recordset")
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
SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_account_type='Accounts Payable'"
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
vAPAcct=""
Do While Not rs.EOF
	if Not vAPAcct="" then vAPAcct=vAPAcct & ","
	vAPAcct=vAPAcct & rs("gl_account_number")
	rs.MoveNext
Loop
rs.close
if vAPAcct="" then vAPAcct=0
if Not Branch=0 then
	SQL= "select customer_name,(sum(debit_amount)+sum(credit_amount)) as total from all_accounts_journal where elt_account_number = " & Branch & " and gl_account_number in (" & vAPAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') and customer_name<>'' group by customer_name order by customer_name"
else
	SQL= "select * from all_accounts_journal where Left(elt_account_number,5) = " & Left(elt_account_number,5) & " and gl_account_number in (" & vAPAcct & ") and (tran_date between " & DM & FromDate & DM & " and " & DM & ToDate+1 & DM & " or tran_type='INIT') order by elt_account_number,customer_name,tran_date,tran_seq_num"
end if

rs.Open SQL, eltConn, adOpenStatic, , adCmdText

tIndex=0
'rs.MoveLast
Count=rs.RecordCount+1000
ReDim aField1(Count)
ReDim aField2(Count)
vTotalBal=0
Do While Not rs.EOF and tIndex<Count
	vBal=cDbl(rs("total"))
	if Not vBal=0 then
		aField2(tIndex)=FormatNumber(vBal,2)
		aField1(tIndex)=rs("customer_name")
		vTotalBal=vTotalBal+vBal
		tIndex=tIndex+1
	end if
	rs.MoveNext
Loop
rs.Close

vTotalBal=FormatNumber(vTotalBal,2)
Set rs=Nothing

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">

<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">Accounts Payable 
      Summary </td>
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
			<td align="right"><img src="../images/button_print_medium.gif" name="bPrint" width="52" height="18" onClick="PrintReport()" ></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">ACCOUNTS 
                    PAYABLE SUMMARY</td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong>As 
                    of <%= FormatDateTime(ToDate,1) %></strong></td>
                </tr>
                <% if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% end if %>
				<tr>
				  <td height="27" align="center" valign="bottom"><img src="../images/button_go.gif" onClick="GoClick()"></td>
				</tr>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="30%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="26%" height="20" bgcolor="D5E8CB"><strong>Account 
                    Name</strong></td>
                  <td width="9%" align="right"><strong>Balance</strong></td>
                </tr>
<% for i=0 to tIndex-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="right" valign="middle"><%= aField2(i) %></td>
                </tr>
<% next %>
				<tr bgcolor="f3f3f3"> 
                  <td colspan="2" height="20">&nbsp;</td>
				</tr>
                 <tr> 
                  <td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
				<tr> 
                  <td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
				<tr bgcolor="D5E8CB"> 
                  <td height="20" align="right" valign="middle"><strong>TOTAL</strong></td>
                  <td align="right" valign="middle"><strong><%= vTotalBal %></strong></td>
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
</table></form>
<br>

</body>
<script language="VBScript">
<!--
Sub BranchChange()
	document.form1.action="ap_summary.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="ap_summary.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end if
End Sub
Sub GoClick()
'	FromDate=document.form1.txtFromDate.Value
'	if Not IsDate(FromDate) then
'		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
'		exit Sub
'	end if
'	ToDate=document.form1.txtToDate.Value
'	if Not IsDate(ToDate) then
'		MsgBox "Please enter DATE in (MM/DD/YYYY) format!"
'		exit Sub
'	end if
	document.form1.action="ap_summary.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
End Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="ap_summaryPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
