<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_Util_Ver_2.inc" -->
<%
'// -------------------- Main ---------------------------------------------------------------------

    Dim vMAWB,vHAWB,vMode,i,j,aChargeItem,aCostItem,hawbWCTable,hawbAddCount,vIsInbound
    Dim hawbOCTableList,hawbTable,hawbAddTable,invQTable,driverTableList,aVendorList,aFLocation,locationTableList

    Set aChargeItem = Server.CreateObject("System.Collections.ArrayList")
    Set aCostItem = Server.CreateObject("System.Collections.ArrayList")
    Set hawbOCTableList = Server.CreateObject("System.Collections.ArrayList")
    Set hawbWCTable = Server.CreateObject("System.Collections.HashTable")
    Set driverTableList = Server.CreateObject("System.Collections.ArrayList")
    Set hawbTable = Server.CreateObject("System.Collections.HashTable")
    Set hawbAddTable = Server.CreateObject("System.Collections.HashTable")
    Set invQTable = Server.CreateObject("System.Collections.HashTable")
    Set aVendorList = Server.CreateObject("System.Collections.ArrayList")
    Set aFLocation = Server.CreateObject("System.Collections.ArrayList")
    Set locationTableList = Server.CreateObject("System.Collections.ArrayList")
    
    eltConn.BeginTrans
    On Error Resume Next:
    main_sub()

    '// Throws error when connection error occurs added by Joon on 10/25/2007
    If err.number Then
        Dim vErrorMesssage
        vErrorMesssage = "Unexpected Error Occurred. Please, contact us if this problem persists"
        vErrorMesssage = vErrorMesssage & "\n" _
            & "Error Number: " & err.number & "\n" _
            & "Application Source: " & err.Source & "\n" _
            & "Description: " & RemoveQuotations(err.Description) & " (" & Server.GetLastError().Line & ":" & Server.GetLastError().Column & ")"
        Response.Write("<script> alert('" & vErrorMesssage & "'); window.location.href='" & Request.ServerVariables("URL") & "'; </script>")
        eltConn.RollbackTrans
    Else
        eltConn.CommitTrans
    End If
    
'//-------------------------- Main Sub --------------------------------------------------------------

    Sub main_sub
    
        vMode = checkBlank(Request.QueryString.Item("mode"),"edit")
        vIsInbound = checkBlank(Request.QueryString.Item("inbound"),"N")
        
        get_charge_item_list()
        get_cost_item_list()
        get_vendor_list() '// trucker-vendor list
        get_freight_location_list()
        
        If vMode = "save" Then
            vHAWB = checkBlank(Request.Form.Item("txtHAWB"),"")
            vMAWB = checkBlank(Request.Form.Item("hMAWB"),"")
            
            If vHAWB <> "" Then
                get_hawb_master()
                delete_all_charges_drivers()
                update_hawb_master_add()
                update_hawb_driver()
                update_hawb_master()
                update_bill_detail()
                update_hawb_milestones()
            
                If update_hawb_weight_charge() Or update_other_charge() Then
                    update_invoice_queue()
                End If
            End If

        Elseif vMode = "edit" Then
            vHAWB = checkBlank(Request.QueryString.Item("HAWB"),"")
        End If
        
        get_hawb_master()
        get_hawb_master_add()
        get_hawb_driver()
        get_other_charge()
        get_weight_charge()
        get_hawb_milestones()
        
    End Sub

'//----------------------- Retreivers -------------------------------------------------------------

    Sub get_hawb_master
        Dim SQL,dataObj
        SQL = "SELECT * FROM hawb_master WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "' AND is_dome='Y'"
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
            & " AND hawb_num='" & vHAWB & "' AND invoice_only='Y'"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbOCTableList = dataObj.GetDataList
    End Sub
    
    Sub get_hawb_master_add
        Dim SQL,dataObj
        SQL = "SELECT * FROM hawb_master_add WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "'"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbAddTable = dataObj.GetRowTable(0)
        hawbAddCount = dataObj.GetDataList.Count
    End Sub
    
    Sub get_hawb_driver
        Dim SQL,dataObj
        SQL = "SELECT a.*,b.bill_number FROM hawb_master_drivers a LEFT OUTER JOIN bill_detail b "_
            & "ON (a.elt_account_number=b.elt_account_number AND a.driver_acct=b.vendor_number " _
            & "AND a.hawb_num=b.hawb_master_hawb_num AND a.item_id=b.item_id) WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.hawb_num='" & vHAWB & "' ORDER BY a.item_id"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set driverTableList = dataObj.GetDataList
    End Sub
    
    Sub get_weight_charge
        Dim SQL,dataObj
        SQL = "SELECT * FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "'"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbWCTable = dataObj.GetRowTable(0)
    End Sub
    
    Sub get_hawb_milestones
        Dim SQL,dataObj
        SQL = "SELECT * FROM HAWB_milestones a LEFT OUTER JOIN freight_location b ON (a.elt_account_number=b.elt_account_number AND " _
            & "a.location_id COLLATE DATABASE_DEFAULT=b.firm_code COLLATE DATABASE_DEFAULT) WHERE a.elt_account_number=" _
            & elt_account_number & " AND a.hawb_num='" & vHAWB & "' order by a.seq_id"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set locationTableList = dataObj.GetDataList
    End Sub
    
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
    
    Sub get_cost_item_list()
        Dim tmpTable,SQL,rs
        
        Set rs = Server.CreateObject("ADODB.RecordSet")
	    SQL= "SELECT * FROM item_cost WHERE elt_account_number = " _
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
	        aCostItem.Add tmpTable
		    rs.MoveNext
	    Loop
        rs.Close
    END Sub
    
    Sub get_vendor_list()
        Dim tempTable,rs,SQL
        Set rs=Server.CreateObject("ADODB.Recordset")
        
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        
        SQL= "select distinct org_account_number,DBA_NAME,is_vendor from organization where elt_account_number = " & elt_account_number _
            & " and (is_vendor = 'Y' AND z_is_trucker = 'Y') order by dba_name"
 	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
    	
	    Do While Not rs.EOF And Not rs.BOF
	        Set tempTable = Server.CreateObject("System.Collections.HashTable")
	        tempTable.Add "name", rs("DBA_NAME").value
	        tempTable.Add "acct", rs("org_account_number").value
	        aVendorList.Add tempTable
	        rs.MoveNext()
	    Loop
	    rs.Close()
    	
    End Sub
        
    Sub get_freight_location_list()
        Dim tempTable,rs,SQL
        Set rs=Server.CreateObject("ADODB.Recordset")
        
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        SQL= "select * from freight_location where elt_account_number = " & elt_account_number 
        
 	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
    	
	    Do While Not rs.EOF And Not rs.BOF
	        Set tempTable = Server.CreateObject("System.Collections.HashTable")
	        tempTable.Add "name", rs("location").value
	        tempTable.Add "id", rs("firm_code").value
	        tempTable.Add "location", checkBlank(rs("city").value & " ", "")
	        aFLocation.Add tempTable
	        rs.MoveNext()
	    Loop
	    rs.Close()
    End Sub
    
    Function GetItemCostInfo(colArg, itemNoArg)
        Dim rs,SQL,resVal
        resVal = ""
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT " & colArg & " FROM item_cost where elt_account_number=" & elt_account_number _
            & " AND item_no=" & itemNoArg

        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
        
        If Not rs.EOF AND Not rs.BOF Then
            resVal = rs(0).value
        End If

        GetItemCostInfo = resVal
        rs.Close()
    
    End Function
    
