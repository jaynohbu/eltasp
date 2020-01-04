<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Booking</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
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
.style9 {color: #000000}3/1/2007
.style10 {color: #517595}
.style11 {color: #663366}
a { 
	text-decoration: none;
}
img {
	border: none;
}
-->
</style>
    <!-- /Start of Combobox/ -->

    <script type="text/javascript">
<!-- 


var ComboBoxes =  new Array('lstMAWB');
// -->

    </script>

    <script type="text/jscript" src="../Include/iMoonCombo.js"></script>

    <!-- /End of Combobox/ -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%
'// Transaction Added By Joon on Oct,18 2007 /////////////////////////////////
eltConn.BeginTrans
'/////////////////////////////////////////////////////////////////////////////
Dim vMAWB, vCarrier,vCarrierDesc
Dim vFlightNo,vFileNo
Dim vOriginPort,vDestPort
Dim vTo,vBy,vTo1,vBy1,vTo2,vBy2
Dim vFlight1,vFlight2
Dim vDeptDate,vDeptTime,vArrivalDate,vArrivalTime
Dim vWeightReserved,vWeightScale
Dim Save,Go,booking_date
Dim aMAWBDisplay(),aMAWB(),aMAWBCarrier()
Dim rs, SQL

'// by ig 7/11/2006 for FILE No.
Dim aFILEPrefix(128),aNextFILE(128),fIndex,vFILEPrefix, rs2, FileNoForSearch

Save=Request.QueryString("Save")
Go=Request.QueryString("Go")
Edit=Request.QueryString("Edit")
Close=Request.QueryString("Close")
vMAWB=Request.QueryString("MAWB")
FileNoForSearch=Request.QueryString("FILENO")
vweightscale = GetSQLResult("SELECT uom FROM user_profile WHERE elt_account_number=" & elt_account_number, "uom")

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
	pos=instr(PortInfo,"^")
	if pos>0 then
		vOriginPort=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vOriginPortID=Left(PortInfo,pos-1)
		if vOriginPortID="" then vOriginPortID=0
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vOriginPortDesc=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vOriginPortState=Left(PortInfo,pos-1)
		vOriginPortCountry=Mid(PortInfo,pos+1,200)
	end if	
	PortInfo=Request("lstDestPort")
	pos=0
	pos=instr(PortInfo,"^")
	if pos>0 then
		vDestPort=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vDestPortID=Left(PortInfo,pos-1)
		if vDestPortID="" then vDestPortID=0
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vDestPortDesc=Left(PortInfo,pos-1)
		PortInfo=Mid(PortInfo,pos+1,200)
	end if
	pos=instr(PortInfo,"^")
	if pos>0 then
		vDestPortCountry=Left(PortInfo,pos-1)
		vDestPortCountryCode=Mid(PortInfo,pos+1,200)
	end if	
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
	vWeightScale=Left(Request("lstWeightScale"),1)
	vAirLineStaff=Request("txtAirLineStaff")
    booking_date = Request("txtBookingDate")
    
	if Save="yes" then
        SQL = "UPDATE mawb_number SET file#=NULL,status='A' where elt_account_number=" _
            & elt_account_number & " AND file#=N'" & vFileNo & "'"
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)

		SQL= "select * from mawb_number where elt_account_number = " & elt_account_number _
		    & " and (is_dome='N' or is_dome='') and mawb_no=N'" & vMAWB & "'"
		
		rs.Open SQL, eltConn, adOpenStatic, adLockPessimistic, adCmdText
		if Not rs.EOF then
			vFileNo = GET_FILE_NUMBER("AEJ", vFileNo, vMAWB )
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
			if Not vDeptDate2="" then
				rs("ETD_DATE2")=vDeptDate2
			end if
			rs("ETA_DATE1")=vArrivalDate1
			if Not vArrivalDate2="" then
				rs("ETA_DATE2")=vArrivalDate2
			end if
			rs("Weight_Reserved")=vWeightReserved
			rs("Weight_Scale")=vWeightScale
			rs("airline_staff")=vAirlineStaff
			rs("Status")="B"
			rs("booking_date")=booking_date
			rs("is_dome")="N"
			rs.Update
		end if
		rs.close	
		CALL UPDATE_USER_NEXT_NUMBER_IN_PREFIX( "AEJ", vFileNo )
		
'update hawb_master
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
		SQL=SQL & " dep_airport_code=N'" & vOriginPort & "'"
		SQL=SQl & ",departure_airport=N'" & Replace(vOriginPortDesc,"'","''") & "'"
		SQL=SQl & ",dest_airport=N'" & Replace(vDestPortDesc,"'","''") & "'"
		SQL=SQl & ",to_1=N'" & vTo & "'"
		SQL=SQl & ",by_1=N'" & vBy & "'"
		SQL=SQl & ",to_2=N'" & vTo1 & "'"
		SQL=SQl & ",by_2=N'" & vBy1 & "'"
		SQL=SQl & ",to_3=N'" & vTo2 & "'"
		SQL=SQl & ",by_3=N'" & vBy2 & "'"
		
		SQL=SQl & ",flight_date_1=N'" & vFlight1 & "/" & day(vDeptDate1) & "'"

		if Not vFlight2="" then
			SQL=SQL & ",flight_date_2=N'" & vFlight2 & "/" & day(vDeptDate2) & "'"
		else
			SQL=SQL & ",flight_date_2=N''"
		end if
		if Not vDeptDate1="" then
			SQL=SQL & ", export_date=N'" & vDeptDate1 & "'"
		end if
		SQL=SQL & ",dest_country=N'" & Replace(vDestPortCountry,"'","''") & "'"
		SQL=SQl & " where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'"
		
		
		eltConn.Execute SQL
'update mawb_master
		SQL= "update mawb_master set "
		SQL=SQL & " dep_airport_code=N'" & vOriginPort & "'"
		SQL=SQl & ",departure_airport=N'" & Replace(vOriginPortDesc,"'","''") & "'"
		SQL=SQl & ",dest_airport=N'" & Replace(vDestPortDesc,"'","''") & "'"
		SQL=SQl & ",to_1=N'" & vTo & "'"
		SQL=SQl & ",by_1=N'" & vBy & "'"
		SQL=SQl & ",to_2=N'" & vTo1 & "'"
		SQL=SQl & ",by_2=N'" & vBy1 & "'"
		SQL=SQl & ",to_3=N'" & vTo2 & "'"
		SQL=SQl & ",by_3=N'" & vBy2 & "'"
		SQL=SQl & ",flight_date_1=N'" & vFlight1 & "//" & day(vDeptDate1) & "'"
		if Not vFlight2="" then
			SQL=SQL & ",flight_date_2=N'" & vFlight2 & "//" & day(vDeptDate2) & "'"
		else
			SQL=SQL & ",flight_date_2=N''"
		end if
		SQL=SQL & ",dest_country=N'" & Replace(vDestPortCountry,"'","''") & "'"
		SQL=SQL & ",is_dome='N' " 
		SQL=SQl & " where elt_account_number=" & elt_account_number & " and mawb_num=N'" & vMAWB & "'"
		
		eltConn.Execute SQL

	end if

elseif Edit="yes" then
	
	if NOT FileNoForSearch = "" then
		SQL= "select * from mawb_number where elt_account_number = " & elt_account_number _
		    & " and (is_dome='N' or is_dome='') and replace(File#,'-','')=N'" & Replace(FileNoForSearch,"-","") & "'"
	else
		SQL= "select * from mawb_number where elt_account_number = " & elt_account_number _
		    & " and (is_dome='N' or is_dome='') and MAWB_No=N'" & vMAWB & "'"		
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
		vDeptDate1=rs("ETD_DATE1")
		vDeptDate2=rs("ETD_DATE2")
		vArrivalDate1=rs("ETA_DATE1")
		vArrivalDate2=rs("ETA_DATE2")
		vWeightReserved=rs("Weight_Reserved")
		vWeightScale=rs("Weight_Scale")
		vAirLineStaff=rs("airline_staff")
		booking_date=rs("booking_date")
		rs.Close
	else
		rs.Close
		if NOT FileNoForSearch = "" then
%>

<script type="text/jscript">alert('File # '+ '<%=FileNoForSearch%>' + ' does not exist.');</script>

<%		
			FileNoForSearch = ""
		else
			if vMAWB = "Select One" then
			else
%>

<script type="text/jscript">alert('MAWB # '+ '<%=vMAWB%>' + ' does not exist.');</script>

<%		
			end if
				vMAWB = ""
		end if	
	end if
elseif Close="yes" then
	SQL= "select * from mawb_number where elt_account_number = " & elt_account_number _
	    & " and (is_dome='N' or is_dome='') and mawb_no=N'" & vMAWB & "'"
    
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if not rs.EOF then
		rs("Status")="C"
	end if
	rs.Update
	rs.close
	vMAWB=""
end if

'get airline info
Dim CarrierName(1024),CarrierCode(1024),SCAC(1024)
SQL= "select dba_name,carrier_code,carrier_id from organization where elt_account_number = " _
    & elt_account_number & " and is_carrier='Y' and carrier_code <> '' order by dba_name"

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

'// GET PORT INFO
Dim PortCode(),PortID(),PortDesc(),PortState(),PortCountry(),PortCountryCode()
SQL= "select * from port where elt_account_number = " & elt_account_number & " order by port_desc"

rs.CursorLocation = adUseClient
rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
Set rs.activeConnection = Nothing

reDim PortCode(rs.RecordCount)
reDim PortID(rs.RecordCount)
reDim PortDesc(rs.RecordCount)
reDim PortState(rs.RecordCount)
reDim PortCountry(rs.RecordCount)
reDim PortCountryCode(rs.RecordCount)

pIndex = 0
Do While Not rs.EOF
	PortCode(pIndex) = rs("port_code")
	PortID(pIndex) = rs("port_id")
	PortDesc(pIndex) = rs("port_desc")
	PortState(pIndex) = rs("port_state")
	PortCountry(pIndex) = rs("port_country")
	PortCountryCode(pIndex) = rs("port_country_code")
	pIndex = pIndex + 1
	rs.MoveNext
Loop
rs.Close

	if VchkAll = "Y" then
		if vCarrierDesc = "" then
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='N' or is_dome='') and Status<>'C'" 
		else
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='N' or is_dome='') and Status<>'C' and carrier_desc = N'" & Replace(vCarrierDesc,"'","\'") & "'" 		
		end if
	else
		if vCarrierDesc = "" then
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='N' or is_dome='') and Status<>'C'  and used <> 'Y' " 
		else
			SQL= "select mawb_no,carrier_desc,used from mawb_number where elt_account_number = " & elt_account_number & " and (is_dome='N' or is_dome='') and Status<>'C'  and used <> 'Y' and carrier_desc = N'" & Replace(vCarrierDesc,"'","\'") & "'" 		
		end if
	end if

    
	Set rs = Server.CreateObject("ADODB.Recordset")
    rs.CursorLocation = adUseClient
    rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
    Set rs.activeConnection = Nothing

	tIndex = 0
	Count = rs.RecordCount
	
	ReDim aMAWBDisplay(Count)
	ReDim aMAWB(Count)
	ReDim aMAWBCarrier(Count)
	
	Do While Not rs.EOF
		aMAWB(tIndex) = rs("mawb_no")
		vUsed = rs("used")
		if vUsed = "Y" then
			aMAWBDISPLAY(tIndex) = aMAWB(tIndex) & "###" & "used"
		else
			aMAWBDISPLAY(tIndex) = aMAWB(tIndex)
		end if
		aMAWBCarrier(tIndex) = rs("carrier_desc")
		rs.MoveNext
		tIndex = tIndex + 1
	Loop
	rs.close
	
