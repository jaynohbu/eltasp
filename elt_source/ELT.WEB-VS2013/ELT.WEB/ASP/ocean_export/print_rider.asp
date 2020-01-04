<%@ LANGUAGE = VBScript %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->

<%

Dim rs,SQL
Dim oFile,fso,reader,PDF,bridge
Dim CustomerForm
'---------------------------------------------------------------
DIm vCompanyName,vCompanyInfo,vOrgAct
Dim vMAWB, vHAWB,vOurRef,vMaster
Dim vflightDate, vAirline,vDestination,vFlight
Dim aSubHouseNo,aPiece,aWeight,aConsignee,aDescription,aCollect,aPrepaid,aNDRNAR,aDestination
Dim aPrepaidCollect
Dim vShipper
Dim vTotalPcs,vTotalWeight,vTotalMeasure
Dim aAdditionalInfo
Dim vAgent,vMAWBCreatedDate
'---------------------------------------------------------------
Dim tmpTotalPiece,tmpTotalWeight

'------------------------Main Procedure-------------------------
vMaster=request.QueryString("vMaster")

response.Write("------------")

if not isempty(vMaster) then 
    Call GET_COMPANY_INFO
    Call GET_MASTER_HOUSE_INFO(vMASTER)
    Call GET_MAWB_INFO(vMAWB)   
    Call GET_FROM_EACH_SUB_HOUSE(vMaster)
    Call WRITE_PDF_TO_BROWSER
    Call DESTRUCTOR
end if 
'---------------------------------------------------------------

Sub GET_COMPANY_INFO

    DIM rs,SQL
    SQL="select * from agent where elt_account_number="&elt_account_number
    set rs=Server.CreateObject("ADODB.Recordset")
    rs.Open SQL, eltConn, , , adCmdText
    
    If Not rs.EOF Then
        vCompanyName=rs("business_legal_name")&Chr(13)
        vCompanyInfo=rs("business_address")
      
        vCompanyInfo=vCompanyInfo& Chr(13)
        vCompanyInfo=vCompanyInfo& rs("business_city")
        vCompanyInfo=vCompanyInfo& ", "&rs("business_state")
        vCompanyInfo=vCompanyInfo& " "&rs("business_zip")&Chr(13)
        vCompanyInfo=vCompanyInfo& "TEL: "&rs("business_phone")&Chr(13)
        vCompanyInfo=vCompanyInfo& "FAX: "&rs("business_fax")
    End if 
    rs.Close
	set rs=Nothing
	response.Write("------------GET_COMPANY_INFO"&"<br>")
End Sub 

Sub GET_AGENT_INFO(vOrgAct)

    DIM rs,SQL
    SQL="select * from organization where elt_account_number="&elt_account_number&" and org_account_number="&vOrgAct
    set rs=Server.CreateObject("ADODB.Recordset")
    rs.Open SQL, eltConn, , , adCmdText
    
    If Not rs.EOF Then
        vAgent=rs("dba_name")&Chr(13)
        vAgent=vAgent& rs("business_address")
        
        if not isnull(rs("business_address2")) then 
            vAgent=vAgent& ", "&rs("business_address2") 
        end if 
        if not isnull(rs("business_address3")) then    
            vAgent=vAgent& ", "&rs("business_address3")
        end if
        vAgent=vAgent& Chr(13)
        vAgent=vAgent& rs("business_city")
        vAgent=vAgent& ", "&rs("business_state")
        vAgent=vAgent& " "&rs("business_zip")&Chr(13)
        vAgent=vAgent& "TEL: "&rs("business_phone")&Chr(13)
        vAgent=vAgent& "FAX: "&rs("business_fax")
    End if 
    rs.Close
	set rs=Nothing
	response.Write("------------GET_COMPANY_INFO"&"<br>")
End Sub 			

