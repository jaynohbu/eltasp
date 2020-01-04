<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Additional Contact Information</title>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language='javascript'>
	window.name = 'AddContact';
</script>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>		

</head>
<!--  #INCLUDE FILE="../include/header.asp" -->


<%
Dim rs, SQL,add,delete,update,vOrgNum,vOrgName,Start,vMask,tIndex
DIM aName(),aJobTitle(),aPhone(),aExt(),aCellPhone(),aFax(),aEmail(),aRemarks(),aItemNo()

Start = Request.QueryString("Start")

if Start = "yes" then
	vOrgNum = Request.QueryString("Num")
	vOrgName = Request.QueryString("Name")
'	vMask = Request.QueryString("Mask")
	vMask = ""
else
	vOrgNum = Request("hOrgNum")
	vOrgName = Request("hOrgName")
'	vMask = Request("hMask")	
	vMask = ""
end if

add=Request.QueryString("add")
delete=Request.QueryString("delete")
update=Request.QueryString("update")

if add = "yes" then
	call add_contact
end if
if delete = "yes" then
	dnum=Request.QueryString("item")
	call delete_contact( dnum )
end if
if update = "yes" then
	unum=Request.QueryString("item")
	call update_contact( unum )
end if

call load_contact_info
Set rs=Nothing

%>

<%
Sub add_contact
DIM vName,vJobTitle,vPhone,vExt,vCell,vFax,vEmail,vMemo,tmpItemNo
	
	Set rs = Server.CreateObject("ADODB.Recordset")
	
	vName=Request("txtName")
	vJobTitle=Request("txtJobTitle")
	vPhone=Request("txtPhone")
	vExt=Request("txtExt")
	vCell=Request("txtCell")
	vFax=Request("txtFax")
	vEmail=Request("txtEmail")
	vMemo=Request("txtRemarks")
	
	SQL= "select max(item_no) as tmpI from ig_org_contact where elt_account_number = " & elt_account_number  & " and " & " org_account_number = " & vOrgNum 
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs.EOF And IsNull(rs("tmpI"))=False Then
		tmpItemNo = CLng(rs("tmpI")) + 1
	Else
		tmpItemNo=1
	End If
	rs.Close	
	
	rs.Open "ig_org_contact", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	rs.AddNew
	
	rs("elt_account_number") = elt_account_number
	rs("org_account_number") = vOrgNum
	rs("item_no") = tmpItemNo
	rs("name") = vName
	rs("job_title") = vJobTitle
	rs("phone")  = vPhone
	rs("phoneExt")  = vExt
	rs("fax") = vFax
	rs("cellPhone")  = vCell
	rs("email") = vEmail
	rs("remark") = vMemo	
	rs("editedby") = login_name
	rs("date") = date()	
	rs.Update
	rs.Close	


end sub
%>

<%
Sub update_contact( num )
DIM vName,vJobTitle,vPhone,vExt,vCell,vFax,vEmail,vMemo,tmpItemNo

vName = Request("ContactName" & num)
vJobTitle=Request("ContactJobTitle" & num)
vPhone=Request("ContactPhone" & num)
vExt=Request("PhoneExt" & num)
vCell=Request("CellPhone" & num)
vFax=Request("ContactFax" & num)
vEmail=Request("Email" & num)
vMemo=Request("Remarks" & num)
tmpItemNo=Request("ContactItemNo" & num)

	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select * from ig_org_contact where elt_account_number = " & elt_account_number & " and " & " org_account_number = " & vOrgNum & " and item_no = " & tmpItemNo
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if Not rs.EOF Then 
		rs("name") = vName
		rs("job_title") = vJobTitle
		rs("phone")  = vPhone
		rs("phoneExt")  = vExt
		rs("fax") = vFax
		rs("cellPhone")  = vCell
		rs("email") = vEmail
		rs("remark") = vMemo	
		rs("editedby") = login_name
		rs("date") = date()
		rs.Update
	end if
	rs.Close

end sub
%>

<%
Sub delete_contact( num )
SQL = " delete ig_org_contact where elt_account_number = " & elt_account_number & " and " & " org_account_number = " & vOrgNum & " and item_no = " & num
Set rs = eltConn.execute (SQL)
end sub
%>

