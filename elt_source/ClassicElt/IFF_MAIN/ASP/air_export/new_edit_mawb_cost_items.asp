<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/Header.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<%
    Dim vMAWB, costItemList, i, vMode
    
    vMAWB = Request.QueryString("MAWB")
    vMode = checkBlank(Request.QueryString("mode"), "view")
    
    if vMode = "add" Then
        eltConn.BeginTrans
        Call AddCostItem
        vMAWB = Request.Form("hMAWBNum")
        Call UpdateTotalOtherCost
        Call GetAllCostItems
        eltConn.CommitTrans
    End If
    
    If vMode = "delete" Then
        eltConn.BeginTrans
        Call DeleteCostItem
        vMAWB = Request.Form("hMAWBNum")
        Call UpdateTotalOtherCost
        Call GetAllCostItems
        eltConn.CommitTrans
    End If
    
    Call GetAllCostItems
    
    Sub UpdateTotalOtherCost
        Dim SQL
        
        SQL = "UPDATE mawb_master SET total_other_cost=" _
            & "(SELECT SUM(cost_amt) FROM mawb_other_cost WHERE elt_account_number=" _
            & elt_account_number & " AND mawb_num=N'" & vMAWB & "') WHERE elt_account_number=" _
            & elt_account_number & " AND mawb_num=N'" & vMAWB & "'"
        
        eltConn.Execute SQL
    End Sub
    
    Sub GetAllCostItems
        Dim dataObj,SQL
        
        SQL = "SELECT * FROM mawb_other_cost a LEFT OUTER JOIN organization b ON " _
            & "(a.elt_account_number=b.elt_account_number AND b.org_account_number=a.vendor_no) " _
            & "WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.mawb_num=N'" & vMAWB & "' ORDER BY a.auto_uid"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set costItemList = dataObj.GetDataList
    End Sub
    
    Sub AddCostItem
        Dim SQL
        
        SQL = "INSERT INTO mawb_other_cost(elt_account_number,mawb_num,vendor_no,cost_amt,item_no,cost_desc) " _
            & " VALUES(" &  elt_account_number & ",N'" & Request.Form("hMAWBNum") _
            & "'," & Request.Form("hAgentAcct") & "," & Request.Form("txtCostAmt") _
            & "," & Request.Form("hCostItem") & ",N'" & Request.Form("lstCostItem") & "')"
        
        eltConn.Execute SQL
    End Sub
    
    Sub DeleteCostItem
        Dim SQL
        
        SQL = "DELETE FROM mawb_other_cost WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & Request.QueryString("did")
        
        eltConn.Execute SQL
    End Sub
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <base target="_self" />
    <title>Edit Cost Items</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <script type="text/javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../Include/JPED.js"></script>

    <script type="text/javascript">
        function lstCostItemChange(vValue,vLabel){
            var hiddenObj = document.getElementById("hCostItem");
            var txtObj = document.getElementById("lstCostItem");
            var divObj = document.getElementById("lstCostItemDiv");

            var tmpPos = vValue.indexOf("-");
            
            
            hiddenObj.value = vValue.substring(0,tmpPos);
            document.getElementById("txtCostAmt").value = vValue.substring(tmpPos+1);
            txtObj.value = vLabel;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstAgentNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hAgentAcct");
            var txtObj = document.getElementById("lstAgentName");
            var divObj = document.getElementById("lstAgentNameDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function addNewItem(){
            if(document.getElementById("hAgentAcct").value == "" 
                || document.getElementById("hAgentAcct").value == "0"){
                alert("Please, select a vendor.");
            }
            else if(document.getElementById("hCostItem").value == "" 
                || document.getElementById("hCostItem").value == "0"){
                alert("Please, select a cost item.");
            }
            else if(document.getElementById("txtCostAmt").value == "" 
                || document.getElementById("txtCostAmt").value == "0"){
                alert("Please, enter cost amount.");
            }
            else{
                document.getElementById("form1").action = "new_edit_mawb_cost_items.asp?mode=add";
                document.getElementById("form1").method = "post";
                document.getElementById("form1").submit();
            }
        }
        
        function removeItem(arg){
            document.getElementById("form1").action = "new_edit_mawb_cost_items.asp?mode=delete&did=" + arg;
            document.getElementById("form1").method = "post";
            document.getElementById("form1").submit();
        }
    </script>

</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <input type="hidden" id="hMAWBNum" name="hMAWBNum" value="<%=vMAWB %>" />
        <br />
        <div style="text-align: center">
            <table cellpadding="2" cellspacing="0" border="0" width="95%" style="text-align: left"
                class="bodycopy">
                <tr class="bodyheader">
                    <td>Vendor</td>
                    <td>Cost Item</td>
                    <td>Amount</td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <!-- Start JPED -->
                        <input type="hidden" id="hAgentAcct" name="hAgentAcct" />
                        <div id="lstAgentNameDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <input type="text" autocomplete="off" id="lstAgentName" name="lstAgentName" value=""
                                        class="shorttextfield" style="width: 180px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstAgentNameChange')"
                                        onfocus="initializeJPEDField(this);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Vendor','lstAgentNameChange')"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                    <td>
                        <!-- Start JPED -->
                        <input type="hidden" id="hCostItem" name="hCostItem" value="" />
                        <div id="lstCostItemDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <input type="text" autocomplete="off" id="lstCostItem" name="lstCostItem" value=""
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="GLItemFill(this,'ItemCost','lstCostItemChange',140)"
                                        onfocus="initializeJPEDField(this);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstCostItem','ItemCost','lstCostItemChange',140)"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                    <td>
                        <input type="text" id="txtCostAmt" name="txtCostAmt" style="behavior: url(../include/igNumDotChkLeft.htc);
                            width: 80px" class="numberfield" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: right">
                        <a href="javascript:;" onclick="addNewItem(); return false;">Add Item</a>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="color: red">
                        <%=costItemList.Count %>
                        Item(s) included
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="height: 5px">
                    </td>
                </tr>
                <% For i = 0 To costItemList.Count-1  %>
                <tr>
                    <td>
                        <%=costItemList(i)("dba_name") %>
                    </td>
                    <td>
                        <%=costItemList(i)("cost_desc") %>
                    </td>
                    <td>
                        <%=costItemList(i)("cost_amt") %>
                    </td>
                    <td>
                        <a href="javascript:;" onclick="removeItem(<%=costItemList(i)("auto_uid") %>); return false;">
                            Delete Item</a>
                    </td>
                </tr>
                <% Next %>
            </table>
        </div>
    </form>
</body>
</html>
