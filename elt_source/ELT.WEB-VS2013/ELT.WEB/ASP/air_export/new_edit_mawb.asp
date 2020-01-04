<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
   
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<script type="text/javascript" language="javascript">

    function setAirFreight() {
        var url = "/IFF_MAIN/ASPX/AccountingTasks/setDefaultFreight.aspx?air_ocean=air";

        var req = "";
        if (window.ActiveXObject) {
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (error) {
                try {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (error) { return ""; }
            }
        }
        else if (window.XMLHttpRequest) {
            req = new XMLHttpRequest();
        }
        else { return ""; }

        req.open("get", url, false);
        req.send();
        var result = req.responseText;
        if (result != "true") {
            return true;
        } else {
            return false;
        }
    }

    function GetOtherCurrency(thisObj, objID) {
        var vCountry = document.getElementById(objID).value;
        var vURL = "/ASP/site_admin/select_currency.asp?code=" + thisObj.value + "&ccode=" + vCountry;
        var vWinArg = "dialogWidth:370px; dialogHeight:280px; help:no; status:no; scroll:no; center:yes";

        var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        if (vReturn) {
            thisObj.value = vReturn;
        }
    }
</script>
<%

''@DECLARATION''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

dim bill_num , vDefaultFreightCostNo , vDefaultFreightCostDesc , vTotalRealCost , vLock_ap , vAgentOrgAcct, vRateRealCost, vProcessDT, vDefaultAccountExpense
Dim vDepCode, vArrCode
Dim MinApplied
MinApplied = -1
Dim qMAWB,vMAWB, vMAWBInfo,vHAWB,IVstrMsg,rs3,ErrMSG,AgentName
Dim qShipperName, vShipperInfo, vShipperName,qShipperAcct,vShipperAcct
Dim qConsigneeName, vConsigneeName, vConsigneeInfo,qConsigneeAcct,vConsigneeAcct
Dim qNotify,vWeightScale
Dim vAgentInfo,vAgentIATACode,vAgentAcct,vDepartureAirport, vTo, vBy, vTo1, vBy1, vTo2, vBy2
Dim vOriginPortID,cMAWB
Dim vDestAirport,vFlightDate1,vFlightDate2
Dim vIssuedBy,vAccountInfo
Dim vCurrency, AgentCountryCode, vChargeCode, vPPO_1, vCOLL_1, vPPO_2, vCOLL_2
Dim vDeclaredValueCarriage, vDeclaredValueCustoms,vInsuranceAMT
Dim vHandlingInfo, vSCI,vSignature,vPlaceExecuted, aMAWB()

'// Weight Charges
Dim aTranNo(3),aPiece(3),aGrossWeight(3),aAdjustedWeight(3),aKgLb(3),aRateClass(3),aItemNo(3),aDimension(3),aDemDetail(3),aChargeableWeight(3),aRateCharge(3),aTotal(3),aLength(3),aWidth(3),aHeight(3)
Dim vTotalPieces,vTotalGrossWeight,vTotalWeightCharge,vDesc1,vDesc2
Dim vShowWeightChargeShipper,vShowWeightChargeConsignee
'// Other Charges
Dim aCarrierAgent(10),aCollectPrepaid(10),aChargeCode(10),aDesc(10),aChargeAmt(10),aVendor(10),aCost(10),aOtherCharge(5)
Dim vShowPrepaidOtherChargeShipper,vShowCollectOtherChargeShipper
Dim vShowPrepaidOtherChargeConsignee,vShowCollectOtherChargeConsignee
Dim cName,cAddress,cCity,cState,cZip,cCountry,cPhone,cIndex
'// Avaliable Houses
Dim aHAWB(640),sHAWB(640),aCOLO(640),sCOLO(640),aShipper(640),sShipper(640),sIsMaster(640),aConsignee(640),sConsignee(640)
Dim aAgent(640),sAgent(640),aClass(640),sRateClass(640),aPCS(640),sPCS(640),aWeightTran(640),aGW(640),sGW(640)
Dim aAW(640),sAW(640),aCW(640),sCW(640),aDW(640),sDW(640),addELTAcct(640),delELTAcct(640)
DIM sHsPCS(640),sHsGW(640),sHsAW(640),sHsDW(640),sHsCW(640),sHsHAWB(640),sHdelELTAcct(640)
DIM sHsCOLO(640),sHsAgent(640),sHsShipper(640),sHsConsignee(640) 
'// Coloaders
Dim aColodeeName(64),aColodeeAcct(64)

'///Dim aAgentName(4096),aAgentInfo(2),aAgentAcct(4096)
'// Dim aShipperName(4096),aShipperInfo(2),aShipperAcct(4096)
'///Dim aConsigneeName(4096),aConsigneeInfo(2),aConsigneeAcct(4096)
'///Dim aNotifyInfo(2),aNotify(4096)
'///aMAWBInfo(2)
Dim rs,rs1,SQL
Dim aChargeItemNo(),aChargeItemName(),aChargeItemDesc(),aChargeItemNameig(),aChargeUnitPrice()
DIM vTotalHAWB,vQueueID
Dim NoHAWB,IsCOLO,tKgLb
'//////////////////////////////////////////////////////////////////
DIM  sTotalPCS,sTotalGW,sTotalAW,sTotalDW,sTotalCW,GWPercent,AWPercent,DWPercent
DIM vUOM, vDefaultAgentName,vExecute,vExecutionDatePlace,aExecute
DIM Save,AddOC,AddHAWB,Edit,DeleteOC,AdjustWeight
DIM DeleteMAWB,DeleteHAWB,fBook
DIM wCount,vAirOrgNum,vDefaultAgentInfo,vFFShipperAcct,pos
DIM vNotify,qNotifyName,vFFConsigneeAcct,vNotifyAcct,vDestCountry
DIM AddHAWBNo,vAddELTAcct,dHAWB,vDelELTAcct
DIM NoItemWC,NoItemOC,vTotalChgWT,ChargeItemInfo,dItemNo
DIM oIndex,vPrepaidOtherChargeAgent,vCollectOtherChargeAgent,vPrepaidOtherChargeCarrier
DIM vCollectOtherChargeCarrier,vPrepaidWeightCharge,vCollectWeightCharge,vPrepaidValuationCharge
DIM vCollectValuationCharge,vPrepaidTax,vCollectTax,vConversionRate,vCCCharge,vChargeDestination
DIM vPrepaidTotal,vCollectTotal,vFinalCollect
DIM NewMAWB,chIndex,mIndex,sIndex,aIndex,sCount,aCount,coIndex
Dim mMawbNo,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport
Dim mFlight1,mFlight2,mETDDate,mFlightDate1,mFlightDate2,mCarrierDesc,mCount
Dim chkAvailTab
Dim vAirline
dim vDefault_SalesRep	
vDefault_SalesRep=session_user_lname	
Dim vSalesPerson
Dim aSRName()
Dim SRIndex
dim NoConsol
DIM sHsCount,sHsTotalPCS,sHsTotalGW,sHsTotalAW,sHsTotalDW,sHsTotalCW
dim tmpAgent(),dict	
NoConsol=false
Dim vFileNo
Dim vReferenceNumber
Dim vAES,vSEDStmt,vSONum,vPONum

''END OF DECLARATION''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


''@INITIALIZATION'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs1 = Server.CreateObject("ADODB.Recordset")
Set rs3 = Server.CreateObject("ADODB.Recordset")
Save=Request.QueryString("Save")
AddOC=Request.QueryString("AddOC")
AddHAWB=Request.QueryString("AddHAWB")
Edit=Request.QueryString("Edit")
DeleteOC=Request.QueryString("DeleteOC")
DeleteHAWB=Request.QueryString("DeleteHAWB")
AdjustWeight=Request.QueryString("AdjustWeight")
vMAWB=Request.QueryString("MAWB")
vMAWB=Replace(vMAWB,"?"," ")
DeleteMAWB=Request.QueryString("DeleteMAWB")
fBook=Request.QueryString("fBook")

'// If master is not saved yet bring booking info
If Edit="yes" Then
    If GetSQLResult("SELECT mawb_num FROM mawb_master WHERE elt_account_number=" & elt_account_number & " AND mawb_num=N'" & vMAWB & "'",Null) = "" Then
        fBook = "yes"
    End If
End If

chkAvailTab = NOT AddHAWB ="no" AND NOT DeleteHAWB ="yes" AND NOT  AddOC = "yes" _
AND NOT DeleteOC = "yes" AND NOT AdjustWeight = "yes" AND NOT Edit ="yes" _
AND NOT SAVE = "yes"

''END OF INITIALIZATION''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

''@MAIN LOGIC''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    '// Transaction Added By Joon on Oct,30 2007 /////////////////////////////////
    eltConn.BeginTrans

    CALL REDIRECT_URL
    CALL GET_DEFAULT_FREIGHT_COST_FROM_DB
    CALL GET_SALES_PERSONS_FROM_USERS
    CALL GET_DEFAULT_WEIGHT_SCALE
    CALL MAIN_PROCESS
    '// CALL GET_AGENT_SHIPPER_CONSIGNEE_VENDOR_INFO
    CALL GET_MAWB_NUMBER_FROM_TABLE( vMAWB )
    Call GET_DEP_ARR_CODE	
    CALL GET_CHARGE_ITEM_INFO
    CALL FINAL_SCREEN_PREPARE
    CALL GET_PRESHIPMENT_DATA

    eltConn.CommitTrans

Sub GET_PRESHIPMENT_DATA
    Dim SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    If Request.QueryString("DataTransfer") = "SO" And Request.QueryString("SONum") <> "" Then
        vSONum = Request.QueryString("SONum")
        SQL = "SELECT * FROM warehouse_shipout WHERE elt_account_number=" _
            & elt_account_number & " AND so_num=N'" & vSONum & "'"

        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            vShipperAcct = rs("customer_acct")
            vShipperName = GetBusinessName(rs("customer_acct"))
            vShipperInfo = GetOrgNameAddress(rs("customer_acct"))
            vConsigneeAcct = rs("consignee_acct")
            vConsigneeName = GetBusinessName(rs("consignee_acct"))
            vConsigneeInfo = GetOrgNameAddress(rs("consignee_acct")) 
            vNotifyAcct = rs("consignee_acct")
            vAccountInfo = GetOrgNameAddress(rs("consignee_acct")) 
        End If
        
        rs.close()
        
        SQL = "SELECT * FROM warehouse_receipt a LEFT OUTER JOIN warehouse_history b " _
            & "ON (a.elt_account_number=b.elt_account_number AND a.wr_num=b.wr_num) " _
            & "WHERE a.elt_account_number=" + elt_account_number + " AND b.so_num=N'" _
            & vSONum & "' AND history_type='Ship-out Made'"
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        aPiece(0) = 0
        Do While Not rs.EOF And Not rs.BOF
            vDesc2 = vDesc2 & rs("item_desc") & chr(10)
            vHandlingInfo = vHandlingInfo & rs("handling_info") & chr(10)
            aPiece(0) = aPiece(0) + CInt(rs("item_piece_shipout"))
            rs.MoveNext()
        Loop
    
    Elseif Request.QueryString("DataTransfer") = "PO" And Request.QueryString("PONum") <> "" Then
        vPONum = Request.QueryString("PONum")
        SQL = "SELECT * FROM pickup_order WHERE elt_account_number=" _
            & elt_account_number & " AND po_num=N'" & vPONum & "'"
            
        rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If Not rs.EOF And Not rs.BOF Then
            
            vShipperAcct = rs("shipper_account_number")
            vShipperName = rs("Shipper_Name")
            vShipperInfo = rs("Shipper_Info")
            vConsigneeAcct = rs("Carrier_account_number")
            vConsigneeName = rs("Carrier_Name")
            vConsigneeInfo = rs("Carrier_Info")
            
            vHandlingInfo = rs("Handling_Info")
            
            If IsNumeric(rs("Total_Pieces")) Then
                aPiece(0) = rs("Total_Pieces")
            End If
            vDesc2 = rs("Desc2")
            aGrossWeight(0) = rs("Total_Gross_Weight")
            
            aAdjustedWeight(0) = rs("Total_Gross_Weight")
            aChargeableWeight(0) = rs("Total_Gross_Weight")
            akglb(0) = Left(rs("Weight_Scale"),1)
        End If

        rs.close()

    End If
    
    If Save="yes" And vSONum <> "" Then
	    SQL="UPDATE warehouse_shipout SET file_type='AE',master_num=N'" & vMAWB _
	        & "',house_num='' WHERE so_num=N'" & vSONum & "'"
	    eltConn.Execute(SQL)
	Elseif Save = "yes" And vPONum <> "" Then
        SQL="UPDATE pickup_order SET file_type='AE',MAWB_NUM=N'" & vMAWB _
	        & "',HAWB_NUM=N'' WHERE po_num=N'" & vPONum & "'"
	    eltConn.Execute(SQL)
    End If
End Sub


Sub REDIRECT_URL
    Dim SQL,rs
	Set rs = Server.CreateObject("ADODB.Recordset")
    If DeleteMAWB="yes" or Save="yes" or AddOC="yes" or AddHAWB="yes" or DeleteOC="yes" or DeleteHAWB="yes" or AdjustWeight="yes" Then
    Else
        SQL = "SELECT master_type,is_inbound FROM mawb_number WHERE elt_account_number=" & elt_account_number _
            & " AND is_dome='Y' AND mawb_no=N'" & vMAWB & "'"

        
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        If NOT rs.EOF AND NOT rs.BOF Then
            If rs("is_inbound") = "Y" Then
                Response.Write("<script> window.location.href='/ASP/domestic/inbound_alert.asp?mode=edit&MAWB=" & Server.URLEncode(vMAWB) & "'; </script>")    
            Else
                If rs(0).value = "DG" Then
                    Response.Write("<script> window.location.href='/ASP/domestic/new_mawb_ground.asp?mode=edit&MAWB=" & Server.URLEncode(vMAWB) & "'; </script>")    
                Elseif rs(0).value = "DA" Then
                    Response.Write("<script> window.location.href='/ASP/domestic/new_edit_mawb.asp?Edit=yes&MAWB=" & Server.URLEncode(vMAWB) & "'; </script>")    
                End If
            End If
            rs.close()
            Response.End()
        End If
    End If
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:MAIN_PROCESS
'Purpose  of the procedure: The procedure is in charge of splitting the tasks related to MAWB, according to the user request to the page
'Group of the tasks that are performed within:				    
'Group 1 Editing/Saving/Deleting MAWB
'Group 2 Invoice Queue related 
'Group 3 Getting the MAWB related information from Screen
'Group 4 Getting the MAWB related information from DB
'Group 5 Getting/Posting/Adding/Removing/Calculating HAWBs to be consolidated
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB MAIN_PROCESS
	IF DeleteMAWB="yes" THEN
		CALL DELETE_MAWB( vMAWB )		
	'// by iMoon 2/21/2007		
		CALL INVOICE_QUEUE_REFRESH( vMAWB )			
		EXIT SUB
	END IF
	IF Save="yes" or AddOC="yes" or AddHAWB="yes" or DeleteOC="yes" or DeleteHAWB="yes" or AdjustWeight="yes" THEN
		CALL GET_MAWB_INFO_FROM_SCREEN
		if AddHAWB="yes" then
			CALL ADD_HAWB_INFO		
		end if	
		IF DeleteHAWB="yes" THEN
			CALL DELETE_HAWB_INFO
		END IF	
		CALL GET_ITEM_WEIGHT_CHARGE_INFO_SCREEN		
		IF AdjustWeight="yes" THEN
			'// CALL ADJUST_WEIGHT_SUB
		END IF
		CALL SET_ITEM_WEIGHT_TOTAL_AND_DESC	
		CALL GET_ITEM_OTHER_CHARGE_INFO_SCREEN	
		IF DeleteOC="yes" THEN
			CALL DELETE_OTHER_CHARGE_INFO
		END IF	
		CALL SET_ITEM_OTHER_CHARGE_INFO	
		if Save="yes" Then
			CALL UPDATE_MAWB_TABLE
			CALL save_cost_item_and_bill_detail_trans("A","E")
		end if
	ELSE
		IF NOT vMAWB="" THEN	
			CALL GET_MB_COST_ITEM_FROM_DB
			CALL GET_MAWB_INFO_FROM_TABLE( vMAWB )			
		ELSE
			vPPO_1="Y"
			vPPO_2="Y"
			vDeclaredValueCarriage="NVD"
			vDeclaredValueCustoms="NCV"
			vInsuranceAMT="XXX"
			vShowWeightChargeShipper="Y"
			vShowWeightChargeConsignee="Y"
			vShowPrepaidOtherChargeShipper="Y"
			vShowCollectOtherChargeShipper="Y"
			vShowPrepaidOtherChargeConsignee="Y"
			vShowCollectOtherChargeConsignee="Y"
			vCurrency = GetSQLResult("SELECT currency FROM user_profile WHERE elt_account_number=" & elt_account_number, "currency")
			
			SQL= "select '' as coll_prepaid,'' as carrier_agent,item_no,item_desc,0 as amt_mawb from " _
                & "item_charge where elt_account_number=" & elt_account_number _
                & " and isnull(item_def,'Custom')='System' order by item_no"
            
            
            rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
    		
		    oIndex=0
		    Do while Not rs.EOF
			    aCollectPrepaid(oIndex)=rs("coll_prepaid")
			    aCarrierAgent(oIndex)=rs("carrier_agent")
			    aChargeCode(oIndex)=rs("item_no")
			    aDesc(oIndex)=rs("item_desc")
			    aChargeAmt(oIndex)=rs("amt_mawb")
			    oIndex = oIndex + 1
			    rs.MoveNext
		    Loop
		    rs.Close
		END IF
		
		CALL SET_DETAULT_OTHER_CHARGE_ITEM_LINE
		Call GET_AGENT_GENERAL_INFORMAION
		
	END IF
	
	IF vMAWB="" THEN EXIT SUB
	IF not AddOC="yes" and not DeleteOC="yes" then
		CALL RESET_PIECE_WEIGHT
	END IF	
	CALL FIND_ALL_COLODEES				
	CALL GET_SELECTED_HAWB_INFO
	CALL GET_AVAIL_HAWB	
	CALL RESET_WCOUNT'------------------wCount=0
	if not AddHAWB="yes" and not DeleteHAWB="yes" and not AdjustWeight="yes" and not AddOC="yes" and not DeleteOC="yes" then
		CALL GET_MAWB_WEIGHT_CHARGE_INFO_FROM_TABLE	
	end if
	if wCount=0 and not AddOC="yes" and not DeleteOC="yes" then
		CALL GET_DEP_ARR_CODE	
		CALL RECALC_ITEM_RATE_CHARGE	
	end if
	if AddHAWB="yes" or DeleteHAWB="yes" or AdjustWeight="yes" or Edit="yes" then
		CALL RECALC_ITEM_TOTAL  
	end if
	vAirline=cInt(Mid(vMAWB,1,3))	
END SUB

Sub GET_MB_COST_ITEM_FROM_DB 
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")
    if  Not vMAWB="" then
        SQL= "select item_no,item_desc,cost_amount,lock_ap, rate from mb_cost_item where elt_account_number = " _
            & elt_account_number & " and mb_no=N'" & vMAWB& "'" & "order by item_id"
        
        rs.Open SQL, eltConn, , , adCmdText
		if not rs.eof then 
	        vDefaultFreightCostNo =rs("item_no")
	        vDefaultFreightCostDesc =rs("item_desc")	       
	        vTotalRealCost =cDbl(rs("cost_amount"))
			vLock_ap =rs("lock_ap")	
			vRateRealCost=rs("rate")	
		end if 
        rs.Close
    end if 
    Set rs=Nothing 
End Sub 

Sub GET_DEFAULT_FREIGHT_COST_FROM_DB
	vDefaultFreightCostNo=0    
    Dim rs
    Set rs=Server.CreateObject("ADODB.Recordset")  
	SQL= "select isnull(default_air_cost_item,-1) as default_air_cost_item from user_profile where elt_account_number = " & elt_account_number
	
	rs.Open SQL, eltConn, , , adCmdText	
	
	if not rs.eof  then 
	 if  cdbl(rs("default_air_cost_item"))<>-1 then 
		vDefaultFreightCostNo=rs("default_air_cost_item")
	 else 
	    vDefaultFreightCostNo=setDefaultAF
	   'response.Write("<script language='javascript'> setAirFreight() </script>")
	 end if 
	else 
	    vDefaultFreightCostNo=setDefaultAF
	    'response.Write("<script language='javascript'> setAirFreight() </script>")
	end if 
	rs.Close	
	if cdbl(vDefaultFreightCostNo) <> 0 then 	
		SQL= "select account_expense, item_desc from item_cost where elt_account_number = " & elt_account_number& " and item_no ="&vDefaultFreightCostNo		
		rs.Open SQL, eltConn, , , adCmdText		
		if not rs.eof then 
			vDefaultAccountExpense = ConvertAnyValue(rs("account_expense"), "Integer", 0)
			vDefaultFreightCostDesc=rs("item_desc")
		end if 
		rs.Close   
	end if 
    Set rs=Nothing 
	
End Sub 

function setDefaultAF
    Dim rs
    dim acct
    DIM nextAcctNo
    
    Set rs1=Server.CreateObject("ADODB.Recordset")  
    SQL = "select  max(gl_account_number) as gl_account_number from  gl  where elt_account_number = " & elt_account_number & "  and gl_account_type= 'Cost of Sales' and gl_master_type='EXPENSE'"
    
    rs1.Open SQL, eltConn, , , adCmdText	
    if not  rs1.eof  then 
        nextAcctNo=ConvertAnyValue(rs1("gl_account_number"),"Integer",0)
        nextAcctNo=nextAcctNo+1
    end if 
    rs1.close
    
'    Set rs=Server.CreateObject("ADODB.Recordset")  
'    SQL = "select  top 1 * from gl where elt_account_number = " & elt_account_number & "  and gl_account_type= 'Cost of Sales' and gl_master_type='EXPENSE' and gl_account_desc='Default Air Freight'"
'    
'    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'    if not rs.eof  then 
'    else
'        rs.AddNew
'        rs("elt_account_number")=elt_account_number
'        rs("gl_account_number")=nextAcctNo
'        rs("gl_account_desc")="Default Air Freight"		
'        rs("gl_master_type")="EXPENSE"	
'        rs("gl_account_type")="Cost Of Sales"
'        rs("gl_account_status")="A"	
'        rs("gl_account_cdate")=Now	
'        rs("gl_last_modified")=Now	
'        rs.update
'    end if    
'    rs.close
   
    dim next_item_no
    next_item_no = 1
    
    Set rs3=Server.CreateObject("ADODB.Recordset")  
    SQL = "select  max(item_no) as item_no from  item_cost  where elt_account_number = " & elt_account_number 
    
    rs3.Open SQL, eltConn, , , adCmdText	
    if not  rs3.eof  then 
        next_item_no=ConvertAnyValue(rs3("item_no"),"Integer",0)
        next_item_no=next_item_no+1
    end if 
    rs3.close   
    
    '// response.Write "----------------"&next_item_no
    
'   Set rs4=Server.CreateObject("ADODB.Recordset")  
'   SQL = "select  * from  item_cost  where elt_account_number = " & elt_account_number & "  and item_name= 'AF' and item_type='Air Freight' and item_desc='AIR FREIGHT'"
'   
'   rs4.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'   if  rs4.eof =true then  
'       rs4.AddNew
'	    rs4("elt_account_number")=elt_account_number
'	    rs4("item_no")=next_item_no
'	    rs4("item_name")="AF"
'	    rs4("item_type")="Air Freight"	
'	    rs4("item_desc")="AIR FREIGHT"
'	    rs4("account_expense")=nextAcctNo	   	   
'	    rs4.update
'	else
'	    next_item_no=rs4("item_no")
'   end if    
'   rs4.close
    
    Set rs2=Server.CreateObject("ADODB.Recordset")  
    SQL = "select * from user_profile where elt_account_number = " & elt_account_number
    
    rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
    If Not rs2.EOF AND Not rs2.BOF Then
        rs2("default_air_cost_item") = next_item_no
        rs2.Update
    End If
    rs2.close
    Set rs2=nothing   
    
    setDefaultAF = next_item_no
      
    '// response.Write SQL
    
end function 


function save_cost_item_and_bill_detail_trans(iType,import_export)
   '---getting agnet org account
	vAgentOrgAcct=0
	if vTotalHAWB=0 then	
		if vPPO_1="Y" or vPPO_2="Y" Then
			vAgentOrgAcct=vShipperAcct
		end if 	
		if vCOLL_1="Y" or vCOLL_2="Y" then	
			vAgentOrgAcct=vConsigneeAcct
		end if 
	end if 
	
	vProcessDT=NOW
	
	vTotalRealCost=checkBlank(request("txtTotalRealCost"),0)
	vRateRealCost=checkBlank(request("txtRateRealCost"),0)
		

	SQL= "delete from mb_cost_item where elt_account_number = " & elt_account_number _
	    & " and mb_no=N'" & vMAWB & "'"
	
	eltConn.Execute SQL
	
	if vTotalRealCost <> 0 then
		SQL = "INSERT INTO mb_cost_item (elt_account_number,mb_no,item_id,item_no,item_desc,ref_no,cost_amount,rate,lock_ap,Vendor_no)" _
		    & "values(" _
		    & elt_account_number & "," _
		    & "N'" & vMAWB & "'," _
		    & "1," & vDefaultFreightCostNo & "," _
		    & "N'" & vDefaultFreightCostDesc & "'," _
            &"''," & vTotalRealCost & "," _
            & vRateRealCost & ","
		if vLock_ap <> "Y" then
			vLock_ap= "N"
		end if
		SQL = SQL & "N'" & vLock_ap & "',"
		SQL = SQL & vAgentOrgAcct & ")"		
	    
		eltConn.Execute SQL, nRecords
	end if	
	
	if vLock_ap <> "Y" then
		SQL= "delete from bill_detail where elt_account_number = " & elt_account_number _
		    & " and mb_no=N'" & vMAWB & "'"
		
		eltConn.Execute SQL	
		if  vTotalRealCost<>0 then
			SQL= "INSERT INTO bill_detail (elt_account_number,mb_no,item_id,bill_number,item_name,item_no,item_expense_acct,item_amt,tran_date,vendor_number,iType,is_manual,import_export)"
			SQL=SQL&"values("
			SQL=SQL&elt_account_number&","
			SQL=SQL&"N'"&vMAWB&"',"
			SQL=SQL&"1,"
			SQL=SQL&"0,"
			SQL=SQL&"N'"&vDefaultFreightCostDesc &"',"
			SQL=SQL&vDefaultFreightCostNo &","				
			SQL=SQL&vDefaultAccountExpense &","
			SQL=SQL&vTotalRealCost &"," ' Expense Account will be set at the AP posting 			
			SQL=SQL&"N'"&vProcessDT&"',"
			SQL=SQL&vAgentOrgAcct&","
			SQL=SQL&"N'"&iType&"',"
			SQL=SQL&"'N',"
			SQL=SQL&"N'"&import_export&"')"
			
			eltConn.Execute SQL					
		end if		
	end if 

End function 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE: CHECK_SHOULD_INVOICE_QUEUED
'Purpose  of the procedure: The procedure is in charge of finding out whether the given HAWB should be
'create a entry into invoice queue or not.
'Tasks that are performed within:				    
'1.Check if the invoice entry should be created or not
'  For regular house airway bill it should be created no matter what, but for sub or master house it only
'  creates a invoice queue entry only when the house is set to create invoice queue entry.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function CHECK_SHOULD_INVOICE_QUEUED(hawb)
    dim rs,SQL
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select isnull(is_sub,'N') as is_sub,isnull(is_master,'N') as is_master," _
	    & "isnull(is_invoice_queued,'Y') as is_invoice_queued from hawb_master where elt_account_number = " _
	    & elt_account_number & " and is_dome='N' And mawb_num=N'" & vMAWB & "' And hawb_num=N'" & hawb & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then	
	    if rs("is_sub")="Y" OR  rs("is_master")="Y" then		 
			if  rs("is_invoice_queued") ="N" then
				CHECK_SHOULD_INVOICE_QUEUED=false
			else 
				CHECK_SHOULD_INVOICE_QUEUED=true
			end if 
		else 
			CHECK_SHOULD_INVOICE_QUEUED=true
		end if
	END IF 
	rs.close
	set rs=Nothing 
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEP_ARR_CODE
'Purpose  of the procedure: The procedure is in charge of retrieving the airport codes for departure
'and arrival
'Tasks that are performed within:									    
'1.find and store departure and arrival airport code in the variables
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub GET_DEP_ARR_CODE    
	SQL= "select Origin_Port_ID,Dest_Port_ID from mawb_number a where elt_account_number = " _
	    & elt_account_number & " and is_dome='N' And mawb_no=N'" & vMAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

	If Not rs.EOF Then
	    vDepCode=rs("Origin_Port_ID")
        vArrCode =rs("Dest_Port_ID")
	 
	END IF 
	rs.close
End Sub 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SALES_PERSONS_FROM_USERS
'Purpose  of the procedure: The procedure is in charge of retrieving the list of salse persons to be 
'used.
'Tasks that are performed within:									    
'1.retrieve sales person from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_SALES_PERSONS_FROM_USERS

    SQL= "select code from all_code where elt_account_number = " & elt_account_number & " and type=22 order by code"
    
    rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

    reDim aSRName(rs.RecordCount+1)
    SRIndex=0
	    do While Not rs.EOF
		    aSRName(SRIndex)=rs("code")	
		    rs.MoveNext
		    SRIndex=SRIndex+1
	    loop
	    rs.Close
	    
END SUB 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:EXECUTION_STRING_CHANGE
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:									    
'1.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub EXECUTION_STRING_CHANGE
    Dim txtPos
    txtPos = InStr(UCase(vExecute),"AS AGENT OF")
    If txtPos>0 Then
		If InStr(vExecute,"CARRIER") = 0 Then
			vExecute = Left(vExecute, txtPos) & Replace(vExecute, chr(13), ", CARRIER" & chr(13), txtPos + 1, 1)
		End If
    End If
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:RESET_WCOUNT
'Purpose  of the procedure: The procedure is in charge of resetting the weight charge count on the screen
'Tasks that are performed within:									    
'1.set wCount to be 0
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB RESET_WCOUNT
	wCount = 0
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:get_mawb_info
'Purpose  of the procedure: The procedure is in charge of getting data for a MAWB from DB through a ajax procedure
'Tasks that are performed within:									    
'1.Return a MAWB information in a string 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function  get_mawb_info( MAWB )
	if MAWB = "" then Exit function
%>
<!--  #INCLUDE VIRTUAL="/ASP/ajaxFunctions/mawb_number_info.inc" -->
<%
	get_mawb_info =  mawbInfo
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GETVEXECUTE
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GETVEXECUTE(vMAWB)
	Dim mInfo
	Dim mDepartureAirportCode,mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2,mDestAirport
	Dim mFlightDate1,mFlightDate2,IssuedBy,mServiceLevel,mFile
	
	if trim(vMAWB) = "" then
		vExecute=vExecutionDatePlace
		exit sub
	end if

	mInfo = get_mawb_info( vMAWB )	
	if isnull(mInfo) then
		exit sub
	else
	end if
	
	pos=InStr(mInfo,chr(10))
	mAirOrgNum=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirportCode=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mCarrierDesc=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mExportDate=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestCountry=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureState=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFile=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
    // Modified by Joon 6/20/2007 service level
    pos=InStr(mInfo,chr(10))
    mServiceLevel=Left(mInfo,pos-1)
    mInfo=Mid(mInfo,pos+1,1000)

	IssuedBy = vAgentInfo
	pos=Instr(IssuedBy,chr(10))
	If pos>0 Then
		IssuedBy=Left(IssuedBy,pos-1)
	End If
	
	If Not IsNull(vExecute) And Trim(vExecute) <> "" Then
		vExecute = "AS AGENT OF " & mCarrierDesc & ", CARRIER" & chr(10) & vExecutionDatePlace
	Else
		vExecute = IssuedBy & chr(10) & mExportDate & " " & vExecute
	End If
	aExecute=vExecute
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:SET_ITEM_WEIGHT_TOTAL_AND_DESC
'Purpose  of the procedure: The procedure is in charge of summing up and setting weight charge total 
'							information to the variables that will be displayed on the screen
'Tasks that are performed within:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB SET_ITEM_WEIGHT_TOTAL_AND_DESC
	vTotalPieces=0
	vTotalGrossWeight=0
	vTotalWeightCharge=0	
	for i=0 to NoItemWC-1
		vTotalPieces=vTotalPieces+aPiece(i)
		vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(i)
		vTotalWeightCharge=vTotalWeightCharge+aTotal(i)
	next
	vDesc1=Request("txtDesc1")
	vDesc2=Request("txtDesc2")
	vPrepaidOtherChargeAgent=0
	vCollectOtherChargeAgent=0
	vPrepaidOtherChargeCarrier=0
	vCollectOtherChargeCarrier=0
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:SET_DETAULT_OTHER_CHARGE_ITEM_LINE
'Purpose  of the procedure: The procedure is in charge of merging two lines of other charge descriptions to one 
'							when there are more than 5 lines due to the printing page limit.
'Tasks that are performed within:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB SET_DETAULT_OTHER_CHARGE_ITEM_LINE
	if oIndex="" then oIndex=2
	NoItemOC=oIndex	
	if NoItemOC>5 then
		for i=0 to NoItemOC-1 Step 2
			aOtherCharge(Fix(i/2))=aDesc(i) & " " & FormatNumber(aChargeAmt(i),2) & "  " & aDesc(i+1) & " " & FormatNumber(aChargeAmt(i+1),2)
		next
	else
		for i=0 to NoItemOC-1
			aOtherCharge(i)=aDesc(i) & " " & FormatNumber(aChargeAmt(i),2)
		next
	end if
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEFAULT_WEIGHT_SCALE
'Purpose  of the procedure: The procedure is in charge of finding out weight scale that the user uses
'                           from the user profile
'Tasks that are performed within:
'1)Set the first entry of aKgLb to be the one in user profile
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_DEFAULT_WEIGHT_SCALE
	SQL= "select uom from user_profile where elt_account_number = " & elt_account_number
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if not rs.EOF then
		vUOM=rs("uom")
		if vUOM="KG" then
			aKgLb(0)="K"
		else
			aKgLb(0)="L"
		end if
	end if
	rs.Close
END SUB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AGENT_GENERAL_INFORMAION
'Purpose  of the procedure: The procedure is in charge of finding out the address information of the agent 
'							in order to feed in to the screen
'Tasks that are performed within:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_AGENT_GENERAL_INFORMAION
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,agent_IATA_Code,country_code from agent where elt_account_number = " & elt_account_number
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		vAgentIATACode = rs("Agent_IATA_Code")		
		AgentName = rs("dba_name")
		vDefaultAgentName=AgentName
		AgentAddress=rs("business_address")
		AgentCity = rs("business_city")
		AgentState = rs("business_state")
		AgentZip = rs("business_zip")
		AgentCountry = rs("business_country")
		AgentPhone=rs("business_phone")
		AgentCountryCode = rs("country_code")
		vAgentInfo=AgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & "," & AgentCountry	
		If checkBlank(vShipperAcct,"") = "" Then
			vShipperAcct=elt_account_number
			vShipperInfo=AgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & "," & AgentCountry & chr(13) & AgentPhone
		End If
		'//////change by stanley on 6/18/2007    
		vDefaultAgentInfo=vAgentInfo
		vPlaceExecuted=AgentCity & "," & AgentState & " " & AgentZip & " " & AgentCountry
		If IsNull(vExecute) Or Trim(vExecute) = "" Or fBook = "yes" Then 
			vExecute=AgentName & chr(10) & "AS AGENT OF " & vIssuedBy & ", CARRIER "&chr(10) & Date & " " & vPlaceExecuted
		End If
		vSignature="FOR " & AgentName
		vExecutionDatePlace=Date & " " & vPlaceExecuted
		'// aShipperName(1)=AgentName
		'// aShipperInfo(1)=elt_account_number & "-" & AgentName & chr(10) & AgentAddress & chr(10) & AgentCity & "," & AgentState & " " & AgentZip & "," & AgentCountry & chr(10) & AgentPhone
		'// aShipperAcct(1)=elt_account_number	
	End If
	rs.Close
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_MAWB
'Purpose  of the procedure: The procedure is in charge of deleting the MAWB from DB when requested
'							
'Tasks that are performed within:
'1)Delete a MAWB from DB
'2)Delete all MAWB weight charge entry from DB
'3)Delete all MAWB other charge entry from DB
'4)Update all HAWBs MAWB information in the DB to be empty since the MAWB is deleted
'5)Reset the status of MAWB number to be usalbe ="N"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_MAWB( vMAWB )
	SQL= "select mawb_num from mawb_master where elt_account_number = " _
	    & elt_account_number & " and is_dome='N' and mawb_num=N'" & vMAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		rs.close
		SQL= "delete from mawb_master where elt_account_number = " & elt_account_number & " and is_dome='N' and mawb_num=N'" & vMAWB & "'"
		eltConn.Execute SQL
		SQL= "delete from mawb_weight_charge where elt_account_number = " & elt_account_number & " and mawb_num=N'" & vMAWB & "'"
		eltConn.Execute SQL
		SQL= "delete from mawb_other_charge where elt_account_number = " & elt_account_number & " and mawb_num=N'" & vMAWB & "'"
		eltConn.Execute SQL
		SQL= "update hawb_master set mawb_num = '' where elt_account_number = " & elt_account_number & " and is_dome='N' and mawb_num=N'" & vMAWB & "'"
		eltConn.Execute SQL
		SQL= "update mawb_number set status='B',used = 'N' where elt_account_number = " & elt_account_number & " and is_dome='N' and mawb_no=N'" & vMAWB & "'"
		eltConn.Execute SQL
	else
		rs.close
%>
<script type="text/jscript">    alert('Could not find the MAWB'); </script>
<%
	end if	
END SUB


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SUB_HAWB_INFO
'Purpose  of the procedure: The procedure is in charge of getting all the Sub Houses that belong to a
'							HAWB of type Master House in order to show them on the screen below the HAWB						
'Tasks that are performed within:
'1)Get all the sub houses that belong to one HAWB consolidated in the MAWB
'2)Sumup all the charge information from the HAWBs to show on the screen
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_SUB_HAWB_INFO(subToNo)
    DIM rs
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL="select a.is_master, a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_Name,a.Consignee_Name, "
	SQL=SQL & " b.tran_no,b.rate_class,b.no_pieces,b.gross_weight,b.adjusted_weight,b.kg_lb,b.dimension,b.chargeable_weight from hawb_master a LEFT OUTER JOIN hawb_weight_charge b "
	SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num =b.hawb_num) where "
	SQL=SQL & " (a.elt_account_number = " & elt_account_number & " or a.coloder_elt_acct=" & elt_account_number
	SQL=SQL & ") and isnull(a.is_sub,'N')='Y' and a.MAWB_NUM=N'" & vMAWB &"' and a.sub_to_no=N'" & subToNo& "' and a.is_dome='N' order by a.hawb_num,b.tran_no"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	sHsCount=0	
	Do While Not rs.EOF 
		If IsNull(rs("tran_no")) = False Then
			tran_no = CInt(rs("tran_no"))
		Else
			tran_no=0
		end if
		if tran_no>0 then
			If IsNull(rs("no_pieces")) = False Then
					sHsPCS(sHsCount) = cLng(rs("no_pieces"))
			End If
			If IsNull(rs("gross_weight")) = False Then
				sHsGW(sHsCount) = Cdbl(rs("gross_weight"))
			Else
				sHsGW(sHsCount)=0
			end if
			If IsNull(rs("adjusted_weight")) = False Then
				sHsAW(sHsCount) = Cdbl(rs("adjusted_weight"))
			Else
				sHsAW(sHsCount)=0
			end if
			If IsNull(rs("dimension")) = False Then
				sHsDW(sHsCount) = Cdbl(rs("dimension"))
			End If	
			If IsNull(rs("Chargeable_Weight")) = False Then
				sHsCW(sHsCount) = Cdbl(rs("Chargeable_Weight"))
			Else
				sHsCW(sHsCount)=0
			end if
			tKgLb=rs("kg_lb")
			if not tKgLb = aKgLb(0) then			
				if aKgLb(0)="K" then
					sHsGW(sHsCount)=FormatNumber(sHsGW(sHsCount)/2.20462262,2)
					sHsAW(sHsCount)=FormatNumber(sHsAW(sHsCount)/2.20462262,2)
					sHsCW(sHsCount)=FormatNumber(sHsCW(sHsCount)/2.20462262,2)
					sHsDW(sHsCount)=FormatNumber(sHsDW(sHsCount)/2.20462262,2)
				else
					sHsGW(sHsCount)=FormatNumber(sHsGW(sHsCount)*2.20462262,2)
					sHsAW(sHsCount)=FormatNumber(sHsAW(sHsCount)*2.20462262,2)
					sHsCW(sHsCount)=FormatNumber(sHsCW(sHsCount)*2.20462262,2)
					sHsDW(sHsCount)=FormatNumber(sHsDW(sHsCount)*2.20462262,2)
				end if
			end if
		end if
		if tran_no=0 or tran_no=1 then
			If IsNull(rs("hawb_num")) = False Then
				sHsHAWB(sHsCount)=rs("hawb_num")
				sHdelELTAcct(sHsCount)=rs("elt_account_number")
			End If
			tmpAcct=cLng(rs("elt_account_number"))			
			if Not tmpAcct=elt_account_number then
				xx=0
				Do while xx<coIndex
					if aColodeeAcct(xx)=tmpAcct then
						sHsCOLO(sHsCount)=aColodeeName(xx)
						exit do
					end if
					xx=xx+1
				loop
			end if
			If IsNull(rs("agent_name")) = False Then
				sHsAgent(sHsCount) = rs("agent_name")
				pos=Instr(sHsAgent(sHsCount),chr(10))
				if pos>0 then sHsAgent(sHsCount)=Mid(sHsAgent(sHsCount),1,pos-1)
			End If	
			sHsShipper(sHsCount) = rs("Shipper_name")
			sHsConsignee(sHsCount) = rs("Consignee_name")
		end if
		sHsTotalPCS=sHsTotalPCS+sHsPCS(sHsCount)
		sHsTotalGW=sHsTotalGW+cDbl(sHsGW(sHsCount))
		sHsTotalAW=sHsTotalAW+cDbl(sHsAW(sHsCount))
		sHsTotalDW=sHsTotalDW+cDbl(sHsDW(sHsCount))
		sHsTotalCW=sHsTotalCW+cDbl(sHsCW(sHsCount))		
		sHsCount=sHsCount+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing
