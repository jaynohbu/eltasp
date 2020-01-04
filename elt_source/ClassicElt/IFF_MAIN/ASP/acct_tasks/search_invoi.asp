<%@ LANGUAGE = VBScript %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
<title>Search Invoices</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">

<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim qInvoiceNo(),qHAWB(),qMAWB(),qShipper(),qInvoiceDate(),qBalance()
Dim aHAWBLink(),aMAWBLink()
Dim vHAWB,vMAWB,vOrgName,vOrgAcct
Dim rs, SQL
qInvoice=Request.QueryString("qInvoice")
pNo=Request.QueryString("pNo")
if pNo="" then pNo=1
Set rs = Server.CreateObject("ADODB.Recordset")
if qInvoice="yes" then
	vInvoiceNo=Request.QueryString("InvoiceNo")
	vHAWB=Request.QueryString("HAWB")
	vMAWB=Request.QueryString("MAWB")
	vCustomer=Request.QueryString("Customer")
	vShipper=Request.QueryString("Shipper")
	vConsignee=Request.QueryString("Consignee")
	vEntryNo=Request.QueryString("EntryNo")
	qqInvoiceDate=Request.QueryString("InvoiceDate")
	qqPieces=Request.QueryString("Pieces")
	qqWeight=Request.QueryString("Weight")
	SQL="Select * from invoice where elt_account_number=" & elt_account_number
	if Not vInvoiceNo="" then
		SQL=SQL & " and invoice_no=" & vInvoiceNo
	end if
	if Not vHAWB="" then
		SQL=SQL & " and hawb_num='" & vHAWB & "'"
	end if
	if Not vMAWB="" then
		SQL=SQL & " and mawb_num='" & vMAWB & "'"
	end if
	if Not vCustomer="" then
		SQL=SQL & " and customer_name like '%" & vCustomer & "%'"
	end if
	if Not vShipper="" then
		SQL=SQL & " and shipper like '%" & vShipper & "%'"
	end if
	if Not vConsignee="" then
		SQL=SQL & " and consignee like '%" & vConsignee & "%'"
	end if
	if Not qqInvoiceDate="" then
		SQL=SQL & " and invoice_date='" & qqInvoiceDAte & "'"
	end if
	if Not qqPieces="" then
		SQL=SQL & " and total_pieces like'" & qqPieces & "%'"
	end if
	if Not qqWeight="" then
		SQL=SQL & " and total_gross_weight like '" & qqWeight & "%'"
	end if
	if Not vEntryNo="" then
		SQL=SQL & " and entry_no like '%" & vEntryNo & "%'"
	end if
	SQL=SQL & " order by invoice_no desc"
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	qIndex=0
	Count=rs.RecordCount
	Dim Pages,PageMod
	Pages=fix(Count/20)
	PageMod=Count mod 20
	if Not PageMod= 0 then Pages=Pages+1
	ReDim qInvoiceNo(Count)
	ReDim qHAWB(Count)
	ReDim qMAWB(Count)
	ReDim qShipper(Count)
	ReDim qInvoiceDate(Count)
	ReDim qBalance(Count)
	ReDim aHAWBLink(Count)
	ReDim aMAWBLink(Count)
	tIndex=0
	Do While Not rs.EOF and qIndex<20
		Do While Not rs.EOF and tIndex< (pNo-1)*20
			rs.MoveNext
			tIndex=tIndex+1
		Loop
		if Not rs.EOF then
			qInvoiceNo(qIndex)=rs("invoice_no")
			qHAWB(qIndex)=rs("hawb_num")
			qMAWB(qIndex)=rs("mawb_num")
			qShipper(qIndex)=rs("customer_name")
			qInvoiceDate(qIndex)=rs("invoice_date")
			qBalance(qIndex)=rs("balance")
			rs.MoveNext
			qIndex=qIndex+1
		end if
	Loop
	rs.Close
end if
Set rs=Nothing
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="self.focus()">

