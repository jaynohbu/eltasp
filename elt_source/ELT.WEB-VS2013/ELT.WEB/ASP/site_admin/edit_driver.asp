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
    Dim driverList,i
    
    If Request.QueryString.Item("mode") = "save" Then
        Call SaveDrivers
    End If
    
    Call GetAllDrivers
    
    Sub GetAllDrivers
        Dim dataObj,SQL
        
        SQL = "select driver_name,driver_acct,driver_id,driver_pass,org_account_number,dba_name " _
            & "from organization a full join registered_driver b " _
            & "on (a.elt_account_number=b.elt_account_number and a.org_account_number=b.driver_acct) " _
            & "where a.elt_account_number=" & elt_account_number & " and a.z_is_trucker='Y'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set driverList = dataObj.GetDataList
    End Sub
    
    Sub SaveDrivers
        Dim SQL,rs,dataTable,dataObj,chkList,tmpPageId

        SQL = "DELETE FROM registered_driver WHERE elt_account_number=" & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
        
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("registered_driver")

        For i=1 To Request.Form("hDriverAcct").Count
            If checkBlank(Request.Form.Item("txtUserID")(i),"") <> "" And checkBlank(Request.Form.Item("txtUserPASS")(i),"") <> "" Then
                Set dataTable = Server.CreateObject("System.Collections.HashTable")
                dataTable.Add "elt_account_number", elt_account_number
                dataTable.Add "driver_acct", Request.Form.Item("hDriverAcct")(i)
                dataTable.Add "driver_name", Request.Form.Item("hDriverName")(i)
                dataTable.Add "driver_id", Request.Form.Item("txtUserID")(i)
                dataTable.Add "driver_pass", Request.Form.Item("txtUserPASS")(i)
                SQL = "SELECT * FROM registered_driver WHERE elt_account_number=" & elt_account_number 
                Call dataObj.UpdateDBRow(SQL,dataTable)
            End If
        Next
    End Sub

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Edit Drivers</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        
        function btnSaveClick(){
            
            var form = document.getElementById("form1");
            form.action = "edit_driver.asp?mode=save";
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
                    Registered Drivers</td>
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
                            <td width="30%">Driver Name</td>
                            <td width="20%">User ID</td>
                            <td width="20%">Password</td>
                            <td width="30%"></td>
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
                        <% For i=0 To driverList.Count-1 %>
                        <tr>
                            <td width="30%"><input type="hidden" name="hDriverName" value="<%=driverList(i)("dba_name") %>" />
                                <input type="hidden" name="hDriverAcct" value="<%=driverList(i)("org_account_number") %>" />
                                <%=driverList(i)("dba_name") %></td>
                            <td width="20%"><input type="text" name="txtUserID" class="shorttextfield" value="<%=driverList(i)("driver_id") %>" /></td>
                            <td width="20%"><input type="text" name="txtUserPass" class="shorttextfield" value="<%=driverList(i)("driver_pass") %>" /></td>
                            <td width="30%"><% If driverList(i)("driver_name") <> "" Then %>Registered<% End If %></td>
                        </tr>
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