<%
Sub load_contact_info

DIM iCnt
SQL = " SELECT * from ig_org_contact where elt_account_number = " & elt_account_number & " and " & " org_account_number = " & vOrgNum & " order by item_no desc "

Set rs = eltConn.execute (SQL)

if NOT rs.eof and NOT rs.bof then
	Do until rs.EOF
 		iCnt = iCnt + 1
		rs.Movenext
 	Loop
end if	
rs.Close

if iCnt = 0 then
 tIndex = 0
 exit sub
end if

ReDim aName(iCnt),aJobTitle(iCnt),aPhone(iCnt),aFax(iCnt),aEmail(iCnt),aRemarks(iCnt),aItemNo(iCnt),aExt(iCnt),aCellPhone(iCnt)
Set rs = eltConn.execute (SQL)
tIndex = 0
if NOT rs.eof and NOT rs.bof then
	tIndex=0
	Do until rs.EOF
		aItemNo(tIndex) = rs("item_no")
		aName(tIndex) = rs("name")
		aJobTitle(tIndex) = rs("job_title")
		aPhone(tIndex) = rs("phone") 
		aExt(tIndex) = rs("phoneExt") 
		aFax(tIndex) = rs("fax")
		aCellPhone(tIndex) = rs("cellPhone") 
		aEmail(tIndex) = rs("email")
		aRemarks(tIndex) = rs("remark")
		tIndex=tIndex+1
		rs.Movenext
	Loop
end if
rs.Close
End Sub
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="12" align="left" valign="middle" class="pageheader"></td>
  </tr>
  <tr>
      <td height="32" align="left" valign="middle" class="pageheader">Additional Contact Information (<%=vOrgName %>)</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#73beb6">
  <tr> 
    <td> 
     <form name=form1 method="post" action="AddContact.asp">
     <!-- start of scroll bar -->		
     <input type="hidden" name="scrollPositionX">
	 <input type="hidden" name="scrollPositionY">
     <!-- end of scroll bar -->
	  <input type=hidden name="hNoItem" Value="<%= tIndex %>">
   	  <input type=hidden name="hOrgNum" Value="<%= vOrgNum %>">
   	  <input type=hidden name="hOrgName" Value="<%= vOrgName %>">
   	  <input type=hidden name="hMask" Value="<%= vMask %>">
   	  <input type=hidden name="ContactItemNo">
	  <input type=hidden name="ContactName">
   	  <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#73beb6" class="border1px">
          <tr bgcolor="D5E8CB"> 
              <td height="8" colspan="11" align="left" valign="top" bgcolor="#ccebed" class="bodyheader"></td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="10" height="1" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="#ecf7f8">
              <td width="1" bgcolor="#ecf7f8" class="bodyheader">&nbsp;</td> 
            <td width="221" height="22" class="bodyheader">Name</td>
            <td width="74" class="bodyheader">Job Title </td>
            <td width="103" class="bodyheader">Phone</td>
            <td width="39" class="bodyheader">Ext.</td>
            <td width="110" class="bodyheader">Cell</td>
            <td width="120" class="bodyheader">Fax.</td>
            <td width="93" class="bodyheader">Email</td>
            <td width="144" class="bodyheader">Memo</td>
            <td colspan="2" class="bodyheader">&nbsp;</td>
          </tr>
          <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="10" height="2" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="f3f3f3">
              <td bgcolor="f3f3f3">&nbsp;</td> 
            <td height="22" bgcolor="f3f3f3"><input name="txtName" class="shorttextfield" size="30" ></td>
            <td><input name="txtJobTitle" class="shorttextfield" size="10" ></td>
            <td><input name="txtPhone" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=15  ></td>
            <td><input name="txtExt" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=5  ></td>
            <td><input name="txtCell" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=15  ></td>
            <td><input name="txtFax" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %> size=20></td>
            <td><input name="txtEmail" class="shorttextfield" size=15></td>
            <td><input name="txtRemarks" class="shorttextfield" size=25></td>
            <td colspan="2"><img src="../images/button_add.gif" width="37" height="17" OnClick="AddContact()"></td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="10" height="1" class="bodyheader"></td>
          </tr>
		  <tr bgcolor="#FFFFFF"> 
            <td height="20" colspan="11"></td>
		  </tr>
          <% for i=0 to tIndex-1 %>
          <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
              <td bgcolor="f3f3f3">&nbsp;</td> 
            <td height="22" bgcolor="f3f3f3"><input name="ContactName<%= i %>" id="ContactName" class="shorttextfield" size="30" Value="<%= aName(i) %>"></td>
            <td bgcolor="#f3f3f3"><input name="ContactJobTitle<%= i %>" id="ContactJobTitle" class="shorttextfield" size="10" Value="<%= aJobTitle(i) %>"></td>
            <td bgcolor="#f3f3f3"><input name="ContactPhone<%= i %>" id="ContactPhone" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=15 Value="<%= aPhone(i) %>" ></td>
            <td bgcolor="#f3f3f3"><input name="PhoneExt<%= i %>" id="PhoneExt" class="shorttextfield" size=5 value="<%= aExt(i) %>" ></td>
            <td bgcolor="#f3f3f3"><input name="CellPhone<%= i %>" <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=15 value="<%= aCellPhone(i) %>" ></td>
            <td bgcolor="#f3f3f3"><input name="ContactFax<%= i %>" id="ContactFax"  <% if vMask = "yes" then response.write ("class='m_shorttextfield' preset='phone'") else response.write ("class='shorttextfield'") end if %>  size=20 Value="<%= aFax(i) %>" ></td>
            <td bgcolor="#f3f3f3"><input name="Email<%= i %>" id="Email" class="shorttextfield" size=15 Value="<%= aEmail(i) %>"></td>
            <td bgcolor="#f3f3f3"><input name="Remarks<%= i %>" id="Remarks" class="shorttextfield" size=25 Value="<%= aRemarks(i) %>"></td>
            <td width="70" bgcolor="#f3f3f3"><img src="../images/button_delete.gif" width="50" height="17" OnClick="DeleteContact(<%= aItemNo(i) %>)"></td>
            <td width="84" bgcolor="#f3f3f3"><img src="../images/button_update.gif" width="52" height="18" OnClick="UpdateContact(<%= i %>)">
                <input type=hidden name="ContactItemNo<%= i %>" Value="<%= aItemNo(i) %>"></td>

          </tr>
          <% next %>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="10" height="1" class="bodyheader"></td>
          </tr>
          <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="11" valign="middle" bgcolor="#ccebed" class="bodycopy">&nbsp;</td>
          </tr>
        </table>
      </form></td>
  </tr>
