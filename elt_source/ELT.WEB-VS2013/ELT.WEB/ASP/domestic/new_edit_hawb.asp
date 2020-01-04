<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
'// -------------------- Main ---------------------------------------------------------------------

    Dim vMAWB,vHAWB,vMode,i,j,aChargeItem,aOtherCharge,aHAWBPrefix,aNextHAWB
    Dim hawbOCTableList,hawbWCTable,hawbTable,invQTable,vPONum,vSONum
    
    vMAWB = checkBlank(Request.QueryString.Item("MAWB"),"")
    vHAWB = checkBlank(Request.QueryString.Item("HAWB"),"")
    vMode = checkBlank(Request.QueryString.Item("mode"),"new")
   

    eltConn.BeginTrans
    main_sub()
    If vMode = "saveNMove" Then
        Response.Redirect("hawb_addi.asp?HAWB=" & hawbTable("HAWB_NUM") & "&inbound=" & hawbTable("is_inbound"))
        Response.End()
    End If
    eltConn.CommitTrans
    
'//-------------------------- Main Sub --------------------------------------------------------------

    Sub main_sub
        If checkBlank(Request.QueryString.Item("Edit"),"no") = "yes" Then
            vMode = "search"
        End If
        
        Set aOtherCharge = Server.CreateObject("System.Collections.ArrayList")
        Set aChargeItem = Server.CreateObject("System.Collections.ArrayList")
        Set aHAWBPrefix = Server.CreateObject("System.Collections.ArrayList")
        Set aNextHAWB = Server.CreateObject("System.Collections.ArrayList")
        Set hawbOCTableList = Server.CreateObject("System.Collections.ArrayList")
        Set hawbTable = Server.CreateObject("System.Collections.HashTable")
        Set hawbWCTable = Server.CreateObject("System.Collections.HashTable")
        Set invQTable = Server.CreateObject("System.Collections.HashTable")

        get_charge_item_list()
        get_hawb_prefix_list()
        
        If vMode = "saveNMove" Or vMode = "saveNQ" Then
            vHAWB = checkBlank(Request.Form.Item("txtHAWBNum"),"")
            vMAWB = checkBlank(Request.Form.Item("hMAWB"),"")
            If update_hawb_master() And vHAWB <> "" Then
                delete_all_charges()
                If update_other_charge() Or update_weight_charge() Then
                    If update_invoice_queue() Then
                        set_hawb_invoiced()
                    End If
                End If
                update_data_transfer()
            End If
            Exit Sub
        Elseif vMode = "search" Then
            get_hawb_master()
            get_other_charge()
            get_weight_charge()
        Elseif vMode = "delete" Then
            delete_hawb_all()
        Elseif vMode = "transfer" Then
   
            If checkBlank(Request.QueryString("PONum"),"") <> "" Then
    
                get_pickup_order()
            Elseif checkBlank(Request.QueryString("SONum"),"") <> "" Then
                get_ship_out()
            End If
        End If
    End Sub
    
    Sub update_data_transfer()
        Dim SQL
        
        vPONum = Request.Form("hPONum").Item
        vSONum = Request.Form("hSONum").Item
        
        If vSONum <> "" Then
	        SQL="UPDATE warehouse_shipout SET file_type='AE',master_num=N'" & vMAWB _
	            & "',house_num=N'" & vHAWB & "' WHERE so_num=N'" & vSONum & "'"
	        eltConn.Execute(SQL)
	    Elseif vPONum <> "" Then
            SQL="UPDATE pickup_order SET file_type='AE',MAWB_NUM=N'" & vMAWB _
	            & "',HAWB_NUM=N'" & vHAWB & "' WHERE po_num=N'" & vPONum & "'"
	        eltConn.Execute(SQL)
        End If
    End Sub
    
    Sub get_pickup_order()
        Dim SQL,dataObj
        vPONum = Request.QueryString("PONum")
        SQL = "SELECT Shipper_Name,Shipper_account_number,Shipper_Info,Desc2," _
            & "Carrier_account_number AS Consignee_acct_num,is_hazard AS danger_good," _
            & "Carrier_Name AS Consignee_Name,Carrier_Info AS Consignee_Info,"_
            & "Handling_Info,Total_Gross_Weight,Total_Gross_Weight AS Total_Chargeable_Weight,Weight_Scale, Total_Pieces  " _
            & "FROM pickup_order WHERE elt_account_number=" & elt_account_number & " AND po_num='" & vPONum & "'"



        If Not IsDataExist(SQL) Then
            Response.Write("<script>alert('The number does not exist'); window.location.href='./new_edit_hawb.asp?mode=new'</script>")
            Response.End()
        End If
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbTable = dataObj.GetRowTable(0)
            
    End Sub
    
    Sub get_ship_out()
        Dim SQL, rs
        vSONum = Request.QueryString("SONum")
        Set rs = Server.CreateObject("ADODB.RecordSet")
        
        SQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" _
            & elt_account_number & " AND so_num=N'" & vSONum & "'"

        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            hawbTable.Add "Shipper_account_number", rs("customer_acct").value
            hawbTable.Add "Shipper_Name", GetBusinessName(rs("customer_acct").value)
            hawbTable.Add "Shipper_Info", GetOrgNameAddress(rs("customer_acct").value)
            hawbTable.Add "Carrier_account_number", rs("consignee_acct").value
            hawbTable.Add "Carrier_Name", GetBusinessName(rs("consignee_acct").value)
            hawbTable.Add "Carrier_Info", GetOrgNameAddress(rs("consignee_acct").value) 
        End If
        
        rs.close()
        
        SQL = "SELECT * FROM warehouse_receipt a LEFT OUTER JOIN warehouse_history b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) " _
            & "WHERE a.elt_account_number=" + elt_account_number + " AND b.so_num=N'" _
            & vSONum & "' AND history_type='Ship-out Made'"
            
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Dim vDesc,vTotalPiece
        vTotalPiece = 0
        Do While Not rs.EOF And Not rs.BOF
            vDesc = vDesc & rs("item_desc") & chr(10)
            hawbTable.Add "Handling_Info", rs("handling_info") & chr(10)
            vTotalPiece = vTotalPiece + CInt(rs("item_piece_shipout"))
            rs.MoveNext()
        Loop
        hawbTable.Add "Total_Pieces", vTotalPiece
        hawbTable.Add "Desc2", vDesc
    End Sub
'//-------------------------- Misc Sub --------------------------------------------------------------

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

    Function GetNextInvQId
        Dim vQueueID,SQL,rs
        Set rs = Server.CreateObject("ADODB.RecordSet")
        SQL = "select max(queue_id) as queue_id from invoice_queue where elt_account_number=" & elt_account_number
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        If Not rs.EOF And Not rs.BOF Then
            vQueueID = checkBlank(rs("queue_id"),0) + 1
        Else
            vQueueID = 1
        End If
        rs.close

        GetNextInvQId = vQueueID
    End Function
    
    Sub get_hawb_prefix_list
    
        Dim SQL,rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
	    SQL= "select prefix,next_no from user_prefix where elt_account_number = " _
	        & elt_account_number & " and type='DOME' order by seq_num"
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.EOF
		    aHAWBPrefix.Add rs("prefix").value
		    aNextHAWB.Add rs("next_no").value
		    rs.MoveNext
	    Loop
	    rs.Close
	    
    End Sub

