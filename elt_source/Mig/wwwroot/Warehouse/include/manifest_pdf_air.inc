<%
'///////////////////////////////// for ELI by iMoon
DIM vFlightNoELI,aAgentInfoFull(64),vDateArrivalFull,vDateDepartFull
'///////////////////////////////// 

'// Added by Joon on Feb/28/2007 /////////////////////////////////////
Dim aSubToNo(64),aIsSub(64)
Dim aShipperName(64),aConsigneeName(64)
Dim aDangerGood(64)
'/////////////////////////////////////////////////////////////////////

if vAgent="" then
	vAgent=0
else
	vAgent=cLng(vAgent)
end if
if MasterAgentNo="" then
	MasterAgentNo=0
else
	MasterAgentNo=cLng(MasterAgentNo)
end if

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
SQL= "select a.*,b.consignee_name,b.Flight_Date_1,b.account_info from mawb_number a,mawb_master b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.mawb_no=b.mawb_num and a.MAWB_No = '" & vMAWB & "'"
rs.Open SQL, eltConn, , , adCmdText
if Not rs.EOF then
	MasterAgentName=rs("consignee_name")
	if AgentName="" then AgentName=MasterAgentName
	If IsNull(rs("Carrier_Desc")) = False Then
		vOwner = rs("Carrier_Desc")
	End If
	If IsNull(rs("Flight#1")) = False Then
		vFlightNo = rs("Flight#1")
	End If
	If IsNull(rs("ETA_Date1")) = False Then
		vDateArrival = rs("ETA_Date1")
	End If
	If IsNull(rs("ETA_Date2")) = False Then
		vDateArrival = rs("ETA_Date2")
	End If
	POD=rs("origin_port_id")
	ETD=rs("etd_date1")
	vPODETD=POD & " " & ETD
	POA=rs("dest_port_id")	

	IF not isnull(rs("eta_date1"))then 
	    ETA=rs("eta_date1")	
	end if 
	
	IF not isnull(rs("eta_date2"))then 
	    ETA=rs("eta_date2")
	end if 
	
	vPOAETA=POA & " " & ETA
	vFileNo=rs("file#")
	vFlightNoELI=rs("Flight_Date_1")

End If
rs.Close
'// Modified by Joon on Feb/28/2007 //////////////////////////////////////////////////////////////
if not vMAWB="" then
	if vAgent=0 or vAgent=MasterAgentNo then
		SQL= "select sub_to_no,is_sub,hawb_num,agent_name,Total_Pieces,adjusted_Weight,Weight_Scale,Shipper_Info,Shipper_Name,Consignee_Info,Consignee_Name,manifest_desc, aes_xtn,account_info, danger_good from hawb_master where isnull(is_master,'N')='N' and elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' order by hawb_num"
	else
		SQL= "select sub_to_no,is_sub,hawb_num,agent_name,Total_Pieces,adjusted_Weight,Weight_Scale,Shipper_Info,Shipper_Name,Consignee_Info,Consignee_Name,manifest_desc, aes_xtn,account_info, danger_good from hawb_master where  isnull(is_master,'N')='N' and  elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and agent_no=" & vAgent & " order by sub_to_no, hawb_num"
end if

rs.Open SQL, eltConn, , , adCmdText
tIndex=0
vTotalPiece=0
vTotalGrossWeight=0
Do While Not rs.EOF
	tIndex=tIndex+1
	aHAWB(tIndex) = rs("HAWB_NUM")
	SubAgent=rs("agent_name")
	if vAgent=MasterAgentNo or elt_account_number = 20009000 then
		aAgentInfo(tIndex)="Agent " & chr(10) & SubAgent
		aAgentInfoFull(tIndex) = rs("account_info")
	end if
	'AgentName=rs("agent_name")
	If IsNull(rs("Total_Pieces")) = False Then
		aPiece(tIndex) = CInt(rs("Total_Pieces"))
		vTotalPiece=vTotalPiece+aPiece(tIndex)
	Else
		aPiece(tIndex)=0
	End If
	If Not IsNull(rs("Weight_Scale")) Or Trim(rs("Weight_Scale")) <> "" Then
		vWeightScale = rs("Weight_Scale")
	end if
	'if vWeightScale="L" then
	'	vWeightScale="LB"
	'Else
	'	vWeightScale="KG"
	'end if
	If Not IsNull(rs("adjusted_Weight")) Or Trim(rs("adjusted_Weight")) <> "" Then
		aGrossWeight(tIndex) = CDBL(rs("adjusted_Weight"))
		if vWeightScale="L" then
			aGrossWeight(tIndex)=FormatNumber(aGrossWeight(tIndex)*0.454,0)
		end if
		vTotalGrossWeight=vTotalGrossWeight+aGrossWeight(tIndex)
	Else
		aGrossWeight(tIndex)=0
	End If
	'aGrossWeight(tIndex)=aGrossWeight(tIndex) & vWeightScale
	
	If IsNull(rs("Shipper_Info")) = False Then
		aShipperInfo(tIndex)=rs("Shipper_Info")
	End If
	If IsNull(rs("Shipper_Name")) = False Then
		aShipperName(tIndex)=rs("Shipper_Name")
	End If
	If IsNull(rs("Consignee_Info")) = False Then
		aConsigneeInfo(tIndex)=rs("Consignee_Info")
	End If
	If IsNull(rs("Consignee_Name")) = False Then
		aConsigneeName(tIndex)=rs("Consignee_Name")
	End If
	
	If IsNull(rs("manifest_desc")) = False Then
        if (not isNull(rs("aes_xtn"))) and rs("aes_xtn")<>"" then 
            aDesc(tIndex) = rs("manifest_desc")&chr(13)&"AES ITN: "&rs("aes_xtn")
		else 
            aDesc(tIndex) = rs("manifest_desc")&chr(13)
		end if 
	End If

