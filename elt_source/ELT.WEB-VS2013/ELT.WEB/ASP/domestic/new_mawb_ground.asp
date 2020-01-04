    <!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%

'// --------------- Main ---------------------------------------------------------------------
    Dim mawbTable,vMAWB,vFileNo,mode,i,j,aChargeItem,aOtherCharge,aIncHAWB
    
    vMAWB = checkBlank(Request.QueryString.Item("MAWB"),"")
    vFileNo = checkBlank(Request.QueryString.Item("FILE"),"")
    mode = checkBlank(Request.QueryString.Item("mode"),"new")
    
    Set aOtherCharge = Server.CreateObject("System.Collections.ArrayList")
    Set aChargeItem = Server.CreateObject("System.Collections.ArrayList")
    Set mawbTable = Server.CreateObject("System.Collections.HashTable")

    Call get_charge_item_list()

    If mode = "save" Then
        update_mawb_master()
        update_mawb_weight_charge()
        delete_mawb_other_charge()
        insert_mawb_other_charge()
        update_mawb_number_used("Y")

    Elseif mode = "delete" Then
        delete_mawb_master()
    Elseif mode = "close" Then
        update_mawb_master_status("C")
    Elseif mode = "edit" Then
        Call redirect_url()

    End If
    
    If mode <> "new" Then
        Set mawbTable = get_booking_info(vFileNo,vMAWB)
        get_other_charge_info()
    End If
    
'//---------- Functions/Subs ------------------------------------------------------------------

    Sub redirect_url()
        dim MAWB_NO
        If ConvertAnyValue(vMAWB,"String","0") <> "0" Then
            Exit Sub
        End If
        
        Dim SQL,rs
	    Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT master_type,is_inbound, mawb_no FROM mawb_number WHERE elt_account_number=" & elt_account_number _
            & " AND is_dome='Y' AND FILE#='" & vFileNo & "'"

        rs.CursorLocation = adUseClient	
        rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
           MAWB_NO=rs("mawb_no")
            If rs("is_inbound") = "Y" Then
                Response.Write("<script> window.location.href='inbound_alert.asp?mode=edit&MAWB=" & MAWB_NO & "'; </script>")    
            Else
                If rs(0).value = "DA" Then
                    Response.Write("<script> window.location.href='new_edit_mawb.asp?Edit=yes&MAWB=" & MAWB_NO & "'; </script>")    
                End If
            End If
        Else
            Response.Write("<script> alert('The MAWB was not found!'); window.location.href='new_mawb_ground.asp'; </script>")    
        End If
	    rs.close()
    End Sub
    

    
    Function get_booking_info(vFileNoCopy,vMAWBCopy)
        Dim SQL,dataObj
        
        SQL = "SELECT TOP 1 * FROM mawb_number a FULL OUTER JOIN mawb_master b " _
            & "ON (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
            & "FULL OUTER JOIN mawb_weight_charge c " _
            & "ON (a.mawb_no=c.mawb_num and a.elt_account_number=c.elt_account_number) " _
            & "WHERE (a.is_dome='Y' or a.is_dome='') AND a.master_type='DG' AND " _
            & "a.elt_account_number=" & elt_account_number _
            & " AND ISNULL(a.file#,'') <> '' AND (a.file#='" & vFileNoCopy & "' " _
            & "OR a.mawb_no='" & vMAWBCopy & "')"
        
        If Not IsDataExist(SQL) Then
            Response.Write("<script>alert('The number does not exist'); window.location.href='new_mawb_ground.asp?mode=new'; </script>")
            Response.End()
        End If

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)

        Set get_booking_info = dataObj.GetRowTable(0)
        
    End Function
    
'//---------- Get Other Charge ------------------------------------------------------------------

    Function get_other_charge_info()
        Dim tmpTable,SQL,rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
        
	    SQL= "SELECT * FROM mawb_other_charge WHERE elt_account_number=" & elt_account_number _
	        & " AND mawb_num='" & mawbTable("mawb_no") & "' ORDER BY Tran_no"
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.EOF
	        Set tmpTable = Server.CreateObject("System.Collections.HashTable")
	        
	        tmpTable.Add "charge_code", rs("charge_code").value
	        tmpTable.Add "Charge_Desc", rs("Charge_Desc").value
	        tmpTable.Add "Amt_MAWB", rs("Amt_MAWB").value
	        
	        aOtherCharge.Add tmpTable
		    rs.MoveNext
	    Loop
        rs.Close
    End Function 
    
'//---------- Get Other Charge List ---------------------------------------------------------------

    Sub get_charge_item_list()
        Dim tmpTable,SQL,rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
        
	    SQL= "SELECT * FROM item_charge WHERE elt_account_number = " _
	        & elt_account_number & " ORDER BY item_name"
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.EOF
	        Set tmpTable = Server.CreateObject("System.Collections.HashTable")
	        tmpTable.Add "item_name" , rs("item_name").value
	        tmpTable.Add "item_no" , rs("item_no").value
	        tmpTable.Add "item_desc" , rs("item_desc").value
	        tmpTable.Add "unit_price" , rs("unit_price").value
	        aChargeItem.Add tmpTable
		    rs.MoveNext
	    Loop
        rs.Close
    END Sub
 
