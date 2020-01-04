<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/Header.asp" -->
<!--  #include VIRTUAL="/IFF_MAIN/ASP/include/recent_file.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
<%
    Dim WRTableList,i,tmpTable,dataObj,SQL,vOrgNum,vOrgName,vSONum
    
    Set WRTableList = Server.CreateObject("System.Collections.ArrayList")
    vOrgNum = checkBlank(Request.QueryString("orgAcct"),0)
    vOrgName = checkBlank(Request.QueryString("orgName"),"")
    vSONum = checkBlank(Request.QueryString("SONum"),"")
    

        SQL = "SELECT a.auto_uid,b.wr_num,b.so_num,a.shipper_acct,a.customer_acct,a.received_date," _
            & "b.item_piece_origin,b.item_piece_remain,b.item_piece_shipout,a.item_piece_remain as item_piece_available,"_
            & "a.PO_NO,a.customer_ref_no,CAST(a.item_desc AS VARCHAR) AS item_desc FROM"_
            & " warehouse_receipt a LEFT OUTER join warehouse_history b "_
            & "on (a.elt_account_number=b.elt_account_number and a.wr_num = b.wr_num) "_
            & "WHERE b.so_num=N'" & vSONum & "' And b.elt_account_number=" & elt_account_number _
            & " AND b.history_type='Ship-out Made' UNION " _
            & "SELECT a.auto_uid,a.wr_num,b.so_num,a.shipper_acct,a.customer_acct,a.received_date," _
            & "a.item_piece_origin,a.item_piece_remain,0 as item_piece_shipout,a.item_piece_remain as item_piece_available," _
            & "a.PO_NO,a.customer_ref_no,CAST(a.item_desc AS VARCHAR) AS item_desc FROM " _
            & "warehouse_receipt a right outer join warehouse_history b "_
            & "on (a.elt_account_number=b.elt_account_number and a.wr_num = b.wr_num) " _
            & "WHERE a.elt_account_number=" & elt_account_number & " and customer_acct=" & vOrgNum _
             & " and ISNULL(b.so_num,'') = '' and a.wr_num not in ("_
            & "SELECT b.wr_num FROM warehouse_history a left join warehouse_receipt b " _
            & "on (a.elt_account_number=b.elt_account_number and a.wr_num = b.wr_num) " _
            & "WHERE a.so_num=N'" & vSONum & "' And a.elt_account_number=" & elt_account_number _
            & " AND a.history_type='Ship-out Made')  and isnull(a.item_piece_remain,0) > 0"
        
        
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set WRTableList = dataObj.GetDataList()
    
    On Error Resume Next:
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Ship Out Detail</title>
    <link href="/iff_main/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        <!--
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
.style10 {color: #cc6600}
        -->
    </style>

    <script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
    
        function countChecked() {
            var count = 0;
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                if(chkObj[i].checked) count++;
            }
            return count;
        }
        
        function enableTxtPiece(chkObj,row_id) {
            var txtObj = document.getElementById("txtPiece" + row_id);
            txtObj.readOnly = !chkObj.checked;
            
            
            if(!txtObj.readOnly){
                txtObj.style.backgroundColor = "#d7d8ad";
            }
            else{
                txtObj.style.backgroundColor = "#cccccc";
                txtObj.value="";
            }
        }
        
        
        function checkPieceLimit(txtObj,availablePCS,shippedOutPCS) {

            var newPCS = parseInt(txtObj.value);
            var limitPCS = availablePCS+shippedOutPCS;
            
            if(limitPCS < newPCS){
                alert("Cannot shipout more than avaialbe quantity of " + limitPCS);
                txtObj.value = limitPCS;
            }
        }
        
        function checkAllWRs() {
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                chkObj[i].checked = true;
                txtObj[i].style.backgroundColor = "#d7d8ad";
                txtObj[i].readOnly = false;
            }
        }

        function clearAll() {
            var url = "shipout_list_update.asp?orgAcct=<%=vOrgNum %>&orgName=" 
                + encodeURIComponent("<%=vOrgName %>") + "&SONum=" + encodeURIComponent("<%=vSONum %>");
            document.location.href = url;
        }
        
        function doShipout(){

            if (countChecked() == 0) {
                
                return false;
            }
            var chkOb2
            var objPCS = document.getElementsByName("txtPiece");
            var chkObj = document.getElementsByName("chkWR");
            var updateHTML = "";
            var totalPCS = tmpPCS = 0;

            for(var i=0;i<objPCS.length;i++){
                tmpPCS = parseInt(objPCS[i].value);
                objPCS[i].readOnly = false;
                objPCS[i].value = tmpPCS;
                if(objPCS[i].value != "" && tmpPCS > 0){
                    totalPCS = totalPCS + tmpPCS;
                }
                else{
                    if (chkObj[i].checked == true){
                        alert("Please check item pieces");
                        return false;
                    }    
                }
            }
        
			document.getElementById("WRListTableHeader").style.width = "100%";
			document.getElementById("WRListTableHeader").style.border = "none";
			updateHTML = document.getElementById("WRListTableHeader").outerHTML;
			
            for(var i=0;i<objPCS.length;i++){
               // alert(updateHTML);
                var tmpTableObj = document.getElementById("WRListTable" + i);
                //document.write(tmpTableObj.outerHTML);
                if (chkObj[i].checked == true){
                    chkObj[i].style.visibility = "hidden";
                  
                    objPCS[i].readOnly = "readOnly";
                    objPCS[i].style.backgroundColor="#CCCCCC";
                    objPCS[i].onfocusout = "";
                    objPCS[i].onkeypress = "";
                    var id =$(tmpTableObj).find('input[name="txtPiece"]').attr('id');
                    var parent = $(tmpTableObj).find('input[name="txtPiece"]').parent();
                    var inp = '<input name="txtPiece" class="readonlybold" id="' + id + '" style="width: 50px; text-align: right; -ms-behavior: url(../include/igNumDotChkLeft.htc); background-color: rgb(204, 204, 204);" onfocusout="checkPieceLimit(this,2,0);" type="text" readonly="" value="' + objPCS[i].value + '" autocomplete="off"></td>';
                    parent.html(inp);
                    //alert($(tmpTableObj).html());
                    tmpTableObj.style.width = "100%";
                    tmpTableObj.style.border = "none";
                   // alert(tmpTableObj.outerHTML);
                    updateHTML = updateHTML + tmpTableObj.outerHTML;
                   
                }
            }
            
            //document.write(updateHTML);
            
            window.opener.document.getElementById("WRListDiv").innerHTML = updateHTML;
            window.opener.document.getElementById("hTempItemValue").value = document.getElementById("hCustID").value;
            window.close();
        }
        
    </script>

