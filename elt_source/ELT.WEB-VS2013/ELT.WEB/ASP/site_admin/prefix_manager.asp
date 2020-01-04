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
    Dim dataObj,dataList,i,mode,max_seq,prefix_str
    
    eltConn.BeginTrans
    '///////////////////////////////////////////////////////////////////
    
    mode = checkBlank(Request.QueryString("mode").Item, "view")
    
    If mode = "add" Then
        max_seq = GetMaxSeqNum()
        Call AddNewPrefix
    Elseif mode = "delete" Then
        prefix_str = checkBlank(Request.QueryString("prefix").Item, "")
        Call DeletePrefix
    End If 
    
    Call GetAllPrefixes
    '////////////////////////////////////////////////////////////////////
    eltConn.CommitTrans
    
    Sub GetAllPrefixes
        Dim SQL,dataObj
        SQL = "select * from user_prefix where elt_account_number=" & elt_account_number & " order by type"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataList = dataObj.GetDataList
    End Sub
    
    Sub AddNewPrefix
        
        Dim SQL,dataObj,tmpTable
        
        SQL = "select * from user_prefix where elt_account_number=" & elt_account_number & " order by type"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        
        SQL = "select * from user_prefix where elt_account_number=" & elt_account_number _
            & " and prefix=N'" & Request.Form("txtPrefixNew").Item & "'"
        
        Set tmpTable = Server.CreateObject("System.Collections.HashTable")
        tmpTable.Add "elt_account_number", elt_account_number
        tmpTable.Add "seq_num", max_seq
        tmpTable.Add "prefix", Request.Form("txtPrefixNew").Item
        tmpTable.Add "type", Request.Form("lstPrefixTypeNew").Item
        tmpTable.Add "next_no", Request.Form("txtNextNew").Item
        tmpTable.Add "desc", Request.Form("txtDescNew").Item
        
        dataObj.SetColumnKeys("user_prefix")
        If dataObj.UpdateDBRow(SQL,tmpTable) Then
        Else
            Response.Write("<script>alert('Failed to add a prefix');</script>")
        End If
    End Sub
    
    Sub DeletePrefix
        Dim SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "delete from user_prefix where elt_account_number=" & elt_account_number _
            & " and prefix=N'" & prefix_str& "'"
        Set rs = eltConn.execute(SQL)
    End Sub
    
    Function GetMaxSeqNum
        Dim returnNum,SQL,rs
        returnNum = 0
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "select max(seq_num)+1 as next_num from user_prefix where elt_account_number=" & elt_account_number
        rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

        If Not rs.EOF And Not rs.BOF Then
            returnNum = rs("next_num").value
        End If
        GetMaxSeqNum = returnNum
    End Function 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Prefix Manager</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <script type="text/javascript">

    function AddPrefix()
    {
        var form = document.getElementById("form1");
        var newPrefix = document.getElementById("txtPrefixNew").value;
        var newNextNo = document.getElementById("txtNextNew").value;
        
        if(newPrefix == "" || newNextNo == "")
        {
            alert("Enter prefix and next number");
            return false;
        }
        
        if(IsPrefixExist(document.getElementById("txtPrefixNew").value)){
            if(!confirm("Prefix already exists, Click OK to update the existing prefix")){
                return false;
            }
        }
            
        form.action = "prefix_manager.asp?mode=add";
        form.method = "POST";
        form.submit();    
    }
    
    //Added By Stanley on 11/11/2007

    
    function IsPrefixExist(vPrefix)
        {
            var objList = document.getElementsByName("txtPrefix");
            
            for(var i=0;i<objList.length;i++){
                if(objList[i].value == vPrefix){
                    return true;
                }
            }
            return false;
        }
        
    function DeletePrefix(vPrefix)
    {
        var ans = confirm("Deleting prefix. Please click OK to continue.");
        if (ans){
            var form = document.getElementById("form1");
            form.action = "prefix_manager.asp?mode=delete&prefix=" + encodeURIComponent(vPrefix);
            form.method = "POST";
            form.submit();    
        }
    }
    
    function EditPrefix(vIndex){
        document.getElementById("lstPrefixTypeNew").selectedIndex = document.getElementsByName("lstPrefixType")[vIndex].selectedIndex;
        document.getElementById("txtPrefixNew").value = document.getElementsByName("txtPrefix")[vIndex].value;
        document.getElementById("txtDescNew").value = document.getElementsByName("txtDesc")[vIndex].value;
        document.getElementById("txtNextNew").value = document.getElementsByName("txtNextNo")[vIndex].value;
    }
    
    function NewPrefix(){
        document.getElementById("lstPrefixTypeNew").value = "";
        document.getElementById("txtPrefixNew").value = "";
        document.getElementById("txtDescNew").value = "";
        document.getElementById("txtNextNew").value = "";
        document.getElementById("lstPrefixTypeNew").selectedIndex = 0;
    }
        
    
    </script>

    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style5 {color: #663366}
-->
</style>
</head>
<body>
    <form name="form1" id="form1">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="46%" height="32" align="left" valign="middle" class="pageheader">
                    PREFIX MANAGER</td>
                <td width="54%" align="right" valign="middle">
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
                            <td height="20" bgcolor="#f3f3f3">
                                Type</td>
                            <td>
                                Prefix</td>
                            <td>
                                Description</td>
                            <td>
                                Beginning No.</td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr style="padding-bottom: 36px; padding-top: 4px">
                            <td width="170" valign="middle">
                                <select class="bodycopy" id="lstPrefixTypeNew" name="lstPrefixTypeNew">
                                    <% If agent_is_intl="Y" Then %>
                                    <option value="HAWB">House AWB</option>
                                    <option value="HBOL">House B/L</option>
                                    <option value="AEJ">Air Export File No.</option>
                                    <option value="AIJ">Air Import File No.</option>
                                    <option value="OEJ">Ocean Export File No.</option>
                                    <option value="OIJ">Ocean Import File No.</option>
                                    <% End If %>
                                    <% If agent_is_dome="Y" Then %>
                                    <option value="DOME">Domestic House Airbill</option>
                                    <option value="DAJ">Domestic Air File No.</option>
                                    <option value="DTJ">Domestic Ground File No.</option>
                                    <% End If %>
                                    <option value="PUO">Pickup Order</option>
                                    <option value="WR">Warehouse Receipt</option>
                                    <option value="SO">Ship Out</option>
                                    <option value="BC">Booking Confirmation</option>
                                    <option value="ETC">Other</option>
                                </select>
                            </td>
                            <td width="85">
                                <input name="txtPrefixNew" type="text" class="m_shorttextfield" maxlength="16" id="txtPrefixNew"
                                    value="" size="12" /></td>
                            <td width="234">
                                <input name="txtDescNew" type="text" class="m_shorttextfield" maxlength="64" id="txtDescNew"
                                    value="" size="42" /></td>
                            <td width="85">
                                <input name="txtNextNew" type="text" class="m_shorttextfield" maxlength="9" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    id="txtNextNew" value="" size="12" /></td>
                            <td width="78">
                                <img src="../images/button_addupdate.gif" height="18" onclick="AddPrefix()" style="cursor: hand;
                                    width: 74px;"></td>
                            <td>
                                <a href="javascript:;" onclick="NewPrefix()" style="cursor: hand">Clear</a></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy"
                        id="tblContent" style="padding-left: 10px">
                        <% For i=0 To dataList.Count-1 %>
                        <tr>
                            <td width="170" height="20">
                                <select class="bodycopy" name="lstPrefixType" disabled>
                                    <% If agent_is_intl="Y" Then %>
                                    <option value="HAWB" <%If dataList(i)("type")="HAWB" Then Response.Write("selected") %>>
                                        House AWB</option>
                                    <option value="HBOL" <%If dataList(i)("type")="HBOL" Then Response.Write("selected") %>>
                                        House B/L</option>
                                    <option value="AEJ" <%If dataList(i)("type")="AEJ" Then Response.Write("selected") %>>
                                        Air Export File No.</option>
                                    <option value="AIJ" <%If dataList(i)("type")="AIJ" Then Response.Write("selected") %>>
                                        Air Import File No.</option>
                                    <option value="OEJ" <%If dataList(i)("type")="OEJ" Then Response.Write("selected") %>>
                                        Ocean Export File No.</option>
                                    <option value="OIJ" <%If dataList(i)("type")="OIJ" Then Response.Write("selected") %>>
                                        Ocean Import File No.</option>
                                    <% End If %>
                                    <% If agent_is_dome="Y" Then %>
                                    <option value="DOME" <%If dataList(i)("type")="DOME" Then Response.Write("selected") %>>
                                        Domestic House Airbill</option>
                                    <option value="DAJ" <%If dataList(i)("type")="DAJ" Then Response.Write("selected") %>>
                                        Domestic Air File No.</option>
                                    <option value="DTJ" <%If dataList(i)("type")="DTJ" Then Response.Write("selected") %>>
                                        Domestic Ground File No.</option>
                                    <% End If %>
                                    <option value="PUO" <%If dataList(i)("type")="PUO" Then Response.Write("selected") %>>
                                        Pickup Order</option>
                                    <option value="WR" <%If dataList(i)("type")="WR" Then Response.Write("selected") %>>
                                        Warehouse Receipt</option>
                                    <option value="SO" <%If dataList(i)("type")="SO" Then Response.Write("selected") %>>
                                        Ship Out</option>
                                    <option value="BC" <%If dataList(i)("type")="BC" Then Response.Write("selected") %>>
                                        Booking Confirmation</option>
                                    <option value="ETC" <%If dataList(i)("type")="ETC" Then Response.Write("selected") %>>
                                        Other</option>
                                </select>
                            </td>
                            <td width="85">
                                <input name="txtPrefix" type="text" class="d_shorttextfield" value="<%=dataList(i)("prefix") %>"
                                    size="12" readonly="readonly" /></td>
                            <td width="234">
                                <input name="txtDesc" type="text" class="d_shorttextfield" value="<%=dataList(i)("desc") %>"
                                    size="42" readonly="readonly" /></td>
                            <td width="85">
                                <input name="txtNextNo" type="text" class="d_shorttextfield" value="<%=dataList(i)("next_no") %>"
                                    size="12" readonly="readonly" /></td>
                            <td width="78">
                                <img src="../images/button_delete.gif" width="50" height="17" onclick="DeletePrefix('<%=dataList(i)("prefix") %>')"
                                    style="cursor: hand"></td>
                            <td>
                                <img src="../images/button_edit.gif" height="18" onclick="EditPrefix(<%= i %>)" style="cursor: hand;
                                    width: 38px;"></td>
                        </tr>
                        <% Next %>
                    </table>
                    <br />
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