'// Modified by Joon on Feb/28/2007 //////////////////////////////////////////////////////////////
    if not isnull(rs("sub_to_no").value) then 
    	aSubToNo(tIndex)= rs("sub_to_no").value
	else
		aSubToNo(tIndex)= "N"
	end if 
	
	if not isnull(rs("is_sub").value) then 
    	aIsSub(tIndex) = rs("is_sub").value
	else 
		aIsSub(tIndex)= "N"
	end if 
	
	aDangerGood(tIndex)=rs("danger_good").value
	rs.MoveNext
Loop
rs.Close
end if
Set rs=Nothing

if tIndex="" then tIndex=1
Dim Pages,PageMod
Pages=fix(tIndex/5)
PageMod=tIndex mod 5
if Not PageMod= 0 then Pages=Pages+1
if Pages=0 then Pages=1
i=0

'Pages=2
for j=1 to Pages
'gerenal info
	On Error Resume Next:
	If Not vMAWB = "" then
		PDF.SetFormFieldData "FLAG_MAWB","M",0
	End If
    PDF.SetFormFieldData "FFName",Left(vFFInfo,InStr(vFFInfo,chr(13))) & "",0
    PDF.SetFormFieldData "FFInfo",Mid(vFFInfo,InStr(vFFInfo,chr(13))+1) & "",0
	PDF.SetFormFieldData "MAWB",vMAWB,0
	PDF.SetFormFieldData "AgentName",AgentName,0
	PDF.SetFormFieldData "Owner",vOwner,0
	PDF.SetFormFieldData "FlightNo",vFlightNo,0
	PDF.SetFormFieldData "DateArrival",vDateArrival,0
	PDF.SetFormFieldData "Page",j & " of " & Pages,0
	PDF.SetFormFieldData "File#",vFileNo,0

'///////////////////////////////////////////////////// for ELI by iMoon
	PDF.SetFormFieldData "FlightNo_ELI",vFlightNoELI,0
	PDF.SetFormFieldData "DateDepartFull",POD & " " & ETD,0
	PDF.SetFormFieldData "DateArrivalFull",POA & " " & vDateArrival,0
	'DIM PREV_SUB_TO_NO
	'PREV_SUB_TO_NO=aSubToNo(0)
	if tIndex>0 then
		for i=(j-1)*5+1 to 5*j
			PDF.SetFormFieldData "HAWB" & i-(j-1)*5,aHAWB(i),0
			If Not aHAWB(i) = "" then
			    PDF.SetFormFieldData "FLAG_HAWB"& i-(j-1)*5,"H",0
			End if
			PDF.SetFormFieldData "MasterAgentInfo" & i-(j-1)*5,aAgentInfo(i),0
			PDF.SetFormFieldData "MasterAgentInfoFull" & i-(j-1)*5,aAgentInfoFull(i),0
			PDF.SetFormFieldData "Pieces" & i-(j-1)*5,aPiece(i),0
			PDF.SetFormFieldData "GrossWeight" & i-(j-1)*5,aGrossWeight(i),0
			
			If AddInfo = "Y" Then 
			    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperInfo(i),0
			Else
			    PDF.SetFormFieldData "ShipperInfo" & i-(j-1)*5,aShipperName(i),0
			End If 
			
			If AddInfo = "Y" Then 
			    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeInfo(i),0
			Else
			    PDF.SetFormFieldData "ConsigneeInfo" & i-(j-1)*5,aConsigneeName(i),0
			End If 
			
			PDF.SetFormFieldData "Desc" & i-(j-1)*5,aDesc(i),0
			
			if aIsSub(i)="Y" then 
				'if i=0 or (PREV_SUB_TO_NO <> aSubToNo(i)) then 
					PDF.SetFormFieldData "MASTER" & i-(j-1)*5,"M/H: "&aSubToNo(i),0
				'end if 
				'PREV_SUB_TO_NO=aSubToNo(i)
			end if 
			
			PDF.SetFormFieldData "HAZMAT" & i-(j-1)*5, aDangerGood(i) & "", 0
			
		next
	'if j=cInt(Pages) then
			PDF.SetFormFieldData "TotalPieces",vTotalPiece,0
			PDF.SetFormFieldData "TotalGrossWeight",vTotalGrossWeight,0
			PDF.SetFormFieldData "TotalHAWB","TOTAL " & tIndex & " HAWB",0
		'PDF.SetFormFieldData "TotalPieces",j,0
		'PDF.SetFormFieldData "TotalGrossWeight",Pages,0
	'end if
	end if

		'r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & "_horizon.pdf",1)
	    PDF.FlattenRemainingFormFields = True
	    r=PDF.CopyForm(0, 0)
	    PDF.ResetFormFields
next



%>