Sub GET_FROM_EACH_SUB_HOUSE(vHAWB)
    DIM rs,SQL
    tmpTotalPiece=0
    tmpTotalWeight=0   
  
    set rs=Server.CreateObject("ADODB.Recordset")
	Set aSubHouseNo = Server.CreateObject("System.Collections.ArrayList")
	Set aPiece = Server.CreateObject("System.Collections.ArrayList")
	Set aWeight = Server.CreateObject("System.Collections.ArrayList")

	Set aConsignee = Server.CreateObject("System.Collections.ArrayList")
	Set aDescription = Server.CreateObject("System.Collections.ArrayList")
	Set aPrepaidCollect = Server.CreateObject("System.Collections.ArrayList")
	Set aNDRNAR = Server.CreateObject("System.Collections.ArrayList")
    Set aDestination = Server.CreateObject("System.Collections.ArrayList")
	Set aAdditionalInfo = Server.CreateObject("System.Collections.ArrayList")
	
	SQL= "select * from hbol_master where is_sub='Y' and ( elt_account_number = " & elt_account_number & " or coloder_elt_acct="&elt_account_number&") and sub_to_no='" & vHAWB& "'"
	rs.Open SQL, eltConn, , , adCmdText
    seq_id=1
	Do While Not rs.eof And Not rs.bof 
        
        aSubHouseNo.Add checkBlank(rs("sub_to_no").Value,"")&"-"&chr(seq_id+64)
        
        'aSubHouseNo.Add checkBlank(rs("hbol_num").Value,"")
        tmpTotalPiece=checkBlank(rs("pieces"),0)
        tmpTotalWeight=checkBlank(rs("measurement"),0)
       
        
        aPiece.Add checkBlank(tmpTotalPiece,0)
        aWeight.Add checkBlank(tmpTotalWeight,0)
       
        aConsignee.Add checkBlank(rs("Consignee_Name").Value,"")
        aDescription.Add checkBlank(rs("desc3").Value,"")
        
        if checkBlank(rs("weight_cp").Value,"N")="N" then
            aPrepaidCollect.Add "P"
        else 
            aPrepaidCollect.Add "C"
        end if 
        'rs("aes_xtn").Value
        'aNDRNAR.Add checkBlank(rs("").value,"") 
        aDestination.Add checkBlank(rs("dest_country").Value,"") 
        aAdditionalInfo.Add aSubHouseNo(seq_id)&"("& checkBlank(rs("hbol_num").Value,"")&") - "&checkBlank(rs("aes_xtn").Value,"NO SED REQUIRED SECTION 30.55(h) FTSR")
        seq_id=seq_id+1
        rs.MoveNext
	Loop
	rs.Close
	vTotalPcs=0
	vTotalWeight=0
	vTotalMeasure=0
	for i=0 to aPiece.Count-1
	    vTotalPcs=vTotalPcs+aPiece(i)
	    vTotalWeight=vTotalWeight+aWeight(i)
	   
	next 	
	set rs=Nothing
	response.Write("------------GET_FROM_EACH_SUB_HOUSE"&"<br>")
END SUB 



Sub GET_MAWB_INFO(MAWB)
    dim rs, SQL    
    set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "select * from ocean_booking_number where elt_account_number= " & elt_account_number & "  and mbol_num='"&MAWB&"'"
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	If Not rs.EOF Then
			vMAWB = rs("booking_num")
			vDestination =rs("dest_port_id")
			vFlight = rs("voyage_no")
			vflightDate = rs("departure_date")
			vMAWBCreatedDate= rs("arrival_date")
			vAirLine = rs("vsl_name")
			vOurRef=rs("file_no")
			
	End If
	rs.close
	set rs=nothing 
	response.Write("------------GET_MAWB_INFO"&"<br>")
End Sub 

Sub GET_MASTER_HOUSE_INFO(vMASTER)
    dim rs, SQL    
    set rs=Server.CreateObject("ADODB.Recordset")
	SQL= "select * from hbol_master where elt_account_number= " & elt_account_number & "  and hbol_num='"&vMASTER&"'"
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	
	If Not rs.EOF Then
			vMAWB = rs("mbol_num")
			vAgent= rs("Agent_Name")
			'vMAWBCreatedDate= rs("CreatedDate")
			vOrgAct=rs("Agent_No")
	End If
	Call GET_AGENT_INFO(vOrgAct)
	rs.close
	set rs=nothing 
	
	response.Write("------------GET_MASTER_HOUSE_INFO"&"<br>")
End Sub 


