
<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<% 

    '// Copied from header.asp /////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'////////////////////////////////////////////////////////////////////////////////
	
    Dim vExportAgentELTAcct,vHAWB,vCOLO,COLODee,Copy,hawbTable,weightTable,OtherTable
    Dim pdfCollectWeightCharge, pdfPrepaidWeightCharge,collect_total,prepaid_total,totalcharge
    Dim otherchage(100),otherchargeDesc(100)
    Set hawbTable = Server.CreateObject("System.Collections.HashTable")
    Set weightTable = Server.CreateObject("System.Collections.HashTable")    
    Set OtherTable = Server.CreateObject("System.Collections.ArrayList")
    
    get_all_parameters()
    get_hawb_master()
    get_weight_charge_table()
    get_other_charge_table()
    get_other_item()    
    get_total()
    show_pdf_result()

    
    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF,logOFile
        
        oFile = Server.MapPath("../template_domestic")
        Set PDF = GetNewPDFObject()
        
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "house_awb_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/house_awb.pdf")
        End If

        Call get_param_values(PDF)
        
        logOFile = Server.MapPath("../template")
        reader = PDF.AddLogo(logOFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile

        Response.Clear
        Response.Expires = 0
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "attachment; filename=HAWB" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing
        Set bridge = Nothing
        
    End Sub
        
    '// Getting parameters from previous pages
    Sub get_all_parameters
        vExportAgentELTAcct = Request.QueryString("AgentELTAcct")
        vHAWB = Request.QueryString("HAWB")
        vCOLO = checkBlank(Request.QueryString("COLO"),Request("hCOLO"))
        COLODee = Request.QueryString("COLODee")
        Copy = Request.QueryString("Copy")
    End Sub
   '//get house bill table
    Sub get_hawb_master
        Dim SQL,dataObj
        SQL = "SELECT a.*,b.customer_acct FROM hawb_master a LEFT OUTER JOIN hawb_master_add b ON " _
            & "(a.elt_account_number=b.elt_account_number AND a.hawb_num=b.hawb_num) " _
            & " WHERE a.elt_account_number=" & elt_account_number _
            & " AND a.hawb_num='" & vHAWB & "' AND a.is_dome='Y'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set hawbTable = dataObj.GetRowTable(0)
    End Sub
   '//get weight charge table
    Sub get_weight_charge_table
        Dim dataObj,SQL
        SQL = "SELECT * from hawb_weight_charge where elt_account_number=" & elt_account_number _
            & " AND HAWB_NUM='" & vHAWB & "'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set weightTable = dataObj.GetRowTable(0)
    End Sub
    
    '// Get List instead of table for other charge
    Sub get_other_charge_table
        Dim dataObj,SQL
        
        SQL = "SELECT * from hawb_other_charge where elt_account_number=" & elt_account_number _
        & " AND HAWB_NUM='" & vHAWB & "' AND invoice_only='N'"        
         Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set OtherTable = dataObj.GetDataList
    End Sub

    '//get object    
    Sub get_other_item
        dim j
        For j=1 To OtherTable.Count 
            otherchage(j)=OtherTable(j-1)("Amt_HAWB") 
            otherchargeDesc(j)=OtherTable(j-1)("Charge_Desc") 
        Next 
        if hawbTable("Charge_Code") ="C" then
            pdfPrepaidWeightCharge=""
            if hawbTable("show_weight_charge_rate") ="N" then
                pdfCollectWeightCharge="AS ARRANGED"
            else
                pdfCollectWeightCharge=checkBlank(hawbTable("Collect_Weight_Charge"),0)
            end if
       else
            pdfCollectWeightCharge=""
            if hawbTable("show_weight_charge_rate") ="N" then
                pdfPrepaidWeightCharge="AS ARRANGED"
            else
                pdfPrepaidWeightCharge=checkBlank(hawbTable("Prepaid_Weight_Charge"),0)
            end if
        end if

    end sub

    '//get all item total 
    Sub get_total
        dim x,tempcharge
        totalcharge=0
        collect_total=0
        prepaid_total=0
        if hawbTable("show_other_charge_rate") ="N" then
            collect_total="AS ARRANGED"
            prepaid_total="AS ARRANGED"
            totalcharge="AS ARRANGED"
            
        else
            collect_total= collect_total + FormatNumberPlus(hawbTable("Collect_Weight_Charge"),2)
            prepaid_total= prepaid_total + FormatNumberPlus(hawbTable("Prepaid_Weight_Charge"),2)
            for x=1 To OtherTable.Count
            tempcharge=0
            tempcharge=tempcharge+FormatAmount(cdbl(OtherTable(x-1)("Amt_HAWB") ))
            if hawbTable("Charge_Code") ="P" then
                    prepaid_total=prepaid_total+tempcharge+0
                    collect_total=""
           else

                    collect_total=collect_total+tempcharge
                    prepaid_total=""
            end if
            next
            
           if hawbTable("Charge_Code") ="P" then
                    collect_total=""
           else
                    prepaid_total=""
            end if
            totalcharge=formatAmount(checkBlank(hawbTable("shipper_cod_amount"),0))
            totalcharge=totalcharge+collect_total


            
        end if
    End Sub
    
    '// show PDF 
    Sub get_param_values(PDF)
        dim S_level,how_to_pay,is_danger_good,i
        
        S_level=hawbTable("service_level")
        if S_level="Select One" then
            S_level=""
        elseif S_level="Other" then
            S_level=hawbTable("service_level_other")
        end if
        how_to_pay=hawbTable("bill_to_party")
        is_danger_good=hawbTable("danger_good")

        On Error Resume Next:
        PDF.SetFormFieldData "CollectWeightCharge",formatAmount(pdfCollectWeightCharge),0
        PDF.SetFormFieldData "PrepaidWeightCharge",formatAmount(pdfPrepaidWeightCharge),0
        PDF.SetFormFieldData "HAWB", vHAWB,0
        PDF.SetFormFieldData "MAWB", hawbTable("MAWB_NUM"),0
        PDF.SetFormFieldData "Ser_level", S_level,0  
        PDF.SetFormFieldData "DeclaredValueCarriage", hawbTable("Declared_Value_Carriage"),0 
        PDF.SetFormFieldData "ShipperRefN", hawbTable("shipper_reference_num"),0    
        PDF.SetFormFieldData "PO_NO", hawbTable("purchase_num"),0
        PDF.SetFormFieldData "DATE_H1", hawbTable("Date_Executed"),0
        
        If checkBlank(hawbTable("is_agent_house"),"N") = "N" Then
            PDF.SetFormFieldData "ff_Name",GetAgentName(elt_account_number),0
            PDF.SetFormFieldData "ffaddress",GetAgentAddress(elt_account_number),0
            PDF.SetFormFieldData "rate1", checkBlank(weightTable("Rate_Charge"),0),0
        Else
            PDF.SetFormFieldData "ff_Name", GetBusinessName(hawbTable("customer_acct")), 0
            Dim customer_info
            customer_info = GetBusinessInfo(hawbTable("customer_acct"))
            PDF.SetFormFieldData "ffaddress", Mid(customer_info,InStr(1,customer_info,chr(13))+1,1000) , 0
        End If
        
        PDF.SetFormFieldData "shipperInfo", hawbTable("Shipper_Info"),0 
        PDF.SetFormFieldData "ConsigneeInfo", hawbTable("Consignee_Info"),0
        PDF.SetFormFieldData "AccountInfo", hawbTable("Account_Info"),0
        PDF.SetFormFieldData "DepartureAirport", hawbTable("Departure_Airport"),0 
        PDF.SetFormFieldData "DestAirport", hawbTable("Dest_Airport"),0  
        PDF.SetFormFieldData "COD_AMT", formatAmount(checkBlank(hawbTable("cod_amount"),0)),0  
        PDF.SetFormFieldData "InsuranceAMT", checkBlank(hawbTable("Insurance_AMT"),0),0
        PDF.SetFormFieldData "Shipper_COD", formatAmount(checkBlank(hawbTable("shipper_cod_amount"),0)),0
        PDF.SetFormFieldData "HANDLINGINFO", hawbTable("Handling_Info"),0
        
        PDF.SetFormFieldData "Pieces1", checkBlank(hawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "TotalPiece", checkBlank(hawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "CUBICWT", checkBlank(weightTable("Dimension"),0),0
        PDF.SetFormFieldData "CUBIC_IN", checkBlank(weightTable("cubic_inches"),0),0
        PDF.SetFormFieldData "GrossWeight1", checkBlank(hawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "TotalGrossWeight", checkBlank(hawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "Desc2", checkBlank(hawbTable("Desc2"),""),0                
        PDF.SetFormFieldData "Dimension", weightTable("Dem_Detail"),0
        PDF.SetFormFieldData "prepaidTotal", formatAmount(prepaid_total),0
        PDF.SetFormFieldData "CollectTotal", formatAmount(collect_total),0
        PDF.SetFormFieldData "FinalCollect",  formatAmount(totalcharge),0        
        
        for i=1 To OtherTable.Count 
        if hawbTable("show_other_charge_rate") ="N" then
            PDF.SetFormFieldData "OtherCharge"& i &"_D","AS ARRANGED",0
            if hawbTable("Charge_Code") ="C" then
                PDF.SetFormFieldData "OtherCharge"& i &"C","AS ARRANGED",0
            else
                PDF.SetFormFieldData "OtherCharge"& i &"P","AS ARRANGED",0
            end if
        
        else
            PDF.SetFormFieldData "OtherCharge"& i &"_D",otherchargeDesc(i),0
            if hawbTable("Charge_Code") ="C" then
                PDF.SetFormFieldData "OtherCharge"& i &"C",formatAmount(otherchage(i)),0
            else
                PDF.SetFormFieldData "OtherCharge"& i &"P",formatAmount(otherchage(i)),0
            end if
        end if
        next

        if how_to_pay ="3" then
            PDF.SetFormFieldData "3P_C", "X" ,0
        elseif how_to_pay ="C" then
            PDF.SetFormFieldData "C_C", "X" ,0
        else
            PDF.SetFormFieldData "S_C", "X" ,0
        end if 
        if is_danger_good="Y" then
            PDF.SetFormFieldData "CHGY", "X" ,0
        else
            PDF.SetFormFieldData "CHGN", "X" ,0
        end if

    End Sub
%>
