<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>EDT Import Step 2</title>
    <style type="text/css">
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
    </style>

    <script type="text/javascript" language="javascript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>

    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
    <!--  #INCLUDE FILE="../include/Goofy_data_manager.inc" -->
    <%
    Dim i, vDataTable, vHAWB, vMAWB, vSec, vMode, vInvoiceNo
    
    Call GET_ALL_PARAMETERS
    
    If vMode = "save" Then
        eltConn.BeginTrans()
        Call CREATE_INVOICE_HEADER
        Call UPDATE_EDT_HAWB
        eltConn.CommitTrans()
        eltConn.Close()
        Set eltConn = Nothing
        
        Response.Redirect("arrival_notice.asp?iType=O&Edit=yes&MAWB=" & Server.URLEncode(vMAWB) & "&HAWB=" & Server.URLEncode(vHAWB) & "&Sec=" & vSec)
    Else
        Call GET_ALL_DATA
    End If
    
    Sub CREATE_INVOICE_HEADER
        Dim rs, SQL, feData, tmpMAWBTable
        
        Set rs=Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT MAX(invoice_no)+1 FROM invoice WHERE elt_account_number=" & elt_account_number
        vInvoiceNo = GetSQLResult(SQL, Null)
        
        Set feData = new DataManager
        SQL = "SELECT * FROM import_mawb WHERE iType='O' AND mawb_num=N'" & Request.Form("txtMAWB").Item _
            & "' AND sec=" & Request.Form("hSec").Item & " AND agent_org_acct=" & Request.Form("hAgentOrgAcct").Item _
            & " AND elt_account_number=" & elt_account_number
        feData.SetDataList(SQL)
        Set tmpMAWBTable = feData.GetDataList()(0)
        
        SQL= "SELECT Top 0 * FROM invoice "
        rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

        rs.AddNew()
        rs("invoice_no") = vInvoiceNo
        rs("elt_account_number") = elt_account_number
        rs("Invoice_type") = "I"
        rs("import_export") = "I"
        rs("air_ocean") = "O"
        rs("Invoice_Date") = Now()  	  	
        rs("ref_no_Our") = tmpMAWBTable("file_no")
        rs("Customer_Info") = Request.Form("txtConsigneeInfo").Item
        rs("Customer_Number") = Request.Form("hConsigneeAcct").Item
        rs("Customer_Name") = Request.Form("lstConsigneeName").Item
        rs("shipper") = Request.Form("lstShipperName").Item
        rs("consignee") = Request.Form("lstConsigneeName").Item
        rs("origin") = tmpMAWBTable("dep_code")
        rs("dest") = tmpMAWBTable("arr_code")
        rs("Origin_Dest") = tmpMAWBTable("dep_code") & "/" & tmpMAWBTable("arr_code")
        rs("Carrier") = tmpMAWBTable("vessel_name") & "/" & tmpMAWBTable("voyage_no")
        rs("Arrival_Dept") = tmpMAWBTable("eta") & "--" & tmpMAWBTable("etd")
        rs("MAWB_NUM") = Request.Form("txtMAWB").Item
        rs("HAWB_NUM") = Request.Form("txtHAWB").Item
        rs("SubTotal") = 0
        rs("Sale_Tax") = 0      
        rs("Agent_Profit") = 0
        rs("amount_charged") = 0
        rs("total_cost")=0
        rs("amount_paid") = 0
	    rs("balance") = 0
		rs("lock_ar") = "N"
		rs("lock_ap") = "N"
		
		rs("ref_no") = ""
		rs("total_pieces") = ""
		rs("total_gross_weight") = ""
		rs("total_charge_weight") = ""
		rs("description") = ""
		rs("remarks") = ""
		rs("term_curr") = ""
        rs.Update    

        rs.Close 
        Set rs = Nothing
    End Sub
    
    Sub GET_ALL_PARAMETERS
        vMAWB = Request.QueryString("MAWB")
        vHAWB = Request.QueryString("HAWB")
        vSec = Request.QueryString("SEC")
        vMode = checkBlank(Request.QueryString("mode"),"view")
    End Sub
    
    Sub GET_ALL_DATA
        Dim SQL, feData
        Set feData = new DataManager
        SQL = "SELECT * FROM import_hawb WHERE iType='O' AND agent_elt_acct<>0 AND processed='N' AND mawb_num=N'" _
            & vMAWB & "' AND hawb_num=N'" & vHAWB & "' AND sec=" & vSec & " AND elt_account_number=" & elt_account_number
        feData.SetDataList(SQL)
        Set vDataTable = feData.GetDataList()(0)
    End Sub
    
    Sub UPDATE_EDT_HAWB
        Dim SQL, rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
        
        vMAWB = Request.Form("txtMAWB")
        vHAWB = Request.Form("txtHAWB")
        vSec = Request.Form("hSec")
        
        SQL = "SELECT * FROM import_hawb WHERE iType='O' AND agent_elt_acct<>0 AND processed='N' AND mawb_num=N'" _
            & vMAWB & "' AND hawb_num=N'" & vHAWB & "' AND sec=" & vSec & " AND elt_account_number=" & elt_account_number
        
        
        rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
        If Not rs.EOF And Not rs.BOF Then
            rs("shipper_name") = Request.Form("lstShipperName").Item
            rs("shipper_acct") = Request.Form("hShipperAcct").Item
            rs("shipper_info") = Request.Form("txtShipperInfo").Item
            rs("consignee_name") = Request.Form("lstConsigneeName").Item
            rs("consignee_acct") = Request.Form("hConsigneeAcct").Item
            rs("consignee_info") = Request.Form("txtConsigneeInfo").Item
            rs("notify_name") = Request.Form("lstNotifyName").Item
            rs("notify_acct") = Request.Form("hNotifyAcct").Item
            rs("notify_info") = Request.Form("txtNotifyInfo").Item
            rs("processed") = "Y"
            rs("invoice_no") = vInvoiceNo
            rs.Update()
        End If
        rs.Close()
        Set rs = Nothing
            
    End Sub
    %>

    <script type="text/jscript">
    
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstConsigneeNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    lstNotifyNameChange(orgNum,orgName);
        }

        function lstNotifyNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hNotifyAcct");
            var infoObj = document.getElementById("txtNotifyInfo");
            var txtObj = document.getElementById("lstNotifyName");
            var divObj = document.getElementById("lstNotifyNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
        }
        function getOrganizationInfo(orgNum)
        {
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

            var url="../ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseText; 
        }
        function btnSaveClick(){
        
            vConsigneeAcct = document.getElementById("hConsigneeAcct").value;
            
            if(vConsigneeAcct != "" && vConsigneeAcct != "0"){
                var oForm = document.getElementById("form1");
                oForm.action = "ocean_import2B.asp?mode=save";
                oForm.target = "_self";
                oForm.method = "post";
                oForm.submit();
            }
            else
            {
                alert("Please, select a consignee");
            }
        }
    </script>

