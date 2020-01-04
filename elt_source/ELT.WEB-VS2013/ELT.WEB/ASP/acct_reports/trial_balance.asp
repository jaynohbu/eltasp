<%@LANGUAGE="VBSCRIPT"%>
<html>
<head>
<title>Trial Balance</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim rs, SQL
Dim aField1(),aField2(),aField3(),aField4(),aField5()
Branch=Request("lstBranch")
Summary=Request("cSummary")
Detail=Request("cDetail")
if Detail="" then Summary="Y"
if Branch="" then Branch=elt_account_number
'get date
ToDate=Request("txtToDate")
if ToDate="" then ToDate=Date
ToDate=CDate(ToDate)
myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
Set rs = Server.CreateObject("ADODB.Recordset")
if Not Branch=0 then
	SQL= "select dba_name from agent where elt_account_number = " & Branch
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		vOrgName=rs("dba_name")
	end if
	rs.close
'SQL= "select * from gl where elt_account_number = " & elt_account_number & " order by gl_account_number"
	SQL= "select a.gl_account_number,b.gl_account_type,b.gl_account_desc,sum(a.credit_amount+a.debit_amount) as gl_account_balance from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & Branch & " and a.gl_account_number=b.gl_account_number and a.tran_date<" & DM & ToDate+1 & DM  & " group by a.gl_account_number,b.gl_account_type,b.gl_account_desc"
else
	if Summary="Y" then
		SQL= "select a.gl_account_number,b.gl_account_type,b.gl_account_desc,sum(a.credit_amount+a.debit_amount) as gl_account_balance from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and Left(a.elt_account_number,5) = " & Left(elt_account_number,5) & " and a.gl_account_number=b.gl_account_number and a.tran_date<" & DM & ToDate+1 & DM  & " group by a.gl_account_number,b.gl_account_type,b.gl_account_desc"
	else
		SQL= "select a.gl_account_number,a.elt_account_number,b.gl_account_type,b.gl_account_desc,sum(a.credit_amount+a.debit_amount) as gl_account_balance from all_accounts_journal a,gl b where a.elt_account_number=b.elt_account_number and Left(a.elt_account_number,5) = " & Left(elt_account_number,5) & " and a.gl_account_number=b.gl_account_number and a.tran_date<" & DM & ToDate+1 & DM  & " group by a.gl_account_number,a.elt_account_number,b.gl_account_type,b.gl_account_desc order by a.gl_account_number,a.elt_account_number"
	end if
end if

rs.Open SQL, eltConn, adOpenStatic, , adCmdText
tIndex=0
'rs.MoveLast
Count=rs.RecordCount+100
ReDim aField1(Count)
ReDim aField2(Count)
ReDim aField3(Count)
ReDim aField4(Count)
ReDim aField5(Count)
vTotalBalance=0
LastGL=0
vSubTotal=0
Do While Not rs.EOF
	aField1(tIndex)=rs("gl_account_number")
	CurrGL=cLng(aField1(tIndex))
	aField2(tIndex)=rs("gl_account_type")
	aField3(tIndex)=rs("gl_account_desc")
	aField4(tIndex)=cDbl(rs("gl_account_balance"))
	if Detail="Y" and Branch=0 then
		aField5(tIndex)=rs("elt_account_number")
		if LastGL=CurrGL then
			aField1(tIndex)=""
			aField2(tIndex)=""
			aField3(tIndex)=""
			vSubTotal=vSubTotal+aField4(tIndex)
		elseif Not tIndex=0 And Not LastGL=CurrGL then
			aField1(tIndex)=""
			aField2(tIndex)=""
			aField3(tIndex)=""
			aField5(tIndex)="Sub Total"
			aField4(tIndex)=vSubTotal
			tIndex=tIndex+1
			aField1(tIndex)=rs("gl_account_number")
			aField2(tIndex)=rs("gl_account_type")
			aField3(tIndex)=rs("gl_account_desc")
			aField4(tIndex)=cDbl(rs("gl_account_balance"))
			aField5(tIndex)=rs("elt_account_number")
			vSubTotal=aField4(tIndex)
		else
			vSubTotal=vSubTotal+aField4(tIndex)
		end if
		LastGL=CurrGL
	end if
	vTotalBalance=FormatNumber(vTotalBalance + cDbl(aField4(tIndex)),2)
	tIndex=tIndex+1
	rs.MoveNext
Loop
if Detail="Y" and Branch=0 then
	aField5(tIndex)="Sub Total"
	aField4(tIndex)=vSubTotal
	tIndex=tIndex+1
end if
rs.Close
Set rs=Nothing

%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">