END SUB


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_MAWB_TABLE
'Purpose  of the procedure: The procedure is in charge of creating/updating information of MAWB to the DB
'							HAWB of type Master House in order to show them on the screen below the HAWB						
'Tasks that are performed within:
'1)Create/Update all the field into DB
'2)Remove and resave all the weight charge/ Other charge items from screen to DB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB UPDATE_MAWB_TABLE
        
		DIM rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		CALL INVOICE_QUEUE_REFRESH( vMAWB )
		CALL MAWB_INVOICE_QUEUE( vMAWB )	
		SQL= "select * from mawb_master where elt_account_number = " _
		    & elt_account_number & " and is_dome='N' and MAWB_NUM = N'" & vMAWB & "'"
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If rs.EOF=true Then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("MAWB_NUM")=vMAWB
			rs("date_executed")=Now
			'-----------------------------------------------------------------for the new record
			rs("CreatedBy")=session_user_lname	
			rs("CreatedDate")=Now
			rs("SalesPerson")=vSalesPerson	
			'-----------------------------------------------------------------------------------
			rs("is_dome")="N"
		End If		
		rs("DEP_AIRPORT_CODE") = vOriginPortID
		rs("master_agent")=vConsigneeAcct
		rs("airline_vendor_num")=vAirOrgNum
		rs("Shipper_Name") = vShipperName
		rs("Shipper_Info") = vShipperInfo
		rs("Shipper_Account_Number") = vShipperAcct
		rs("ff_shipper_acct") = vFFShipperAcct
		rs("Consignee_Name") = vConsigneeName
		rs("Consignee_Info") = vConsigneeInfo
		rs("Consignee_acct_num") = vConsigneeAcct
		rs("ff_consignee_acct") = vFFConsigneeAcct
		rs("Issue_Carrier_Agent") = vAgentInfo
		rs("Agent_IATA_Code") = vAgentIATACode
		rs("Notify_No") = vNotifyAcct
		rs("Account_No") = vAgentAcct 
		rs("Departure_Airport") = vDepartureAirport
		rs("To_1") = vTo
		if vBy = "Select One" then vBy = ""
		rs("By_1") = vBy
		rs("To_2") = vTo1
		rs("By_2") = vBy1
		rs("To_3") = vTo2
		rs("By_3") = vBy2
		rs("Dest_Airport") = vDestAirport
		rs("Flight_Date_1") = vFlightDate1
		rs("Flight_Date_2") = vFlightDate2
		rs("IssuedBy")=vIssuedBy
		rs("Account_Info") = vAccountInfo
		rs("Currency") = vCurrency
		rs("Charge_Code") = vChargeCode
		rs("PPO_1") = vPPO_1
		rs("COLL_1") = vCOLL_1
		rs("PPO_2") = vPPO_2
		rs("COLL_2") = vCOLL_2
		rs("Declared_Value_Carriage") = vDeclaredValueCarriage
		rs("Declared_Value_Customs")= vDeclaredValueCustoms
		rs("Insurance_AMT")=vInsuranceAMT
		rs("Handling_Info")=vHandlingInfo
		rs("dest_country")=vDestCountry
		rs("SCI")=vSCI
		rs("total_pieces")=vTotalPieces
		rs("total_gross_weight")=vTotalGrossWeight
		rs("total_chargeable_weight")=vTotalChgWT
		rs("total_weight_charge_hawb")=vTotalWeightCharge
		rs("desc1")=vDesc1
		rs("desc2")=vDesc2
		rs("Weight_Scale")=vWeightScale
		rs("Prepaid_Weight_Charge") = vPrepaidWeightCharge
		rs("Collect_Weight_Charge") = vCollectWeightCharge
		rs("Prepaid_Due_Agent") = vPrepaidOtherChargeAgent
		rs("Collect_Due_Agent") = vCollectOtherChargeAgent
		rs("Prepaid_Due_Carrier") = vPrepaidOtherChargeCarrier
		rs("Collect_Due_Carrier") = vCollectOtherChargeCarrier
		rs("Prepaid_Total")=vPrepaidTotal
		rs("Collect_Total")=vCollectTotal
		rs("Prepaid_Valuation_Charge")=vPrepaidValuationCharge
		rs("Collect_Valuation_Charge")=vCollectValuationCharge
		rs("Prepaid_Tax")=vPrepaidTax
		rs("Collect_Tax")=vCollectTax
		rs("Currency_Conv_Rate")=vConversionRate
		rs("CC_Charge_Dest_Rate")=vCCCharge
		rs("Charge_at_Dest")=vChargeDestination
		rs("Total_Collect_Charge")=vFinalCollect	
		rs("show_weight_charge_shipper")="Y"
		rs("show_weight_charge_consignee")="Y"
		rs("show_prepaid_other_charge_shipper")="Y"
		rs("show_collect_other_charge_shipper")="Y"
		rs("show_prepaid_other_charge_consignee")="Y"
		rs("show_collect_other_charge_consignee")="Y"		
		rs("Signature")=vSignature
		rs("Date_Last_Modified")=Now
		rs("Execution")=vExecute
		rs("SalesPerson")=	vSalesPerson	
		rs("ModifiedBy")= session_user_lname
		rs("ModifiedDate")=Now	
		rs("reference_number") = vReferenceNumber
		'---------------------------------------------------here we save realcost
		rs("Total_Freight_Cost") = vTotalRealCost
        rs("aes_xtn")=vAES
        rs("sed_stmt")=vSEDStmt
        
		rs.Update
		rs.Close	
		
		SQL= "select used from mawb_number where elt_account_number = " & elt_account_number _
		    & " and is_dome='N' and MAWB_No=N'" & vMAWB & "'"
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF Then
			rs("used")="Y"
			rs.Update
		End If
		rs.Close
		SQL= "delete from mawb_weight_charge where elt_account_number = " & elt_account_number _
		    & " and mawb_num=N'" & vMAWB & "'"
		
		eltConn.Execute SQL
		for i=0 to NoItemWC-1
			SQL= "select * from mawb_weight_charge where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' and tran_no=" & i+1
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("mawb_num")=vMAWB
			rs("tran_no")=i+1
			rs("no_pieces")=aPiece(i)
			rs("gross_weight")=Round(aGrossWeight(i),2)
			rs("kg_lb")=aKgLb(i)
			rs("rate_class")=aRateClass(i)
			rs("commodity_item_no")=aItemNo(i)
			rs("chargeable_weight")=Round(aChargeableWeight(i),0)
			rs("rate_charge")=aRateCharge(i)
			rs("total_charge")=Round(aTotal(i),2)		
			rs.Update
			rs.Close
		next
			
		SQL= "delete from mawb_other_charge where elt_account_number = " _
		    & elt_account_number & " and mawb_num=N'" & vMAWB & "'"
		
		eltConn.Execute SQL
		for i=0 to NoItemOC-1
			SQL= "select * from mawb_other_charge where elt_account_number = " _
			    & elt_account_number & " and mawb_num=N'" & vMAWB & "' and tran_no=" & i+1
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("mawb_num")=vMAWB
			rs("tran_no")=i+1
			rs("coll_prepaid")=aCollectPrepaid(i)
			rs("carrier_agent")=aCarrierAgent(i)
			rs("charge_code")=aChargeCode(i)
			rs("charge_desc")=aDesc(i)
			rs("amt_mawb")=aChargeAmt(i)
			rs.Update
			rs.Close
		next
		Set rs = nothing
	 
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_DEFAULT_SALES_PERSON_FROM_DB
'Purpose  of the procedure: The procedure is in charge of getting a Default Sales person that will be 
'filled in the screen
'Tasks that are performed within:									    
'1.Retrieve the Default sales person for the organization
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_DEFAULT_SALES_PERSON_FROM_DB
    On Error Resume Next:
    if isnull(vShipperAcct) or vShipperAcct = 0 then
        vSalesPerson ="" 
    else 
        SQL= "select SalesPerson from organization where elt_account_number = " _
            & elt_account_number & " and org_account_number = " & vShipperAcct
        
	    rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    Set rs.activeConnection = Nothing
        if not rs.EOF then	
            vSalesPerson = rs("SalesPerson")
        else vSalesPerson ="" 
        end if   
        rs.close
    end if 
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_MAWB_INFO_FROM_SCREEN
'Purpose  of the procedure: The procedure is in charge of getting all the MAWB information from the screen
'Tasks that are performed within:									    
'1.Retrieve all the information from the screen and store them into variables
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_MAWB_INFO_FROM_SCREEN
	vMAWB=Request("hmawb_num")
	vAirOrgNum=Request("hAirOrgNum")
	if vAirOrgNum="" then vAirOrgNum=0
	vDefaultAgentName=Request("hDefaultAgentName")
	vDefaultAgentInfo=Request("hDefaultAgentInfo")
	qShipperName=Request("txtShipperName")
	vShipperInfo=Trim(Request("txtShipperInfo"))
    vSalesPerson=Request("lstSalesRP")
    if vSalesPerson = "none" then
       Call GET_DEFAULT_SALES_PERSON_FROM_DB
    end if 	
	pos=0
	pos=instr(vShipperInfo,chr(13))
	if pos>0 then
		vShipperName=Mid(vShipperInfo,1,pos-1)
	else
		vShipperName=vShipperInfo
	end if
	vShipperAcct=Request("hShipperAcct")
	if not vShipperAcct="" then 
		vShipperAcct=cLng(vShipperAcct)
	else
		vShipperAcct=0
	end if

	vFFShipperAcct=Request.Form("txtShipperAcct").Item(1)
	qConsigneeName=Request("txtConsigneeName")
	vConsigneeInfo=Request("txtConsigneeInfo")
	pos=0
	pos=instr(vConsigneeInfo,chr(13))
	if pos>0 then
		vConsigneeName=Mid(vConsigneeInfo,1,pos-1)
	else
		vConsigneeName=vConsigneeInfo
	end if
	vNotify=Request("lstNotifyName")
	qNotifyName=Request("txtNotify")
	vConsigneeAcct=Request("hConsigneeAcct")
	if not vConsigneeAcct="" then
		vConsigneeAcct=cLng(vConsigneeAcct)
	else
		vConsigneeAcct=0
	end if
	vFFConsigneeAcct=Request("txtConsigneeAcct")	
	vNotifyAcct=Request("hNotifyAcct")
	vAgentInfo=Request("txtAgentInfo")
	vAgentIATACode=Request("txtAgentIATACode")
	vAgentAcct=Request("txtAgentAcct")
	vOriginPortID=Request("hOriginPortID")
	vDepartureAirport = Request("txtDepartureAirport")
	vAccountInfo=Request("txtBillToInfo")
	vTo=Request("txtTo")
	vBy=Request("txtBy")
	vTo1=Request("txtTo1")
	vBy1=Request("txtBy1")
	vTo2=Request("txtTo2")
	vBy2=Request("txtBy2")
	vDestAirport=Request("txtDestAirport")
	vFlightDate1=Request("txtFlightDate1")
	vFlightDate2=Request("txtFlightDate2")
	vIssuedBy=Request("txtIssuedBy")
	vCurrency=Request("txtCurrency")
	vChargeCode=Request("txtChargeCode")
	vChargeCode=Request("txtChargeCode")	
	vPPO_1 = Request("cPPO1")
	vCOLL_1 = Request("cCOLL1")
	vPPO_2 = Request("cPPO2")
	vCOLL_2 = Request("cCOLL2")
	vDeclaredValueCarriage=Request("txtDeclaredValueCarriage")	
	vDeclaredValueCustoms=Request("txtDeclaredValueCustoms")
	vInsuranceAMT=Request("txtInsuranceAMT")	
	vHandlingInfo=Request("txtHandlingInfo")
	vDestCountry=Request("txtDestCountry")
    'Response.Write "vDestCountry:" &vDestCountry
	vSCI=Request("txtSCI")
	vSignature=Request("txtSignature")
	vExecute=Request("txtExecute")
	vReferenceNumber = Request("txtReferenceNumber")
	vAES = checkBlank(Request.Form.Item("txtAES"),"")
    If vAES = "" Then
	    vSEDStmt = Request.Form.Item("txtSEDStatement")
	End If
	
	vSONum = Request.Form("hSONum")
	vPONum = Request.Form("hPONum")
	
END SUB


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GetFileNo
'Purpose  of the procedure: The procedure is in charge of file number that is assigned to this MAWB from DB
'Tasks that are performed within:									    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub GetFileNo()
    Dim tempNo,pos
    tempNo = ""
	SQL= "select file# from mawb_number where elt_account_number = " & elt_account_number & " and is_dome='N' and mawb_no=N'" & vMAWB & "'"	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		tempNo = rs("file#").value	
	End if
	rs.Close
	vFileNo = tempNo
    
    If IsNull(vAccountInfo) Or Trim(vAccountInfo) = "" Then
        vAccountInfo = "FILE# " & tempNo & chr(13) & vAccountInfo
    Else      
	    vAccountInfo = Replace(vAccountInfo,chr(10),"")
	    vAccountInfo = Trim(vAccountInfo)
        Do While InStr(vAccountInfo,chr(13)) = 1
	        vAccountInfo = Replace(vAccountInfo,chr(13),"",1,1)	       
	    Loop	    
	    Do While InStrRev(vAccountInfo,chr(13)) = Len(vAccountInfo) And Trim(vAccountInfo) <> ""
	        vAccountInfo = Replace(vAccountInfo,chr(13),"",Len(vAccountInfo),1)	        
	    Loop	    
	    If Instr(vAccountInfo, tempNo) > 0 And Instr(UCase(vAccountInfo), "FILE#") = 0 Then
	        vAccountInfo =  Replace(vAccountInfo,tempNo, "FILE# " & tempNo)
	    Elseif Instr(vAccountInfo, tempNo) = 0 Then
	        vAccountInfo = "FILE# " & tempNo & chr(13) & vAccountInfo
	    End If
	End If
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GetFileNumber
'Purpose  of the procedure: The procedure is in charge of file number that is assigned to this MAWB from DB
'Tasks that are performed within:									    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Function GetFileNumber(mawb_num)
    Dim resVal,rs,SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    SQL = "SELECT File# from mawb_number where elt_account_number=" & elt_account_number _
        & " and is_dome='N' AND mawb_no=N'" & mawb_num & "'"
    
    resVal = ""    
    Set rs = eltConn.execute (SQL)

    If Not rs.EOF And Not rs.BOF Then
        resVal = rs("File#").value
    End If        
    GetFileNumber = resVal
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:IsModified
'Purpose  of the procedure: The procedure is in charge of checking out where the document has been modifed 
'since last modified date
'Tasks that are performed within:									    
'1.check if the document is modifed if it is it returns true, and returns false otherwise
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Function IsModified()
    Dim resVal
    resVal = false
    SQL = "select CreatedDate,ModifiedDate from mawb_master where elt_account_number = " _
        & elt_account_number & " and is_dome='N' and mawb_num = N'" & vMAWB & "'"
    
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		If rs("CreatedDate").value <> rs("ModifiedDate").value Then
		    resVal = true
		End If
	End If
    IsModified = resVal
    rs.close()