'//---------- Update Master Header -------------------------------------------------------------

    Sub update_mawb_master()
        Dim SQL,i,resVal,dataObj,dataTable
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        SQL = "SELECT * FROM mawb_master WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" _
            & elt_account_number

        dataTable.Add "mawb_no", vMAWB
        dataTable.Add "MAWB_NUM", vMAWB
        dataTable.Add "elt_account_number", elt_account_number
        
        dataTable.Add "Shipper_Name", Request.Form.Item("lstShipperName")
        dataTable.Add "Shipper_Info", Request.Form.Item("txtShipperInfo")
        dataTable.Add "Shipper_account_number", Request.Form.Item("hShipperAcct")
        
        dataTable.Add "Consignee_Name", Request.Form.Item("lstConsigneeName")
        dataTable.Add "Consignee_Info", Request.Form.Item("txtConsigneeInfo")
        dataTable.Add "Consignee_acct_num", Request.Form.Item("hConsigneeAcct")

        dataTable.Add "Account_Info", Request.Form.Item("txtBillToInfo")
        //change by stanley on 8/28/2007 revised by joon on August 30, 2007
        dataTable.Add "Notify_no", ConvertAnyValue(Request.Form.Item("hNotifyAcct"),"Long",0)
        dataTable.Add "Declared_Value_Carriage", Request.Form.Item("txtDeclaredValueCarriage")
        dataTable.Add "Insurance_AMT", Request.Form.Item("txtInsuranceAmt")

        dataTable.Add "Total_Pieces", Request.Form.Item("txtPiece")
        dataTable.Add "Total_Gross_Weight", Request.Form.Item("txtGrossWeight")
        dataTable.Add "total_chargeable_weight", Request.Form.Item("txtChargeableWeight")
        dataTable.Add "Weight_Scale", "L"
        dataTable.Add "dim_text", Request.Form.Item("hDimDetail")
        dataTable.Add "Total_Weight_Charge_HAWB", Request.Form.Item("txtTotalCharge")
        dataTable.Add "cod_amount", Request.Form.Item("txtCODAmount")
        dataTable.Add "carrier_icc_num", Request.Form.Item("txtCarrierICCNum")
        dataTable.Add "shipper_reference_num", Request.Form.Item("txtShipperReferenceNum")
        dataTable.Add "bill_to_party", Request.Form.Item("chkBilling")
        dataTable.Add "third_party_no", Request.Form.Item("txt3rdPartyNo")
        dataTable.Add "shipper_COD", Request.Form.Item("txtshipperCOD")
        
        dataTable.Add "service_level_other", Request.Form.Item("txtServiceLevel")
        dataTable.Add "Desc2", Request.Form.Item("txtItemDesc")
        dataTable.Add "master_type", "DG"
        dataTable.Add "is_dome", "Y"
        
        If Request.Form.Item("chkBilling") = "S" Then
            dataTable.Add "PPO_1", "Y"
            dataTable.Add "COLL_1", "N"
            dataTable.Add "PPO_2", "Y"
            dataTable.Add "COLL_2", "N"
        Else
            dataTable.Add "PPO_1", "N"
            dataTable.Add "COLL_1", "Y"
            dataTable.Add "PPO_2", "N"
            dataTable.Add "COLL_2", "Y"
        End If
        
        '// Dummy values
        dataTable.Add "Show_Weight_Charge_Shipper", "Y"
        dataTable.Add "Show_Weight_Charge_Consignee", "Y"
        dataTable.Add "Show_Prepaid_Other_Charge_Shipper", "Y"
        dataTable.Add "Show_Collect_Other_Charge_Shipper", "Y"
        dataTable.Add "Show_Prepaid_Other_Charge_Consignee", "Y"
        dataTable.Add "Show_Collect_Other_Charge_Consignee", "Y"
        dataTable.Add "show_weight_charge_shipper", "Y"
        dataTable.Add "show_weight_charge_consignee", "Y"
        dataTable.Add "show_prepaid_other_charge_shipper", "Y"
        dataTable.Add "show_collect_other_charge_shipper", "Y"
        dataTable.Add "show_prepaid_other_charge_consignee", "Y"
        dataTable.Add "show_collect_other_charge_consignee", "Y"
        
        '// dates
        dataTable.Add "Date_Last_Modified", date()
        dataTable.Add "Invoiced", "N"
        dataTable.Add "SalesPerson", Request.Form.Item("lstSalesRP")
        dataTable.Add "Handling_Info", Request.Form.Item("txtHandlingInfo")
        
        dataTable.Add "ModifiedBy", GetUserFLName(user_id)
        dataTable.Add "ModifiedDate", date()
        dataTable.Add "Date_Executed", Request.Form.Item("txtBillDate")
        
        dataObj.SetColumnKeys("mawb_master")
        Call dataObj.UpdateDBRow(SQL, dataTable)
    End Sub
    
'//---------- Update MAWB Weight ------------------------------------------------------------------

    Sub update_mawb_weight_charge()
        Dim SQL,i,resVal,dataObj,dataTable
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        SQL = "SELECT * FROM mawb_weight_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" _
            & elt_account_number
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "MAWB_NUM", vMAWB
        dataTable.Add "Tran_No", 1
        dataTable.Add "No_Pieces", ConvertAnyValue(Request.Form.Item("txtPiece"),"Long",0)
        dataTable.Add "Gross_Weight", Request.Form.Item("txtGrossWeight")
        dataTable.Add "Kg_Lb", "L"
        dataTable.Add "Rate_Class", ""
        dataTable.Add "Commodity_Item_No", ""
        dataTable.Add "Dem_Detail", Request.Form.Item("hDimDetail")
        dataTable.Add "Chargeable_Weight", Request.Form.Item("txtChargeableWeight")
        dataTable.Add "Rate_Charge", Request.Form.Item("txtRateCharge")
        dataTable.Add "Total_Charge", Request.Form.Item("txtTotalCharge")
        dataTable.Add "Desc1", ""
        dataTable.Add "Desc2", Request.Form.Item("txtItemDesc")
        dataTable.Add "cubic_inches", Request.Form.Item("txtCubicInches")
        dataTable.Add "dimension_factor", Request.Form.Item("hDimfactor")
        dataTable.Add "cubic_weight", Request.Form.Item("txtCubicWeight")
        dataObj.SetColumnKeys("mawb_weight_charge")
        Call dataObj.UpdateDBRow(SQL, dataTable)
    End Sub
    