<br>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">SEARCH Invoices</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#89A979">
  <tr> 
    <td> 
	<form name=form1 method="post">
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr bgcolor="D5E8CB"> 
            <td colspan="8" height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="E7F0E2"> 
            <td width="100%" colspan="8" bgcolor="#E7F0E2" class="bodycopy"><br> <table width="73%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="89A979" bgcolor="D5E8CB" class="border1px">
                <tr align="left" valign="middle" bgcolor="E7F0E2"> 
                  <td align="left" valign="middle" class="bodycopy">&nbsp;</td>
                  <td align="left" valign="middle" class="bodyheader">Invoice# 
                  </td>
                  <td colspan="6" align="left" valign="middle" class="bodyheader"><b> 
                    <input name="txtInvoiceNo" class="shorttextfield" Value="<%= vInvoiceNo %>" size="20">
                    </b></td>
                </tr>
                <tr> 
                  <td height="1" colspan="8" align="left" valign="middle" bgcolor="89A979"></td>
                </tr>
				<tr> 
                  <td height="20" colspan="8" align="left" valign="middle" bgcolor="E7F0E2"></td>
                </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td width="2%" height="18" align="left" valign="middle">&nbsp;</td>
                  <td width="14%" align="left" valign="middle">HAWB</td>
                  <td width="20%" align="left" valign="middle"><b> 
                    <input name="txtHAWB" class="shorttextfield" Value="<%= vHAWB %>" size="20">
                    </b></td>
                  <td width="16%" align="left" valign="middle">MAWB</td>
                  <td width="20%" align="left" valign="middle"><b> 
                    <input name="txtMAWB" class="shorttextfield" Value="<%= vMAWB %>" size="20" >
                    </b></td>
                  <td width="10%" align="left" valign="middle">Customer</td>
                  <td width="18%" align="left" valign="middle"><b> 
                    <input name="txtCustomer" class="shorttextfield" Value="<%= vCustomer %>" size="20" >
                    </b></td>
                  <td width="37" align="left" valign="middle">&nbsp;</td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">Invoice Date</td>
                  <td align="left" valign="middle"><b> 
                    <input name="txtQInvoiceDate" class="shorttextfield" Value="<%= qqInvoiceDate %>" size="20" >
                    </b></td>
                  <td align="left" valign="middle">Pieces</td>
                  <td align="left" valign="middle"><b> 
                    <input name="txtQPieces" class="shorttextfield" Value="<%= qqPieces %>" size="8" >
                    </b> </td>
                  <td align="left" valign="middle">Weight</td>
                  <td align="left" valign="middle"><b> 
                    <input name="txtQWeight" class="shorttextfield" Value="<%= qqWeight %>" size="8" >
                    </b></td>
                  <td align="left" valign="middle">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">Shipper</td>
                  <td align="left" valign="middle"><b> 
                    <input name="txtShipper" class="shorttextfield" Value="<%= vShipper %>" size="20">
                    </b></td>
                  <td align="left" valign="middle">Consignee</td>
                  <td align="left" valign="middle"><b> 
                    <input name="txtConsignee" class="shorttextfield" Value="<%= vConsignee %>" size="20" >
                    </b></td>
                  <td align="left" valign="middle">Entry #</td>
                  <td width="69%"><b> 
                    <input name="txtEntryNo" class="shorttextfield" Value="<%= vEntryNo %>" size="20">
                    </b></td>
                  <td align="left" valign="middle"><img src="../images/button_go.gif" width="31" height="18" OnClick="qInvoice()"  style="cursor:hand"></td>
                </tr>
              </table>
              <br>
              <br>
              <br>
              Page 
              <% for i=1 to Pages %>
              <a href="../acct_tasks/search_invoi.asp?qInvoice=yes&pNo=<%= i %>&InvoiceNo=<%= vInvoiceNo %>&HAWB=<%= vHAWB %>&MAWB=<%= vMAWB %>&Customer=<%= vCustomer %>&Shipper=<%= vShipper %>&Consignee=<%= vConsignee %>&InvoiceDate=<%= qqInvoiceDate %>&Pieces=<%= qqPieces %>&Weight=<%= qqWeight %>&EntryNo=<%= vEntryNo %>"><%= i %></a> 
              <% next %> 
			  <a href="../acct_tasks/search_invoi.asp?qInvoice=yes&pNo=<%= pNo+1 %>&InvoiceNo=<%= vInvoiceNo %>&HAWB=<%= vHAWB %>&MAWB=<%= vMAWB %>&Customer=<%= vCustomer %>&Shipper=<%= vShipper %>&Consignee=<%= vConsignee %>&InvoiceDate=<%= qqInvoiceDate %>&Pieces=<%= qqPieces %>&Weight=<%= qqWeight %>&EntryNo=<%= vEntryNo %>">Next</a> 
            </td>
          </tr>
   <tr>
            <td height="1" colspan="8" ></td>
          </tr>
<tr align="left" valign="middle"> 
            <td width="15%" bgcolor="D5E8CB" class="bodyheader">Invoice No</td>
            <td width="15%" bgcolor="D5E8CB" class="bodyheader">HAWB/MBOL</td>
            <td width="15%" bgcolor="D5E8CB" class="bodyheader">MAWB/MBOL</td>
            <td width="23%" bgcolor="D5E8CB" class="bodyheader">Customer</td>
            <td width="15%" bgcolor="D5E8CB" class="bodyheader">Invoice Date</td>
            <td width="15%" bgcolor="D5E8CB" class="bodyheader">Balance</td>
            <td width="42" bgcolor="D5E8CB">&nbsp;</td>
  </tr>