End Function
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_MAWB_INFO_FROM_TABLE
'Purpose  of the procedure: The procedure is in charge of retriving MAWB information from DB
'Tasks that are performed within:									    
'1.Retreive MAWB general information from DB
'2.Retrieve MAWB other charges from DB
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_MAWB_INFO_FROM_TABLE( vMAWB )
	DIM lAccountInfo
	lAccountInfo = ""		
	vOriginPortID=Request("hOriginPortID")
	vDepartureAirport = Request("txtDepartureAirport")
	vTo=Request("txtTo")
	vBy=Request("txtBy")
	vTo1=Request("txtTo1")
	vBy1=Request("txtBy1")
	vTo2=Request("txtTo2")
	vBy2=Request("txtBy2")
	vAccountInfo=Request("txtBillToInfo")
	vDestAirport=Request("txtDestAirport")
	vFlightDate1=Request("txtFlightDate1")
	vFlightDate2=Request("txtFlightDate2")
	vDestCountry=Request("txtDestCountry")
	vIssuedBy=Request("txtIssuedBy")
	vExecute=Request("htxtExecute")
	vDesc2="CONSOLIDATION AS PER" & chr(13) & "MANIFEST" & chr(13) & "FREIGHT PREPAID"
	SQL= "select * from mawb_master where elt_account_number = " _
	    & elt_account_number & " and is_dome='N' and MAWB_NUM=N'" & vMAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing	
	If Not rs.EOF Then		
		vSalesPerson=rs("SalesPerson")     		
		if(isnull(vSalesPerson))then 
			vSalesPerson=""
		end if 
		vAirOrgNum=rs("airline_vendor_num")
		vShipperAcct = rs("Shipper_Account_Number")
		vShipperName = rs("Shipper_Name")		
		vFFShipperAcct = rs("ff_shipper_acct")
		vShipperInfo = rs("Shipper_Info")
		vConsigneeInfo = rs("Consignee_Info")
		vConsigneeName = rs("Consignee_Name")
		vConsigneeAcct = clng(rs("Consignee_acct_num"))
		vFFConsigneeAcct = rs("ff_Consignee_acct")
		vAgentInfo = rs("Issue_Carrier_Agent")
		vAgentIATACode = rs("Agent_IATA_Code")
		vNotifyAcct = rs("Notify_No")
		vAgentAcct = rs("Account_No")
		vDepartureAirport = rs("Departure_Airport")
		vOriginPortID = rs("DEP_AIRPORT_CODE")			
		vTo = rs("to_1")
		vBy = rs("by_1")
		if vBy = "Select One" then vBy = ""
			vTo1 = rs("to_2")
			vBy1 = rs("by_2")
			vTo2 = rs("to_3")
			vBy2 = rs("by_2")
			vCurrency = rs("Currency")
			vDestAirport = rs("Dest_Airport")
			vFlightDate1 = rs("Flight_Date_1")
			vFlightDate2 = rs("Flight_Date_2")
			vIssuedBy = rs("IssuedBy")
			lAccountInfo = rs("Account_Info")
			vChargeCode = rs("Charge_Code")
			vPPO_1 = rs("PPO_1")
			vCOLL_1 = rs("COLL_1")
			vPPO_2 = rs("PPO_2")
			vCOLL_2 = rs("COLL_2")
			vDeclaredValueCarriage = rs("Declared_Value_Carriage")
			vDeclaredValueCustoms = rs("Declared_Value_Customs")
			vInsuranceAMT = rs("Insurance_AMT")
			vHandlingInfo = rs("Handling_Info")
			vDestCountry=rs("dest_country")
			vTotalPieces=rs("total_pieces")
			vTotalGrossWeight=rs("total_gross_weight")
			vTotalWeightCharge=rs("total_weight_charge_hawb")
			vDesc1=rs("desc1")
			vDesc2=rs("desc2")
			vPrepaidWeightCharge=rs("Prepaid_Weight_Charge")
			if vPrepaidWeightCharge="" then
				vPrepaidWeightCharge=cdbl(vPrepaidWeightCharge)
			else
				vPrepaidWeightCharge=0
			end if
			vCollectWeightCharge=rs("Collect_Weight_Charge")
			if vCollectWeightCharge="" then
				vCollectWeightCharge=cdbl(vCollectWeightCharge)
			else
				vCollectWeightCharge=0
			end if

			vAES = checkBlank(rs("aes_xtn"),"")
            vSEDStmt = checkBlank(rs("sed_stmt").value,"")
            
            If vAES = "" And vSEDStmt = "" Then
                vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
            End If
        
			vPrepaidOtherChargeAgent=cdbl(rs("Prepaid_Due_Agent"))
			vCollectOtherChargeAgent=cdbl(rs("Collect_Due_Agent"))
			vPrepaidOtherChargeCarrier=cdbl(rs("Prepaid_Due_Carrier"))
			vCollectOtherChargeCarrier=cdbl(rs("Collect_Due_Carrier"))
			vPrepaidTotal=cdbl(rs("Prepaid_Total"))
			vCollectTotal=cdbl(rs("Collect_Total"))
			vPrepaidValuationCharge=cdbl(rs("Prepaid_Valuation_Charge"))
			vCollectValuationCharge=cdbl(rs("Collect_Valuation_Charge"))
			vPrepaidTax=cdbl(rs("Prepaid_Tax"))
			vCollectTax=cdbl(rs("Collect_Tax"))
			vConversionRate=cdbl(rs("Currency_Conv_Rate"))
			vCCCharge=rs("CC_Charge_Dest_Rate")
			vChargeDestination=cdbl(rs("Charge_at_Dest"))
			vFinalCollect=cdbl(rs("Total_Collect_Charge"))
			vShowWeightChargeShipper=rs("show_weight_charge_shipper")
			vShowWeightChargeConsignee=rs("show_weight_charge_consignee")
			vShowPrepaidOtherChargeShipper=rs("show_prepaid_other_charge_shipper")
			vShowCollectOtherChargeShipper=rs("show_collect_other_charge_shipper")
			vShowPrepaidOtherChargeConsignee=rs("show_prepaid_other_charge_consignee")
			vShowCollectOtherChargeConsignee=rs("show_collect_other_charge_consignee")
			vSCI = rs("SCI")
			vSignature = rs("Signature")
			vExecute=rs("execution")
			aExecute=vExecute
					'///1111111111111111111111111111111111111111111111
			vReferenceNumber = rs("reference_number").value
		else
			NewMAWB="Y"
			vPPO_1="Y"
			vDesc2=vDesc2 & chr(10) & ""
			vPPO_2="Y"
			vDeclaredValueCarriage="NVD"
			vDeclaredValueCustoms="NCV"
			vInsuranceAMT="XXX"
			vShowWeightChargeShipper="Y"
			vShowWeightChargeConsignee="Y"
			vShowPrepaidOtherChargeShipper="Y"
			vShowCollectOtherChargeShipper="Y"
			vShowPrepaidOtherChargeConsignee="Y"
			vShowCollectOtherChargeConsignee="Y"
		end if
		rs.Close	
		if Not NewMAWB="Y" then
			'// SQL= "select * from mawb_other_charge where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "' order by tran_no"
			'// to show system charge items default, change left join to right join in the second part of union
            SQL= "(select a.tran_no,a.coll_prepaid, a.carrier_agent, a.charge_code, a.charge_desc, a.amt_mawb " _
                & "from mawb_other_charge a left outer join item_charge b " _
                & "on (a.elt_account_number=b.elt_account_number and a.charge_code=b.item_no) " _
                & "where isnull(b.item_def,'Custom')='Custom' and a.elt_account_number = " _
                & elt_account_number & " and a.mawb_num=N'" & vMAWB _
                & "') union (select isnull(a.tran_no,0),isnull(a.coll_prepaid,'') as coll_prepaid," _
                & "isnull(a.carrier_agent,'') as carrier_agent,b.item_no as charge_code, b.item_desc as charge_desc," _
                & "isnull(a.amt_mawb,0) as amt_mawb from " _
                & "(select * from mawb_other_charge where mawb_num=N'" & vMAWB _
                & "') a left outer join item_charge b " _
                & "on (a.elt_account_number=b.elt_account_number and a.charge_code=b.item_no) " _ 
                & "where b.elt_account_number=" & elt_account_number & " and isnull(b.item_def,'Custom')='System') order by tran_no"
            
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			oIndex=0
			Do while Not rs.EOF
				aCollectPrepaid(oIndex)=rs("coll_prepaid")
				aCarrierAgent(oIndex)=rs("carrier_agent")
				aChargeCode(oIndex)=rs("charge_code")
				aDesc(oIndex)=rs("charge_desc")
				aChargeAmt(oIndex)=rs("amt_mawb")
				rs.MoveNext
				oIndex=oIndex+1
			Loop
			rs.Close
		else
			vAccountInfo = ""
			SQL= "select '' as coll_prepaid,'' as carrier_agent,item_no,item_desc,0 as amt_mawb from " _
            & "item_charge where elt_account_number=" & elt_account_number _
            & " and isnull(item_def,'Custom')='System' order by item_no"
            
            rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
    		
		    oIndex=0
		    Do while Not rs.EOF
			    aCollectPrepaid(oIndex)=rs("coll_prepaid")
			    aCarrierAgent(oIndex)=rs("carrier_agent")
			    aChargeCode(oIndex)=rs("item_no")
			    aDesc(oIndex)=rs("item_desc")
			    aChargeAmt(oIndex)=rs("amt_mawb")
			    oIndex = oIndex + 1
			    rs.MoveNext
		    Loop
		    rs.Close
		    
		    vSEDStmt = GetSQLResult("SELECT sed_statement FROM user_profile WHERE elt_account_number=" & elt_account_number, Null)
		    '// If vDeclaredValueCustoms = "NCV" Or ConvertAnyValue(vDeclaredValueCustoms,"Long","0")<2500 Then
            '// End If
            
			Exit Sub
		end if		
		If vMawb = "" Then
			vAccountInfo = ""
		Else
			If Not lAccountInfo = ""  Then
			vAccountInfo = lAccountInfo
		End If
	End If
	
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:ADD_HAWB_INFO
'Purpose  of the procedure: The procedure is in charge of adding a HAWB to the MAWB
'Tasks that are performed within:									    
'1.Set booking information to the HAWB 
'2.If the HAWB is a Master House, change all the booking information portion of the sub hosues as well
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB ADD_HAWB_INFO
	AddHAWBNo=Request.QueryString("AddHAWBNo")
	vAddELTAcct=Request.QueryString("AddELTAcct")
	dim is_master_house	
	CALL CHECK_INVOICE_STATUS_HAWB(	AddHAWBNo,vAddELTAcct )	
	SQL= "select * from hawb_master where elt_account_number = " & vAddELTACCT & " and is_dome='N' and HAWB_NUM=N'" & addHAWBNo & "'"
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs.EOF Then
		rs("MAWB_NUM")=vMAWB
		rs("Departure_Airport") = vDepartureAirport
		rs("To_1") = vTo
		if vBy = "Select One" then vBy = ""			
		rs("By_1") = vBy
		rs("To_2") = vTo1
		rs("By_2") = vBy1
		rs("To_3") = vTo2
		rs("By_3") = vBy2
		rs("Dest_Airport") = vDestAirport
		rs("Flight_Date_1") = vFlightDate1
		rs("Flight_Date_2") = vFlightDate2
		is_master_house=checkBlank(rs("is_master"),"N")
		rs.Update			
	end if
	rs.Close		
	if is_master_house="Y" then
			UPDATE_ALL_SUB_HOUSE_INFO vAddELTACCT,addHAWBNo,"N"
	end if			
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_HAWB_INFO
'Purpose  of the procedure: The procedure is in charge of deleting a HAWB from the MAWB
'Tasks that are performed within:									    
'1.Set booking information to be empty
'2.If the HAWB is a Master House, change all the booking information portion of the sub hosues as well
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_HAWB_INFO
		dHAWB=Request("dHAWB")
		vDelELTAcct=Request.QueryString("delELTAcct")
		dim is_master_house
		CALL CHECK_INVOICE_STATUS_HAWB(	dHAWB,vDelELTAcct )
		SQL= "select * from hawb_master where elt_account_number = " & vDelELTAcct & " and is_dome='N' and HAWB_NUM=N'" & dHAWB & "'"
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF Then
			is_master_house=checkBlank(rs("is_master"),"N")
			rs("MAWB_NUM")=""
			rs("Departure_Airport") = ""
			rs("To_1") = ""
			rs("By_1") = ""
			rs("To_2") = ""
			rs("By_2") = ""
			rs("To_3") = ""
			rs("By_3") = ""
			rs("Dest_Airport") = ""
			rs("Flight_Date_1") = ""
			rs("Flight_Date_2") = ""
			rs.Update
		end if
		rs.Close		
		if is_master_house="Y" then
				UPDATE_ALL_SUB_HOUSE_INFO vDelELTAcct,dHAWB,"Y"
		end if 
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_ITEM_WEIGHT_CHARGE_INFO_SCREEN
'Purpose  of the procedure: The procedure is in charge of getting weight charge items from screen
'Tasks that are performed within:									    
'1.Get all the item charges from screen and save them to the varialbes 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_ITEM_WEIGHT_CHARGE_INFO_SCREEN
	NoItemWC=Request("hNoItemWC")
	if NoItemWC="" then NoItemWC=0
		vTotalChgWT=0
	for i=0 to NoItemWC-1
		aPiece(i)=Request("txtPiece" & i)
		if aPiece(i)="" then aPiece(i)=0
		aGrossWeight(i) = ConvertAnyValue(Request("txtGrossWeight" & i), "Integer", 0)
		if aGrossWeight(i)="" then aGrossWeight(i)=0
		aKgLb(i)=Request("lstKgLb" & i)
		aRateClass(i)=Request("txtRateClass" & i)
		aItemNo(i)=Request("txtItemNo" & i)
		aChargeableWeight(i)=Request("txtChargeableWeight" & i)
		if aChargeableWeight(i)="" then aChargeableWeight(i)=0
		vTotalChgWT=vTotalChgWT+cDbl(aChargeableWeight(i))
		aRateCharge(i)=Request("txtRateCharge" & i)		
		if aRateCharge(i)="" then aRateCharge(i)=0
		aTotal(i)=Request("txtTotal" & i)		
		if aTotal(i)="" then aTotal(i)=0
	next	
	vWeightScale = aKgLb(0)
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_ITEM_OTHER_CHARGE_INFO_SCREEN
'Purpose  of the procedure: The procedure is in charge of getting other charge items from screen
'Tasks that are performed within:									    
'1.Get all the other charges from screen and save them to the varialbes 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_ITEM_OTHER_CHARGE_INFO_SCREEN
	NoItemOC=Request("hNoItemOC")
	if NoItemOC="" then NoItemOC=0
	for i=0 to NoItemOC-1
		aCarrierAgent(i)=Request("lstCarrierAgent" & i)
		aCollectPrepaid(i)=Request("lstCollectPrepaid" & i)
		if aCollectPrepaid(i)="P" then
			vPPO_2="Y"
		end if
		if aCollectPrepaid(i)="C" then
			vCOLL_2 ="Y"
		end if
		ChargeItemInfo=Request("lstChargeCode" & i)
		pos=0
		pos=Instr(ChargeItemInfo,"-")
		if pos>0 then
			aChargeCode(i)=cInt(left(ChargeItemInfo,pos-1))
			aDesc(i)=Mid(ChargeItemInfo,pos+1,2000)
			pos=0
			pos=Instr(aDesc(i),"-")
			if (pos > 0) then
				aDesc(i)=LTRIM(Mid(aDesc(i),1,pos-1))
			end if
		end if		
		aChargeAmt(i)=Request("txtChargeAmt" & i)
		if aChargeAmt(i)="" then aChargeAmt(i)=0	
	next
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:ADJUST_WEIGHT_SUB
'Purpose  of the procedure: The procedure is in charge of fixing adjustable weight portion of the
'                            consolidated HAWBs on the screen                          
'Tasks that are performed within:									    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB ADJUST_WEIGHT_SUB
	Dim tHAWB,tAW,tRateClass,tmpTran_no,masterWeightScale
	
	masterWeightScale = GetSQLResult("select Kg_Lb from mawb_weight_charge where elt_Account_number=" & elt_account_number & " AND mawb_num=N'" & vMAWB & "'", Null)
	NoHAWB=Request.QueryString("AdjustItemNo")	
	
	for k=0 to NoHAWB-1
		if not Request("txtsHAWB" & k)="" then
			tHAWB=Request("txtsHAWB" & k)
		end if	
		Call Check_Invoice_status_HAWB(	tHAWB, elt_account_number )	
		if not Request("txtsAW" & k)="" then
			tAW=(Request("txtsAW" & k))				
		else
			tAW=0
		end if			
		if not Request("txtsRateClass" & k)="" then
			tRateClass=Request("txtsRateClass" & k)
		else
			tRateClass=""
		end if		
		if not Request("txtWeightTran" & k)="" then
			tmpTran_no=Request("txtWeightTran" & k)
		else
			tmpTran_no=""
		end if					
		IsCOLO=""
		IsCOLO=Request("txtsCOLO" & k)		
		if IsCOLO="" then
			SQL= "select * from hawb_weight_charge where elt_account_number = " & elt_account_number & _
			" And HAWB_NUM=N'" & tHAWB & "' and tran_no=N'" & tmpTran_no & "'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText			
			
			If not rs.EOF then
				tKgLb = rs("kg_lb")
				If tKgLb <> checkBlank(masterWeightScale, aKgLb(0)) Then
					If masterWeightScale = "K" Then '// In case house in Lb and master in Kg
						tAW = tAW * 2.20462262 '// house adjusted weight entered in masterWeightScale
					Else '// In case house in Kg and master in Lb
						tAW = tAW / 2.20462262
					End If
				end if
				rs("Adjusted_Weight") = CDbl(tAW)
				rs.Update
			end If
			rs.Close

			'// added on 4/14/2010
			SQL= "select * from hawb_master where elt_account_number=" & elt_account_number & _
			" and HAWB_NUM=N'" & tHAWB & "'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText			
			
			If not rs.EOF then
				rs("Adjusted_Weight") = CDbl(tAW)
				rs.Update
			end If
			rs.Close
		end if
	next		
END SUB 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:DELETE_OTHER_CHARGE_INFO
'Purpose  of the procedure: The procedure is in charge of deleting an other charge information                                               
'Tasks that are performed within:									    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB DELETE_OTHER_CHARGE_INFO
	dItemNo=Request.QueryString("dItemNo")
	for i=dItemNo to NoItemOC-1
		aCarrierAgent(i)=aCarrierAgent(i+1)
		aCollectPrepaid(i)=aCollectPrepaid(i+1)
		aChargeCode(i)=aChargeCode(i+1)
		aDesc(i)=aDesc(i+1)
		aChargeAmt(i)=aChargeAmt(i+1)	
	next
	NoItemOC=NoItemOC-1
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:SET_ITEM_OTHER_CHARGE_INFO
'Purpose  of the procedure: The procedure is in charge of setting the varialbes related to other charge information
'                           according to the values taken from screen                                            
'Tasks that are performed within:		
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUb SET_ITEM_OTHER_CHARGE_INFO
	oIndex=NoItemOC
	For i=0 To NoItemOC-1
		if aCarrierAgent(i)="A" and aCollectPrepaid(i)="P" then
			vPrepaidOtherChargeAgent=vPrepaidOtherChargeAgent+aChargeAmt(i)
		elseif aCarrierAgent(i)="A" and aCollectPrepaid(i)="C" then
			vCollectOtherChargeAgent=vCollectOtherChargeAgent+aChargeAmt(i)
		elseif aCarrierAgent(i)="C" and aCollectPrepaid(i)="P" then
			vPrepaidOtherChargeCarrier=vPrepaidOtherChargeCarrier+aChargeAmt(i)
		elseif aCarrierAgent(i)="C" and aCollectPrepaid(i)="C" then
			vCollectOtherChargeCarrier=vCollectOtherChargeCarrier+aChargeAmt(i)
		end if
	Next
	CALL SET_DETAULT_OTHER_CHARGE_ITEM_LINE		
	vShowWeightChargeShipper="Y"
	vShowWeightChargeConsignee="Y"
	vShowPrepaidOtherChargeShipper="Y"
	vShowCollectOtherChargeShipper="Y"
	vShowPrepaidOtherChargeConsignee="Y"
	vShowCollectOtherChargeConsignee="Y"	
	If vPPO_1="Y" Then
		vPrepaidWeightCharge=vTotalWeightCharge
	Else
		vCollectWeightCharge=vTotalWeightCharge
	End If
	vPrepaidValuationCharge=Request("txtPrepaidValuationCharge")
	if vPrepaidValuationCharge="" then vPrepaidValuationCharge=0
	vPrepaidValuationCharge=cdbl(vPrepaidValuationCharge)	
	vCollectValuationCharge=Request("txtCollectValuationCharge")
	if vCollectValuationCharge="" then vCollectValuationCharge=0
	vCollectValuationCharge=cdbl(vCollectValuationCharge)	
	vPrepaidTax=Request("txtPrepaidTax")
	if vPrepaidTax="" then vPrepaidTax=0
	vPrepaidTax=cdbl(vPrepaidTax)
	vCollectTax=Request("txtCollectTax")
	if vCollectTax="" then vCollectTax=0
	vCollectTax=cdbl(vCollectTax)
	vConversionRate=Request("txtConversionRate")
	if vConversionRate="" then vConversionRate=0
	vConversionRate=cdbl(vConversionRate)
	vCCCharge=Request("txtCCCharge")
	if vCCCharge="" then vCCCharge=0
	vCCCharge=cdbl(vCCCharge)	
	vChargeDestination=Request("txtChargeDestination")	
	if vChargeDestination="" then vChargeDestination=0
	vChargeDestination=cdbl(vChargeDestination)
	vPrepaidTotal=vPrepaidWeightCharge+vPrepaidValuationCharge+vPrepaidTax+vPrepaidOtherChargeAgent+vPrepaidOtherChargeCarrier
	vCollectTotal=vCollectWeightCharge+vCollectValuationCharge+vCollectTax+vCollectOtherChargeAgent+vCollectOtherChargeCarrier
	vFinalCollect=vCollectTotal+vChargeDestination
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_SELECTED_HAWB_INFO
'Purpose  of the procedure: The procedure is in charge of getting  HAWBs that have same MAWB # from DB						                                         
'Tasks that are performed within:						    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_SELECTED_HAWB_INFO
    DIM rs, masterWeightScale
    
    masterWeightScale = GetSQLResult("select Kg_Lb from mawb_weight_charge where elt_Account_number=" & elt_account_number & " AND mawb_num=N'" & vMAWB & "'", Null)
    
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL="select a.sub_count, a.is_master, a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_Name,a.Consignee_Name, "
	SQL=SQL & " b.tran_no,b.rate_class,b.no_pieces,b.gross_weight,b.adjusted_weight,b.kg_lb,b.dimension,b.chargeable_weight from hawb_master a LEFT OUTER JOIN hawb_weight_charge b "
	SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num =b.hawb_num) where "
	SQL=SQL & " (a.elt_account_number = " & elt_account_number & " or a.coloder_elt_acct=" & elt_account_number
	'and not (isnull(a.is_master,'N')='Y' and a.sub_count <=0) 
	SQL=SQL & ") and isnull(a.is_sub,'N')='N' and a.MAWB_NUM = N'" & vMAWB & "' and a.is_dome='N' order by a.hawb_num,b.tran_no"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	sCount=0	
	Do While Not rs.EOF 
		If IsNull(rs("tran_no")) = False Then
			tran_no = CInt(rs("tran_no"))
		Else
			tran_no=0
		end if
		if tran_no>0 then
			tKgLb=rs("kg_lb")
			If IsNull(rs("rate_class")) = False Then
				sRateClass(sCount) = rs("rate_class")
			End If	
			If IsNull(rs("no_pieces")) = False Then
					sPCS(sCount) = cLng(rs("no_pieces"))
			End If	
			If IsNull(rs("gross_weight")) = False Then
				sGW(sCount) = Cdbl(rs("gross_weight"))
			Else
				sGW(sCount)=0
			end if
			If IsNull(rs("adjusted_weight")) = False Then
				sAW(sCount) = Cdbl(rs("adjusted_weight"))
			Else
				sAW(sCount)=0
			end if
			If IsNull(rs("dimension")) = False Then
				sDW(sCount) = Cdbl(rs("dimension"))
			End If	
			If IsNull(rs("Chargeable_Weight")) = False Then
				sCW(sCount) = Cdbl(rs("Chargeable_Weight"))
			Else
				sCW(sCount)=0
			end if
			aWeightTran(sCount) = rs("tran_no")
			if  tKgLb <> checkBlank(masterWeightScale, aKgLb(0)) And masterWeightScale <> "" Then
				if masterWeightScale = "K" then
					sGW(sCount)=FormatNumber(sGW(sCount)/2.20462262,0)
					sAW(sCount)=FormatNumber(sAW(sCount)/2.20462262,0)
					sCW(sCount)=FormatNumber(sCW(sCount)/2.20462262,0)
					sDW(sCount)=FormatNumber(sDW(sCount)/2.20462262,0)
				else
					sGW(sCount)=FormatNumber(sGW(sCount)*2.20462262,0)
					sAW(sCount)=FormatNumber(sAW(sCount)*2.20462262,0)
					sCW(sCount)=FormatNumber(sCW(sCount)*2.20462262,0)
					sDW(sCount)=FormatNumber(sDW(sCount)*2.20462262,0)
				end if
			end if
		end if
		if tran_no=0 or tran_no=1 then
			If IsNull(rs("hawb_num")) = False Then
				sHAWB(sCount)=rs("hawb_num")
				delELTAcct(sCount)=rs("elt_account_number")
			End If	
			tmpAcct=cLng(rs("elt_account_number"))
			if Not tmpAcct=elt_account_number then
				xx=0
				Do while xx<coIndex
					if aColodeeAcct(xx)=tmpAcct then
						sCOLO(sCount)=aColodeeName(xx)
						exit do
					end if
					xx=xx+1
				loop
			end if
			If IsNull(rs("agent_name")) = False Then
			sAgent(sCount) = rs("agent_name")
				pos=Instr(sAgent(sCount),chr(10))
				if pos>0 then sAgent(sCount)=Mid(sAgent(sCount),1,pos-1)
			End If	
			sShipper(sCount) = rs("Shipper_name")
			sConsignee(sCount) = rs("Consignee_name")
		end If
		
		sTotalPCS=sTotalPCS+sPCS(sCount)
		sTotalGW=sTotalGW + cDbl(sGW(sCount))
		sTotalAW=sTotalAW + cDbl(sAW(sCount))
		sTotalDW=sTotalDW + cDbl(sDW(sCount))
		sTotalCW=sTotalCW + cDbl(sCW(sCount))

		if sTotalCW>0 then
			GWPercent=Round((sTotalGW/sTotalCW)*100,1)
			AWPercent=Round((sTotalAW/sTotalCW)*100,1)
			DWPercent=Round((sTotalDW/sTotalCW)*100,1)
		end if		
		sIsMaster(sCount)=checkBlank(rs("is_master"),"N")	
		sCount=sCount+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing
