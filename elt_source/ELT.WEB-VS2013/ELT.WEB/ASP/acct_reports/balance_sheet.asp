<%@LANGUAGE="VBSCRIPT"%>

<html>
<head>
<title>Income Statement</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aAsset(128),aAssetName(128),aLiability(128),aLiabilityName(128)
Branch=Request("lstBranch")
if Detail="" then Summary="Y"
if Branch="" then Branch=elt_account_number
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

'get all Asset Accounts from gl
'SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and gl_master_type='ASSET' order by gl_account_number"
'rs.Open SQL, eltConn, adOpenStatic, , adCmdText
'vAssetAcct=""
'Do While Not rs.EOF
'	if Not vAssetAcct="" then vAssetAcct=vAssetAcct & ","
'	vAssetAcct=vAssetAcct & rs("gl_account_number")
'	rs.MoveNext
'Loop
'rs.close
ToDate=Request("txtToDate")
if ToDate="" then ToDate=Date
ToDate=CDate(ToDate)
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
if Not Branch=0 then
	SQL= "select a.gl_account_name,sum(a.debit_amount+a.credit_amount) as amount,b.gl_master_type,b.gl_begin_balance from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & Branch & " and a.gl_account_number=b.gl_account_number and a.tran_date < " & DM & ToDate+1 & DM & " group by a.gl_account_number,a.gl_account_name,b.gl_master_type,b.gl_begin_balance"
else
	SQL= "select a.gl_account_name,sum(a.debit_amount+a.credit_amount) as amount,b.gl_master_type,b.gl_begin_balance from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number and Left(a.elt_account_number,5) = " & Left(elt_account_number,5) & " and a.gl_account_number=b.gl_account_number and a.tran_date < " & DM & ToDate+1 & DM & " group by a.gl_account_number,a.gl_account_name,b.gl_master_type,b.gl_begin_balance order by a.gl_account_name"
end if
rs.Open SQL, eltConn, adOpenStatic, , adCmdText
aIndex=0
aSubTotal=0
lIndex=0
lSubTotal=0
eIndex=0
eSubTotal=0
vRevenue=0
vExpense=0
bBalance=0
Do While Not rs.EOF
	vType=rs("gl_master_type")
	Amount=cDbl(rs("amount"))
	bBalance=cDbl(rs("gl_begin_balance"))
	Amount=Amount+bBalance
	if vType="ASSET" then
		aAsset(aIndex)=Amount
		aSubTotal=aSubTotal+Amount
		aAssetName(aIndex)=rs("gl_account_name")
		aIndex=aIndex+1
	elseif vType="LIABILITY" then
		aLiability(lIndex)=-Amount
		lSubTotal=lSubTotal-Amount
		aLiabilityName(lIndex)=rs("gl_account_name")
		lIndex=lIndex+1
	elseif vType="REVENUE" then
		vRevenue=vRevenue-amount
	elseif vType="EXPENSE" then
		vExpense=vExpense+amount
	end if
	rs.MoveNext
Loop
rs.Close
NetIncome=vRevenue-vExpense
TotalLE=lSubTotal+NetIncome
'response.write lSubTotal
Set rs=Nothing
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">


<form name=form1>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">Balance Sheet</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
        <!--  #INCLUDE FILE="../include/OneCal.htm" -->
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
                  <td height="29" align="center" valign="middle" class="bodyheader">Balance 
                    Sheet </td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"> 
                    AS of <strong><%= FormatDateTime(ToDate,1) %></strong></td>
                </tr>
                <% 'if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% 'end if %>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  <table width="35%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="70%" height="20" bgcolor="D5E8CB"><strong>ASSETS</strong></td>
                  <td width="30%" bgcolor="D5E8CB">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong>Current Assets</strong></td>
                  <td>&nbsp;</td>
                </tr>
                <% for i=0 to aIndex-1 %>
                <tr align="left" valign="middle" bgcolor="#F3f3f3"> 
                  <td><%= aAssetName(i) %></td>
                  <td align="right"><%= FormatCurrency(aAsset(i)) %></td>
                </tr>
                <% next %>
                <tr align="left" valign="middle" bgcolor="#F3f3f3"> 
                  <td align="right"><strong>Total Current Assets</strong></td>
                  <td align="right"><b><%= FormatCurrency(aSubTotal) %></b></td>
                </tr>
				<tr>
				<td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                <td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
				<tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20"><strong>TOTAL ASSETS</strong></td>
                  <td align="right"><b><%= FormatCurrency(aSubTotal) %></b></td>
                </tr>
				<tr bgcolor="f3f3f3"> 
                  <td height="2" colspan="2" bgcolor="89A979"> </td>
				</tr>
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20"><strong>LIABILITIES &amp; EQUITY</strong></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong>Liabilities</strong></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td ><p class="numberindent"><strong>Current Liabilities</strong></p></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <% for i=0 to lIndex-1 %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td><p class="numberindent"><%= aLiabilityName(i) %></p></td>
                  <td align="right"><%= FormatCurrency(aLiability(i)) %></td>
                </tr>
                <% next %>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Current Liabilities</strong></td>
                  <td align="right"><b><%= FormatCurrency(lSubTotal) %></b></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Liabilities</strong></td>
                  <td align="right"><b><%= FormatCurrency(lSubTotal) %></b></td>
                </tr>
                <tr> 
                <td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
			    <tr align="left" valign="middle" bgcolor="ecf7f8"> 
                  <td><strong>Equity</strong></td>
                  <td align="right">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td class="bodycopy"><p class="numberindent"><strong>Net Income</strong></p></td>
                  <td align="right"><%= FormatCurrency(NetIncome) %></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="f3f3f3"> 
                  <td align="right"><strong>Total Equity</strong></td>
                  <td align="right"><%= FormatCurrency(NetIncome) %></td>
                </tr>
				<tr>
				<td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                <td height="1" colspan="2" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td height="20"><strong>TOTAL LIABILITIES &amp; EQUITY</strong></td>
                  <td align="right"><b><%= FormatCurrency(TotalLE) %></b></td>
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
<script language="vbscript">
<!---
Sub BranchChange()
	document.form1.action="balance_sheet.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="_self"
	form1.submit()
end Sub
Sub key()
if Window.event.Keycode=13 then
//	MsgBox document.form1.txtToDate.Value	
	document.form1.action="balance_sheet.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
    document.form1.target="_self"

	form1.submit()
end if
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="balance_sheetPrint.asp" & "?WindowName=" & window.name
	document.form1.target="popUpWindow"
	document.form1.method="POST"
	form1.submit()
End Sub

--->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