'//------------------------- Updating ------------------------------------------------------------

    Function update_hawb_master
        
        Dim SQL,dataObj
        
        hawbTable.Add "elt_account_number", elt_account_number
        hawbTable.Add "HAWB_NUM", Request.Form.Item("txtHAWBNum")
        hawbTable.Add "MAWB_NUM", Request.Form.Item("txtMAWBNum")
        hawbTable.Add "Agent_Name", Request.Form.Item("lstFFAgent")
        hawbTable.Add "Agent_Info", GetBusinessInfo(Request.Form.Item("hFFAgentAcct"))
        hawbTable.Add "Agent_No", Request.Form.Item("hFFAgentAcct")
        hawbTable.Add "Shipper_Name", Request.Form.Item("lstShipperName")
        hawbTable.Add "Shipper_account_number", Request.Form.Item("hShipperAcct")
        hawbTable.Add "Shipper_Info", Request.Form.Item("txtShipperInfo")
        hawbTable.Add "Consignee_Name", Request.Form.Item("lstConsigneeName")
        hawbTable.Add "Consignee_Info", Request.Form.Item("txtConsigneeInfo")
        hawbTable.Add "Consignee_acct_num", Request.Form.Item("hConsigneeAcct")
        hawbTable.Add "Departure_Airport", Request.Form.Item("txtDepartureAirport")
        hawbTable.Add "Account_Info", Request.Form.Item("txtBillToInfo")
        hawbTable.Add "Currency", "USD"
        
        If Request.Form.Item("chkBilling") = "S" Then
            hawbTable.Add "PPO_1", "Y"
            hawbTable.Add "PPO_2", "Y"
            hawbTable.Add "COLL_1", ""
            hawbTable.Add "COLL_2", ""
            hawbTable.Add "Charge_Code", "P"
            hawbTable.Add "Prepaid_Weight_Charge", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
        Else
            hawbTable.Add "PPO_1", ""
            hawbTable.Add "PPO_2", ""
            hawbTable.Add "COLL_1", "N"
            hawbTable.Add "COLL_2", "N"
            hawbTable.Add "Charge_Code", "C"
            hawbTable.Add "Collect_Weight_Charge", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
        End If
        
        hawbTable.Add "show_other_charge_rate", "Y"
        hawbTable.Add "show_weight_charge_rate", "Y"
        
        hawbTable.Add "Declared_Value_Carriage", formatNumberPlus(Request.Form.Item("txtDeclaredValueCarriage"),2)
        hawbTable.Add "Dest_Airport", Request.Form.Item("txtDestAirport")
        hawbTable.Add "Insurance_AMT", formatNumberPlus(Request.Form.Item("txtInsuranceAmt"),2)
        hawbTable.Add "Handling_Info", Request.Form.Item("txtHandlingInfo")
        
        
        '// Save weight info when additional hawb was not made
        
        If Request.Form.Item("chkHouseType") = "N" Then
            hawbTable.Add "Total_Pieces", formatNumberPlus(Request.Form.Item("txtPiece"),0)
            hawbTable.Add "Total_Gross_Weight", formatNumberPlus(Request.Form.Item("txtGrossWeight"),2)
            hawbTable.Add "Total_Chargeable_Weight", formatNumberPlus(Request.Form.Item("txtChargeableWeight"),2)
            hawbTable.Add "Weight_Scale", "L"
            hawbTable.Add "Total_Weight_Charge_HAWB", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
            hawbTable.Add "Adjusted_Weight", formatNumberPlus(Request.Form.Item("txtChargeableWeight"),2)
        End If
        
        hawbTable.Add "Date_Executed", Request.Form.Item("txtExecutedDate")
        hawbTable.Add "Desc2", Request.Form.Item("txtItemDesc")
        hawbTable.Add "Notify_no", ConvertAnyValue(Request.Form.Item("hNotifyAcct"),"Long",0)
        hawbTable.Add "SalesPerson", Request.Form.Item("lstSalesRP")
        hawbTable.Add "shipper_reference_num", Request.Form.Item("txtShipperReferenceNum")
        hawbTable.Add "service_level", Request.Form.Item("txtServiceLevel")
        hawbTable.Add "cod_amount", formatNumberPlus(Request.Form.Item("txtCODAmount"),2)
        hawbTable.Add "shipper_cod_amount", formatNumberPlus(Request.Form.Item("txtShipperCODAmount"),2)
        hawbTable.Add "bill_to_party", Request.Form.Item("chkBilling")
        hawbTable.Add "danger_good", Request.Form.Item("chkDanger")
        hawbTable.Add "purchase_num", Request.Form.Item("txtPurchaseNum")
        hawbTable.Add "service_level_other", Request.Form.Item("txtServiceLevel2")
        hawbTable.Add "is_agent_house", Request.Form.Item("chkHouseType")
        hawbTable.Add "is_inbound", Request.Form.Item("chkIsInbound")
        hawbTable.Add "export_date", Request.Form.Item("txtExecutedDate")
        
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("hawb_master")
        
        SQL = "SELECT * FROM hawb_master WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & Request.Form.Item("txtHAWBNum") & "' AND is_dome='Y'"
        
        update_hawb_master = dataObj.UpdateDBRow(SQL, hawbTable)
        
    End Function

    Function delete_all_charges
        Dim rs, SQL
        If Request.Form.Item("chkHouseType") = "N" Then
            SQL = "BEGIN TRANSACTION " _
                & " DELETE FROM invoice_queue WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & hawbTable("HAWB_NUM") & "'" _
                & " DELETE FROM hawb_other_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & hawbTable("HAWB_NUM") & "'" _
                & " DELETE FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & hawbTable("HAWB_NUM") & "'" _
                & " COMMIT"
        
            Set rs = Server.CreateObject("ADODB.Recordset")
            Set rs = eltConn.execute(SQL)
        End If
    End Function
    
    Function update_other_charge
    
        Dim tmpTable,tranNo,rs
        Dim SQL,dataObj,resVal
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("hawb_other_charge")
        resVal = False

        SQL = "SELECT TOP 0 * FROM hawb_other_charge"
        tranNo = 1
        
        For i=1 To Request.Form.Item("hChargeCode").count
            If checkBlank(Request.Form.Item("hChargeCode")(i),"") <> "" Then
                Set tmpTable = Server.CreateObject("System.Collections.HashTable")
                tmpTable.Add "elt_account_number", elt_account_number
                tmpTable.Add "HAWB_NUM", Request.Form.Item("txtHAWBNum")
                tmpTable.Add "Tran_No", CInt(tranNo)
                tmpTable.Add "Coll_Prepaid", hawbTable("Charge_Code")
                tmpTable.Add "charge_code", Request.Form.Item("hChargeCode")(i)
                tmpTable.Add "Charge_Desc", Request.Form.Item("txtChargeDesc")(i)
                tmpTable.Add "Amt_HAWB", ConvertAnyValue(Request.Form.Item("txtChargeAmt")(i),"Amount",0)
                tmpTable.Add "invoice_only", Request.Form.Item("chkHouseType")
                hawbOCTableList.Add tmpTable
                tranNo = tranNo + 1

                Call dataObj.insertDBRow(SQL, tmpTable)
                resVal = True
            End If
        Next
        update_other_charge = resVal
        
    End Function
    
    Function update_weight_charge
    
        Dim resVal
        resVal = False

        If Request.Form.Item("txtPiece").Count > 0 Then
            hawbWCTable.Add "elt_account_number", elt_account_number
            hawbWCTable.Add "HAWB_NUM", Request.Form.Item("txtHAWBNum")
            hawbWCTable.Add "Tran_No", 1
            hawbWCTable.Add "No_Pieces", ConvertAnyValue(Request.Form.Item("txtPiece"),"Long",0)
            hawbWCTable.Add "unit_qty", "PCS"
            hawbWCTable.Add "Gross_Weight", formatNumberPlus(Request.Form.Item("txtGrossWeight"),2)
            hawbWCTable.Add "Adjusted_Weight", Request.Form.Item("txtChargeableWeight")
            hawbWCTable.Add "Kg_Lb", "L"
            hawbWCTable.Add "cubic_inches", formatNumberPlus(Request.Form.Item("txtCubicInches"),2)
            hawbWCTable.Add "dimension_factor", Request.Form.Item("hDimFactor")
            hawbWCTable.Add "Dimension", Request.Form.Item("txtCubicWeight")
            hawbWCTable.Add "Dem_Detail", Request.Form.Item("hDimDetail")
            hawbWCTable.Add "Chargeable_Weight", formatNumberPlus(Request.Form.Item("txtChargeableWeight"),2)
            hawbWCTable.Add "Rate_Charge", Request.Form.Item("txtRateCharge")
            hawbWCTable.Add "Total_Charge", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
            hawbWCTable.Add "invoice_only", Request.Form.Item("chkHouseType")