END SUB

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:PERFORM_CHECK_MISMATCH_ERROR
'Purpose  of the procedure: The procedure is in charge of alerting the mismatch of pieces between the total 
'of houses and the one on the mawb                                            
'Tasks that are performed within:						    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB PERFORM_CHECK_MISMATCH_ERROR
	DIM hCnt
	On Error Resume Next:
		hCnt = cInt(document.frmMAWB.hTotalHAWB.value)	
	if Not Save="yes" and not AddOC="yes" and not AddHAWB="yes" and not DeleteOC="yes" and not DeleteHAWB="yes" and not AdjustWeight="yes" and not DeleteMAWB="yes" then		
		if Not vTotalPieces="" and hCnt > 0 then
			if Not cLng(vTotalPieces)=sTotalPCS then
			ErrMSG="PCS mismatch between selected and saved! " & " ^ Selected Total Pieces:" & sTotalPCS & " ^ Saved Total Pieces: " & vTotalPieces
			end if
		end if
	end if
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AVAIL_HAWB
'Purpose  of the procedure: The procedure is in charge of listing all the available house airway bill to the screen                                        
'Tasks that are performed within:
'1)Get all the available house airway bill informations from DB and store them to the variables						    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB GET_AVAIL_HAWB
	DIM rs, masterWeightScale
	
	masterWeightScale = GetSQLResult("select Kg_Lb from mawb_weight_charge where elt_Account_number=" & elt_account_number & " AND mawb_num=N'" & vMAWB & "'", Null)
	
	Set rs = Server.CreateObject("ADODB.Recordset")		
	SQL= "select a.elt_account_number,a.hawb_num,a.agent_name,a.Shipper_name,a.Consignee_name, "
	SQL=SQL & "b.tran_no,b.no_pieces,b.rate_class,b.kg_lb,b.gross_weight,b.adjusted_weight,b.chargeable_weight,b.dimension from hawb_master a  INNER JOIN hawb_weight_charge b "
	SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num) "
	SQL=SQL & " where (a.elt_account_number=" & elt_account_number &"or a.coloder_elt_acct=" & elt_account_number 
	SQL=SQL & ") and  isnull(a.is_sub,'N')='N' and a.MAWB_NUM = '' and not (a.elt_account_number=" &elt_account_number&" and isnull(colo,'')= 'Y') and not (isnull(a.is_master,'N')='Y' and a.sub_count <= 0) and a.is_dome='N' order by a.hawb_num,b.tran_no" 
	
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	aCount=0
	Do While Not rs.EOF 
		If IsNull(rs("tran_no")) = False Then
			tran_no = CInt(rs("tran_no"))
		Else
			tran_no=0
		end if
		if tran_no>0 then
			tKgLb=rs("kg_lb")
			If IsNull(rs("no_pieces")) = False Then
				aPCS(aCount)=cdbl(rs("no_pieces"))
			End If
			If IsNull(rs("rate_class")) = False Then
				aClass(aCount)=rs("rate_class")
			End If
			If IsNull(rs("gross_weight")) = False Then
				aGW(aCount)=cdbl(rs("gross_weight"))
			Else
				aGW(aCount)=0
			end if
			If IsNull(rs("adjusted_weight")) = False Then
				aAW(aCount)=cdbl(rs("adjusted_weight"))
			Else
				aAW(aCount)=0
			end if
			If IsNull(rs("Chargeable_Weight")) = False Then
				aCW(aCount)=cdbl(rs("Chargeable_Weight"))
			Else
				aCW(aCount)=0
			end if
			If IsNull(rs("dimension")) = False Then
				aDW(aCount)=cdbl(rs("dimension"))
			End If			
			If tKgLb <> checkBlank(masterWeightScale, aKgLb(0)) then
				if masterWeightScale = "K" then
					aGW(aCount)=FormatNumber(aGW(aCount)/2.20462262,2)
					aAW(aCount)=FormatNumber(aAW(aCount)/2.20462262,2)
					aCW(aCount)=FormatNumber(aCW(aCount)/2.20462262,2)
				else
					aGW(aCount)=FormatNumber(aGW(aCount)*2.20462262,2)
					aAW(aCount)=FormatNumber(aAW(aCount)*2.20462262,2)
					aCW(aCount)=FormatNumber(aCW(aCount)*2.20462262,2)
				end if
			end if
		end if
		if tran_no=0 or tran_no=1 then
			If IsNull(rs("hawb_num")) = False Then
				aHAWB(aCount) = rs("hawb_num")
				AddELTAcct(aCount)=rs("elt_account_number")
			End If	
			tmpAcct=cLng(rs("elt_account_number"))
			if Not tmpAcct=elt_account_number then
				xx=0
				Do while xx<coIndex				
					if aColodeeAcct(xx)=tmpAcct then
						aCOLO(aCount)=aColodeeName(xx)
						exit do
					end if
					xx=xx+1
				loop
			end if
			If IsNull(rs("agent_name")) = False Then
				aAgent(aCount) = rs("agent_name")
				pos=Instr(aAgent(tIndex),chr(10))
				if pos>0 then aAgent(aCount)=Mid(aAgent(aCount),1,pos-1)
			End If	
			aShipper(aCount) = rs("Shipper_name")
			aConsignee(aCount) = rs("Consignee_name")
		end if
		aCount=aCount+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing
END SUB

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AVAIL_HAWB
'Purpose  of the procedure: The procedure is in charge of listing all the available house airway bill to the screen                                        
'Tasks that are performed within:
'1)Get all the available house airway bill informations from DB and store them to the variables						    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_MAWB_WEIGHT_CHARGE_INFO_FROM_TABLE
		DIM rs
		Set rs = Server.CreateObject("ADODB.Recordset")
		wCount=0
		SQL="select no_pieces as p,rate_class,kg_lb,gross_weight as aw,chargeable_weight as cw,rate_charge,total_charge, Commodity_Item_No"
		SQL=SQL & " from mawb_weight_charge where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "' order by tran_no"
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		Do While Not rs.EOF and wCount<3
			If IsNull(rs("p")) = False Then
				aPiece(wCount) = cLng(rs("p"))
			End If
			If IsNull(rs("rate_class")) = False Then
				aRateClass(wCount) = rs("rate_class")
			End If
			If IsNull(rs("kg_lb")) = False Then
				akgLb(wCount) = rs("kg_lb")
			End If
			If IsNull(rs("aw")) = False Then
				aGrossWeight(wCount) = cDbl(rs("aw"))
			End If
			If IsNull(rs("cw")) = False Then
				aChargeableWeight(wCount) = cDbl(rs("cw"))
			End If
			aItemNo(wCount) = rs("Commodity_Item_No")
			aRateCharge(wCount)=rs("rate_charge")
			aTotal(wCount)=rs("total_charge")			
			rs.MoveNext
			wCount=wCount+1
		Loop
		rs.Close
		set rs = nothing
END SUB

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:UPDATE_ALL_SUB_HOUSE_INFO
'Purpose  of the procedure: The procedure is in charge of updating booking information for all the sub houses
'							belong to a Master House                                        
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB UPDATE_ALL_SUB_HOUSE_INFO(elt_acct,MasterHouse,CLR)
	
    dim rs, SQL, HAWBS(50),hhIndex	
	set rs= Server.CreateObject("ADODB.Recordset")
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")	
	SQL= "select hawb_num as hb from hawb_master  where (elt_account_number= "
	SQL= SQL& elt_acct & " or coloder_elt_acct="
	SQL= SQL& elt_acct & ") and is_dome='N' and is_sub='Y' and sub_to_no=N'"& MasterHouse & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing	
	If Not rs.EOF Then
		hhIndex=0
		Do While Not rs.EOF
			HAWBS(hhIndex)=rs("hb")
			hhIndex=hhIndex+1
			rs.MoveNext		
		Loop			
	End If	
	rs.close	
	IF CLR<>"Y" THEN 
		For i =0 to hhIndex -1	
			SQL= "select mawb_num,airline_vendor_num,DEP_AIRPORT_CODE,Departure_Airport,To_1,by_1,To_2,By_2,To_3,By_3,Dest_Airport,Flight_Date_1,Flight_Date_2,export_date,dest_country,departure_state,IssuedBy,Execution from hawb_master where (elt_account_number= "
			SQL= SQL& elt_account_number & " or coloder_elt_acct="
			SQL= SQL& elt_account_number & ") and is_dome='N' and is_sub='Y' and hawb_num=N'" & HAWBS(i) & "'"
            
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if not rs.EOF then
				rs("mawb_num")=vMAWB
				rs("airline_vendor_num")=vAirOrgNum
				rs("DEP_AIRPORT_CODE") = vOriginPortID
				rs("Departure_Airport") = vDepartureAirport
				rs("To_1") = vTo
				rs("by_1") = vBy 
				rs("To_2") = vTo1
				rs("By_2") = vBy1
				rs("To_3") = vTo2
				rs("By_3") = vBy2
				rs("Dest_Airport") = vDestAirport
				rs("Flight_Date_1") = vFlightDate1
				rs("Flight_Date_2") = vFlightDate2
				rs("export_date")=vExportDate
				rs("dest_country")=vDestCountry
				rs("departure_state")=vDepartureState
				rs("IssuedBy")=vIssuedBy 
				rs("Execution")=vExecute						
				rs.Update
			end if 		
			rs.close
		next
	ELSE 	
		For i =0 to hhIndex -1	
			SQL= "select mawb_num,airline_vendor_num,DEP_AIRPORT_CODE,Departure_Airport,To_1,by_1,To_2,By_2,To_3,By_3,Dest_Airport,Flight_Date_1,Flight_Date_2,export_date,dest_country,departure_state,IssuedBy,Execution from hawb_master where (elt_account_number= "
			SQL= SQL& elt_account_number & " or coloder_elt_acct="
			SQL= SQL& elt_account_number & ") and is_sub='Y' and is_dome='N' and hawb_num=N'"& HAWBS(i) & "'"
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if not rs.EOF then
				rs("mawb_num")=""
				rs("airline_vendor_num")=0
				rs("DEP_AIRPORT_CODE") = 0
				rs("Departure_Airport") = ""
				rs("To_1") = ""
				rs("by_1") = ""
				rs("To_2") = ""
				rs("By_2") = ""
				rs("To_3") =""
				rs("By_3") = ""
				rs("Dest_Airport") = ""
				rs("Flight_Date_1") = ""
				rs("Flight_Date_2") = ""
				rs("export_date")=null
				rs("dest_country")=""
				rs("departure_state")=""
				rs("IssuedBy")=""
				rs("Execution")=""						
				rs.Update
			end if 		
			rs.close
		next
	END  IF 
	set rs=nothing 
END SUB 


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:RECALC_ITEM_RATE_CHARGE
'Purpose  of the procedure: The procedure is in charge of recalculating Weight charges for the MAWB with all 
'							the sub houses belong to the MAWB 
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB RECALC_ITEM_RATE_CHARGE
	On Error Resume Next:
	if aKgLb(0)="K" then 
		SQL= "Select c.rate_class,c.kg_lb, Sum(p) as p, sum(aw) as aw , sum(cw) as cw from (select  b.rate_class as rate_class, 'K' as kg_lb,"
		SQL=SQL &"sum(b.no_pieces)  as p,"
		SQL=SQL &"case when b.kg_lb ='L' then SUM(ROUND(b.adjusted_weight/2.20462262,0))  else sum(b.adjusted_weight) end as aw,"
		SQL=SQL &"case when b.kg_lb ='L' then SUM(ROUND(b.chargeable_weight/2.20462262,0))  else sum(b.chargeable_weight) end as cw "
		
		SQL=SQL & "from hawb_master a INNER JOIN hawb_weight_charge b "
		SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num) "
		SQL=SQL & " where a.is_dome='N' and isnull(a.is_sub,'N') ='N' and (a.elt_account_number = " & elt_account_number & " or a.coloder_elt_acct=" & elt_account_number
		SQL=SQL & ") and a.MAWB_NUM = N'" & vMAWB & "' GROUP BY  b.rate_class,b.Kg_Lb"
		SQL=SQL & ")C GROUP BY rate_class,kg_lb"
	
	else 
		SQL= "Select c.rate_class,c.kg_lb, Sum(p) as p, sum(aw) as aw , sum(cw) as cw from (select b.rate_class as rate_class, 'L' as kg_lb,"
		SQL=SQL &"sum(b.no_pieces) as p,"
		SQL=SQL &"case when b.kg_lb ='K' then SUM(ROUND(b.adjusted_weight*2.20462262,0)) else sum(b.adjusted_weight) end as aw,"
		SQL=SQL &"case when b.kg_lb ='K' then SUM(ROUND(b.chargeable_weight*2.20462262,0)) else sum(b.chargeable_weight) end as cw "
		
		SQL=SQL & "from hawb_master a INNER JOIN hawb_weight_charge b "
		SQL=SQL & " on (a.elt_account_number=b.elt_account_number) and (a.hawb_num=b.hawb_num) "
		SQL=SQL & " where a.is_dome='N' and isnull(a.is_sub,'N')='N' and (a.elt_account_number = " & elt_account_number & " or a.coloder_elt_acct=" & elt_account_number
		SQL=SQL & ") and a.MAWB_NUM = N'" & vMAWB & "' GROUP BY  b.rate_class,b.Kg_Lb"
		SQL=SQL & ")C GROUP BY rate_class,kg_lb"   
	end if
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	Do While Not rs.EOF and wCount<3
		If IsNull(rs("p")) = False Then
			aPiece(wCount) = cLng(rs("p"))
		End If
		If IsNull(rs("rate_class")) = False Then
			aRateClass(wCount) = rs("rate_class")
		End If
		If IsNull(rs("kg_lb")) = False Then
			tkgLb=rs("kg_lb")
		End If
		If IsNull(rs("aw")) = False Then
			aGrossWeight(wCount) = cDbl(rs("aw"))
		Else
			aGrossWeight(wCount)=0
		end if
		
		If IsNull(rs("cw")) = False Then
			aChargeableWeight(wCount) = cDbl(rs("cw"))
		Else
			aChargeableWeight(wCount)=0
		end if
	
		if not tKgLb=aKgLb(0) then
			if aKgLb(0)="K" then
				aChargeableWeight(wCount)=FormatNumber(aChargeableWeight(wCount)/2.20462262,2)
				aGrossWeight(wCount)=FormatNumber(aGrossWeight(wCount)/2.20462262,2)
			else
				aChargeableWeight(wCount)=FormatNumber(aChargeableWeight(wCount)*2.20462262,2)
				aGrossWeight(wCount)=FormatNumber(aGrossWeight(wCount)*2.20462262,2)
			end if
		end if
		Set rs1 = Server.CreateObject("ADODB.Recordset")
		vAirline=cInt(Mid(vMAWB,1,3))
		DIM MinCharge
		dim MinApplied
		MinApplied=false		
		SQL="select weight_break,rate,kg_lb from all_rate_table where elt_account_number=" & elt_account_number
		SQL=SQl & " and rate_type=5 "
		SQL=SQL & " and (airline=" & vAirline & " or airline=-1) and origin_port=N'" & vDepCode & "'"
		SQL=SQL & " and dest_port=N'" & vArrCode & "' order by weight_break desc"
		
		rs1.CursorLocation = adUseClient
		rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs1.activeConnection = Nothing
		rIndex=0
		dim rFLAG
		rFLAG=true 
		DIM tmpWT 
		tmpWT=-1
		do while not rs1.EOF
			wb=cdbl(rs1("weight_break"))
			tKgLb=rs1("kg_lb")
			TempRate=cdbl(rs1("rate"))
			if wb=0 then MinCharge=TempRate
			if not wb=0 and not tKgLb=aKgLb(0) then
				if aKgLb(0)="K" then 'query K and DB L--searched amount is smaller relatively, so aChargeableWeight get bigger
					tmpWT=cdbl(aChargeableWeight(wCount))*2.20462262
					TempRate=TempRate*2.20462262
				else
					tmpWT=cdbl(aChargeableWeight(wCount))/2.20462262
					 TempRate=TempRate/2.20462262
				end if
			end if
			if tmpWT <> -1 then
				if tmpWT >= wb then
				  if rFLAG = true then 
						aRateCharge(wCount)=TempRate
						if wb=0 then 
							MinApplied=true 
							aRateCharge(wCount)=1
						end if 
						rFLAG=false
				  end if
				end if 
			 else 
				if aChargeableWeight(wCount) >= wb then 
				  if rFLAG = true then 
						aRateCharge(wCount)=TempRate
						if wb=0 then 
							MinApplied=true 
							aRateCharge(wCount)=1
						end if 
						rFLAG=false
				  end if
				end if 
			 end if 
			rs1.MoveNext
			rIndex=rIndex+1
		loop
		rs1.Close	
		if not aRateCharge(wCount)="" then		
			if tmpWT <> -1 then 			 
				tmpNum = cdbl(aChargeableWeight(wCount)) * cDBL(aRateCharge(wCount))
			else
				tmpNum = cdbl(aChargeableWeight(wCount)) * cDBL(aRateCharge(wCount))			
			end if 
			aTotal(wCount)=FormatNumber(tmpNum,2)			
			if tmpNum < MinCharge  then				
			 aRateCharge(wCount)=0
			 aTotal(wCount)=MinCharge
			end if 			
			if MinApplied=true then 			
			 aRateCharge(wCount)=0
			 aTotal(wCount)=MinCharge
			end if			
		end if	
	wCount=wCount+1
	rs.MoveNext
	Loop
	rs.Close
END SUB 


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:RECALC_ITEM_TOTAL
'Purpose  of the procedure: The procedure is in charge of recalculating all the total charges for the MAWB 
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB RECALC_ITEM_TOTAL
	vTotalPieces=0
	vTotalGrossWeight=0
	vTotalWeightCharge=0
	vPrepaidWeightCharge=0
	vCollectWeightCharge=0
	vPrepaidTotal=0	
	for i=0 to wCount-1
		vTotalPieces=vTotalPieces+aPiece(i)
		
		vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(i)		
		if aTotal(i)<>"" then
			vTotalWeightCharge=vTotalWeightCharge+cDbl(aTotal(i))
		end if
	next
	If vPPO_1="Y" Then
		vPrepaidWeightCharge=vTotalWeightCharge
	Else
		vCollectWeightCharge=vTotalWeightCharge
	End If
	vPrepaidTotal=vPrepaidWeightCharge+vPrepaidValuationCharge+vPrepaidTax+vPrepaidOtherChargeAgent+vPrepaidOtherChargeCarrier
	vCollectTotal=vCollectWeightCharge+vCollectValuationCharge+vCollectTax+vCollectOtherChargeAgent+vCollectOtherChargeCarrier
	vFinalCollect=vCollectTotal+vChargeDestination		
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:RESET_PIECE_WEIGHT
'Purpose  of the procedure: The procedure is in charge of setting pieces, gross wiehgt , chargealbe weight to be empty
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB RESET_PIECE_WEIGHT
	for i=0 to 2
		aPiece(i)=0
		aGrossWeight(i)=0
		aChargeableWeight(i)=0
	next
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:FIND_ALL_COLODEES
'Purpose  of the procedure: The procedure is in charge of making a list of coloders with the coloders that are 
'                           listed in the client profile with their elt_account_number
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB FIND_ALL_COLODEES
	DIM rs
	Set rs = Server.CreateObject("ADODB.Recordset")
	coIndex=0
	SQL= "select tran_date,colodee_name,colodee_elt_acct from colo where coloder_elt_acct = " & elt_account_number & " order by colodee_name,tran_date"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    '// response.Write("-------------------"&SQL&"<BR>")
	Set rs.activeConnection = Nothing
	Do While Not rs.EOF
		'// response.write rs("tran_date") & "<br>"
		aColodeeName(coIndex)=rs("colodee_name")
		'// response.Write("-------------"&aColodeeName(coIndex)&"<br>")
		aColodeeAcct(coIndex)=cLng(rs("colodee_elt_acct"))
		coIndex=coIndex+1
		rs.MoveNext
	Loop
	rs.Close
	set rs = nothing	
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_AGENT_SHIPPER_CONSIGNEE_VENDOR_INFO
'Purpose  of the procedure: The procedure is in charge of 
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'//SUB GET_AGENT_SHIPPER_CONSIGNEE_VENDOR_INFO
'//	aIndex=1
'//	cIndex=1
'//	sIndex=1
'//	aAgentName(0)="Select One"
'//	aAgentInfo(0)=""
'//	aShipperName(0)="Select One"
'//	aShipperInfo(0)=""
'//	aConsigneeName(0)="Select One"
'//	aConsigneeInfo(0)=""
'//	SQL= "select dba_name,org_account_number,is_agent,is_shipper,is_consignee from organization where elt_account_number = " & elt_account_number & " and (account_status='A'"
'//	if Not vShipperAcct="" then
'//		SQL=SQL & " or org_account_number=" & vShipperAcct
'//	end if
'//	if Not vConsigneeAcct="" then
'//		SQL=SQL & " or org_account_number=" & vConsigneeAcct
'//	end if
'//	if Not vFFAgentAcct="" then
'//		SQL=SQL & " or org_account_number=" & vFFAgentAcct
'//	end if
'//	
'//	SQL=SQL & ") and ( is_shipper='Y' or is_consignee = 'Y' or is_agent = 'Y') order by dba_name"
'//	
'//	rs.CursorLocation = adUseClient
'//	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
'//	Set rs.activeConnection = Nothing
'//	Do While Not rs.EOF
'//		cName=rs("DBA_NAME")
'//		cAcct=cLng(rs("org_account_number"))
'//		IsAgent=rs("is_agent")
'//		IsShipper=rs("is_shipper")
'//		IsConsignee=rs("is_consignee")
'//		carrier=rs("BY")
'//		rs.MoveNext
'//		if IsConsignee="Y" or IsAgent="Y" then
'//			aAgentName(aIndex) = cName
'//			aAgentAcct(aIndex)=cAcct
'//			aIndex = aIndex+1
'//		end if
'//		if IsShipper="Y" then
'//			aShipperName(sIndex) = cName
'//			aShipperAcct(sIndex)=cAcct
'//			sIndex = sIndex+1
'//		end if
'//		if IsConsignee="Y" or IsAgent="Y" then
'//			aConsigneeName(cIndex) = cName
'//			aConsigneeAcct(cIndex)=cAcct
'//			cIndex = cIndex+1
'//		end If
'//	Loop
'//	rs.Close
'//END SUB


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_MAWB_NUMBER_FROM_TABLE
'Purpose  of the procedure: The procedure is in charge of making a list of MAWB that can be assinged when
'creating a MAWB
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_MAWB_NUMBER_FROM_TABLE( vMAWB )
	SQL= "select mawb_no from mawb_number where elt_account_number = " & elt_account_number & " and is_dome='N' and status='B' order by mawb_no"
	'response.write SQL
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	reDim aMAWB(rs.RecordCount+1)
	If Not rs.EOF Then
		mIndex=0
		aMAWB(0)="Select One"
		Do While Not rs.EOF
			mIndex = mIndex + 1
			aMAWB(mIndex) = rs("mawb_no")
			rs.MoveNext
		Loop
	End If
	rs.close
END SUB

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_CHARGE_ITEM_INFO
'Purpose  of the procedure: The procedure is in charge of creating a list of  charge items
'created for the MAWB
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB GET_CHARGE_ITEM_INFO
	SQL= "select * from item_charge where elt_account_number = " & elt_account_number & " order by item_name"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	
	reDim aChargeItemName(rs.RecordCount+1)
	reDim aChargeItemNo(rs.RecordCount+1)
	reDim aChargeItemDesc(rs.RecordCount+1)
	reDim aChargeUnitPrice(rs.RecordCount+1)
	reDim aChargeItemNameig(rs.RecordCount+1)
	
	chIndex=1
	aChargeItemName(0)="Select One"
	aChargeItemNo(0)=0
	aChargeItemDesc(0)=""
	aChargeUnitPrice(0)=0 '// Unit_price by ig 10/21/2006
	aChargeItemNameig(0)="Select One"
	Do While Not rs.EOF
		aChargeItemName(chIndex)=rs("item_name")
		aChargeItemNo(chIndex)=cInt(rs("item_no"))
		aChargeItemDesc(chIndex)=rs("item_desc")
		aChargeUnitPrice(chIndex)=rs("unit_price") 
		if ( len(aChargeItemName(chIndex))) < 7 then	
			aChargeItemNameig(chIndex) = aChargeItemName(chIndex) & " " & string(7-len(aChargeItemName(chIndex)),"-") & " " & aChargeItemDesc(chIndex)
		else
			aChargeItemNameig(chIndex) = aChargeItemName(chIndex)
		end if
		
		chIndex=chIndex+1
		rs.MoveNext
	Loop
rs.Close
END SUB
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:FINAL_SCREEN_PREPARE
'Purpose  of the procedure: The procedure is in charge of creating a list of  charge items
'creating a MAWB
'Tasks that are performed within:
'1)					    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB FINAL_SCREEN_PREPARE
	DIM tmpStr
	IF NOT vMAWB = "" AND NOT vMAWB = "0" THEN
		CALL CHECK_INVOICE_STATUS_MAWB(	vMAWB, elt_account_number )	
	END IF	
	Set rs=Nothing
	Set rs1=Nothing
	Set rs3=Nothing
	if  vNotifyAcct="" or isnull(vNotifyAcct) then vNotifyAcct="0"  
	If IsNull(vExecute) Or Trim(vExecute) = "" Then
        GETVEXECUTE(vMAWB)
    End If    
	tmpstr = "A"&chr(13)&chr(10)&"S"
	pos = inStr(vExecute,tmpstr)
	if pos > 0 then
		vExecute = replace(vExecute,tmpstr,"AS")
	end if	
END SUB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:CHECK_INVOICE_STATUS_HAWB
'Purpose  of the procedure: The procedure is in charge of checking out whether the invoices belong to the 
'HAWB has been processed or not 
'Tasks that are performed within:									    
'1.Find all the invoice # belong to the HAWB and store on a array
'2.Make a message string that will be used in alerting the user when the user attempt to modify HAWB that
'are already processed.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

SUB CHECK_INVOICE_STATUS_HAWB( tvHAWB, t_elt_account_number )
	DIM invoiceNUM(100),ivIndex
	if tvHAWB = "" Then Exit sub
	
	ivIndex = 0				
	SQL="select invoice_no from invoice where elt_account_number=" & t_elt_account_number & " and air_ocean = 'A' and hawb_num=N'" & tvHAWB & "'"
	
	rs3.CursorLocation = adUseClient
	rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs3.activeConnection = Nothing
	Do While Not rs3.EOF
		invoiceNUM(ivIndex) = rs3("invoice_no")
		ivIndex = ivIndex + 1										
		rs3.MoveNext
	Loop
	rs3.Close
	
	if ivIndex = 0	then
		SQL= "select invoice_no from invoice_hawb where elt_account_number = " & elt_account_number & " and hawb_num=N'" & tvHAWB & "'"
		
		rs3.CursorLocation = adUseClient
		rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs3.activeConnection = Nothing
		Do While Not rs3.EOF
			invoiceNUM(ivIndex) = rs3("invoice_no")
			ivIndex = ivIndex + 1										
			rs3.MoveNext
		Loop
		rs3.Close
	
		if ivIndex = 0	then
			SQL="select hawb_num from invoice_queue where elt_account_number=" & t_elt_account_number & " and hawb_num=N'" & tvHAWB & "'" & " and invoiced = 'Y' "
			
			rs3.CursorLocation = adUseClient
			rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs3.activeConnection = Nothing
			if Not rs3.EOF then
				invoiceNUM(ivIndex) = "(Unknown)"
				ivIndex = ivIndex + 1										
			end if
			rs3.Close
		end if
			
	end if
	
	DIM tmpIVstrMsg	
	tmpIVstrMsg = ""
	if ivIndex > 0 then
		for iii = 0 to ivIndex - 1
			tmpIVstrMsg = tmpIVstrMsg	& invoiceNUM(iii) & ","
		next
		tmpIVstrMsg = MID(tmpIVstrMsg,1,LEN(tmpIVstrMsg)-1)
%>
<script type="text/jscript">
    //////////////////////////////////////////
    alert('The HAWB#:' + '<%=tvHAWB%>' + ' was already Invoiced as IV #:' + '<%= tmpIVstrMsg %>' + '.\nPlease check Invoice Information & HAWB information later.');
    //////////////////////////////////////////
</script>
<%
	end if
End Sub	

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:CHECK_INVOICE_STATUS_MAWB
'Purpose  of the procedure: The procedure is in charge of checking out whether the invoices belong to the 
'MAWB has been processed or not 
'Tasks that are performed within:									    
'1.Find all the invoice # belong to the MAWB and store on a array
'2.Make a message string that will be used in alerting the user when the user attempt to modify HAWB that
'are already processed.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	