'////////////////////////////////////// by ig 07/09/2006 
CALL GET_FILE_PREFIX_FROM_USER_PROFILE( "AEJ" )
'////////////////////////////////////////////////////////

Set rs2=Nothing
Set rs=Nothing

if save = "yes" then 
	goMAWBOK = "yes"
else
	goMAWBOK = ""
end if

eltConn.CommitTrans
    
%>
<%

SUB UPDATE_USER_NEXT_NUMBER_IN_PREFIX( strType, tmpFileNo )
    
    DIM tmpNextNo,tPrefix,tmpNo

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

	SQL= "select * from user_prefix where elt_account_number=" & elt_account_number & " and type=N'" _
	    & strType & "' and prefix=N'" & tPrefix & "'"
	
	rs2.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	If Not rs2.EOF Then
	    tmpNo = ConvertAnyValue(tmpNextNo,"Long",0)
		if tmpNo >= ConvertAnyValue(rs2("next_no").Value,"Long",0) then
			rs2("next_no")=tmpNo+1
			rs2.Update
		end if
		for i=0 to fIndex
			if tPrefix=aFILEPrefix(i) then
				aNextFILE(i)=tmpNo+1
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
	SQL= "select * from mawb_number where elt_account_number = " & elt_account_number _
	    & " and (is_dome='N' or is_dome='') and File#=N'" & tmpFileNo & "' and mawb_no<>N'" & tmpMAWB & "'"
	
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

	SQL= "select prefix,next_no from user_prefix where elt_account_number = " & elt_account_number _
	    & " and type=N'"& strType & "' order by prefix"
	
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
%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0" onload="self.focus(); ">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="frmMAWBNO" id="frmMAWBNO" method="post" action="" onkeydown="javascript:setChangeFlag();">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    booking</td>
                <td width="50%" align="right" valign="middle">
                    <span class="bodyheader style11">FILE NO.</span><input name="txtJobNum" type="text"
                        class="lookup" size="22" value="Search Here" onkeydown="javascript: if(event.keyCode == 13) { lookupFile(); }"
                        onfocus="javascript: this.value = ''; this.style.color='#000000'; " tabindex="-1"><img
                            src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"
                            onfocus="lookupFile()" onclick="lookupFile()"></td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="A0829C">
            <tr>
                <td>
                    <input type="hidden" name="txtCarrierDesc" value="<%=vCarrierDesc%>">
                    <!--// by ig 7/11/2006 -->
                    <input type="hidden" name="hFILEPrefix" value="<%= vFILEPrefix %>">
                    <input type="hidden" name="hNEXTFILENo" value="<%= vNEXTFILENo %>">
                    <input type="hidden" name="FlagChanged" value="">
                    <!--// -->
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="A0829C"
                        bgcolor="#be99b9" class="border1px">
                        <tr>
                            <td>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                    <tr bgcolor="#e8d9e6">
                                        <td height="24" align="center" valign="middle" bgcolor="#e8d9e6" class="bodyheader">
                                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="26%" valign="middle">
                                                        <img src="/iff_main/ASP/Images/spacer.gif" width="70" height="5"><img src="/iff_main/ASP/Images/spacer.gif"
                                                            width="70" height="5">
                                                    </td>
                                                    <td width="48%" align="center" valign="middle">
                                                        <img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" onclick="bSaveClick()"
                                                            style="cursor: pointer" tabindex="-1" /></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <a href="/iff_main/ASP/air_export/booking.asp" target="_self" tabindex="-1">
                                                            <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                                style="cursor: pointer"></a></td>
                                                    <td width="13%" align="right" valign="middle">
                                                        <img src="../images/button_closebooking.gif" width="48" height="18" name="bClose"
                                                            onclick="bCloseClick()" style="cursor: pointer" tabindex="-1" alt="" />
                                                        <% if mode_begin then %>
                                                        <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Clicking this will close the current bill or booking. Closing it means it will still be saved in the system, but not accessible through the dropdowns on the Operations screen.  Often old bills that are very rarely accessed are closed to help keep the dropdowns clean.')"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="bottom" class="bodylistheader" alt="" /></div>
                                                        <% end if %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="9" bgcolor="#be99b9">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td valign="middle" bgcolor="f3f3f3" class="bodycopy">
                                            <br>
                                            <table width="75%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td height="28" align="right">
                                                        <span class="bodyheader">
                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</span></td>
                                                </tr>
                                            </table>
                                            <table width="75%" border="0" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
                                                bgcolor="#FFFFFF" class="border1px">
                                                <tr bgcolor="#e8d9e6">
                                                    <td width="1%" height="20">
                                                        &nbsp;
                                                    </td>
                                                    <td width="34%" height="20">
                                                        <strong class="bodyheader">Airline Carrier</strong></td>
                                                    <td width="27%" height="20">
                                                        &nbsp;
                                                    </td>
                                                    <td width="18%" height="20">
                                                        &nbsp;
                                                    </td>
                                                    <td width="20%" height="20">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                    <td height="20">
                                                        <select name="lstCarrier" size="1" class="bodycopy" style="width: 200px">
                                                            <% for i=0 to aIndex-1 %>
                                                            <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>" <% if carriername(i) = vcarrierdesc then response.write("selected") %>>
                                                                <%= CarrierName(i) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                    </td>
                                                    <td align="left" valign="middle" class="bodycopy">
                                                        <div>
                                                            <input type="checkbox" name="chkAll" value="Y" <% if vchkall="y" then response.write("checked") %>>
                                                            List up all Master AWB No.<% if mode_begin then %>
                                                            <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Checking this check box and clicking the Go button will list both unused and used MAWB numbers below, allowing you to edit or reuse old numbers.')"
                                                                onmouseout="hidetip()">
                                                                <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                                            <% end if %>
                                                        </div>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="image" src="../images/button_go.gif" onclick="GoClick(); return false;"
                                                            style="cursor: pointer"></td>
                                                </tr>
                                            </table>
                                            <br>
                                            <table width="75%" border="0" cellpadding="2" cellspacing="0" bordercolor="#A0829C"
                                                class="border1px">
                                                <!-- duplicated function
					<tr align="left" valign="middle" bgcolor="#f2ecf1" class="bodycopy">
                        <td width="1%" height="19">&nbsp;</td>
                        <td width="11%" class="bodycopy"><span class="bodyheader">MAWB No.</span></td>
                        <td width="43%"><span class="bodyheader">
                          <input name="txtSMAWB" type=text class="shorttextfield" tabindex=1 size="19">
                          <font color="#333333" size="2"><strong><font size="2"><img src="../images/button_search.gif" name="B1" width="36" height="18" align="absmiddle" onClick="lookup()" ></font></strong></font></span></td>
                        <td width="9%">&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                      </tr>
					  -->
                                                <tr align="left" valign="middle" bgcolor="#e8d9e6" class="bodycopy">
                                                    <td width="1%" height="20">
                                                        &nbsp;
                                                    </td>
                                                    <td width="22%" height="20" bgcolor="#e8d9e6" class="bodycopy">
                                                        <img src="/iff_main/ASP/Images/required.gif" align="absbottom"><strong><font color="c16b42">Master
                                                            AWB No.</font></strong></td>
                                                    <td width="15%" valign="middle">
                                                        &nbsp;
                                                    </td>
                                                    <td width="15%">
                                                        &nbsp;</td>
                                                    <td width="26%">
                                                        <span class="style1">File No.</span>
                                                    </td>
                                                    <td width="21%">
                                                        <span class="style1">Booking Date</span></td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                    <td height="19">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" valign="top" class="bodycopy">
                                                        <div style="margin-bottom: 6px">
                                                            <% if NOT vMAWB = "" And aFILEPrefix(0) = "EDIT" And vUsed = "N" then%>
                                                            <input type="checkbox" id="chkReUseFileNo" name="chkReUseFileNo" style="margin-left: -4px" />Change
                                                            Master AWB No.
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

