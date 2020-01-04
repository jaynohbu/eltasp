<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/Header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<%
    Dim vMAWB, creditItemList, i, vMode
    
    vMAWB = Request.QueryString("BookingNum")
    vMode = checkBlank(Request.QueryString("mode"), "view")
    
    if vMode = "add" Then
        eltConn.BeginTrans
        Call AddCreditItem
        vMAWB = Request.Form("hMAWBNum")
        Call GetAllCreditItems
        eltConn.CommitTrans
    End If
    
    If vMode = "delete" Then
        eltConn.BeginTrans
        Call DeleteCreditItem
        vMAWB = Request.Form("hMAWBNum")
        Call GetAllCreditItems
        eltConn.CommitTrans
    End If
    
    Call GetAllCreditItems
    
    Sub GetAllCreditItems
        Dim dataObj,SQL
        
        SQL = "SELECT * FROM mbol_agent_credit WHERE booking_num=N'" & vMAWB & "'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set creditItemList = dataObj.GetDataList
    End Sub
    
    Sub AddCreditItem
        Dim SQL
        
        SQL = "INSERT INTO mbol_agent_credit(elt_account_number,booking_num,charge_code,charge_desc,credit_amt,remark) " _
            & " VALUES(" &  elt_account_number & ",N'" & Request.Form("hMAWBNum") _
            & "'," & Request.Form("hChargeItem") & ",N'" & Request.Form("lstChargeItem") _
            & "'," & Request.Form("txtChargeAmt") & ",N'" & Request.Form("txtRemark") & "')"
        
        eltConn.Execute SQL
    End Sub
    
    Sub DeleteCreditItem
        Dim SQL
        
        SQL = "DELETE FROM mbol_agent_credit WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & Request.QueryString("did")
        
        eltConn.Execute SQL
    End Sub
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <base target="_self" />
    <title>Edit Agent Credit</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../Include/JPED.js"></script>

    <script type="text/javascript">
        
        function lstChargeItemChange(vValue,vLabel){
            var hiddenObj = document.getElementById("hChargeItem");
            var txtObj = document.getElementById("lstChargeItem");
            var divObj = document.getElementById("lstChargeItemDiv");
            
            hiddenObj.value = vValue
            txtObj.value = vLabel;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
        
        function addNewItem(){

            if(document.getElementById("hChargeItem").value == "" 
                || document.getElementById("hChargeItem").value == "0"){
                alert("Please, select a credit item.");
            }
            else if(document.getElementById("txtChargeAmt").value == "" 
                || document.getElementById("txtChargeAmt").value == "0"){
                alert("Please, enter credit amount.");
            }
            else{
                document.getElementById("form1").action = "new_edit_mbol_agent_credit.asp?mode=add";
                document.getElementById("form1").method = "post";
                document.getElementById("form1").submit();
            }
        }
        
        function removeItem(arg){
            document.getElementById("form1").action = "new_edit_mbol_agent_credit.asp?mode=delete&did=" + arg;
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
                    <td>
                        Agent Credit</td>
                    <td>
                        Amount</td>
                    <td>
                        Remark</td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- Start JPED -->
                        <input type="hidden" id="hChargeItem" name="hChargeItem" value="" />
                        <div id="lstChargeItemDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <input type="text" autocomplete="off" id="lstChargeItem" name="lstChargeItem" value=""
                                        class="shorttextfield" style="width: 180px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="GLItemFill(this,'ItemChargeNameDesc','lstChargeItemChange',140)"
                                        onfocus="initializeJPEDField(this,event);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstChargeItem','ItemChargeNameDesc','lstChargeItemChange',140)"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                    <td>
                        <input type="text" id="txtChargeAmt" name="txtChargeAmt" style="behavior: url(../include/igNumDotChkLeft.htc);
                            width: 80px" class="numberfield" />
                    </td>
                    <td>
                        <input type="text" id="txtRemark" name="txtRemark" style="width: 150px" class="shorttextfield" />
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
                        <%=creditItemList.Count %>
                        Item(s) included
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="height: 5px">
                    </td>
                </tr>
                <% For i = 0 To creditItemList.Count-1  %>
                <tr>
                    <td>
                        <%=creditItemList(i)("charge_desc") %>
                    </td>
                    <td>
                        <%=FormatNumberPlus(creditItemList(i)("credit_amt"),2) %>
                    </td>
                    <td>
                        <%=creditItemList(i)("remark") %>
                    </td>
                    <td style="text-align: right">
                        <a href="javascript:;" onclick="removeItem(<%=creditItemList(i)("auto_uid") %>); return false;">
                            Delete Item</a>
                    </td>
                </tr>
                <% Next %>
            </table>
        </div>
    </form>
</body>
</html>