SUB CHECK_INVOICE_STATUS_MAWB( tvMAWB, t_elt_account_number )
	DIM invoiceNUM(100),ivIndex
	If Not tvMAWB = "" then
		ivIndex = 0				
		SQL="select invoice_no from invoice where elt_account_number=" & t_elt_account_number & " and air_ocean = 'A' and mawb_num=N'" & tvMAWB & "'"
		
		rs3.CursorLocation = adUseClient
		rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs3.activeConnection = Nothing
		Do While Not rs3.EOF
			invoiceNUM(ivIndex) = rs3("invoice_no")
			ivIndex = ivIndex + 1										
			rs3.MoveNext
		Loop
		rs3.Close
	
		if ivIndex = 0	then
			SQL="select mawb_num from invoice_queue where elt_account_number=" & t_elt_account_number & " and mawb_num=N'" & tvMAWB & "'" & " and invoiced = 'Y' "
			
			rs3.CursorLocation = adUseClient
			rs3.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs3.activeConnection = Nothing
			if Not rs3.EOF then
				invoiceNUM(ivIndex) = "(Unknown)"
				ivIndex = ivIndex + 1										
			end if
			rs3.Close
		end if
				
		IVstrMsg = ""
		if ivIndex > 0 then
			for iii = 0 to ivIndex - 1
				IVstrMsg = IVstrMsg	& invoiceNUM(iii) & ","
			next
			IVstrMsg = MID(IVstrMsg,1,LEN(IVstrMsg)-1)
		end if
	End if		
End Sub		


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:GET_QUEUE_ID
'Purpose  of the procedure: The procedure is in charge of retrieving current queue id that will be assinged
'to the next invoice queue entry
'Tasks that are performed within:									    
'1.retreive the most updated queue id
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
FUNCTION GET_QUEUE_ID
	SQL="select max(queue_id) as queue_id from invoice_queue where elt_account_number=" & elt_account_number
	
	rs1.CursorLocation = adUseClient
	rs1.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs1.activeConnection = Nothing
	If Not rs1.EOF And IsNull(rs1("queue_id"))=False Then
		vQueueID=CLng(rs1("queue_id"))+1
	Else
		vQueueID=1
	End If
	rs1.close
	GET_QUEUE_ID = vQueueID
END FUNCTION


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:MAWB_INVOICE_QUEUE
'Purpose  of the procedure: The procedure is in charge of creating/updating invoice queue entries that belongs to a MAWB
'Tasks that are performed within:									    
'1.Delete all the MAWB invoice queue entries in the queue that belong to the MAWB that the HAWB is assigned
'2.Recreate all the MAWB invoice queues reflecting the changes made for the HAWB and the Sub HAWBs, and the other 
'HAWBS that belong to the MAWB. 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB MAWB_INVOICE_QUEUE( vMAWB )		
	DIM tHAWB	
	vTotalHAWB=Request("hTotalHAWB")
	if vTotalHAWB="" then vTotalHAWB=0	
	if vTotalHAWB=0 then	
		if vPPO_1="Y" or vPPO_2="Y" And ConvertAnyValue(vPrepaidTotal, "Double", 0) > 0 Then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='S' and mawb_num=N'" & vMAWB & "' and bill_to_org_acct=" & vShipperAcct
			
			rs3.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs3.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs3.AddNew
				rs3("elt_account_number")=elt_account_number
				rs3("queue_id")=vQueueID
				rs3("inqueue_date")=now
				rs3("agent_shipper")="S"
				rs3("mawb_num")=vMAWB
				rs3("bill_to")=vShipperName
				rs3("bill_to_org_acct")=vShipperAcct
				rs3("agent_name")=vConsigneeName
				rs3("agent_org_acct")=vConsigneeAcct					
				rs3("air_ocean")="A"
				rs3("master_only")="Y"
				rs3("invoiced")="N"
				rs3.Update
			end if
			rs3.close
		end if	
		if vCOLL_1="Y" or vCOLL_2="Y" And ConvertAnyValue(vCollectTotal, "Double", 0) > 0 then
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vMAWB & "' and bill_to_org_acct=" & vConsigneeAcct
			
			rs3.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs3.EOF then
				vQueueID = GET_QUEUE_ID() 
				rs3.AddNew
				rs3("elt_account_number")=elt_account_number
				rs3("queue_id")=vQueueID
				rs3("inqueue_date")=now
				rs3("agent_shipper")="A"
				rs3("mawb_num")=vMAWB
				rs3("bill_to")=vConsigneeName
				rs3("bill_to_org_acct")=vConsigneeAcct
				rs3("agent_name")=vConsigneeName
				rs3("agent_org_acct")=vConsigneeAcct					
				rs3("air_ocean")="A"
				rs3("master_only")="Y"
				rs3("invoiced")="N"
				rs3.Update
			end if
			rs3.close
		end if			
	else		
		dim atmpHAWB(100),tmpIndex
		Set dict = CreateObject("Scripting.Dictionary")
		tmpIndex = 0
		SQL = "select hawb_num,Agent_Name from hawb_master where ((( isnull(is_master,'N')='Y' or isnull(is_sub,'N')='Y') and isnull(is_invoice_queued,'Y') <> 'N') OR (( isnull(is_master,'N')='N' and isnull(is_sub,'N')='N'))) and elt_account_number = " & elt_account_number & " and is_dome='N' and mawb_num=N'" & vMAWB & "'" 		
		
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		reDim tmpAgent(rs.RecordCount+1)
		
		Do while Not rs.EOF
			atmpHAWB(tmpIndex)=rs("hawb_num")
			tmpAgent(tmpIndex)=rs("Agent_Name")				
			tmpval=tmpAgent(tmpIndex)
			if not dict.Exists(tmpval) then		   
				dict.Add tmpval, 1				
			else 			
				dict(tmpval)=dict(tmpval)+1					
			end if 
			tmpIndex = tmpIndex + 1
			rs.MoveNext
		Loop
		rs.Close
		for i=0 to tmpIndex-1				
			tHAWB=atmpHAWB(i)						
			if CHECK_SHOULD_INVOICE_QUEUED(tHAWB )= true then						
				CALL HAWB_INVOICE_QUEUE	( tHAWB, vTotalHAWB,tmpAgent(i) )
			else						
			end if					
		next 
	
		SQL="select master_agent from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vMAWB & "' and bill_to_org_acct=" & vConsigneeAcct
		
		rs3.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if Not rs3.EOF then
			rs3("master_agent")="Y"
			rs3.Update
		end if
		rs3.close					
	end if
	set dict=nothing 
END SUB


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:INVOICE_QUEUE_REFRESH
'Purpose  of the procedure: The procedure is in charge of deleting all the invoice queue entries that 
'belong to the HAWB/MAWB
'Tasks that are performed within:									    
'1.delete all the queue entries that belong to the HAWB
'2.delete all the queue entries that belong to the MAWB
'3.Last query should be understoood 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
SUB INVOICE_QUEUE_REFRESH( vMAWB )
	DIM arr_queue_id(100),qu_index	
	qu_index = 0				
	SQL="select queue_id from invoice_queue where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'" & " and invoiced = 'N' "
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	Do While Not rs.EOF
		arr_queue_id(qu_index) = rs("queue_id")
		qu_index = qu_index + 1										
		rs.MoveNext
	Loop
	rs.Close	
	for iii = 0 to qu_index - 1
		SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'" & " and invoiced = 'N' and queue_id=" & arr_queue_id(iii)
		
		eltConn.Execute SQL			
	next	
	SQL= "delete invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & vMAWB & "' and invoiced = 'N' and bill_to_org_acct not in (select agent_no from hbol_master where elt_account_number=" & elt_account_number & " and booking_num = N'" & vMAWB & "' group by agent_no )"
	
	eltConn.Execute SQL
End Sub
		

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'SUB PROCEDURE:HAWB_INVOICE_QUEUE
'Purpose  of the procedure: The procedure is in charge of creating/updating invoice queue entries that belongs to a HAWB
'Tasks that are performed within:									    
'1.Delete all the HAWB invoice queue entries in the queue that belong to the MAWB that the HAWB is assigned
'2.Recreate all the HAWB invoice reflecting the changes made for the HAWB and the Sub HAWBs, and the other 
'HAWBS that belong to the MAWB. 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub HAWB_INVOICE_QUEUE( tmpHAWB, iiiCnt,tmpAt )
	DIM tvQueueID,tvShipperAcct,tvShipperName,tvFFAgentAcct,tvFFAgentName,tvPPO_1,tvPPO_2,tvCOLL_1,tvCOLL_2,tvMAWB,rs
	set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "select * from hawb_master  where  elt_account_number = " & elt_account_number & " and is_dome='N' and HAWB_NUM=N'" & tmpHAWB & "'"
	
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	if not rs.EOF Then		
			tvMAWB = rs("MAWB_NUM")
			tvShipperAcct = rs("Shipper_Account_Number")
			tvFFShipperAcct = rs("ff_shipper_acct")
			tvFFAgentName=rs("agent_name")
			tvFFAgentAcct=cLng(rs("agent_no"))
			tvShipperName=rs("shipper_name")
			tvPPO_1 = rs("PPO_1")
			tvCOLL_1 = rs("COLL_1")
			tvPPO_2 = rs("PPO_2")
			tvCOLL_2 = rs("COLL_2")
			
		if tvPPO_1="Y" or tvPPO_2="Y" then
			rs.close
			tvQueueID = GET_QUEUE_ID()
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='S' and hawb_num=N'" & tmpHAWB & "' and bill_to_org_acct=" & tvShipperAcct
            
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=tvQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="S"
				rs("hawb_num")=tmpHAWB
				rs("mawb_num")=tvMAWB
				rs("bill_to")=tvShipperName
				rs("bill_to_org_acct")=tvShipperAcct
				rs("agent_name")=tvFFAgentName
				rs("agent_org_acct")=tvFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		else
			rs.close			
		end if	
		if tvCOLL_1="Y" or tvCOLL_2="Y" then
			tvQueueID = GET_QUEUE_ID()
			SQL="select * from invoice_queue where elt_account_number=" & elt_account_number & " and agent_shipper='A' and mawb_num=N'" & tvMAWB & "' and bill_to_org_acct=" & tvFFAgentAcct
			
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			if rs.EOF then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("queue_id")=tvQueueID
				rs("inqueue_date")=now
				rs("agent_shipper")="A"					
				if dict(tmpAt)=1 then				
					rs("hawb_num")=tmpHAWB
				else
					rs("hawb_num")="CONSOLIDATION"
				end if
				rs("mawb_num")=tvMAWB
				rs("bill_to")=tvFFAgentName
				rs("bill_to_org_acct")=tvFFAgentAcct
				rs("agent_name")=tvFFAgentName
				rs("agent_org_acct")=tvFFAgentAcct
				rs("air_ocean")="A"
				rs("invoiced")="N"
				rs.Update
			end if
			rs.close
		end if
	end if	
	set rs=nothing 
End Sub