Sub WRITE_PDF_TO_BROWSER

	oFile = Server.MapPath("../template")
	Set PDF = Server.CreateObject("APToolkit.Object")
	reader = PDF.OpenOutputFile("MEMORY")

	Set fso = CreateObject("Scripting.FileSystemObject")
	CustomerForm=oFile & "/Customer/" & "rider_" & elt_account_number & ".pdf"

	If fso.FileExists(CustomerForm) Then
		reader = PDF.OpenInputFile(CustomerForm)
	Else
		reader = PDF.OpenInputFile(oFile+"/rider_o.pdf")
	End If
	Set fso = Nothing
	'-----------------------this is where we set all the form fields with the values
	Call SET_PDF_FIELDS_WITH_VALUES
	'-------------------------------------------------------------------------------
	'// reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    reader = PDF.CopyForm(0, 0)
	PDF.CloseOutputFile
	bridge = PDF.BinaryImage'//this is where  we get all the info in binary
	Response.Expires = 0
	Response.Clear
	Response.ContentType = "application/pdf"
	Response.AddHeader "Content-Type", "application/pdf"
	'Response.AddHeader "Content-Disposition", "attachment; filename=certificate_origin.pdf"
	Response.AddHeader "Content-Disposition", "inline; filename=certificate_origin.pdf"
	Response.BinaryWrite(bridge)
	set bridge = Nothing
	set PDF = Nothing
	response.Write("------------WRITE_PDF_TO_BROWSER"&"<br>")
End Sub

Sub SET_PDF_FIELDS_WITH_VALUES
    PDF.SetFormFieldData "pConsolidationNo", vMaster & "", 0
	PDF.SetFormFieldData "pCompanyName", vCompanyName & "", 0
	PDF.SetFormFieldData "pCompanyInfo", vCompanyInfo & "", 0
	PDF.SetFormFieldData "pAgent", vAgent & "", 0
	PDF.SetFormFieldData "pDatePrinted", Date() & "", 0
	PDF.SetFormFieldData "pOurRef", vOurRef & "", 0
	PDF.SetFormFieldData "pMAWB", vMAWB & "", 0
	PDF.SetFormFieldData "pFligtDate", vflightDate& "", 0
	PDF.SetFormFieldData "pMAWBCreatedDate", vMAWBCreatedDate & "", 0
	PDF.SetFormFieldData "pAirLine", vAirline&" / "&vFlight & "", 0
	PDF.SetFormFieldData "pDestination", vDestination & "", 0
	PDF.SetFormFieldData "pTotalPieces", vTotalPcs & "", 0
	PDF.SetFormFieldData "pTotalWeight", vTotalWeight & "", 0

	Dim limitCount,i
	
	If aSubHouseNo.count > 9 Then
		limitCount = 9
	Else
		limitCount = aSubHouseNo.count
	End If 

	For i=1 To limitCount
		PDF.SetFormFieldData "pHAWB_"&i, aSubHouseNo(i-1)& "", 0
		PDF.SetFormFieldData "pPieces_"&i, aPiece(i-1) & "", 0
		PDF.SetFormFieldData "pWeight_"&i, aWeight(i-1) & "", 0
		PDF.SetFormFieldData "pConsignee_"&i, aConsignee(i-1) & "", 0
		PDF.SetFormFieldData "pDesc_"&i, aDescription(i-1) & "", 0
		PDF.SetFormFieldData "pPreCol_"&i, aPrepaidCollect(i-1) & "", 0
		'PDF.SetFormFieldData "pNDRNAR_"&i, aNDRNAR(i-1) & "", 0
		PDF.SetFormFieldData "pDestination_"&i, aDestination(i-1)& "", 0
	Next
	
	i=1	
	If aAdditionalInfo.count > 11 Then
		limitCount = 11
	Else
		limitCount = aAdditionalInfo.count
	End If 
	
	For i=1 To limitCount
		PDF.SetFormFieldData "pAddInfo_"&i, aAdditionalInfo(i-1)& "", 0		
	Next
	response.Write("------------SET_PDF_FIELDS_WITH_VALUES"&"<br>")
End Sub

Sub DESTRUCTOR
    set rs=nothing 
	Set aSubHouseNo =nothing
	Set aPiece = nothing
	Set aWeight = nothing
	Set aConsignee = nothing
	Set aDescription = nothing
	Set aPrepaidCollect =nothing
	Set aNDRNAR = nothing
    Set aDestination = nothing
	Set aAdditionalInfo = nothing
	response.Write("------------DESTRUCTOR"&"<br>")
End Sub 
%>
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<% Response.End %>