var param =  'PostBack=false&s=' + encodeURIComponent(s) + '&p=' + encodeURIComponent(p) + "&dome=N" ;
popAddMAWB = showModalDialog("../Include/AddMAWB.asp?" + param, "modal","dialogWidth:450px; dialogHeight:180px; help:0; status:0; scroll:0;center:1;Sunken;");    

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
                                                                value="<%=iMoonDefaultValue%>" tabindex="-1" />
                                                            <div id="<%=iMoonComboBoxName%>_Div" style="display: none; position: absolute; top: 0;
                                                                left: 0; width: 17px">
                                                                <img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif"
                                                                    border="0" /></div>
                                                        </div>
                                                        <div id="<%=iMoonComboBoxName%>_NewDiv" style="display: none; position: absolute;
                                                            top: 0; left: 0; width: 17px">
                                                            <img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif"
                                                                alt="Quick Add MAWB No." border="0" /></div>
                                                        <!-- /End of Combobox/ -->
                                                        <select name="lstMAWB" id="lstMAWB" listsize="20" class="ComboBox" style="width: 170px;
                                                            display: none" onchange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                                                            <option value="">Select One</option>
                                                            <% for i=0 to tIndex-1 %>
                                                            <option value="<%= aMAWBCarrier(i) %>" <% if vmawb=amawb(i) then response.write("selected") %>>
                                                                <%= aMAWBDISPLAY(i) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                        <!-- /End of Combobox/ -->
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td valign="top">
                                                        <% if NOT aFILEPrefix(0) = "NONE" and NOT aFILEPrefix(0) = "EDIT" then%>
                                                        <select name="lstFILEPrefix" size="1" class="bodyheader" style="width: 80px" onchange="PrefixChange()">
                                                            <% For i=0 To fIndex-1 %>
                                                            <option value="<%= aNextFILE(i) %>" <% if vfileprefix=afileprefix(i) then response.write("selected") %>>
                                                                <%= aFILEPrefix(i) %>
                                                            </option>
                                                            <%  Next %>
                                                        </select>
                                                        <% end if %>
                                                        <% if aFILEPrefix(0) = "NONE" then%>
                                                        <input name='txtFileNo' class='bodyheader' style='width: 110px' value='<%= vFileNo %>'
                                                            size='20'>
                                                        <% else %>
                                                        <input name='txtFileNo' class='readonlybold' style='width: 90px' value='<%= vFileNo %>'
                                                            size='15' readonly="readonly">
                                                        <% end if%>
                                                    </td>
                                                    <td valign="top">
                                                        <input id="txtBookingDate" name="txtBookingDate" type="text" value="<%=ConvertAnyValue(booking_date,"Date",Date)%>"
                                                            class="m_shorttextfield" preset="shortdate" /></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="6">
                                                        <table class="bodycopy">
                                                            <tr>
                                                                <td>
                                                                    <% if NOT vMAWB = "" And aFILEPrefix(0) = "EDIT" then %>
                                                                    <a href="javascript:;" onclick="javascript:goToMAWB(); return false;" class="goto">
                                                                        <img src="/iff_main/ASP/Images/icon_goto.gif" width="36" height="21" align="absbottom" alt="" />Go
                                                                        to MAWB</a>
                                                                    <% end if %>
                                                                </td>
                                                                <td width="15px">
                                                                </td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    <td height="2" colspan="6" bgcolor="#be99b9">
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                                    <td height="18">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" class="bodyheader">
                                                        Airport of Departure</td>
                                                    <td>
                                                    </td>
                                                    <td colspan="2">
                                                        <span class="bodyheader">Airport of Destination</span></td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#Ffffff">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="3" bgcolor="#FFFFFF">
                                                        <select name="lstOriginPort" size="1" class="shorttextfield" style="width: 230px">
                                                            <option>Select One</option>
                                                            <% for i= 0 to pIndex-1 %>
                                                            <option value="<%= PortCode(i) & "^" & PortID(i) & "^" & PortDesc(i) & "^" & PortState(i) & "^" & PortCountry(i) %>"
                                                                <% if voriginport=portcode(i) then response.write("selected") %>>
                                                                <%= PortCode(i) & "-" & PortDesc(i) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                    </td>
                                                    <td colspan="2" bgcolor="#FFFFFF">
                                                        <select name="lstDestPort" size="1" class="smallselect" style="width: 230px" onchange="DestPortChange()">
                                                            <option value="">Select One</option>
                                                            <% for i= 0 to pIndex-1 %>
                                                            <option value="<%= PortCode(i) & "^" & PortID(i) & "^" & PortDesc(i) & "^" & PortCountry(i) & "^" & PortCountryCode(i) %>"
                                                                <% if vdestport=portcode(i) then response.write("selected") %>>
                                                                <%= PortCode(i) & "-" & PortDesc(i) %>
                                                            </option>
                                                            <% next %>
                                                        </select>
                                                    </td>
                                                    <tr bgcolor="#F3f3f3" class="bodyheader">
                                                        <td height="18">
                                                            &nbsp;
                                                        </td>
                                                        <td bgcolor="#F3f3f3">
                                                            <span class="style9">To</span></td>
                                                        <td colspan="2">
                                                            <span class="style9">By First Carrier</span></td>
                                                        <td>
                                                            &nbsp;
                                                        </td>
                                                        <td width="21%">
                                                            &nbsp;
                                                        </td>
                                                        <tr bgcolor="#Ffffff">
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                <input name="txtTo" class="m_shorttextfield" value="<%= vTo %>" size="8" maxlength="3"></td>
                                                            <td colspan="2">
                                                                <input name="txtBy" class="shorttextfield" value="<%= vBy %>" size="24"></td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <tr bgcolor="#F3f3f3">
                                                                <td>
                                                                    &nbsp;
                                                                </td>
                                                                <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                                    To</td>
                                                                <td bgcolor="#F3f3f3" class="bodycopy">
                                                                    By</td>
                                                                <td class="bodyheader">
                                                                    &nbsp;
                                                                </td>
                                                                <td bgcolor="#F3f3f3" class="bodycopy">
                                                                    To</td>
                                                                <td bgcolor="#F3f3f3" class="bodycopy">
                                                                    By</td>
                                                                <tr bgcolor="#Ffffff">
                                                                    <td>
                                                                        &nbsp;
                                                                    </td>
                                                                    <td>
                                                                        <input name="txtTo1" class="m_shorttextfield" value="<%= vTo1 %>" size="8" maxlength="3"></td>
                                                                    <td colspan="2">
                                                                        <input name="txtBy1" class="shorttextfield" value="<%= vBy1 %>" size="24"></td>
                                                                    <td>
                                                                        <input name="txtTo2" class="m_shorttextfield" value="<%= vTo2 %>" size="8" maxlength="3"></td>
                                                                    <td>
                                                                        <input name="txtBy2" class="shorttextfield" value="<%= vBy2 %>" size="24"></td>
                                                                    <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td class="bodyheader">
                                                                            Flight No. 1</td>
                                                                        <td height="20" colspan="2" class="bodyheader">
                                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Departure Date</td>
                                                                        <td class="bodyheader">
                                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Arrival Date</td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <td class="bodycopy">
                                                                            <input name="txtFlight1" class="shorttextfield" value="<%= vFlight1 %>" size="24"></td>
                                                                        <td colspan="2">
                                                                            <input name="txtDeptDate1" class="m_shorttextfield" preset="shortdate" value="<%= vDeptDate1 %>"
                                                                                size="20"></td>
                                                                        <td>
                                                                            <input name="txtArrivalDate1" class="m_shorttextfield" preset="shortdate" value="<%= vArrivalDate1 %>"
                                                                                size="20"></td>
                                                                        <td>
                                                                            &nbsp;
                                                                        </td>
                                                                        <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">
                                                                            <td height="20">
                                                                                &nbsp;
                                                                            </td>
                                                                            <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                                                <span class="bodycopy">Flight No. 2</span></td>
                                                                            <td height="20" colspan="2" bgcolor="#F3f3f3" class="bodycopy">
                                                                                Departure Date</td>
                                                                            <td height="20" bgcolor="#F3f3f3" class="bodycopy">
                                                                                Arrival Date</td>
                                                                            <td height="20" class="bodyheader">
                                                                                &nbsp;
                                                                            </td>
                                                                            <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td class="bodycopy">
                                                                                    <input name="txtFlight2" class="shorttextfield" value="<%= vFlight2 %>" size="24"></td>
                                                                                <td colspan="2">
                                                                                    <input name="txtDeptDate2" class="m_shorttextfield" preset="shortdate" value="<%= vDeptDate2 %>"
                                                                                        size="20"></td>
                                                                                <td>
                                                                                    <input name="txtArrivalDate2" class="m_shorttextfield" preset="shortdate" value="<%= vArrivalDate2 %>"
                                                                                        size="20"></td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <tr align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td class="bodyheader">
                                                                                        Weight Reserved</td>
                                                                                    <td height="20" colspan="2" class="bodyheader">
                                                                                        Weight Scale</td>
                                                                                    <td colspan="2" class="bodyheader">
                                                                                        Airline Reservation Staff</td>
                                                                                </tr>
                                                                                <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td class="bodycopy">
                                                                                        <input name="txtWeightReserved" class="shorttextfield" value="<%= vWeightReserved %>"
                                                                                            size="14" style="behavior: url(../include/igNumChkRight.htc)"></td>
                                                                                    <td colspan="2">
                                                                                        <select name="lstWeightScale" size="1" class="smallselect">
                                                                                            <option>LB</option>
                                                                                            <option <% if vweightscale="K" OR vweightscale="KG" then response.write("selected") %>>
                                                                                                KG</option>
                                                                                        </select>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input name="txtAirLineStaff" type="text" class="shorttextfield" value="<%= vAirLineStaff %>"
                                                                                            size="20"></td>
                                                                                    <td>
                                                                                        &nbsp;
                                                                                    </td>
                                                                                </tr>
                                            </table>
                                            <br>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr id="bottom_menu" align="center">
                            <td width="1" valign="top" bgcolor="#be99b9">
                                <img src="../images/spacer.gif" width="1" height="24"></td>
                            <td id="td_menu" width="100%" height="24" align="center" valign="middle" bgcolor="e8d9e6">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="26%" valign="middle">
                                            <img src="/iff_main/ASP/Images/spacer.gif" width="70" height="5"><img src="/iff_main/ASP/Images/spacer.gif"
                                                width="70" height="5">
                                        </td>
                                        <td width="48%" align="center" valign="middle">
                                            <input type="image" src="../images/button_save_medium.gif" width="46" height="18"
                                                name="bSave" onclick="bSaveClick(); return false;" style="cursor: pointer" /></td>
                                        <td width="13%" align="right" valign="middle">
                                            <a href="javascript: ;" target="_self">
                                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                                    style="cursor: pointer"></a></td>
                                        <td width="13%" align="right" valign="middle">
                                            <input type="image" src="../images/button_closebooking.gif" width="48" height="18"
                                                name="bClose" onclick="bCloseClick(); return false;" style="cursor: pointer" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td width="1" valign="top" bgcolor="#be99b9">
                                <img src="../images/spacer.gif" width="1" height="24"></td>
                        </tr>
                        <tr>
                            <td height="1" colspan="2" align="left" valign="top" bgcolor="be99b9">
                                <img src="../images/spacer.gif" width="250" height="1"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>