'//-------------------------- Manipulators --------------------------------------------------------------

    Function delete_all_charges_drivers()
        Dim rs, SQL
        
        '// If agent bill then delete invoice queue, other charge, weight charge
        If Request.Form.Item("hHAWBType") = "Y" Then
        
            SQL = "DELETE FROM invoice_queue WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & vHAWB & "'"

            Set rs = Server.CreateObject("ADODB.Recordset")
            Set rs = eltConn.execute(SQL)
            
            SQL = "DELETE FROM hawb_other_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & vHAWB & "'"
            Set rs = Server.CreateObject("ADODB.Recordset")
            
            Set rs = eltConn.execute(SQL)
            SQL = "DELETE FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & vHAWB & "'"
            Set rs = Server.CreateObject("ADODB.Recordset")
            Set rs = eltConn.execute(SQL)
        
        End If

        SQL = "DELETE FROM hawb_master_drivers WHERE auto_uid IN (" _
            & "SELECT auto_uid FROM hawb_master_drivers a LEFT OUTER JOIN bill_detail b "_
            & "ON (a.elt_account_number=b.elt_account_number AND a.driver_acct=b.vendor_number " _
            & "AND a.hawb_num=b.hawb_master_hawb_num AND a.item_id=b.item_id) WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.hawb_num='" & vHAWB & "' AND ISNULL(b.bill_number,0)=0)"
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
        
        SQL = "DELETE FROM bill_detail WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_master_hawb_num='" & vHAWB & "' AND ISNULL(bill_number,0) = 0"

        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
        
        SQL = "DELETE FROM hawb_milestones WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "'"

        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
        
        delete_all_charges_drivers = True
    End Function
    
    Function update_hawb_master_add()
        Dim tmpTable,SQL,dataObj,resVal
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("hawb_master_add")
        resVal = False

        SQL = "SELECT * FROM hawb_master_add WHERE elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & vHAWB & "'"

        Set tmpTable = Server.CreateObject("System.Collections.HashTable")
        tmpTable.Add "elt_account_number", elt_account_number
        tmpTable.Add "hawb_num", Request.Form.Item("txtHAWB")
        tmpTable.Add "mawb_num", Request.Form.Item("hMAWB")
        tmpTable.Add "is_agent_house", Request.Form.Item("hHAWBType")
        tmpTable.Add "customer_acct", Request.Form.Item("hCustomerAcct")
        tmpTable.Add "billto_acct", Request.Form.Item("hBillToAcct")
        tmpTable.Add "ship_status", Request.Form.Item("chkShipStatus")
        tmpTable.Add "pickup_alert_date", Request.Form.Item("txtPickupAlertedDate")
        tmpTable.Add "pickup_alert_time", Request.Form.Item("txtPickupAlertedTime")
        tmpTable.Add "ready_date", Request.Form.Item("txtReadyDate")
        tmpTable.Add "ready_time", Request.Form.Item("txtReadyTime")
        tmpTable.Add "close_date", Request.Form.Item("txtCloseDate")
        tmpTable.Add "close_time", Request.Form.Item("txtCloseTime")
        tmpTable.Add "pickup_date", Request.Form.Item("txtPickupDate")
        tmpTable.Add "pickup_time", Request.Form.Item("txtPickupTime")
        tmpTable.Add "dispatch_date", Request.Form.Item("txtDispatchedDate")
        tmpTable.Add "dispatch_time", Request.Form.Item("txtDispatchedTime")
        tmpTable.Add "onboard_date", Request.Form.Item("txtOnboardDate")
        tmpTable.Add "onboard_time", Request.Form.Item("txtOnboardTime")
        tmpTable.Add "transfer_date", Request.Form.Item("txtTransferDate")
        tmpTable.Add "transfer_time", Request.Form.Item("txtTransferTime")
        tmpTable.Add "delivery_alert_date", Request.Form.Item("txtDeliveryAlertedDate")
        tmpTable.Add "delivery_alert_time", Request.Form.Item("txtDeliveryAlertedTime")
        tmpTable.Add "recover_date", Request.Form.Item("txtRecoveredDate")
        tmpTable.Add "recover_time", Request.Form.Item("txtRecoveredTime")
        tmpTable.Add "OFD_date", Request.Form.Item("txtOFDDate")
        tmpTable.Add "OFD_time", Request.Form.Item("txtOFDTime")
        tmpTable.Add "POD_date", Request.Form.Item("txtPODDate")
        tmpTable.Add "POD_time", Request.Form.Item("txtPODTime")
        tmpTable.Add "carrier_signer", Request.Form.Item("txtCarrierSigner")
        tmpTable.Add "POD_signer", Request.Form.Item("txtPODSigner")
        tmpTable.Add "ship_time_status", Request.Form.Item("hShipTimeStatus")

        update_hawb_master_add = dataObj.updateDBRow(SQL, tmpTable)
    End Function
    
    Function update_hawb_master
        Dim tmpTable,SQL,dataObj,total_amount
        
        If Request.Form.Item("hHAWBType") = "Y" Then
            Set tmpTable = Server.CreateObject("System.Collections.HashTable")
            tmpTable.Add "Total_Pieces", formatNumberPlus(Request.Form.Item("txtPiece"),0)
            tmpTable.Add "Total_Gross_Weight", formatNumberPlus(Request.Form.Item("txtGrossWeight"),2)
            tmpTable.Add "Total_Chargeable_Weight", formatNumberPlus(Request.Form.Item("txtChargeableWeight"),2)
            tmpTable.Add "Weight_Scale", "L"
            tmpTable.Add "Total_Weight_Charge_HAWB", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
            tmpTable.Add "Adjusted_Weight", formatNumberPlus(Request.Form.Item("txtChargeableWeight"),2)
            
            tmpTable.Add "PPO_1", "Y"
            tmpTable.Add "PPO_2", "Y"
            tmpTable.Add "COLL_1", ""
            tmpTable.Add "COLL_2", ""
            tmpTable.Add "Charge_Code", "P"
            tmpTable.Add "Prepaid_Weight_Charge", formatNumberPlus(Request.Form.Item("txtTotalCharge"),2)
            tmpTable.Add "bill_to_party", "S"
            
            total_amount = 0
            For i=1 To Request.Form.Item("hChargeCode").count
                If checkBlank(Request.Form.Item("hChargeCode")(i),"") <> "" Then
                    total_amount = total_amount + formatNumberPlus(Request.Form.Item("txtChargeAmt")(i),2)
                End If
            Next
            
            tmpTable.Add "Total_Other_Charges", total_amount
            
            Set dataObj = new DataManager
            dataObj.SetColumnKeys("hawb_master")
            
            SQL = "SELECT * FROM hawb_master WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & Request.Form.Item("txtHAWB") & "' AND is_dome='Y'"
            
            update_hawb_master = dataObj.UpdateDBRow(SQL, tmpTable)
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
                tmpTable.Add "HAWB_NUM", Request.Form.Item("txtHAWB")
                tmpTable.Add "Tran_No", CInt(tranNo)
                tmpTable.Add "Coll_Prepaid", "P"
                tmpTable.Add "charge_code", Request.Form.Item("hChargeCode")(i)
                tmpTable.Add "Charge_Desc", Request.Form.Item("txtChargeDesc")(i)
                tmpTable.Add "Amt_HAWB", formatNumberPlus(Request.Form.Item("txtChargeAmt")(i),2)
                tmpTable.Add "invoice_only", "Y"
                hawbOCTableList.Add tmpTable
                tranNo = tranNo + 1

                Call dataObj.insertDBRow(SQL, tmpTable)
                resVal = True
            End If
        Next

        update_other_charge = resVal
    End Function

    Function update_bill_detail()
        
        Dim tmpTable,rs,tmpId
        Dim SQL,dataObj,resVal
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("bill_detail")
        resVal = False

        For i=1 To Request.Form.Item("lstDriver").count
            If checkBlank(Request.Form.Item("lstDriver")(i),0) <> 0 And FormatNumberPlus(Request.Form.Item("txtDriverCost")(i),0) > 0 Then
                tmpId = checkBlank(Request.Form.Item("hDriverItemNo")(i),GetNewAPItemNo())
                Set tmpTable = Server.CreateObject("System.Collections.HashTable")
                tmpTable.Add "elt_account_number", elt_account_number
                tmpTable.Add "hawb_master_hawb_num", Request.Form.Item("txtHAWB")
                tmpTable.Add "ref", Request.Form.Item("txtHAWB")
                tmpTable.Add "invoice_no", 0
                tmpTable.Add "item_id", tmpId
                tmpTable.Add "bill_number", 0
                tmpTable.Add "vendor_number", Request.Form.Item("lstDriver")(i)
                tmpTable.Add "item_name", GetItemCostInfo("item_desc",Request.Form.Item("lstCostCode")(i))
                tmpTable.Add "item_no", Request.Form.Item("lstCostCode")(i)
                tmpTable.Add "item_amt", ConvertAnyValue(Request.Form.Item("txtDriverCost")(i),"Amount",0)
                tmpTable.Add "item_amt_origin", ConvertAnyValue(Request.Form.Item("txtDriverCost")(i),"Amount",0)
                tmpTable.Add "item_expense_acct", GetItemCostInfo("account_expense",Request.Form.Item("lstCostCode")(i))
                tmpTable.Add "tran_date", Request.Form.Item("txtExecutedDate")

                SQL = "SELECT * FROM bill_detail WHERE elt_account_number=" & elt_account_number _
                    & " AND hawb_master_hawb_num='" & Request.Form.Item("txtHAWB") _
                    & "' AND vendor_number=" & Request.Form.Item("lstDriver")(i) _
                    & " AND item_id=" & tmpId
                Call dataObj.insertDBRow(SQL, tmpTable)
                resVal = True
            End If
        Next
        
        update_bill_detail = resVal
    End Function
    
    Function update_hawb_driver
        Dim tmpTable,rs,tmpId
        Dim SQL,dataObj,resVal
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("hawb_master_drivers")
        resVal = False

        For i=1 To Request.Form.Item("lstDriver").count
            If checkBlank(Request.Form.Item("lstDriver")(i),0) <> 0 Then
                tmpId = checkBlank(Request.Form.Item("hDriverItemNo")(i),GetNewDriverItemNo())
                Set tmpTable = Server.CreateObject("System.Collections.HashTable")
                tmpTable.Add "elt_account_number", elt_account_number
                tmpTable.Add "hawb_num", Request.Form.Item("txtHAWB")
                tmpTable.Add "mawb_num", Request.Form.Item("txtMAWB")
                tmpTable.Add "driver_acct", Request.Form.Item("lstDriver")(i)
                tmpTable.Add "item_id", tmpId
                tmpTable.Add "piece", Request.Form.Item("txtDriverPieces")(i)
                tmpTable.Add "weight", Request.Form.Item("txtDriverWeight")(i)
                tmpTable.Add "cost_item_no", Request.Form.Item("lstCostCode")(i)
                tmpTable.Add "cost_amount", ConvertAnyValue(Request.Form.Item("txtDriverCost")(i),"Amount",0)
                tmpTable.Add "cost_percent", Request.Form.Item("txtDriverCostPercent")(i)
                tmpTable.Add "remark", Request.Form.Item("txtDriverRemark")(i)
                
                SQL = "SELECT * FROM hawb_master_drivers WHERE elt_account_number=" & elt_account_number _
                    & " AND hawb_num='" & Request.Form.Item("txtHAWB") _
                    & "' AND driver_acct=" & Request.Form.Item("lstDriver")(i) _
                    & " AND item_id=" & tmpId
                Call dataObj.insertDBRow(SQL, tmpTable)
                resVal = True
            End If
        Next

        update_hawb_driver = resVal
    End Function
    
    Function update_invoice_queue
        If Request.Form.Item("hHAWBType") = "Y" Then
        
            invQTable.Add "elt_account_number", elt_account_number
            invQTable.Add "queue_id", GetNextInvQId()
            invQTable.Add "inqueue_date", Request.Form.Item("txtExecutedDate")
            invQTable.Add "agent_shipper", "S"
            invQTable.Add "hawb_num", Request.Form.Item("txtHAWB")
            invQTable.Add "mawb_num", Request.Form.Item("hMAWB")
            
            invQTable.Add "bill_to", Request.Form.Item("lstCustomerName")
            invQTable.Add "bill_to_org_acct", Request.Form.Item("hCustomerAcct")
            
            invQTable.Add "air_ocean", "D"
            invQTable.Add "master_only", "N"
            invQTable.Add "invoiced", "N"
            invQTable.Add "is_dome", "Y"
            
            Dim SQL,dataObj
            Set dataObj = new DataManager
            dataObj.SetColumnKeys("invoice_queue")
            
            SQL = "SELECT * FROM invoice_queue WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & vHAWB & "'"
            
            update_invoice_queue = dataObj.UpdateDBRow(SQL, invQTable)
        End If
    End Function

    Function update_hawb_weight_charge()
        hawbWCTable.Add "elt_account_number", elt_account_number
        hawbWCTable.Add "HAWB_NUM", Request.Form.Item("txtHAWB")
        hawbWCTable.Add "Tran_No", 1
        hawbWCTable.Add "No_Pieces", formatNumberPlus(Request.Form.Item("txtPiece"),0)
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
        hawbWCTable.Add "invoice_only", "Y"
