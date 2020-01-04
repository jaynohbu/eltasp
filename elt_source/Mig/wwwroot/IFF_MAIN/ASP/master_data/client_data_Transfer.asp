<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
    <title>Client Profile Transfer</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
		window.name = 'TransClient';
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
    <style type="text/css">
        .style1 {color: #FF0000}
    </style>
</head>
<!--  #INCLUDE FILE="../master_data/client_profile_declaration.inc" -->
<%
Dim PostBack,Action,elt_account_number,login_name,UserRight	
Dim v_source_dba,v_source_org,v_target_dba,v_target_org
Dim code_list,i

DIM Ret
	call get_queryString
	if PostBack = "" then PostBack = true
	if not PostBack then
		v_target_org = v_source_org
	end if
	
	call get_all_dba
%>
<% 
function fill_space( s, spaceLen )
DIM tL,tmpS
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
<% 
sub get_all_dba
DIM rs,SQL,tmpTable,tmpDbaName
DIM tmpStr

set code_list = Server.CreateObject("System.Collections.ArrayList")
SQL = "select org_account_number,isnull(dba_name,'') as dba_name, isnull(class_code,'') as class_code, CASE WHEN isnull(account_status,'') = 'A' THEN '' ELSE 'Deactivated' END as account_status from organization where elt_account_number=" & elt_account_number  & " order by dba_name,class_code"

Set rs = eltConn.execute(SQL)
Do While Not rs.EOF and NOT rs.bof
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("org_account_number").value
		tmpTable.Add "dba_name",rs("dba_name").value
		if rs("account_status").value = "" then
			tmpDbaName = rs("dba_name").value 
		else
			tmpDbaName = rs("dba_name").value & " (" & rs("account_status").value & ")"
		end if
		
		tmpStr = tmpDbaName & fill_space(tmpDbaName,60) & " " & rs("class_code").value
		tmpTable.Add "code_description", tmpStr
		tmpTable.Add "description",rs("class_code").value  
		code_list.Add tmpTable	
		rs.MoveNext
Loop
rs.close
set rs = nothing

end sub
%>
<%
sub get_queryString
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	PostBack = Request.QueryString("PostBack")
	v_source_org = Request.QueryString("src")
	if isnull(v_source_org) then
		v_source_org = "0"
	end if
	v_source_dba = Request.QueryString("Dba")
	if isnull(v_source_dba) then
		v_source_dba = ""
	end if
end sub 
%>
<body link="#336699" vlink="#336699" style="margin:0px 0px 0px 0px">
    <form action="all_dba_manage.asp" method="post" name="form1">
        <table border="0" bordercolor="#ffffff" cellpadding="0" cellspacing="0" class="border1px"
            width="100%">
            <tr>
                <td align="left" valign="middle" class="bodycopy">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodycopy">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
            </tr>
            <tr>
                <td width="15" align="left" valign="middle" class="bodycopy">
                    &nbsp;</td>
                <td width="209" align="left" valign="middle" class="bodycopy">
                    &nbsp;</td>
                <td width="22" align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td width="987" align="left" valign="middle" class="bodyheader">
                    All Transactional Data and Master Data for
                </td>
            </tr>
            <tr>
                <td align="left" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td align="left" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <input id="txt_source_dba" class="d_shorttextfield" name="txt_source_dba" style="width: 250px;"
                        value="<%= v_source_dba%>" readonly="true"><input type="hidden" name="source_org"
                            value="<%=v_source_org%>">
                </td>
            </tr>
            <tr>
                <td align="left" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="left" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    <span class="bodyheader">-&gt; <span class="style1">will be Transfered and Merged into</span></span></td>
            </tr>
            <tr>
                <td align="left" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodyheader" valign="middle">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    <select class="smallselect" id="lst_code" name="lst_code" size="1" style="width: 485px;
                        font-size: 11px; font-family: 'Courier New', Courier, monospace;" onchange="lst_code_on_change(this)">
                        <option value="0">Select Target Client</option>
                        <% if Not IsNull(code_list) And Not isEmpty(code_list) Then %>
                        <% for i=0 To code_list.count-1 %>
                        <option <% If InStr(code_list(i)("code_description"),"Deactivated") > 0 Then Response.Write("style='color:#FF0000;font:bold'") %> value="<%=code_list(i)("code")%>">
                            <%=code_list(i)("code_description") %>
                        </option>
                        <% If i Mod 2560 = 0 Then Response.Flush() %>
                        <% next %>
                        <% end if %>
                    </select>
                </td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle">
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Class&nbsp;</span></td>
                <td align="left" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle">
                    <span class="bodyheader">
                        <input id="txt_class" class="shorttextfield" name="txt_class" style="width: 250px;
                            border-style: none; background-color: #f3f3f3" value="<%= v_class_code%>" readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Address&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_address" class="shorttextfield" name="txt_business_address"
                            style="width: 400px; border-style: none; background-color: #f3f3f3" value="<%= v_business_address%>"
                            readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_address2" class="shorttextfield" name="txt_business_address2"
                            style="width: 400px; border-style: none; background-color: #f3f3f3" value="<%= v_business_address2%>"
                            readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">City&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_city" class="shorttextfield" name="txt_business_city" style="width: 250px;
                            border-style: none; background-color: #f3f3f3" value="<%= v_business_city%>"
                            readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">State/Province&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_state" class="shorttextfield" name="txt_business_state" style="width: 250px;
                            border-style: none; background-color: #f3f3f3" value="<%= v_business_state%>"
                            readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodyheader" valign="middle">
                    Zip&nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_zip" class="shorttextfield" name="txt_business_zip" style="width: 250px;
                            border-style: none; background-color: #f3f3f3" value="<%= v_business_zip%>" readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Country&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_country" class="shorttextfield" name="txt_business_country"
                            style="width: 250px; border-style: none; background-color: #f3f3f3" value="<%= v_b_country_code%>"
                            readonly="true"></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Primary Contact </span>
                </td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td>
                                <span class="bodyheader">
                                    <input id="txt_owner_fname" class="shorttextfield" name="txt_owner_fname" style="width: 70px;
                                        border-style: none; background-color: #f3f3f3" type="text" value="<%= v_owner_fname%>"
                                        maxlength="32" readonly="true" /></span></td>
                            <td>
                                <span class="bodyheader">
                                    <input id="txt_owner_mname" class="shorttextfield" name="txt_owner_mname" style="width: 30px;
                                        border-style: none; background-color: #f3f3f3" type="text" value="<%= v_owner_mname%>"
                                        maxlength="32" readonly="true" /></span></td>
                            <td>
                                <span class="bodyheader">
                                    <input id="txt_owner_lname" class="shorttextfield" name="txt_owner_lname" style="width: 70px;
                                        border-style: none; background-color: #f3f3f3" type="text" value="<%= v_owner_lname%>"
                                        maxlength="32" readonly="true" /></span></td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Primary Phone&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_phone" class="shorttextfield" name="txt_business_phone" style="width: 175px;
                            border-style: none; background-color: #f3f3f3" type="text" value="<%=v_business_phone%>"
                            maxlength="32" readonly="true" /></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Primary Fax&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_business_fax" class="shorttextfield" name="txt_business_fax" style="width: 175px;
                            border-style: none; background-color: #f3f3f3" type="text" value="<%= v_business_fax%>"
                            readonly="true" /></span></td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="right" class="bodycopy" valign="middle">
                    <span class="bodyheader">Primary Cell&nbsp;</span></td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <span class="bodyheader">
                        <input id="txt_owner_phone" class="shorttextfield" name="txt_owner_phone" style="width: 175px;
                            border-style: none; background-color: #f3f3f3" type="text" value="<%= v_owner_phone%>"
                            maxlength="32" readonly="true" />
                    </span>
                </td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="left" class="bodycopy" valign="middle">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    &nbsp;</td>
                <td align="left" valign="middle" class="bodyheader">
                    <input id="bTrans" class="bodycopy" style="width: 80px" type="button" value="Transfer Data"
                        onclick="javascript:doBtn(this);">
                    <input id="bClose" class="bodycopy" style="width: 80px" type="button" value="Close"
                        onclick="javascript:window.close();"></td>
            </tr>
        </table>
    </form>
</body>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax.js"></script>

<script language="javascript" type="text/javascript">

function prevNextMain(xmlHttp) {
	var xmlData = xmlHttp.responseXML;  
    var itemNode = xmlData.getElementsByTagName("item"); 
    var codeNode = xmlData.getElementsByTagName("itemcode");
    var descNode = xmlData.getElementsByTagName("itemdesc");
    var itemLength = itemNode.length;    

	if (itemLength == 0) {
		alert(xmlHttp.responseText);
	}

    var resultXML = "", cd, ds, txtField 
	
    for (i=0; i<itemLength; i++) { 
		try {
	        cd = codeNode[i].childNodes[0].nodeValue; 
			ds = descNode[i].childNodes[0].nodeValue; 
		}
		catch (e) {ds = "";}

		txtField = document.getElementById('txt_' + cd);
		if(txtField) {
			txtField.value = ds;
		}
    } 
}
function showResponsePrevNext(req,field,tmpVal,tWidth,tMaxLength,url,post_parameter) {

	if (req.readyState == 4) {
		if (req.status == 200) {
			prevNextMain(req);
		}
		else
		{
			alert(req.responseText);
		}
	}	
}

function lst_code_on_change(oSelect) {

	var org_account_number = oSelect.options[ oSelect.options.selectedIndex ].value;
	try {
		if(oSelect.options.selectedIndex > 0 ) {
			var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_organization_PrevNext.asp" 
						+"?o="+org_account_number 
						+"&Action=thisOrg";
			new ajax.xhr.Request('GET','',url,showResponsePrevNext,'','','');
		}
		else {
			reset_field();
		}
	} catch(f) {}
}

function reset_field() {
	document.getElementById('txt_class').value = '';
	document.getElementById('txt_business_address').value = '';
	document.getElementById('txt_business_address2').value = '';
	document.getElementById('txt_business_city').value = '';
	document.getElementById('txt_business_state').value = '';
	document.getElementById('txt_business_zip').value = '';
	document.getElementById('txt_business_country').value = '';
	document.getElementById('txt_owner_fname').value = '';
	document.getElementById('txt_owner_mname').value = '';
	document.getElementById('txt_owner_lname').value = '';
	document.getElementById('txt_business_phone').value = '';
	document.getElementById('txt_business_fax').value = '';
	document.getElementById('txt_owner_phone').value = '';
}
function transfer_data(src,target) {

      if (window.ActiveXObject) {
	       try {
		    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch(e) {
                try {
                 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e1) {
                 return;
                }
          }
      } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
      } else {return;}
     
    try {    
        xmlHTTP.open("get","/iff_main/asp/ajaxFunctions/ajax_transfer_client.asp?src="+src+"&target="+target,false); 
        xmlHTTP.send(); 
        var sourceCode = xmlHTTP.responseText;
	    if (sourceCode)
	    {
			if(sourceCode == 'ok') {
				alert('Transfered successfully!'); 
			} else {
				alert(sourceCode); 			
			}
		}		
	} catch (e) {}
}
function doBtn(o) {
	try {
			switch(o.id) {
				case 'bTrans' :
					var oSelect = document.getElementById('lst_code');
					var source_org = document.getElementById('source_org').value;
					var org_account_number = oSelect.options[ oSelect.options.selectedIndex ].value;
					try {
						if (org_account_number > 0 && source_org > 0) {
							if(confirm('Do you really want to transfer all data of this Client profile?')) {
							   transfer_data(source_org,org_account_number);
							}
						}
						else {
							alert('Please select a target Client.');
						}
					} catch(f) {}
					break;
				default :
					break;
			}
	} catch(ex) {}
		
}
</script>

</html>
