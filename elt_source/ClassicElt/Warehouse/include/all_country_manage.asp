<!--  #INCLUDE FILE="transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="connection.asp" -->
<html>
<head>
    <title>Edit List</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <script language='javascript'>
		window.name = 'AllCountry';
		function closeReturn(s) 
		{
			window.returnValue = s;
			window.close();
		}		
    </script>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>		

</head>
<%
Dim country
Dim PostBack,Action	
Dim i
DIM code_str, elt_account_number,login_name,UserRight,code_list,code_list_all,default,Ret

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	default = Request.QueryString("default")

	PostBack = Request.QueryString("PostBack")
	if PostBack = "" then PostBack = true

	if not PostBack then
		code_str = Request.QueryString("type")
		select case code_str
			case "business_country" 
			case "owner_mail_country" 
		end select
	else
		Action = Request.QueryString("Action")
		select case Action
			case "save" 
				 Ret = Request.QueryString("retVal")
				 call save_code()
				 response.write "<script language='javascript'>closeReturn(""" & Ret & """);</script>"
		end select		
	end if
	
	call get_code_list()
%>

<%
sub save_code()
DIM rs,SQL,tmpCode,tmpDesc,dVal,MyArray,listCnt,pos

'lst_code

	dVal = Request("lst_code")
	if isnull(dVal) then exit sub
	MyArray = Split(dVal,",")
	listCnt = ubound(MyArray)
	
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL = "delete from country_code where elt_account_number="& elt_account_number 
	eltConn.Execute(SQL)

	for i = 0 to listCnt
		pos = Instr(MyArray(i),"^")
		if pos > 0 then
			tmpCode = Trim(Mid(MyArray(i),1,pos-1))
			tmpDesc = Trim(replace(Mid(MyArray(i),pos+1),"'","''"))
			tmpDesc = Trim(replace(Mid(MyArray(i),pos+1),"^^^",","))

			SQL = "select * from country_code where elt_account_number="& elt_account_number & " and country_code='" & tmpCode &"'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF Then
				rs.AddNew
				rs("elt_account_number")=elt_account_number		
				rs("country_code")=tmpCode		
			end if
			rs("country_name")=tmpDesc
			rs.Update
			rs.Close
		end if
	next
	set rs = nothing
end sub
%>
<%
sub get_code_list()
DIM rs,SQL
DIM tmpTable

	set code_list = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select country_code, substring(country_name,0,40) as country_name from country_code where elt_account_number="&elt_account_number&" order by country_name" 

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("country_code").value
		tmpTable.Add "code_description", rs("country_name").value '& fill_space(rs("country_name").value,35) & rs("country_code").value
		tmpTable.Add "description",rs("country_name").value  
		code_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
	
	if isnull(default) then default = ""
	if code_list.count > 0 then
		if default = "" then default = code_list(0)("country_code")
	end if	
	
	set code_list_all = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select country_code, substring(country_name,0,40) as country_name from all_country_code where country_code not in (select country_code from country_code where elt_account_number=" & elt_account_number & ") order by country_name" 

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("country_code").value
		tmpTable.Add "code_description", rs("country_name").value '& fill_space(rs("country_name").value,35) & rs("country_code").value
		
		tmpTable.Add "description",rs("country_name").value  
		code_list_all.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
	
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
<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <form action="all_code_manage.asp" method="post" name="form1">
        <table align="center" border="0" bordercolor="#73beb6" cellpadding="3" cellspacing="0"
            class="border1px" width="100%">
            <tr bgcolor="D5E8CB">
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="top"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
                  <td width="120" align="center" class="bodyheader"><input class="bodycopy" id="bSelectAllLeft" style="width: 120px; height:25px" type="button" value="Select all" onClick="javascript:doBtn(this);"></td>
                  <td width="10" class="bodycopy">&nbsp;</td>
                  <td width="120" align="center" class="bodyheader">&nbsp;</td>
                  <td width="10" class="bodycopy">&nbsp;</td>				  
                </tr>
              </table></td>
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
                  <td width="120" align="center" class="bodyheader"><input class="bodycopy" id="bSelectAllRight" style="width: 120px; height:25px" type="button" value="Select all" onClick="javascript:doBtn(this);"></td>
                  <td width="10" class="bodycopy">&nbsp;</td>
                  <td width="120" align="center" class="bodyheader">&nbsp;</td>
                  <td width="10" class="bodycopy">&nbsp;</td>
                </tr>
              </table></td>
            </tr>
            <tr bgcolor="D5E8CB">
                <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="top" width="20%"><select class="smallselect" id="lst_code" name="lst_code" size="4" style="height: 300px; width: 300px; font-size: 11px; font-family: 'Courier New', Courier, monospace;" multiple="multiple" onChange="javascript:lst_code_on_change(this);">
                  <% if Not IsNull(code_list) And Not isEmpty(code_list) Then %>
                  <% for i=0 To code_list.count-1 %>
                  <option <% 
						if code_list(i)("code") = default then 
								response.write "selected" 
						end if				
						%> value="<%=code_list(i)("code")%>"><%= code_list(i)("code_description") %></option>
                  <% next %>
                  <% end if %>
                </select></td>
                <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle" width="3%">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
						<tr align="left" valign="middle" bgcolor="#f3f3f3"><td height="32" align="left"><input class="bodycopy" id="bLeftAll" style="width: 30px; height:25px" type="button" value="<<" onClick="javascript:doBtn(this);"></td></tr>
                        <tr><td><input class="bodycopy" id="bLeft" style="width: 30px; height:25px" type="button" value="<" onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3"><td height="4" align="left"></td></tr>
                        <tr><td><input class="bodycopy" id="bRight" style="width: 30px; height:25px" type="button" value=">" onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3"><td height="4" align="left"></td></tr>
                        <tr><td><input class="bodycopy" id="bRightAll" style="width: 30px; height:25px" type="button" value=">>" onClick="javascript:doBtn(this);"></td></tr>																		
                    </table></td>
                <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle" width="76%"><select class="smallselect" id="lst_code_all" name="lst_code_all" size="4" style="height: 300px; width: 300px; font-size: 11px; font-family: 'Courier New', Courier, monospace;" multiple="multiple" onChange="javascript:lst_code_all_on_change(this);">
                  <% if Not IsNull(code_list_all) And Not isEmpty(code_list_all) Then %>
                  <% for i=0 To code_list_all.count-1 %>
                  <option value="<%=code_list_all(i)("code")%>"><%= code_list_all(i)("code_description") %></option>
                  <% next %>
                  <% end if %>
                </select></td>
            </tr>
            <tr bgcolor="D5E8CB">
              <td align="center" bgcolor="#f3f3f3" class="bodyheader" valign="top" colspan="3"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                <tr>
                  <td width="120" align="center" class="bodyheader"><input class="bodycopy" id="bMODIFY" style="width: 120px; height:25px" type="button" value="Modify..." onClick="javascript:doBtn(this);"></td>
                  <td width="10" class="bodycopy">&nbsp;</td>
                  <td width="120" align="center" class="bodyheader"><input class="bodycopy" id="bOK" style="width: 120px; height:25px" type="button" value="Save" onClick="javascript:doBtn(this);"></td>
                  <td width="10" class="bodycopy">&nbsp;</td>				  
                  <td width="120" align="center" class="bodyheader"><input class="bodycopy" id="bCANCEL" style="width: 120px; height:25px" type="button" value="Cancel" onClick="javascript:doBtn(this);"></td>
                </tr>
              </table></td>
              <td width="1%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
            </tr>
        </table>
    </form>
</body>

<script language="javascript" src="../ajaxFunctions/otherFunctions.js" type="text/javascript"></script>

<script language="javascript">
function submit_page(strAction) {
	document.form1.action=strAction;
	document.form1.method="POST";
	document.form1.target = window.name;
	document.form1.submit();
}
function doBtn(o) {
	try {
			var oSelect = document.getElementById('lst_code');
			var oSelectAll = document.getElementById('lst_code_all');
			
			if (oSelect.options.selectedIndex >= 0) {
				var	s = oSelect.options[ oSelect.options.selectedIndex ].value;
			}
			else {
				var	s = '';
			}	
	
			switch(o.id) {
				case 'bSelectAllRight' :
					selectAllOptions(oSelectAll);
					lst_code_all_on_change(oSelectAll);				
					break;
				case 'bSelectAllLeft' :
					selectAllOptions(oSelect);
					lst_code_on_change(oSelect);				
					break;
				case 'bLeft' :
					copy_list(oSelectAll,oSelect);
					sortSelect(oSelect);
					removeSelectedOptions(oSelectAll);
					btn_init();
					break;
				case 'bLeftAll' :
					copy_list(oSelectAll,oSelect);
					sortSelect(oSelect);
					removeSelectedOptions(oSelectAll);					
					btn_init();
					break;
				case 'bRight' :
					copy_list(oSelect,oSelectAll);
					sortSelect(oSelectAll);
					removeSelectedOptions(oSelect);					
					btn_init();
					break;
				case 'bRightAll' :
					copy_list(oSelect,oSelectAll);
					sortSelect(oSelectAll);
					removeSelectedOptions(oSelect);					
					btn_init();
					break;
				case 'bOK' :
					combine_select_value(oSelect);
					selectAllOptions(oSelect);
					submit_page("all_country_manage.asp?PostBack=true&Action=save&retVal=ok&WindowName="+window.name);
					break;
				case 'bCANCEL' :
					window.returnValue = '';
					window.close();			
					break;
				case 'bMODIFY' :
					if (oSelect.options.selectedIndex >= 0) {
						s = oSelect.options[ oSelect.options.selectedIndex ].value + '^^' + oSelect.options[ oSelect.options.selectedIndex ].text;
					}				
		var param = 'mode=Modify' + '&default=' + encodeURIComponent(s);
		var retVal = showModalDialog("all_country_edit.asp?"+param,"EditCode","dialogWidth:540px; dialogHeight:150px; help:0; status:0; scroll:0;center:1;Sunken;");   
					if (retVal != '' && typeof(retVal) != 'undefined') {
						adjust_option_item(retVal,oSelect);
					}
					break;
				default :
					break;
			}
	} catch(ex) {}
		
}
function combine_select_value(obj) {
	for (var i=0; i<obj.options.length; i++) {
		var tmpStr = obj.options[i].text.replace(",","^^^");
		obj.options[i].value = obj.options[i].value + '^' + tmpStr;
	}
}

function lst_code_on_change(o) {
	try {
			var cnt = GetSelectValues(o);
			if(cnt == 1) {
				change_btn_status('bRightAll','disabled');
				change_btn_status('bRight','');
				change_btn_status('bMODIFY','');
			}	
			else if(cnt > 1) {
				change_btn_status('bRightAll','');
				change_btn_status('bRight','disabled');
				change_btn_status('bMODIFY','disabled');
			}
			else {
				change_btn_status('bRightAll','disabled');
				change_btn_status('bRight','disabled');
				change_btn_status('bMODIFY','disabled');
			}
	} catch(ex) {}
}

function lst_code_all_on_change(o) {
	try {
			var cnt = GetSelectValues(o);
			if(cnt == 1) {
				change_btn_status('bLeftAll','disabled');
				change_btn_status('bLeft','');
			}	
			else if(cnt > 1) {
				change_btn_status('bLeftAll','');
				change_btn_status('bLeft','disabled');
			}
			else {
				change_btn_status('bLeftAll','disabled');
				change_btn_status('bLeft','disabled');			
			}
			
	} catch(ex) {}
}
function change_btn_status(strBtn, status ) {
try {
	document.getElementById(strBtn).disabled=status;
	} catch(ex) {}
}

function btn_init() {

	try {
		change_btn_status('bMODIFY','disabled');
	} catch(ex) {}		

	try {
		var o = document.getElementById('lst_code');
			if(GetSelectValues(o) == 0) {
				change_btn_status('bRightAll','disabled');
				change_btn_status('bRight','disabled');
			}
	} catch(ex) {}		
	
	try {
		var o = document.getElementById('lst_code_all');
			if(GetSelectValues(o) == 0) {
				change_btn_status('bLeftAll','disabled');
				change_btn_status('bLeft','disabled');
			}
	} catch(ex) {}		
}

	btn_init();	

</script>

</html>
