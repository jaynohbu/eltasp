<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Edit Schedule B Number</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="../include/JPED.js" type="text/jscript"></script>

    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <style type="text/css">
<!--
.style1 {color: #cc6600}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<%

Dim rs, SQL,add,delete,update,dAccount,TranNo,tNo,tIndex,uIndex,i,j
Dim aSB(200),aDesc(200),aUnit1(200),aUnit2(200)
Dim vSB,vDesc,vUnit1,vUnit2,rNo,dSB
Set rs = Server.CreateObject("ADODB.Recordset")

eltConn.BeginTrans

	add=Request("add")
	delete=Request("delete")
	update=Request("update")
	if delete="yes" then
		dSB=Request.QueryString("dSB")
		SQL= "delete scheduleb where elt_account_number = " & elt_account_number & " and sb='" & dSB & "'"
		eltConn.Execute SQL
	end if
	if update="yes" then
		rNo=Request.QueryString("rNo")
		vSB=Request("txtSB" & rNo)
		vUnit1=Request("lstUnitOne" & rNo)
		vUnit2=Request("lstUnitTwo" & rNo)
		vDesc=Request("txtDesc" & rNo)
		SQL= "select description,sb_unit1,sb_unit2 from scheduleb where elt_account_number = " & elt_account_number & " and sb='" & vSB & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if Not rs.EOF Then 
			rs("description") = vDesc
			rs("sb_unit1")=vUnit1
			rs("sb_unit2")=vUnit2
			rs.Update
		end if
		rs.Close
	end if
	TranNo=Session("TranNo")
	if TranNo="" then
	Session("TranNo")=0
	TranNo=0
	end if
	tNo=CInt(Request.QueryString("tNo"))
	if add="yes" And tNo=TranNo then
		Session("TranNo")=Clng(Session("TranNo"))+1
		TranNo=Clng(Session("TranNo"))
		vSB=Request("txtSB")
		vDesc=Request("txtDesc")
		vUnit1=Request("lstUnitOne")
		vUnit2=Request("lstUnitTwo")

		SQL= "select * from scheduleb where elt_account_number = " & elt_account_number & " and sb=N'" & vSB & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		'rs.Open "scheduleb", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
		if rs.eof then
			rs.AddNew
			rs("elt_account_number") = elt_account_number
			rs("sb") = vSB
			rs("description") = vDesc
			rs("sb_unit1")=vUnit1
			rs("sb_unit2")=vUnit2
			rs.Update
		end if
		rs.Close	
	end if

	SQL= "select * from scheduleb where elt_account_number = " & elt_account_number & " order by sb"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	tIndex=0
	Do While Not rs.EOF
		aSB(tIndex)=rs("sb")
		aDesc(tIndex)=rs("description")
		aUnit1(tIndex)=rs("sb_unit1")
		aUnit2(tIndex)=rs("sb_unit2")
		tIndex=tIndex+1
		rs.MoveNext
	Loop
	rs.Close
	'GET Unit Code
	Dim aUnitCode(64), aUnitDesc(64)
	SQL= "select * from unit_code order by unit_code"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	aUnitCode(0)=""
	aUnitDesc(0)="Select One"
	uIndex=1
	Do While Not rs.EOF
		aUnitCode(uIndex)=Trim(rs("unit_code"))
		aUnitDesc(uIndex)=rs("unit_desc")
		uIndex=uIndex+1
		rs.MoveNext
	Loop
	rs.Close
	Set rs=Nothing

eltConn.CommitTrans

%>

<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <!-- pointer disabled
<table width="100%" height="12" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top"><img src="../images/spacer.gif" width="535" height="6"><img src=<% 
	
	if Not isPopWin then  
	response.write("'../images/pointer_md.gif'") 
	end if%> width="11" height="7"><img src="../images/spacer.gif" width="57" height="6"></td>
  </tr>
</table>
-->
    <table width="95%" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                Schedule B</td>
            <td align="right" valign="bottom" class="bodycopy">
                <a href="http://www.census.gov/foreign-trade/schedules/b/index.html" target='_blank'
                    class="style1">Schedule B Lookup</a></td>
        </tr>
    </table>
    <form name="form1" method="post">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
            bgcolor="#73beb6" class="border1px">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX" />
                    <input type="hidden" name="scrollPositionY" />
                    <!-- end of scroll bar -->
                    <input type="hidden" id="hNoItem" value="<%= tIndex %>" />
                    <table width="100%" border="0" cellpadding="2" cellspacing="0">
                        <tr bgcolor="ccebed">
                            <td colspan="8" height="8" align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr bgcolor="73beb6">
                            <td colspan="8" height="1" align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <thead>
                            <tr align="left" valign="middle" bgcolor="ecf7f8">
                                <td width="5" height="20" bgcolor="ecf7f8">
                                </td>
                                <td width="158" height="20" bgcolor="ecf7f8" class="bodyheader">
                                    Schedule B Number</td>
                                <td width="248" class="bodyheader">
                                    Description</td>
                                <td width="276" class="bodyheader">
                                    Unit 1</td>
                                <td width="286" class="bodyheader">
                                    Unit 2</td>
                                <td width="66" bgcolor="ecf7f8" class="bodyheader">
                                    &nbsp;</td>
                                <td width="1" height="22">
                                    &nbsp;</td>
                                <td width="52" class="bodyheader">
                                    &nbsp;</td>
                            </tr>
                        </thead>
                        <% for i=0 to tIndex-1 %>
                        <%next%>
                        <tr bgcolor="f3f3f3">
                            <td>
                            </td>
                            <td>
                                <input name="txtSB" type="text" class="shorttextfield" value="<%= aSB(i) %>" size="16"
                                    style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                            <td>
                                <input name="txtDesc" type="text" class="shorttextfield" maxlength="45" value="<%= aDesc(i) %>"
                                    size="34"></td>
                            <td>
                                <select name="lstUnitOne" size="1" class="smallselect" style="width: 210px">
                                    <% for j=0 to uIndex-1 %>
                                    <option value="<%= aUnitCode(j) %>">
                                        <%= aUnitDesc(j) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td>
                                <select name="lstUnitTwo" size="1" class="smallselect" style="width: 210px">
                                    <% for j=0 to uIndex-1 %>
                                    <option value="<%= aUnitCode(j) %>">
                                        <%= aUnitDesc(j) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td>
                                <img src="../images/button_add_bold.gif" width="37" height="17" onclick="AddSB(<%= TranNo %>)"
                                    style="cursor: hand"></td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr bgcolor="73beb6">
                            <td colspan="8" height="1" align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 10px">
                            <td colspan="8">
                            </td>
                        </tr>
                        <input type="hidden" id="SB">
                        <tbody>
                            <% for i=0 to tIndex-1 %>
                            <tr valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <td height="22" bgcolor="#FFFFFF">
                                </td>
                                <td align="left">
                                    <input name="txtSB<%= i %>" type="text" class="d_shorttextfield" id="SB" value="<%= aSB(i) %>"
                                        size="16" readonly="true"></td>
                                <td align="left">
                                    <input name="txtDesc<%= i %>" type="text" class="shorttextfield" maxlength="45" value="<%= aDesc(i) %>"
                                        size="34"></td>
                                <td align="left">
                                    <select name="lstUnitOne<%= i %>" size="1" class="smallselect" style="width: 210px">
                                        <% for j=0 to uIndex-1 %>
                                        <option value="<%= aUnitCode(j) %>" <% if aUnit1(i)=aUnitCode(j) then response.write("selected") %>>
                                            <%= aUnitDesc(j) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </td>
                                <td align="left">
                                    <select name="lstUnitTwo<%= i %>" size="1" class="smallselect" style="width: 210px">
                                        <% for j=0 to uIndex-1 %>
                                        <option value="<%= aUnitCode(j) %>" <% if aUnit2(i)=aUnitCode(j) then response.write("selected") %>>
                                            <%= aUnitDesc(j) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </td>
                                <td align="left">
                                    <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteSB('<%= aSB(i) %>')"
                                        style="cursor: hand"></td>
                                <td width="1" height="22">
                                </td>
                                <td align="left">
                                    <img src="../images/button_update.gif" width="52" height="18" onclick="UpdateSB(<%= i %>)"
                                        style="cursor: hand"></td>
                            </tr>
                            <% next %>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="11" style="background-color: #ffffff; height: 10px">
                </td>
            </tr>
            <tr>
                <td height="1" colspan="11" align="left" valign="top" bgcolor="73beb6" class="bodyheader">
                </td>
            </tr>
            <tr>
                <td height="20" colspan="11" align="right" valign="middle" bgcolor="ccebed" class="bodycopy">
                    &nbsp;</td>
            </tr>
        </table>
    </form>
</body>

<script type="text/vbscript">
<!---
Sub AddSB(TranNo)
Dim AddOK
AddOK=false
SB=Document.form1.txtSB.Value
tIndex=cInt(document.form1.hNoItem.Value)

if Not SB="" then
	AddOK=true
else
	MsgBox "Please enter a Schedule B Number"
	AddOK=false
end if
if AddOK=true then
	for j=1 to tIndex
		if document.all("SB").item(j).Value=SB then
			AddOK=false
			MsgBox "The Schedule B Number is existed!"
		end if
	next
end if
if Len(SB)>32 then
	MsgBox "Invaild SB!"
	AddOK=false
end if
if AddOK=true then
	document.form1.action="edit_sche_b.asp?add=yes&tNo=" & TranNo   & "&WindowName=" & window.name 
	Document.form1.target = "_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub DeleteSB(SB)
	ok=MsgBox ("Are you sure you want to delete this Schedule B Number?" & chr(13) & "Continue?",4,"Message")
	if ok=6 then	
		document.form1.action="edit_sche_b.asp?delete=yes&dSB=" & encodeURIComponent(SB) & "&WindowName=" & window.name 
		Document.form1.target = "_self"
		document.form1.method="POST"
		form1.submit()
	end if
End Sub
Sub UpdateSB(rNo)
SB=document.all("SB").item(rNo+1).value
if Len(SB)>32 then
	MsgBox "Invalid SB!"
else
	document.form1.action="edit_sche_b.asp?update=yes&rNo=" & rNo & "&WindowName=" & window.name 
	Document.form1.target = "_self"
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
--->
</script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
