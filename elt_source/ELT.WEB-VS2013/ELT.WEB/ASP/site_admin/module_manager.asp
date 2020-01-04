
<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/Header.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<%

    Dim pageList,i,mode,this_user_id
    
    this_user_id = checkBlank(Request.QueryString.Item("UID"),user_id)
    If Request.QueryString.Item("mode") = "save" And (user_id <> 0 OR (LCase(login_name) = "system" And user_id=0)) then
        'Call UpdateTabs
		Call UpdatePageUserAccess
    End if

    Call GetAllTabs
    
    Sub GetAllTabs
        Dim SQL,dataObj

        SQL = "select *,case when page_id not in (select page_id from page_user_access where is_bloked=1 and elt_account_number=" _
            & elt_account_number & " and user_id=" & this_user_id & ") then 'Y' else 'N' end as allow" _
            & " from tab_master where page_status='A' and page_label<>'Default Page' and page_label<>'Default Module Page' AND is_obsolete <> 1" _
            & " order by top_seq_id,sub_seq_id,page_seq_id"
   ''''Response.Write SQL 
   ''''Response.end 

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set pageList = dataObj.GetDataList
    End Sub
    
    Sub UpdateTabs
        Dim SQL,rs,dataTable,dataObj,chkList,tmpPageId
		Set dataObj = new DataManager
        dataObj.SetColumnKeys("tab_user")

        For i=1 To Request.Form("chkAuthorizePage").Count
            tmpPageId = Request.Form("chkAuthorizePage")(i)
            Set dataTable = Server.CreateObject("System.Collections.HashTable")
            dataTable.Add "elt_account_number", elt_account_number
            dataTable.Add "user_id", this_user_id
            dataTable.Add "page_id", tmpPageId
            dataTable.Add "is_denied", "N"
            dataTable.Add "is_faved", "N"
            SQL = "SELECT * FROM tab_user WHERE page_id=" & tmpPageId & " AND elt_account_number=" & elt_account_number & " AND user_id=" & this_user_id
            Call dataObj.UpdateDBRow(SQL,dataTable)
        Next
		
		For i=1 To Request.Form("chkUnAuthorizePage").Count
            tmpPageId = Request.Form("chkUnAuthorizePage")(i)
            Set dataTable = Server.CreateObject("System.Collections.HashTable")
            dataTable.Add "elt_account_number", elt_account_number
            dataTable.Add "user_id", this_user_id
            dataTable.Add "page_id", tmpPageId
            dataTable.Add "is_denied", "Y"
            dataTable.Add "is_faved", "N"
            SQL = "SELECT * FROM page_user_access WHERE page_id=" & tmpPageId & " AND elt_account_number=" & elt_account_number & " AND user_id=" & this_user_id
            Call dataObj.UpdateDBRow(SQL,dataTable)
        Next
        
		SQL = "DELETE FROM tab_user WHERE is_denied='Y' AND is_faved='N' AND elt_account_number=" & elt_account_number & " AND user_id=" & this_user_id
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
		
    End Sub
	
	Sub UpdatePageUserAccess
        Dim SQL,rs,dataTable,dataObj,chkList,tmpPageId
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("page_user_access")

        For i=1 To Request.Form("chkAuthorizePage").Count
            tmpPageId = Request.Form("chkAuthorizePage")(i)
            Set dataTable = Server.CreateObject("System.Collections.HashTable")
            dataTable.Add "elt_account_number", elt_account_number
            dataTable.Add "user_id", this_user_id
            dataTable.Add "page_id", tmpPageId
            dataTable.Add "is_bloked", 0
            SQL = "SELECT * FROM page_user_access WHERE page_id=" & tmpPageId & " AND elt_account_number=" & elt_account_number & " AND user_id=" & this_user_id
            Call dataObj.UpdateDBRow(SQL,dataTable)
        Next
		
		For i=1 To Request.Form("chkUnAuthorizePage").Count
            tmpPageId = Request.Form("chkUnAuthorizePage")(i)
            Set dataTable = Server.CreateObject("System.Collections.HashTable")
            dataTable.Add "elt_account_number", elt_account_number
            dataTable.Add "user_id", this_user_id
            dataTable.Add "page_id", tmpPageId
            dataTable.Add "is_bloked", 1
            SQL = "SELECT * FROM page_user_access WHERE page_id=" & tmpPageId & " AND elt_account_number=" & elt_account_number & " AND user_id=" & this_user_id
            Call dataObj.UpdateDBRow(SQL,dataTable)
        Next
        
    End Sub
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Authorized Pages</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function CheckAll(argObj,selectText){
            var chkObjList = document.getElementsByName(selectText);

            for(var i=0; i<chkObjList.length; i++){
                chkObjList[i].checked = argObj.checked;
            }
        }
        function btnSaveClick(){
            
            var pageList = document.getElementsByName("chkAuthorizePage");
			var pageListUnAuth = document.getElementsByName("chkUnAuthorizePage");
            var form = document.getElementById("form1");
            
            for(var i=0; i<pageList.length; i++){
				pageListUnAuth[i].checked = !pageList[i].checked;
            }
            form.action = "module_manager.asp?mode=save&UID=" + <%=this_user_id %>;
            form.method = "POST";
            form.submit();    
        }
        function btnCloseClick(){
            window.close();
        }
    
    </script>