<script type="text/javascript" src="../ajaxFunctions/ajax.js"></script>

<script type="text/jscript">

    function goToMAWB() {
	    if(document.all.FlagChanged.value) {
		    var a = confirm("You did not save the changed information.\nDo you really want to call MAWB screen?");
		    if(!a) return false;
        }
        // Modified by Joon on Jan/30/2007
	    var form = document.getElementById("frmMAWBNO");
        var fileNo = document.getElementById("txtFileNo").value;    

        form.action = "new_edit_mawb.asp?fBook=yes&Edit=yes&MAWB=<%=Server.URLEncode(vMAWB) %>&FILE=<%=Server.URLEncode(vFileNo) %>&WindowName=<%=WindowName %>";
        form.method = "post";
        form.target = "_self";
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

<script language="vbscript">
<!---
// Add search function 7/11/2006

/////////////////////////////
Sub Lookup()
/////////////////////////////
	DIM MAWB
	MAWB=document.frmMAWBNO.txtsMAWB.value

	if NOT TRIM(MAWB) = "" then
		document.frmMAWBNO.txtsMAWB.value = ""
		document.frmMAWBNO.action="booking.asp?Edit=yes&MAWB=" & encodeURIComponent(MAWB)
		document.frmMAWBNO.method="POST"
		document.frmMAWBNO.target = "_self"
		frmMAWBNO.submit()
	END IF
End Sub

/////////////////////////////
Sub LookupFile()
/////////////////////////////
	DIM FILENO
	FILENO=document.frmMAWBNO.txtJobNum.value

	if NOT TRIM(FILENO) = "" and not FILENO = "Search Here" then
		document.frmMAWBNO.txtJobNum.value = ""
		document.frmMAWBNO.action="booking.asp?Edit=yes&FILENO=" & encodeURIComponent(FILENO)
		document.frmMAWBNO.method="POST"
		document.frmMAWBNO.target = "_self"
		frmMAWBNO.submit()
   	else
	    msgbox "Please enter a File No!"
	END IF
End Sub
////////////////////

Sub bsaveclick()
	sindex=Document.frmMAWBNO.lstMAWB.Selectedindex
	MAWB=document.frmMAWBNO.lstMAWB.item(sindex).Text
	
	If document.frmMAWBNO.txtFileNo.value = "" Then
	    MsgBox "Please, preset file numbers and prefixes in prefix manager. You can also manual enter it in this page."
	    Exit Sub
	End If
	
	pos=0
	pos=Instr(MAWB,"###")
	
	if pos>0 then MAWB=Mid(MAWB,1,pos-1)
	
	if sindex>0 then

		DeptDate1=document.frmMAWBNO.txtDeptDate1.Value
		ArrivalDate1=document.frmMAWBNO.txtArrivalDate1.Value
		DeptDate2=document.frmMAWBNO.txtDeptDate2.Value
		ArrivalDate2=document.frmMAWBNO.txtArrivalDate2.Value
		Weight=document.frmMAWBNO.txtWeightReserved.value
		To0=document.frmMAWBNO.txtTo.Value
		To1=document.frmMAWBNO.txtTo1.Value
		To2=document.frmMAWBNO.txtTo2.Value
		Flight2=document.frmMAWBNO.txtFlight2.Value
		if Not Flight2="" then
			if DeptDate2="" or ArrivalDate2="" then
				MsgBox "Please enter Departure Date2 Or Arrival Date2!"
				exit Sub
			end if
		end if

		if Len(To0)>3 or Len(To1)>3 or Len(To2)>3 then
			MsgBox "The To Port has three characters!"
		elseif IsDate(DeptDate1)=False then
			MsgBox "Please enter Departure Date in MM/DD/YYYY format!"
		elseif IsDate(ArrivalDate1)=False then
			MsgBox "Please enter Arrival Date in MM/DD/YYYY format!"
		elseif Not DeptDate2="" And IsDate(DeptDate2)=False then
			MsgBox "Please enter Departure Date in MM/DD/YYYY format!"
		elseif Not ArrivalDate2="" and IsDate(ArrivalDate2)=False then
			MsgBox "Please enter Arrival Date in MM/DD/YYYY format!"
		else
			document.frmMAWBNO.action="booking.asp?save=yes&MAWB=" & encodeURIComponent(MAWB)
			document.frmMAWBNO.method="POST"
			document.frmMAWBNO.target="_self"
			frmMAWBNO.submit()
		end if
	else
		msgbox "Please select a MAWB No."
	end if

End Sub

// by igMoon 07/10/2006 for File No.
Sub PrefixChange()
	sIndex = document.frmMAWBNO.lstFILEPrefix.selectedIndex
	Prefix = document.frmMAWBNO.lstFILEPrefix.item(sIndex).Text
	document.frmMAWBNO.hNEXTFILENo.value = document.frmMAWBNO.lstFILEPrefix.value
	document.frmMAWBNO.txtFileNo.value = Prefix & "-" & document.frmMAWBNO.lstFILEPrefix.value
End Sub
/////////////////////////////////////

Sub GoClick()
    sindex=Document.frmMAWBNO.lstCarrier.Selectedindex
	if sindex = 0 then
		vCarrierDesc = ""
	else
		vCarrierDesc=document.frmMAWBNO.lstCarrier.item(sindex).Text
	end if

	document.frmMAWBNO.txtCarrierDesc.Value=vCarrierDesc
	document.frmMAWBNO.action="booking.asp?go=yes"
	document.frmMAWBNO.method="POST"
	document.frmMAWBNO.target="_self"
	frmMAWBNO.submit()
End Sub

Sub bCloseclick()
	sindex=Document.frmMAWBNO.lstMAWB.Selectedindex
	MAWB=document.frmMAWBNO.lstMAWB.item(sindex).Text
	pos=0
	pos=Instr(MAWB,"###")
	
	if sindex>0 then
		document.frmMAWBNO.action="booking.asp?Close=yes&MAWB=" & encodeURIComponent(MAWB)
		document.frmMAWBNO.method="POST"
		document.frmMAWBNO.target="_self"
		frmMAWBNO.submit()
	end if
End Sub


Sub DestPortChange()
	sindex=document.frmMAWBNO.lstDestPort.selectedindex
	if sindex>0 then
		DestPort=document.frmMAWBNO.lstDestPort.item(sindex).Text
		DestPort=Mid(DestPort,1,3)
		document.frmMAWBNO.txtTo.Value=DestPort
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

--->
</script>

<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
