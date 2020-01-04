<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
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

    Dim vMAWB, aHAWB(64),aShipperInfo(64),aAgentInfo(64)
    Dim aConsigneeInfo(64),aCBM(64)
    Dim vOwner,vConcolidator,vFlightNo,vDateArrival
    Dim aPiece(64),aGrossWeight(64),vWeightScale
    Dim aDesc(64)
    Dim tIndex
    Dim vTotalPiece,vTotalGrossWeight
    Dim aIsSub(64), aSubToNo(64)
    vMBOL=Request.QueryString("MBOL")
    vAgent=checkBlank(Request.QueryString("Agent"),0)
    AgentName=Request.QueryString("AgentName")
    MasterAgentNo=checkBlank(Request.QueryString("MasterAgentNo"),0)
    MasterAgentName=Request.QueryString("MasterAgentName")
    MasterAgentPhone=Request.QueryString("MasterAgentPhone")
    'vMAWB="988-9211 0271"
    Dim rs, SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,agent_IATA_Code from agent where elt_account_number = " & elt_account_number
    rs.Open SQL, eltConn, , , adCmdText	
    If Not rs.EOF Then
	    vFFName = rs("dba_name")
	    vFFAddress=rs("business_address")
	    vFFCity = rs("business_city")
	    vFFState = rs("business_state")
	    vFFZip = rs("business_zip")
	    vFFCountry = rs("business_country")
	    vFFPhone=rs("business_phone")
	    vFFInfo=vFFName & chr(13) & vFFAddress & chr(13) & vFFCity & "," & vFFState & " " & vFFZip & " " & vFFCountry
    end if
    rs.close
 
    SQL= "select * from ocean_booking_number where elt_account_number = " & elt_account_number & " and booking_num=N'" & vMBOL & "'"
    rs.Open SQL, eltConn, , , adCmdText
    if Not rs.EOF then
	    vCarrierName = rs("carrier_desc")
	    vDateArrival = rs("arrival_date")
	    POD=rs("origin_port_id")
	    ETD=rs("departure_date")
	    vPODETD=POD & " " & ETD
	    POA=rs("dest_port_id")
	    ETA=rs("arrival_date")
	    vPOAETA=POA & " " & ETA
	    vFlightNo = rs("vsl_name")'<--------------------------------------------- get from DB
	    vVoyageNo = rs("voyage_no")
	    vFlightNo = vFlightNo &" "& vVoyageNo'<-----------------concat here with newley applied vVoyageNo
	    vFileNo=rs("file_no")
    	
    End If
    rs.Close
   
    vMAWB = ""  '// IT's a real MBOL Number
    SQL= "select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vMBOL & "'"
    rs.Open SQL, eltConn, , , adCmdText
    if Not rs.EOF then
	    vOwner = rs("consignee_name")
	    vMAWB = rs("mbol_num")
    End If

    If vMAWB = "" Then
	    vMAWB = vMBOL
    End If

    rs.Close
     
    If not vMBOL="" Then
	    if vAgent=0 or vAgent=MasterAgentNo then
		    SQL= "select  hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc, aes_xtn, sed_stmt from hbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' and isnull(is_sub,'N')='N' order by hbol_num"
	    else
		    SQL= "select hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,aes_xtn, sed_stmt from hbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' and agent_no=" & vAgent & " and isnull(is_sub,'N')='N' order by hbol_num"
	    end If

	    rs.Open SQL, eltConn, , , adCmdText
          
	    If rs.EOF then
		    rs.close
		    if vAgent=0 or vAgent=MasterAgentNo then
			    SQL= "select mbol_num,'' as hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc,'' as aes_xtn,'' as sed_stmt from mbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' order by hbol_num"
		    else
			    SQL= "select mbol_num,'' as hbol_num,agent_name,pieces,gross_weight,measurement,Shipper_Info,Consignee_Info,manifest_desc, '' as aes_xtn,'' as sed_stmt from mbol_master where elt_account_number = " & elt_account_number & " and booking_num = N'" & vMBOL & "' and agent_acct_num=" & vAgent & " order by hbol_num"
		    end If
          
		    rs.Open SQL, eltConn, , , adCmdText
            
	    End If
       
	    tIndex=0
	    HBOLCnt=0
	    vTotalPiece=0
	    vTotalGrossWeight=0
	    vTotalCBM=0
       
	    Do While Not rs.EOF
		    tIndex=tIndex+1
		    aHAWB(tIndex) = rs("hbol_num")
		    If Not Trim(aHAWB(tIndex)) = "" Then
			    HBOLCnt = HBOLCnt + 1
		    End IF
		    'SubAgent=rs("agent_name")
		    'if vAgent=MasterAgentNo then
		    '	aAgentInfo(tIndex)="Agent" & chr(10) & SubAgent
		    'end if
		    'AgentName=rs("agent_name")
		    If IsNull(rs("pieces")) = False Then
			    aPiece(tIndex) = CDbl(rs("pieces").value)
			    vTotalPiece=vTotalPiece+aPiece(tIndex)
		    Else
			    aPiece(tIndex)=0
		    End If
		    If IsNull(rs("measurement")) = False Then
			    aCBM(tIndex) = CDbl(rs("measurement").value)
			    vTotalCBM=vTotalCBM+aCBM(tIndex)
		    Else
			    aCBM(tIndex)=0
		    End If
		    If IsNull(rs("gross_weight")) = False Then
			    aGrossWeight(tIndex) = CDbl(rs("gross_weight").value)
			    'if vWeightScale="L" then
			    '	aGrossWeight(tIndex)=(aGrossWeight(tIndex)*0.4535924)
			    'end if
			    vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(tIndex)
		    Else
			    aGrossWeight(tIndex)=0
		    End If
		    'aGrossWeight(tIndex)=aGrossWeight(tIndex) & vWeightScale
		    If IsNull(rs("Shipper_Info")) = False Then
			    aShipperInfo(tIndex)=rs("Shipper_Info")
		    End If
		    If IsNull(rs("Consignee_Info")) = False Then
			    aConsigneeInfo(tIndex)=rs("Consignee_Info")
		    End If
    		
		    If Not IsNull(rs("manifest_desc")) Then
			    aDesc(tIndex) = rs("manifest_desc")
		    End If
    		
		    If (not isNull(rs("aes_xtn"))) and rs("aes_xtn")<>"" then
			    adesc(tindex) = aDesc(tIndex) & chr(13) & "AES ITN: " & rs("aes_xtn")
		    Elseif (not isNull(rs("sed_stmt"))) and rs("sed_stmt")<>"" then
			    aDesc(tIndex) = aDesc(tIndex) & chr(13) & rs("sed_stmt")
		    End If
    		
		    rs.MoveNext
	    Loop

	    rs.Close
    End If
      
    Set rs=Nothing

    if tIndex="" then tIndex=1
    Dim Pages,PageMod
    Pages=fix(tIndex/5)
    PageMod=tIndex mod 5
    if Not PageMod= 0 then Pages=Pages+1

    i=0

    response.buffer = True

    '/////////////////
    DIM oFile
    oFile = Server.MapPath("../template")
    Set PDF =GetNewPDFObject()
    r = PDF.OpenOutputFile("MEMORY")

    '/////////////////////////////////////////////////////////////////////////
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm=oFile & "/Customer/" & "Manifest_Ocean" & elt_account_number & ".pdf"

    If fso.FileExists(CustomerForm) Then
    '// Customer has a specific invoice form
	    r = PDF.OpenInputFile(CustomerForm)
    Else
    '// Normal Form
	    r = PDF.OpenInputFile(oFile+"/Manifest_Ocean.pdf")
    End If
    Set fso = nothing
    '////////////////////////////////////////////////////////////////////////

    '///move here by iMoon
	    r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)

    for j=1 to Pages
    'gerenal info
        PDF.SetFormFieldData "FFName",Left(vFFInfo,InStr(vFFInfo,chr(13))) & "",0
        PDF.SetFormFieldData "FFInfo",Mid(vFFInfo,InStr(vFFInfo,chr(13))+1) & "",0
	    PDF.SetFormFieldData "MAWB",vMAWB,0
	    If Not vMBOL = "" then
		    PDF.SetFormFieldData "FLAG_MAWB","M",0
	    End If

	    PDF.SetFormFieldData "Owner",vOwner,0
	    PDF.SetFormFieldData "CarrierName",vCarrierName,0
	    PDF.SetFormFieldData "Owner",vOwner,0
	    PDF.SetFormFieldData "FlightNo",vFlightNo,0
	    PDF.SetFormFieldData "DateArrival",vDateArrival,0
	    PDF.SetFormFieldData "Page",j & " of " & Pages,0
	    PDF.SetFormFieldData "File#",vFileNo,0
	    PDF.SetFormFieldData "ETD",vPODETD,0
	    PDF.SetFormFieldData "ETA",vPOAETA,0
	    for i=(j-1)*5+1 to 5*j
		    PDF.SetFormFieldData "HAWB" & i-(j-1)*5,aHAWB(i),0
		    If Not aHAWB(i) = "" then
		    PDF.SetFormFieldData "FLAG_HAWB"& i-(j-1)*5,"H",0
		    End if
		    'PDF.SetFormFieldData "MasterAgentInfo" & i-(j-1)*5,aAgentInfo(i),0
		    PDF.SetFormFieldData "Pieces" & i-(j-1)*5,aPiece(i),0
		    PDF.SetFormFieldData "GrossWeight" & i-(j-1)*5, ConvertAnyValue(aGrossWeight(i),"Long",""),0
		    PDF.SetFormFieldData "CBM" & i-(j-1)*5, ConvertAnyValue(aCBM(i),"Long",""),0
		    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperInfo(i),0
		    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeInfo(i),0
		    PDF.SetFormFieldData "Desc" & i-(j-1)*5,aDesc(i),0
	    next
		    PDF.SetFormFieldData "TotalPieces",vTotalPiece,0
		    PDF.SetFormFieldData "TotalGrossWeight", ConvertAnyValue(vTotalGrossWeight,"Long",""),0
		    PDF.SetFormFieldData "TotalCBM", ConvertAnyValue(vTotalCBM,"Long",""),2
		    If HBOLCnt > 0 then
			    PDF.SetFormFieldData "TotalHAWB","TOTAL " & tIndex & " HBOL",0
		    End if
		    PDF.SetFormFieldData "KG","KG",0
		    PDF.SetFormFieldData "CBM","CBM",0

	    PDF.FlattenRemainingFormFields = True
    '	r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)
	    r=PDF.CopyForm(0, 0)
	    PDF.ResetFormFields
    Next

    '////////////////////////////////////////////////////////////////////////////
    PDF.CloseOutputFile

    response.expires = 0
    response.clear
    response.ContentType = "application/pdf"
    response.AddHeader "Content-Type", "application/pdf"
    If checkBlank(windowName,"") <> "" Then
        response.AddHeader "Content-Disposition", "inline; filename=MAN" & Session.SessionID & ".pdf"
    Else
        response.AddHeader "Content-Disposition", "attachment; filename=MAN" & Session.SessionID & ".pdf"
    End If
    WritePDFBinary(PDF)
    set PDF=nothing
    eltConn.Close()
    Set eltConn = Nothing

%>