</table>
</body>

<script language="javascript">

function validateEmail(emailad) {
var exclude=/[^@\-\.\w]|^[_@\.\-]|[\._\-]{2}|[@\.]{2}|(@)[^@]*\1/;
var check=/@[\w\-]+\./;
var checkend=/\.[a-zA-Z]{2,3}$/;

	if(((emailad.search(exclude) != -1)||(emailad.search(check)) == -1)||(emailad.search(checkend) == -1)){
		return false;
	}
	return true;
}
</script>

<SCRIPT LANGUAGE="vbscript">
Sub DeleteContact( num )
	document.form1.action="AddContact.asp?delete=yes&item=" & num & "&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target=window.name
	form1.submit()
End Sub
Sub UpdateContact( num )
	document.form1.action="AddContact.asp?update=yes&item=" & num & "&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target=window.name
	form1.submit()
End Sub

Sub AddContact()

Name=trim(Document.form1.txtName.Value)
tIndex=cInt(document.form1.hNoItem.Value)

if Name="" then
	MsgBox "Please enter a contact name"
	exit sub
end if

strEmail = trim(Document.form1.txtEmail.Value)

if Not strEmail = "" then
	if Not validateEmail(strEmail) then
		msgbox "Please enter a valid email address."
		exit sub	
	end if
end if

for i=1 to tIndex
	if ( Name = document.all("ContactName").item(i).value ) then
	 msgbox "Contact Name: " & Name & " exists already. "
	 exit sub
	end if
next

	document.form1.action="AddContact.asp?add=yes&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target=window.name
	form1.submit()
	
End Sub

Sub UpdateAccount(rNo)
	document.form1.action="AddContact.asp?update=yes&rNo=" & rNo & "&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target=window.name
	form1.submit()
End Sub
--->
</SCRIPT>

</html>