</head>
<body>
    <form id="form1" action="">
        <input type="hidden" id="hSec" name="hSec" value="<%=vDataTable("sec") %>" />
        <input type="hidden" id="hAgentOrgAcct" name="hAgentOrgAcct" value="<%=vDataTable("agent_org_acct") %>" />
        <div style="text-align: center">
            <table width="95%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td class="pageheader">
                        Electronic Data Transfer (EDT)
                    </td>
                </tr>
            </table>
            <br />
            <table width="95%" border="0" cellpadding="0" cellspacing="0" style="border: solid 1px #909EB0">
                <tr style="background-color: #CFD6DF">
                    <td align="center" valign="middle" class="bodyheader" style="height: 24px">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="center">
                                    <img height="18" style="cursor: hand" onclick="javascript:btnSaveClick();" src="../images/button_save_medium.gif"
                                        width="46" alt="" />
                                </td>
                            </tr>
                            <tr style="height: 1px; background-color: #909EB0">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: #f3f3f3; text-align: center" class="bodyheader">
                                    <br />
                                    <br />
                                    <table width="75%" height="28" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right" valign="middle" class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt="" />Required
                                                field</td>
                                        </tr>
                                    </table>
                                    <table width="75%" border="0" cellpadding="2" cellspacing="0" style="border: solid 1px #909EB0">
                                        <tr style="background-color: #CFD6DF" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                Master B/L No.</td>
                                            <td>
                                                House B/L No.</td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                <input type="text" class="d_shorttextfield" size="25" id="txtMAWB" name="txtMAWB"
                                                    value="<%=vDataTable("mawb_num") %>" /></td>
                                            <td>
                                                <input type="text" class="d_shorttextfield" size="25" id="txtHAWB" name="txtHAWB"
                                                    value="<%=vDataTable("hawb_num") %>" /></td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="height:10px">
                                        <td></td>
                                        </tr>
                                        <tr style="background-color: #CFD6DF" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                Shipper</td>
                                            <td>
                                                Shipper
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                <textarea id="txtShipperInfoEDT" name="txtShipperInfoEDT" class="multilinetextfield"
                                                    cols="" rows="5" style="width: 300px"><%=vDataTable("shipper_info") %></textarea>
                                            </td>
                                            <td>
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="" />
                                                <div id="lstShipperNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                                onfocus="initializeJPEDField(this);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange')"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                    </tr>
                                                </table>
                                                <textarea id="txtShipperInfo" name="txtShipperInfo" class="multilinetextfield" cols=""
                                                    rows="5" style="width: 300px"></textarea>
                                                <!-- End JPED -->
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #CFD6DF" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                Consignee</td>
                                            <td>
                                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom" alt=""/>Consignee
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                <textarea id="txtConsigneeInfoEDT" name="txtConsigneeInfoEDT" class="multilinetextfield"
                                                    cols="" rows="5" style="width: 300px"><%=vDataTable("consignee_info") %></textarea>
                                            </td>
                                            <td>
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="" />
                                                <div id="lstConsigneeNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0" id="tblConsignee">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                                value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange')" onfocus="initializeJPEDField(this);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                    </tr>
                                                </table>
                                                <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="multilinetextfield"
                                                    cols="" rows="5" style="width: 300px"></textarea>
                                                <!-- End JPED -->
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #CFD6DF" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                Notify</td>
                                            <td>
                                                Notify
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                        <tr style="background-color: #ffffff" class="bodyheader">
                                            <td style="width: 5px">
                                            </td>
                                            <td>
                                                <textarea id="txtNotifyInfoEDT" name="txtNotifyInfoEDT" class="multilinetextfield"
                                                    cols="" rows="5" style="width: 300px"><%=vDataTable("notify_info") %></textarea>
                                            </td>
                                            <td>
                                                <!-- Start JPED -->
                                                <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="" />
                                                <div id="lstNotifyNameDiv">
                                                </div>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value=""
                                                                class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange')"
                                                                onfocus="initializeJPEDField(this);" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange')"
                                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                        <td>
                                                            <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtNotifyInfo')" /></td>
                                                    </tr>
                                                </table>
                                                <textarea id="txtNotifyInfo" name="txtNotifyInfo" class="multilinetextfield" cols=""
                                                    rows="5" style="width: 300px"></textarea>
                                                <!-- End JPED -->
                                            </td>
                                            <td style="width: 5px">
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                </td>
                            </tr>
                            <tr style="height: 1px; background-color: #909EB0">
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <img height="18" style="cursor: hand" onclick="javascript:btnSaveClick();" src="../images/button_save_medium.gif"
                                        width="46" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
