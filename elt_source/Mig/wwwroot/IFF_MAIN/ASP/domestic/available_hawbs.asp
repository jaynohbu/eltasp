<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
<% 
    Dim aHAWBList,vMAWB,vMAWBType,vIsDome,i,j,keyArray,vMode,aHAWBIncList
    
    vMAWBType = checkBlank(Request.QueryString.Item("MT"),"")
    vIsDome = checkBlank(Request.QueryString.Item("ISDOME"),"N")
    vMAWB = checkBlank(Request.QueryString.Item("MAWB"),"")
    vMode = checkBlank(Request.QueryString.Item("MODE"),"LIST")
    
    If checkBlank(vMAWB,"") = "" Then
        Response.Write("<script>alert('Master bill was not selected'); window.close(); </script>")
    End If
    
    If vMode = "SAVE" Then
       update_hawbs()
       update_hawb_weights()
    End If 
    Set aHAWBList = get_available_hawbs 
    Set aHAWBIncList = get_included_hawbs
    
    Function get_available_hawbs()
        Dim SQL,dataObj
        SQL= "SELECT a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_name,a.Consignee_name, " _
            & "b.tran_no,b.no_pieces,b.rate_class,b.kg_lb,b.gross_weight,b.adjusted_weight,b.chargeable_weight,b.dimension " _
            & "FROM hawb_master a INNER JOIN hawb_weight_charge b " _
            & " ON (a.elt_account_number=b.elt_account_number) AND (a.hawb_num=b.hawb_num) " _
            & " WHERE (a.elt_account_number=" & elt_account_number & " OR a.coloder_elt_acct=" & elt_account_number _
            & ") AND ISNULL(a.is_sub,'N')='N' and a.MAWB_NUM = '' AND NOT (a.elt_account_number=" _
            & elt_account_number & " AND isnull(colo,'')= 'Y') AND NOT (ISNULL(a.is_master,'N')='Y' " _
            & "AND a.sub_count <= 0) AND a.is_dome='" & vIsDome & "' ORDER BY a.hawb_num,b.tran_no" 
	
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        keyArray = dataObj.GetKeyArray()

        Set get_available_hawbs = dataObj.GetDataList()
        
    End Function
    
    Function get_included_hawbs()
        Dim SQL,dataObj
        SQL= "SELECT a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_name,a.Consignee_name, " _
            & "b.tran_no,b.no_pieces,b.rate_class,b.kg_lb,b.gross_weight,b.adjusted_weight,b.chargeable_weight,b.dimension " _
            & "FROM hawb_master a INNER JOIN hawb_weight_charge b " _
            & " ON (a.elt_account_number=b.elt_account_number) AND (a.hawb_num=b.hawb_num) " _
            & " WHERE (a.elt_account_number=" & elt_account_number & " OR a.coloder_elt_acct=" & elt_account_number _
            & ") AND ISNULL(a.is_sub,'N')='N' and a.MAWB_NUM = '" & vMAWB & "' AND NOT (a.elt_account_number=" _
            & elt_account_number & " AND isnull(colo,'')= 'Y') AND NOT (ISNULL(a.is_master,'N')='Y' " _
            & "AND a.sub_count <= 0) AND a.is_dome='" & vIsDome & "' ORDER BY a.hawb_num,b.tran_no" 
	
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        keyArray = dataObj.GetKeyArray()

        Set get_included_hawbs = dataObj.GetDataList()
    End Function 
    
    Function update_hawbs()
        Dim hawbList,i,rs,SQL
        
        '// Initially Set mawb numbers to nothing
        For i=1 To Request.Form.Item("hHAWB").Count
            SQL = "UPDATE hawb_master set mawb_num='', adjusted_weight=" _
                & Request.Form.Item("txtAdjustedWeight")(i) & " WHERE hawb_num='" _
                & Request.Form.Item("hHAWB")(i) & "' AND elt_account_number=" & elt_account_number
            
            Set rs = Server.CreateObject("ADODB.Recordset")
            Set rs = eltConn.execute(SQL)
        Next

        '// added hawb_num will have mawb_num
        For i=1 To Request.Form.Item("hHAWB").Count
            If Request.Form.Item("chkHAWB")(i) = "added" Then
                SQL = "UPDATE hawb_master set mawb_num='" & vMAWB & "', adjusted_weight=" _
                    & Request.Form.Item("txtAdjustedWeight")(i) & " WHERE hawb_num='" _
                    & Request.Form.Item("hHAWB")(i) & "' AND elt_account_number=" & elt_account_number
                
                Set rs = Server.CreateObject("ADODB.Recordset")
                Set rs = eltConn.execute(SQL)
            End If
        Next
    End Function
    
    Function update_hawb_weights
        Dim hawbList,i,rs,SQL

        '// added hawb_num will have mawb_num
        For i=1 To Request.Form.Item("hHAWB").Count
            If Request.Form.Item("chkHAWB")(i) = "added" Then
                SQL = "UPDATE hawb_weight_charge Set adjusted_weight=" _
                    & Request.Form.Item("txtAdjustedWeight")(i) & " WHERE hawb_num='" _
                    & Request.Form.Item("hHAWB")(i) & "' AND elt_account_number=" & elt_account_number
                
                Set rs = Server.CreateObject("ADODB.Recordset")
                Set rs = eltConn.execute(SQL)
            End If
        Next
    End Function

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CONSOLIDATION</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        <!--
        .style1 {
	        color: #000000;
	        font-weight: bold;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style9 {color: #000000}
        .style10 {color: #517595}
        .style11 {color: #663366}
        .style12 {color: #c16b42}
        .style13 {color: #CC0000}
        -->
    </style>
    <script type="text/javascript" src="../ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../include/JPED.js"></script>
    <script type="text/javascript">
    
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");
            var formObj = document.getElementById("subForm");

            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
		    
		    formObj.action = "available_hawbs.asp?MT=DG&ISDOME=Y&MAWB=" + encodeURIComponent(argV);
            formObj.method = "POST";
            formObj.target = "_self";
            formObj.submit();
        }
        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB";
            
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function SyncAWField(thisObj){
            var chkHAWBList = document.getElementsByName("chkHAWB");
            var txtAWList = document.getElementsByName("txtAdjustedWeight");
            
            for(var i=0;i<chkHAWBList.length;i++){
                if(chkHAWBList[i].uniqueID == thisObj.uniqueID){
                    txtAWList[i].style.backgroundColor = "#FFFFFF"
                    txtAWList[i].readOnly = !thisObj.checked;
                }
            }
        }
        
        function AddHAWBs(){

            var chkHAWBList = document.getElementsByName("chkHAWB");
            var txtAWList = document.getElementsByName("txtAdjustedWeight");
            var sourceTableObj = document.getElementById("tblHAWBs");
            var targetTableObj = document.getElementById("tblAddedHAWBs");
            var rowIndexArray = new Array();
            var addContent = "";
            var j = 0;
            
            for(var i=0;i<chkHAWBList.length;i++){
                if(chkHAWBList[i].checked && chkHAWBList[i].value == ""){
                    chkHAWBList[i].checked = false;
                    chkHAWBList[i].value = "added";
                    txtAWList[i].style.backgroundColor="#ffffff";
                    txtAWList[i].readOnly = false;
                    txtAWList[i].onfocusout = "calculateAll();";
                    
                    var tmpRowObj = chkHAWBList[i].parentNode.parentNode;
                    rowIndexArray[j++] = tmpRowObj.rowIndex;
                    addContent = addContent + tmpRowObj.outerHTML;
                }
            }
            
            for(i=rowIndexArray.length-1;i>=0;i--){
                sourceTableObj.deleteRow(rowIndexArray[i]);
            }
            
            targetTableObj.outerHTML = "<table class=\"bodycopy\" id=\"tblAddedHAWBs\" width=100%>" 
                + targetTableObj.firstChild.innerHTML + addContent + "</table>";
            calculateAll();
        }
        
        function removeHAWBs(){
            var chkHAWBList = document.getElementsByName("chkHAWB");
            var txtAWList = document.getElementsByName("txtAdjustedWeight");
            var sourceTableObj = document.getElementById("tblAddedHAWBs");
            var targetTableObj = document.getElementById("tblHAWBs");
            var rowIndexArray = new Array();
            var addContent = "";
            var j = 0;
            
            for(var i=0;i<chkHAWBList.length;i++){
                if(chkHAWBList[i].checked && chkHAWBList[i].value == "added"){
                    chkHAWBList[i].checked = false;
                    chkHAWBList[i].value = "";
                    txtAWList[i].style.backgroundColor="#cccccc";
                    txtAWList[i].readOnly = true;
                    
                    var tmpRowObj = chkHAWBList[i].parentNode.parentNode;
                    rowIndexArray[j++] = tmpRowObj.rowIndex;
                    addContent = addContent + tmpRowObj.outerHTML;
                }
            }
            
            for(i=rowIndexArray.length-1;i>=0;i--){
                sourceTableObj.deleteRow(rowIndexArray[i]);
            }
            
            targetTableObj.outerHTML = "<table class=\"bodycopy\" id=\"tblHAWBs\" width=100%>" 
                + targetTableObj.firstChild.innerHTML + addContent + "</table>";
            calculateAll();
        }
        
        function calculateAll(){
            var hPiecesList = document.getElementsByName("hPieces");
            var hGWList = document.getElementsByName("hGrossWeight");
            var hAWList = document.getElementsByName("txtAdjustedWeight");
            var hDWList = document.getElementsByName("hDimWeight");
            var hCWList = document.getElementsByName("hChargeWeight");
            var chkHAWBList = document.getElementsByName("chkHAWB");
            
            
            var totalPieces = totalGW = totalAW = totalDW = totalCW = 0;
            
            for(var i=0;i<chkHAWBList.length;i++){
                if(chkHAWBList[i].value == "added"){
                    totalPieces = totalPieces + parseInt(hPiecesList[i].value);
                    totalGW = totalGW + parseFloat(hGWList[i].value);
                    totalAW = totalAW + parseFloat(hAWList[i].value);
                    totalDW = totalDW + parseFloat(hDWList[i].value);
                    totalCW = totalCW + parseFloat(hCWList[i].value);
                }
            }
            
            document.getElementById("txtTotalPieces").value = totalPieces;
            document.getElementById("txtTotalGrossWeight").value = totalGW;
            document.getElementById("txtTotalAdjustedWeight").value = totalAW;
            document.getElementById("txtTotalDimWeight").value = totalDW;
            document.getElementById("txtTotalChargeWeight").value = totalCW;
            
            if(totalCW != 0){
                document.getElementById("txtPercentGrossWeight").value = (totalGW/totalCW*100).toFixed(0);
                document.getElementById("txtPercentAdjustedWeight").value = (totalAW/totalCW*100).toFixed(0);
                document.getElementById("txtPercentDimWeight").value = (totalDW/totalCW*100).toFixed(0);
                document.getElementById("txtPercentChargeWeight").value = 100;
            }
            else{
                document.getElementById("txtPercentGrossWeight").value = "";
                document.getElementById("txtPercentAdjustedWeight").value = "";
                document.getElementById("txtPercentDimWeight").value = "";
                document.getElementById("txtPercentChargeWeight").value = "";
            }
        }
        
        function SaveChanges(){
            var childForm = document.getElementById("subForm")
            var chkHAWBList = document.getElementsByName("chkHAWB");
            
            try{
                var parentForm = self.opener.document.frmMAWB;
                parentForm.all("txtPiece").value = childForm.all("txtTotalPieces").value;
                parentForm.all("txtGrossWeight").value = childForm.all("txtTotalAdjustedWeight").value;
                parentForm.all("txtCubicWeight").value = childForm.all("txtTotalDimWeight").value;
                parentForm.all("txtChargeableWeight").value = childForm.all("txtTotalChargeWeight").value;
                parentForm.all("hDimDetail").value = "";
                parentForm.all("hDimFactor").value = "";
                parentForm.all("txtCubicInches").value = 0;
            }
            catch(err){}
            
            for(var i=0;i<chkHAWBList.length;i++){
                chkHAWBList[i].checked = true;
            }
                
            childForm.target = "_self";
            childForm.method = "POST";
            childForm.action = "available_hawbs.asp?MODE=SAVE&MAWB=<%=vMAWB %>&ISDOME=<%=vIsDome %>&MT=<%=vMAWBType %>";
            childForm.submit();
        }
        
    </script>

</head>
<body link="336699" vlink="336699" bgcolor="#efefef" topmargin="0" onLoad="self.focus(); calculateAll();">
    <form id="subForm">
            <table class="bodycopy" width="100%">
            <tr>
                <td colspan="20" style="height: 20px; vertical-align: bottom">
                    <b>AVAILABLE HOUSES</b>
                </td>
            </tr>
        </table>
        <div style="overflow-y: scroll; height: 250px; background-color:#FFFFFF" >

            <table class="bodycopy" id="tblHAWBs" width="100%">
                <tr style="color:#FFFFFF; background-color:#7a7a7a; font-weight:bold; text-align:center">
                    <td width="3%">
                    </td>
                    <td width="10%">
                        HAWB</td>
                    <td width="19%">
                        Agent</td>
                    <td width="19%">
                        Shipper</td>
                    <td width="19%">
                        Consignee</td>
                    <td width="5%">
                        Pieces</td>
                    <td width="5%">
                        Scale</td>
                    <td width="5%">
                        Gross Weight</td>
                    <td width="5%">
                        Adjusted Weight</td>
                    <td width="5%">
                        Dimnsional Weight</td>
                    <td width="5%">
                        Chargeable Weight</td>
                </tr>
                <% For i=0 To aHAWBList.count-1%>
                <tr>
                    <td>
                        <input type="checkbox" name="chkHAWB" class="bodycopy" value="" /></td>
                    <td>
                        <a href="new_edit_hawb.asp?mode=search&HAWB=<%=aHAWBList(i)("hawb_num") %>" target="_blank">
                            <%=aHAWBList(i)("hawb_num") %>
                            <input type="hidden" name="hHAWB" value="<%=aHAWBList(i)("hawb_num") %>" />
                        </a>
                    </td>
                    <td>
                        <%=aHAWBList(i)("agent_name") %>
                    </td>
                    <td>
                        <%=aHAWBList(i)("Shipper_name") %>
                    </td>
                    <td>
                        <%=aHAWBList(i)("Consignee_name") %>
                    </td>
                    <td>
                        <%=aHAWBList(i)("no_pieces") %>
                        <input type="hidden" name="hPieces" value="<%=aHAWBList(i)("no_pieces") %>" />
                    </td>
                    <td>
                        <%=aHAWBList(i)("kg_lb") %>
                    </td>
                    <td>
                        <%=aHAWBList(i)("gross_weight") %>
                        <input type="hidden" name="hGrossWeight" value="<%=aHAWBList(i)("gross_weight") %>" />
                    </td>
                    <td>
                        <input type="text" class="d_shorttextfield" size="10" name="txtAdjustedWeight" value="<%=aHAWBList(i)("adjusted_weight") %>"
                            readonly="readonly" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                    </td>
                    <td>
                        <%=aHAWBList(i)("dimension") %>
                        <input type="hidden" name="hDimWeight" value="<%=aHAWBList(i)("dimension") %>" />
                    </td>
                    <td>
                        <%=aHAWBList(i)("chargeable_weight") %>
                        <input type="hidden" name="hChargeWeight" value="<%=aHAWBList(i)("chargeable_weight") %>" />
                    </td>
                </tr>
                <% Next %>
            </table>
        </div>
        <table class="bodycopy" width="100%">
            <tr>
                <td colspan="20" style="height: 30px; vertical-align: bottom">
                    <input type="button" value="Add >>" onclick="AddHAWBs()" />
                    <input type="button" value="<< Remove" onclick="removeHAWBs()" />
                </td>
            </tr>
            <tr>
                <td colspan="20" style="height: 30px; vertical-align: bottom">
                    <!-- Start JPED -->
                        <input type="hidden" id="hSearchNum" name="hSearchNum" value="<%=vMAWB %>"/>
                        <div id="lstSearchNumDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="bodycopy"><b>INCLUDED HOUSES FOR&nbsp;&nbsp;</b>
                                </td>
                                <td>
                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value="<%=vMAWB %>"
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="searchNumFill(this,'lstSearchNumChange',200);"
                                        onfocus="initializeJPEDField(this);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                        
                </td>
            </tr>
        </table>
        <div style="overflow-y: scroll; height: 150px; background-color:#FFFFFF">
            <table class="bodycopy" id="tblAddedHAWBs" width="100%">
                <tr style="color:#FFFFFF; background-color:#7a7a7a; font-weight:bold; text-align:center">
                    <td width="3%"></td>
                    <td width="10%">
                        HAWB</td>
                    <td width="19%">
                        Agent</td>
                    <td width="19%">
                        Shipper</td>
                    <td width="19%">
                        Consignee</td>
                    <td width="5%">
                        Pieces</td>
                    <td width="5%">
                        Scale</td>
                    <td width="5%">
                        Gross Weight</td>
                    <td width="5%">
                        Adjusted Weight</td>
                    <td width="5%">
                        Dimnsional Weight</td>
                    <td width="5%">
                        Chargeable Weight</td>
                </tr>
                <% For i=0 To aHAWBIncList.count-1%>
                <tr>
                    <td>
                        <input type="checkbox" name="chkHAWB" class="bodycopy" value="added" /></td>
                    <td>
                        <a href="new_edit_hawb.asp?mode=search&HAWB=<%=aHAWBIncList(i)("hawb_num") %>" target="_blank">
                            <%=aHAWBIncList(i)("hawb_num") %>
                            <input type="hidden" name="hHAWB" value="<%=aHAWBIncList(i)("hawb_num") %>" />
                        </a>
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("agent_name") %>
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("Shipper_name") %>
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("Consignee_name") %>
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("no_pieces") %>
                        <input type="hidden" name="hPieces" value="<%=aHAWBIncList(i)("no_pieces") %>" />
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("kg_lb") %>
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("gross_weight") %>
                        <input type="hidden" name="hGrossWeight" value="<%=aHAWBIncList(i)("gross_weight") %>" />
                    </td>
                    <td>
                        <input type="text" class="m_shorttextfield" size="10" name="txtAdjustedWeight" value="<%=aHAWBIncList(i)("adjusted_weight") %>"
                            style="behavior: url(../include/igNumDotChkLeft.htc)" onfocusout="calculateAll();" />
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("dimension") %>
                        <input type="hidden" name="hDimWeight" value="<%=aHAWBIncList(i)("dimension") %>" />
                    </td>
                    <td>
                        <%=aHAWBIncList(i)("chargeable_weight") %>
                        <input type="hidden" name="hChargeWeight" value="<%=aHAWBIncList(i)("chargeable_weight") %>" />
                    </td>
                </tr>
                <% Next %>
            </table>
        </div>
        <table class="bodycopy">
            <tr bgcolor="efefef">
                <td>
                </td>
                <td>
                    Pieces</td>
                <td>
                    Gross Weight</td>
                <td>
                    Adjusted Weight</td>
                <td>
                    Dimnsional Weight</td>
                <td>
                    Chargeable Weight</td>
            </tr>
            <tr>
                <td>
                    <b>Total&nbsp;</b></td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtTotalPieces" name="txtTotalPieces"
                        readonly="readonly" /></td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtTotalGrossWeight" name="txtTotalGrossWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtTotalAdjustedWeight" name="txtTotalAdjustedWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtTotalDimWeight" name="txtTotalDimWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtTotalChargeWeight" name="txtTotalChargeWeight"
                        readonly="readonly" />
                </td>
            </tr>
            <tr>
                <td>
                    <b>%&nbsp;</b></td>
                <td>
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtPercentGrossWeight" name="txtPercentGrossWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtPercentAdjustedWeight" name="txtPercentAdjustedWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtPercentDimWeight" name="txtPercentDimWeight"
                        readonly="readonly" />
                </td>
                <td>
                    <input type="text" class="d_shorttextfield" id="txtPercentChargeWeight" name="txtPercentChargeWeight"
                        readonly="readonly" />
                </td>
            </tr>
        </table>
        <table class="bodycopy" width="100%">
            <tr>
                <td colspan="20" style="height: 30px; vertical-align: bottom">
                    <input type="button" value="Save" onclick="SaveChanges()" />
                    <input type="button" value="Close" onclick="window.close();" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