if wCount = 0 then wCount = 1 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>New/Edit MAWB</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <base target="_self" />
    <script type="text/jscript" src="../include/CollapsibleRows.js"></script>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style5
        {
            color: #663366;
        }
        
        .style6
        {
            font-size: 10px;
        }
        
        .style9
        {
            color: #c16b42;
            font-size: 12px;
        }
    </style>
    <script type="text/javascript" src="../Include/iMoonCombo.js"></script>
    <script language="javascript" type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../include/JPED.js"></script>
    <script type="text/javascript">

        function setDefulatFreight(){
            alert();
        }
        function showtip(){}

        function checkMaxRows(txtObj){
            var nomoretext=false;
            var str = txtObj.value;
            var allowedRows =txtObj.getAttribute("rows");
            var allowedCols =txtObj.getAttribute("cols");
            var lines = str.split("\r\n");
    	
            if (lines.length > allowedRows)
            {
                if(window.event.keyCode != 8 && (window.event.keyCode <37 || window.event.keyCode >40))
                {
                    alert("Can't add more line!")
                    nomoretext = true;
                    txtObj.value = "";
                    for(var i=0;i<allowedRows;i++)
                    {
                        if(i == allowedRows-1)
                        {
                            txtObj.value = txtObj.value + lines[i];
                        }
                        else
                        {
                            txtObj.value = txtObj.value + lines[i] + "\n";
                        }
                    }
                }
            }
            return !nomoretext;
        }

        var ComboBoxes =  new Array('lstMAWB');

        function validateSalesRep(){

            var txtSalesRep=document.getElementById("txtSalesRep");
            var salesRep=txtSalesRep.value;
            if(salesRep!=""){       
                return true;
            }else{
                return false;
            }
        }

        function SalesRPChange(){}

        function docModified(arg){}

        function textLimit(field, maxlen) {
            if (field.value.length > maxlen + 1){
                alert('Your input has exceeded the maximum character!');
            }
            if (field.value.length > maxlen){
                field.value = field.value.substring(0, maxlen);
            }
        }

        function setChargeableWeight(index){
        
            id1="txtGrossWeight"+index;
            id2="txtDimension"+index;
            id3="txtChargeableWeight"+index;
    	
            gross=document.getElementById(id1).value;	
            dimension=document.getElementById(id2).value;
            if(gross==""){
                gross="0";
            }
            if(dimension==""){
                dimension="0";
            }	
            gross=parseFloat(gross);
            dimension=parseFloat(dimension);
    	
            if(gross > dimension){
                document.getElementById(id3).value=gross;
            }else{
                document.getElementById(id3).value=dimension;
            }
        }
    
        // Start of list change effect //////////////////////////////////////////////////////////////////
    
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var infoObj = document.getElementById("txtShipperInfo");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")

            hiddenObj.value = orgNum;
            infoObj.value = getOrganizationInfo(orgNum);
            txtObj.value = orgName;
        
            $("textarea.txtSignature").value = "AS AGENT FOR " + orgName ;
        
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
            divObj.style.height = "0px";
            docModified(1);
        }
    
        function lstConsigneeNameChange(orgNum,orgName)
        {
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
            docModified(1);
            lstNotifyNameChange(orgNum,orgName);
        }
    
        function lstNotifyNameChange(orgNum,orgName)
        {
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
            docModified(1);
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

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=B&org=" + orgNum;
    
            xmlHTTP.open("GET",url,false); 
            xmlHTTP.send(); 
        
            return xmlHTTP.responseText; 
        }
    
        var dep="";
        var arp="";
        var Unit="";
        var wgt="";
        var airline="";
        var cusAcc="";

        function catchRatingInfo(index){

            airline="<%=vAirline%>"
            dep="<%=vDepCode%>";
            arp="<%=vArrCode%>";
            var tmpStr = "";
            var oSelect;
    	
            if(document.frmMAWB.cCOLL1.checked){
                tmpStr = document.getElementById("lstConsigneeName");
                cusAcc = document.getElementById("hConsigneeAcct")
            }
            else{
                tmpStr = document.getElementById("lstShipperName");
                cusAcc = document.getElementById("hShipperAcct");
            }
            //GETTING WEIGHT 
            if(index==0){
                wgt=document.frmMAWB.txtChargeableWeight0.value;
                Unit=frmMAWB.lstKgLb0.options[document.frmMAWB.lstKgLb0.selectedIndex].value;
    		
                var WGT;
                try{
                    WGT=wgt.split(",");
                } catch(f) {}
    	   
                if(WGT.length>1 && WGT){
                    wgt="";
                    for (var i=0;i<WGT.length;i++){
                        wgt+=WGT[i];
                    }
                }
    	   
            }else{
                wgt=document.frmMAWB.txtChargeableWeight0.value;
                Unit=document.frmMAWB.lstKgLb0.options[document.frmMAWB.lstKgLb0.selectedIndex].value;
                var WGT;
                try{
                    WGT=wgt.split(",");
                } catch(f) {}
    	   
                if(WGT.length>1 && WGT){
                    wgt="";
                    for (var i=0;i<WGT.length;i++){
                        wgt+=WGT[i];
                    }
                }
            }
        }

        function processReqChange(){

            var index=document.getElementById("hCurrentIndex").value;
            var rateId="txtRateCharge"+index;
            var totalId="txtTotal"+index;
      
            if (req.readyState == 4) {	
                if (req.status == 200) {				
                    var result = req.responseText;
                    // document.getElementById("txtSignature").value=result;
                    var numericVar=parseFloat(result);
    		   
                    if(numericVar<0){
                        if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
                            var tVal=numericVar*-1;
                            tVal=Math.round(tVal*1000)/1000;
        	            
                            document.getElementById(totalId).value=tVal.toFixed(2);
                            document.getElementById(rateId).value="N/A";
                        }else{
                            document.getElementById(rateId).value="N/A";
                        }
                        return;
                    }
                    CSRate=parseFloat(result);
                    //result=Math.round(result*1000)/1000;
                    if( document.getElementById(rateId).value!=0){
                        document.getElementById(rateId).value=CSRate.toFixed(2);
                        bCalClick(index); 
                    }
                        // document.getElementById(rateId).value=result;
                    else if(result==0){
                        document.getElementById(rateId).value="N/A";
                    }
                    else{
                        document.getElementById(rateId).value=result;
                    }
                    document.getElementById(rateId).focus();	
    			
                } else {
                    document.getElementById(rateId).value="N/A";
                    document.getElementById(rateId).focus();
                }
            }
        }
    
        function chkDfRateClicked(vInd){
            <% If agent_status = "A" Or agent_status = "T" Then %>
            getIATARate(vInd); 
            getAirLineBuyingRate(); 
            <% Else %>
            alert("Premium subscription is needed for this feature.");
            <% End If %>
            }
        var req ="";
        function getIATARate(index ){
            <% If agent_status = "A" Or agent_status = "T" Then %>
            // change back on 11/2/2007 by joon
            try{
            document.getElementById("hCurrentIndex").value=index;
            catchRatingInfo(index);
            
          
            if (window.ActiveXObject) {
                try {
                    req = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        req = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            } 
            else { return ""; }

            if (req) {
                req.onreadystatechange = processReqChange;
		    
                req.open("GET","/ASP/ajaxFunctions/ajax_iata_rate.asp?Unit=" 
                    + encodeURIComponent(Unit) + "&airline=" 
                    + encodeURIComponent(airline) + "&arp="
                    + encodeURIComponent(arp) + "&dep="
                    + encodeURIComponent(dep) + "&wgt="
                    + encodeURIComponent(wgt), true);	
    	
                req.send();		
            }
        }catch(e){alert(e.message);}
        /*
		var rateId="txtRateCharge"+index;
		var totalId="txtTotal"+index;					
	    document.getElementById("hCurrentIndex").value=index;
	    catchRatingInfo(index);		
		var xmlHTTP;		
		if (window.ActiveXObject) {
		   try {
			xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
		   } catch(e) {
				try {
				 xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
				} catch(e1) {
				 return;
				}
		  }
		} else if (window.XMLHttpRequest) 
		{
			xmlHTTP = new XMLHttpRequest();
		} else {return;}
		
		try {    
				xmlHTTP.open("GET","/ASP/ajaxFunctions/ajax_iata_rate.asp?Unit="+ Unit+ "&airline="+ airline+"&arp="+arp+"&dep="+dep+"&wgt="+wgt, false);	
				xmlHTTP.send(); 		
				var result = xmlHTTP.responseText;	
	   	        var numericVar=parseFloat(result);
						   
		        if(numericVar<0){
		            if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
		                var tVal=numericVar*-1;
	                     tVal=Math.round(tVal*1000)/1000;
        	            
	                    document.getElementById(totalId).value=tVal.toFixed(2);
		                document.getElementById(rateId).value="N/A";
		            }else{
				        document.getElementById(rateId).value="N/A";
				    }
		            return;
		        }
				
				
			    CSRate=parseFloat(result);
				
			    //result=Math.round(result*1000)/1000;
				
				document.getElementById(rateId).value=CSRate;
				
			    if( document.getElementById(rateId).value!=0)
				{			        
				    bCalClick(index); 
					
			    }			 
			    if(CSRate==0)
				{
				    document.getElementById(rateId).value="N/A";
			    }	
		        document.getElementById(rateId).focus();	
		}catch(e){}
		*/
        <% End If %>
        }
	
        function getAirLineBuyingRate(){
            <% If agent_status = "A" Or agent_status = "T" Then %>
            /*
            var CSRate;
            var rateId="txtRateRealCost";
            var totalId="txtTotalRealCost";	
            var xmlHTTP;		
                if (window.ActiveXObject) {
                   try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                   } catch(e) {
                        try {
                         xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch(e1) {
                         return;
                        }
                  }
                } else if (window.XMLHttpRequest) 
                {
                    xmlHTTP = new XMLHttpRequest();
                } else {return;}
                
                try {    
                        xmlHTTP.open("GET","/ASP/ajaxFunctions/ajax_airline_rate.asp?Unit="+ Unit+ "&airline="+ airline+"&arp="+arp+"&dep="+dep+"&wgt="+wgt, false);	
                        xmlHTTP.send(); 		
                        var result = xmlHTTP.responseText;	
                        var numericVar=parseFloat(result);
                                   
                        if(numericVar<0){
                            if(confirm("Minimum charge will be applied.\n Would you like to proceed?")){
                                var tVal=numericVar*-1;
                                 tVal=Math.round(tVal*1000)/1000;
                                
                                document.getElementById(totalId).value=tVal.toFixed(2);
                                document.getElementById(rateId).value="N/A";
                            }else{
                                document.getElementById(rateId).value="N/A";
                            }
                            return;
                        }
                          
                        CSRate=parseFloat(result);
                        document.getElementById(rateId).value=CSRate;				
                        if( document.getElementById(rateId).value!=0)
                        {			        
                           bCalRealCostClick();					
                        }			 
                        if(CSRate==0)
                        {
                            document.getElementById(rateId).value="N/A";
                        }	
                        document.getElementById(rateId).focus();	
                }catch(e){}	  
            */
            <% End If %>
            }
	
        function alertAll(){
            alert("from alert all:"+ dep+"--"+ arp+"--"+ Unit+"--"+ airline+"wgt="+wgt);	
        }
    
        function toggleSub(obj,masterHouse){
    	
            id2="hCount"+masterHouse;	
            count=document.getElementById(id2).value;
            var arr=obj.src.split("/");
    	
            if (arr[arr.length-1]=="Collapse.gif"){
                obj.src="../Images/Expand.gif";
    		
                for(i=0;i<count;i++){
                    id1="tr"+masterHouse+i;
                    document.getElementById(id1).style.display="none";
                }
            }else{	
                obj.src="../Images/Collapse.gif";		
                for(i=0;i<count;i++){			
                    id1="tr"+masterHouse+i;
                    document.getElementById(id1).style.display="";
                }
            }
            //document.getElementById(id1).style.display="none";
        }

        function checkMismatch(){
            if (parseInt("<%=sCount%>")>0){
                if($("input[name=txtTotalPCS]").get(0).value!=document.frmMAWB.txtPiece0.value){
                    if(confirm("PCS mismatch between selected and saved!\n Would you like to proceed anyway? ")){
                        return true;
                    }else{
                        return false;
                    }
                }
            }
            return true	;
        }
    
        function SetCostItems(){
            var vURL = "./new_edit_mawb_cost_items.asp?MAWB=" + encodeURIComponent(document.getElementsByName("hmawb_num").value);
            var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
            var vReturn = showModalDialog(vURL, "popWindow", vWinArg);
        }
    
        function SetCreditNote(){
            var url="";
            var vWinArg = "dialogWidth:600px; dialogHeight:400px; help:no; status:no; scroll:yes; center:yes";
            var vReturn = showModalDialog("../acct_tasks/credit_note_list.asp?TYPE=A&MAWB=" + document.getElementById("hmawb_num").value + "&HAWB=");
            
            if(vReturn >= 0){
                //try{parent.document.frames['topFrame'].changeTopModule("Accounting");}catch(err){}
                if(vReturn == 0){
                    url=
                     "/ASP/acct_tasks/edit_credit_note.asp?"
                     + 
                        "new=yes&MoveType=AIR&MasterOnly=Y&InvType=Agent&AgentID=" 
                        + document.getElementById("hShipperAcct").value 
                        + "&MAWB=" 
                        + document.getElementById("hmawb_num").value 
                        + "&HAWB="
                    ;
                }
                else{
                    url=
                   "/ASP/acct_tasks/edit_credit_note.asp?"
                   + 
                "edit=yes&InvoiceNo=" + vReturn
                    ;
                }
               
                viewPop(url);
            }
        }
        function EditClick(HAWB,MAWB){
            url ="/IFF_MAIN/ASPX/Misc/EditAES.aspx?AESID=&HAWB="+encodeURIComponent(HAWB)+"&MAWB="+encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }

        function openWindowFromSearch(url){
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }
    </script>
</head>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" onload="initCollapsingRows(); <% If NOT chkAvailTab Then Response.write("toggleVisibility('nothing')") ELSE Response.write("expanded('toggleButton')")%>; self.focus(); scrollToObj('<%=Request.QueryString.Item("focus") %>');">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form method="post" name="frmMAWB">
    <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
    <input type="hidden" id="hSONum" name="hSONum" value="<%=vSONum %>" />
    <input type="hidden" id="hPONum" name="hPONum" value="<%=vPONum %>" />
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td width="46%" height="32" align="left" valign="middle" class="pageheader">
                New/Edit MASTER AIR WAYBILL (MAWB)
            </td>
            <td width="54%" align="right" valign="middle">
                <span class="bodyheader style5">FILE NO.</span><input name="txtJobNum" type="text"
                    class="lookup" size="24" value="Search Here" onkeydown="javascript: if(event.keyCode == 13) { lookupFile(); }"
                    onclick="javascript: this.value = ''; this.style.color='#000000'; "><img src="../images/icon_search.gif"
                        name="B1" width="33" height="27" align="absmiddle" style="cursor: hand" onclick="lookupFile()">
            </td>
        </tr>
    </table>
    <div class="selectarea">
        <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="45%" class="select">
                    Select Master AWB No.
                </td>
                <td width="55%" rowspan="2" align="right" valign="bottom">
                    <% If vMAWB <> "" Then %>
                    <div id="print">
                        <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit
                            Note</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <a href="javascript:EditClick('','<%=vMAWB %>');" tabindex="-1">
                            <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED" width="25"
                                height="26" style="margin-right: 10px" />Create AES</a>
                        <img src="/ASP/Images/button_devider.gif" alt="" />
                        <img src="/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" /><a href="javascript:void(0);" id="NewPrintVeiw1"
                            >Master Air Waybill</a>
                    </div>
                    <% End If %>
                </td>
            </tr>
            <tr>
                <td>
                    <!-- //Start of Combobox// -->
                    <%  iMoonDefaultValue = vMAWB %>
                    <%  iMoonComboBoxName =  "lstMAWB" %>
                    <%  iMoonComboBoxWidth =  "160px" %>
                    <script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {	MAWBChange("new"); } 
                    function <%=iMoonComboBoxName%>_OnAddNewPlus() {	} 
                    </script>
                    <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                        position: ; top: ; left: ; z-index: ;">
                        <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                            class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                            value="<%=iMoonDefaultValue%>" />
                        <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                            left: -140px; width: 17px">
                            <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                border="0" />
                        </div>
                    </div>
                    <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                        top: 0; left: 0; width: 17px">
                        <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif" 
                             style="display: none"
                            border="0" />
                    </div>
                    <!-- /End of Combobox/ -->
                    <select name="lstMAWB" id="lstMAWB" class="ComboBox" listsize="20" style="width: 160px;
                        height: 200px; display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                        <% For i=0 to mIndex %>
                        <option value="<%= aMawb(i) %>" <% if aMawb(i)=vMAWB then response.write("selected") %>>
                            <%= aMawb(i)%>
                        </option>
                        <% next %>
                    </select>
                </td>
            </tr>
        </table>
    </div>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
        bgcolor="#A0829C" class="border1px">
        <tr>
            <td>
                <!-- start of scroll bar -->
                <input type="hidden" name="scrollPositionX">
                <input type="hidden" name="scrollPositionY">
                <!-- end of scroll bar -->
                <input type="hidden" name="hCurrentIndex" id="hCurrentIndex" value="<%= vMAWB %>">
                <input type="hidden" name="hmawb_num" id="hmawb_num" value="<%= vMAWB %>">
                <input type="hidden" name="hAirOrgNum" value="<%= vAirOrgNum %>">
                <input type="hidden" name="hmawbinfo" value="<%= vMAWBInfo %>">
                <input type="hidden" name="hOriginPortID" value="<%= vOriginPortID %>">
                <input type="hidden" name="hDefaultAgentName" value="<%= vDefaultAgentName %>">
                <input type="hidden" name="hDefaultAgentInfo" value="<%= vDefaultAgentInfo %>">
                <input type="hidden" name="hNoItemWC" value="<%= wCount %>">
                <input type="hidden" name="hNoItemOC" value="<%= oIndex %>">
                <input type="hidden" name="hExecution" value="<%= vExecutionDatePlace %>">
                <input type="hidden" name="hTotalHAWB" value="<%= sCount %>">
                <input type="hidden" name="htxtExecute">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td height="24" align="center" valign="middle" bgcolor="E5D4E3" class="bodyheader">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="33%">
                                        &nbsp;
                                    </td>
                                    <td width="34%" align="center" valign="middle">
                                        <img src='../images/button_save_medium.gif' name='bSave' onclick="if (checkMismatch()){bsaveclick()}"
                                            style="cursor: hand">
                                    </td>
                                    <td width="10%" align="right" valign="middle">
                                        <a href="/ASP/air_export/new_edit_mawb.asp">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                            onclick="bCloseClick()" style="cursor: hand" />
                                        <% if mode_begin then %>
                                        <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns &ldquo;clean&rdquo;.');"
                                            onmouseout="hidetip()">
                                            <img src="../Images/button_info.gif" align="bottom" class="bodylistheader">
                                        </div>
                                        <% end if %>
                                    </td>
                                    <td width="10%" align="right" valign="middle">
                                        <img src='../images/button_delete_medium.gif' width='51' height='17' name='bDeleteMAWB'
                                            onclick='DeleteMAWB()' style="cursor: hand">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" bgcolor="#A0829C">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                <tr>
                                    <td width="52%" align="left" valign="top">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                                            class="bodycopy" style="padding-left: 10px">
                                            <tr bgcolor="#f0e7ef">
                                                <td width="66%" height="18" class="bodyheader">
                                                    Shipper's Name and Address
                                                </td>
                                                <td width="34%">
                                                    Shipper's Account No.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <!-- Start JPED -->
                                                    <input type="hidden" id="hShipperAcct" name="hShipperAcct" value="<%=vShipperAcct %>" />
                                                    <div id="lstShipperNameDiv">
                                                    </div>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <input type="text" autocomplete="off" id="lstShipperName" name="lstShipperName" value="<%=vShipperName %>"
                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Shipper','lstShipperNameChange',null,event)"
                                                                    onfocus="initializeJPEDField(this,event);" />
                                                            </td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','Shipper','lstShipperNameChange',null,event)"
                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                            </td>
                                                            <td>
                                                                  <input type='hidden' id='quickAdd_output'/>
                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                    onclick="quickAddClient('hShipperAcct','lstShipperName','txtShipperInfo')" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <textarea id="txtShipperInfo" name="txtShipperInfo" class="monotextarea" cols=""
                                                        rows="5" style="width: 300px"><%=vShipperInfo %></textarea>
                                                    <!-- End JPED -->
                                                </td>
                                                <td valign="top">
                                                    <input name="txtShipperAcct" class="m_shorttextfield" value="<%= vFFShipperAcct %>"
                                                        size="20" preset="maxsize">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3">
                                                <td height="18" class="bodyheader">
                                                    Consignee's Name
                                                </td>
                                                <td>
                                                    Consignee's Account No.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <!-- Start JPED -->
                                                    <input type="hidden" id="hConsigneeAcct" name="hConsigneeAcct" value="<%=vConsigneeAcct %>" />
                                                    <div id="lstConsigneeNameDiv">
                                                    </div>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <input type="text" autocomplete="off" id="lstConsigneeName" name="lstConsigneeName"
                                                                    value="<%=vConsigneeName %>" class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9;
                                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                                                    onkeyup="organizationFill(this,'Consignee','lstConsigneeNameChange',null,event)" onfocus="initializeJPEDField(this,event);" />
                                                            </td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange',null,event)"
                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                            </td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                    onclick="quickAddClient('hConsigneeAcct','lstConsigneeName','txtConsigneeInfo')" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <textarea id="txtConsigneeInfo" name="txtConsigneeInfo" class="monotextarea" cols=""
                                                        rows="5" style="width: 300px"><%=vConsigneeInfo %></textarea>
                                                    <!-- End JPED -->
                                                </td>
                                                <td valign="top">
                                                    <input name="txtConsigneeAcct" class="m_shorttextfield" value="<%= vFFConsigneeAcct %>"
                                                        size="20" preset="maxsize">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader">
                                                <td height="18">
                                                    Issuing Carrier's Agent Name and City
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea name="txtAgentInfo" cols="40" rows="3" wrap="hard" class="monotextarea"
                                                        onkeypress="return checkMaxRows(this);"><%= vAgentInfo %></textarea>
                                                </td>
                                                <td valign="top">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader">
                                                <td height="18">
                                                    Agent's IATA Code
                                                </td>
                                                <td>
                                                    Account No.
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3">
                                                <td height="18" bgcolor="#FFFFFF">
                                                    <input name="txtAgentIATACode" class="shorttextfield" value="<%= vAgentIATACode %>"
                                                        size="17" maxlength="17">
                                                </td>
                                                <td bgcolor="#FFFFFF">
                                                    <input name="txtAgentAcct" class="shorttextfield" value="<%= vAgentAcct %>" size="17"
                                                        maxlength="17">
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3" class="bodyheader">
                                                <td height="18" colspan="2">
                                                    Airport of Departure (Addr. of First Carrier) and Requested Routing
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input name="txtDepartureAirport" class="shorttextfield" value="<%= vDepartureAirport %>"
                                                        size="35" maxlength="35">
                                                </td>
                                                <td>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy" style="padding-left: 10px">
                                                        <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td align="center" class="bodycopy">
                                                                Routing and Destination
                                                            </td>
                                                            <td colspan="4">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                            <td width="15%" height="20">
                                                                &nbsp;<strong>To</strong>
                                                            </td>
                                                            <td width="41%" bgcolor="#f0e7ef">
                                                                &nbsp;<strong>By First Carrier</strong>
                                                            </td>
                                                            <td width="11%">
                                                                To
                                                            </td>
                                                            <td width="11%">
                                                                By
                                                            </td>
                                                            <td width="11%">
                                                                To
                                                            </td>
                                                            <td width="11%" bgcolor="#f0e7ef">
                                                                By
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td>
                                                                <input name="txtTo" class="shorttextfield" value="<%= vTo %>" size="12" maxlength="8">
                                                            </td>
                                                            <td>
                                                                <input name="txtBy" class="shorttextfield" value="<%= vBy %>" size="20" maxlength="20">
                                                            </td>
                                                            <td>
                                                                <input name="txtTo1" class="shorttextfield" value="<%= vTo1 %>" size="8" maxlength="8">
                                                            </td>
                                                            <td>
                                                                <input name="txtBy1" class="shorttextfield" value="<%= vBy1 %>" size="8" maxlength="8">
                                                            </td>
                                                            <td>
                                                                <input name="txtTo2" class="shorttextfield" value="<%= vTo2 %>" size="8" maxlength="8">
                                                            </td>
                                                            <td>
                                                                <input name="txtBy2" class="shorttextfield" value="<%= vBy2 %>" size="8" maxlength="8">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy" style="padding-left: 10px">
                                                        <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td colspan="2" align="center" bgcolor="#f0e7ef">
                                                                For Carrier Only
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                            <td height="20">
                                                                &nbsp;<strong>Airport of Destination</strong><strong></strong>
                                                            </td>
                                                            <td>
                                                                &nbsp;<strong>Flight/Date</strong>
                                                            </td>
                                                            <td>
                                                                &nbsp;<strong>Flight/Date</strong>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" valign="middle">
                                                            <td>
                                                                <input name="txtDestAirport" class="shorttextfield" value="<%= vDestAirport %>" size="24"
                                                                    maxlength="24">
                                                            </td>
                                                            <td>
                                                                <input name="txtFlightDate1" class="shorttextfield" value="<%= vFlightDate1 %>" size="17"
                                                                    maxlength="17">
                                                            </td>
                                                            <td>
                                                                <input name="txtFlightDate2" class="shorttextfield" value="<%= vFlightDate2 %>" size="17"
                                                                    maxlength="17">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="48%" valign="top">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                                            <tr bgcolor="#f0e7ef">
                                                <td width="50%" height="18" class="bodycopy">
                                                    Not Negotiable
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="bodyheader style9">
                                                    <br>
                                                    Air Way Bill
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-bottom: 10px">
                                                    <span class="bodyheader">Issued by</span><br>
                                                    <textarea name="txtIssuedBy" id="txtIssuedBy" cols="30" rows="3" wrap="hard" class="monotextarea"
                                                        onkeypress="javascript:return checkMaxRows(this);"><%= vIssuedBy %></textarea>
                                                </td>
                                            </tr>
                                            <tr bgcolor="#f3f3f3">
                                                <td height="18" class="bodyheader">
                                                    <strong>Notify</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-bottom: 105px">
                                                    <!-- Start JPED -->
                                                    <input type="hidden" id="hNotifyAcct" name="hNotifyAcct" value="<%=vNotifyAcct %>" />
                                                    <div id="lstNotifyNameDiv">
                                                    </div>
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                            <td>
                                                                <input type="text" autocomplete="off" id="lstNotifyName" name="lstNotifyName" value="<%= GetBusinessName(checkBlank(vNotifyAcct,0)) %>"
                                                                    class="shorttextfield" style="width: 285px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Notify','lstNotifyNameChange',null,event)"
                                                                    onfocus="initializeJPEDField(this,event);" />
                                                            </td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstNotifyName','Notify','lstNotifyNameChange',null,event)"
                                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                                    border-left: 0px solid #7F9DB9; cursor: hand;" />
                                                            </td>
                                                            <td>
                                                                <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: hand"
                                                                    onclick="quickAddClient('hNotifyAcct','lstNotifyName','txtBillToInfo')" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <textarea id="txtBillToInfo" name="txtBillToInfo" class="monotextarea" cols="" rows="5"
                                                        style="width: 300px"><%=vAccountInfo %></textarea>
                                                    <!-- End JPED -->
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="18" bgcolor="#f3f3f3">
                                                    <strong class="bodyheader">Reference Number</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="text" name="txtReferenceNumber" class="shorttextfield" size="27" maxlength="32"
                                                        value="<%=checkBlank(vReferenceNumber,GetFileNumber(vMAWB))%>" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                                                    <tr align="center" valign="middle">
                                                                        <td bgcolor="#f0e7ef" class="bodycopy">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td bgcolor="#f0e7ef">
                                                                            &nbsp;
                                                                        </td>
                                                                        <td colspan="2" bgcolor="#f0e7ef">
                                                                            <strong>WT/VAL</strong>
                                                                        </td>
                                                                        <td colspan="2" bgcolor="#f0e7ef">
                                                                            <strong>Other</strong>
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                                        <td>
                                                                            Currency
                                                                        </td>
                                                                        <td>
                                                                            CHGS<br>
                                                                            Code
                                                                        </td>
                                                                        <td>
                                                                            PPD
                                                                        </td>
                                                                        <td>
                                                                            COLL
                                                                        </td>
                                                                        <td>
                                                                            PPD
                                                                        </td>
                                                                        <td>
                                                                            COLL
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" valign="middle">
                                                                            <input name="txtCurrency" type="text" class="shorttextfield" size="4" maxlength="3"
                                                                                value="<%=vCurrency %>" readonly="readonly" onclick="GetOtherCurrency(this,'hCountryCode')"
                                                                                onkeydown="GetOtherCurrency(this,'hCountryCode')" style="cursor: hand" />
                                                                            <input type="hidden" id="hCountryCode" value="<%=AgentCountryCode %>" />
                                                                        </td>
                                                                        <td align="left" valign="middle">
                                                                            <input name="txtChargeCode" class="shorttextfield" value="<%= vChargeCode %>" size="4"
                                                                                maxlength="4">
                                                                        </td>
                                                                        <td align="center" valign="middle">
                                                                            <input name="cPPO1" type="checkbox" <% if vPPO_1="Y" Then response.write("checked") %>
                                                                                onclick="cPPO1Click(this.checked)" value="<%= vPPO_1 %>">
                                                                        </td>
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" name="cCOLL1" value="<%= vCOLL_1 %>" <% if vCOLL_1="Y" Then response.write("checked") %>
                                                                                onclick="cCOLL1Click(this.checked)">
                                                                        </td>
                                                                        <td align="center" valign="middle">
                                                                            <input name="cPPO2" type="checkbox" <% if vPPO_2="Y" Then response.write("checked") %>
                                                                                value="Y" onclick="cPPO2Click(this.checked)">
                                                                        </td>
                                                                        <td align="center" valign="middle">
                                                                            <input type="checkbox" name="cCOLL2" value="Y" <% if vCOLL_2="Y" Then response.write("checked") %>
                                                                                onclick="cCOLL2Click(this.checked)">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td valign="top">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1" class="bodycopy">
                                                                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                                                                        <td width="50%" height="20" class="bodycopy">
                                                                            <strong>Declared Value for Carriage</strong>
                                                                        </td>
                                                                        <td width="50%" class="bodycopy">
                                                                            <strong>Declared Value for Customs</strong>
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="middle">
                                                                        <td>
                                                                            <input name="txtDeclaredValueCarriage" class="shorttextfield" value="<%=vDeclaredValueCarriage %>"
                                                                                maxlength="16" size="12">
                                                                        </td>
                                                                        <td>
                                                                            <input name="txtDeclaredValueCustoms" class="shorttextfield" value="<%= vDeclaredValueCustoms %>"
                                                                                maxlength="16" size="12">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <input name="txtShipperAcct" class="shorttextfield" value="<%= vFFShipperAcct %>"
                                                                    size="20" maxlength="16">
                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                                    <tr>
                                                                        <td height="20" align="left" valign="middle" bgcolor="#f0e7ef">
                                                                            &nbsp;<strong>Amount of Insurance</strong>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" valign="middle">
                                                                            <input name="txtInsuranceAmt" class="shorttextfield" value="<%= vInsuranceAMT %>"
                                                                                size="17" maxlength="16">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td valign="top">
                                                                <span class="bodycopy">INSURANCE - If carrier offers insurance and such insurance is
                                                                    requested in accordance with conditions on reverse hereof indicate amount to be
                                                                    insured in figures in box marked Amount of insurance.</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#FFFFFF">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                                class="bodycopy" style="padding-left: 10px">
                                <tr>
                                    <td height="20" colspan="5" align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                        <strong>Handling Information </strong>(Maximum of 125 characters or 2 lines)
                                    </td>
                                    <td width="35%" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td width="2%" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td width="13%" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" align="left" valign="middle">
                                        <textarea name="txtHandlingInfo" id="txtHandlingInfo" cols="70" rows="2" class="monotextarea"
                                            onkeyup="textLimit(this,127);" wrap="HARD"><%= vHandlingInfo %></textarea>
                                    </td>
                                    <td align="left" valign="top">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="top">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="bottom">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                            <tr>
                                                <td height="20" bgcolor="#FFFFFF" class="bodycopy">
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" rowspan="2" align="left" valign="bottom">
                                        These commodities, technology or software exported from
                                        <%=GetAgentCountry() %>
                                        in accordance with the Export Administration Regulations.<strong> Ultimate destination</strong>
                                        <input name="txtDestCountry" class="m_shorttextfield" value="<%= vDestCountry %>"
                                            size="20" preset="maxsize">
                                    </td>
                                    <td rowspan="2" align="right" valign="bottom">
                                        Diversion contrary to<br>
                                        U.S. law prohibited.
                                    </td>
                                    <td rowspan="2" align="left" valign="top">
                                        &nbsp;
                                    </td>
                                    <td height="20" align="left" valign="middle">
                                        <strong>SCI </strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top" style="height: 18px">
                                        <input name="txtSCI" class="m_shorttextfield" value="<%= vSCI %>" preset="maxsize"
                                            size="14">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td height="2" bgcolor="A0829C">
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                    class="collapsible">
                    <thead>
                        <tr align="center" valign="middle">
                            <th height="22" colspan="13" bgcolor="E5D4E3">
                                <strong><a name="available_hawb"></a><span class="style6"><font color="c16b42">AVAILABLE
                                    HOUSE AWB NO. </font></span></strong>&nbsp;&nbsp;&nbsp;<img src="../Images/Expand.gif"
                                        width="10" height="7" border="0" id="toggleButton" style="cursor: hand" onclick="toggleVisibility('toggleButton')" />
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Clicking on the arrow will open up the area containing all HAWB in the system that are not consolidated to a MAWB.  If you wish to add a HAWB to this Master, find it and click Add on its line.  The flight info will be pushed automatically to the House from the Master.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="middle" class="bodylistheader">
                                </div>
                                <% end if %>
                            </th>
                        </tr>
                        <tr align="left" valign="middle">
                            <th height="1" colspan="13" bgcolor="#FFFFFF">
                            </th>
                        </tr>
                        <tr align="left" bgcolor="#f0e7ef" class="bodyheader">
                            <th width="1">
                            </th>
                            <th width="125" height="20" bgcolor="#f3f3f3">
                                House AWB No.
                            </th>
                            <th width="84" bgcolor="#f3f3f3">
                                Coloadee
                            </th>
                            <th width="196" bgcolor="#f3f3f3">
                                Agent
                            </th>
                            <th width="172" bgcolor="#f3f3f3">
                                Shipper
                            </th>
                            <th width="144" bgcolor="#f3f3f3">
                                Consignee
                            </th>
                            <th width="35" bgcolor="#f3f3f3">
                                Pieces
                            </th>
                            <th width="37" bgcolor="#f3f3f3">
                                GW
                            </th>
                            <th width="39" bgcolor="#f3f3f3">
                                AW
                            </th>
                            <th width="37" bgcolor="#f3f3f3">
                                DW
                            </th>
                            <th width="37" bgcolor="#f3f3f3">
                                CW
                            </th>
                            <th bgcolor="#f3f3f3">
                                &nbsp;
                            </th>
                            <th bgcolor="#f3f3f3">
                                &nbsp;
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for j=0 to aCount-1 %>
                        <tr align="left" valign="middle">
                            <td>
                            </td>
                            <td>
                                <input name="txtaHAWB<%= j %>" type="text" class="d_shorttextfield" readonly value="<%= aHAWB(j) %>"
                                    size="13">
                            </td>
                            <td>
                                <input name="txtaCOLO<%= j %>" type="text" class="d_shorttextfield" readonly value="<%= aCOLO(j) %>"
                                    size="10">
                            </td>
                            <td>
                                <input name="txtaAgent<%= j %>" type="text" class="d_shorttextfield" readonly value="<%= aAgent(j) %>"
                                    size="24">
                            </td>
                            <td>
                                <input name="txtaShipper<%= j %>" type="text" class="d_shorttextfield" readonly value="<%= aShipper(j) %>"
                                    size="21">
                            </td>
                            <td>
                                <input name="txtaConsignee<%= j %>" type="text" class="d_shorttextfield" readonly
                                    value="<%= aConsignee(j) %>" size="21">
                            </td>
                            <td>
                                <input name="txtaPcs<%= j %>" type="text" class="readonlyright" readonly value="<%= aPCS(j) %>"
                                    size="4">
                            </td>
                            <td>
                                <input name="txtaGW<%= j %>" type="text" class="readonlyright" readonly value="<%= aGW(j) %>"
                                    size="7">
                            </td>
                            <td>
                                <input name="txtaAW<%= j %>" type="text" class="readonlyright" readonly value="<%= aAW(j) %>"
                                    size="7">
                            </td>
                            <td>
                                <input name="txtaDW<%= j %>" type="text" class="readonlyright" readonly value="<%= aDW(j) %>"
                                    size="7">
                            </td>
                            <td>
                                <input name="txtaCW<%= j %>" type="text" class="readonlyright" readonly value="<%= aCW(j) %>"
                                    size="7">
                            </td>
                            <td width="1" align="left">
                                &nbsp;
                            </td>
                            <% if not aHAWB(j)="" then %>
                            <td width="252" align="left">
                                <input type="image" src="../images/button_add.gif" width="37" height="17" onclick="AddToHAWB('<%= aHAWB(j) %>',<%= AddELTAcct(j) %>); return false;"
                                    style="cursor: pointer" /><input type="image" src="../images/button_edit.gif" width="37"
                                        height="18" onclick="EditHAWB('<%= aHAWB(j) %>','<%= AddELTAcct(j) %>'); return false;"
                                        style="cursor: pointer; margin-left: 20px" />
                            </td>
                            <% end if %>
                        </tr>
                        <% next %>
                    </tbody>
                </table>
                <table id="selected_hawb" width="100%" border="0" cellpadding="1" cellspacing="0"
                    bgcolor="#FFFFFF" class="bodycopy">
                    <tr align="center" valign="middle">
                        <td height="22" colspan="12" bgcolor="E5D4E3">
                            <strong><span class="style6"><font color="c16b42">SELECTED HOUSE AWB NO.
                                <% if mode_begin then %>
                            </font></span></strong>
                            <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('The House bills listed in this section are consolidated to this Master AWB.  You may click Remove to take them off of the consolidation.');"
                                onmouseout="hidetip()">
                                <img src="../Images/button_info.gif" align="middle" class="bodylistheader">
                            </div>
                            <% end if %>
                            <strong><span class="style6"><font color="c16b42"></font></span></strong>
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td height="1" colspan="12" bgcolor="#FFFFFF">
                        </td>
                    </tr>
                    <tr>
                        <td width="106" height="20" bgcolor="#f0e7ef">
                            <strong>House AWB No.</strong>
                        </td>
                        <td width="19" bgcolor="#f0e7ef">
                            &nbsp;
                        </td>
                        <td width="84" bgcolor="#f0e7ef">
                            <strong>Coloadee</strong>
                        </td>
                        <td width="138" bgcolor="#f0e7ef">
                            <strong>Agent</strong>
                        </td>
                        <td width="142" bgcolor="#f0e7ef">
                            <strong>Shipper</strong>
                        </td>
                        <td width="233" bgcolor="#f0e7ef">
                            <strong>Consignee</strong>
                        </td>
                        <td width="37" bgcolor="#f0e7ef">
                            <strong>Pieces</strong>
                        </td>
                        <td width="37" bgcolor="#f0e7ef">
                            <strong>GW</strong>
                        </td>
                        <td width="37" bgcolor="#f0e7ef">
                            <strong>AW</strong>
                        </td>
                        <td width="37" bgcolor="#f0e7ef">
                            <strong>DW</strong>
                        </td>
                        <td width="79" bgcolor="#f0e7ef">
                            <strong>CW</strong>
                        </td>
                        <td width="213" bgcolor="#f0e7ef">
                            &nbsp;
                        </td>
                    </tr>
                    <% for i=0 to sCount-1 %>
                    <tr align="left" valign="middle">
                        <td>
                            <input name="txtsHAWB<%= i %>" type="text" class="d_shorttextfield" value="<%= sHAWB(i) %>"
                                size="13" readonly>
                        </td>
                        <%GET_SUB_HAWB_INFO(sHAWB(i))%>
                        <td align="center" <% if sIsMaster(i)="Y" then response.Write("style='visibility:visible'") else response.Write("style='visibility:hidden'") end if %>>
                            <img src="../Images/Expand.gif" width="10" height="7" border="0" <% if sHsCount > 0 then response.Write(" style='cursor:hand;visibility:visible'") else response.Write(" style='cursor:hand;visibility:hidden'") end if%>
                                onclick='toggleSub(this,"<%=sHAWB(i)%>")' />
                        </td>
                        <td>
                            <input name="txtsCOLO<%= i %>" type="text" class="d_shorttextfield" value="<%= sCOLO(i) %>"
                                size="12" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsAgent<%= i %>" type="text" class="d_shorttextfield" value="<%= sAgent(i) %>"
                                size="24" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsShipper<%= i %>" type="text" class="d_shorttextfield" value="<%= sShipper(i) %>"
                                size="21" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsConsignee<%= i %>" type="text" class="d_shorttextfield" value="<%= sConsignee(i) %>"
                                size="21" readonly="readonly" />
                            <input name="txtWeightTran<%= i %>" type="hidden" value="<%= aWeightTran(i) %>">
                        </td>
                        <td>
                            <input name="txtsPcs<%= i %>" type="text" class="readonlyright" value="<%= sPCS(i) %>"
                                size="4" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsGW<%= i %>" type="text" class="readonlyright" value="<%= sGW(i) %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <!--<input name="txtsAW<%= i %>" type="text" <% if elt_account_number = cstr(delELTAcct(i)) then response.Write(" class='numberfield'") else  response.Write(" class='d_numberfield' readonly")  end if  %>
                                    value="<%= sAW(i) %>" size="7">-->
                            <input name="txtsAW<%= i %>" type="text" class="readonlyright" value="<%= sAW(i) %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsDW<%= i %>" type="text" class="readonlyright" value="<%= sDW(i) %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtsCW<%= i %>" type="text" class="readonlyright" value="<%= sCW(i) %>"
                                size="7" readonly="readonly" />
                        </td>
                        <% if not sHAWB(i)="" then %>
                        <td width="213" align="left">
                            <input type="image" src="../images/button_edit.gif" width="37" height="18" onclick="EditHAWB('<%= sHAWB(i) %>','<%= delELTAcct(i) %>'); return false;"
                                style="cursor: hand">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="image"
                                    src="../images/button_remove.gif" width="55" height="17" onclick="DeleteHAWB('<%= sHAWB(i) %>','<%= delELTAcct(i) %>'); return false;"
                                    style="cursor: hand">
                        </td>
                        <% end if %>
                    </tr>
                    <%if sIsMaster(i)="Y" then %>
                    <% for k=0 to sHsCount-1 %>
                    <tr id="tr<%=sHAWB(i)&k%>" align="left" style="display: none" valign="middle">
                        <td bgcolor="#f0e7ef">
                            &nbsp;
                        </td>
                        <td bgcolor="#f0e7ef">
                        </td>
                        <td bgcolor="#f0e7ef">
                            <strong>Sub House No.</strong>
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input name="txtsSHShipper<%= k %>" type="text" class="d_shorttextfield" value="<%= sHsHAWB(k) %>"
                                size="21" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input name="txtsSHConsignee<%= k %>" type="text" class="d_shorttextfield" value="<%= sHsShipper(k) %>"
                                size="21" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input name="txtsConsignee<%= k %>" type="text" class="d_shorttextfield" value="<%= sHsConsignee(k) %>"
                                size="21" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input name="txtsPcs<%= k %>" type="text" class="readonlyright" value="<%= sHsPCS(k) %>"
                                size="4" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input type="text" class="readonlyright" value="<%= sHsGW(k) %>" size="7" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input type="text" class="readonlyright" value="<%= sHsAW(k) %>" size="7" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input type="text" class="readonlyright" value="<%= sHsDW(k) %>" size="7" readonly="readonly" />
                        </td>
                        <td bgcolor="#f0e7ef">
                            <input type="text" class="readonlyright" value="<%=sHsCW(k) %>" size="7" readonly="readonly" />
                        </td>
                        <% if not sHsHAWB(k)="" then %>
                        <td bgcolor="#f0e7ef" width="213" align="left">
                            <input type="image" src="../images/button_edit.gif" width="37" height="18" onclick="EditHAWB('<%= sHsHAWB(k) %>','<%= sHdelELTAcct(k) %>'); return false"
                                style="cursor: hand">
                            <input type="hidden" id="hCount<%=sHAWB(i)%>" value="<%=sHsCount%>" />
                        </td>
                        <% end if %>
                    </tr>
                    <%next%>
                    <%end if%>
                    <% next %>
                    <tr align="left" valign="middle">
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td align="right">
                            <strong>Total</strong>
                        </td>
                        <td>
                            <input name="txtTotalPCS" type="text" class="readonlyright" value="<%= sTotalPCS %>"
                                size="4" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtTotalGW" type="text" class="readonlyright" value="<%= sTotalGW %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtTotalAW" type="text" class="readonlyright" value="<%= sTotalAW %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtTotalCW" type="text" class="readonlyright" value="<%= sTotalDW %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td>
                            <input name="txtTotalCW2" type="text" class="readonlyright" value="<%= sTotalCW %>"
                                size="7" readonly="readonly" />
                        </td>
                        <td align="right">
                            &nbsp;
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td align="right">
                            <strong>%</strong>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <input name="txtGWPercent" type="text" class="readonlyright" value="<%= GWPercent %>"
                                size="7" readonly>
                        </td>
                        <td>
                            <input name="txtAWPercent" type="text" class="readonlyright" value="<%= AWPercent %>"
                                size="7" readonly>
                        </td>
                        <td>
                            <input name="txtDWPercent" type="text" class="readonlyright" value="<%= DWPercent %>"
                                size="7" readonly>
                        </td>
                        <td>
                            <% if  Not GWPercent  = 0 or  Not AWPercent  = 0 or  Not DWPercent  = 0 then %>
                            <input name="txtCWPercent" type="text" class="readonlyright" value="100" size="7"
                                readonly>
                            <% end if %>
                        </td>
                        <td align="left" valign="middle">
                            <input type="image" src="../images/button_update.gif" width="51" height="18" onclick="UpdateHouseChange(<%= sCount %>); return false;"
                                style="cursor: hand">
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td height="1" colspan="12" bgcolor="A0829C">
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                    style="padding-left: 10px">
                    <tr align="left" valign="middle" bgcolor="#f0e7ef">
                        <input type="hidden" id="Pieces">
                        <input type="hidden" id="KgLb">
                        <input type="hidden" id="GrossWeight">
                        <input type="hidden" id="ChargeableWeight">
                        <input type="hidden" id="RateCharge">
                        <input type="hidden" id="TotalCharge">
                        <td height="22" colspan="10" align="center" valign="middle" bgcolor="#E5D4E3">
                            <span class="style6"><strong><font color="c16b42">WEIGHT CHARGE</font></strong></span>
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td height="1" colspan="12" bgcolor="#FFFFFF">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="#f0e7ef" class="bodyheader">
                        <td width="114" height="20" bgcolor="#f3f3f3">
                            No of pieces
                        </td>
                        <td width="114" bgcolor="#f3f3f3">
                            Gross Weight
                        </td>
                        <td width="91" bgcolor="#f3f3f3">
                            KG/LB
                        </td>
                        <td width="114" bgcolor="#f3f3f3">
                            Rate Class
                        </td>
                        <td width="161" bgcolor="#f3f3f3">
                            Commodity Item No.
                        </td>
                        <td width="105" bgcolor="#f3f3f3">
                            Chargeable Weight
                        </td>
                        <td width="117" bgcolor="#f3f3f3">
                            Fetch Rate
                        </td>
                        <td width="102" bgcolor="#f3f3f3">
                            Rate/Charge
                        </td>
                        <td width="62" bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                        <td width="171" align="left" bgcolor="#f3f3f3">
                            Total
                        </td>
                    </tr>
                    <% for i=0 to wCount-1 %>
                    <tr align="left" valign="middle">
                        <td>
                            <input name="txtPiece<%= i %>" class="shorttextfield Pieces" id="Pieces" value="<%= aPiece(i) %>"
                                size="5" style="behavior: url(../include/igNumDotChkLeft.htc)" maxlength="4">
                        </td>
                        <td>
                            <input name="txtGrossWeight<%= i %>" class="shorttextfield GrossWeight" id="GrossWeight"
                                value="<%=aGrossWeight(i)%>" size="10" style=""
                                maxlength="7">
                        </td>
                        <td>
                            <select id="KgLb" size="1" class="smallselect KgLb" name="lstKgLb<%= i %>" onchange="ScaleChange(<%= i %>);">
                                <option value="L">LB</option>
                                <option value="K" <% if aKgLb(0)="K" Then response.write("selected") %>>KG</option>
                            </select>
                        </td>
                        <td>
                            <input name="txtRateClass<%= i %>" class="shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                value="<%=aRateClass(i)%>" size="6" maxlength="1">
                        </td>
                        <td>
                            <input name="txtItemNo<%= i %>" class="shorttextfield" value="<%=aItemNo(i)%>" size="12"
                                maxlength="7">
                        </td>
                        <td>
                            <input name="txtChargeableWeight<%= i %>" class="shorttextfield ChargeableWeight"
                                id="ChargeableWeight" style="behavior: url(../include/igNumDotChkLeft.htc)" value="<%= aChargeableWeight(i) %>"
                                size="12" maxlength="7">
                        </td>
                        <td>
                            <img name="chkDfRate" id="chkDfRate" onclick="chkDfRateClicked(<%= i %>);" style="cursor: hand"
                                onmouseup="src='../Images/icon_rate_on.gif'" src='../Images/icon_rate_on.gif'
                                onmousedown="src='../Images/icon_rate_off.gif'" alt="" /><strong><span class="style6"><font
                                    color="c16b42">
                                    <% if mode_begin then %>
                                </font></span></strong>
                            <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('If you have a rate in the rate manager that corresponds to this shipment, clicking this button will import it into the rate field.  Depending on the circumstance, the ports, shipper/consignee, and rate type may all need to match.');"
                                onmouseout="hidetip()">
                                <img src="../Images/button_info.gif" align="middle" class="bodylistheader">
                            </div>
                            <% end if %>
                        </td>
                        <td>
                            <input name="txtRateCharge<%= i %>" class="shorttextfield RateCharge" id="txtRateCharge<%= i %>"
                                style="behavior: url(../include/igNumDotChkLeft.htc)" value="<% if aRateCharge(i)="0" then response.Write("N/A")else response.Write(aRateCharge(i))end if  %>"
                                size="12" maxlength="8">
                        </td>
                        <td>
                            <input type="image" src="../images/button_cal.gif" width="37" height="18" name="bCal<%= i %>"
                                onclick="bCalClick(<%= i %>); return false;" value="Cal" style="cursor: hand">
                        </td>
                        <td width="171" align="left">
                            <input name="txtTotal<%= i %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                class="shorttextfield TotalCharge" id="TotalCharge" value="<%=formatNumber(aTotal(i),2) %>"
                                size="16" maxlength="12">
                        </td>
                    </tr>
                    <% next %>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                    class="bodycopy" style="padding-left: 10px">
                    <tr align="left" valign="middle">
                        <td height="1" colspan="3" bgcolor="#FFFFFF">
                        </td>
                    </tr>
                    <tr bgcolor="#ffffff">
                        <td height="1" colspan="3">
                        </td>
                    </tr>
                    <tr bgcolor="#f0e7ef" style="height: 20px">
                        <td style="width: 250px">
                            <strong>Nature and Quantity of Goods</strong>
                        </td>
                        <td style="width: 250px">
                            <strong>Nature and Quantity of Goods (Continued)</strong>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr align="left" valign="top" bgcolor="#FFFFFF">
                        <td>
                            <textarea name="txtDesc2" cols="22" rows="14" wrap="hard" class="monotextarea" onkeyup="Desc2KeyUp()"><%= vDesc2 %></textarea>
                        </td>
                        <td>
                            <textarea name="txtDesc1" cols="22" rows="9" wrap="hard" class="monotextarea" onkeydown="return checkMaxRows(this);"><%= vDesc1 %></textarea>
                        </td>
                        <td>
                            <% If sCount = 0 And vMAWB <> "" Then %>
                            <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                <tr>
                                    <td>
                                        <strong>ITN Number</strong>
                                    </td>
                                    <td style="width: 10px">
                                    </td>
                                    <td>
                                        <input type="text" class="shorttextfield" name="txtAES" id="txtAES" value="<%=vAES %>"
                                            style="width: 180px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>AES Exemption Statement</strong>
                                    </td>
                                    <td style="width: 10px">
                                    </td>
                                    <td>
                                        <input type="text" class="shorttextfield" name="txtSEDStatement" id="txtSEDStatement"
                                            value="<%=vSEDStmt %>" style="width: 180px" />
                                    </td>
                                </tr>
                            </table>
                            <% End If %>
                        </td>
                    </tr>
                </table>
                <input type="hidden" id="ChargeItem" />
                <input type="hidden" id="ChargeVendor" />
                <input type="hidden" id="ChargeAmt" />
                <input type="hidden" id="ChargeCost" />
                <input type="hidden" id="ItemDesc" />
                <table id="add_oc" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                    class="bodycopy">
                    <tr align="left" valign="middle">
                        <td height="1" colspan="10" bgcolor="A0829C">
                        </td>
                    </tr>
                    <tr align="center" valign="middle" bgcolor="E5D4E3">
                        <td height="22" colspan="10">
                            <strong><font color="c16b42">OTHER CHARGE</font></strong>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy" id="OtherCharge"
                                style="padding-left: 10px">
                                <tr bgcolor="#f0e7ef">
                                    <td width="98" height="20" bgcolor="#f3f3f3">
                                        <strong>Carrier/Agent</strong>
                                    </td>
                                    <td width="98" bgcolor="#f3f3f3">
                                        <strong>Collect/Prepaid</strong>
                                    </td>
                                    <td width="270" bgcolor="#f3f3f3">
                                        <strong>Charge Item</strong>
                                    </td>
                                    <td width="276" bgcolor="#f3f3f3">
                                        <strong>Description</strong>
                                    </td>
                                    <td width="151" bgcolor="#f3f3f3">
                                        <strong>Charge Amount</strong>
                                    </td>
                                    <td width="" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <% for i=0 to oIndex-1 %>
                                <tr id="aRow<%=i %>">
                                    <td>
                                        <select name="lstCarrierAgent<%= i %>" size="1" style="width: 40px" class="smallselect">
                                            <option value="C" selected>C</option>
                                            <option value="A" <% if aCarrierAgent(i)="A" Then response.write("selected") %>>A</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="lstCollectPrepaid<%= i %>" size="1" style="width: 40px" class="smallselect">
                                            <option value="P" selected>P</option>
                                            <option value="C" <% if aCollectPrepaid(i)="C" Then response.write("selected") %>>C</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select id="ChargeItem" size="1" name="lstChargeCode<%= i %>" onchange="ChargeItemChange(<%= i %>)"
                                            class="smallselect ChargeItem" style="width: 270px">
                                            <% for j=0 to chIndex-1 %>
                                            <option value="<%= aChargeItemNo(j) & "-" & aChargeItemDesc(j)  & "-" & aChargeUnitPrice(j) %>"
                                                <% if cInt(aChargeCode(i))=aChargeItemNo(j) then response.write("selected") %>>
                                                <%= aChargeItemNameig(j) %>
                                            </option>
                                            <% next %>
                                        </select>
                                    </td>
                                    <td>
                                        <input id="ItemDesc" name="txtChargeDesc<%= i %>" size="45" value="<%= aDesc(i) %>"
                                            class="shorttextfield ItemDesc">
                                    </td>
                                    <td>
                                        <input id="ChargeAmt" onkeyup="checkDecimalTextMax(this,10);" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                            name="txtChargeAmt<%= i %>" size="12" value="<%if isnumeric(aChargeAmt(i)) then response.Write(formatnumber(aChargeAmt(i),2))else response.Write(formatnumber(aChargeAmt(i),2)) end if   %>"
                                            class="numberalign ChargeAmt">
                                    </td>
                                    <!--            <td width="224" align="left" valign="middle"><img src="../images/button_delete.gif" width="50" height="17" onClick="removeTableRow(<%= i %>)"  style="cursor:hand"></td> -->
                                    <td width="224" align="left" valign="middle">
                                        <input type="image" src="../images/button_delete.gif" width="50" height="17" onclick="DeleteOC(<%= i %>); return false;"
                                            style="cursor: hand">
                                    </td>
                                </tr>
                                <% next %>
                            </table>
                        </td>
                    </tr>
                    <tr align="right" bgcolor="f3f3f3">
                        <td colspan="5" align="left" bgcolor="f3f3f3" style="padding-left: 10px">
                            <input type="image" src="../images/button_addcharge.gif" name="bAddOC" onclick="AddOC(); return false;"
                                style="cursor: hand">
                        </td>
                        <!--            <td width="30%"><img src="../images/button_addcharge.gif" width="113" height="18" type="button" name="bAddOC" onClick="addTableRow()"  style="cursor:hand"></td> -->
                        <td width="21%" align="left">
                            &nbsp;
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                    class="bodycopy">
                    <tr align="center" valign="middle">
                        <td width="43%" height="22" align="left" valign="top" bgcolor="#FFFFFF">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                <tr align="left" valign="middle" bgcolor="E5D4E3">
                                    <td width="50%" height="20" align="center">
                                        <strong>Prepaid</strong>
                                    </td>
                                    <td width="50%" align="center" bgcolor="E5D4E3">
                                        <strong>Collect</strong>
                                    </td>
                                </tr>
                                <tr align="center" valign="middle">
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        Weight Charge
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidWeightCharge" class="readonlyright" readonly="readonly" style="width: 70px"
                                            value="<%if isnumeric(vPrepaidWeightCharge) then response.Write(formatnumber(vPrepaidWeightCharge,2))else response.Write(vPrepaidWeightCharge) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectWeightCharge" class="readonlyright" readonly="readonly" style="width: 70px"
                                            value="<%if isnumeric(vCollectWeightCharge) then response.Write(formatnumber(vCollectWeightCharge,2))else response.Write(vCollectWeightCharge) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center" valign="middle">
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        Valuation Charge
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidValuationCharge" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vPrepaidValuationCharge) then response.Write(formatnumber(vPrepaidValuationCharge,2))else response.Write(vPrepaidValuationCharge) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectValuationCharge" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vCollectValuationCharge) then response.Write(formatnumber(vCollectValuationCharge,2))else response.Write(vCollectValuationCharge) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center" valign="middle">
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        Tax
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidTax" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vPrepaidTax) then response.Write(formatnumber(vPrepaidTax,2))else response.Write(vPrepaidTax) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectTax" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vCollectTax) then response.Write(formatnumber(vCollectTax,2))else response.Write(vCollectTax) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center" valign="middle">
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        Total Other Charges Due Agent
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidOtherChargeAgent" class="readonlyright" readonly="readonly"
                                            style="width: 70px" value="<%if isnumeric(vPrepaidOtherChargeAgent) then response.Write(formatnumber(vPrepaidOtherChargeAgent,2))else response.Write(vPrepaidOtherChargeAgent) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectOtherChargeAgent" class="readonlyright" readonly="readonly"
                                            style="width: 70px" value="<%if isnumeric(vCollectOtherChargeAgent) then response.Write(formatnumber(vCollectOtherChargeAgent,2))else response.Write(vCollectOtherChargeAgent) end if  %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center" valign="middle">
                                    <td colspan="2" bgcolor="#f3f3f3">
                                        Total Other Charges Due Carrier
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidOtherChargeCarrier" class="readonlyright" readonly="readonly"
                                            style="width: 70px" value="<%if isnumeric(vPrepaidOtherChargeCarrier) then response.Write(formatnumber(vPrepaidOtherChargeCarrier,2))else response.Write(vPrepaidOtherChargeCarrier) end if  %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectOtherChargeCarrier" class="readonlyright" readonly="readonly"
                                            style="width: 70px" value="<%if isnumeric(vCollectOtherChargeCarrier) then response.Write(formatnumber(vCollectOtherChargeCarrier,2))else response.Write(vCollectOtherChargeCarrier) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td height="20" bgcolor="#f0e7ef">
                                        <strong>Total Prepaid</strong>
                                    </td>
                                    <td bgcolor="#f0e7ef">
                                        <strong>Total Collect</strong>
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtPrepaidTotal" class="readonlyboldright" readonly="readonly" style="width: 70px"
                                            value="<%if isnumeric(vPrepaidTotal) then response.Write(formatnumber(vPrepaidTotal,2))else response.Write(vPrepaidTotal) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCollectTotal" class="readonlyboldright" readonly="readonly" style="width: 70px"
                                            value="<%if isnumeric(vCollectTotal) then response.Write(formatnumber(vCollectTotal,2))else response.Write(vCollectTotal) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                        Currency Conversion Rates
                                    </td>
                                    <td height="20" align="center" bgcolor="#f3f3f3" class="bodyheader">
                                        CC Charges in Dest. Currency
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        <input name="txtConversionRate" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%=vConversionRate %>" size="14" maxlength="14">
                                    </td>
                                    <td>
                                        <input name="txtCCCharge" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vCCCharge) then response.Write(formatnumber(vCCCharge,2))else response.Write(formatnumber(vCCCharge,2)) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td height="18">
                                        &nbsp;
                                    </td>
                                    <td>
                                        <strong>Charges at Destination</strong>
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        For Carriers Use only at Destination
                                    </td>
                                    <td>
                                        <input name="txtChargeDestination" class="numberfield" style="behavior: url(../include/igNumDotChkLeft.htc);
                                            width: 70px" value="<%if isnumeric(vChargeDestination) then response.Write(formatnumber(vChargeDestination,2))else response.Write(vChargeDestination) end if  %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td height="18">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f0e7ef">
                                        <strong>Total Collect Charges</strong>
                                    </td>
                                </tr>
                                <tr align="center">
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <input name="txtFinalCollect" class="readonlyboldright" value="<% if isnumeric(vFinalCollect) then response.Write(formatnumber(vFinalCollect,2))else response.Write(vFinalCollect) end if   %>"
                                            size="14" maxlength="14">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="57%" valign="top" bgcolor="ffffff">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
                                class="bodycopy">
                                <tr bgcolor="#f0e7ef">
                                    <td width="100%" height="20" colspan="2" bgcolor="#E5D4E3">
                                        <strong>Other Charges</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input name="txtOtherCharge1" class="readonly" value="<%if isnumeric(aOtherCharge(0)) then response.Write(formatnumber(aOtherCharge(0),2))else response.Write(aOtherCharge(0)) end if   %>"
                                            size="75" maxlength="45" readonly="readonly">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input name="txtOtherCharge2" class="readonly" value="<%if isnumeric(aOtherCharge(1)) then response.Write(formatnumber(aOtherCharge(1),2))else response.Write(aOtherCharge(1)) end if   %>"
                                            size="75" maxlength="45" readonly="readonly">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input name="txtOtherCharge3" class="readonly" value="<%if isnumeric(aOtherCharge(2) ) then response.Write(formatnumber(aOtherCharge(2) ,2))else response.Write(aOtherCharge(2) ) end if %>"
                                            size="75" maxlength="45" readonly="readonly">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input name="txtOtherCharge4" class="readonly" value="<%if isnumeric(aOtherCharge(3)) then response.Write(formatnumber(aOtherCharge(3),2))else response.Write(aOtherCharge(3)) end if   %>"
                                            size="75" maxlength="45" readonly="readonly">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input name="txtOtherCharge5" class="readonly" value="<%if isnumeric(aOtherCharge(4)) then response.Write(formatnumber(aOtherCharge(4),2))else response.Write(aOtherCharge(4)) end if   %>"
                                            size="75" maxlength="45" readonly="readonly">
                                    </td>
                                </tr>
                                <tr>
                                    <td height="48" colspan="2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea name="txtSignature" cols="50" rows="2" wrap="hard" class="monotextarea txtSignature"><%= vSignature %></textarea>
                                    </td>
                                    <td align="left" valign="bottom">
                                        <input type="text" name="txtEmpolyee" class="readonly" readonly="readonly" value="<%=GetUserFLName(user_id) %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Signature of Shipper or Agent
                                    </td>
                                    <td>
                                        Prepared by
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20" colspan="2">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <textarea name="txtExecute" cols="50" rows="3" wrap="hard" class="monotextarea"><%= vExecute %></textarea>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" height="1" bgcolor="A0829C">
                        </td>
                    </tr>
                    <tr align="left" valign="middle">
                        <td height="32" colspan="2" bgcolor="#f3f3f3" class="bodycopy">
                            <table width="100%" align="right">
                                <tr>
                                    <td class="bodycopy" align="right">
                                        <strong>Sales Person</strong>
                                        <select name="lstSalesRP" size="1" class="smallselect" style="width: 200px">
                                            <option value="none">Select One</option>
                                            <% For i=0 To SRIndex-1 %>
                                            <option value="<%= aSRName(i)%>" <%
  	                    if vSalesPerson = aSRName(i) then response.write("selected") %>>
                                                <%= aSRName(i) %>
                                            </option>
                                            <%  Next  %>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" height="1" bgcolor="A0829C">
                        </td>
                    </tr>
                    <tr align="center" valign="middle">
                        <td height="22" colspan="2" bgcolor="E5D4E3">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="26%">
                                        &nbsp;
                                    </td>
                                    <td width="49%" align="center" valign="middle">
                                        <input type="image" src="../images/button_save_medium.gif" name="bSave" onclick="if (checkMismatch()){bsaveclick()}; return false;"
                                            style="cursor: hand">
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <a href="/ASP/air_export/new_edit_mawb.asp">
                                            <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" style="cursor: hand"></a>
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <input type="image" src='../images/button_delete_medium.gif' width='51' height='17'
                                            name='bDeleteMAWB' onclick='DeleteMAWB(); return false;' style="cursor: hand">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="32" align="right" valign="bottom">
                <% If vMAWB <> "" Then %>
                <div id="print">
                    <a href="javascript:;" onclick="SetCostItems(); return false;" tabindex="-1">Cost Items</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <a href="javascript:;" onclick="SetCreditNote(); return false;" tabindex="-1">Credit
                        Note</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <a href="javascript:EditClick('','<%=vMAWB %>');" tabindex="-1">
                        <img src="/ASP/Images/icon_createhouse.gif" alt="Click here to create SED" width="25"
                            height="26" style="margin-right: 10px" />Create AES</a>
                    <img src="/ASP/Images/button_devider.gif" alt="" />
                    <img src="/ASP/Images/icon_printer_preview.gif" align="absbottom" alt="" /><a href="javascript:;" id="NewPrintVeiw2"
                        >Master Air Waybill</a>
                </div>
                <% End If %>
            </td>
        </tr>
    </table>
    <br />
    </form>