</head>
<body onLoad="window.focus();">
    <br />
    <center>
        <form id="form1" name="form1">
            <table width="95%" border="0" cellpadding="0" cellspacing="0" style="width: 95%">
                <tr>
                    <td height="34" colspan="5" class="bodyheader">
                        FOR ACCOUNT OF (CUSTOMER): <span class="style10">
                            <%=Request.QueryString("orgName") %>
                            <input type="hidden" id="hCustID" name="hCustID" value="<%=Request.QueryString("orgAcct") %>" />
                        </span>
                    </td>
                    <td align="right" colspan="2" class="bodyheader">
                        Ship Out No.: <span class="style10">
                            <%=vSONum %>
                        </span>
                    </td>
                </tr>
            </table>
            <table width="95%" height="18" border="0" align="center" cellpadding="0" cellspacing="0"
                bordercolor="#9e816e" bgcolor="#f4e9e0" class="border1px" id="WRListTableHeader"
                style="border-bottom: none">
                <tr class="bodyheader">
                    <td width="3%" rowspan="2">
                    </td>
                    <td width="12%" rowspan="2" height="13">
                        W/R No.
                    </td>
                    <td width="10%" rowspan="2">
                        Received Date
                    </td>
                    <td width="12%" rowspan="2">
                        Customer Ref No.
                    </td>
                    <td width="10%" rowspan="2">
                        P.O. No.
                    </td>
                    <td width="22%" rowspan="2">
                        Descriptions</td>
                    <td colspan="3" align="center" style="border-left: 1px solid #9e816e; border-bottom: 1px solid #9e816e">
                        NO. OF QTY<span class="style10"></span></td>
                </tr>
                <tr class="bodyheader">
                    <td width="7%" align="center" style="border-left: 1px solid #9e816e">
                        Received
                    </td>
                    <td width="7%" align="center" style="border-left: 1px solid #9e816e">
                        Remaining</td>
                    <td width="7%" align="center" style="border-left: 1px solid #9e816e">
                        <span class="style10">Ship Out</span></td>
                </tr>
                <tr>
                    <td height="1" colspan="9" bgcolor="#9e816e">
                    </td>
                </tr>
            </table>
            <% For i=0 To WRTableList.Count-1 %>
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                class="border1px" id="WRListTable<%=i %>" style="width: 95%; border-bottom: none;
                border-top: none">
                <tr id='Row<%=WRTableList(i)("auto_uid") %>' align="left">
                    <td width="3%" align="left">
                        <input type="checkbox" name="chkWR" id="chkWR<%=WRTableList(i)("auto_uid") %>" class="bodycopy"
                            onclick="enableTxtPiece(this,<%=WRTableList(i)("auto_uid") %>)" value="<%=WRTableList(i)("auto_uid") %>"
                            <% If checkBlank(WRTableList(i)("so_num"),"") <> "" Then Response.Write("checked") %> />
                        <input type="hidden" name="hWRNum" value="<%=WRTableList(i)("wr_num") %>" />
                        <input type="hidden" name="hWRValue" value="<%=WRTableList(i)("auto_uid") %>" />
                        <input type="hidden" name="hAvailablePiece" value="<%=WRTableList(i)("item_piece_available") %>" />
                        <input type="hidden" name="txtOriginPiece" id="txtOriginPiece<%=WRTableList(i)("auto_uid") %>"
                            value="<%=WRTableList(i)("item_piece_origin")%>" />
                        <input type="hidden" name="txtRemainPiece" id="txtRemainPiece<%=WRTableList(i)("auto_uid") %>"
                            value="<%=WRTableList(i)("item_piece_remain")%>" />
                        <input type="hidden" name="txtShippedPiece" id="txtShippedPiece<%=WRTableList(i)("auto_uid") %>"
                            value="<%=WRTableList(i)("item_piece_shipout")%>" />
                    </td>
                    <td width="12%" align="left">
                        <%=WRTableList(i)("wr_num") %>
                    </td>
                    <td width="10%">
                        <%=WRTableList(i)("received_date") %>
                    </td>
                    <td width="12%" align="left">
                        <%=WRTableList(i)("customer_ref_no") %>
                    </td>
                    <td width="10%">
                        <%=WRTableList(i)("PO_NO") %>
                    </td>
                    <td width="22%" align="left">
                        <%=WRTableList(i)("item_desc") %>
                    </td>
                    <td width="7%" align="right" style="padding-right: 10px">
                        <%=WRTableList(i)("item_piece_origin")%>
                    </td>
                    <td width="7%" align="right" style="padding-right: 10px">
                        <%=CInt(WRTableList(i)("item_piece_remain")) + CInt(WRTableList(i)("item_piece_shipout"))%>
                    </td>
                    <td width="7%" align="right" style="padding-right: 10px">
                        <input type="text" name="txtPiece" id="txtPiece<%=WRTableList(i)("auto_uid") %>"
                            autocomplete="off" class="readonlybold"
                            <% If checkBlank(WRTableList(i)("so_num"),"") = "" Then Response.Write("readOnly='readOnly'") %>
                            <% If checkBlank(WRTableList(i)("so_num"),"") <> "" Then Response.Write("style='background-color:#d7d8ad'") %>
                            onfocusout="checkPieceLimit(this,<%=WRTableList(i)("item_piece_available") %>,<%=WRTableList(i)("item_piece_shipout") %>);"
                            style="behavior: url(../include/igNumDotChkLeft.htc); width:50px; text-align:right" value="<%=WRTableList(i)("item_piece_shipout") %>" /></td>
                </tr>
            </table>
            <% Next %>
            <table width="95%" height="20" border="0" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                bgcolor="#e5cfbf" class="border1px">
                <tr>
                    <td width="155" align="left" valign="middle" style="padding-left: 3px">
                        <img src="/IFF_MAIN/ASP/Images/button_selectall.gif" alt="Select all" width="61"
                            height="17" style="margin-right: 28px; cursor: hand" onClick="javascript:checkAllWRs();" />
                        <img src="/IFF_MAIN/ASP/Images/button_clear.gif" alt="Clear all" width="56" height="17"
                            style="cursor: hand" onClick="javascript:clearAll();" /></td>
                    <td height="24" align="center" valign="middle">
                        <img src="/IFF_MAIN/ASP/Images/button_shipout.gif" alt="Ship out" width="74" height="18"
                            style="margin-right: 145px; cursor: hand" onClick="javascript:doShipout();" /></td>
                </tr>
            </table>
        </form>
    </center>
</body>
</html>