<% for i=0 to qIndex-1 %>
  <tr align="left" valign="middle" bgcolor="#FFFFFF"> 
            <td><input name="T7" type="text" class="shorttextfield" value="<%= qInvoiceNo(i) %>" size="16"></td>
            <td><input name="T8" type="text" class="shorttextfield" value="<%= qHAWB(i) %>" size="16"></td>
            <td><input name="T9" type="text" class="shorttextfield" value="<%= qMAWB(i) %>" size="16"></td>
            <td><input name="T10" type="text" class="shorttextfield" value="<%= qShipper(i) %>" size="28"></td>
            <td><input name="T11" type="text" class="shorttextfield" value="<%= qInvoiceDAte(i) %>" size="12"></td>
            <td><input name="T12" type="text" class="shorttextfield" value="<%= qBalance(i) %>" size="16"></td>
            <td><img src="../images/button_edit.gif" width="38" height="18" OnClick="GoEdit(<%= qInvoiceNo(i) %>)" name="B2"  style="cursor:hand"></td>
  </tr>
<% next %>
  <tr align="left" valign="middle" bgcolor="E7F0E2"> 
            <td height="20" colspan="8" align="left" valign="middle" class="bodycopy">Page 
<% for i=1 to Pages %>
	<a href="../acct_tasks/search_invoi.asp?qInvoice=yes&pNo=<%= i %>&InvoiceNo=<%= vInvoiceNo %>&HAWB=<%= vHAWB %>&MAWB=<%= vMAWB %>&Customer=<%= vCustomer %>&Shipper=<%= vShipper %>&Consignee=<%= vConsignee %>&InvoiceDate=<%= qqInvoiceDate %>&Pieces=<%= qqPieces %>&Weight=<%= qqWeight %>&EntryNo=<%= vEntryNo %>"><%= i %></a>
<% next %>
            <a href="../acct_tasks/search_invoi.asp?qInvoice=yes&pNo=<%= pNo+1 %>&InvoiceNo=<%= vInvoiceNo %>&HAWB=<%= vHAWB %>&MAWB=<%= vMAWB %>&Customer=<%= vCustomer %>&Shipper=<%= vShipper %>&Consignee=<%= vConsignee %>&InvoiceDate=<%= qqInvoiceDate %>&Pieces=<%= qqPieces %>&Weight=<%= qqWeight %>&EntryNo=<%= vEntryNo %>">Next</a> 
            </td>
  </tr>
          <tr align="left" valign="middle" bgcolor="D5E8CB"> 
            <td height="22" colspan="8" align="left" valign="middle" class="bodycopy">&nbsp;</td>
  </tr>
        </table>
	    </form></td>
  </tr>
</table>

<br>
</body>
<script language="VBScript">
<!--
Sub GoNew(OrgInfo)
	document.form1.action="search_invoi.asp?new=yes" & OrgInfo & "&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target="_self"
	form1.submit()
End Sub

Sub qInvoice()
InvoiceNo=document.form1.txtInvoiceNo.Value
HAWB=document.form1.txtHAWB.Value
MAWB=document.form1.txtMAWB.Value
Customer=document.form1.txtCustomer.Value
Shipper=document.form1.txtShipper.Value
Consignee=document.form1.txtConsignee.Value
qInvoiceDate=document.form1.txtQInvoiceDate.Value
Pieces=document.form1.txtQPieces.Value
Weight=document.form1.txtQWeight.Value
EntryNo=document.form1.txtEntryNo.Value

if Not qInvoiceDate="" and Not IsDAte(qInvoiceDAte) then
	MsgBox "Please enter the correct invoice date (mm/dd/yyyy)"
elseif Not InvoiceNo="" and Not IsNumeric(InvoiceNo) then
	MsgBox "Please enter a numeric number for the invoice no!"
elseif Not Pieces="" and Not IsNumeric(Pieces) then
	MsgBox "Please enter a numeric number for the Pieses!"
elseif Not Weight="" and Not IsNumeric(Weight) then
	MsgBox "Please enter a numeric number for the Weight!"
else
	document.form1.action="search_invoi.asp?qInvoice=yes&InvoiceNo=" & InvoiceNo & "&HAWB=" & HAWB & "&MAWB=" & MAWB & "&Customer=" & Customer & "&Shipper=" & Shipper & "&Consignee=" & Consignee & "&InvoiceDate=" & qInvoiceDate & "&Pieces=" & Pieces & "&Weight=" & Weight & "&EntryNo=" & EntryNo & "&WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub

Sub GoEdit(InvoiceNo)
	document.form1.action="edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo & "&WindowName=" & window.name
	Document.form1.target="_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