'// Disabled - Saves Only when total charge is greater than 0 /////////////////////////////////////////////////////
'// If formatNumberPlus(Request.Form.Item("txtTotalCharge"),2) > 0 Then
            Dim SQL,dataObj
            Set dataObj = new DataManager
            dataObj.SetColumnKeys("hawb_weight_charge")
            
            SQL = "SELECT * FROM hawb_weight_charge WHERE elt_account_number=" & elt_account_number _
                & " AND hawb_num='" & Request.Form.Item("txtHAWB") & "'"
            
            update_hawb_weight_charge = dataObj.UpdateDBRow(SQL, hawbWCTable)
'// End If
'////////////////////////////////////////////////////////////////////////////////////////////////////////
    End Function

    Function update_hawb_milestones()
        Dim tmpTable,rs
        Dim SQL,dataObj,resVal
        Set dataObj = new DataManager
        dataObj.SetColumnKeys("hawb_milestones")
        resVal = False

        For i=1 To Request.Form.Item("lstFreightLocation").count
            If checkBlank(Request.Form.Item("lstFreightLocation")(i),"") <> "" Then
                Set tmpTable = Server.CreateObject("System.Collections.HashTable")
                tmpTable.Add "elt_account_number", elt_account_number
                tmpTable.Add "hawb_num", Request.Form.Item("txtHAWB")
                tmpTable.Add "location_id", Request.Form.Item("lstFreightLocation")(i)
                tmpTable.Add "seq_id", i-1
                tmpTable.Add "job_type", Request.Form.Item("txtFreightLocationJobType")(i)
                tmpTable.Add "status", Request.Form.Item("lstFreightLocationStatus")(i)
                tmpTable.Add "remark", Request.Form.Item("txtFreightLocationRemark")(i)
                tmpTable.Add "update_date", now()
                
                SQL = "SELECT TOP 0 * FROM hawb_milestones"
                Call dataObj.insertDBRow(SQL, tmpTable)
                resVal = True
            End If
        Next

        update_hawb_milestones = resVal
    End Function
    
    
    Function GetNewDriverItemNo()
        Dim rs,SQL,resVal
        resVal = ""
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT ISNULL(MAX(item_id),0) FROM hawb_master_drivers where elt_account_number=" & elt_account_number _
            & " AND hawb_num='" & Request.Form.Item("txtHAWB") & "'"

        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
        
        If Not rs.EOF AND Not rs.BOF Then
            resVal = CInt(rs(0).value) + 1
        End If
        rs.Close()
        
        GetNewDriverItemNo = resVal
    End Function
    
    Function GetNewAPItemNo()
        Dim rs,SQL,resVal
        resVal = ""
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT ISNULL(MAX(item_id),0) FROM bill_detail where elt_account_number=" & elt_account_number _
            & " AND hawb_master_hawb_num='" & Request.Form.Item("txtHAWB") & "'"

        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
        
        If Not rs.EOF AND Not rs.BOF Then
            resVal = CInt(rs(0).value) + 1
        End If
        rs.Close()
        
        GetNewAPItemNo = resVal
    End Function
    
    On Error Resume Next:
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>House Airbill Additional Info</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/javascript" src="../include/JPTableDOM.js"></script>

    <style type="text/css">
        <!--
        body {
	        margin-bottom: 1.5em;
        }
        .style7 {color: #c16b42}
        .textbutton {
	        text-align: left;
	        margin:0.6em 0;
        }
        .textbutton a {
	        font-size:9PX;
	        color: #000000;
	        text-decoration: none;
        }
        .textbutton a:hover {
	        color: #b83423;
        }
        .textbutton img {
	        vertical-align:middle;
	        margin:4px 10px 4px 0;
        }
        .dateformat, .timeformat {
	        behavior: url("/ASP/include/mask_js.htc");
        }

       
        .dateformat1 {	behavior: url("/ASP/include/mask_js.htc");
        }
        .timeformat1 {	behavior: url("/ASP/include/mask_js.htc");
        }
        .dateformat2 {	behavior: url("/ASP/include/mask_js.htc");
        }
        .timeformat2 {	behavior: url("/ASP/include/mask_js.htc");
        }
        .style8 {color: #999999}
		#pickup, #delivery {
			position:absolute;
			left: 0px;
			top: 0px;
		}
		.simpletabs {
			float: left;
			width: 100%;
			font: bold 10px/1.5em Verdana;
			border-bottom:3px solid #eec983;
			}
		ul.simpletabs  {
			margin: 0;
			padding: 0 0 0 10px;
			list-style: none;
		}
		ul.simpletabs li {
			display: inline;
			margin: 0;
			padding: 3px 0 3px 0;
			border: solid 1px #eec983;
			border-bottom: none;
			height: 18px;
		}
		ul.simpletabs li a { 
			text-decoration: none;
			margin: 0;
			padding: 10px 10px 10px 10px ;
			color:#999999;
			
		}
		ul.simpletabs li a:hover {
			color: #444444;
		}
        -->
    </style>

    <script type="text/javascript">
        function setRadioCheck(ObjList,val){
            for(var i=0; i<ObjList.length;i++){
                if(ObjList[i].value == val){
                    ObjList[i].checked = true;
                }
            }
        }
        
        function findSelect(oSelect,selVal){
            oSelect.options.selectedIndex = 0;
            for(var i=0;i<oSelect.children.length;i++){
                var tmpText = oSelect.options[i].value;
                if(tmpText != "" && tmpText.match(selVal) != null){
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        
       function checkPiece(thisObj) {

            var Vpieces2
            //change at 7/30/2007 by stanley
            if (document.getElementById("hHAWBType").value =="Y")
            {
            var Vpieces=document.getElementById("txtPieces").value;
            var tableObj = thisObj.parentNode.parentNode.parentNode.parentNode;
            var rowID = 0;
            var ObjList = document.getElementsByName(thisObj.name);
            for(var i=0;i<ObjList.length;i++){
                if(thisObj.uniqueID == ObjList[i].uniqueID){
                    rowID = i;
                }
            }
            
           for( var n=1; n<=rowID; n++)
                {
                
                    if(n!=rowID)
                    {
                        Vpieces=Vpieces-document.getElementsByName("txtDriverPieces")(n).value; 
                        }
                }
            for(var cn=rowID+1;cn<ObjList.length;cn++){
    
                Vpieces=Vpieces-document.getElementsByName("txtDriverPieces")(cn).value;
            }
            if(Vpieces<0)
            {   
                alert("no more Pieces.");
                Vpieces=0;
            }

            Vpieces2= document.getElementsByName("txtDriverPieces")(rowID).value;
            if (Vpieces2>Vpieces)
            {
                //document.getElementsByName("txtDriverPieces")(rowID).value = Vpieces;
                //alert("Warning: Driver's total pieces is greater than total pieces for the shipment.");
            }
            else
            {
                document.getElementsByName("txtDriverPieces")(rowID).value = Vpieces2;
            }
            }
            
        } 

        function checkWeight(thisObj) {
            var Vweight2
            //change at 7/30/2007 by stanley
            if (document.getElementById("hHAWBType").value =="Y")
            {
            var Vweight=document.getElementById("txtGrossWeight").value;
            var tableObj = thisObj.parentNode.parentNode.parentNode.parentNode;
            
            var rowID = 0;
            var ObjList = document.getElementsByName(thisObj.name);
            for(var i=0;i<ObjList.length;i++){
                if(thisObj.uniqueID == ObjList[i].uniqueID){
                    rowID = i;
                }
            }
           for( var n=1; n<=rowID; n++)
                {
                    if(n!=rowID)
                    {
                        Vweight=Vweight-document.getElementsByName("txtDriverWeight")(n).value; 
                        }
                }
            for(var cn=rowID+1;cn<ObjList.length;cn++){
    
                Vweight=Vweight-document.getElementsByName("txtDriverWeight")(n).value; 
            }

            if(Vweight<0)
            {   
                Vweight=0;
            }
            
            
            Vweight2= document.getElementsByName("txtDriverWeight")(rowID).value;
            if (Vweight2>Vweight)
            {
                //document.getElementsByName("txtDriverWeight")(rowID).value = Vweight;
                //alert("Your total weight is " + Vweight + " LB");
            }
            else
            {
                document.getElementsByName("txtDriverWeight")(rowID).value = Vweight2;
            }
            }
            
        }         
        function DimCalClick(){
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=350,height=280";
            var childWindow = window.open("new_dimcal.asp?ItemNum=","Dimension_Calculation", props);
            childWindow.focus();
        }
        
        function GoManageDrivers(){
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=650,height=420";
            var childWindow = window.open("../site_admin/edit_driver.asp","PopWindow", props);
            childWindow.focus();
        }
        
        function GoManageFreightLocations(){
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,width=900,height=700";
            var childWindow = window.open("../master_data/edit_freight.asp","PopWindow", props);
            childWindow.focus();
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
        
        function lstCustomerNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hCustomerAcct");
            var infoObj = document.getElementById("txtCustomerInfo");
            var txtObj = document.getElementById("lstCustomerName");
            var divObj = document.getElementById("lstCustomerNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            lstBillToNameChange(orgNum,orgName)
        }
        
        function lstBillToNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hBillToAcct");
            var infoObj = document.getElementById("txtBillToInfo");
            var txtObj = document.getElementById("lstBillToName");
            var divObj = document.getElementById("lstBillToNameDiv")
    
            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum,"B");
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
        }
        
        function AddOtherCharge(){
            var tableObj = document.getElementById("tblOtherCharge");
            var tableContent = tableObj.firstChild.innerHTML;
            var addContent = tableObj.firstChild.firstChild.innerHTML;
            tableObj.outerHTML = "<table id=\"tblOtherCharge\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
                + tableObj.firstChild.innerHTML + "<tr class=\"bodyheader\">" + addContent + "</tr></table>";
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
        
        function AddDriver(){
            var tableObj = document.getElementById("tblDriver");
            var tableContent = tableObj.firstChild.innerHTML;
            var addContent = tableObj.firstChild.firstChild.innerHTML;
            tableObj.outerHTML = "<table id=\"tblDriver\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
                + tableObj.firstChild.innerHTML + "<tr class=\"bodyheader\">" + addContent + "</tr></table>";
        }
        
        function DeleteDriver(thisObj){
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
            
            var rowID = 0;
            var selectObjList = document.getElementsByName(thisObj.name);
            for(var i=0;i<selectObjList.length;i++){
                if(thisObj.uniqueID == selectObjList[i].uniqueID){
                    rowID = i;
                }
            }
            
            if(thisObj.value == ""){
                document.getElementsByName("txtChargeDesc")[rowID].value = "";
                document.getElementsByName("txtChargeAmt")[rowID].value = "";   
                document.getElementsByName("hChargeCode")[rowID].value = "";   
            }
            else
            {
                var ocValue = document.getElementsByName("lstChargeCode")[rowID].value;
                var ocArray = new Array();
                
                ocArray = ocValue.split("-");
                document.getElementsByName("txtChargeDesc")[rowID].value = ocArray[3];
                document.getElementsByName("txtChargeAmt")[rowID].value = ocArray[1];   
                document.getElementsByName("hChargeCode")[rowID].value = ocArray[0];   
            }
        }
        
        function getOrganizationInfo(orgNum,infoFormat){
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;
        
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
        function doTimeStamp(dateObjName,timeObjName){
            var dateObj = document.getElementById(dateObjName);
            var timeObj = document.getElementById(timeObjName);
            var nowObj = new Date();
            
            dateObj.value = nowObj.getMonth() + 1 + "/" + nowObj.getDate()+ "/" + nowObj.getYear();
            
            var Hours = Mins = 0;
            
            Hours = nowObj.getHours()
            if(Hours >= 12){
                AMPM = " PM";
                if(Hours > 12){
                    Hours = Hours - 12;
                }
            }
            else{
                AMPM = " AM";
            }
            
            var Mins = nowObj.getMinutes();
            if(Mins < 10){
                timeObj.value =  Hours + ":0" + Mins + AMPM;
            }
            else{
                timeObj.value =  Hours + ":" + Mins + AMPM;
            }
        }
        
        function GoBackHAWB(){
            
            document.form1.action = "new_edit_hawb.asp?mode=search&HAWB=" + document.getElementById("txtHAWB").value;
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function bsaveClick(){
        
            if (document.getElementById("txtHAWB") == ""){
                return false;
            }
            if(checkOtherChargeForSave() == false ){
                alert("Please, check other charges before saving.");
                return false;
            }
            if(checkDriversForSave() == false){
                alert("Please, check driver costs before saving.");
                return false;
            }
            
            SetStatus();
            document.form1.action = "hawb_addi.asp?mode=save&inbound=<%=vIsInbound %>";
            document.form1.method = "POST";
            document.form1.target = "_self";
            document.form1.submit();
        }
        
        function SetStatus(){
            var objList = new Array();
            var abbrList = new Array();
            
            objList[0] = "txtPickupAlertedTime";
            objList[1] = "txtDispatchedTime";
            objList[2] = "txtOnboardTime";
            objList[3] = "txtTransferTime";
            objList[4] = "txtDeliveryAlertedTime";
            objList[5] = "txtRecoveredTime";
            objList[6] = "txtOFDTime";
            objList[7] = "txtPODTime";
            
            abbrList[0] = "ALRT";
            abbrList[1] = "DISP";
            abbrList[2] = "ONBO";
            abbrList[3] = "TRAN";
            abbrList[4] = "ALRT";
            abbrList[5] = "RECO";
            abbrList[6] = "OFD";
            abbrList[7] = "POD";
            
            for(var i=objList.length-1;i>=0;i--){
                if(document.getElementById(objList[i]).value != ""){
                    document.getElementById("hShipTimeStatus").value = abbrList[i];
                    break;
                }
            }
        }
        
        function checkOtherChargeForSave(){
        
            var OCList = document.getElementsByName("hChargeCode");
            var OCAmountList = document.getElementsByName("txtChargeAmt");
            for(var i=1;i<OCList.length;i++){
                if(OCList[i].value != "" && OCList[i].value != "0" &&
                    (OCAmountList[i].value == "" || OCAmountList[i].value == "0")){
                    return false;
                }
            }
            return true;
        }
        
        function checkDriversForSave(){
            var DriverList = document.getElementsByName("lstDriver");
            var CostList = document.getElementsByName("lstCostCode");
            var DriverAmountList = document.getElementsByName("txtDriverCost");
            /*
            for(var i=1;i<DriverList.length;i++){
                if(DriverList[i].value != "" && DriverList[i].value != "0" && 
                    (CostList[i].value == "" || CostList[i].value == "0" 
                    || DriverAmountList[i].value == "" || DriverAmountList[i].value == "0")){
                    )){
                    return false;
                }
            }
            */
            return true;
        }
        
        function NewPrintVeiw(){
            var searchVal = document.getElementById("txtHAWB").value;
            if(searchVal == ""){
                alert("Please, select a HAWB number to view.");
                return false;
            }
            var props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
            window.open("view_print.asp?sType=house&hawb=" + searchVal, "popUpWindow", props);
        }
        
        function loadValues(){
        
            try{
            
                document.getElementById("txtHAWB").value="<%=MakeJavaString(hawbTable("HAWB_NUM")) %>";
                document.getElementById("hMAWB").value="<%=MakeJavaString(hawbTable("MAWB_NUM")) %>";
                document.getElementById("hHAWBType").value="<%=MakeJavaString(hawbTable("is_agent_house")) %>";
                document.getElementById("txtExecutedDate").value = "<%=checkBlank(hawbTable("Date_Executed"),Date()) %>";
                setRadioCheck(document.getElementsByName("chkShipStatus"),"<%=checkBlank(hawbAddTable("ship_status"),"A") %>")
                
                <% If hawbAddCount > 0 Then %>
                lstCustomerNameChange(<%=checkBlank(hawbAddTable("customer_acct"),0) %>,"<%=MakeJavaString(GetBusinessName(hawbAddTable("customer_acct"))) %>");
                lstBillToNameChange(<%=checkBlank(hawbAddTable("billto_acct"),0) %>,"<%=MakeJavaString(GetBusinessName(hawbAddTable("billto_acct"))) %>");
                <% Else %>
                lstCustomerNameChange(<%=checkBlank(hawbTable("Agent_No"),0) %>,"<%=checkBlank(hawbTable("Agent_Name"),"") %>");
                lstBillToNameChange(<%=checkBlank(hawbTable("Agent_No"),0) %>,"<%=checkBlank(hawbTable("Agent_Name"),"") %>");
                <% End If %>
                document.getElementById("txtPickupAlertedDate").value="<%=MakeJavaString(hawbAddTable("pickup_alert_date")) %>";
                document.getElementById("txtPickupAlertedTime").value="<%=MakeJavaString(hawbAddTable("pickup_alert_time"))%>";
                document.getElementById("txtReadyDate").value="<%=MakeJavaString(hawbAddTable("ready_date")) %>";
                document.getElementById("txtReadyTime").value="<%=MakeJavaString(hawbAddTable("ready_time")) %>";
                document.getElementById("txtCloseDate").value="<%=MakeJavaString(hawbAddTable("close_date")) %>";
                document.getElementById("txtCloseTime").value="<%=MakeJavaString(hawbAddTable("close_time")) %>";
                document.getElementById("txtPickupDate").value="<%=MakeJavaString(hawbAddTable("pickup_date")) %>";
                document.getElementById("txtPickupTime").value="<%=MakeJavaString(hawbAddTable("pickup_time")) %>";
                document.getElementById("txtDispatchedDate").value="<%=MakeJavaString(hawbAddTable("dispatch_date")) %>";
                document.getElementById("txtDispatchedTime").value="<%=MakeJavaString(hawbAddTable("dispatch_time")) %>";
                document.getElementById("txtOnboardDate").value="<%=MakeJavaString(hawbAddTable("onboard_date")) %>";
                document.getElementById("txtOnboardTime").value="<%=MakeJavaString(hawbAddTable("onboard_time")) %>";
                document.getElementById("txtTransferDate").value="<%=MakeJavaString(hawbAddTable("transfer_date")) %>";
                document.getElementById("txtTransferTime").value="<%=MakeJavaString(hawbAddTable("transfer_time")) %>";
                
                document.getElementById("txtDeliveryAlertedDate").value="<%=MakeJavaString(hawbAddTable("delivery_alert_date")) %>";
                document.getElementById("txtDeliveryAlertedTime").value="<%=MakeJavaString(hawbAddTable("delivery_alert_time")) %>";
                document.getElementById("txtRecoveredDate").value="<%=MakeJavaString(hawbAddTable("recover_date")) %>";
                document.getElementById("txtRecoveredTime").value="<%=MakeJavaString(hawbAddTable("recover_time")) %>";
                document.getElementById("txtOFDDate").value="<%=MakeJavaString(hawbAddTable("OFD_date")) %>";
                document.getElementById("txtOFDTime").value="<%=MakeJavaString(hawbAddTable("OFD_time")) %>";
                document.getElementById("txtPODDate").value="<%=MakeJavaString(hawbAddTable("POD_date")) %>";
                document.getElementById("txtPODTime").value="<%=MakeJavaString(hawbAddTable("POD_time")) %>";
                
                document.getElementById("txtCarrierSigner").value="<%=MakeJavaString(hawbAddTable("carrier_signer")) %>";
                document.getElementById("txtPODSigner").value="<%=MakeJavaString(hawbAddTable("POD_signer")) %>";

                document.getElementById("hShipTimeStatus").value = "<%=MakeJavaString(hawbAddTable("ship_time_status")) %>";
                <% For j=1 To hawbOCTableList.Count %>
                findSelect(document.getElementsByName("lstChargeCode")[<%=j %>],"<%=MakeJavaString(hawbOCTableList(j-1)("Charge_Desc")) %>");
                document.getElementsByName("hChargeCode")[<%=j %>].value = "<%=MakeJavaString(hawbOCTableList(j-1)("charge_code")) %>";
                document.getElementsByName("txtChargeDesc")[<%=j %>].value = "<%=MakeJavaString(hawbOCTableList(j-1)("Charge_Desc")) %>";
                document.getElementsByName("txtChargeAmt")[<%=j %>].value = "<%=formatAmount(hawbOCTableList(j-1)("Amt_HAWB") )%>";
                <% Next %>
                
                <% For j=1 To driverTableList.Count %>
                findSelect(document.getElementsByName("lstDriver")[<%=j %>],"<%=MakeJavaString(driverTableList(j-1)("driver_acct")) %>");
                findSelect(document.getElementsByName("lstCostCode")[<%=j %>],"<%=MakeJavaString(driverTableList(j-1)("cost_item_no")) %>");
                document.getElementsByName("txtDriverPieces")[<%=j %>].value = "<%=MakeJavaString(driverTableList(j-1)("piece")) %>";
                document.getElementsByName("txtDriverWeight")[<%=j %>].value = "<%=MakeJavaString(driverTableList(j-1)("weight")) %>";
                document.getElementsByName("txtDriverCost")[<%=j %>].value = "<%=formatAmount(driverTableList(j-1)("cost_amount") )%>";
                document.getElementsByName("txtDriverCostPercent")[<%=j %>].value = "<%=MakeJavaString(driverTableList(j-1)("cost_percent")) %>";
                document.getElementsByName("txtDriverPaid")[<%=j %>].value = "<%=formatAmount(driverTableList(j-1)("driver_paid") )%>";
                document.getElementsByName("txtDriverRemark")[<%=j %>].value = "<%=MakeJavaString(driverTableList(j-1)("remark")) %>";
                document.getElementsByName("hDriverItemNo")[<%=j %>].value = "<%=MakeJavaString(driverTableList(j-1)("item_id")) %>";
                <% If checkBlank(driverTableList(j-1)("bill_number"),0) <> 0 Then  %>
                    document.getElementsByName("hDriverItemNo")[<%=j %>].disabled = true;
                    document.getElementsByName("lstDriver")[<%=j %>].disabled = true;
                    document.getElementsByName("lstCostCode")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverPieces")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverWeight")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverCost")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverCostPercent")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverPaid")[<%=j %>].disabled = true;
                    document.getElementsByName("txtDriverRemark")[<%=j %>].disabled = true;
                    document.getElementsByName("DriverDeleteIcon")[<%=j %>].onclick = "";
                <% Else %>
                <% End If %>
                <% Next %>
                
                document.getElementById("txtPieces").value = "<%=MakeJavaString(hawbWCTable("No_Pieces")) %>";
                document.getElementById("txtGrossWeight").value = "<%=MakeJavaString(hawbWCTable("Gross_Weight")) %>";
                document.getElementById("txtChargeableWeight").value = "<%=MakeJavaString(hawbWCTable("Chargeable_Weight")) %>";
                document.getElementById("txtTotalCharge").value = "<%=formatNumberPlus(checkblank(hawbWCTable("Total_Charge"),0),2) %>";
                document.getElementById("hDimDetail").value = "<%=MakeJavaString(hawbWCTable("Dem_Detail")) %>";
                document.getElementById("hDimFactor").value = "<%=MakeJavaString(hawbWCTable("dimension_factor")) %>";
                document.getElementById("txtCubicInches").value = "<%=MakeJavaString(hawbWCTable("cubic_inches")) %>";
                document.getElementById("txtCubicWeight").value = "<%=MakeJavaString(hawbWCTable("Dimension")) %>";
                document.getElementById("txtRateCharge").value = "<%=MakeJavaString(hawbWCTable("Rate_Charge")) %>";
                
                <% For j=1 To locationTableList.Count %>
                findSelect(document.getElementsByName("lstFreightLocation")[<%=j %>],"<%=MakeJavaString(locationTableList(j-1)("location_id")) %>");
                findSelect(document.getElementsByName("lstFreightLocationStatus")[<%=j %>],"<%=MakeJavaString(locationTableList(j-1)("status")) %>");
                document.getElementsByName("txtFreightLocationJobType")[<%=j %>].value = "<%=MakeJavaString(locationTableList(j-1)("job_type")) %>";
                document.getElementsByName("txtFreightLocationRemark")[<%=j %>].value = "<%=MakeJavaString(locationTableList(j-1)("remark")) %>";
                <% Next %>
            }
            catch(err){
                alert("An Error occurred while loading data, and the information may not be correct.\nPlease contact us for further instruction.");
            }
            
            AddNewTableRow("templateOtherCharge","newOtherCharge");
            AddNewTableRow("templateDriver","newDriver");
            AddNewTableRow("templateFreightLocation","newFreightLocation");
            
            if (document.getElementById("hHAWBType").value != "Y"){
                document.getElementById("OtherChargeDiv").outerHTML = "";
                document.getElementById("WeightChargeDiv").outerHTML = "";
            }
            
            if("<%=vIsInbound %>" == "Y"){
                MM_showHideLayers('pickup','','hide','delivery','','show');
				document.getElementById("pickupli").style.backgroundColor = "#ffffff";
				document.getElementById("deliveryli").style.backgroundColor = "#eec983";
            }
            else{
                MM_showHideLayers('pickup','','show','delivery','','hide');
				document.getElementById("deliveryli").style.backgroundColor = "#ffffff";
				document.getElementById("pickupli").style.backgroundColor = "#eec983";
            }
        }
        
        function SetDefaultDriverValues(thisObj){

            if (document.getElementById("hHAWBType").value =="Y")
            {
                var Vpieces=document.getElementById("txtPieces").value;
                var Vweight=document.getElementById("txtGrossWeight").value;  
                var tableObj = thisObj.parentNode.parentNode.parentNode.parentNode;
                
                var rowID = 0;
                var ObjList = document.getElementsByName(thisObj.name);
                for(var i=0;i<ObjList.length;i++){
                    if(thisObj.uniqueID == ObjList[i].uniqueID){
                        rowID = i;
                    }
                }

                for(var n=1; n<rowID; n++)
                {
                    Vpieces=Vpieces-document.getElementsByName("txtDriverPieces")(n).value;
                    Vweight=Vweight-document.getElementsByName("txtDriverWeight")(n).value;
                }
                if(Vpieces<0)
                {   
                    Vpieces=0;
                }
                
                if(Vweight<0)
                {   
                    Vweight=0;
                }
                document.getElementsByName("txtDriverPieces")(rowID).value = Vpieces;
                document.getElementsByName("txtDriverWeight")(rowID).value = Vweight;
            }
        }
        
		function MM_findObj(n, d) { //v4.01
		  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		  if(!x && d.getElementById) x=d.getElementById(n); return x;
		}
		
		function MM_showHideLayers() { //v6.0
		  var i,p,v,obj,args=MM_showHideLayers.arguments;
		  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
			if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
			obj.visibility=v; }
		}
		
		function swapTabColor(argOn,argOff){
		    document.getElementById(argOn).style.backgroundColor = "#eec983";
		    document.getElementById(argOff).style.backgroundColor = "#ffffff";
		}
		                    
    </script>

    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />
</head>
<body onLoad="loadValues()">
    <!-- onload="MM_showHideLayers('pickup','','inherit')" -->
    <form name="form1">
        <input type="hidden" id="hShipTimeStatus" name="hShipTimeStatus" value="" />
        <!-- page header -->
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" colspan="4" align="left" valign="middle" class="pageheader">
                    HOUSE AIRBILL (Additional Info)
                </td>
                <td width="55%" colspan="5" align="right" valign="middle">
                </td>
            </tr>
        </table>
        <div class="selectarea">
            <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="45%" valign="bottom">
                    </td>
                    <td width="55%" align="right" valign="bottom">
                        <div id="print">
                            <a href="javascript:;" onClick="GoBackHAWB();return false;">
                                <img src="../Images/icon_additional_info_back.gif" alt="Go to previous step" style="margin-right: 15px" />Back
                                to House Airbill </a><a href="javascript:;" onClick="NewPrintVeiw();return false;">
                                    <img src="../Images/icon_printer_preview.gif" alt="Print House Airbill" style="margin-left: 36px" />
                                    House Air Waybill</a></div>
                    </td>
                </tr>
            </table>
        </div>
        <!-- page body -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            class="border1px">
            <tr>
                <td height="22" align="center" bgcolor="#eec983">
                    <img src="../images/button_save_medium.gif" width="46" height="18" style="cursor: pointer"
                        onclick="bsaveClick();" /></td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132">
                </td>
            </tr>
            <tr>
                <td align="center" valign="top" bgcolor="#f3f3f3">
                    <br />
                    <br />
                    <table width="88%" border="0" cellpadding="0" cellspacing="0" bordercolor="#997132"
                        class="border1px">
                        <tr>
                            <td width="44%" align="left" valign="top" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                    <tr>
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader" style="padding-left: 10px">
                                            Customer</td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hCustomerAcct" name="hCustomerAcct" value="" />
                                            <div id="lstCustomerNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstCustomerName" name="lstCustomerName"
                                                            value="" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                            onkeyup="organizationFill(this,'Customer','lstCustomerNameChange',null,event)" onFocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstCustomerName','Customer','lstCustomerNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <input type='hidden' id='quickAdd_output'/>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hCustomerAcct','lstCustomerName','txtCustomerInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtCustomerInfo" name="txtCustomerInfo" class="monotextarea" cols=""
                                                rows="5" style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader" style="padding-left: 10px">
                                            Bill to</td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px">
                                            <!-- Start JPED -->
                                            <input type="hidden" id="hBillToAcct" name="hBillToAcct" value="" />
                                            <div id="lstBillToNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <input type="text" autocomplete="off" id="lstBillToName" name="lstBillToName" value=""
                                                            class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onKeyUp="organizationFill(this,'BillTo','lstBillToNameChange',null,event)"
                                                            onfocus="initializeJPEDField(this,event);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstBillToName','BillTo','lstBillToNameChange',null,event)"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                            onclick="quickAddClient('hBillToAcct','lstBillToName','txtBillToInfo')" /></td>
                                                </tr>
                                            </table>
                                            <textarea id="txtBillToInfo" name="txtBillToInfo" class="monotextarea" cols="" rows="5"
                                                style="width: 300px"></textarea>
                                            <!-- End JPED -->
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="56%" align="left" valign="top">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                                    style="border-left: 1px solid #997132">
                                    <tr>
                                        <td width="43%" height="18" bgcolor="#f3f3f3" class="bodyheader style7" style="padding-left: 10px">
                                            House Airbill No.
                                        </td>
                                        <td width="57%" bgcolor="#f3f3f3" class="bodyheader">
                                            Date</td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px">
                                            <input class="readonlybold" id="txtHAWB" name="txtHAWB" value="" size="24" />
                                            <input type="hidden" id="hHAWBType" name="hHAWBType" value="" />
                                            <input type="hidden" id="hMAWB" name="hMAWB" value="" /></td>
                                        <td>
                                            <input name="txtExecutedDate" class="readonly" id="txtExecutedDate" value="" size="14" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="1" bgcolor="#997132">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="1" bgcolor="#ffffff">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="1" bgcolor="#997132">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="18" colspan="2" bgcolor="#f3d9a8" class="bodyheader" style="padding-left: 10px">
                                            SHIPMENT STATUS</td>
                                    </tr>
                                    <tr>
                                        <td height="28" colspan="2" align="left" class="bodyheader" style="padding-left: 10px">
                                            <input type="radio" name="chkShipStatus" value="A" checked="checked" />
                                            Active
                                            <input type="radio" name="chkShipStatus" value="C" style="margin-left: 30px" />
                                            Closed</td>
                                    </tr>
                                    <tr>
                                        <td height="36" colspan="2" align="left" valign="bottom">
                                            <ul class="simpletabs">
                                                <li id="pickupli"><a href="javascript:; " onClick="MM_showHideLayers('pickup','','show','delivery','','hide'); swapTabColor('pickupli','deliveryli')">
                                                    PICKUP</a> </li>
                                                <li id="deliveryli"><a href="javascript:; " onClick="MM_showHideLayers('pickup','','hide','delivery','','show'); swapTabColor('deliveryli','pickupli')">
                                                    DELIVERY</a> </li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="200" colspan="2" align="left" valign="top" class="bodycopy">
                                            <div style="position: relative; width: 100%">
                                                <!-- pickup column -->
                                                <div id="pickup" style="clear: both">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td width="50%" valign="top">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Alerted</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtPickupAlertedDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtPickupAlertedTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtPickupAlertedDate','txtPickupAlertedTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Ready</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtReadyDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtReadyTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtReadyDate','txtReadyTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Close</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtCloseDate" value="" size="12" class="m_shorttextfield" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtCloseTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtCloseDate','txtCloseTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Pickup Appointment</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtPickupDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtPickupTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtPickupDate','txtPickupTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="50%" valign="top">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Dispatched</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtDispatchedDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtDispatchedTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtDispatchedDate','txtDispatchedTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Onboard</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtOnboardDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtOnboardTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtOnboardDate','txtOnboardTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Transfer to Carrier
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtTransferDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtTransferTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtTransferDate','txtTransferTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Carrier Signer
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input name="txtCarrierSigner" class="shorttextfield" value="" size="34" /></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <!-- delivery column -->
                                                <div id="delivery" style="clear: both">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td width="50%" valign="top">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Alerted</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtDeliveryAlertedDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtDeliveryAlertedTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtDeliveryAlertedDate','txtDeliveryAlertedTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            Recovered</td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtRecoveredDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtRecoveredTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtRecoveredDate','txtRecoveredTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            OFD (Out for Delivery)
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="padding-left: 10px">
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtOFDDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtOFDTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtOFDDate','txtOFDTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="48">
                                                                            &nbsp;</td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="50%" valign="top">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            POD Time
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bodycopy">
                                                                                <tr>
                                                                                    <td>
                                                                                        <span class="style8">Date</span></td>
                                                                                    <td>
                                                                                        <span class="style8">Time</span></td>
                                                                                    <td>
                                                                                        &nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="34%">
                                                                                        <input name="txtPODDate" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="34%">
                                                                                        <input name="txtPODTime" class="m_shorttextfield" value="" size="12" /></td>
                                                                                    <td width="32%">
                                                                                        <img src="../Images/icon_timestamp.gif" alt="Time stamp" align="absmiddle" style="cursor: hand;"
                                                                                            onclick="doTimeStamp('txtPODDate','txtPODTime')" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td height="18" bgcolor="#f3f3f3" class="bodycopy">
                                                                            POD Signer
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <input name="txtPODSigner" class="shorttextfield" value="" size="34" /></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br />
                </td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3">
                    <!-- weight charges -->
                    <div id="WeightChargeDiv">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                            <tr>
                                <td colspan="7" height="2" bgcolor="#997132">
                                </td>
                            </tr>
                            <tr>
                                <td height="20" colspan="7" bgcolor="#f3d9a8" class="bodyheader style7" style="padding-left: 10px">
                                    WEIGHT CHARGES
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td width="9%" height="20" bgcolor="#f3f3f3" class="" style="padding-left: 10px">
                                    Pieces</td>
                                <td width="9%" bgcolor="#f3f3f3">
                                    WT(LB)</td>
                                <td width="9%" bgcolor="#f3f3f3">
                                    Cubic IN
                                </td>
                                <td width="13%" bgcolor="#f3f3f3">
                                    Cubic (WT)
                                </td>
                                <td width="10%" bgcolor="#f3f3f3">
                                    Chrg WT
                                </td>
                                <td width="13%" bgcolor="#f3f3f3">
                                    Rate</td>
                                <td width="37%" bgcolor="#f3f3f3">
                                    Total</td>
                            </tr>
                            <tr>
                                <td align="left" class="" style="padding-left: 10px">
                                    <input name="txtPiece" class="txtunitbox" id="txtPieces" value="" size="6" maxlength="6"
                                        style="behavior: url(../include/igNumDotChkLeft.htc)" />
                                    <input type="hidden" id="hDimDetail" name="hDimDetail" value="" style="behavior: url(../include/igNumDotChkLeft.htc)"  />
                                    <input type="hidden" id="hDimFactor" name="hDimFactor" value="" style="behavior: url(../include/igNumDotChkLeft.htc)"  />
                                </td>
                                <td align="left">
                                    <input name="txtGrossWeight" class="txtunitbox" id="txtGrossWeight" value="" size="10"
                                        maxlength="7" style="behavior: url(../include/igNumDotChkLeft.htc)"  onfocusout="setChargeableWeight();" />
                                </td>
                                <td align="left">
                                    <input name="txtCubicInches" class="txtunitbox" id="txtCubicInches" value="" size="10"
                                        maxlength="7" style="behavior: url(../include/igNumDotChkLeft.htc)"  /></td>
                                <td align="left">
                                    <input name="txtCubicWeight" class="txtunitbox" id="txtCubicWeight" value="" size="10"
                                        maxlength="7" onfocusout="setChargeableWeight();" style="behavior: url(../include/igNumDotChkLeft.htc)"  />
                                    <img src="../images/measure.gif" name="" width="16" height="16" align="absmiddle"
                                        style="cursor: hand; margin-left: 4px" onClick="DimCalClick();" /></td>
                                <td align="left">
                                    <input name="txtChargeableWeight" class="txtunitbox" id="txtChargeableWeight" value=""
                                        size="9" maxlength="7" style="behavior: url(../include/igNumDotChkLeft.htc)"  /></td>
                                <td align="left">
                                    <input name="txtRateCharge" class="txtunitbox" id="txtRateCharge" value="" size="4"
                                        maxlength="5" style="behavior: url(../include/igNumDotChkLeft.htc)"  />
                                    <img src="../images/button_cal.gif" name="bCal" width="37" height="18" align="absmiddle"
                                        style="cursor: hand" onClick="setTotalWeightCharge()" /></td>
                                <td align="left">
                                    <input name="txtTotalCharge" id="txtTotalCharge" value="" size="12" maxlength="12"
                                        class="txtunitbox" style="behavior: url(../include/igNumDotChkLeft.htc)"  /></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height: 8px">
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <div ID="OtherChargeDiv">
                    <table id="tblOtherCharge" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <thead>
                            <tr>
                                <td colspan="5" height="1" bgcolor="#997132">
                                </td>
                            </tr>
                            <tr>
                                <td width="10" bgcolor="#f3d9a8">
                                </td>
                                <td height="20" bgcolor="#f3d9a8" class="bodyheader style7" colspan="4">
                                    OTHER CHARGES
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td width="10">
                                </td>
                                <td bgcolor="#f3f3f3">
                                    Charge Type
                                </td>
                                <td bgcolor="#f3f3f3">
                                    Charge Description</td>
                                <td bgcolor="#f3f3f3">
                                    Amount</td>
                                <td bgcolor="#f3f3f3" width="40%">
                                </td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="visibility: hidden" ID="templateOtherCharge">
                                <td style="height: 24px">
                                </td>
                                <td style="height: 24px">
                                    <select size="1" name="lstChargeCode" onChange="ChargeItemChange(this)" class="smallselect"
                                        style="width: 220px">
                                        <option value=""></option>
                                        <% For i=0 To aChargeItem.Count-1 %>
                                        <option value="<%=aChargeItem(i)("item_no") %>-<%=aChargeItem(i)("unit_price") %>-<%=aChargeItem(i)("item_name") %>-<%=aChargeItem(i)("item_desc") %>">
                                            <%=aChargeItem(i)("item_name") %>
                                            -<%=aChargeItem(i)("item_desc") %></option>
                                        <% Next %>
                                    </select>
                                    <input type="hidden" name="hChargeCode" value="" /></td>
                                <td style="height: 24px">
                                    <input name="txtChargeDesc" size="40" value="" class="shorttextfield" /></td>
                                <td style="height: 24px">
                                    <input name="txtChargeAmt" size="10" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td style="height: 24px">
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: pointer" name="OCDeleteIcon" /></td>
                            </tr>
                            <% For j=0 To hawbOCTableList.Count-1 %>
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <select size="1" name="lstChargeCode" onChange="ChargeItemChange(this)" style="width: 220px"
                                        class="smallselect">
                                        <option value=""></option>
                                        <% For i=0 To aChargeItem.Count-1 %>
                                        <option value="<%=aChargeItem(i)("item_no") %>-<%=aChargeItem(i)("unit_price") %>-<%=aChargeItem(i)("item_name") %>-<%=aChargeItem(i)("item_desc") %>">
                                            <%=aChargeItem(i)("item_name") %>
                                            -<%=aChargeItem(i)("item_desc") %></option>
                                        <% Next %>
                                    </select>
                                    <input type="hidden" name="hChargeCode" value="" />
                                </td>
                                <td>
                                    <input name="txtChargeDesc" size="40" value="" class="shorttextfield" /></td>
                                <td>
                                    <input name="txtChargeAmt" size="10" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td>
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: hand" name="OCDeleteIcon" /></td>
                            </tr>
                            <% Next %>
                            <tr ID="newOtherCharge">
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td width="10">
                                </td>
                                <td class="textbutton">
                                    <a href="javascript:;" onClick="AddNewTableRow('templateOtherCharge','newOtherCharge'); return false;">
                                        <img src="../Images/icon_add.gif" alt="Add Driver" />ADD CHARGE ITEM </a>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <!-- Start JPTableDome.js Referred -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <thead>
                            <tr>
                                <td colspan="10" height="2" bgcolor="#997132">
                                </td>
                            </tr>
                            <tr>
                                <td width="10px" bgcolor="#f3d9a8" class="bodyheader style7">
                                </td>
                                <td height="20" colspan="9" bgcolor="#f3d9a8" class="bodyheader style7">
                                    DRIVERS &nbsp;&nbsp;<a href="javascript:;" onclick="GoManageDrivers();">Manage Drivers</a>
                                </td>
                            </tr>
                            <tr>
                                <td width="10px">
                                </td>
                                <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Driver Name
                                </td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Cost Item
                                </td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Pieces</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Weight</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Cost</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    %</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Paid</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                    Remark</td>
                                <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                                </td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="visibility: hidden;" ID="templateDriver">
                                <td width="10px">
                                </td>
                                <td>
                                    <input type="hidden" name="hDriverItemNo" value="" />
                                    <select size="1" name="lstDriver" style="width: 220px" class="smallselect" onChange="SetDefaultDriverValues(this)">
                                        <option value="0"></option>
                                        <% For i=0 To aVendorList.Count-1 %>
                                        <option value="<%=aVendorList(i)("acct") %>">
                                            <%=aVendorList(i)("name") %>
                                        </option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <select size="1" name="lstCostCode" class="smallselect" style="width: 220px">
                                        <option value="0"></option>
                                        <% For i=0 To aCostItem.Count-1 %>
                                        <option value="<%=aCostItem(i)("item_no") %>">
                                            <%=aCostItem(i)("item_name") %>
                                            -<%=aCostItem(i)("item_desc") %></option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <input name="txtDriverPieces" size="6" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                        onChange="checkPiece(this);" /></td>
                                <td>
                                    <input name="txtDriverWeight" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                        onChange="checkWeight(this);" /></td>
                                <td>
                                    <input name="txtDriverCost" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td>
                                    <input name="txtDriverCostPercent" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td>
                                    <input name="txtDriverPaid" size="8" value="" class="d_numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                        readonly="readonly" /></td>
                                <td>
                                    <input name="txtDriverRemark" size="26" value="" class="shorttextfield" /></td>
                                <td>
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: hand" name="DriverDeleteIcon" /></td>
                            </tr>
                            <% For j=0 To driverTableList.Count-1 %>
                            <tr>
                                <td width="10px">
                                </td>
                                <td>
                                    <input type="hidden" name="hDriverItemNo" value="" />
                                    <select size="1" name="lstDriver" style="width: 220px" class="smallselect" onChange="SetDefaultDriverValues(this)">
                                        <option value="0"></option>
                                        <% For i=0 To aVendorList.Count-1 %>
                                        <option value="<%=aVendorList(i)("acct") %>">
                                            <%=aVendorList(i)("name") %>
                                        </option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <select size="1" name="lstCostCode" class="smallselect" style="width: 220px">
                                        <option value="0"></option>
                                        <% For i=0 To aCostItem.Count-1 %>
                                        <option value="<%=aCostItem(i)("item_no") %>">
                                            <%=aCostItem(i)("item_name") %>
                                            -<%=aCostItem(i)("item_desc") %></option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <input name="txtDriverPieces" size="6" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                        onChange="checkPiece(this);" /></td>
                                <td>
                                    <input name="txtDriverWeight" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                        onChange="checkWeight(this);" /></td>
                                <td>
                                    <input name="txtDriverCost" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td>
                                    <input name="txtDriverCostPercent" size="8" value="" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" /></td>
                                <td>
                                    <input name="txtDriverPaid" size="8" value="" class="d_numberfield" style="behavior: url(../include/igNumDotChkLeft.htc)" 
                                        readonly="readonly" /></td>
                                <td>
                                    <input name="txtDriverRemark" size="26" value="" class="shorttextfield" /></td>
                                <td>
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: hand" name="DriverDeleteIcon" /></td>
                            </tr>
                            <% Next %>
                            <tr ID="newDriver">
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td width="10px">
                                </td>
                                <td class="textbutton" colspan="9">
                                    <a href="javascript:;" onClick="AddNewTableRow('templateDriver','newDriver'); return false;">
                                        <img src="../Images/icon_add.gif" alt="Add Driver" />ADD DRIVER </a>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    <!-- End JPTableDome.js Referred -->
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left" valign="top">
                    <!-- Start JPTableDome.js Referred -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <thead>
                            <tr>
                                <td colspan="8" height="1" bgcolor="#997132">
                                </td>
                            </tr>
                            <tr>
                                <td height="20" bgcolor="#f3d9a8" class="bodyheader style7" colspan="8" style="padding-left: 10px">
                                    MILESTONES &nbsp;&nbsp;<a href="javascript:;" onclick="GoManageFreightLocations();">Manage
                                        Freight Locations</a>
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td width="10px">
                                </td>
                                <td>
                                    Location</td>
                                <td>
                                    Job Type</td>
                                <td>
                                    Status</td>
                                <td>
                                    Remark</td>
                                <td width="20px">
                                </td>
                                <td width="20px">
                                </td>
                                <td width="20px">
                                </td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="visibility: hidden" ID="templateFreightLocation">
                                <td width="10px">
                                </td>
                                <td>
                                    <select name="lstFreightLocation" style="width: 220px" class="smallselect">
                                        <option value=""></option>
                                        <% For i=0 To aFLocation.Count-1 %>
                                        <option value="<%=aFLocation(i)("id") %>">
                                            <%=aFLocation(i)("name") %>
                                        </option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="txtFreightLocationJobType" style="width: 200px" class="shorttextfield" /></td>
                                <td>
                                    <select name="lstFreightLocationStatus" style="width: 160px" class="smallselect">
                                        <option value=""></option>
                                        <option value="Issued">Issued</option>
                                        <option value="Acknowledged">Acknowledged</option>
                                        <option value="In-progress">In-progress</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Incompleted">Incompleted</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="txtFreightLocationRemark" style="width: 200px" class="shorttextfield" /></td>
                                <td>
                                    <a href="javascript:;" onclick="tableRowMoveUp(this)" style="font-size: 10px">
                                        <img src="../Images/Collapse.gif" />
                                        Move</a>
                                </td>
                                <td>
                                    <a href="javascript:;" onclick="tableRowMoveDown(this)" style="font-size: 10px">
                                        <img src="../Images/Expand.gif" />
                                        Move</a>
                                </td>
                                <td>
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: pointer" name="LocationDeleteIcon" /></td>
                            </tr>
                            <% For j=0 To locationTableList.Count-1 %>
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <select name="lstFreightLocation" style="width: 220px" class="smallselect">
                                        <option value=""></option>
                                        <% For i=0 To aFLocation.Count-1 %>
                                        <option value="<%=aFLocation(i)("id") %>">
                                            <%=aFLocation(i)("name") %>
                                        </option>
                                        <% Next %>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="txtFreightLocationJobType" style="width: 200px" class="shorttextfield" /></td>
                                <td>
                                    <select name="lstFreightLocationStatus" style="width: 160px" class="smallselect">
                                        <option value=""></option>
                                        <option value="Issued">Issued</option>
                                        <option value="Acknowledged">Acknowledged</option>
                                        <option value="In-progress">In-progress</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Incompleted">Incompleted</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="txtFreightLocationRemark" style="width: 200px" class="shorttextfield" /></td>
                                <td>
                                    <a href="javascript:;" onclick="tableRowMoveUp(this)" style="font-size: 10px">
                                        <img src="../Images/Collapse.gif" />
                                        Move</a>
                                </td>
                                <td>
                                    <a href="javascript:;" onclick="tableRowMoveDown(this)" style="font-size: 10px">
                                        <img src="../Images/Expand.gif" />
                                        Move</a>
                                </td>
                                <td>
                                    <img src="../images/button_delete.gif" width="50" height="17" onClick="DeleteTableRow(this)"
                                        style="cursor: hand" name="LocationDeleteIcon" /></td>
                            </tr>
                            <% Next %>
                            <tr ID="newFreightLocation">
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td width="10px">
                                </td>
                                <td colspan="8" class="textbutton">
                                    <a href="javascript:;" onClick="AddNewTableRow('templateFreightLocation','newFreightLocation'); return false;">
                                        <img src="../Images/icon_add.gif" alt="Add Location" />ADD FREIGHT LOCATIONS</a>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    <!-- End JPTableDome.js Referred -->
                </td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132">
                </td>
            </tr>
            <tr>
                <td height="22" align="center" valign="middle" bgcolor="#eec983">
                    <img src="../images/button_save_medium.gif" name="bSave" width="46" height="18" id="bSave"
                        style="cursor: pointer" onClick="bsaveClick();" /></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="45%" height="45" valign="bottom">
                </td>
                <td width="55%" align="right" valign="bottom">
                    <div id="print">
                        <a href="javascript:;" onClick="GoBackHAWB();return false;">
                            <img src="../Images/icon_additional_info_back.gif" alt="Go to previous step" style="margin-right: 15px" />Back
                            to House Airbill </a><a href="javascript:;" onClick="NewPrintVeiw();return false;">
                                <img src="../Images/icon_printer_preview.gif" alt="Print House Airbill" style="margin-left: 36px" />
                                House Air Waybill</a></div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