'//---------- Update Other Charge ------------------------------------------------------------------

    Sub insert_mawb_other_charge()
        Dim SQL,i,resVal,dataObj,dataTable,vTranNo
        
        SQL = "SELECT TOP  0 * FROM mawb_other_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" _
            & elt_account_number
            
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("mawb_other_charge")
        
        For vTranNo = 1 to Request.Form.Item("lstChargeCode").Count-1
            If checkBlank(Request.Form.Item("hChargeCode")(vTranNo+1),"") <> "" Then
                Set dataTable = Server.CreateObject("System.Collections.HashTable")
                dataTable.Add "elt_account_number", elt_account_number
                dataTable.Add "MAWB_NUM", vMAWB
                dataTable.Add "Tran_No", vTranNo
                If Request.Form.Item("chkBilling") = "S" Then
                    dataTable.Add "Coll_Prepaid", "P"
                Else
                    dataTable.Add "Coll_Prepaid", "C"
                End If
                dataTable.Add "Carrier_Agent", ""
                dataTable.Add "charge_code", Request.Form.Item("hChargeCode")(vTranNo+1)
                dataTable.Add "Charge_Desc", Request.Form.Item("txtChargeDesc")(vTranNo+1)
                dataTable.Add "Amt_MAWB", Request.Form.Item("txtChargeAmt")(vTranNo+1)
                dataTable.Add "Amt_Acct",""
                dataTable.Add "Vendor_Num","" 
                dataTable.Add "Cost_Amt",""
                Call dataObj.InsertDBRow(SQL, dataTable)
            End If
        Next
    End Sub
    
'//------------ Delete Other Charge -----------------------------------------------------------------

    Sub delete_mawb_other_charge
        Dim SQL,rs
        
        SQL = "DELETE FROM mawb_other_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" _
            & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub

'//------------ Delete Master itself -----------------------------------------------------------------

    Sub delete_mawb_master
        Dim SQL,rs
       
        SQL = "BEGIN TRANSACTION " _
            & "UPDATE mawb_number SET used = 'N' WHERE mawb_no='" & vMAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM mawb_master WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM mawb_weight_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM mawb_other_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM mawb_other_charge WHERE mawb_num='" & vMAWB & "' AND elt_account_number=" & elt_account_number _
            & "COMMIT"
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub

'//------------ Close Booking -----------------------------------------------------------------

    Sub update_mawb_master_status(vStatus)
        Dim SQL,rs
        
        SQL = "UPDATE mawb_number SET Status = '" & vStatus & "' WHERE mawb_no='" & vMAWB & "' AND elt_account_number=" _
            & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub
    
    Sub update_mawb_number_used(vUsed)
        Dim SQL,rs
       
        SQL = "UPDATE mawb_number SET used = '" & vUsed & "' WHERE mawb_no='" & vMAWB _
            & "' AND elt_account_number=" & elt_account_number 
            
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ground Booking</title>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        <!--
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
.style14 {color: #C6603E}
.style15 {font-size: 9px; font-weight: bold; left: 6px; font-family: Verdana, Arial, Helvetica, sans-serif;}
        -->
    </style>

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
        
        
        function lookupFile(arg){
           	var fileno=document.getElementById("txtJobNum").value;
           	
	        if (fileno != "" &&  fileno != "Search Here")
	        {
		        document.frmMAWB.action = "new_mawb_ground.asp?mode=editFile&FILE=" + encodeURIComponent(arg);
                document.frmMAWB.method = "POST";
                document.frmMAWB.target = "_self";
                document.frmMAWB.submit();
                }
                else
                {
                    alert('Please enter a File No!');
                }
        }
        
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");

            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    
		    document.frmMAWB.action = "new_mawb_ground.asp?mode=edit&MAWB=" + encodeURIComponent(argV);
            document.frmMAWB.method = "POST";
            document.frmMAWB.target = "_self";
            document.frmMAWB.submit();
        }
        
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            
            var obj = document.getElementById(objName);

            var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DGB&qStr=";
            
            FillOutJPED(obj,url,changeFunction,vHeight);

        }
        
        function lstShipperNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
       
        
        function lstConsigneeNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var infoObj = document.getElementById("txtConsigneeInfo");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
        
        function lstNotifyNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hNotifyAcct");
            var infoObj = document.getElementById("txtBillToInfo");
            var txtObj = document.getElementById("lstNotifyName");
            var divObj = document.getElementById("lstNotifyNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
        }
        
        function getOrganizationInfo(orgNum){
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org="+ orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
            
            return xmlHTTP.responseText; 
        }
        
        function ChargeItemChange(thisObj){
            // no,price,name,desc
            var rowID = thisObj.parentNode.parentNode.id;
            
            
            var ocIndex = $("select.lstChargeCode").get(rowID).selectedIndex;
            var ocValue = $("select.lstChargeCode").get(rowID).options[ocIndex].value;
            var ocArray = new Array();
            
            ocArray = ocValue.split("-");
            document.getElementsByName("txtChargeDesc")[rowID].value = ocArray[3];
            document.getElementsByName("txtChargeAmt")[rowID].value = ocArray[1];   
            document.getElementsByName("hChargeCode")[rowID].value = ocArray[0];   
        }
        
        function DimCalClick(){
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280";
            var childWindow = window.open("dimcal_master.asp?ItemNum=", "Dimension_Calculation", props);
            childWindow.focus();
        }
        
        function ShowAvailableHAWBs(){
            var vMAWB = document.getElementById("hSearchNum").value;
            var props = "scrollBars=no,resizable=no,toolbar=no,menubar=no,location=no,directories=no,width=900,height=600";
            var childWindow = window.open("available_hawbs.asp?MT=DG&ISDOME=Y&MAWB=" + vMAWB, "Available_HAWBs", props);
            childWindow.focus();
        }
        
        function bsaveClick() {
            var vMAWB = document.getElementById("hSearchNum").value;
            if(vMAWB =="")
            {
                alert('Please select a Bill of Lading No.');
            }
            else
            {
		        document.frmMAWB.action = "new_mawb_ground.asp?mode=save&MAWB=" + encodeURIComponent(vMAWB);
                document.frmMAWB.method = "POST";
                document.frmMAWB.target = "_self";
                document.frmMAWB.submit();
            }
        }
        //////////////////////////add on 7/29/2007 by stanley/////////////////////////////////
        function bCloseClick()
        { 
        var mawb = '<%=vMAWB%>';
        if(mawb == '') {
	        alert('Please select a Bill of Lading No.');
	        return false;
        }
        if(!confirm("Do you really want to close this Bill of Lading No. '" + mawb +"' ?")) {return false;}
	        if (close_mawb(mawb) ) {
		        alert("Bill of Lading No. : " + mawb + " was closed successfully.");
		        window.location = "new_edit_mawb.asp";
	        } else {
		        alert("Some error was occured when closing.");		
		        return false;
	        }
        }

        function close_mawb(mawb) {
              if (window.ActiveXObject) {
	               try {
		            xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
	               } catch(e) {
                        try {
                         xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(f) {
                         return true;
                        }
                  }
              } else if (window.XMLHttpRequest) {
                    xmlHTTP = new XMLHttpRequest();
              } else {return true;}

	        var url = "/ASP/ajaxFunctions/ajax_mawb_close.asp" 
				        +"?n="+mawb;
        	 
            try {    
                xmlHTTP.open("get",url,false); 
                xmlHTTP.send(); 
                var sourceCode = xmlHTTP.responseText;
	            if (sourceCode) {
                    // alert(sourceCode);					
			        if ( sourceCode == 'ok' ) {
				        return true;
			        } 
			        else {
					        switch(sourceCode) {
						        default :
							          break;
					        }			
					        return false;			
			        }
		        }
        		
            }   catch(e) { return false; }
        }
///////////////////////////////////////////////////////
        
        function DeleteMAWB(){
            var vMAWB = document.getElementById("hSearchNum").value;
            if(vMAWB == "" || vMAWB == "0")
            {
                alert('Please select a Bill of Lading No.');
            }
            else
            {
               var r=confirm("Do you really want to delete Bill of lading No '" + vMAWB + "' ? Continue?");
               if(r == true)
               {
		            document.frmMAWB.action = "new_mawb_ground.asp?mode=delete&MAWB=" + encodeURIComponent(vMAWB);
                    document.frmMAWB.method = "POST";
                    document.frmMAWB.target = "_self";
                    document.frmMAWB.submit();
              }
           }
        }
        
        function AddOtherCharge(){
            var table = document.getElementById("tblOtherCharege");
            
            //get existing rows
            var rows = document.getElementById("tblOtherCharege").rows;
            var tds;
            if(rows.length>0)
                tds = rows[0].innerHTML;

            var new_rowid=rows.length;
            var row = table.insertRow(rows.length);
            row.id=new_rowid;
            //alert("new_rowid: " +new_rowid);
            //alert("newrow :" +tds);
            row.innerHTML=tds;
        // Create an empty <tr> element and add it to the 1st position of the table:
//        var row = table.insertRow(0);

//        // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
//        var cell1 = row.insertCell(0);
//        var cell2 = row.insertCell(1);

        // Add some text to the new cells:
//        cell1.innerHTML = "NEW CELL1";
//        cell2.innerHTML = "NEW CELL2";

//            var new_id = 0;
//            var tableObj = document.getElementById("tblOtherCharege");
//            var tableNodes =  tableObj.children[0];
//            var newNode = tableObj.insertRow(0); 
//            var last_id = tableNodes.lastChild.id;
//            new_id = parseInt(last_id)+1;
//            var addContent = tableNodes.firstChild.innerHTML;
//            //newNode.attr("class","bodyheader");
//            newNode.id=new_id;
//            newNode.innerHTML=addContent;
//            tableNodes.append();
           // var addObj = tableObj.children[0].children[0];
            //addObj.id=new_id;
          //  var addContent = tableObj.children[0].children[0].innerHTML;
           // tableObj.outerHTML = "<table id=\"tblOtherCharege\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
           //     + tableObj.firstChild.innerHTML + "<tr class=\"bodyheader\">" + addContent + "</tr></table>";
        }
        
        function DeleteOtherCharge(thisObj){
            var tableObj = thisObj.parentNode.parentNode.parentNode.parentNode;
            
            var rowID = 0;
            var ObjList = document.getElementsByName(thisObj.name);
            for(var i=0;i<ObjList.length;i++){
                if(thisObj.uniqueID == ObjList[i].uniqueID){
                    rowID = i;
                }
            }
            tableObj.deleteRow(rowID);
        }
        
        function findSelect(oSelect,selVal){
            oSelect.options.selectedIndex = 0;
            
            for(var i=0;i<oSelect.options.length;i++)
            {
                var tempArray = new Array();
                tempArray = oSelect.options[i].value.split("-")
                if(tempArray[0] == selVal)
                {
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        function setTotalWeightCharge(){
            var vPieces = parseInt(document.getElementById("txtPieces").value);
            var vCW = parseFloat(document.getElementById("txtChargeableWeight").value);
            var vGW = parseFloat(document.getElementById("txtGrossWeight").value);
            var vDW = parseFloat(document.getElementById("txtCubicWeight").value);
            var vRateCharge = parseFloat(document.getElementById("txtRateCharge").value);
            
            if(vRateCharge>0 && vCW>0){
                document.getElementById("txtTotalCharge").value = (vRateCharge * vCW).toFixed(2);
            }
        }
        
        function setChargeableWeight(){
            var objCW = document.getElementById("txtChargeableWeight");
            var vGW = parseFloat(document.getElementById("txtGrossWeight").value);
            var vDW = parseFloat(document.getElementById("txtCubicWeight").value);
            
            if(isNaN(vGW)) vGW=0;
            if(isNaN(vDW)) vDW=0;
            objCW.value = Math.max(vGW,vDW);
        }
        
        function sync3rdParty(){
        
            var lstObj = document.getElementsByName("chkBilling");
            var targetObject = document.getElementById("txt3rdPartyNo");
            var targetTdObject = document.getElementById("td3rdPartyNo");
            
            targetObject.value = "";
            targetObject.style.visibility = "hidden";
            targetTdObject.style.visibility = "hidden";
            
            for(var i=0; i<lstObj.length; i++){
            
                if(lstObj[i].checked && lstObj[i].value == "3"){
                    targetObject.style.visibility = "visible";
                    targetTdObject.style.visibility = "visible";
                }
            }
        }

        function loadMAWBInfo(){
        
            document.getElementById("lstSearchNum").value = "<%=MakeJavaString(mawbTable("mawb_no")) %>";
            document.getElementById("hSearchNum").value = "<%=MakeJavaString(mawbTable("mawb_no")) %>";
            
            document.getElementById("hShipperAcct").value = "<%=ConvertAnyValue(mawbTable("Shipper_account_number"),"String",elt_account_number) %>";
            document.getElementById("lstShipperName").value = "<%=ConvertAnyValue(mawbTable("Shipper_Name"),"String",GetAgentName(elt_account_number)) %>";
            document.getElementById("txtShipperInfo").value = "<%=checkBlank(MakeJavaString(mawbTable("Shipper_Info")),GetAgentName(elt_account_number) & "\n" & MakeJavaString(GetAgentAddress(elt_account_number))) %>";
            
            document.getElementById("hConsigneeAcct").value = "<%=MakeJavaString(mawbTable("Consignee_acct_num")) %>";
            document.getElementById("lstConsigneeName").value = "<%=MakeJavaString(mawbTable("Consignee_Name")) %>";
            document.getElementById("txtConsigneeInfo").value = getOrganizationInfo(document.getElementById("hConsigneeAcct").value);
            
            document.getElementById("hNotifyAcct").value = "<%=MakeJavaString(mawbTable("Notify_no")) %>";
            document.getElementById("lstNotifyName").value = "<%=GetBusinessName(mawbTable("Notify_no")) %>";
            document.getElementById("txtBillToInfo").value = getOrganizationInfo(document.getElementById("hNotifyAcct").value);
            
            document.getElementById("txtDepartureAirport").value = "<%=MakeJavaString(mawbTable("Origin_Port_Location")) %>";
            document.getElementById("txtDestAirport").value = "<%=MakeJavaString(mawbTable("Dest_Port_Location")) %>";
            document.getElementById("txtCarrierICCNum").value = "<%=ConvertAnyValue(mawbTable("carrier_icc_num"),"String",GetCarrierInfo("ICC_MC",mawbTable("Carrier_acct"))) %>";
            document.getElementById("txtDeclaredValueCarriage").value = "<%=formatNumberPlus(ConvertAnyValue(mawbTable("Declared_Value_Carriage"),"Amount",0),2) %>";
            document.getElementById("txtInsuranceAmt").value = "<%=formatNumberPlus(ConvertAnyValue(mawbTable("Insurance_AMT"),"Amount",0),2) %>";
            document.getElementById("txtShipperReferenceNum").value = "<%=MakeJavaString(mawbTable("shipper_reference_num")) %>";
            
            document.getElementById("txtServiceLevel").value = "<%=MakeJavaString(mawbTable("service_level_other")) %>";
            document.getElementById("txtCODAmount").value = "<%=formatNumberPlus(ConvertAnyValue(mawbTable("cod_amount"),"Amount",0),2) %>";
            
            // retrieves data from weight_charge or booking
            document.getElementById("txtPiece").value = "<%=ConvertAnyValue(mawbTable("No_Pieces"),"Long",mawbTable("pieces")) %>";
            document.getElementById("hDimDetail").value = "<%=MakeJavaString(mawbTable("Dem_Detail")) %>";
            document.getElementById("hDimFactor").value = "<%=mawbTable("dimension_factor") %>";
            document.getElementById("txtGrossWeight").value = "<%=ConvertAnyValue(mawbTable("Gross_Weight"),"Long",mawbTable("Weight_Reserved")) %>";
            document.getElementById("txtCubicInches").value = "<%=MakeJavaString(mawbTable("cubic_inches")) %>";
            document.getElementById("txtCubicWeight").value = "<%=MakeJavaString(mawbTable("cubic_weight")) %>";
            document.getElementById("txtChargeableWeight").value = "<%=MakeJavaString(mawbTable("Chargeable_Weight")) %>";
            document.getElementById("txtRateCharge").value = "<%=MakeJavaString(mawbTable("Rate_Charge")) %>";
            document.getElementById("txtTotalCharge").value = "<%=formatNumberPlus(ConvertAnyValue(mawbTable("Total_Charge"),"Amount",0),2) %>";
            
            <% For i=1 To aOtherCharge.count %>
            document.getElementsByName("hChargeCode")[<%=i %>].value = "<%=MakeJavaString(aOtherCharge(i-1)("charge_code")) %>";
            document.getElementsByName("txtChargeDesc")[<%=i %>].value = "<%=MakeJavaString(aOtherCharge(i-1)("Charge_Desc")) %>";
            document.getElementsByName("txtChargeAmt")[<%=i %>].value = "<%=formatNumberPlus(ConvertAnyValue(aOtherCharge(i-1)("Amt_MAWB"),"Amount",0 ),2) %>";
            findSelect(document.getElementsByName("lstChargeCode")[<%=i %>],"<%=MakeJavaString(aOtherCharge(i-1)("charge_code")) %>");
            <% Next %>
            
            document.getElementById("txtHandlingInfo").value = "<%=MakeJavaString(mawbTable("Handling_Info")) %>";
            document.getElementById("txtItemDesc").value = "<%=MakeJavaString(mawbTable("Desc2")) %>";
            
            <% If mawbTable("bill_to_party") = "S" Then %>
            document.getElementsByName("chkBilling")[0].checked = true;
            <% Elseif mawbTable("bill_to_party") = "C" Then %>
            document.getElementsByName("chkBilling")[1].checked = true;
            <% Elseif mawbTable("bill_to_party") = "3" Then %>
            document.getElementsByName("chkBilling")[2].checked = true;
            <% End If %>
            sync3rdParty();
            document.getElementById("txt3rdPartyNo").value = "<%=MakeJavaString(mawbTable("third_party_no")) %>";
            document.getElementById("txtshipperCOD").value = "<%=formatNumberPlus(ConvertAnyValue(mawbTable("shipper_COD"),"Amount",0),2) %>";
            document.getElementById("txtBillDate").value = "<%=ConvertAnyValue(mawbTable("Date_Executed"),"Date",Date()) %>";
        }
        
        function NewPrintVeiw(){
            vMAWB = document.getElementById("hSearchNum").value;
        
            if(vMAWB == ""){
                alert("Please, select Bill of Lading NO. to view PDF");
            }
            else{
                var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
                window.open("view_print.asp?sType=ground_master&mawb=" + vMAWB, "PrintBeta", props);
            }
        }

    </script>

</head>
<body link="336699" vlink="336699" topmargin="0" onload="self.focus(); loadMAWBInfo(); AddOtherCharge(); AddOtherCharge();">
    <div id="tooltipcontent">
    </div>
    <form method="post" name="frmMAWB" id="frmMAWB">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <input type="hidden" name="scrollPositionX">
        <input type="hidden" name="scrollPositionY">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="46%" height="32" align="left" valign="middle" class="pageheader">
                    New/Edit bill of lading
                </td>
                <td width="54%" align="right" valign="middle">
                    <span class="bodyheader style5">FILE NO.</span><input name="txtJobNum" type="text"
                        class="lookup" size="24" value="Search Here" onkeydown="javascript: if(event.keyCode == 13) { lookupFile(this.value); }"
                        onclick="javascript: this.value = ''; this.style.color='#000000'; " id="txtJobNum"><img
                            src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                            style="cursor: hand" onclick="lookupFile(this.value)"></td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="select">
                        <img src="/ASP/Images/required.gif" align="absbottom" alt="" />Select Bill
                        of Lading No.
                    </td>
                    <td rowspan="2" align="right" valign="bottom">
                        <div id="print" style="width: 180px">
                            <img src="/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" /><a
                    href="javascript:void(0);" id="NewPrintVeiw1">Bill of Lading </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- Start JPED -->
                        <input type="hidden" id="hSearchNum" name="hSearchNum" />
                        <div id="lstSearchNumDiv">
                        </div>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value=""
                                        class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                        border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="searchNumFill(this,'lstSearchNumChange',200,event);"
                                        onfocus="initializeJPEDField(this,event);" /></td>
                                <td>
                                    <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                        style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                        border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                            </tr>
                        </table>
                        <!-- End JPED -->
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            class="border1px">
            <tr>
                <td width="100%" height="24" colspan="2" bgcolor="#eec983">
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="33%">
                                &nbsp;
                            </td>
                            <td width="34%" align="center" valign="middle">
                                <img src='../images/button_save_medium.gif' name='bSave' onclick="bsaveClick();"
                                    style="cursor: hand"></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                    onclick="bCloseClick()" style="cursor: hand" />
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns &ldquo;clean&rdquo;.')"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                            </td>
                            <td width="10%" align="right" valign="middle">
                                <img src='../images/button_delete_medium.gif' width='51' height='17' name='bDeleteMAWB'
                                    onclick='DeleteMAWB()' style="cursor: hand"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132" colspan="2">
                </td>
            </tr>
            <tr>
                <td colspan="2" bgcolor="#f3f3f3">
                    <br>
                    <br>
                    <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
                        bgcolor="#FFFFFF" class="border1px">
                        <tr>
                            <td width="45%" valign="top" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="36%" height="20" bgcolor="#f3d9a8" style="padding-left: 10px">
                                            <strong class="bodyheader">Shipper's Name and Address</strong></td>
                                        <td width="35%" bgcolor="#f3d9a8">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="103" colspan="2" valign="top" bgcolor="#FFFFFF" style="padding-left: 10px">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="" />
                                            <div id="lstShipperNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                                rows="5" style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" bgcolor="#f3f3f3" class="bodyheader" style="padding-left: 10px">
                                            <strong>Consignee's Name</strong></td>
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" bgcolor="#FFFFFF" style="padding-left: 10px">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="" />
                                            <div id="lstConsigneeNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                            value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                                rows="5" style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" bgcolor="#f3f3f3" style="padding-left: 10px">
                                            <span class="bodycopy"><strong>Point (Port) of Origin </strong></span>
                                        </td>
                                        <td bgcolor="#f3f3f3">
                                            <strong class="bodyheader">Point (Port) of Destination </strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF" style="padding-left: 10px">
                                            <input name="txtDepartureAirport" class="shorttextfield" value="" size="28" maxlength="35"
                                                id="txtDepartureAirport" style="background-color: #cccccc" readonly="readOnly"></td>
                                        <td bgcolor="#FFFFFF">
                                            <input name="txtDestAirport" class="shorttextfield" value="" size="28" maxlength="35"
                                                id="txtDestAirport" style="background-color: #cccccc" readonly="readOnly"></td>
                                    </tr>
                                </table>
                            </td>
                            <td width="55%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="bodyheader">
                                        <td width="33%" height="20" bgcolor="#f3d9a8" class="leftpadding">
                                            Date</td>
                                        <td width="33%" bgcolor="#f3d9a8" class="bodyheader">
                                            Billing to
                                        </td>
                                        <td width="34%" bgcolor="#f3d9a8" class="bodyheader">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="23" class="leftpadding">
                                            <input name="txtBillDate" id="txtBillDate" class="shorttextfield" value="" size="24" id="" /></td>
                                        <td colspan="2">
                                            <span class="bodycopy">
                                                <input type="radio" name="chkBilling" id="BillShipper" value="S" checked onclick="sync3rdParty();" />
                                                Shipper
                                                <input type="radio" name="chkBilling" id="BillConsignee" value="C" style="margin-left: 17px"
                                                    onclick="sync3rdParty();" />
                                                Consignee
                                                <input type="radio" name="chkBilling" id="BillThirdParty" value="3" style="margin-left: 17px"
                                                    onclick="sync3rdParty();" />
                                                3rd Party </span>
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="20" bgcolor="#f3f3f3" class="leftpadding">
                                            Carrier ICC MC No.</td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">
                                            <span class="leftpadding">Declared Value for Carriage</span></td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">
                                            Amount of Insurance
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="leftpadding">
                                            <input name="txtCarrierICCNum" class="shorttextfield" maxlength="64" value="" size="24"
                                                id="txtCarrierICCNum" /></td>
                                        <td>
                                            <span class="leftpadding">
                                                <input name="txtDeclaredValueCarriage" class="shorttextfield" value="" size="24"
                                                    id="txtDeclaredValueCarriage" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                            </span>
                                        </td>
                                        <td>
                                            <input name="txtInsuranceAmt" class="shorttextfield" value="" size="24" maxlength="17"
                                                id="txtInsuranceAmt" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="20" bgcolor="#f3f3f3" class="leftpadding">
                                            Shipper's Reference No.
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">
                                            <span class="leftpadding"><span class="bodylistheader style15" style="padding-right: 25px">
                                                Service Level </span></span>
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">
                                            <span class="bodyheader style15 style14">C.O.D. AMOUNT </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="leftpadding" style="height: 18px">
                                            <input name="txtShipperReferenceNum" class="shorttextfield" value="" maxlength="64"
                                                size="24" id="txtShipperReferenceNum">
                                        </td>
                                        <td style="height: 18px">
                                            <span class="leftpadding">
                                                <input type="text" name="txtServiceLevel" class="shorttextfield" size="24" value=""
                                                    id="txtServiceLevel" style="background-color: #cccccc" readonly="readOnly" />
                                            </span>
                                        </td>
                                        <td style="height: 18px">
                                            <input name="txtCODAmount" class="shorttextfield" value="" size="24" maxlength="24"
                                                id="txtCODAmount" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="20" colspan="3" bgcolor="#f3f3f3" class="leftpadding">
                                            Third Party Billing
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" class="leftpadding">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="" />
                                            <div id="lstNotifyNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtBillToInfo" name="txtBillToInfo" class="monotextarea" cols="" rows="5"
                                                style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" bgcolor="#f3f3f3" class="bodycopy">
                                            <b id="td3rdPartyNo">Third Party Billing Acct. No.</b></td>
                                        <td bgcolor="#f3f3f3">
                                            &nbsp;</td>
                                        <td height="20" bgcolor="#f3f3f3" class="bodycopy">
                                            <b>Shipper C.O.D</b></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#FFFFFF" class="leftpadding" style="height: 18px">
                                            <input name="txt3rdPartyNo" class="shorttextfield" value="" size="24" id="txt3rdPartyNo" /></td>
                                        <td style="height: 18px">
                                            &nbsp;</td>
                                        <td bgcolor="#FFFFFF" class="leftpadding" style="height: 18px">
                                            <input name="txtshipperCOD" class="shorttextfield" value="" size="24" id="txtshipperCOD"
                                                style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="height: 5px">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
                        bgcolor="#FFFFFF" class="border1px">
                        <tr class="bodyheader">
                            <td height="20" colspan="2" bgcolor="#f3d9a8" class="leftpadding" style="padding-left: 10px">
                                <span class="style15 style14">WEIGHT CHARGES</span>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td width="69%" height="20" valign="top" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                    <tr class="bodyheader">
                                        <td width="11%" height="20" bgcolor="#f3f3f3" class="leftpadding" style="padding-left: 10px">
                                            Pieces</td>
                                        <td width="13%" bgcolor="#f3f3f3">
                                            WT(LB)</td>
                                        <td width="13%" bgcolor="#f3f3f3">
                                            Cubic IN
                                        </td>
                                        <td width="19%" bgcolor="#f3f3f3">
                                            Cubic (WT)
                                        </td>
                                        <td width="12%" bgcolor="#f3f3f3">
                                            Chrg WT
                                        </td>
                                        <td width="16%" bgcolor="#f3f3f3">
                                            Rate</td>
                                        <td width="16%" bgcolor="#f3f3f3">
                                            Total</td>
                                    </tr>
                                    <tr>
                                        <td class="leftpadding" style="padding-left: 10px">
                                            <input name="txtPiece" class="txtunitbox" id="txtPiece" value="" size="6" maxlength="6"
                                                 />
                                            <input type="hidden" id="hDimDetail" name="hDimDetail" value="" />
                                            <input type="hidden" id="hDimFactor" name="hDimFactor" value="" />
                                        </td>
                                        <td>
                                            <input name="txtGrossWeight" class="txtunitbox" id="txtGrossWeight" value="" size="10"
                                                maxlength="7" onfocusout="setChargeableWeight();" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                        </td>
                                        <td>
                                            <input name="txtCubicInches" class="txtunitbox" id="txtCubicInches" value="" size="10"
                                                maxlength="7" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                        <td>
                                            <input name="txtCubicWeight" class="txtunitbox" id="txtCubicWeight" value="" size="10"
                                                maxlength="7" onfocusout="setChargeableWeight();" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                            <img src="../images/measure.gif" name="" width="16" height="16" align="absmiddle"
                                                style="cursor: hand; margin-left: 4px" onclick="DimCalClick();"></td>
                                        <td>
                                            <input name="txtChargeableWeight" class="txtunitbox" id="txtChargeableWeight" value=""
                                                size="9" maxlength="7" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                        <td>
                                            <input name="txtRateCharge" class="txtunitbox" id="txtRateCharge" value="" size="4"
                                                maxlength="5" style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                            <img src="../images/button_cal.gif" name="bCal" width="37" height="18" align="absmiddle"
                                                style="cursor: hand" onclick="setTotalWeightCharge()"></td>
                                        <td>
                                            <input name="txtTotalCharge" id="txtTotalCharge" value="" size="12" maxlength="12"
                                                class="txtunitbox" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="7">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td height="1" bgcolor="#997132" colspan="5">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="20" colspan="5" bgcolor="#f3d9a8" class="leftpadding style14" style="padding-left: 10px">
                                                        <a name="add_oc"></a><span class="style15">OTHER CHARGE</span></td>
                                                </tr>
                                                <tr class="bodyheader">
                                                    <td width="260" height="20" bgcolor="#f3f3f3" class="leftpadding" style="padding-left: 10px">
                                                        Charge Item
                                                    </td>
                                                    <td width="240" bgcolor="#f3f3f3">
                                                        Description</td>
                                                    <td bgcolor="#f3f3f3">
                                                        Charge Amt
                                                    </td>
                                                    <td bgcolor="#f3f3f3">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                            <!-- DO NOT MESS WITH THIS PLEASE.  U WILL REGRET IT.  BY JOON ^^ -->
                                            <!------------------------------------------------------------------>
                                            <table id="tblOtherCharege" width="100%" border="0" cellspacing="0" cellpadding="0"><tr id="0" class="bodyheader" style="visibility: hidden">
                                                    <td width="260" height="20" bgcolor="#FFFFFF" class="leftpadding" style="padding-left: 10px">
                                                        <select tabindex="6" size="1" name="lstChargeCode" onchange="ChargeItemChange(this)"
                                                            class="smallselect lstChargeCode" style="width: 220px">
                                                            <option value=""></option>
                                                            <% For i=0 To aChargeItem.Count-1 %>
                                                            <option value="<%=aChargeItem(i)("item_no") %>-<%=aChargeItem(i)("unit_price") %>-<%=aChargeItem(i)("item_name") %>-<%=aChargeItem(i)("item_desc") %>">
                                                                <%=aChargeItem(i)("item_name") %>
                                                                -<%=aChargeItem(i)("item_desc") %></option>
                                                            <% Next %>
                                                        </select>
                                                        <input type="hidden" name="hChargeCode" value="">
                                                    </td>
                                                    <td width="240" bgcolor="#FFFFFF">
                                                        <input tabindex="7" name="txtChargeDesc" size="40" value="" class="shorttextfield"></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input tabindex="8" name="txtChargeAmt" size="10" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteOtherCharge(this)"
                                                            style="cursor: hand" name="OCDeleteIcon"></td>
                                                </tr><% For j=0 To aOtherCharge.Count-1 %><tr id="<%= (j+1) %>" class="bodyheader">
                                                    <td height="20" bgcolor="#FFFFFF" class="leftpadding" style="padding-left: 10px">
                                                        <select tabindex="6" size="1" name="lstChargeCode" onchange="ChargeItemChange(this)"
                                                            class="smallselect lstChargeCode" style="width: 220px">
                                                            <option value=""></option>
                                                            <% For i=0 To aChargeItem.Count-1 %>
                                                            <option value="<%=aChargeItem(i)("item_no") %>-<%=aChargeItem(i)("unit_price") %>-<%=aChargeItem(i)("item_name") %>-<%=aChargeItem(i)("item_desc") %>">
                                                                <%=aChargeItem(i)("item_name") %>
                                                                -<%=aChargeItem(i)("item_desc") %></option>
                                                            <% Next %>
                                                        </select>
                                                        <input type="hidden" name="hChargeCode" value="">
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input tabindex="7" name="txtChargeDesc" size="40" value="" class="shorttextfield"></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input tabindex="8" name="txtChargeAmt" size="10" value="" class="numberfield" ostyle="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteOtherCharge(this)"
                                                            style="cursor: hand" name="OCDeleteIcon"></td>
                                                </tr><% Next %></table>
                                            <!------------------------------------------------------------------>
                                            <!-- DO NOT MESS WITH THIS PLEASE.  U WILL REGRET IT.  BY JOON ^^ -->
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr class="bodyheader">
                                                    <td height="8" bgcolor="#FFFFFF" class="leftpadding">
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                    </td>
                                                </tr>
                                                <tr class="bodyheader">
                                                    <td height="32" valign="top" bgcolor="#FFFFFF" class="leftpadding" style="padding-left: 10px">
                                                        <img src="../images/button_addcharge.gif" width="113" height="18" tabindex="25" name="bAddOC"
                                                            onclick="AddOtherCharge()" style="cursor: hand"></td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#FFFFFF">
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bodyheader">
                                                    <td height="20" bgcolor="#f3f3f3" class="leftpadding" style="padding-left: 10px">
                                                        Special Instruction
                                                    </td>
                                                    <td bgcolor="#f3f3f3">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#f3f3f3">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#f3f3f3">
                                                        &nbsp;
                                                    </td>
                                                    <td bgcolor="#f3f3f3">
                                                        &nbsp;
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr class="bodyheader">
                                                    <td height="20" colspan="5" bgcolor="#FFFFFF" class="leftpadding" style="padding-left: 10px">
                                                        <textarea name="txtHandlingInfo" id="txtHandlingInfo" cols="70" rows="2" class="monotextarea"
                                                            wrap="HARD"></textarea></td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="31%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                            Description</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <textarea name="txtItemDesc" cols="34" rows="14" wrap="hard" class="monotextarea"
                                                tabindex="3" onkeyup="" id="txtItemDesc"></textarea></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="bodyheader">
                            <td height="6" colspan="2" valign="top" bgcolor="#FFFFFF">
                            </td>
                        </tr>
                    </table>
                    <br />
                </td>
            </tr>
            <tr>
                <td height="2" bgcolor="#997132" colspan="2">
                </td>
            </tr>
            <tr>
                <td height="24" colspan="2" align="center" valign="middle" bgcolor="#f3d9a8" class="leftpadding">
                    <span class="bodyheader style15 style6"><span class="style15">CONSOLIDATION<img src="../Images/icon_consolidation.gif"
                        alt="Consolidation here" width="35" height="20" align="absmiddle" style="margin-left: 15px;
                        cursor: hand" onclick="ShowAvailableHAWBs()"></span></span></td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132" colspan="2">
                </td>
            </tr>
            <tr>
                <td height="20" colspan="2" bgcolor="#f3f3f3">
                    <table width="100%" align="right">
                        <tr>
                            <td height="36" align="right" valign="middle" class="bodycopy">
                                <strong>Sales Person</strong>
                                <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px" id="lstSalesRP">
                                    <option value="none">Select One</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132" colspan="2">
                </td>
            </tr>
            <tr>
                <td height="24" colspan="2" bgcolor="#eec983">
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="12%">
                                &nbsp;
                            </td>
                            <td width="49%" align="center" valign="middle">
                                <img src='../images/button_save_medium.gif' name='bSave' onclick="bsaveClick();"
                                    style="cursor: hand"></td>
                            <td width="12%" align="right" valign="middle">
                                <img src='../images/button_delete_medium.gif' width='51' height='17' name='bDeleteMAWB'
                                    onclick='DeleteMAWB()' style="cursor: hand"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="32" align="right" valign="bottom">
                    <div id="print">
                        <img src="/ASP/Images/icon_printer_preview.gif" width="45" height="29" align="absbottom"><a
                           href="javascript:void(0);" id="NewPrintVeiw2">Bill of Lading </a>
                    </div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

</html>