</body>
<script type="text/jscript">
    function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
    function bCloseClick() {
        var mawb = '<%=vMAWB%>';
        if (mawb == '') {
            alert('Please select a Master AWB No.');
            return false;
        }
        if (!confirm("Do you really want to close this Master AWB No. : " + mawb + "?")) { return false; }
        if (close_mawb(mawb)) {
            alert("Master AWB No. : " + mawb + " was closed successfully.");
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
            } catch (e) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (f) {
                    return true;
                }
            }
        } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } else { return true; }

        var url = "/ASP/ajaxFunctions/ajax_mawb_close.asp?n=" + encodeURIComponent(mawb);

        try {
            xmlHTTP.open("get", url, false);
            xmlHTTP.send();
            var sourceCode = xmlHTTP.responseText;
            if (sourceCode) {
                if (trim(sourceCode) == 'ok') {
                    return true;
                }
                else {
                    switch (trim(sourceCode)) {
                        default:
                            break;
                    }
                    return false;
                }
            }

        } catch (e) { return false; }
    }
</script>
<script type="text/javascript" src="/ASP/ajaxFunctions/ajax_ig_call_db.js"></script>
<script type="text/jscript">
    function search_mawb(jobNo) {

        if (window.ActiveXObject) {
            try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (f) {
                    return true;
                }
            }
        } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } else { return true; }

        var url = "/ASP/ajaxFunctions/ajax_mawb_search.asp?j=" + encodeURIComponent(jobNo);

        try {
            xmlHTTP.open("get", url, false);
            xmlHTTP.send();
            var sourceCode = xmlHTTP.responseText;
            if (sourceCode) {
                if (sourceCode == 'no') {
                    return false;
                } else {
                    return sourceCode;
                }
            }
        } catch (e) { return false; }

    }

    function lookupFile() {
        var mIndex, existMJob, mFile, last_Chr10_Index, MAWB;
        var JobNo = document.frmMAWB.txtJobNum.value.toUpperCase();
        var fileno = document.frmMAWB.txtJobNum.value;
        if (JobNo.trim() != "" && fileno != "Search Here") {
            existMJob = false;
            MAWB = search_mawb(JobNo);
            if (MAWB != false)
                existMJob = true;

            if (existMJob) {
                document.frmMAWB.txtJobNum.value = "";
                document.frmMAWB.action = "new_edit_mawb.asp?Edit=yes&mawb=";
+encodeURIComponent(MAWB) + "&WindowName=" + window.name;
                document.frmMAWB.method = "POST";
                document.frmMAWB.target = "_self";
                frmMAWB.submit();
            }
            else
                alert("File# " + JobNo + " does not exist.");

        }
        else
            alert("Please enter a File No!");

    }
    
