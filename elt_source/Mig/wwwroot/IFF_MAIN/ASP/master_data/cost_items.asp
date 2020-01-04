<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Cost Items</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
    <%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    
    Dim aAllData, vMode, vSetup, i, dataTable

    Call GetAllParameters
    eltConn.BeginTrans()
    If vSetup = "yes" Then
        Call SetupItems()
    End If
    If vMode = "add" Then
        Call AddNewItem
    Elseif vMode = "update" Then
        Call UpdateItem
    Elseif vMode = "delete" Then
        Call DeleteItem
    Else
    End If
    
    Call GetAllItems
    eltConn.CommitTrans()
    
    Sub GetAllParameters
        vMode = Request.QueryString("mode")
        vSetup = Request.QueryString("setup")
    End Sub
    
    Sub AddNewItem
        Dim feData, SQL, vNewItemNo
        Set dataTable = Server.CreateObject("System.Collections.HashTable")
        dataTable.Add "elt_account_number", elt_account_number
        vNewItemNo = GetSQLResult("SELECT MAX(item_no) FROM item_cost WHERE elt_account_number=" & elt_account_number, Null)
        dataTable.Add "item_no", ConvertAnyValue(vNewItemNo,"Integer",0)+1
        dataTable.Add "item_name", Request.Form("txtItemNameAdd").Item
        dataTable.Add "item_desc", Request.Form("txtItemDescAdd").Item
        dataTable.Add "unit_price", Request.Form("txtItemAmountAdd").Item
        dataTable.Add "item_def", "Custom"
        dataTable.Add "item_type", "Service"
        
        SQL = "SELECT * FROM item_cost WHERE elt_account_number=" _
            & elt_account_number & " AND item_name='" & dataTable("item_name") & "'"
        
        If IsDataExist(SQL) Then
            Response.Write("<script>alert('Item Code - " & dataTable("item_name") & " already exists.');</script>")
        Else
            Set feData = new DataManager
            feData.SetColumnKeys("item_cost")
            feData.UpdateDBRow SQL, dataTable
        End If
    End Sub
    
    Sub UpdateItem
        Dim feData, SQL, vNewItemNo, updateID
        updateID = Request.QueryString("id")
        Set dataTable = Server.CreateObject("System.Collections.HashTable")
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "item_desc", Request.Form("txtItemDescAdd").Item
        dataTable.Add "unit_price", Request.Form("txtItemAmountAdd").Item
        
        SQL = "SELECT * FROM item_cost WHERE elt_account_number=" _
            & elt_account_number & " AND item_no=" & updateID
        Set feData = new DataManager
        feData.SetColumnKeys("item_cost")
        feData.UpdateDBRow SQL, dataTable
    End Sub
    
    Sub DeleteItem
        Dim deleteID, SQL
        deleteID = Request.QueryString("id")
        If Not IsItemLocked(deleteID) Then
            SQL = "DELETE FROM item_cost WHERE elt_account_number=" & elt_account_number & " AND item_no=" & deleteID
            eltConn.execute(SQL)
        Else
            Response.Write("<script>alert('Cannot delete the item code. It has been used already.');</script>")
        End If
    End Sub
    
    Sub GetAllItems
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM item_cost WHERE elt_account_number=" & elt_account_number & " ORDER BY item_name"
        feData.SetDataList(SQL)
        Set aAllData = feData.getDataList
    End Sub
    
    Sub SetupItems
        Dim SQL
        SQL = "If NOT EXISTS (SELECT * FROM item_cost WHERE elt_account_number=" & elt_account_number _
            & ") INSERT INTO item_cost (elt_account_number, item_no, item_name, item_type, item_desc, item_def) " _
            & "SELECT '" & elt_account_number & "',item_no,item_name,item_type,item_desc,item_def FROM item_cost AS item_cost_copy where elt_account_number=10001000"
        eltConn.Execute SQL
    End Sub
    
    Function IsItemLocked(vItemCode)
        Dim vRecordCount, SQL
        SQL = "SELECT (SELECT COUNT(item_no) FROM invoice_cost_item WHERE elt_Account_number=" & elt_account_number & " AND item_no=" & vItemCode & ")+" _
            & "(SELECT COUNT(item_no) FROM mb_cost_item WHERE elt_Account_number=" & elt_account_number & " AND item_no=" & vItemCode & ")+" _
            & "(SELECT COUNT(default_air_cost_item) FROM user_profile WHERE elt_Account_number=" & elt_account_number & " AND default_air_cost_item=" & vItemCode & ")+" _
            & "(SELECT COUNT(default_ocean_cost_item) FROM user_profile WHERE elt_Account_number=" & elt_account_number & " AND default_ocean_cost_item=" & vItemCode & ")"
        vRecordCount = GetSQLResult(SQL,Null)
        If vRecordCount > 0 Then
            IsItemLocked = True
        Else
            IsItemLocked = False
        End If
    End Function
    
    %>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1 {color: #663366}
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        a:hover {
	        color: #CC3300;
        }
    </style>

    <script type="text/jscript">
        function AddNewItem(){
            if(document.getElementById("txtItemNameAdd").value == "" || document.getElementById("txtItemDescAdd").value == ""){
                alert("Please, enter a item name and description.");
                return false;
            }
            var oForm = document.getElementById("form1");
            oForm.action = "cost_items.asp?mode=add";
            oForm.target = "_self";
            oForm.method = "post";
            oForm.submit();
        }
        
        function DeleteItem(arg){
            if(confirm("Are you sure you want to delete this item? Press OK to contnue.")){
                var oForm = document.getElementById("form1");
                oForm.action = "cost_items.asp?mode=delete&id=" + arg;
                oForm.target = "_self";
                oForm.method = "post";
                oForm.submit();
            }
        }
        
        function UpdateItem(i,arg){
            var oForm = document.getElementById("form1");
            document.getElementById("txtItemNameAdd").value = document.getElementById("txtItemName"+i).value;
            document.getElementById("txtItemDescAdd").value = document.getElementById("txtItemDesc"+i).value;
            document.getElementById("txtItemAmountAdd").value = document.getElementById("txtItemAmount"+i).value;
            
            oForm.action = "cost_items.asp?mode=update&id=" + arg;
            oForm.target = "_self";
            oForm.method = "post";
            oForm.submit();
        }
        
    </script>

    <script type="text/javascript" src="../include/tooltips.js"></script>

</head>
<body>
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form id="form1" action="">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <div style="text-align: center">
            <table style="width: 95%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td valign="middle" class="pageheader">
                        Cost Items
                    </td>
                </tr>
            </table>
        </div>
        <div style="text-align: center">
            <table style="border: solid 1px #73beb6; width: 95%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table style="width: 100%" border="0" cellpadding="0" cellspacing="0">
                            <tr style="background-color: #ecf7f8; height: 20px" class="bodyheader">
                                <td style="width: 10px">
                                </td>
                                <td>
                                    Code
                                </td>
                                <td>
                                    Description
                                </td>
                                <td></td>
                                <td>
                                    Amount
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                                <td style="width: 10px">
                                </td>
                            </tr>
                            <tr style="background-color:#ccebed">
                                <td colspan="9" style="height: 8px">
                                </td>
                            </tr>
                            <tr style="background-color:#73beb6">
                                <td colspan="9" style="height: 1px">
                                </td>
                            </tr>
                            <tr style="background-color:#f3f3f3">
                                <td style="width: 10px">
                                </td>
                                <td>
                                    <input type="text" id="txtItemNameAdd" name="txtItemNameAdd" value="" class="shorttextfield"
                                        style="width: 100px" />
                                </td>
                                <td>
                                    <input type="text" id="txtItemDescAdd" name="txtItemDescAdd" value="" class="shorttextfield"
                                        style="width: 300px" />
                                </td>
                                <td></td>
                                <td>
                                    <input type="text" id="txtItemAmountAdd" name="txtItemAmountAdd" value="" class="shorttextfield"
                                        style="behavior: url(../include/igNumChkRight.htc); width: 100px" />
                                </td>
                                <td>
                                    <img src="../images/button_add_bold.gif" style="cursor: hand" alt="" onclick="AddNewItem()" />
                                </td>
                                <td>
                                </td>
                                <td style="width: 10px">
                                </td>
                            </tr>
                            <tr style="background-color: #73beb6">
                                <td colspan="9" style="height: 1px">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="9" style="height: 10px">
                                </td>
                            </tr>
                            <% For i = 0 To aAllData.Count-1 %>
                            <tr>
                                <td style="width: 10px">
                                </td>
                                <td>
                                    <input type="text" id="txtItemName<%=i %>" name="txtItemName" value="<%=aAllData(i)("item_name") %>"
                                        readonly="readonly" class="d_shorttextfield" style="width: 100px" />
                                </td>
                                <td>
                                    <input type="text" id="txtItemDesc<%=i %>" name="txtItemDesc" value="<%=aAllData(i)("item_desc") %>"
                                        class="shorttextfield" style="width: 300px" />
                                </td>
                                <td class="bodycopy"><% If checkBlank(aAllData(i)("account_expense"),"")<>"" And agent_status = "A" Then %>Accounting Enabled<% End If %></td>
                                <td>
                                    <input type="text" id="txtItemAmount<%=i %>" name="txtItemAmount" value="<%=ConvertAnyValue(aAllData(i)("unit_price"),"Amount","") %>"
                                        class="shorttextfield" style="behavior: url(../include/igNumChkRight.htc);
                                        width: 100px" />
                                </td>
                                <td>
                                    <img src="../images/button_delete.gif" style="cursor: hand" alt="" onclick="DeleteItem(<%=aAllData(i)("item_no") %>)" />
                                </td>
                                <td>
                                    <img src="../images/button_update.gif" style="cursor: hand" alt="" onclick="UpdateItem(<%=i %>,<%=aAllData(i)("item_no") %>)" />
                                </td>
                                <td style="width: 10px">
                                </td>
                            </tr>
                            <% Next %>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #ffffff; height: 10px">
                    </td>
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #73beb6; height: 1px">
                    </td>
                </tr>
                <tr>
                    <td colspan="9" style="background-color: #ccebed; height: 20px">
                        &nbsp;</td>
                </tr>
            </table>
        </div>
        <br />
    </form>
</body>
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
