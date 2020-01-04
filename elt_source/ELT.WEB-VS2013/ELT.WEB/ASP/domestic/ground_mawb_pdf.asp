<%@ LANGUAGE = VBScript %>
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<%  
    Dim vExportAgentELTAcct,vMAWB,vCOLO,COLODee,Copy,mawbTable,weightTable,OtherTable
    Dim pdfCollectWeightCharge, pdfPrepaidWeightCharge,collect_total,prepaid_total,totalcharge,MawbNoTable
    Dim otherchage(100),otherchargeDesc(100)
    Set mawbTable = Server.CreateObject("System.Collections.HashTable")
    Set weightTable = Server.CreateObject("System.Collections.HashTable") 
    Set MawbNoTable = Server.CreateObject("System.Collections.HashTable")    
    Set OtherTable = Server.CreateObject("System.Collections.ArrayList")
    
    get_all_parameters()
    get_mawb_master()
    get_weight_charge_table()
    get_other_charge_table()
    get_mawb_num_table()   


    show_pdf_result()

    
    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF,logOFile
        
        oFile = Server.MapPath("../template_domestic")
        Set PDF = GetNewPDFObject()
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "ground_awb_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/ground_awb.pdf")
        End If

        Call get_param_values(PDF)
        logOFile = Server.MapPath("../template")
        reader = PDF.AddLogo(logOFile &  "/logo/Logo" & elt_account_number & ".pdf",1)

        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
        bridge = PDF.BinaryImage
        
        Response.Clear
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "attachment; filename=MAWB" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)

        
        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing
        Set bridge = Nothing

    End Sub
    

        
    '// Getting parameters from previous pages
    Sub get_all_parameters
        vExportAgentELTAcct = Request.QueryString("AgentELTAcct")
        vMAWB=Request.QueryString("MAWB")
        vCOLO = checkBlank(Request.QueryString("COLO"),Request("hCOLO"))
        COLODee = Request.QueryString("COLODee")
        Copy = Request.QueryString("Copy")        
    End Sub
   '//get house bill table
    Sub get_mawb_master
        Dim SQL,dataObj
        SQL= "select * from mawb_master where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and is_dome='Y'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set mawbTable = dataObj.GetRowTable(0)
    End Sub
    
    '//get mawb number table
    sub get_mawb_num_table()
        Dim SQL,dataObj
        SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and MAWB_NO = '" & vMAWB & "'"
        
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set MawbNoTable = dataObj.GetRowTable(0)

    End Sub
   '//get weight charge table
    Sub get_weight_charge_table
        Dim dataObj,SQL
        SQL = "SELECT * from mawb_weight_charge where elt_account_number=" & elt_account_number _
            & " AND MAWB_NUM='" & vMAWB & "'"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set weightTable = dataObj.GetRowTable(0)
    End Sub
    
    '// Get List instead of table for other charge
    Sub get_other_charge_table
        Dim dataObj,SQL
        
        SQL = "SELECT * from mawb_other_charge where elt_account_number=" & elt_account_number _
        & " AND MAWB_NUM='" & vMAWB & "' "       
         Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set OtherTable = dataObj.GetDataList
    End Sub

    '//get object    
    Sub get_other_item
        dim j
        For j=1 To OtherTable.Count 
            otherchage(j)=formatAmount(OtherTable(j-1)("Amt_MAWB"))
            otherchargeDesc(j)=formatAmount(OtherTable(j-1)("Charge_Desc"))
        Next 
        if mawbTable("bill_to_party") ="C" or mawbTable("bill_to_party") ="3"  then
            pdfPrepaidWeightCharge=""

                pdfCollectWeightCharge=checkBlank(mawbTable("Total_Weight_Charge_HAWB"),0)

       else
            pdfCollectWeightCharge=""
                pdfPrepaidWeightCharge=checkBlank(mawbTable("Total_Weight_Charge_HAWB"),0)

        end if
    end sub

    '//get all item total 
    Sub get_total
        dim x,tempcharge 

            collect_total= collect_total + FormatNumberPlus(mawbTable("Total_Weight_Charge_HAWB"),2)
            prepaid_total= prepaid_total + FormatNumberPlus(mawbTable("Total_Weight_Charge_HAWB"),2)
            for x=1 To OtherTable.Count
            tempcharge=0
            tempcharge=tempcharge+FormatAmount(cdbl(OtherTable(x-1)("Amt_MAWB") ))
            
            if OtherTable(x-1)("Coll_Prepaid") ="C" then

                    collect_total=collect_total+tempcharge
                    prepaid_total=""
           else
                    prepaid_total=prepaid_total+tempcharge+0
                    collect_total=""
            end if
            next
            totalcharge=formatAmount(checkBlank(mawbTable("shipper_COD"),0))
            totalcharge=totalcharge+collect_total
            
        'end if
    End Sub
    
    
   Sub do_not_show_other
        dim s
        if OtherTable.Count>0 then
        
        for s=1 To OtherTable.Count 
        otherchage(s)= "AS ARRANGED"
        next
        end if

    End Sub
    
    '// show PDF 
    Sub get_param_values(PDF)
        dim how_to_pay,i,collect_weight_Charge,prepail_weight_charge
        '// On Error Resume Next:
        get_other_item()
        get_total()
        how_to_pay=mawbTable("bill_to_party")
        collect_weight_Charge=formatAmount(pdfCollectWeightCharge)
        prepail_weight_charge=formatAmount(pdfPrepaidWeightCharge)
        PDF.SetFormFieldData "BILLNO", vMAWB,0
        PDF.SetFormFieldData "Ser_level", MawbNoTable("service_level_other"),0  
        PDF.SetFormFieldData "DeclaredValueCarriage", mawbTable("Declared_Value_Carriage"),0 
        PDF.SetFormFieldData "ShipperRefN", mawbTable("shipper_reference_num"),0    
        PDF.SetFormFieldData "DATE_G1", mawbTable("Date_Executed"),0
        PDF.SetFormFieldData "CARR_NO", mawbTable("carrier_icc_num"),0        
        