/////////////////////////////
function bsaveclick(){
/////////////////////////////
    var To0=document.frmMAWB.txtTo.value;
    var To1=document.frmMAWB.txtTo1.value;
    var To2=document.frmMAWB.txtTo2.value;
    if (To0.length>3 || To1.length >3 || To2.length >3 ){
	    alert( "The To Port has three characters!");
	    return;
    }

    var sindex=document.frmMAWB.lstMAWB.selectedIndex;

    if (sindex == 0 ){
       alert( "Please select a MAWB");
        return;
    }
    var OK=true;

    if ( document.frmMAWB.hNoItemWC.value != "") {
        var WC=parseInt(document.frmMAWB.hNoItemWC.value);
        var OC = parseInt(document.frmMAWB.hNoItemOC.value);
        if (sindex>0 ){
	        for (var i=0 ;i< WC; i++){
		        if (!IsNumeric($("input.Pieces").get(i).value)) {
			        alert( "Please enter a Numeric Value for PIECEs!");
			        OK=false;
			        return false;
                }
		        else if (!IsNumeric($("input.GrossWeight").get(i).value)) {
			        alert( "Please enter a Numeric Value for GROSS WEIGHT!");
			        OK=false;
			        return false;
		        }
		        else if (!IsNumeric($("input.ChargeableWeight").get(i).value)) {
			        alert( "Please enter a Numeric Value for CHARGEABLE WEIGHT!");
			        OK=false;
			        return false;
		        }
		        else if ($("input.RateCharge").get(i).value!="" 
                        && !IsNumeric($("input.RateCharge").get(i).value)) {
			        if ($("input.RateCharge").get(i).value!="N/A" ) 
				        $("input.RateCharge").get(i).value=0;
			        else{
				        alert( "Please enter a Numeric Value for RATE/CHARGE!");
				        OK=false;
			            return false;
			        }
		        }
		        else if ($("input.TotalCharge").get(i).value!="" 
                        && !IsNumeric($("input.TotalCharge").get(i).value)) {
			        alert("Please enter a Numeric Value for TOTAL CHARGE!");
			        OK=false;
			        return false;
		        }

		        var Scale=$("select.KgLb").get(i).value;
//		        if (Scale!=$("select.KgLb>option").get(0).value ){
//			        alert( "UOM mismatch!");
//			        OK=false;
//			        return false;
//		        }
	        }
	        if (OK) {
		        for (var i=0 ;i< OC;i++){
			        var cAmt=$("input.ChargeAmt").get(i).value;
			        if ( cAmt!="" && !IsNumeric(cAmt)){
				        alert( "Please enter a Numeric Value for CHARGE AMT!");
				        OK=false;
			           return false;
			        }
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtPrepaidValuationCharge.value!="" 
                    && !IsNumeric(document.frmMAWB.txtPrepaidValuationCharge.value) ){
			        alert ("Please enter a Numeric Value for VALUATION CHARGE!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtCollectValuationCharge.value!="" 
                    && !IsNumeric(document.frmMAWB.txtCollectValuationCharge.value)){
			        alert ("Please enter a Numeric Value for VALUATION CHARGE!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtPrepaidTax.value!="" 
                    && !IsNumeric(document.frmMAWB.txtPrepaidTax.value)){
			        alert( "Please enter a Numeric Value for TAX!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtCollectTax.value!="" 
                    && !IsNumeric(document.frmMAWB.txtCollectTax.value)){
			        alert( "Please enter a Numeric Value for TAX!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtConversionRate.value!="" 
                    && !IsNumeric(document.frmMAWB.txtConversionRate.value) ){
		            alert("Please enter a Numeric Value for CONVERSION RATE!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtCCCharge.value!="" && !IsNumeric(document.frmMAWB.txtCCCharge.value) ){
			        alert( "Please enter a Numeric Value for CC CHARGE!");
			        OK=false;
		        }
	        }
	        if (OK) {
		        if (document.frmMAWB.txtChargeDestination.value!="" 
                    && !IsNumeric(document.frmMAWB.txtChargeDestination.value)) {
			        alert("Please enter a Numeric Value for DESTINATION CHARGE!");
			        OK=false;
		        }
	        }
	        if (OK) {
                var sss=document.frmMAWB.lstMAWB.selectedIndex;
                var vMAWB=document.frmMAWB.lstMAWB.item(sss).text;

                if( !CHECK_IV_STATUS( vMAWB ) )
	                return false;

		        document.frmMAWB.action="new_edit_mawb.asp?Save=yes&MAWB=" 
		            + encodeURIComponent(vMAWB) + "&WindowName=" + window.name;
		        document.frmMAWB.method="POST";
		        document.frmMAWB.target = "_self";
		        frmMAWB.submit();
	        }
        }
        else
	        alert( "Please select a MAWB number!");
    }
}

</script>
<script type="text/vbscript">


/////////////////////////////
Sub Lookup() ' Never used
/////////////////////////////
DIM mIndex, existMAWB,MAWB
 mIndex = "<%=mIndex%>"
	MAWB=UCase(document.frmMAWB.txtSMAWB.value)

	if NOT TRIM(MAWB) = "" then
		existMAWB = false
		For i=0 to mIndex
			if MAWB = UCase(document.frmMAWB.lstMAWB.item(i).text) then
				existMAWB = true
				exit for
			end if
		Next	
		
		if existMAWB then
				fillMAWBInfo(i)
				document.frmMAWB.action="new_edit_mawb.asp?Edit=yes&mawb=" _
				    & encodeURIComponent(document.frmMAWB.txtSMAWB.value)  & "&WindowName=" & window.name
				document.frmMAWB.method="POST"
				document.frmMAWB.target = window.name
				document.frmMAWB.txtsMAWB.value = ""
				frmMAWB.submit()
		else
				msgbox "MAWB # " & MAWB & " does not exist."
		end if		
	END IF
End Sub


Sub bMAWBClick()
	MAWB=document.frmMAWB.txtMAWB.value
	document.frmMAWB.action="new_edit_mawb.asp?mawb=" & encodeURIComponent(MAWB) & "&WindowName=" & window.name
	document.frmMAWB.method="POST"
	document.frmMAWB.target = window.name
	frmMAWB.submit()
End Sub

Sub bShipperNameClick()
	document.frmMAWB.action="new_edit_mawb.asp?sname=" & encodeURIComponent(Document.frmMAWB.txtShipperName.Value) & "&WindowName=" & window.name
	document.frmMAWB.method="POST"
	document.frmMAWB.txtShipperInfo.Value=""
	document.frmMAWB.target = window.name
	frmMAWB.submit()
End Sub
Sub bConsigneeNameClick()
	document.frmMAWB.action="new_edit_mawb.asp?coname=" & encodeURIComponent(Document.frmMAWB.txtConsigneeName.Value) & "&WindowName=" & window.name
	document.frmMAWB.method="POST"
	document.frmMAWB.txtConsigneeInfo.Value=""
	document.frmMAWB.target = window.name
	frmMAWB.submit()
End Sub
Sub bNotifyClick()
	document.frmMAWB.action="new_edit_mawb.asp?Notify=" & encodeURIComponent(Document.frmMAWB.txtNotify.Value) & "&WindowName=" & window.name
	document.frmMAWB.method="POST"
	document.frmMAWB.target = window.name
	frmMAWB.submit()
End Sub

Sub fillMAWBInfo(sindex)
vMAWB=Document.frmMAWB.lstMAWB.item(sindex).text
mInfo=Document.frmMAWB.lstMAWB.item(sindex).value

if not Document.frmMAWB.lstMAWB.item(sindex).text="Select One" then
	Document.frmMAWB.hmawb_num.Value=Document.frmMAWB.lstMAWB.item(sindex).text
else
	Document.frmMAWB.hmawb_num.Value=""
end if
mCarrierDesc=""

if not mInfo="" then
    // Modified by Joon 6/20/2007 service level
    pos=InStr(mInfo,chr(10))
    mServiceLevel=Left(mInfo,pos-1)
    mInfo=Mid(mInfo,pos+1,1000)
    //////////////////////////////////////////////
	pos=InStr(mInfo,chr(10))
	mAirOrgNum=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirportCode=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mTo2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mBy2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestAirport=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate1=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mFlightDate2=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mCarrierDesc=Left(mInfo,pos-1)	
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mExportDate=Left(mInfo,pos-1)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDestCountry=Left(mInfo,pos-1)
	mDepartureState=Mid(mInfo,pos+1,1000)
	mInfo=Mid(mInfo,pos+1,1000)
	pos=InStr(mInfo,chr(10))
	mDepartureState=Left(mInfo,pos-1)
	mFile=Mid(mInfo,pos+1,1000)
	AccountInfo=document.frmMAWB.txtBillToInfo.Value
	pos=0
	pos=instr(AccountInfo,"FILE#")
	if pos>0 then
		pos=instr(AccountInfo,chr(10))
		if pos>0 then
			AccountInfo="FILE# " & mFile & chr(10) & Mid(AccountInfo,pos+1,200)
		else
			AccountInfo="FILE# " & mFile
		end if
	else
		pos=instr(AccountInfo,"NOTIFY:")
		if pos>0 then
			AccountInfo="FILE# " & mFile & chr(10) & Mid(AccountInfo,pos,200)
		else
			AccountInfo="FILE# " & mFile
		end if
	end if
else
	mDepartureAirportCode=""
	mDepartureAirport=""
	mTo=""
	mBy=""
	mTo1=""
	mBy1=""
	mTo2=""
	mBy2=""
	mDestAirport=""
	mFlightDate1=""
	mFlightDate2=""
	mCarrierDesc=""
	mExportDate=""
	mDestCountry=""
	mDepartureState=""
	mFile=""
end if
//'document.frmMAWB.txtBillToInfo.Value=AccountInfo & "^^"
document.frmMAWB.hAirOrgNum.Value=mAirOrgNum
document.frmMAWB.hOriginPortID.Value=mDepartureAirportCode
document.frmMAWB.txtDepartureAirport.Value=mDepartureAirport
document.frmMAWB.txtTo.Value=mTo
document.frmMAWB.txtBy.Value=mBy
document.frmMAWB.txtTo1.Value=mTo1
document.frmMAWB.txtBy1.Value=mBy1
document.frmMAWB.txtTo2.Value=mTo2
document.frmMAWB.txtBy2.Value=mBy2
document.frmMAWB.txtDestAirport.Value=mDestAirport
document.frmMAWB.txtFlightDate1.Value=mFlightDate1
document.frmMAWB.txtFlightDate2.Value=mFlightDate2
document.frmMAWB.txtDestCountry.value=mDestCountry
IssuedBy=mCarrierDesc
document.frmMAWB.txtIssuedBy.Value=mCarrierDesc

Agent= document.frmMAWB.txtExecute.Value

pos=0
pos=instr(Agent,chr(10))
if pos>0 then
	Agent=Mid(Agent,1,pos-1)
end if

pos=instr(mCarrierDesc,chr(10))
if pos>0 then
	Carrier=Mid(mCarrierDesc,1,pos-1)
else
	Carrier=mCarrierDesc
end if

if Mid(Agent,1,11) = "AS AGENT OF" then
	document.frmMAWB.htxtExecute.Value= "AS AGENT OF " & Carrier & chr(10) & "<%= vExecutionDatePlace %>"
else
	document.frmMAWB.htxtExecute.Value= Agent & chr(10) & "AS AGENT OF " & Carrier & chr(10) & "<%= vExecutionDatePlace %>"
	
end if

End sub

</script>
<script type="text/javascript">
    function MAWBChange(arg) {
        var sindex, mInfo, pos;
        var mDepartureAirportCode, mDepartureAirport, mTo, mBy, mTo1, mBy1, mTo2, mBy2, mDestAirport;
        var mFlightDate1, mFlightDate2, IssuedBy, AccountInfo;

        sindex = document.frmMAWB.lstMAWB.selectedIndex;

        if (sindex == 0)
            return;

        var vMAWB = document.frmMAWB.lstMAWB.item(sindex).text;
        // mInfo=Document.frmMAWB.lstMAWB.item(sindex).value

        var mInfo = get_mawb_booking_info(vMAWB);


        if (document.frmMAWB.lstMAWB.item(sindex).text != "Select One")
            document.frmMAWB.hmawb_num.value = document.frmMAWB.lstMAWB.item(sindex).text;
        else
            document.frmMAWB.hmawb_num.value = "";

        var mCarrierDesc = "";
        //
        if (mInfo != "") {
            var pos = mInfo.indexOf('\n');
            var mAirOrgNum = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mDepartureAirportCode = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mDepartureAirport = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mTo = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mBy = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mTo1 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mBy1 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mTo2 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mBy2 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mDestAirport = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mFlightDate1 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mFlightDate2 = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mCarrierDesc = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mExportDate = mInfo.substring(0, pos);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mDestCountry = mInfo.substring(0, pos);
            var mDepartureState = mInfo.substring(pos + 1, 1000);
            mInfo = mInfo.substring(pos + 1, 1000);

            pos = mInfo.indexOf('\n');
            var mDepartureState = mInfo.substring(0, pos);
            mFile = mInfo.substring(pos + 1, 1000);

        }
        else {
            mDepartureAirportCode = "";
            mDepartureAirport = "";
            mTo = "";
            mBy = "";
            mTo1 = "";
            mBy1 = "";
            mTo2 = "";
            mBy2 = "";
            mDestAirport = "";
            mFlightDate1 = "";
            mFlightDate2 = "";
            mCarrierDesc = "";
            mExportDate = "";
            mDestCountry = "";
            mDepartureState = "";
            mFile = "";
        }

        document.frmMAWB.hAirOrgNum.value = mAirOrgNum;
        document.frmMAWB.hOriginPortID.value = mDepartureAirportCode;
        document.frmMAWB.txtDepartureAirport.value = mDepartureAirport;
        document.frmMAWB.txtTo.value = mTo;
        document.frmMAWB.txtBy.value = mBy;
        document.frmMAWB.txtTo1.value = mTo1;
        document.frmMAWB.txtBy1.value = mBy1;
        document.frmMAWB.txtTo2.value = mTo2;
        document.frmMAWB.txtBy2.value = mBy2;
        document.frmMAWB.txtDestAirport.value = mDestAirport;
        document.frmMAWB.txtFlightDate1.value = mFlightDate1;
        document.frmMAWB.txtFlightDate2.value = mFlightDate2;
        document.frmMAWB.txtDestCountry.value = mDestCountry;
        IssuedBy = mCarrierDesc;
        document.frmMAWB.txtIssuedBy.value = mCarrierDesc;

        Agent = document.frmMAWB.txtExecute.value;

        pos = 0;
        pos = Agent.indexOf('\n');
        if (pos > 0)
            Agent = Agent.substring(0, pos);

        pos = mCarrierDesc.indexOf('\n');
        if (pos > 0)
            Carrier = mCarrierDesc.substring(0, pos);
        else
            Carrier = mCarrierDesc;

        if (Agent.substring(0, 11) == "AS AGENT OF")
            document.frmMAWB.txtExecute.value = "AS AGENT OF " + Carrier + "\n" + "<%= vExecutionDatePlace %>";
        else
            document.frmMAWB.txtExecute.value = Agent + "\n" + "AS AGENT OF " + Carrier + ", CARRIER" + "\n" + "<%= vExecutionDatePlace %>";

        if (arg == "new") {
            document.frmMAWB.action = "new_edit_mawb.asp?Edit=yes&MAWB=" + encodeURIComponent(vMAWB) + "&WindowName=" + window.name;
            document.frmMAWB.method = "POST";
            document.frmMAWB.target = "_self";
            frmMAWB.submit();
        }

    }


    function cPPO2Click(isChecked) {
        if (!isChecked) {
            document.frmMAWB.cPPO2.value = "";
            document.frmMAWB.cCOLL2.checked = true;
            document.frmMAWB.cCOLL2.value = "Y";
        }
        else {
            document.frmMAWB.cPPO2.value = "Y";
            document.frmMAWB.cCOLL2.checked = false;
            document.frmMAWB.cCOLL2.value = "";
        }
    }

    function cCOLL2Click(isChecked) {
        if (!isChecked) {
            document.frmMAWB.cCOLL2.value = "";
            document.frmMAWB.cPPO2.checked = true;
            document.frmMAWB.cPPO2.value = "Y";
        }
        else {
            document.frmMAWB.cCOLL2.value = "Y";
            document.frmMAWB.cPPO2.checked = false;
            document.frmMAWB.cPPO2.value = "";
        }
    }

    // Modified by Joon on Feb/5/2007 ////////////////////////////////////////////
    function cPPO1Click(isChecked) {
        var DescArray, k, Desc2;
        if (!isChecked) {
            document.frmMAWB.cPPO1.value = "";
            document.frmMAWB.cCOLL1.checked = true;
            document.frmMAWB.cCOLL1.value = "Y";
            Desc2 = document.frmMAWB.txtDesc2.value;

            DescArray = Desc2.split('\n');
            Desc2 = "";
            for (var k = 0; k < DescArray.length; k++) {
                if (DescArray[k].toUpperCase().indexOf("FREIGHT") >= 0)
                    Desc2 = Desc2 + "FREIGHT COLLECT";
                else
                    Desc2 = Desc2 + DescArray[k];

                if (k < DescArray.length)
                    Desc2 = Desc2 + '\n';
            }

            if (Desc2.indexOf("FREIGHT") == 0)
                Desc2 = Desc2 + "FREIGHT COLLECT";

        }
        else {
            document.frmMAWB.cPPO1.value = "Y";
            document.frmMAWB.cCOLL1.checked = false;
            document.frmMAWB.cCOLL1.value = "";
            Desc2 = document.frmMAWB.txtDesc2.value;

            DescArray = Desc2.split('\n');
            Desc2 = "";
            for (var k = 0; k < DescArray.length; k++) {
                if (DescArray[k].toUpperCase().indexOf("FREIGHT") >= 0)
                    Desc2 = Desc2 + "FREIGHT PREPAID"
                else
                    Desc2 = Desc2 + DescArray[k];

                if (k < DescArray.length)
                    Desc2 = Desc2 + '\n';
            }

            if (Desc2.indexOf("FREIGHT") == 0)
                Desc2 = Desc2 + "FREIGHT PREPAID";
        }
        document.frmMAWB.txtDesc2.value = Desc2;
    }
    function cCOLL1Click(isChecked) {
        var DescArray, k, Desc2;
        if (!isChecked) {
            document.frmMAWB.cCOLL1.value = "";
            document.frmMAWB.cPPO1.checked = true;
            document.frmMAWB.cPPO1.value = "Y";
            Desc2 = document.frmMAWB.txtDesc2.value;
            DescArray = Desc2.split('\n');
            Desc2 = "";
            for (var k = 0; k < DescArray.length; k++) {
                if (DescArray[k].toUpperCase().indexOf("FREIGHT") >= 0)
                    Desc2 = Desc2 + "FREIGHT PREPAID";
                else
                    Desc2 = Desc2 + DescArray[k];

                if (k < DescArray.length)
                    Desc2 = Desc2 + '\n';
            }
            if (Desc2.indexOf("FREIGHT") == 0)
                Desc2 = Desc2 + "FREIGHT PREPAID";
        }
        else {
            document.frmMAWB.cCOLL1.value = "Y";
            document.frmMAWB.cPPO1.checked = false;
            document.frmMAWB.cPPO1.value = "";
            Desc2 = document.frmMAWB.txtDesc2.value;
            DescArray = Desc2.split('\n');
            Desc2 = "";
            for (var k = 0; k < DescArray.length; k++) {
                if (DescArray[k].toUpperCase().indexOf("FREIGHT") >= 0)
                    Desc2 = Desc2 + "FREIGHT COLLECT";
                else
                    Desc2 = Desc2 + DescArray[k];

                if (k < DescArray.length)
                    Desc2 = Desc2 + '\n';
            }

            if (Desc2.indexOf("FREIGHT") == 0)
                Desc2 = Desc2 + "FREIGHT COLLECT";
        }
        document.frmMAWB.txtDesc2.value = Desc2;
    }
    function AddToHAWB(addHAWB, addELTAcct) {
        document.frmMAWB.action = "new_edit_mawb.asp?addHAWB=yes&addHAWBNo="
        + encodeURIComponent(addHAWB) + "&addELTAcct="
        + addELTAcct + "&focus=selected_hawb"
        + "&WindowName=" + window.name;
        document.frmMAWB.method = "POST";
        document.frmMAWB.target = "_self";
        frmMAWB.submit();
    }
</script>
<script type="text/vbscript">

Sub LaserClick(Copy)    'Never Used

jPopUpPDF()
sindex=Document.frmMAWB.lstMAWB.Selectedindex
if sindex = 0 then
	exit sub
end if
MAWB=Document.frmMAWB.lstMAWB.item(sindex).text
document.frmMAWB.action="mawb_pdf.asp?mawb=" & encodeURIComponent(MAWB) & "&Copy=" & Copy & "&WindowName=popupNew" 
document.frmMAWB.method="POST"
document.frmMAWB.target="popUpPDF"
frmMAWB.submit()

End Sub
</script>
<script type="text/javascript">
    function Desc2KeyUp() { // converted from vbscript
        var Info = document.frmMAWB.txtDesc2.value;
        var MyArray = Info.split('\n');
        var dd = MyArray.length - 1;
        if (dd > 13) {
            alert("Please go to Other Description session to continue!");
            Info = ""
            for (var i = 0; i <= 13; i++) {
                Info = Info + MyArray[i];
            }
            document.frmMAWB.txtDesc2.value = Info;
            document.frmMAWB.txtDesc1.focus();
        }
        Info = "";
        for (var i = 0; i <= dd; i++) {
            Info = Info + MyArray[i];
        }
        if (Info.length > 260) {
            Info = Info.substring(0, 261);
            document.frmMAWB.txtDesc2.value = Info;
            document.frmMAWB.txtDesc1.focus();
        }
    }

    function DeleteHAWB(HAWB, delELTAcct) {
        document.frmMAWB.action = "new_edit_mawb.asp?DeleteHAWB=yes&dHAWB=" + encodeURIComponent(HAWB)
        + "&delELTAcct=" + delELTAcct + "&focus=selected_hawb" + "&WindowName=" + window.name;
        document.frmMAWB.method = "POST";
        document.frmMAWB.target = "_self";

        frmMAWB.submit();
    }
    function UpdateHouseChange(sCount) {
        alert("Please, save the Master AWB after updating.");
        document.frmMAWB.action = "new_edit_mawb.asp?AdjustWeight=yes&AdjustItemNo=" + sCount + "&focus=selected_hawb" + "&WindowName=" + window.name;
        document.frmMAWB.method = "POST";
        document.frmMAWB.target = "_self";

        frmMAWB.submit();
    }


    function bCalClick(i) {
        var ItemNo = i;
        var Pieces = $("input.Pieces").get(ItemNo).value;
        if (Pieces == "")
            Pieces = 0;
        var ChargeableWeight = $("input.ChargeableWeight").get(ItemNo).value;
        var GrossWeight = $("input.GrossWeight").get(ItemNo).value;
        if (ChargeableWeight == "")
            ChargeableWeight = 0;
        var RateCharge = $("input.RateCharge").get(ItemNo).value;
        if (RateCharge == "")
            RateCharge = 0;

        if (!IsNumeric(Pieces))
            alert("Please enter a numeric value for PIECES");
        else if (!IsNumeric(ChargeableWeight))
            alert("Please enter a numeric value for Chargeable Weight");
        else if (!IsNumeric(RateCharge)) {
            alert("Please enter a numeric value for RateCharge");
            $("input.RateCharge").get(ItemNo).value = "";
        }
        else {
            $("input.GrossWeight").get(ItemNo).value = parseFloat(GrossWeight).toFixed(2);
            $("input.ChargeableWeight").get(ItemNo).value = parseFloat(ChargeableWeight).toFixed(2);
            $("input.RateCharge").get(ItemNo).value = parseFloat(RateCharge).toFixed(2);
            var TotalCharge = parseFloat(RateCharge) * parseFloat(ChargeableWeight);
            $("input.TotalCharge").get(ItemNo).value = (Math.round(TotalCharge)).toFixed(2);
        }
    }
</script>
<script type="text/vbscript">
Sub bCalRealCostClick() 'never used
	Pieces=document.all("Pieces").item(1).Value
	
	if Pieces="" then Pieces=0
	ChargeableWeight=document.all("ChargeableWeight").item(1).Value
	GrossWeight=document.all("GrossWeight").item(1).Value
	if ChargeableWeight="" then ChargeableWeight=0
	
	RateCharge=document.getElementById("txtRateRealCost").value
	if RateCharge="" then RateCharge=0
	
	if IsNumeric(Pieces)=false then
		MsgBox "Please enter a numeric value for PIECES"
	elseif IsNumeric(ChargeableWeight)=false then
		MsgBox "Please enter a numeric value for Chargeable Weight"
	elseif IsNumeric(RateCharge)=false then
		MsgBox "Please enter a numeric value for RateCharge"
		document.all("RateCharge").item(1).Value=""
	
	else
		TotalCharge=cDbl(RateCharge)*cDbl(ChargeableWeight)
		document.getElementById("txtTotalRealCost").value=formatNumber(Round(TotalCharge,2))
	end if
End Sub
</script>
<script type="text/javascript">
    function AddOC() {
        var NoItem = parseInt(document.frmMAWB.hNoItemOC.value);
        document.frmMAWB.hNoItemOC.value = NoItem + 1;
        document.frmMAWB.action = "new_edit_mawb.asp?AddOC=yes&focus=add_oc&WindowName=" + window.name;
        document.frmMAWB.method = "POST";
        document.frmMAWB.target = "_self";
        frmMAWB.submit();
    }
    function DeleteOC(ItemNo){
        if (document.frmMAWB.hNoItemOC.value>0 
            && parseInt(document.frmMAWB.hNoItemOC.value)!=ItemNo ){
	        if (confirm("Are you sure you want to delete this Other Charge? \r\nContinue?")){
		        document.frmMAWB.action="new_edit_mawb.asp?DeleteOC=yes&dItemNo=" + ItemNo + "&focus=add_oc" + "&WindowName=" + window.name;
		        document.frmMAWB.method="POST";
		        document.frmMAWB.target = "_self";
		        document.frmMAWB.submit();
	        }
        }
    }
</script>
<script type="text/vbscript">


Sub key() 'never used
MAWB=document.frmMAWB.txtMAWB.value
if Window.event.Keycode=13 then
	document.frmMAWB.action="new_edit_mawb.asp?mawb=" & encodeURIComponent(MAWB)  & "&WindowName=" & window.name
	document.frmMAWB.method="POST"
	document.frmMAWB.target = window.name
	frmMAWB.submit()
end if
End Sub
</script>
<script type="text/javascript">
//////////////////////////////////
// Unit_Price by ig 10/21/2006
//////////////////////////////////
function GET_ITEM_UNIT_PRICE ( tmpBuf ){
    var ItemUnitPrice,pos;

    ItemUnitPrice=0;

    pos=tmpBuf.indexOf("-");
    if (pos>0 )
	    ItemUnitPrice=tmpBuf.substring(pos+1,200);

	return ItemUnitPrice;

}
function SET_UNIT_PRICE( obj, val ){
	obj.value = parseFloat(val).toFixed(2);//  FormatNumber(val,2,,,0)
}
function ChargeItemChange(index){
    var AgentName,ItemDesc;
    var sindex= $("select.ChargeItem").get(index).selectedIndex;// Document.all("ChargeItem").item(index+1).Selectedindex
    var ItemInfo=$("select.ChargeItem>option").get(sindex).value;

    var pos=ItemInfo.indexOf("-");
    if (pos>=0 )
	    ItemDesc=ItemInfo.substring(pos+1,200);

    ///////////////////////////////
    // Unit_Price by ig 10/21/2006
	var ItemUnitPrice = GET_ITEM_UNIT_PRICE(ItemDesc);

    pos=ItemDesc.indexOf("-");
    if (pos>=0 )
	    ItemDesc=ItemDesc.substring(0,pos-1);
    ///////////////////////////////
    if (ItemDesc == "-0" )
     ItemDesc = "";

    if (sindex>=0 ){
	    $("input.ItemDesc").get(index).value=ItemDesc.trim();
	    // Unit_Price by ig 10/21/2006
	    SET_UNIT_PRICE ($("input.ChargeAmt").get(index) , ItemUnitPrice );
	}
    else
	     $("input.ItemDesc").get(index).value="";

}
function CHECK_IV_STATUS( tvMAWB ){
    if (tvMAWB == "" || tvMAWB == "0" ){
	    return true;
    }

    var IVstrMSG = "<%=IVstrMsg%>";
    if (IVstrMSG != ""){
	    if (confirm("Invoice No. " + IVstrMSG + " for MAWB#:" + tvMAWB + " was processed already.\r\nDo you want to continue?")) 
		    return true;
	    else
		    return false;
    }
    return true;
}

function DeleteMAWB(){
    var sindex=document.frmMAWB.lstMAWB.selectedIndex;
    if (sindex>0 ){
	    var MAWB=document.frmMAWB.lstMAWB.item(sindex).text;
	    if (confirm("Do you really want to delete MAWB " + MAWB + "? \r\nContinue?")) {	
		    if (!CHECK_IV_STATUS(MAWB))
			    return;

		    document.frmMAWB.action="new_edit_mawb.asp?DeleteMAWB=yes&MAWB=" + encodeURIComponent(MAWB) + "&WindowName=" +window.name;
		    document.frmMAWB.method="POST";
		    document.frmMAWB.target = "_self";
		    frmMAWB.submit();
	    }
    }
}

function EditHAWB(HAWB,COLODee){
	if (parseFloat(COLODee).toFixed(0)!=parseFloat(<%= elt_account_number %>).toFixed(0) )
	    window.location.href = "view_print.asp?hawb=" + encodeURIComponent(HAWB) + "&sType=house&COLODee=" + encodeURIComponent(COLODee);
	else
	  //  window.location.href = "new_edit_hawb.asp?WindowName=<%=WindowName %>&HAWB=" + encodeURIComponent(HAWB);
	    window.top.location.href = "/AirExport/HAWB/WindowName=<%=WindowName %>&HAWB=" + encodeURIComponent(HAWB);
}

function ScaleChange(ItemNo){
	var Scale=$("select.KgLb").get(ItemNo).value;
	var GW=$("input.GrossWeight").get(ItemNo).value;
	var CW=$("input.ChargeableWeight").get(ItemNo).value;
	var RateCharge = $("input.RateCharge").get(ItemNo).value;

	if (GW!="")
    	GW=parseFloat(GW);
	else
		GW=0;

	if (CW!="")
		CW=parseFloat(CW);
	else
		CW=0;

	if (Scale == "K" ){
		GW = GW / 2.20462262;
		CW = CW / 2.20462262;
        if(IsNumeric(RateCharge) )
            RateCharge=parseFloat(RateCharge * 2.20462262).toFixed(2);
    }
	else{
		GW = GW * 2.20462262;
		CW = CW * 2.20462262;
        if(IsNumeric(RateCharge) )
            RateCharge=parseFloat(RateCharge/ 2.20462262).toFixed(2);
	}

	if (IsNumeric(RateCharge) ){
        
		$("input.RateCharge").get(ItemNo).value = RateCharge;
		$("input.TotalCharge").get(ItemNo).value = (Math.round((CW * RateCharge))).toFixed(2);  
	}

	$("input.GrossWeight").get(ItemNo).value = parseFloat(GW).toFixed(2); 
	$("input.ChargeableWeight").get(ItemNo).value = parseFloat(CW).toFixed(2); 
	
}


function NewPrintVeiw(){
    var props,HAWB,sindex,MAWB;
    sindex = document.frmMAWB.lstMAWB.selectedIndex;
    MAWB = document.frmMAWB.lstMAWB.item(sindex).text;
    cMAWB= frmMAWB.hmawb_num.value;

    if (MAWB != ""  && MAWB != "Select One" ){
        props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
        window.open ("view_print.asp?sType=master&mawb=" + encodeURIComponent(MAWB), "popUpWindow", props);
    }
    else if (cMAWB != ""  ){
        props = "scrollBars=no,resizable=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes,width=880,height=650";
        window.open ("view_print.asp?sType=master&mawb=" + encodeURIComponent(cMAWB), "popUpWindow", props);
    }
    else{
        alert("Please, select Master AWB NO. to view PDF");
	}
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
                   opener.top.location.href="/AirExport/MAWB/"+window.location.href.split("?")[1];
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


<script type="text/vbscript">


Sub MenuMouseOver() 'never used
  document.frmMAWB.lstMAWB.style.visibility="hidden"
End Sub
Sub MenuMouseOut() 'never used
  document.frmMAWB.lstMAWB.style.visibility="visible"
End Sub

Function makeMsgBox(tit,mess,icon,buts,defs,mode) 'never used
   butVal = icon + buts + defs + mode
   makeMsgBox = MsgBox(mess,butVal,tit)
End Function

Function setDefaultFreight() 'never used
    RET=makeMsgBox("Check if Air Freight Cost is set","Default Air Freight Cost Item is not set in your Company Profile, would you like to set it before you move on?",48,4,0,4096)
    if RET = 6 THEN window.location="/ASP/SITE_ADMIN/co_config.asp?DAFCost=Y"  end if
End Function

</script>
<script type="text/javascript">
    var fBook = "<%= fBook %>";

    if (fBook == "yes")
        MAWBChange("");

</script>
<% if MinApplied <> -1  then 
	'response.Write("<script language='javascript'></script>")
	end if 
%>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
   
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