<form name=form1 method="post">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="20" align="left" valign="bottom" class="pageheader">Trial Balance</td>
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

			<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
			<td align="right"><img src="../images/button_print_medium.gif" name="bPrint" width="52" height="18" onClick="PrintReport()" ></td>
			</tr>
                <tr> 
                  <td align="center" valign="middle" class="reportheader"><%= vOrgName %></td>
                </tr>
                <tr> 
                  <td height="29" align="center" valign="middle" class="bodyheader">TRIAL 
                    BALANCE </td>
                </tr>
                <tr> 
                  <td height="22" align="center" valign="middle" class="bodycopy"><strong>As 
                    of <%= FormatDateTime(ToDate,1) %></strong></td>
                </tr>
                <% if UserRight=9 then %>
                <!--  #INCLUDE FILE="../include/branch.asp" -->
                <% end if %>
                <tr> 
                  <td align="center" valign="middle">
                    <input type=checkbox name="cSummary" value="Y" <% if Summary="Y" then response.write("checked") %> onClick="SummaryClick()">
                    <strong>Summary &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    <input type=checkbox name="cDetail" value="Y" <% if Detail="Y" then response.write("checked") %> onClick="DetailClick()">
                    Detail</strong></td>
                </tr>
                <tr>
                  <td height="24">&nbsp;</td>
                </tr>
              </table>

			  
            <table width="70%" border="0" align="center" cellpadding="2" cellspacing="2" class="bodycopy">
              <tr align="left" valign="middle" bgcolor="D5E8CB"> 
                  <td width="15%" height="20"><strong>Account Number</strong></td>
                  <td width="20" align="left"><strong>Account Type</strong></td>
                  <td width="25%" align="left"><strong>Account Description</strong></td>
<% if Detail="Y" And Branch=0 then %>
                  <td width="20%" align="left" bgcolor="D5E8CB"><strong>Branch</strong></td>
<% end if %>				  
                  <td width="20%" align="left"><strong>Account Balance</strong></td>
                </tr>
<% for i=0 to tIndex-1 %>
                <tr valign="top" bgcolor="f3f3f3"> 
                  <td align="left" valign="middle"><%= aField1(i) %></td>
                  <td align="left" valign="middle"><%= aField2(i) %></td>
                  <td align="left" valign="middle"><%= aField3(i) %></td>
				  <% if Detail="Y" And Branch=0 then %>
                  <% if aField5(i)="Sub Total" then %>
                  <td align="left" valign="middle"><%= aField5(i) %></td>
				  <% else %>
                  <td align="right" valign="middle"><%= aField5(i) %></td>
				  <% end if %>
                  <% end if %>
                  
                <td width="1" align="right" valign="middle" bgcolor="#F3f3f3"><%= FormatNumber(aField4(i),2) %></td>
                </tr>
<% next %>
                <tr bgcolor="f3f3f3"> 
                  <td colspan="5" height="20" align="left" valign="top">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="5" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="5" align="left" valign="middle" bgcolor="#89A979"></td>
                </tr>
                <tr valign="middle" bgcolor="D5E8CB" class="bodyheader">
				  <td bgcolor="D5E8CB"></td> 
				  <td bgcolor="D5E8CB"></td>
<% if Detail="Y" And Branch=0 then %> 
				  <td align="left" bgcolor="D5E8CB"></td> 
<% end if %>                 
				  <td height="20" align="right" bgcolor="D5E8CB">TOTAL BALANCE</td>
                  <td align="right" bgcolor="D5E8CB"><b><%= vTotalBalance %></b></td>
                </tr>
                <tr> 
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
</table></form><br>

</body>
<script language="VBScript">
<!--
Sub key()
if Window.event.Keycode=13 then
	document.form1.action="trial_balance.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub BranchChange()
	document.form1.action="trial_balance.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end Sub
Sub DetailClick()
if document.form1.cSummary.checked=True then
	document.form1.cSummary.checked=False
	document.form1.cDetail.checked=True
else
	document.form1.cSummary.checked=True
	document.form1.cDetail.checked=False
end if
	document.form1.action="trial_balance.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub SummaryClick()
if document.form1.cDetail.checked=True then
	document.form1.cSummary.checked=True
	document.form1.cDetail.checked=False
else
	document.form1.cSummary.checked=False
	document.form1.cDetail.checked=True
end if
	document.form1.action="trial_balance.asp" & "?WindowName=" & window.name
	document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub

Sub PrintReport()
	jPopUpNormal()
	document.form1.action="trial_balancePrint.asp" & "?WindowName=" & window.name
	document.form1.method="POST"
	document.form1.target="popUpWindow"
	form1.submit()
End Sub

-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