'        If checkBlank(mawbTable("is_agent_house"),"N") = "N" Then
'            PDF.SetFormFieldData "ff_Name",GetAgentName(elt_account_number),0
'            PDF.SetFormFieldData "ffaddress",GetAgentAddress(elt_account_number),0
'        Else
'            PDF.SetFormFieldData "ff_Name", GetBusinessName(mawbTable("customer_acct")), 0
'            Dim customer_info
'            customer_info = GetBusinessInfo(mawbTable("customer_acct"))
'            PDF.SetFormFieldData "ffaddress", Mid(customer_info,InStr(1,customer_info,chr(13))+1,1000) , 0
'        End If

        PDF.SetFormFieldData "carrier_name", GetBusinessName(MawbNoTable("Carrier_acct")),0
        PDF.SetFormFieldData "carrier_info", GetBusinessInfo(MawbNoTable("Carrier_acct")),0

        PDF.SetFormFieldData "THIRD_PARTY_NO", mawbTable("third_party_no"),0
        PDF.SetFormFieldData "shipperInfo", mawbTable("Shipper_Info"),0 
        PDF.SetFormFieldData "ConsigneeInfo", mawbTable("Consignee_Info"),0
        PDF.SetFormFieldData "THIRD_PARTY_BILL", mawbTable("Account_Info"),0
        PDF.SetFormFieldData "DepartureAirport", MawbNoTable("Origin_Port_Location"),0 
        PDF.SetFormFieldData "DestAirport", MawbNoTable("Dest_Port_Location"),0  
        PDF.SetFormFieldData "COD_AMT", formatAmount(checkBlank(mawbTable("cod_amount"),0)),0  
        PDF.SetFormFieldData "InsuranceAMT", checkBlank(mawbTable("Insurance_AMT"),0),0
        PDF.SetFormFieldData "Shipper_COD", formatAmount(checkBlank(mawbTable("shipper_COD"),0)),0
        PDF.SetFormFieldData "HANDLINGINFO", mawbTable("Handling_Info"),0
        PDF.SetFormFieldData "rate1", checkBlank(weightTable("Rate_Charge"),0),0
        PDF.SetFormFieldData "Pieces1", checkBlank(mawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "TotalPiece", checkBlank(mawbTable("Total_Pieces"),0),0
        PDF.SetFormFieldData "CUBICWT", checkBlank(weightTable("cubic_weight"),0),0
        PDF.SetFormFieldData "CUBIC_IN", checkBlank(weightTable("cubic_inches"),0),0
        PDF.SetFormFieldData "GrossWeight1", checkBlank(mawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "TotalGrossWeight", checkBlank(mawbTable("Total_Gross_Weight"),0),0
        PDF.SetFormFieldData "Desc2", checkBlank(mawbTable("Desc2"),""),0                
        PDF.SetFormFieldData "Dimension", mawbTable("dim_text"),0
'// charge table
    if not prepaid_total ="" and not collect_total="" then
       if Copy="SHIPPER" then
           if not mawbTable("Show_Weight_Charge_Shipper") ="Y" then
                if how_to_pay = "S" then
                    
                    prepail_weight_Charge="AS ARRANGED"
                else
                    collect_weight_charge="AS ARRANGED"
                end if
           end if
           if not mawbTable("Show_Collect_Other_Charge_Shipper") ="Y" and not how_to_pay = "S" then
                do_not_show_other()
                totalcharge=""
                prepaid_total="AS ARRANGED"
           elseif not mawbTable("Show_Prepaid_Other_Charge_Shipper") ="Y" and how_to_pay = "S" then
                do_not_show_other()
                totalcharge=""
                prepaid_total="AS ARRANGED"
           end if
       elseif Copy="CONSIGNEE" then
           if not mawbTable("Show_Weight_Charge_Consignee") ="Y" then
                if how_to_pay = "S" then
                    prepail_weight_Charge="AS ARRANGED"
                else
                    collect_weight_charge="AS ARRANGED"
                end if
           end if
           if not mawbTable("Show_Prepaid_Other_Charge_Consignee") ="Y"  and how_to_pay = "S" then
                do_not_show_other()
                totalcharge=""
                collect_total="AS ARRANGED"
           elseif not mawbTable("Show_Collect_Other_Charge_Consignee") ="Y"  and not how_to_pay = "S" then
                do_not_show_other()
                totalcharge=""
                collect_total="AS ARRANGED"
           end if 
       end if
     end if            
        for i=1 To OtherTable.Count 
            PDF.SetFormFieldData "OtherCharge_D"& i ,otherchargeDesc(i),0
            if OtherTable(i-1)("Coll_Prepaid") ="C" then
                PDF.SetFormFieldData "OtherCharge_C"& i ,otherchage(i),0
            elseif OtherTable(i-1)("Coll_Prepaid") ="P" then
                PDF.SetFormFieldData "OtherCharge_P"& i ,otherchage(i),0
            end if
        next
        PDF.SetFormFieldData "CollectWeightCharge",collect_weight_Charge,0
        PDF.SetFormFieldData "PrepaidWeightCharge",prepail_weight_Charge,0
        PDF.SetFormFieldData "prepaidTotal", formatAmount(prepaid_total),0
        PDF.SetFormFieldData "CollectTotal", formatAmount(collect_total),0
        PDF.SetFormFieldData "FinalCollect", totalcharge,0 
        
        if how_to_pay ="3" then
            PDF.SetFormFieldData "3P_C", "X" ,0
        elseif how_to_pay ="C" then
            PDF.SetFormFieldData "C_C", "X" ,0
        else
            PDF.SetFormFieldData "S_C", "X" ,0
        end if 

    End Sub
%>
