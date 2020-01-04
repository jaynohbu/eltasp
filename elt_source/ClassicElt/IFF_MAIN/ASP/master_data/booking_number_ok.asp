<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>MAWB Number Creation</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<%
Dim vMAWB, vCarrier,vCarrierDesc
Dim Go
Dim MAWBNUM(102),errMsg(102),errIndex

Dim rs, SQL

Go=Request.QueryString("Go")

Set rs = Server.CreateObject("ADODB.Recordset")
if Go="yes" then
	vStartNo=Request("txtStart")
	vEndNo=Request("txtEnd")
	vCarrierDesc=Request("txtCarrierDesc")
	CarrierInfo=Request("lstCarrier")
	pos=0
	pos=instr(CarrierInfo,"-")
	if pos>0 then
		vCarrier=Left(CarrierInfo,pos-1)
		vSCAC=Mid(CarrierInfo,pos+1,200)
	end if

	check=CInt(Mid(vStartNo,8,1))
	StartNo=CLng(Mid(vStartNo,1,7))
	EndNo=CLng(Mid(vEndNo,1,7))
	errIndex = 1
	
	DIM tmpI 
	
	for i=StartNo To EndNo
		
		tmpI = i
		
		if LEN(tmpI) < 7 then			
			for j=0 to 6
				if LEN(tmpI) < 7 then
					tmpI = "0" & tmpI					
				else
					exit for
				end if
			next			
		end if
		
	
		vMAWBTemp=vCarrier & "-" & mid(tmpI,1,4) & " " & mid(tmpI,5,3) & check
		
			
		SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and mawb_no='" & vMAWBTemp & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		MAWBNUM(errIndex) = vMAWBTemp

		if rs.EOF then
			rs.AddNew
			rs("elt_account_number") = elt_account_number
			rs("mawb_no") = vCarrier & "-" & mid(tmpI,1,4) & " " & mid(tmpI,5,3) & check
			rs("Carrier_Code")=vCarrier
			rs("Carrier_Desc")=vCarrierDesc
			rs("scac")=vSCAC
			rs("status")="A"
			rs("used")="N"
			rs("created_date")=date
			rs("is_dome") = ""
            rs("master_type") = ""
			rs.Update
			errMsg(errIndex) = "Successfully be created."
		else
			errMsg(errIndex) = "error : Already exists."			
		end if
		rs.Close
		errIndex = errIndex + 1
		check=check+1
		if check=7 then check=0
	next	
	
end if

Set rs=Nothing
%>

<!--  #INCLUDE FILE="../include/recent_file.asp" -->

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

 <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">MAWB No. Creation</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6" bgcolor="#73beb6" class="border1px">
  <tr bgcolor="ccebed">
    <td width="2" height="8" align="left" valign="top" bgcolor="ccebed"></td>
  </tr>
  <tr bgcolor="73beb6">
    <td height="1" align="left" valign="top"></td>
  </tr>
  <tr align="left" bgcolor="ecf7f8">
    <td height="22" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
<table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6" bgcolor="#FFFFFF" class="border1px">
  <tr bgcolor="#CCCCCC">
    <td width="2%">&nbsp;</td>
    <td width="32%" height="20" align="center"><strong>MAWB Number </strong></td>
    <td width="66%" align="center"><strong>Message</strong></td>
  </tr>
  
<% 	for i=1 To errIndex-1 %>
	
	<% pos = 0
	   pos = instr(errMsg(i),"Successfully")
	%>
	<% 
	 tmpMod = i mod 2
	%>	

	<% if tmpMod = 1 then  %>
		<tr bgcolor="f3f3f3"> 
	<% else  %>
		<tr> 
	<% end if %>
	
	<% if pos <= 0 then %>
		<td width="2%"><font color="#FF0000"><% response.write i %></font></td>
		<td width="32%" align="center"><font color="#FF0000"><strong><% response.write MAWBNUM(i) %></strong></font></td>
		<td width="66%" height="20" align="center"><font color="#FF0000"><% response.write errMsg(i) %></font></td>
		</tr>
	<% else %>	
		<td width="2%"><% response.write i %></td>
		<td width="32%" align="center"><% response.write MAWBNUM(i) %></td>
		<td width="66%" height="20" align="center"><% response.write errMsg(i) %></td>
		</tr>
	<% end if %>
	
<% next  %>

</table></td>
  </tr>
  <tr bgcolor="73beb6">
    <td height="1" align="left" valign="top"></td>
  </tr>
  <tr align="center" bgcolor="ccebed">
    <td height="2" valign="middle" class="bodycopy"><input name="CloseMe" type="button" class="formbody" onClick="javascript:window.close();" value="Close"></td>
  </tr>
</table>

</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