'// Disabled - Saves Only when total charge is greater than 0 /////////////////////////////////////////////////////
'// If formatNumberPlus(Request.Form.Item("txtTotalCharge"),2) > 0 Then
            Dim SQL,dataObj
            Set dataObj = new DataManager
            dataObj.SetColumnKeys("hawb_weight_charge")
            
            SQL = "SELECT * FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & Request.Form.Item("txtHAWBNum") & "'"
            
            update_weight_charge = dataObj.insertDBRow(SQL, hawbWCTable)
            resVal = True
'// End If
'////////////////////////////////////////////////////////////////////////////////////////////////////////
        End If
        update_weight_charge = resVal
    End Function
    
    Function update_invoice_queue
        If Request.Form.Item("chkHouseType") = "N" Then
            invQTable.Add "elt_account_number", elt_account_number
            invQTable.Add "queue_id", GetNextInvQId()
            invQTable.Add "inqueue_date", Request.Form.Item("txtExecutedDate")
            invQTable.Add "agent_shipper", "S"
            invQTable.Add "hawb_num", Request.Form.Item("txtHAWBNum")
            invQTable.Add "mawb_num", Request.Form.Item("txtMAWBNum")
            
            If Request.Form.Item("chkBilling") = "S" Then
                invQTable.Add "bill_to", Request.Form.Item("lstShipperName")
                invQTable.Add "bill_to_org_acct", Request.Form.Item("hShipperAcct")
            Elseif Request.Form.Item("chkBilling") = "3" Then
                invQTable.Add "bill_to", GetBusinessName(Request.Form.Item("hNotifyAcct"))
                invQTable.Add "bill_to_org_acct", Request.Form.Item("hNotifyAcct")
            Else
                invQTable.Add "bill_to", Request.Form.Item("lstConsigneeName")
                invQTable.Add "bill_to_org_acct", Request.Form.Item("hConsigneeAcct")
            End If
                
            invQTable.Add "air_ocean", "D"
            invQTable.Add "master_only", "N"
            invQTable.Add "invoiced", "N"
            invQTable.Add "is_dome", "Y"
            
            Dim SQL,dataObj
            Set dataObj = new DataManager
            dataObj.SetColumnKeys("invoice_queue")
            
            If checkBlank(invQTable("bill_to_org_acct"),"") <> "" Then
                SQL = "SELECT b.invoice_no FROM hawb_master a LEFT OUTER JOIN invoice b ON " _
                    & "(a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num " _
                    & "AND a.mawb_num=b.mawb_num AND b.Air_Ocean='A') " _
                    & "WHERE a.is_invoice_queued='Y' AND a.elt_account_number=" & elt_account_number _
                    & " AND a.hawb_num='" & Request.Form.Item("txtHAWBNum") & "'"
                Dim tmpInvNo
                tmpInvNo = GetSQLResult(SQL, NULL)
                If checkBlank(tmpInvNo,"") <> "" Then
                    Response.Write("<script>alert('Invoice No " & tmpInvNo & " was already created for this bill');</script>")
                    update_invoice_queue = False
                Else
                    SQL = "SELECT * FROM invoice_queue WHERE elt_account_number=" & elt_account_number _
                        & " AND hawb_num='" & Request.Form.Item("txtHAWBNum") & "'"
                    update_invoice_queue = dataObj.UpdateDBRow(SQL, invQTable)
                End If
            End If
        End If
    End Function
    
    Sub set_hawb_invoiced()
        Dim SQL
        SQL="UPDATE hawb_master SET is_invoice_queued='Y' WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & Request.Form.Item("txtHAWBNum") & "'"
        eltConn.Execute(SQL)
    End Sub
    
'//----------------------- Retreiving -------------------------------------------------------------

    Sub get_hawb_master
        Dim SQL,dataObj
        SQL = "SELECT a.*,b.master_type FROM hawb_master a LEFT OUTER JOIN mawb_master b ON " _
            & "(a.elt_account_number=b.elt_Account_number AND a.mawb_num=b.mawb_num) " _
            & "WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.hawb_num='" & vHAWB & "' AND a.is_dome='Y'"
        If Not IsDataExist(SQL) Then
            Response.Write("<script>alert('The number does not exist'); window.location.href='./new_edit_hawb.asp?mode=new'</script>")
            Response.End()
        End If
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbTable = dataObj.GetRowTable(0)
    End Sub
    
    Sub get_other_charge
        Dim SQL,dataObj
        SQL = "SELECT * FROM hawb_other_charge WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "' AND invoice_only='N'"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbOCTableList = dataObj.GetDataList
    End Sub
    
    Sub get_weight_charge
        Dim SQL,dataObj
        SQL = "SELECT * FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "'"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbWCTable = dataObj.GetRowTable(0)
    End Sub
    
'//------------------- Removing ----------------------------------------------------------------------
    
    Sub delete_hawb_all
        Dim SQL,rs
        SQL = "BEGIN TRANSACTION " _
            & "DELETE FROM hawb_master WHERE hawb_num='" & vHAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM hawb_other_charge WHERE hawb_num='" & vHAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM hawb_weight_charge WHERE hawb_num='" & vHAWB & "' AND elt_account_number=" & elt_account_number _
            & "DELETE FROM invoice_queue WHERE hawb_num='" & vHAWB & "' AND elt_account_number=" & elt_account_number _
            & "COMMIT"
  
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub
    
