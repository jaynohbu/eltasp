<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    %>
    <title>Edit List</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">

    <script language='javascript'>
		window.name = 'AllCode';
		function closeReturn(s) 
		{
			window.returnValue = s;
			window.close();
		}		
    </script>

    <style type="text/css">
<!--
body {
	background-color: #f3f3f3;
}
-->
</style>
</head>
<%
Dim country
Dim PostBack,Action	
Dim i
DIM code_str, code_type,elt_account_number,login_name,UserRight,code_list,default,Ret,code_desc

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	default = Request.QueryString("default")

	PostBack = Request.QueryString("PostBack")
	if PostBack = "" then PostBack = true
	if not PostBack then
		code_str = Request.QueryString("type")
		code_desc = ""
%>
<!--  #INCLUDE FILE="all_code_type.inc" -->
<%		
	else
		Action = Request.QueryString("Action")
		code_type = Request.QueryString("type")
		code_str = ""
%>
<!--  #INCLUDE FILE="all_code_type.inc" -->
<%		
		select case Action
			case "save" 
				 Ret = Request.QueryString("retVal")
				 call save_code( code_type, Ret )
'				 response.write "<script language='javascript'>//closeReturn(""" & Ret & """);"
			case "delete" 
				 call delete_code( code_type )
		end select		
	end if
	
	call get_code_list( code_type )
%>
<%
sub delete_code( code_type )
DIM SQL,dVal,MyArray,iCnt,i,tmpStr
	dVal = Replace(Request("lst_code"),"'","''")
	if isnull(dVal) then exit sub
	MyArray = Split(dVal,",")
	tmpStr = Join(MyArray,"','")
	tmpStr = replace(tmpStr,"' ","'")
	SQL = "delete all_code where elt_account_number="& elt_account_number & " and type=" & code_type &" and replace(code,',','^^^') in  (N'"& tmpStr & "')"
	eltConn.Execute(SQL)		
end sub
%>
<%
sub save_code( code_type, Ret )
DIM rs,SQL,tmpCode,tmpDesc,pos
	pos = Instr(Ret,"^^^")
	if pos > 0 then
		tmpCode = replace(Mid(Ret,1,pos-1),"'","''")
		tmpDesc = Mid(Ret,pos+3)
	end if
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL = "select * from all_code where elt_account_number="& elt_account_number & " and type=" & code_type &" and code=N'"&tmpCode&"'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs.EOF Then
		rs.AddNew
		rs("elt_account_number")=elt_account_number		
		rs("type")=code_type		
	end if
	tmpCode = replace(tmpCode,"''","'")
	
	rs("code")=tmpCode
	rs("description")=tmpDesc
	rs.Update
	rs.Close
	set rs = nothing
	default = tmpCode
end sub
%>
<%
sub get_code_list( code_type )
DIM rs,SQL
DIM tmpTable

	set code_list = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select code, isnull(description,'') as description from all_code where elt_account_number=" & elt_account_number & " and type=" & code_type & " order by code"

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code", replace(rs("code").value,",","^^^")
		tmpTable.Add "code_description", rs("code").value & " - " & rs("description").value
		tmpTable.Add "description",rs("description").value  
		code_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
	
	if isnull(default) then default = ""
	if code_list.count > 0 then
		if default = "" then default = code_list(0)("code")
	end if	
end sub
%>
<% 
function fill_space( s, spaceLen )
DIM i,tL,tmpS
tL = spaceLen - LEN(s)
tmpS = ""

if tL <= 0 then
	fill_space = ""
	exit function
end if

For i = 0  to tL
	tmpS = tmpS & "&nbsp;"
Next

fill_space = tmpS
end function
%>
<body link="336699" vlink="336699" style="margin: 0px 0px 0px 0px">
    <form action="all_code_manage.asp" method="post" name="form1">
        <table width="90%" border="0" align="center" cellpadding="3" cellspacing="0" bordercolor="#73beb6"
            bgcolor="#FFFFFF" class="maskwindow">
            <tr bgcolor="D5E8CB">
                <td height="8" colspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader">
                </td>
            </tr>
            <tr bgcolor="D5E8CB">
                <td width="3%" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader">
                    &nbsp;</td>
                <td width="44%" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader">
                    <select class="smallselect" id="lst_code" name="lst_code" size="4" style="height: 232px;
                        width: 300px; font-size: 11px; font-family: 'Courier New', Courier, monospace;"
                        multiple="multiple" onchange="lst_code_on_change(this)">
                        <% if Not IsNull(code_list) And Not isEmpty(code_list) Then %>
                        <% for i=0 To code_list.count-1 %>
                        <option <% 
						if code_list(i)("code") = default then 
								response.write "selected" 
						end if				
						%> value="<%=code_list(i)("code")%>">
                            <%= code_list(i)("code_description") %>
                        </option>
                        <% next %>
                        <% end if %>
                    </select>
                </td>
                <td width="53%" align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td>
                                <input class="bodycopy" id="bOK" style="width: 75px; height: 25px" type="button"
                                    value="OK" onclick="javascript:doBtn(this);"></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                            <td height="4" align="left">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input class="bodycopy" id="bCANCEL" style="width: 75px; height: 25px" type="button"
                                    value="Cancel" onclick="javascript:doBtn(this);"></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                            <td height="32" align="left" bgcolor="#FFFFFF">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input class="bodycopy" id="bADD" style="width: 75px; height: 25px" type="button"
                                    value="Add..." onclick="javascript:doBtn(this);"></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                            <td height="4" align="left">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input class="bodycopy" id="bMODIFY" style="width: 75px; height: 25px" type="button"
                                    value="Modify..." onclick="javascript:doBtn(this);"></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3f3f3">
                            <td height="4" align="left">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input class="bodycopy" id="bDELETE" style="width: 75px; height: 25px" type="button"
                                    value="Delete" onclick="javascript:doBtn(this);"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr bgcolor="D5E8CB">
                <td height="8" colspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader">
                </td>
            </tr>
        </table>
    </form>
