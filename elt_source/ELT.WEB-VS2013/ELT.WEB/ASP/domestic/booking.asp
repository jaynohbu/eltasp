<%@  LANGUAGE="VBScript" %>
<html>
<head>
    <title>Booking</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <style type="text/css">
<!--
.style1 {
	color: #000000;
	font-weight: bold;
}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style9 {color: #000000}
.style10 {color: #517595}
.style11 {color: #663366}
.style12 {
	color: #c16b42;
	font-weight: bold;
	
}
.style13 {
	color: #c16b42;
	font-weight: bold;
	visibility:hidden;
}
-->
</style>

    <script type="text/javascript">
var ComboBoxes =  new Array('lstMAWB');
function txtServiceLevel2Change(){

	var serviceLevel = document.getElementById("txtServiceLevel").value;
	var serviceLevelOther = document.getElementById("txtServiceLevel2");
	var tableshow= document.getElementById("TableS");
	if(serviceLevel == "Other"){
	    tableshow.style.visibility = "visible";
		serviceLevelOther.style.visibility = "visible";
		//serviceLevelOther.value="Please Select describe."
	}
	else{
	    tableshow.style.visibility = "hidden";
		serviceLevelOther.style.visibility = "hidden";
		serviceLevelOther.value = "";
	}
}

    </script>
        <script  type="text/javascript" src='/ASP/Include/iMoonCombo.js'></script>
      
    <!-- /End of Combobox/ -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
    '// Transaction Added By Joon on Oct,18 2007 /////////////////////////////////
    eltConn.BeginTrans
    '/////////////////////////////////////////////////////////////////////////////

    Dim vMAWB, vCarrier,vCarrierDesc,vCarrierCode
    Dim vFlightNo,vFileNo
    Dim vOriginPort,vDestPort
    Dim vTo,vBy,vTo1,vBy1,vTo2,vBy2
    Dim vFlight1,vFlight2
    Dim vDeptDate,vDeptTime,vArrivalDate,vArrivalTime
    Dim vWeightReserved,vWeightScale
    Dim Save,Go,booking_date
    Dim aMAWBDisplay(),aMAWB(),aMAWBCarrier()
    Dim rs, SQL
    Dim vServiceLevel,vPieces
    Dim vServiceLevel2
    Dim aFILEPrefix(128),aNextFILE(128),fIndex,vFILEPrefix, rs2, FileNoForSearch

    Save=Request.QueryString("Save")
    Go=Request.QueryString("Go")
    Edit=Request.QueryString("Edit")
    Close=Request.QueryString("Close")
    vMAWB=Request.QueryString("MAWB")
    FileNoForSearch=Request.QueryString("FILENO")

    if GO = "yes" or Save = "yes" or Edit = "yes" then
	    VchkAll=Request("chkAll")
    end if


    Set rs = Server.CreateObject("ADODB.Recordset")

    '// by ig 7/11/2006 for FILE No.
    Set rs2 = Server.CreateObject("ADODB.Recordset")

    vCarrierDesc=Request("txtCarrierDesc")
    CarrierInfo=Request("lstCarrier")

    pos=0
    pos=instr(CarrierInfo,"-")
    if pos>0 then
	    vCarrier=Left(CarrierInfo,pos-1)
	    vSCAC=Mid(CarrierInfo,pos+1,200)
    end if

    if Save="yes" then
	    vFileNo=Request("txtFileNo")
	    PortInfo=Request("lstOriginPort")
	    pos=0
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vOriginPort=Left(PortInfo,pos-1)
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vOriginPortID=Left(PortInfo,pos-1)
		    if vOriginPortID="" then vOriginPortID=0
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vOriginPortDesc=Left(PortInfo,pos-1)
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vOriginPortState=Left(PortInfo,pos-1)
		    vOriginPortCountry=Mid(PortInfo,pos+1,200)
	    end if	
	    PortInfo=Request("lstDestPort")
	    pos=0
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vDestPort=Left(PortInfo,pos-1)
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vDestPortID=Left(PortInfo,pos-1)
		    if vDestPortID="" then vDestPortID=0
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vDestPortDesc=Left(PortInfo,pos-1)
		    PortInfo=Mid(PortInfo,pos+1,200)
	    end if
	    pos=instr(PortInfo,"-")
	    if pos>0 then
		    vDestPortCountry=Left(PortInfo,pos-1)
		    vDestPortCountryCode=Mid(PortInfo,pos+1,200)
	    end if	
	    vServiceLevel2=Request("txtServiceLevel2")
	    vServiceLevel=Request("txtServiceLevel")
        '// ADDED BY Stanley 10-19-2007
       booking_date = Request("txtBookingDate")
    	
	    if vServiceLevel ="Other" and not vServiceLevel2="" then
	    vServiceLevel =vServiceLevel2
	    end if
    	
    	
	    vPieces=Request("txtPieces")

	    vTo=Request("txtTo")
	    vBy=Request("txtBy")
	    vTo1=Request("txtTo1")
	    vBy1=Request("txtBy1")
	    vTo2=Request("txtTo2")
	    vBy2=Request("txtBy2")
	    vFlight1=Request("txtFlight1")
	    vFlight2=Request("txtFlight2")
	    vDeptDate1=Request("txtDeptDate1")
	    vDeptDate2=Request("txtDeptDate2")
	    vArrivalDate1=Request("txtArrivalDate1")
	    vArrivalDate2=Request("txtArrivalDate2")
	    vWeightReserved=Request("txtWeightReserved")
	    if vWeightReserved="" then
		    vWeightReserved=0
	    end if
	    vWeightScale=Request("lstWeightScale")
	    vAirLineStaff=Request("txtAirLineStaff")

	    if Save="yes" then
    	
	        SQL = "UPDATE mawb_number SET file#=NULL,status='A' where elt_account_number=" & elt_account_number & " AND file#='" & vFileNo & "'"
            Set rs = Server.CreateObject("ADODB.Recordset")
            Set rs = eltConn.execute(SQL)
            
		    SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and mawb_no='" & vMAWB & "'"
		    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		    if Not rs.EOF then
    	
			    '// by ig 7/11/2006 for FILE No.
			    vFileNo = GET_FILE_NUMBER("DAJ", vFileNo, vMAWB )
			    '/////////////////////////////// 
    			
			    rs("File#")=vFileNo
			    rs("Origin_Port_ID")=vOriginPort
			    rs("origin_port_aes_code")=vOriginPortID
			    rs("origin_port_location")=vOriginPortDesc
			    rs("origin_port_state")=vOriginPortState
			    rs("origin_port_country")=vOriginPortCountry
			    rs("Dest_Port_ID")=vDestPort
			    rs("dest_port_aes_code")=vDestPortID
			    rs("dest_port_location")=vDestPortDesc
			    rs("dest_port_country")=vDestPortCountry
			    rs("dest_country_code")=vDestPortCountryCode
			    rs("To")=vTo
			    rs("BY")=vBy
			    rs("To_1")=vTo1
			    if vBy1 = "Select One" then vBy1 = ""
			    rs("By_1")=vBy1
			    rs("To_2")=vTo2
			    rs("By_2")=vBy2
			    rs("Flight#1")=vFlight1
			    rs("Flight#2")=vFlight2
			    rs("ETD_DATE1")=vDeptDate1
			    rs("service_level_other")=vServiceLevel2
			    if vServiceLevel="other" then 
			    vServiceLevel=vServiceLevel2
			    end if
			    rs("service_level")=vServiceLevel
			    rs("pieces")=vPieces
    	
			    if Not vDeptDate2="" then
				    rs("ETD_DATE2")=vDeptDate2
			    end if
			    rs("ETA_DATE1")=vArrivalDate1
			    if Not vArrivalDate2="" then
				    rs("ETA_DATE2")=vArrivalDate2
			    end if
			    rs("Weight_Reserved")=vWeightReserved
			    rs("Weight_Scale")=Left(vWeightScale,1)
			    rs("airline_staff")=vAirlineStaff
			    rs("Status")="B"
			    rs("booking_date")=booking_date
			    rs("is_dome")="Y"
			    rs("master_type")="DA"
			    rs("Carrier_acct") = GetAcctByCode(Request.Form.Item("hCarrierCode"))
			    rs.Update
		    end if
		    rs.close

		    '// by ig 7/11/2006 for FILE No.		
		    CALL UPDATE_USER_NEXT_NUMBER_IN_PREFIX( "DAJ", vFileNo )
		    '//////////////////////////////
    		
    'update hawb_master
		    dim date9
		    pos=0
		    pos=instr(vOriginPortDesc,"'")
		    if pos>0 then
			    vOriginPortDesc=Mid(vOriginPortDesc,1,pos) & "'" & Mid(vOriginPortDesc,pos+1,2000)
		    end if
		    pos=instr(vDestPortDesc,"'")
		    if pos>0 then
			    vDestPortDesc=Mid(vDestPortDesc,1,pos) & "'" & Mid(vDestPortDesc,pos+1,2000)
		    end if
		    SQL= "update hawb_master set "
		    SQL=SQL & " dep_airport_code='" & vOriginPort & "'"
		    SQL=SQl & ",departure_airport='" & vOriginPortDesc & "'"
		    SQL=SQl & ",dest_airport='" & vDestPortDesc & "'"
		    SQL=SQl & ",to_1='" & vTo & "'"
		    SQL=SQl & ",by_1='" & vBy & "'"
		    SQL=SQl & ",to_2='" & vTo1 & "'"
		    SQL=SQl & ",by_2='" & vBy1 & "'"
		    SQL=SQl & ",to_3='" & vTo2 & "'"
		    SQL=SQl & ",by_3='" & vBy2 & "'"
		    date9=day(vDeptDate1)
		    SQL=SQl & ",flight_date_1='" & vFlight1 & "/0" & day(vDeptDate1) & "'"
		    if Not vFlight2="" then
			    SQL=SQL & ",flight_date_2='" & vFlight2 & "/0" & day(vDeptDate2) & "'"
		    else
			    SQL=SQL & ",flight_date_2=''"
		    end if
		    if Not vDeptDate1="" then
			    SQL=SQL & ", export_date='" & vDeptDate1 & "'"
		    end if
		    SQL=SQL & ",dest_country='" & vDestPortCountry & "'"
		    SQL=SQl & " where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "'"
		    eltConn.Execute SQL
    'update mawb_master
		    SQL= "update mawb_master set "
		    SQL=SQL & " dep_airport_code='" & vOriginPort & "'"
		    SQL=SQl & ",departure_airport='" & vOriginPortDesc & "'"
		    SQL=SQl & ",dest_airport='" & vDestPortDesc & "'"
		    SQL=SQl & ",to_1='" & vTo & "'"
		    SQL=SQl & ",by_1='" & vBy & "'"
		    SQL=SQl & ",to_2='" & vTo1 & "'"
		    SQL=SQl & ",by_2='" & vBy1 & "'"
		    SQL=SQl & ",to_3='" & vTo2 & "'"
		    SQL=SQl & ",by_3='" & vBy2 & "'"
		    SQL=SQl & ",flight_date_1='" & vFlight1 & "/0" & day(vDeptDate1) & "'"
		    if Not vFlight2="" then
			    SQL=SQL & ",flight_date_2='" & vFlight2 & "/0" & day(vDeptDate2) & "'"
		    else
			    SQL=SQL & ",flight_date_2=''"
		    end if
		    '//changed by stanley on 10-19-2007
		    SQL=SQL & ",service_level='" & ConvertAnyValue(vServiceLevel,"String","") & "'"
		    SQL=SQL & ",service_level_other='" & ConvertAnyValue(vServiceLevel2,"String","") & "'"
		    SQL=SQL & ",Total_Pieces=" & ConvertAnyValue(vPieces,"String","")

		    SQL=SQL & ",dest_country='" & vDestPortCountry & "'"
		    SQL=SQL & ",is_dome='Y'" 
		    SQL=SQl & " where elt_account_number = " & elt_account_number & " and mawb_num='" & vMAWB & "'"
		    eltConn.Execute SQL

	    end if

    elseif Edit="yes" then
	
	    if NOT FileNoForSearch = "" then
		    SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and replace(File#,'-','') = '" & Replace(FileNoForSearch,"-","") & "' AND is_inbound<>'Y'"
	    else
		    SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and MAWB_No = '" & vMAWB & "'"		
	    end if
    		
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	    If Not rs.EOF Then
    		
		    if rs("used") = "Y" then
			    VchkAll = "Y" '// to Display this MAWB in Dropdown List 
		    end if
    		
		    vMAWB=rs("MAWB_NO")
		    vFileNo=rs("File#")
		    vOriginPort=rs("Origin_Port_ID")
		    vDestPort=rs("Dest_Port_ID")
		    vTo=rs("To")
		    vBy=rs("BY")
		    vBy=Request("lstMAWB")
		    vTo1=rs("To_1")
		    vBy1=rs("By_1")
		    vTo2=rs("To_2")
		    vBy2=rs("By_2")
		    vFlight1=rs("Flight#1")
		    vFlight2=rs("Flight#2")
		    vServiceLevel2=rs("service_level_other").value
		    vServiceLevel=rs("service_level").value
		    if not vServiceLevel2 ="" then
		    vServiceLevel="Other"
		    end if
		    vPieces=rs("pieces").value
		    vDeptDate1=rs("ETD_DATE1")
		    vDeptDate2=rs("ETD_DATE2")
		    vArrivalDate1=rs("ETA_DATE1")
		    vArrivalDate2=rs("ETA_DATE2")
		    vWeightReserved=rs("Weight_Reserved")
		    vWeightScale=rs("Weight_Scale")
		    vAirLineStaff=rs("airline_staff")
		    booking_date=rs("booking_date")
		    '//change by stanley om 10-19-2007
		    vCarrierCode = ConvertAnyValue(rs("Carrier_code").value,"String","")
		    rs.Close
	    else
		    rs.Close
		    if NOT FileNoForSearch = "" then
%>

<script language='javascript'>alert('File # '+ '<%=FileNoForSearch%>' + ' does not exist.');</script>
<%		
			    FileNoForSearch = ""
		    else
			    if vMAWB = "Select One" then
			    else
%>
<script language='javascript'>alert('MAWB # '+ '<%=vMAWB%>' + ' does not exist.');</script>

<%		
			    end if
				    vMAWB = ""
		    end if	
	    end if
    elseif Close="yes" then
	    SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and mawb_no='" & vMAWB & "'"
	    rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	    if not rs.EOF then
		    rs("Status")="C"
	    end if
	    rs.Update
	    rs.close
	    vMAWB=""
    end if

    'get airline info
    Dim CarrierName(512),CarrierCode(512),SCAC(128)
    SQL= "select dba_name,carrier_code,carrier_id,org_account_number from organization where elt_account_number = " & elt_account_number & " and is_carrier='Y' and carrier_code <> '' order by dba_name"
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    Set rs.activeConnection = Nothing

    aIndex=1
    CarrierName(0)="Select One"
    CarrierCode(0)=0
    Do While Not rs.EOF
	    CarrierName(aIndex)=rs("dba_name")
	    CarrierCode(aIndex)=rs("carrier_code")
	    SCAC(aIndex)=rs("carrier_id")
	    aIndex=aIndex+1
	    rs.MoveNext
    Loop
    rs.Close

    'GET PORT INFO
    Dim PortCode(1000),PortID(1000),PortDesc(1000),PortState(1000),PortCountry(1000),PortCountryCode(1000)
    SQL= "select * from port where elt_account_number = " & elt_account_number & " AND port_country_code='US' order by port_desc"
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    Set rs.activeConnection = Nothing

    pIndex=0
    Do While Not rs.EOF
	    PortCode(pIndex)=rs("port_code")
	    PortID(pIndex)=rs("port_id")
	    PortDesc(pIndex)=rs("port_desc")
	    PortState(pIndex)=rs("port_state")
	    PortCountry(pIndex)=rs("port_country")
	    PortCountryCode(pIndex)=rs("port_country_code")
	    pIndex=pIndex+1
	    rs.MoveNext
    Loop
    rs.Close

	if VchkAll = "Y" then
		if vCarrierDesc = "" then
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and Status<>'C' "
		else
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and Status<>'C' and carrier_desc = '" & Replace(vCarrierDesc,"'","\'") & "'" 		
		end if
	else
		if vCarrierDesc = "" then
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and Status<>'C'  and used <> 'Y' " 
		else
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and (master_type='DA' or master_type='') and Status<>'C'  and used <> 'Y' and carrier_desc = '" & Replace(vCarrierDesc,"'","\'") & "'" 		
		end if
	end if
	
	SQL = SQL & " and is_inbound <> 'Y'"

	Set rs = Server.CreateObject("ADODB.Recordset")
    rs.CursorLocation = adUseClient
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    Set rs.activeConnection = Nothing

	tIndex=0
	Count=rs.RecordCount+1000
	ReDim aMAWBDisplay(Count)
	ReDim aMAWB(Count)
	ReDim aMAWBCarrier(Count)
	Do While Not rs.EOF
		aMAWB(tIndex)=rs("mawb_no")
		vUsed=rs("used")
		if vUsed="Y" then
			aMAWBDISPLAY(tIndex)=aMAWB(tIndex) & "###" & "used"
		else
			aMAWBDISPLAY(tIndex)=aMAWB(tIndex)
		end if
		aMAWBCarrier(tIndex)=rs("carrier_desc")
		rs.MoveNext
		tIndex=tIndex+1
	Loop
	rs.close
	
'////////////////////////////////////// by ig 07/09/2006 
    CALL GET_FILE_PREFIX_FROM_USER_PROFILE( "DAJ" )
    Set rs2=Nothing
'////////////////////////////////////////////////////////
	
    Set rs=Nothing

    if save = "yes" then 
	    goMAWBOK = "yes"
    else
	    goMAWBOK = ""
    end if

    eltConn.CommitTrans
    
%>
<%
'//////// by ig 07/09/2006 /////////////////////////////
'///////////////////////////////////////////////////////
%>
<%
SUB UPDATE_USER_NEXT_NUMBER_IN_PREFIX( strType, tmpFileNo )
DIM tmpNextNo,tPrefix

	if aFILEPrefix(0) = "NONE" then
		exit sub
	end if

	pos=0
	pos=instr(tmpFileNo,"-")
	if pos>0 then
		tPrefix=Mid(tmpFileNo,1,pos-1)
		tmpNextNo=Mid(tmpFileNo,pos+1,32)
	else
		exit sub
	end if

	SQL= "select * from user_prefix where elt_account_number=" & elt_account_number & " and type='"& strType &"' and prefix='" & tPrefix & "'"
	rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs2.EOF Then
		if cLng(tmpNextNo)>=cLng(rs2("next_no")) then
			rs2("next_no")=cLng(tmpNextNo)+1
			rs2.Update
		end if
		for i=0 to fIndex
			if tPrefix=aFILEPrefix(i) then
				aNextFILE(i)=cLng(tmpNextNo)+1
			end if
		next
	end if
	rs2.Close

END SUB
%>
<%
FUNCTION GET_FILE_NUMBER ( strType, strFileNo, tmpMAWB)

DIM  tmpFileNo,FileNoExist,vNextFileNo

vFILEPrefix = request("txtFileNo")
pos=0
pos=instr(vFILEPrefix,"-")

if pos>0 then
	vFILEPrefix=Mid(vFILEPrefix,1,pos-1)
Else
	GET_FILE_NUMBER = strFileNo
	exit function
End if

if isnull(vFILEPrefix) or vFILEPrefix = "" then
	GET_FILE_NUMBER = strFileNo
	exit function
end if

vNextFileNo = request("hNEXTFILENo")

if vNextFileNo = "" then 
	vNextFileNo = "0"
end if
	
tmpFileNo = strFileNo

if tmpFileNo = "" then
	if Not vFILEPrefix="" then
		tmpFileNo=vFILEPrefix & "-" & vNextFileNo
	else
		tmpFileNo=vNextFileNo
	end if
end if

FileNoExist = true

DO WHILE FileNoExist
	SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='Y' or is_dome='') and master_type='DA' and File#='" & tmpFileNo & "' and mawb_no<>'"&tmpMAWB&"'"
	rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If rs2.EOF=true Then		
		FileNoExist=false
		rs2.close
		GET_FILE_NUMBER = tmpFileNo
		exit function
	else
		tmpFileNo = rs2("File#")
		rs2.close
		pos=0
		pos=instr(tmpFileNo,"-")
		if pos>0 then
			vNextFileNo=Mid(tmpFileNo,pos+1,32)
		end if

		vNextFileNo=vNextFileNo+1
		tmpFileNo=vFILEPrefix & "-" & vNextFileNo
	end if
LOOP

END FUNCTION
%>
<%
SUB GET_FILE_PREFIX_FROM_USER_PROFILE( strType )

	if isnull(vFileNo) then
		vFileNo = ""
	end if

	vFILEPrefix=Request("hFILEPrefix")

	if isnull(vFILEPrefix) then
		vFILEPrefix = ""
	end if

	if vFILEPrefix = "" then
		if not vFileNo = "" then
				pos=0
				pos=instr(vFileNo,"-")
				if pos>0 then
					vFILEPrefix=Mid(vFileNo,1,pos-1)
				end if
		end if
	end if

	SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number & " and type='"& strType & "' order by prefix"
	rs2.Open SQL, eltConn, , , adCmdText
	fIndex=0
	do While Not rs2.EOF
		aFILEPrefix(fIndex)=rs2("prefix")
		aNextFILE(fIndex)=rs2("next_no")

		if vFILEPrefix = "" then
			vFILEPrefix = aFILEPrefix(fIndex)
		end if
		
		if aFILEPrefix(fIndex)= vFILEPrefix then
			vNEXTFILENo = aNextFILE(fIndex)
		end if	
		
		rs2.MoveNext
		fIndex=fIndex+1
	loop
	rs2.Close

	if fIndex = 0 then
		aFILEPrefix(0) = "NONE"
		fIndex = 1
		vFILEPrefix = ""
	end if
	
	if NOT vFileNo = ""  then
		aFILEPrefix(0) = "EDIT"
		fIndex = 1
		vFILEPrefix = ""	
	end if
	
	if trim(vFileNo) = "" then
		if Not vFILEPrefix="" then
			vFileNo=vFILEPrefix & "-" & vNextFileNo
		else
			vFileNo=vNextFileNo
		end if
	end if
	
End SUB


Function GetAcctByCode(vCarrierCode)
    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select * from organization where elt_account_number=" & elt_account_number _
        & " and Carrier_code='" & vCarrierCode & "'"
	
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj("org_account_number").value
	End If
	GetAcctByCode = result

    rsObj.Close()
End Function

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); ">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="frmMAWBNO" id="frmMAWBNO" method="post" action="" onKeyDown="javascript:setChangeFlag();">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    Airline booking</td>
                <td width="50%" align="right" valign="middle">
                    <span class="bodyheader style11">FILE NO.</span><input name="txtJobNum" type="text"
                        class="lookup" size="22" value="Search Here" onClick="javascript: this.value=''; this.style.color='#000000'; "
                        onKeyPress="javascript: if(event.keyCode == 13) { LookupFile(); }"><img src="../images/icon_search.gif"
                            name="B1" width="33" height="27" align="absmiddle" onClick="LookupFile()" style="cursor: hand"></td>
            </tr>
        </table>
        <br />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            bgcolor="#997132" class="border1px">
            <tr>
                <td>
                    <input type="hidden" name="txtCarrierDesc" value="<%=vCarrierDesc%>">
                    <!--// by ig 7/11/2006 -->
                    <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>">
                    <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>">
                    <input type="hidden" name="FlagChanged" value="">
                    <!--// -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#F2DEBF">
                            <td height="24" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%" valign="middle">
                                            <img src="/ASP/Images/spacer.gif" width="70" height="5"><img src="/ASP/Images/spacer.gif"
                                                width="70" height="5">
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="bSaveClick()"
                                                style="cursor: hand" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="/ASP/domestic/booking.asp" target="_self">
                                                <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: hand"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                                onClick="bCloseClick()" style="cursor: hand" />
                                            <% if mode_begin then %>
                                            <div style="width: 21px; display: inline; vertical-align: text-bottom" onMouseOver="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns ?clean?.');"
                                                onMouseOut="hidetip()">
                                                <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                            <% end if %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9" bgcolor="#997132">
                            </td>
                        </tr>
                        <tr align="center">
                            <td valign="middle" bgcolor="f3f3f3" class="bodycopy">
                                <br>
                                <table width="650px" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="28" align="right">
                                            <span class="bodyheader">
                                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                    </tr>
                                </table>
                                <table width="650px" border="0" cellpadding="0" cellspacing="0" bordercolor="#997132"
                                    bgcolor="#FFFFFF" class="border1px">
                                    <tr bgcolor="#F2DEBF">
                                        <td width="1%" height="20" bgcolor="#f3d9a8">&nbsp;
                                        </td>
                                        <td width="34%" height="20" bgcolor="#f3d9a8">
                                            <strong class="bodyheader">Airline Carrier</strong></td>
                                        <td width="27%" height="20" bgcolor="#f3d9a8">&nbsp;
                                        </td>
                                        <td width="18%" height="20" bgcolor="#f3d9a8">&nbsp;
                                        </td>
                                        <td width="20%" height="20" bgcolor="#f3d9a8">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                        </td>
                                        <td height="20">
                                            <select name="lstCarrier" size="1" class="bodycopy" style="width: 200px">
                                                <% for i=0 to aIndex-1 %>
                                                <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>" <% if CarrierName(i) = vCarrierDesc then response.write("selected") %>>
                                                    <%= CarrierName(i) %>
                                                </option>
                                                <% next %>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left" valign="middle" class="bodycopy">
                                            <div>
                                                <input type="checkbox" name="chkAll" value="Y" <% if VchkAll="Y" then response.write("checked") %>>
                                                List up all Master AWB No.<% if mode_begin then %>
                                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onMouseOver="showtip('Checking this check box and clicking the Go button will list both unused and used MAWB numbers below, allowing you to edit or reuse old numbers.');"
                                                    onMouseOut="hidetip()">
                                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                                <% end if %>
                                            </div>
                                        </td>
                                        <td align="center" valign="middle">
                                            <img src="../images/button_go.gif" width="31" height="18" onClick="GoClick()" style="cursor: hand"></td>
                                    </tr>
                                </table>
                                <br>
                                <table width="650px" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132"
                                    class="border1px">
                                    <!-- duplicated function
					<tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                        <td width="1%" height="19">&nbsp;</td>
                        <td width="11%" class="bodycopy"><span class="bodyheader">MAWB No.</span></td>
                        <td width="43%"><span class="bodyheader">
                          <input name="txtSMAWB" type=text class="shorttextfield" size="19">
                          <font color="#333333" size="2"><strong><font size="2"><img src="../images/button_search.gif" name="B1" width="36" height="18" align="absmiddle" onClick="lookup()" ></font></strong></font></span></td>
                        <td width="9%">&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                      </tr>
					  -->
                                    <tr align="left" valign="middle" bgcolor="#F2DEBF" class="bodycopy">
                                        <td width="1%" height="20" bgcolor="#f3d9a8">&nbsp;                                        </td>
                                        <td width="16%" height="20" bgcolor="#f3d9a8" class="bodycopy">
                                            <img src="/ASP/Images/required.gif" align="absbottom"><strong><font color="c16b42">Master
                                                AWB No.</font></strong></td>
                                        <td width="12%" valign="middle" bgcolor="#f3d9a8">&nbsp;                                        </td>
                                        <td width="23%" bgcolor="#f3d9a8">&nbsp;</td>
                                        <td width="15%" bgcolor="#f3d9a8"><span class="style1">Booking Date</span></td>
                                        <td width="33%" bgcolor="#f3d9a8"><span class="style1">File No.</span>                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                        <td height="19">&nbsp;                                            </td>
                                        <td colspan="2" valign="top" class="bodycopy">
											<div style="margin-bottom:6px">
												<% if NOT vMAWB = "" And aFILEPrefix(0) = "EDIT" And vUsed = "N" then%>
													<input type="checkbox" id="chkReUseFileNo" name="chkReUseFileNo" style="margin-left: -4px" />Change Master AWB No.
												<% End If %>
											</div>
										
										
                                            <!-- //Start of Combobox// -->
                                            <%  iMoonDefaultValue = vMAWB %>
                                            <%  iMoonComboBoxName =  "lstMAWB" %>
                                            <%  iMoonComboBoxWidth =  "170px" %>

                                            <script language="javascript"> 
function <%=iMoonComboBoxName%>_OnChangePlus() { MAWBChange(); } 
// Add New 10/30/2006
function <%=iMoonComboBoxName%>_OnAddNewPlus(oText,oSelect,oDiv) 
{  
var s = oText.value;
while(s.indexOf("&") != -1) { s = s.replace('&','________');	}	
while(s.indexOf("'") != -1) { s = s.replace("'","^^^^^^^^");	}	

var sindex = document.all.lstCarrier.selectedIndex;
var p = '';

if ( sindex > 0 ) {
p = document.all.lstCarrier.item(sindex).innerText;
}

var s = oText.value;

var param =  'PostBack=false'+'&s=' + s + '&p=' + p + "&dome=DA" ;
popAddMAWB = showModalDialog("../Include/AddMAWB.asp?"+param,"AddMAWB","dialogWidth:450px; dialogHeight:180px; help:0; status:0; scroll:0;center:1;Sunken;");    

	if (popAddMAWB != '' && typeof(popAddMAWB) != 'undefined')
	{ 
		// Add New 10/30/2006 // unremark followings if you want to disable edit mode.
		///////////////////////////////////// 	
		//	oDiv.style.display = 'none'; 
		/////////////////////////////////////	
	
		var sMAWB = popAddMAWB.substring(0,popAddMAWB.indexOf("-"));

		while(sMAWB.indexOf("^") != -1) { sMAWB = sMAWB.replace('^','-'); }		
		var popAddMAWB = popAddMAWB.substring(popAddMAWB.indexOf("-")+1,popAddMAWB.length);

		var items = oSelect.options;
	
		for( var i = 0; i < items.length; i++ ) {
			var item = items[i];
			if( item.text.toLowerCase() == sMAWB.toLowerCase() ) {
				oSelect.selectedIndex = i;
				break;
			}
		}

		if ( i >= items.length || items.length == 1 )
		{
			var oOption = document.createElement("OPTION");
			oSelect.options.add(oOption,1);
			oOption.innerText = sMAWB;
			oOption.value = popAddMAWB;		
			oSelect.selectedIndex = 1;
		}
	
		oText.value = sMAWB;
		<%=iMoonComboBoxName%>_OnChangePlus();		
	}
	return true;	
}

                                            </script>

                                            <div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width: <%=iMoonComboBoxWidth%>;
                                                position: ; top: ; left: ; z-index: ;">
                                                <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text"
                                                    class="ComboBox" autocomplete="off" style="width: <%=iMoonComboBoxWidth%>; vertical-align: middle"
                                                    value="<%=iMoonDefaultValue%>" />
                                                <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                    left: -140px; width: 17px">
                                                    <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                        border="0" /></div>
                                            </div>
                                            <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                top: 0; left: 0; width: 17px">
                                                <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                    alt="Quick Add MAWB No." border="0" /></div>
                                            <!-- /End of Combobox/ -->
                                            <select name="lstMAWB" id="lstMAWB" listsize="20" class="ComboBox" style="width: 170px;
                                                display: none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                                <option>Select One</option>
                                                <% for i=0 to tIndex-1 %>
                                                <option value="<%= aMAWBCarrier(i) %>" <% if vMAWB=aMAWB(i) then response.write("selected") %>>
                                                    <%= aMAWBDISPLAY(i) %>                                                </option>
                                                <% next %>
                                            </select>
                                            <!-- /End of Combobox/ -->                                        </td>
                                        <td valign="top">&nbsp;</td>
                                        <td valign="top"><input name="txtBookingDate" type="text" class="m_shorttextfield " id="txtBookingDate"
                                                value="<%=ConvertAnyValue(booking_date,"Date" , Date) %>" size="14" preset="shortdate" /></td>
										<td valign="top"><% if NOT aFILEPrefix(0) = "NONE" and NOT aFILEPrefix(0) = "EDIT" then%>
                                            <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 80px" onChange="PrefixChange()">
                                                <% For i=0 To fIndex-1 %>
                                                <option value="<%= aNextFILE(i) %>" <% if vFILEPrefix=aFILEPrefix(i) then response.write("selected") %>> <%= aFILEPrefix(i) %> </option>
                                                <%  Next %>
                                            </select>
                                            <% end if %>
                                            <% if aFILEPrefix(0) = "NONE" then%>
                                            <input name='txtFileNo' id='txtFileNo' class='bodyheader' style='width: 110px' value='<%= vFileNo %>'
                                                size='20'>
                                            <% else %>
                                            <input name='txtFileNo' id='txtFileNo' class='readonlybold' style='width: 110px' value='<%= vFileNo %>'
                                                size='15' readonly='true'>
                                        <% end if%></td>
                                    </tr>
                                    <tr>
                                        <td colspan="6">
                                            <table class="bodycopy">
                                                <tr>
                                                    <td>
                                                        <% if NOT vMAWB = "" And aFILEPrefix(0) = "EDIT" then %>
                                                        <a href="javascript:goToMAWB();" class="goto">
                                                            <img src="/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom">Go
                                                            to MAWB</a>
                                                        <% end if %>                                                    </td>
                                                    <td width="15px">                                                    </td>
                                                    <td>                                                    </td>
                                                </tr>
                                            </table>                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                        <td height="2" colspan="6" bgcolor="#997132">                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                        <td height="18">&nbsp;                                            </td>
                                        <td colspan="2" class="bodyheader">
                                            Airport of Departure</td>
                                        <td>                                        </td>
                                        <td colspan="2">
                                            <span class="bodyheader">Airport of Destination</span></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#Ffffff">&nbsp;                                            </td>
                                        <td colspan="3" bgcolor="#FFFFFF">
                                            <select name="lstOriginPort" size="1" class="shorttextfield" style="width: 230px">
                                                <option value="">Select One</option>
                                                <% for i= 0 to pIndex-1 %>
                                                <option value="<%= PortCode(i) & "-" & PortID(i) & "-" & PortDesc(i) & "-" & PortState(i) & "-" & PortCountry(i) %>"
                                                    <% if vOriginPort=PortCode(i) Then response.write("selected") %>>
                                                    <%= PortCode(i) & "-" & PortDesc(i) %>                                                </option>
                                                <% next %>
                                            </select>                                        </td>
                                        <td colspan="2" bgcolor="#FFFFFF">
                                            <select name="lstDestPort" size="1" class="smallselect" style="width: 230px" onChange="DestPortChange()">
                                                <option value="">Select One</option>
                                                <% for i= 0 to pIndex-1 %>
                                                <option value="<%= PortCode(i) & "-" & PortID(i) & "-" & PortDesc(i) & "-" & PortCountry(i) & "-" & PortCountryCode(i) %>"
                                                    <% if vDestPort=PortCode(i) Then response.write("selected") %>>
                                                    <%= PortCode(i) & "-" & PortDesc(i) %>                                                </option>
                                                <% next %>
                                            </select>                                        </td>
                                        <tr bgcolor="#F3f3f3">
                                            <td height="18">&nbsp;                                                </td>
                                            <td bgcolor="#F3f3f3" class="bodyheader">
                                                <span class="style9">To</span></td>
                                            <td colspan="2" class="bodyheader">
                                                <span class="style9">By First Carrier</span></td>
                                            <td>
                                                <span class="style12">Service Level</span></td>
                                            <td valign="middle">
                                                <table id="TableS" border="0" align="left" <%if vserviceLevel="OTC (over the counter)" or vserviceLevel="NFO (next flight out)" or vserviceLevel="2nd Day" or vserviceLevel="" then %>style="visibility:hidden"
                                                    <%End If%>>
                                                    <tr>
                                                        <td style="height: 9px; width: 125px;">
                                                            <span style="font-size: 6pt">(if other, please describe)</span></td>
                                                    </tr>
                                                </table>                                            </td>
                                        </tr>
                                    <tr bgcolor="#Ffffff" style="color: #000000">
                                        <td>&nbsp;                                            </td>
                                        <td>
                                            <input name="txtTo" class="shorttextfield" value="<%= vTo %>" size="24"></td>
                                        <td colspan="2">
                                            <input type="hidden" name="hCarrierCode" value="<%=vCarrierCode %>" />
                                            <input name="txtBy" class="shorttextfield" maxlength="32" value="<%= vBy %>" size="24"></td>
                                        <td colspan="1">
                                            <select name="txtServiceLevel" id="txtServiceLevel" class="smallselect" onChange="txtServiceLevel2Change();">
                                                <option value="" <% if vServiceLevel="" Then response.write("selected") %>>Select One</option>
                                                <option value="OTC (over the counter)" <% if vServiceLevel="OTC (over the counter)" Then response.write("selected") %>>
                                                    OTC (over the counter)</option>
                                                <option value="NFO (next flight out)" <% if vServiceLevel="NFO (next flight out)" Then response.write("selected") %>>
                                                    NFO (next fight out) </option>
                                                <option value="2nd Day" <% if vServiceLevel="2nd Day" Then response.write("selected") %>>
                                                    2nd Day</option>
                                                <option value="Other" <% if not vServiceLevel="OTC (over the counter)" and  not vServiceLevel="NFO (next flight out)" and not vServiceLevel="2nd Day" and not vServiceLevel="" Then response.write("selected") %>>
                                                    Other</option>
                                            </select>                                        </td>
                                        <td colspan="1">
                                            <input name="txtServiceLevel2" type="text" class="shorttextfield date" id="txtServiceLevel2"
                                                value="<%=vServiceLevel2%>" size="20" preset="shortdate" <%if vserviceLevel="OTC (over the counter)" or vserviceLevel="NFO (next flight out)" or vserviceLevel="2nd Day" or vserviceLevel="" then %>style="visibility:hidden"
                                                <%End If%> /></td>
                                        <tr bgcolor="#F3f3f3" style="color: #000000">
                                            <td>&nbsp;                                                </td>
                                            <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                To</td>
                                            <td bgcolor="#F3f3f3" class="bodycopy">
                                                By</td>
                                            <td class="bodyheader">&nbsp;                                                </td>
                                            <td bgcolor="#F3f3f3" class="bodycopy">
                                                To</td>
                                            <td>
                                                By</td>
                                            <tr bgcolor="#Ffffff" style="color: #000000">
                                                <td>&nbsp;                                                    </td>
                                                <td>
                                                    <input name="txtTo1" class="shorttextfield" value="<%= vTo1 %>" size="24"></td>
                                                <td colspan="2">
                                                    <input name="txtBy1" maxlength="32" class="shorttextfield" value="<%= vBy1 %>" size="24"></td>
                                                <td>
                                                    <input name="txtTo2" class="shorttextfield" value="<%= vTo2 %>" size="24"></td>
                                                <td>
                                                    <input name="txtBy2" maxlength="32" class="shorttextfield" value="<%= vBy2 %>" size="24"></td>
                                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy" style="color: #000000">
                                                    <td>&nbsp;                                                        </td>
                                                    <td class="bodyheader">
                                                        Flight No. 1</td>
                                                    <td height="20" colspan="2" class="bodyheader">
                                                        <img src="/ASP/Images/required.gif" align="absbottom">Departure Date</td>
                                                    <td class="bodyheader">
                                                        <img src="/ASP/Images/required.gif" align="absbottom">Arrival Date</td>
                                                    <td>&nbsp;                                                        </td>
                                                </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="color: #000000">
                                        <td>&nbsp;                                            </td>
                                        <td class="bodycopy">
                                            <input name="txtFlight1" class="shorttextfield" maxLength="29" value="<%= vFlight1 %>" size="24"></td>
                                        <td colspan="2">
                                            <input name="txtDeptDate1" class="m_shorttextfield " preset="shortdate" value="<%= vDeptDate1 %>"
                                                size="20"></td>
                                        <td>
                                            <input name="txtArrivalDate1" class="m_shorttextfield " preset="shortdate" value="<%= vArrivalDate1 %>"
                                                size="20"></td>
                                        <td>&nbsp;                                            </td>
                                        <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy" style="color: #000000">
                                            <td height="20">&nbsp;                                                </td>
                                            <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                <span class="bodycopy">Flight No. 2</span></td>
                                            <td height="20" colspan="2" bgcolor="#F3f3f3" class="bodycopy">
                                                Departure Date</td>
                                            <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                Arrival Date</td>
                                            <td height="20" class="bodyheader">&nbsp;                                                </td>
                                            <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="color: #000000">
                                                <td>&nbsp;                                                    </td>
                                                <td class="bodycopy">
                                                    <input name="txtFlight2" class="shorttextfield" maxLength="29" value="<%= vFlight2 %>" size="24"></td>
                                                <td colspan="2">
                                                    <input name="txtDeptDate2" class="m_shorttextfield " preset="shortdate" value="<%= vDeptDate2 %>"
                                                        size="20"></td>
                                                <td>
                                                    <input name="txtArrivalDate2" class="m_shorttextfield " preset="shortdate" value="<%= vArrivalDate2 %>"
                                                        size="20"></td>
                                                <td>&nbsp;                                                    </td>
                                                <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy" style="color: #000000">
                                                    <td>&nbsp;                                                        </td>
                                                    <td class="bodyheader">
                                                        Weight Reserved (LB)                                                    </td>
                                                    <td height="20" colspan="2" class="bodyheader">
                                                        Pieces</td>
                                                    <td colspan="2" class="bodyheader">
                                                        Airline Reservation Staff</td>
                                                </tr>
                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="color: #000000">
                                        <td>&nbsp;                                            </td>
                                        <td class="bodycopy">
                                            <input name="txtWeightReserved" class="m_shorttextfield" maxlength="7" value="<%= vWeightReserved %>"
                                                size="24" style="behavior: url(../include/igNumChkRight.htc)"></td>
                                        <td colspan="2">
                                            <input name="txtPieces" class="m_shorttextfield" maxlength="6" value="<%=ConvertAnyValue(vPieces,"Long" , 0) %>"
                                                size="20" style="behavior: url(../include/igNumChkRight.htc)">
                                            <select style="visibility: hidden" name="lstWeightScale" size="1" class="smallselect">
                                                <option>LB</option>
                                                <option <% if vWeightScale="KG" Then response.write("selected") %>>KG</option>
                                            </select>                                        </td>
                                        <td colspan="2">
                                            <input name="txtAirLineStaff" type="text" class="shorttextfield" value="<%= vAirLineStaff %>"
                                                size="20"></td>
                                    </tr>
                                </table>
                                <br>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="color: #000000">
                <td height="1">
                </td>
            </tr>
            <tr style="color: #000000">
                <td height="24" align="center" bgcolor="#eec983">
                    <table width="98%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%" valign="middle">
                                <img src="/ASP/Images/spacer.gif" width="70" height="5"><img src="/ASP/Images/spacer.gif"
                                    width="70" height="5">
                            </td>
                            <td width="48%" align="center" valign="middle">
                                <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onClick="bSaveClick()"
                                    style="cursor: hand" /></td>
                            <td width="13%" align="right" valign="middle">
                                <a href="/ASP/domestic/booking.asp" target="_self">
                                    <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                        style="cursor: hand"></a></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                    onClick="bCloseClick()" style="cursor: hand" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>

<script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

<script language='javascript'>
    function goToMAWB() {
	    if(document.all.FlagChanged.value) {
		    var a = confirm("You did not save the changed information.\nDo you really want to call MAWB screen?");
		    if(!a) return false;
        }
        // Modified by Joon on Jan/30/2007
	    var form = document.getElementById("frmMAWBNO");
        var fileNo = document.getElementById("txtFileNo").value;    

        form.action="new_edit_mawb.asp?fBook=yes&Edit=yes&MAWB=" + "<%=vMAWB%>&FILE=" + fileNo;
        form.method="POST";
        form.target="_self";
        form.submit();
    }
    
    function MAWBChange(){
        var formObj = document.getElementById("frmMAWBNO");
        var chkObj = document.getElementById("chkReUseFileNo");
        
        if(chkObj == null || !chkObj.checked){
            var vMAWB = document.getElementById("lstMAWB_Text").value;
            if(vMAWB.indexOf("###") > 0){
                vMAWB = vMAWB.substring(0,vMAWB.indexOf("###"));
            }
            formObj.action = "booking.asp?Edit=yes&MAWB=" + encodeURIComponent(vMAWB);
            formObj.method = "POST";
            formObj.target = "_self";
            formObj.submit();
        }
        else{
            document.getElementById("txtBy").value = document.getElementById("lstMAWB").value;
        }
    }
</script>

<script type="text/vbscript">

<!---
// Add search function 7/11/2006

/////////////////////////////
Sub Lookup()    'never used (commented out)
/////////////////////////////
    DIM MAWB
	MAWB=document.frmMAWBNO.txtsMAWB.value

	if NOT TRIM(MAWB) = "" then
		document.frmMAWBNO.txtsMAWB.value = ""
		document.frmMAWBNO.action="booking.asp?Edit=yes&MAWB=" & MAWB
		document.frmMAWBNO.method="POST"
		document.frmMAWBNO.target = "_self"
		frmMAWBNO.submit()
	END IF

End Sub
</script>
<script type="text/javascript">
function LookupFile() {
    var FILENO = document.frmMAWBNO.txtJobNum.value;

	if (FILENO.trim() != "" && FILENO != "Search Here") {
	    document.frmMAWBNO.txtJobNum.value = "";
	    document.frmMAWBNO.action = "booking.asp?Edit=yes&FILENO=" + encodeURIComponent(FILENO);
	    document.frmMAWBNO.method = "POST";
	    document.frmMAWBNO.target = "_self";
	    frmMAWBNO.submit();
	}
    else
        alert("Please enter a File No!");
	
	
}
function bSaveClick() {
    var sindex=document.frmMAWBNO.lstMAWB.selectedIndex;
    var MAWB=document.frmMAWBNO.lstMAWB.item(sindex).text;

    if (document.frmMAWBNO.txtFileNo.value == "" ){
        alert("Please, preset file numbers and prefixes in prefix manager. \r\nYou can also manual enter a file number in this page.");
        return;
    }
	
    var pos=0;
    pos=MAWB.indexOf("###");

    if (pos>=0) 
        MAWB=MAWB.substring(0,pos);

    if (sindex>=0) {
	    var DeptDate1=document.frmMAWBNO.txtDeptDate1.value;
	    var ArrivalDate1=document.frmMAWBNO.txtArrivalDate1.value;
	    var DeptDate2=document.frmMAWBNO.txtDeptDate2.value;
	    var ArrivalDate2=document.frmMAWBNO.txtArrivalDate2.value;
	    var Weight=document.frmMAWBNO.txtWeightReserved.value;
	    var To0=document.frmMAWBNO.txtTo.value;
	    var To1=document.frmMAWBNO.txtTo1.value;
	    var To2=document.frmMAWBNO.txtTo2.value;
	    var Flight2=document.frmMAWBNO.txtFlight2.value;
	    if (Flight2!=""){
		    if (DeptDate2=="" || ArrivalDate2=="" ){
			    alert("Please enter Departure Date2 Or Arrival Date2!");
			    return;
		    }
	    }

	    if (To0.length > 3 || To1.length > 3 || To2.length > 3)
	        alert("The To Port has three characters!");
	    else if (!IsDate(DeptDate1))
	        alert("Please enter Departure Date in MM/DD/YYYY format!");
	    else if (!IsDate(ArrivalDate1))
	        alert("Please enter Arrival Date in MM/DD/YYYY format!");
	    else if (DeptDate2 != "" && !IsDate(DeptDate2))
	        alert("Please enter Departure Date in MM/DD/YYYY format!");
	    else if (ArrivalDate2 != "" && !IsDate(ArrivalDate2))
	        alert("Please enter Arrival Date in MM/DD/YYYY format!");
	    else {
	        document.frmMAWBNO.action = "booking.asp?save=yes&MAWB=" + encodeURIComponent(MAWB);
	        document.frmMAWBNO.method = "POST";
	        document.frmMAWBNO.target = "_self";
	        frmMAWBNO.submit();
	    }
    }
    else
	    alert("Please select a MAWB No.");
}


// by igMoon 07/10/2006 for File No.
function PrefixChange() {
    var sIndex = document.frmMAWBNO.lstFILEPrefix.selectedIndex;
    var Prefix = document.frmMAWBNO.lstFILEPrefix.item(sIndex).text;
    document.frmMAWBNO.hNEXTFILENo.value = document.frmMAWBNO.lstFILEPrefix.value;
    document.frmMAWBNO.txtFileNo.value = Prefix + "-" 
    + document.frmMAWBNO.lstFILEPrefix.value;
}

function GoClick() {
    var sindex = document.frmMAWBNO.lstCarrier.selectedIndex;
    var vCarrierDesc = "";
    if (sindex > 0)
        vCarrierDesc = document.frmMAWBNO.lstCarrier.item(sindex).text;

    document.frmMAWBNO.txtCarrierDesc.value = vCarrierDesc;
    document.frmMAWBNO.action = "booking.asp?go=yes";
    document.frmMAWBNO.method = "POST";
    document.frmMAWBNO.target = "_self";
    frmMAWBNO.submit();
}

function bCloseClick() {
    var sindex = document.frmMAWBNO.lstMAWB.selectedIndex;
    var MAWB = document.frmMAWBNO.lstMAWB.item(sindex).text;
    var pos = 0;
        pos = MAWB.indexOf("###");

    if (pos>=0 ) 
        MAWB=MAWB.SUBSTRING(0,pos);
    if (sindex > 0) {
        if (!confirm("Do you really want to close Airline Booking No. '" +MAWB+"' ? \r\nContinue?")) 
            return false;

	    document.frmMAWBNO.action="booking.asp?Close=yes&MAWB=" + encodeURIComponent(MAWB);
	    document.frmMAWBNO.method="POST";
	    document.frmMAWBNO.target="_self";
	    frmMAWBNO.submit();
    }
    else
        alert ("Please select a Master AWB No." );
}


function DestPortChange() {
    var sindex = document.frmMAWBNO.lstDestPort.selectedIndex;
     if (sindex > 0) {
        var DestPort = document.frmMAWBNO.lstDestPort.item(sindex).text;
        DestPort = DestPort.substring(0, 3);
        document.frmMAWBNO.txtTo.value = DestPort;
    }
}
</script>
<script type="text/vbscript">


Sub bSaveClick2() 'never used
    MAWB=document.frmMAWBNO.lstMAWB.item(sindex).Text
    if not MAWB ="" then
		    document.frmMAWBNO.action="booking.asp?save=yes&MAWB=" & MAWB
		    document.frmMAWBNO.method="POST"
		    document.frmMAWBNO.target="_self"
		    frmMAWBNO.submit()
    else
	    msgbox "Please select a MAWB No."
    end if
End Sub

Sub MenuMouseOver()
document.frmMAWBNO.lstCarrier.style.visibility="hidden"
document.frmMAWBNO.lstDestPort.style.visibility="hidden"
End Sub
Sub MenuMouseOut()
document.frmMAWBNO.lstCarrier.style.visibility="visible"
document.frmMAWBNO.lstDestPort.style.visibility="visible"
End Sub

</script>

<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