'//------------------ Page Error Handling ------------------------------------------------------------
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Domestic Export</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">

    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript">
    // Additional utility Functions
	   
        function showtip(){}
        
        
        function other_ser(){
			var oth_SL=document.getElementById("txtServiceLevel").value 
			if (oth_SL=="Other"){
			document.getElementById("txtServiceLevel2").readOnly=false
	        document.getElementById("txtServiceLevel2").style.background="#FFFFFF";
			}
			else
			{
			document.getElementById("txtServiceLevel2").readOnly=true
			document.getElementById("txtServiceLevel2").style.background="#CCCCCC";
			document.getElementById("txtServiceLevel2").value="";
			}
        }

        function AddOtherCharge(){
            var table = document.getElementById("tblOtherCharege");

            //get existing rows
            var rows = document.getElementById("tblOtherCharege").rows;
            var tds;
            if (rows.length > 0)
                tds = rows[0].innerHTML;

            var new_rowid = rows.length;
            var row = table.insertRow(rows.length);
            row.id = new_rowid;
            //alert("new_rowid: " +new_rowid);
            //alert("newrow :" +tds);
            row.innerHTML = tds;
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
        
        function ChargeItemChange(thisObj){
            // no,price,name,desc

            var rowID = thisObj.parentNode.parentNode.id;


           

            
            if(thisObj.value == ""){
                document.getElementsByName("txtChargeDesc")[rowID].value = "";
                document.getElementsByName("txtChargeAmt")[rowID].value = "";   
                document.getElementsByName("hChargeCode")[rowID].value = "";   
            }
            else
            {
                var ocIndex = $("select.lstChargeCode").get(rowID).selectedIndex;
                var ocValue = $("select.lstChargeCode").get(rowID).options[ocIndex].value;
                
                ocArray = ocValue.split("-");
                document.getElementsByName("txtChargeDesc")[rowID].value = ocArray[3];
                document.getElementsByName("txtChargeAmt")[rowID].value = ocArray[1];   
                document.getElementsByName("hChargeCode")[rowID].value = ocArray[0];   
            }
        }
        
        function findSelect(oSelect,selVal){
            oSelect.options.selectedIndex = 0;
            for(var i=0;i<oSelect.options.length;i++){
                var tmpText = oSelect.options[i].value;
                if(tmpText != "" && tmpText.match(selVal) != null){
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        function setField(xmlTag,htmlTag,xmlObj){
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null 
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else{
                document.getElementById(htmlTag).value = "";
            }
        }

        function setSelectField(xmlTag,htmlTag,xmlObj){
            var htmlObj = document.getElementById(htmlTag);
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null 
                && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null){
                for(var i=0;i<htmlObj.children(0).length;i++){
                    if(htmlObj.children(0).get(i).value.substring == xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue){
                        htmlObj.options(i).selected = true;
                    }
                }
            }
            else{
                htmlObj.selectedIndex = -1;
            }
        }
        
        function setTotalWeightCharge(){
            var vPieces = parseInt(document.getElementById("txtPiece").value);
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
        
    </script>
     <script>
        
$(document).ready(function (){
           
    if(parent.PrepPDFPrintOptions==undefined)
    {    
        $("#NewPrintVeiw1").click(
           function () { 
               if(confirm("You cannot print this document in a popup mode. Would you like to try in full page mode?"))
               {
                   opener.top.location.href="/DomesticFreight/HouseAirBill/"+window.location.href.split("?")[1];
                   window.close();
               }
               else
               { 
                   window.close();
               } 
           });
    }
});

    </script>
    <script type="text/javascript">
    // Event Controllers
    
        function DimCalClick(){
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280";
            var childWindow = window.open("new_dimcal.asp?ItemNum=", "Dimension_Calculation", props);
            childWindow.focus();
        }
        
        function MAWBEditClick(){
        
            var vMAWB = document.getElementById("lstSearchNum").value;
            var vMAWBType = document.getElementById("hMasterType").value;

            if(vMAWB != ""){
                /*
                jPopUpNormal();
                document.form1.action = "new_edit_mawb.asp?WindowName=popUpWindow&Edit=yes&mawb=" + vMAWB;
                document.form1.method = "POST";
                document.form1.target = "popUpWindow";
                document.form1.submit();
                */
               
                window.top.location.href = "/DomesticFreight/MasterAirBill/WindowName=popUpWindow&Edit=yes&mawb=" + vMAWB;
            }
        }
        
        function lookup(){
            var searchVal = document.getElementById("txtqHAWB").value;
            if(searchVal == "Search Here" || searchVal == ""){
                alert("Please, enter a House AirBill number to search.");
                return false;
            }
            document.form1.action = "new_edit_hawb.asp?mode=search&HAWB=" + searchVal;
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function DeleteHAWB(){
            var searchVal = document.getElementById("txtHAWBNum").value;
            if(searchVal == ""){
                alert("Please, select a House AirBill to delete.");
                return false;
            }
            
            var ans = confirm("Do you really want to delete House AirBill No. '" + searchVal + "' ?");
            if(!ans){ return false;}
            document.form1.action = "new_edit_hawb.asp?mode=delete&HAWB=" + searchVal;
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function NewPrintVeiw(){
            var searchVal = document.getElementById("txtHAWBNum").value;
            if(searchVal == ""){
                alert("Please, select a House AirBill to view.");
                return false;
            }
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
            window.open("view_print.asp?sType=house&hawb=" + searchVal, "popUpWindow", props);
        }
        
        function GoToAddition(arg){
            var nextHAWB = document.getElementById("lstHAWBPrefix").value;
            var newNum = tmpUrl = "";
            
            if(document.getElementById("txtHAWBNum").value == "" || arg == "SAN"){
                if(document.getElementsByName("chkHouseType")[1].checked){
                    tmpUrl = "new_edit_hawb_OK.asp?SaveAsNew=yes&Prefix=" + nextHAWB.split("-")[0]
                        + "&NEXTPREFIX=" + nextHAWB.split("-")[1] + "&salesPerson=" 
                        + document.getElementById("lstSalesRP").value;
                    newNum = showModalDialog("hawb_Dialog.asp?" + tmpUrl,"","dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes");
                }
                else{
                    tmpUrl = "hawb_numbering_manual.asp";
                    newNum = showModalDialog(tmpUrl, "", "dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes");
                }
                if(newNum == null || newNum == ""){
		                return false;
                }
                else{
                    document.getElementById("txtHAWBNum").value = newNum;
                }
            }
            document.form1.action = "new_edit_hawb.asp?mode=saveNMove";
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function bsaveClick(arg){
            var nextHAWB = document.getElementById("lstHAWBPrefix").value;
            var newNum = tmpUrl = "";
            
            if(document.getElementById("txtHAWBNum").value == "" || arg == "SAN"){
                if(document.getElementsByName("chkHouseType")[1].checked){
                    tmpUrl = "new_edit_hawb_OK.asp?SaveAsNew=yes&Prefix=" + nextHAWB.split("-")[0]
                        + "&NEXTPREFIX=" + nextHAWB.split("-")[1] + "&salesPerson=" 
                        + document.getElementById("lstSalesRP").value;
                    newNum = showModalDialog("hawb_Dialog.asp?" + tmpUrl,"","dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no;center:yes");
                }
                else{
                    tmpUrl = "hawb_numbering_manual.asp";
                    newNum = showModalDialog(tmpUrl, "", "dialogWidth:400px; dialogHeight:170px; help:no; status:no; scroll:no; center:yes");
                }
                if(newNum == null || newNum == ""){
		                return false;
                }
                else{
                    document.getElementById("txtHAWBNum").value = newNum;
                }
            }
            document.form1.action = "new_edit_hawb.asp?mode=saveNQ";
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function checkExistMAWB(argObj){
            if(document.getElementById("txtMAWBNum").value != ""){
                alert("This master has already been declared as inbound/outbound shipment");
                argObj.blur();
                return false;
            }
        }
        
    </script>

    <script type="text/javascript">        
    // Editable drop-down controllers
    
        function lstSearchNumChange(argV,argL){
        
            var divObj = document.getElementById("lstSearchNumDiv");
            var xmlObj = null;
            
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
            divObj.style.height = "0px";
		    divObj.innerHTML = "";
		    
		    document.getElementById("hSearchNum").value = argV;
		    document.getElementById("lstSearchNum").value = argL;
		    
		    var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=view&bill=" 
		        + argV + "&stype=domestic_master";

            new ajax.xhr.Request('GET','',url,loadBookingValues,'','','','');
		    
        }
        
        function searchNumFill(obj,changeFunction,vHeight,event){
            var qStr = obj.value;
            var keyCode = event.keyCode;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DUB&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var url = "/ASP/ajaxFunctions/ajax2_mawb_header.asp?mode=list&mtype=DUB";
            
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        
        function lstFFAgentChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hFFAgentAcct");
            var txtObj = document.getElementById("lstFFAgent");
            var divObj = document.getElementById("lstFFAgentDiv");
            var infoObj = document.getElementById("hFFAgentInfo");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
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
            
    </script>

    <script type="text/vbscript" language="vbscript">
        Function vbMsg(questionTxt,title,buttons)
            Dim returnVal
            returnVal = MsgBox(questionTxt,buttons,title)
            vbMsg = returnVal
        End Function    
    </script>

    <script type="text/javascript">
    // Initialization Controllers
    
        function setRadioCheck(ObjList,val){
            for(var i=0; i<ObjList.length;i++){
                if(ObjList[i].value == val){
                    ObjList[i].checked = true;
                }
                else{
                    ObjList[i].checked = false;
                }
            }
        }
        
        function loadBookingValues(req,field,tmpVal,tWidth,tMaxLength,url){
            if (req.readyState == 4){   
                if (req.status == 200){
                    var xmlObj = req.responseXML;
                    try{
                        setField("mawb_no","txtMAWBNum",xmlObj);
                        setField("master_type","hMasterType",xmlObj);
                        setRadioCheck(document.getElementsByName("chkIsInbound"),xmlObj.getElementsByTagName("is_inbound")[0].childNodes[0].nodeValue);
                        
                        //var answer = vbMsg("Do you want to retrieve master/booking information?","Retrieving booking/master Info.",4);
                        //if(answer == 6){
                            /*
                            setField("Shipper_account_number","hShipperAcct",xmlObj);
                            setField("Shipper_Name","lstShipperName",xmlObj);
                            setField("Shipper_Info","txtShipperInfo",xmlObj);
                            setField("Consignee_acct_num","hConsigneeAcct",xmlObj);
                            setField("Consignee_Name","lstConsigneeName",xmlObj);
                            setField("Consignee_Info","txtConsigneeInfo",xmlObj);
                            setField("Notify_no","hNotifyAcct",xmlObj);
                            setField("Account_Info","txtBillToInfo",xmlObj);
                            setField("Notify_Name","lstNotifyName",xmlObj);
                            setField("Declared_Value_Carriage","txtDeclaredValueCarriage",xmlObj);
                            setField("Insurance_AMT","txtInsuranceAmt",xmlObj);
                            setField("cod_amount","txtCODAmount",xmlObj);
                            setField("shipper_reference_num","txtShipperReferenceNum",xmlObj);
                            setSelectField("service_level","txtServiceLevel",xmlObj);
                            setField("service_level_other","txtServiceLevel2",xmlObj);
                            */
                            setField("inbound_customer_acct","hFFAgentAcct",xmlObj);
                            setField("Customer_Name","lstFFAgent",xmlObj);
                            setField("Origin_Port_Location","txtDepartureAirport",xmlObj);
                            setField("Dest_Port_Location","txtDestAirport",xmlObj);
                        //}
                    }catch(err){}
                }
            }
        }
        
        function loadValues(){
        
            try{
                <% If agent_is_cartage = "Y" Then %>
                setRadioCheck(document.getElementsByName("chkHouseType"),"<%=checkBlank(hawbTable("is_agent_house"),"Y") %>");  
                document.getElementById("tblHouseType").style.visibility = "visible";
                document.getElementById("tblBookingType").style.visibility = "visible";
                document.getElementById("spnAddInfoTop").style.visibility = "visible";
                document.getElementById("spnAddInfoBot").style.visibility = "visible";
                document.getElementById("tblFFAgent").style.visibility = "visible";
                document.getElementById("spanFFAgent").style.visibility = "visible";
                <% Else %>
                setRadioCheck(document.getElementsByName("chkHouseType"),"<%=checkBlank(hawbTable("is_agent_house"),"N") %>"); 
                document.getElementById("tblHouseType").style.visibility = "hidden";
                document.getElementById("tblBookingType").style.visibility = "hidden";
                document.getElementById("spnAddInfoTop").style.visibility = "hidden";
                document.getElementById("spnAddInfoBot").style.visibility = "hidden";
                document.getElementById("tblFFAgent").style.visibility = "hidden";
                document.getElementById("spanFFAgent").style.visibility = "hidden";
                <% End If %>
                
                <% If checkBlank(Request.QueryString.Item("WindowName"),"") <> "" Then %>
                window.name="<%=Request.QueryString.Item("WindowName") %>";
                <% End If %>
                        
                document.getElementById("txtHAWBNum").value = "<%=MakeJavaString(hawbTable("HAWB_NUM")) %>";
                document.getElementById("txtMAWBNum").value = "<%=MakeJavaString(hawbTable("MAWB_NUM")) %>";
                document.getElementById("hMasterType").value = "<%=MakeJavaString(hawbTable("master_type")) %>";
                document.getElementById("lstSearchNum").value = "<%=MakeJavaString(hawbTable("MAWB_NUM")) %>";
                document.getElementById("hSearchNum").value = "<%=MakeJavaString(hawbTable("MAWB_NUM")) %>";
                document.getElementById("lstFFAgent").value = "<%=MakeJavaString(hawbTable("Agent_Name")) %>";
                document.getElementById("hFFAgentAcct").value = "<%=MakeJavaString(hawbTable("Agent_No")) %>";
                document.getElementById("lstShipperName").value = "<%=MakeJavaString(hawbTable("Shipper_Name")) %>";
                document.getElementById("hShipperAcct").value = "<%=MakeJavaString(hawbTable("Shipper_account_number")) %>";
                document.getElementById("txtShipperInfo").value = "<%=MakeJavaString(hawbTable("Shipper_Info")) %>";
                document.getElementById("lstConsigneeName").value = "<%=MakeJavaString(hawbTable("Consignee_Name")) %>";
                document.getElementById("txtConsigneeInfo").value = "<%=MakeJavaString(hawbTable("Consignee_Info")) %>";
                document.getElementById("hConsigneeAcct").value = "<%=MakeJavaString(hawbTable("Consignee_acct_num")) %>";
                document.getElementById("txtDepartureAirport").value = "<%=MakeJavaString(hawbTable("Departure_Airport")) %>";
                document.getElementById("txtBillToInfo").value = "<%=MakeJavaString(hawbTable("Account_Info")) %>";
                document.getElementById("txtDeclaredValueCarriage").value = "<%=MakeJavaString(hawbTable("Declared_Value_Carriage")) %>";
                document.getElementById("txtDestAirport").value = "<%=MakeJavaString(hawbTable("Dest_Airport")) %>";
                document.getElementById("txtInsuranceAmt").value = "<%=formatNumberPlus(CheckBlank(hawbTable("Insurance_AMT"),0),2) %>";
                document.getElementById("txtHandlingInfo").value = "<%=MakeJavaString(hawbTable("Handling_Info")) %>";
                document.getElementById("txtPiece").value = "<%=MakeJavaString(hawbTable("Total_Pieces")) %>";
                document.getElementById("txtGrossWeight").value = "<%=MakeJavaString(hawbTable("Total_Gross_Weight")) %>";
                document.getElementById("txtChargeableWeight").value = "<%=MakeJavaString(hawbTable("Total_Chargeable_Weight")) %>";
                document.getElementById("txtTotalCharge").value = "<%=formatNumberPlus(ConvertAnyValue(hawbTable("Total_Weight_Charge_HAWB"),"Amount",0),2 )%>";
                document.getElementById("hDimDetail").value = "<%=MakeJavaString(hawbWCTable("Dem_Detail")) %>";
                document.getElementById("hDimFactor").value = "<%=MakeJavaString(hawbWCTable("dimension_factor")) %>";
                document.getElementById("txtCubicInches").value = "<%=MakeJavaString(hawbWCTable("cubic_inches")) %>";
                document.getElementById("txtCubicWeight").value = "<%=MakeJavaString(hawbWCTable("Dimension")) %>";
                document.getElementById("txtRateCharge").value = "<%=MakeJavaString(hawbWCTable("Rate_Charge")) %>";
                document.getElementById("txtExecutedDate").value = "<%=checkBlank(hawbTable("Date_Executed"),Date()) %>";
                document.getElementById("txtItemDesc").value = "<%=MakeJavaString(hawbTable("Desc2")) %>";
                document.getElementById("hNotifyAcct").value = "<%=MakeJavaString(hawbTable("Notify_no")) %>";
                document.getElementById("lstNotifyName").value = "<%=MakeJavaString(GetBusinessName(hawbTable("Notify_no"))) %>";
                document.getElementById("lstSalesRP").value = "<%=MakeJavaString(hawbTable("SalesPerson")) %>";
                document.getElementById("txtShipperReferenceNum").value = "<%=MakeJavaString(hawbTable("shipper_reference_num")) %>";
                document.getElementById("txtServiceLevel").value = "<%=MakeJavaString(hawbTable("service_level")) %>";
                document.getElementById("txtCODAmount").value = "<%=formatNumberPlus(ConvertAnyValue(hawbTable("cod_amount"),"Amount",0),2) %>";
                document.getElementById("txtShipperCODAmount").value = "<%=formatNumberPlus(ConvertAnyValue(hawbTable("shipper_cod_amount"),"Amount",0),2) %>";
                document.getElementById("txtPurchaseNum").value = "<%=MakeJavaString(hawbTable("purchase_num")) %>";
                document.getElementById("txtServiceLevel2").value = "<%=MakeJavaString(hawbTable("service_level_other")) %>";

                setRadioCheck(document.getElementsByName("chkBilling"),"<%=MakeJavaString(hawbTable("bill_to_party")) %>");
                setRadioCheck(document.getElementsByName("chkDanger"),"<%=MakeJavaString(hawbTable("danger_good")) %>");
                
                <% If hawbTable("is_inbound") <> "" Then %>
                setRadioCheck(document.getElementsByName("chkIsInbound"),"<%=MakeJavaString(hawbTable("is_inbound")) %>");
                <% End If %>
                
                if (document.getElementById("txtServiceLevel").value == "Other"){
                    document.getElementById("txtServiceLevel2").style.backgroundColor = "#FFFFFF";
                    document.getElementById("txtServiceLevel2").readOnly = false;
                }

                <% For j=1 To hawbOCTableList.Count %>
                AddOtherCharge();
                findSelect(document.getElementsByName("lstChargeCode")[<%=j %>],"<%=hawbOCTableList(j-1)("Charge_Desc") %>");
                document.getElementsByName("hChargeCode")[<%=j %>].value = "<%=hawbOCTableList(j-1)("charge_code") %>";
                document.getElementsByName("txtChargeDesc")[<%=j %>].value = "<%=hawbOCTableList(j-1)("Charge_Desc") %>";
                document.getElementsByName("txtChargeAmt")[<%=j %>].value = "<%=ConvertAnyValue(hawbOCTableList(j-1)("Amt_HAWB"),"Amount",0)%>";
                <% Next %>
            }
            catch (err){
                alert("An Error occurred while loading data, and the information may not be correct.\nPlease contact us for further instruction.");
            }

            AddOtherCharge();
            AddOtherCharge();
            syncChargeTable();
            
            <% If vMode="new" And vMAWB<>"" Then %>
                lstSearchNumChange("<%=vMAWB %>","<%=vMAWB %>");
            <% End If %>
        }

        function syncChargeTable(){
            try{
                if(!document.getElementsByName("chkHouseType")[1].checked){
                    document.getElementById("txtPiece").disabled = true;
                    document.getElementById("hDimDetail").disabled = true;
                    document.getElementById("hDimFactor").disabled = true;
                    document.getElementById("txtGrossWeight").disabled = true;
                    document.getElementById("txtCubicInches").disabled = true;
                    document.getElementById("txtCubicWeight").disabled = true;
                    document.getElementById("txtChargeableWeight").disabled = true;
                    document.getElementById("txtRateCharge").disabled = true;
                    document.getElementById("txtTotalCharge").disabled = true;
                    document.getElementById("divAddOtherCharge").style.visibility = "hidden";
                    
                    var delList = document.getElementsByName("OCDeleteIcon");
                    
                    for(var i=0;i<delList.length;i++){
                        document.getElementsByName("lstChargeCode")[i].disabled = true;
                        document.getElementsByName("hChargeCode")[i].disabled = true;
                        document.getElementsByName("txtChargeDesc")[i].disabled = true;
                        document.getElementsByName("txtChargeAmt")[i].disabled = true;
                        document.getElementsByName("OCDeleteIcon")[i].disabled = true;
                    }
                }
                else{
                    document.getElementById("txtPiece").disabled = false;
                    document.getElementById("hDimDetail").disabled = false;
                    document.getElementById("hDimFactor").disabled = false;
                    document.getElementById("txtGrossWeight").disabled = false;
                    document.getElementById("txtCubicInches").disabled = false;
                    document.getElementById("txtCubicWeight").disabled = false;
                    document.getElementById("txtChargeableWeight").disabled = false;
                    document.getElementById("txtRateCharge").disabled = false;
                    document.getElementById("txtTotalCharge").disabled = false;
                    document.getElementById("divAddOtherCharge").style.visibility = "visible";
                    
                    var delList = document.getElementsByName("OCDeleteIcon");
                    
                    for(var i=0;i<delList.length;i++){
                        document.getElementsByName("lstChargeCode")[i].disabled = false;
                        document.getElementsByName("hChargeCode")[i].disabled = false;
                        document.getElementsByName("txtChargeDesc")[i].disabled = false;
                        document.getElementsByName("txtChargeAmt")[i].disabled = false;
                        document.getElementsByName("OCDeleteIcon")[i].disabled = false;
                    }
                }
            }catch(error){}
        }
        
    </script>

    <style type="text/css">
    <!--
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style6 {color: #663366}
        .style14 {color: #CC0000}
        #Layer1 {
	        position:absolute;
	        width:705px;
	        height:115px;
	        z-index:101;
	        visibility: hidden;
        }
        .style15 {color: #c16b42}
        .style18
        {
            height: 20px;
        }
    -->
    </style>
</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" onload="self.focus(); loadValues();">
    <form method="post" name="form1">
        
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <input type="hidden" name="scrollPositionX" />
        <input type="hidden" name="scrollPositionY" />
        <input type="hidden" name="hMasterType" id="hMasterType" />
        <input type="hidden" name="hPONum" id="hPONum" value="<%=vPONum %>" />
        <input type="hidden" name="hSONum" id="hSONum" value="<%=vSONum %>" />
        <div id="tooltipcontent">
        </div>
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" colspan="4" align="left" valign="middle" class="pageheader">
                    NEW/EDIT HOUSE AIRBILL</td>
                <td width="55%" colspan="5" align="right" valign="middle">
                    <span class="bodyheader style6">HOUSE AWB NO.</span>
                    <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Use this field to find previously entered HAWBs. Enter the number including prefix and the dash and click the magnifying glass button.');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                    <input name="txtqHAWB" id="txtqHAWB" class="lookup" value="Search Here" onkeydown="javascript: if(event.keyCode == 13) { lookup(); }"
                        onclick="javascript: this.value = ''; this.style.color='#000000'; " size="22"><img
                            src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                            style="cursor: hand" onclick="lookup()"></td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="45%" valign="bottom">
                    </td>
                    <td width="55%" align="right" valign="bottom">
                        <div id="print">
                            <span id="spnAddInfoTop" style="visibility:hidden">
                                <img src="../Images/icon_additional_info.gif" alt="go to additional House Airbill info "
                                    align="absbottom" style="margin-right: 1em" /><a href="javascript:;" onclick="GoToAddition();return false;">Additional
                                        House Airbill Info </a>
                                <img src="/ASP/Images/spacer.gif" width="40" height="15" /></span><img src="/ASP/Images/icon_printer_preview.gif"
                                    align="absbottom" style="margin-right: 1em" /><a  href="javascript:void(0);" id="NewPrintVeiw1">House
                                        Air Waybill</a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            bgcolor="#997132" class="border1px">
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="24" align="left" valign="middle" bgcolor="#eec983" class="bodycopy">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%">
                                            &nbsp;
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" name="bSave" width="43"
                                                height="18" onclick="bsaveClick(); return false;" style="cursor: hand" alt="" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/domestic/new_edit_hawb.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDeleteHAWB"
                                                onclick="DeleteHAWB()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" bgcolor="#997132">
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#f3f3f3">
                                <br />
                                <br />
                                <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <table id="tblHouseType" border="0" align="center" cellpadding="0" cellspacing="0" style="visibility:hidden">
                                                <tr class="bodyheader">
                                                    <td height="22" colspan="2" align="left" valign="middle">
                                                        Type of House Airbill
                                                    </td>
                                                </tr>
                                                <tr style="padding-bottom: 8px">
                                                    <td width="18%" class="bodycopy">
                                                        <input name="chkHouseType" type="radio" value="Y" onclick="syncChargeTable()" />
                                                        Forwarders</td>
                                                    <td width="46%" class="bodycopy">
                                                        <input name="chkHouseType" type="radio" value="N" onclick="syncChargeTable()" />
                                                        In-house</td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <table id="tblBookingType" border="0" align="center" cellpadding="0" cellspacing="0" style="visibility:hidden">
                                                <tr class="bodyheader">
                                                    <td height="22" colspan="2">
                                                        Booking Type &nbsp;
                                                    </td>
                                                </tr>
                                                <tr style="padding-bottom: 8px">
                                                    <td width="18%" class="bodycopy">
                                                        <input name="chkIsInbound" type="radio" value="N" checked="checked" onfocus="checkExistMAWB(this);" />
                                                        Outbound</td>
                                                    <td width="18%" class="bodycopy">
                                                        <input name="chkIsInbound" type="radio" value="Y" onfocus="checkExistMAWB(this);" />
                                                        Inbound</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
                                    bgcolor="#FFFFFF" class="border1px">
                                    <tr bgcolor="#f3d9a8">
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td height="20" bgcolor="#f3d9a8">
                                            <font color="c16b42"><strong>House AWB No.</strong></font></td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td class="bodyheader">
                                            Date
                                        </td>
                                    </tr>
                                    <tr bgcolor="#ffffff">
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td height="24">
                                            <select name="lstHAWBPrefix" size="1" class="bodyheader" style="width: 55px" 
                                                id="lstHAWBPrefix">
                                                <% For i=0 To aHAWBPrefix.Count-1 %>
                                                <option value="<%=aHAWBPrefix(i) %>-<%=aNextHAWB(i) %>">
                                                    <%=aHAWBPrefix(i) %>
                                                </option>
                                                <% Next %>
                                            </select>
                                            <input name="txtHAWBNum" id="txtHAWBNum" class="readonlybold" value="" size="22" readonly="readonly"></td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            <input name="txtExecutedDate" id="txtExecutedDate"  type="text" class="m_shorttextfield date" size="18" preset="shortdate" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" height="1" bgcolor="#997132">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td width="1%">
                                            &nbsp;
                                        </td>
                                        <td width="40%">
                                            <span class="bodyheader" id="spanFFAgent">Customer</span></td>
                                        <td width="19%">
                                            &nbsp;
                                        </td>
                                        <td width="40%">
                                            <span class="bodyheader">Master AWB No.</span>
                                            <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Select a MAWB to consolidate this HAWB to.  This is optional.  Consolidation may be done later through the MAWB screen.')"
                                                onmouseout="hidetip()">
                                                <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td colspan="2" valign="top">
                                           
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hFFAgentAcct" name="hFFAgentAcct" value="" />
                                            <div id="lstFFAgentDiv">
                                            </div>
                                            <table id="tblFFAgent" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstFFAgent" name="lstFFAgent" value=""
                                                            class="shorttextfield" style="width: 235px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Agent','lstFFAgentChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstFFAgent','Agent','lstFFAgentChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                       <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hFFAgentAcct','lstFFAgent','hFFAgentInfo')" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                           </td>
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
                                                <img src="../Images/icon_goto.gif" align="absbottom" alt="" /><span class="goto"><a href="javascript:;"
                                                    onclick="MAWBEditClick(); return false;" >Go to MAWB</a></span>
                                            </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="height: 5px">
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
                <tr align="center" valign="middle">
                    <td bgcolor="#FFFFFF">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr class="bodyheader">
                                <td height="20" bgcolor="#f3d9a8" class="bodyheader" colspan="2" style="padding-left: 10px">
                                    Shipper's Name and Address</td>
                                <td width="21%" bgcolor="#f3d9a8">
                                    Master Bill No.</td>
                                <td bgcolor="#f3d9a8" class="bodyheader" colspan="2">
                                    Billing To
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="5" valign="top" colspan="2" style="padding-left: 10px">
                                    <!-- Start JPED -->
                                    <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="" />
                                    <div id="lstShipperNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value=""
                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',100,event)"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',100,event)"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                    onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" /></td>
                                        </tr>
                                    </table>
                                    <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                        rows="5" style="width: 300px"></textarea>
                                    <!-- End JPED -->
                                </td>
                                <td valign="middle">
                                    <input name="txtMAWBNum" id="txtMAWBNum" type="text" class="readonly" size="28" value=""></td>
                                <td valign="middle" class="bodycopy" colspan="2">
                                    <input type="radio" name="chkBilling" value="S" checked />
                                    Shipper
                                    <input type="radio" name="chkBilling" value="C" style="margin-left: 17px" />
                                    Consignee
                                    <input type="radio" name="chkBilling" value="3" style="margin-left: 17px" />
                                    3rd Party
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td height="20" bgcolor="#f3f3f3">
                                    Declared Value for Carriage
                                </td>
                                <td bgcolor="#f3f3f3" colspan="1">
                                    Amount of Insurance
                                </td>
                                <td colspan="1" bgcolor="#f3f3f3">
                                    C.O.D. Amount
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input name="txtDeclaredValueCarriage" id="txtDeclaredValueCarriage" class="shorttextfield" size="28" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td colspan="1">
                                    <input name="txtInsuranceAmt" id="txtInsuranceAmt" class="shorttextfield" size="28" maxlength="17" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td colspan="1" valign="top">
                                    <input type="text" name="txtCODAmount" id="txtCODAmount" class="shorttextfield" size="27"
                                        maxlength="14" value="" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                            </tr>
                            <tr class="bodyheader">
                                <td height="20" bgcolor="#f3f3f3">
                                    Shipper's Reference No.
                                </td>
                                <td width="20%" bgcolor="#f3f3f3">
                                    P.O. No.
                                </td>
                                <td width="17%" bgcolor="#f3f3f3">
                                    Shipper C.O.D</td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <input name="txtShipperReferenceNum" id="txtShipperReferenceNum" type="text" class="shorttextfield"
                                        size="28" value="" /></td>
                                <td valign="top">
                                    <input name="txtPurchaseNum" id="txtPurchaseNum" type="text" class="shorttextfield"
                                        size="28" value="" /></td>
                                <td colspan="1" valign="top">
                                    <input name="txtShipperCODAmount" id="txtShipperCODAmount" type="text" class="shorttextfield"
                                        size="27" value="" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                            </tr>
                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                <td height="20" colspan="2" style="padding-left: 10px">
                                    Consignee's Name and Address
                                </td>
                                <td height="20">
                                    Third Party Billing</td>
                                <td colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" colspan="2" style="padding-left: 10px">
                                    <!-- Start JPED -->
                                    <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="" />
                                    <div id="lstConsigneeNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td class="style18">
                                                <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                    value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                    onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" /></td>
                                            <td class="style18">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td class="style18">
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                    onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" /></td>
                                        </tr>
                                    </table>
                                    <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                        rows="5" style="width: 300px"></textarea>
                                    <!-- End JPED -->
                                </td>
                                <td colspan="3">
                                    <!-- Start JPED -->
                                    <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" />
                                    <div id="lstNotifyNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value=""
                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'All','lstNotifyNameChange',null,event)"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','All','lstNotifyNameChange',null,event)"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                    onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" /></td>
                                        </tr>
                                    </table>
                                    <textarea id="txtBillToInfo" name="txtBillToInfo" class="monotextarea" cols="" rows="5"
                                        style="width: 300px"></textarea></td>
                            </tr>
                            <tr class="bodyheader" bgcolor="#f3f3f3">
                                <td width="19%" height="20" valign="middle" style="padding-left: 10px">
                                    Point (Port) of Origin
                                </td>
                                <td width="23%">
                                    Point (Port) of Destination</td>
                                <td>
                                    <span class="style15">Service Level</span>
                                </td>
                                <td colspan="1">
                                    <span class="style15">Other Service Level</span>
                                </td>
                                <td colspan="1">
                                    Contained Hazardous Goods</td>
                            </tr>
                            <tr>
                                <td height="24" valign="top" style="padding-left: 10px">
                                    <input name="txtDepartureAirport" id="txtDepartureAirport" class="d_shorttextfield" value="" size="24" maxlength="27"
                                        readonly="readonly" /></td>
                                <td valign="top">
                                    <input name="txtDestAirport" id="txtDestAirport" class="d_shorttextfield" value="" size="24" maxlength="27"
                                        readonly="readonly" /></td>
                                <td valign="top">
                                    <select name="txtServiceLevel" id="txtServiceLevel" class="smallselect" onchange="other_ser()">
                                        <option value="Select One" selected="selected">Select One</option>
                                        <option value="Same Day">Same Day</option>
                                        <option value="Next Day">Next Day </option>
                                        <option value="2nd Day">2nd Day</option>
                                        <option value="3-5 Day">3-5 Day (deferred)</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </td>
                                <td valign="top">
                                    <input name="txtServiceLevel2" id="txtServiceLevel2" value="" size="24" maxlength="27"
                                        class="shorttextfield" readonly="readonly" style="background-color: #cccccc" />
                                </td>
                                <td align="left" valign="middle" class="bodycopy">
                                    <input type="radio" name="chkDanger" value="Y" />
                                    Yes
                                    <input type="radio" name="chkDanger" value="N" style="margin-left: 17px" />
                                    No</td>
                            </tr>
                        </table>
                    </td>
                </tr>
        </table>
        <br />
        <table width="95%" cellpadding="0" cellspacing="0" bgcolor="#997132" border="0" align="Center">
            <tr>
                <td>
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
                        bgcolor="#FFFFFF" class="border1px" id="tblCharges">
                        <tr class="bodyheader">
                            <td height="20" colspan="2" bgcolor="#f3d9a8" class="leftpadding" style="padding-left: 10px">
                                <span class="style15">WEIGHT CHARGES</span></td>
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
                                            <input name="txtPiece" id="txtPiece" class="txtunitbox" id="txtPiece" value="" size="6" maxlength="6"
                                                style="behavior: url(../include/igNumDotChkLeft.htc)" />
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
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                <tr>
                                                    <td height="1" bgcolor="#997132" colspan="5">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="20" colspan="5" bgcolor="#f3d9a8" class="leftpadding style14" style="padding-left: 10px">
                                                        <span class="style15"><strong>OTHER CHARGE</strong></span></td>
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
                                            <table id="tblOtherCharege" width="100%" border="0" cellspacing="0" cellpadding="0"><tr  id="0" class="bodyheader" style="visibility: hidden">
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
                                                            class="smallselect lstChargeCode" style="width: 220px" id="lstChargeCode">
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
                                                        <input tabindex="7" name="txtChargeDesc" size="40" value="" 
                                                            class="shorttextfield" id="txtChargeDesc"></td>
                                                    <td bgcolor="#FFFFFF">
                                                        <input tabindex="8" name="txtChargeAmt" size="10" value="" class="numberfield" 
                                                            style="behavior: url(../include/igNumDotChkLeft.htc)" id="txtChargeAmt" /></td>
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
                                                    <td height="32" valign="middle" bgcolor="#FFFFFF" class="leftpadding" style="padding-left: 10px">
                                                        <div id="divAddOtherCharge">
                                                            <img src="../Images/icon_add.gif" alt="Add Other Charge" name="bAddOC" align="absmiddle"
                                                                style="margin-right: 0.6em; cursor: pointer" /><a href="javascript:;" onclick="AddOtherCharge(); return false;">Add
                                                                    Other Charge</a>
                                                        </div>
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
                            <td width="31%" valign="top" align="center">
                                <table border="0" cellspacing="0" cellpadding="0">
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
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                        class="border1px" align="center" bordercolor="#997132">
                        <tr align="center" valign="middle">
                            <td height="32" colspan="2" bgcolor="#f3f3f3">
                                <div align="right">
                                    <strong>Sales Person</strong>
                                    <select name="lstSalesRP" id="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                                        <option value="none">Select One</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" bgcolor="#997132">
                            </td>
                        </tr>
                        <tr align="center" valign="middle">
                            <td height="24" colspan="2" bgcolor="#eec983">
                                <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132">
                                    <tr>
                                        <td width="26%">
                                            <img src="../images/button_save_new.gif" alt="save as new" name="bSaveAsNew" onclick="bsaveClick('SAN');"
                                                style="cursor: hand" /></td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" name="bSave" width="43" height="18" onclick="bsaveClick();"
                                                style="cursor: hand" alt="" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/domestic/new_edit_hawb.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_delete_medium.gif" width="51" height="17" name="bDeleteHAWB"
                                                onclick="DeleteHAWB()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" height="32" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td align="right" valign="bottom">
                    <div id="print">
                        <span id="spnAddInfoBot" style="visibility:hidden">
                            <img src="../Images/icon_additional_info.gif" alt="go to additional House Airbill info "
                                align="absbottom" style="margin-right: 1em" /><a href="javascript:;" onclick="GoToAddition();return false;">Additional
                                    House Airbill Info</a><img src="/ASP/Images/spacer.gif" width="40" height="15" /></span><img
                                        src="/ASP/Images/icon_printer_preview.gif" width="29" height="29" style="margin-right: 1em"
                                        align="absbottom"><a href="javascript:void(0);" id="NewPrintVeiw2" >House
                                            Air Waybill</a></div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>

<script type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