</body>

<script language="javascript" src="/ASP/ajaxFunctions/otherFunctions.js" type="text/javascript"></script>

<script language="javascript">
function doBtn(o) {
	try {
			var oSelect = document.getElementById('lst_code');
			
			if (oSelect.options.selectedIndex >= 0) {
				var	s = oSelect.options[ oSelect.options.selectedIndex ].value;
			}
			else {
				var	s = '';
			}	
	
			switch(o.id) {
				case 'bOK' :
				window.returnValue = s; 
				window.close();			
					break;
				case 'bCANCEL' :
				window.returnValue = '';
				window.close();			
					break;
				case 'bADD' :
		var param = 'type=' + '<%=code_type%>' + '&desc=' + '<%=code_desc%>' + '&mode=Add';
		var retVal = showModalDialog("all_code_edit.asp?"+param,"EditCode","dialogWidth:540px; dialogHeight:150px; help:0; status:0; scroll:0;center:1;Sunken;");   
					if (retVal != '' && typeof(retVal) != 'undefined') {
						var code = retVal.substring(0,retVal.indexOf('^^^'));
						var goStop = false
						if (!check_dupe(code,oSelect.options)) {
							goStop = true;
						}
						else {
							if(confirm('The Code ' + code + ' already exists in this code list. \nDo you want to replace with new description?')) {
							 goStop = true
							}		
						}
						
						if(goStop) {
							document.form1.action="all_code_manage.asp?Action=save&type="+"<%=code_type%>"+"&retVal="+encodeURIComponent(retVal)+"&WindowName="+window.name;
							document.form1.method="POST";
							document.form1.target = window.name;
							document.form1.submit();					
						}
					}
					break;
				case 'bMODIFY' :
		var param = 'type=' + '<%=code_type%>'+ '&desc=' + '<%=code_desc%>' + '&mode=Modify' + '&default=' + encodeURIComponent(s)
		var retVal = showModalDialog("all_code_edit.asp?"+param,"EditCode","dialogWidth:540px; dialogHeight:150px; help:0; status:0; scroll:0;center:1;Sunken;");   
					if (retVal != '' && typeof(retVal) != 'undefined') {
						document.form1.action="all_code_manage.asp?Action=save&type="+"<%=code_type%>"+"&retVal="+encodeURIComponent(retVal)+"&WindowName="+window.name;
						document.form1.method="POST";
						document.form1.target = window.name;
						document.form1.submit();
					}
					break;
				case 'bDELETE' :
					if(confirm('Are you sure you want to delete the selected item(s)?')) {
						document.form1.action="all_code_manage.asp?Action=delete&type="+"<%=code_type%>"+"&WindowName="+window.name;
						document.form1.method="POST";
						document.form1.target = window.name;
						document.form1.submit();
					}
					break;
				default :
					break;
			}
	} catch(ex) {}
		
}

function lst_code_on_change(o) {
	try {
			if(GetSelectValues(o) > 1) {
				document.getElementById('bMODIFY').disabled="disabled";
				document.getElementById('bDELETE').disabled="";			
			}	
			else {
				document.getElementById('bMODIFY').disabled="";
				document.getElementById('bDELETE').disabled="";			
			}
	} catch(ex) {}		
}

function btn_init() {
	try {
		var o = document.getElementById('lst_code');
			if(GetSelectValues(o) == 0) {
				document.getElementById('bMODIFY').disabled="disabled";
				document.getElementById('bDELETE').disabled="disabled";	
			}
	} catch(ex) {}		
}
function oScroll(oSelect){
	try {
		var opt=oSelect.options;
		for (var i=0;i<opt.length;i++){
			if(opt[i].selected){
				opt[i].selected='false';
				opt[i].selected='true';
				return;
			}
		}
	} catch(f) {}	
}

btn_init();	
if ('<%=Action%>' == 'save') {
	oScroll(document.getElementById('lst_code'));
}
</script>

</html>