</head>
<body>
    <form name="form1" id="form1">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="46%" height="32" align="left" valign="middle" class="pageheader">
                    Authorized Pages</td>
                <td width="54%" align="right" valign="bottom">
                    <input type="image" src="../images/button_save_medium.gif" onclick="btnSaveClick(); return false;" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="image" src="../images/button_closebooking.gif" onclick="btnCloseClick(); return false;" />
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9190A5"
            class="border1px">
            <tr>
                <td height="8" align="left" valign="top" bgcolor="#C7C6E1" class="bodyheader">
                </td>
            </tr>
            <tr>
                <td height="1" align="left" valign="top" bgcolor="#9190A5">
                </td>
            </tr>
            <tr>
                <td align="left">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy"
                        id="tblHeader" style="padding-left: 10px">
                        <tr class="bodyheader" bgcolor="#f3f3f3">
                            <td height="20" width="15%">
                                Top Module</td>
                            <td width="15%">
                                Sub Module</td>
                            <td width="30%">
                                Page Label</td>
                            <td width="40%">
                                <input type="checkbox" id="chkAuthorizeAll" name="chkAuthorizeAll" onclick="CheckAll(this,'chkAuthorizePage');" 
                                <% if cInt(UserRight)<>9 And trim(LCASE(user_id)) <> "admin" And trim(LCASE(user_id)) <> "system" Then Response.Write(" disabled") %> /> Select All
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy"
                        id="tblContent" style="padding-left: 10px">
                        <tr>
                            <td height="5">
                            </td>
                        </tr>
                        <% For i=0 To pageList.Count-1 %>
                        <% If (pageList(i)("top_module") = "International" And agent_is_intl = "N") OR (pageList(i)("top_module") = "Domestic" And agent_is_dome = "N") Or pageList(i)("top_module")="Accounting Beta" Then%>
                        <% Else %>
                        <tr>
                            <td width="15%">
                                <%= pageList(i)("top_module") %>
                            </td>
                            <td width="15%">
                                <%= pageList(i)("sub_module") %>
                            </td>
                            <td width="30%">
                                <%= pageList(i)("page_label") %>
                            </td>
                            <td width="40%">
                                <input type="checkbox" name="chkAuthorizePage" value="<%= pageList(i)("page_id") %>" <% If pageList(i)("allow") = "Y" Then Response.Write("checked") End If%> 
                                <% if cInt(UserRight)<>9 And trim(LCASE(user_id)) <> "admin" And trim(LCASE(user_id)) <> "system" Then %> onclick="javascript:return false;"<% End If %> /> 
								<input type="checkbox" name="chkUnAuthorizePage" value="<%= pageList(i)("page_id") %>" <% If pageList(i)("allow") <> "Y" Then Response.Write("checked") End If%> style="display:none" />
								Authorize Page
                            </td>
                        </tr>
                        <% End If %>
                        <% Next %>
                        <tr>
                            <td height="5">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
